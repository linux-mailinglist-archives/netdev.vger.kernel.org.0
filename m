Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0165E440
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 04:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjAEDtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 22:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjAEDs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 22:48:56 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699AA574D2;
        Wed,  4 Jan 2023 19:46:28 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NnXQL4Rf0z6J6cN;
        Thu,  5 Jan 2023 11:44:10 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 5 Jan 2023 03:46:25 +0000
Message-ID: <94a8ef89-b59e-d218-77a1-bf2f9d4096c7@huawei.com>
Date:   Thu, 5 Jan 2023 06:46:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 11/12] samples/landlock: Add network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-12-konstantin.meskhidze@huawei.com>
 <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/16/2022 5:25 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to allow a sandboxer to
>> bind/connect to a list of particular ports restricting network
>> actions to the rest of ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Removes network support if ABI < 4.
>> * Removes network support if not set by a user.
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
>>   samples/landlock/sandboxer.c | 129 +++++++++++++++++++++++++++++++----
>>   1 file changed, 116 insertions(+), 13 deletions(-)
>> 
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index fd4237c64fb2..68582b0d7c85 100644
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
> 
> This is a bug because env_port_name is not allocated. This should simply
> return 0.
> 
> 
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
>> @@ -164,41 +222,63 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
>>   	LANDLOCK_ACCESS_FS_REFER | \
>>   	LANDLOCK_ACCESS_FS_TRUNCATE)
>> 
>> +#define ACCESS_NET_BIND_CONNECT ( \
>> +	LANDLOCK_ACCESS_NET_BIND_TCP | \
>> +	LANDLOCK_ACCESS_NET_CONNECT_TCP)
> 
> You can remove ACCESS_NET_BIND_CONNECT and make the underlying access
> rights explicit.
> 
> 
>> +
>>   /* clang-format on */
>> 
>> -#define LANDLOCK_ABI_LAST 3
>> +#define LANDLOCK_ABI_LAST 4
>> 
>>   int main(const int argc, char *const argv[], char *const *const envp)
>>   {
>>   	const char *cmd_path;
>>   	char *const *cmd_argv;
>>   	int ruleset_fd, abi;
>> +	char *env_port_name;
>>   	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
>> -	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
>> +	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE,
>> +	      access_net_tcp = ACCESS_NET_BIND_CONNECT;
>>   	struct landlock_ruleset_attr ruleset_attr = {
>>   		.handled_access_fs = access_fs_rw,
>> +		.handled_access_net = access_net_tcp,
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
>>   			"%s bash -i\n\n",
>> -			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> +			ENV_TCP_CONNECT_NAME, argv[0]);
>>   		fprintf(stderr,
>>   			"This sandboxer can use Landlock features "
>>   			"up to ABI version %d.\n",
>> @@ -240,7 +320,10 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   	case 2:
>>   		/* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>>   		ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
>> -
>> +		__attribute__((fallthrough));
>> +	case 3:
>> +		/* Removes network support for ABI < 4 */
>> +		ruleset_attr.handled_access_net &= ~ACCESS_NET_BIND_CONNECT;
> 
> You can check the TCP environment variables here and error out if one is
> set.
> 
> Please keep the newline here.
> 
> 
>>   		fprintf(stderr,
>>   			"Hint: You should update the running kernel "
>>   			"to leverage Landlock features "
>> @@ -259,16 +342,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   	access_fs_ro &= ruleset_attr.handled_access_fs;
>>   	access_fs_rw &= ruleset_attr.handled_access_fs;
>> 
>> +	/* Removes bind access attribute if not supported by a user. */
>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>> +	if (!env_port_name) {
> 
> You can move this logic at the populate_ruleset_net() call site and
> update this helper to not call getenv() twice for the same variable.

   But here I exclude ruleset attributes, not rule itself. It will break
   the logic: creating a ruleset then applying rules.
   I suggest to leave here as its.
> 
> 
>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_BIND_TCP;
>> +	}
>> +	/* Removes connect access attribute if not supported by a user. */
>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>> +	if (!env_port_name) {
>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>> +	}
>> +	ruleset_attr.handled_access_net &= access_net_tcp;
> 
> There is no need for access_net_tcp.
> 
>> +
>>   	ruleset_fd =
>>   		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>>   	if (ruleset_fd < 0) {
>>   		perror("Failed to create a ruleset");
>>   		return 1;
>>   	}
> 
> newline
> 
>> -	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +		goto err_close_ruleset;
>> +	}
>> +	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +		goto err_close_ruleset;
>> +	}
> 
> newline
> 
>> +	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_BIND_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>> -	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
> 
> newline
> 
>>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>> --
>> 2.25.1
>> 
> .
