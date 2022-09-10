Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4680D5B48EE
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiIJVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIJVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:00:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29733114C;
        Sat, 10 Sep 2022 14:00:02 -0700 (PDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4w93csNz67LWc;
        Sun, 11 Sep 2022 04:58:49 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 23:00:00 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:59:59 +0100
Message-ID: <132e8423-adf5-3343-8a09-2d09719ff262@huawei.com>
Date:   Sat, 10 Sep 2022 23:59:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 17/18] samples/landlock: add network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-18-konstantin.meskhidze@huawei.com>
 <fe3bc928-14f8-5e2b-359e-9a87d6cf5b01@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <fe3bc928-14f8-5e2b-359e-9a87d6cf5b01@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:10 AM, Mickaël Salaün пишет:
> 
> On 29/08/2022 19:04, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to allow a sandboxer to
>> bind/connect to a list of particular ports restricting network
>> actions to the rest of ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * Removes network support if ABI < 3.
>> 
>> Changes since v5:
>> * Makes network ports sandboxing optional.
>> * Fixes some logic errors.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
>> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
>> to insert TCP ports.
>> * Renames populate_ruleset() to populate_ruleset_fs().
>> * Adds populate_ruleset_net() and parse_port_num() helpers.
>> * Refactors main() to support network sandboxing.
>> 
>> ---
>>   samples/landlock/sandboxer.c | 123 +++++++++++++++++++++++++++++++----
>>   1 file changed, 112 insertions(+), 11 deletions(-)
>> 
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index 771b6b10d519..7f88067534df 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
>> @@ -51,6 +51,8 @@ static inline int landlock_restrict_self(const int ruleset_fd,
>> 
>>   #define ENV_FS_RO_NAME "LL_FS_RO"
>>   #define ENV_FS_RW_NAME "LL_FS_RW"
>> +#define ENV_TCP_BIND_NAME "LL_TCP_BIND"
>> +#define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
>>   #define ENV_PATH_TOKEN ":"
>> 
>>   static int parse_path(char *env_path, const char ***const path_list)
>> @@ -71,6 +73,20 @@ static int parse_path(char *env_path, const char ***const path_list)
>>   	return num_paths;
>>   }
>> 
>> +static int parse_port_num(char *env_port)
>> +{
>> +	int i, num_ports = 0;
>> +
>> +	if (env_port) {
>> +		num_ports++;
>> +		for (i = 0; env_port[i]; i++) {
>> +			if (env_port[i] == ENV_PATH_TOKEN[0])
>> +				num_ports++;
>> +		}
>> +	}
>> +	return num_ports;
>> +}
>> +
>>   /* clang-format off */
>> 
>>   #define ACCESS_FILE ( \
>> @@ -81,8 +97,8 @@ static int parse_path(char *env_path, const char ***const path_list)
>> 
>>   /* clang-format on */
>> 
>> -static int populate_ruleset(const char *const env_var, const int ruleset_fd,
>> -			    const __u64 allowed_access)
>> +static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
>> +			       const __u64 allowed_access)
>>   {
>>   	int num_paths, i, ret = 1;
>>   	char *env_path_name;
>> @@ -143,6 +159,48 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
>>   	return ret;
>>   }
>> 
>> +static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>> +				const __u64 allowed_access)
>> +{
>> +	int num_ports, i, ret = 1;
>> +	char *env_port_name;
>> +	struct landlock_net_service_attr net_service = {
>> +		.allowed_access = 0,
>> +		.port = 0,
>> +	};
>> +
>> +	env_port_name = getenv(env_var);
>> +	if (!env_port_name) {
>> +		ret = 0;
>> +		goto out_free_name;
>> +	}
>> +	env_port_name = strdup(env_port_name);
>> +	unsetenv(env_var);
>> +	num_ports = parse_port_num(env_port_name);
>> +
>> +	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
>> +		ret = 0;
>> +		goto out_free_name;
>> +	}
>> +
>> +	for (i = 0; i < num_ports; i++) {
>> +		net_service.allowed_access = allowed_access;
>> +		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
>> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				      &net_service, 0)) {
>> +			fprintf(stderr,
>> +				"Failed to update the ruleset with port \"%d\": %s\n",
>> +				net_service.port, strerror(errno));
>> +			goto out_free_name;
>> +		}
>> +	}
>> +	ret = 0;
>> +
>> +out_free_name:
>> +	free(env_port_name);
>> +	return ret;
>> +}
>> +
>>   /* clang-format off */
>> 
>>   #define ACCESS_FS_ROUGHLY_READ ( \
>> @@ -171,32 +229,50 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   	const char *cmd_path;
>>   	char *const *cmd_argv;
>>   	int ruleset_fd, abi;
>> +	char *env_port_name;
>>   	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
>> -	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
>> +	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE,
>> +	      access_net_tcp = 0;
>>   	struct landlock_ruleset_attr ruleset_attr = {
>>   		.handled_access_fs = access_fs_rw,
>> +		.handled_access_net = access_net_tcp,
> 
> Please follow the same logic as for handled_access_fs: by default
> handles all accesses, then remove the ones that are not supported by the
> kernel, then remove the ones that are not explicitly set by users (by
> checking env_port_name).
> 
  So at the beginning there will be full network ruleset attribute 
supported:
  .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
                        LANDLOCK_ACCESS_NET_CONNECT_TCP;
  Correct?

> 
>>   	};
>> 
>>   	if (argc < 2) {
>>   		fprintf(stderr,
>> -			"usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
>> -			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
>> +			"<cmd> [args]...\n\n",
>> +			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> +			ENV_TCP_CONNECT_NAME, argv[0]);
>>   		fprintf(stderr,
>>   			"Launch a command in a restricted environment.\n\n");
>> -		fprintf(stderr, "Environment variables containing paths, "
>> -				"each separated by a colon:\n");
>> +		fprintf(stderr,
>> +			"Environment variables containing paths and ports "
>> +			"each separated by a colon:\n");
>>   		fprintf(stderr,
>>   			"* %s: list of paths allowed to be used in a read-only way.\n",
>>   			ENV_FS_RO_NAME);
>>   		fprintf(stderr,
>> -			"* %s: list of paths allowed to be used in a read-write way.\n",
>> +			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>>   			ENV_FS_RW_NAME);
>> +		fprintf(stderr,
>> +			"Environment variables containing ports are optional "
>> +			"and could be skipped.\n");
>> +		fprintf(stderr,
>> +			"* %s: list of ports allowed to bind (server).\n",
>> +			ENV_TCP_BIND_NAME);
>> +		fprintf(stderr,
>> +			"* %s: list of ports allowed to connect (client).\n",
>> +			ENV_TCP_CONNECT_NAME);
>>   		fprintf(stderr,
>>   			"\nexample:\n"
>>   			"%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
>>   			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>> +			"%s=\"9418\" "
>> +			"%s=\"80:443\" "
>>   			"%s bash -i\n",
>> -			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> +			ENV_TCP_CONNECT_NAME, argv[0]);
>>   		return 1;
>>   	}
>> 
>> @@ -224,15 +300,32 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   		}
>>   		return 1;
>>   	}
>> +
>> +	/* Adds optionally network bind() support. */
>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>> +	if (env_port_name) {
>> +		access_net_tcp |= LANDLOCK_ACCESS_NET_BIND_TCP;
>> +	}
>> +	/* Adds optionally network connect() support. */
>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>> +	if (env_port_name) {
>> +		access_net_tcp |= LANDLOCK_ACCESS_NET_CONNECT_TCP;
>> +	}
>> +	ruleset_attr.handled_access_net = access_net_tcp;
>> +
>>   	/* Best-effort security. */
>>   	switch (abi) {
>>   	case 1:
>>   		/* Removes LANDLOCK_ACCESS_FS_REFER for ABI < 2 */
>>   		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_REFER;
>> +		/* Removes network support for ABI < 2 */
>> +		ruleset_attr.handled_access_net = 0;
> 
> Same issue as for the documentation.

   So I need to add refactored code into documentation?
> 
> 
>>   		__attribute__((fallthrough));
>>   	case 2:
>>   		/* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>>   		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
>> +		/* Removes network support for ABI < 3 */
>> +		ruleset_attr.handled_access_net = 0;
>>   	}
>>   	access_fs_ro &= ruleset_attr.handled_access_fs;
>>   	access_fs_rw &= ruleset_attr.handled_access_fs;
>> @@ -243,10 +336,18 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   		perror("Failed to create a ruleset");
>>   		return 1;
>>   	}
>> -	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +		goto err_close_ruleset;
>> +	}
>> +	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +		goto err_close_ruleset;
>> +	}
>> +	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_BIND_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>> -	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>> --
>> 2.25.1
>> 
> .
