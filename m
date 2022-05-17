Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2420D529DC7
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbiEQJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244813AbiEQJTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:19:53 -0400
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F51366AC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:19:44 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L2Vv24FYvzMqRvW;
        Tue, 17 May 2022 11:19:42 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4L2Vv20b6QzljsWP;
        Tue, 17 May 2022 11:19:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652779182;
        bh=ARidMCdDRKiuZ+BhOi1PjlacWARhCtG478EGH7ySFto=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=k24LU6krCXtTw2RfrmkPYrueXlTrxKJBWCJ7erp9H/AnIqi79Xj2fF4zmsh/aBijQ
         tptT0S+4ulKpuV9XYwgupIFfe93mh4pox7BEzBAuDYWiQFqsmuccnlPUGlg4uWXOFG
         +TA/m6drfCK5blQ2YUnmiqGEZ0yVHdGLxeohqJmo=
Message-ID: <179ac2ee-37ff-92da-c381-c2c716725045@digikod.net>
Date:   Tue, 17 May 2022 11:19:41 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-16-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 15/15] samples/landlock: adds network demo
In-Reply-To: <20220516152038.39594-16-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> This commit adds network demo. It's possible to
> allow a sandoxer to bind/connect to a list of
> particular ports restricting networks actions to
> the rest of ports.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v4:
> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
> to insert TCP ports.
> * Renames populate_ruleset() to populate_ruleset_fs().
> * Adds populate_ruleset_net() and parse_port_num() helpers.
> * Refactoring main() to support network sandboxing.
> 
> ---
>   samples/landlock/sandboxer.c | 105 +++++++++++++++++++++++++++++++----
>   security/landlock/ruleset.h  |   4 +-
>   2 files changed, 95 insertions(+), 14 deletions(-)
> 
> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index 3e404e51ec64..4006c42eec1c 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c
> @@ -51,6 +51,8 @@ static inline int landlock_restrict_self(const int ruleset_fd,
> 
>   #define ENV_FS_RO_NAME "LL_FS_RO"
>   #define ENV_FS_RW_NAME "LL_FS_RW"
> +#define ENV_TCP_BIND_NAME "LL_TCP_BIND"
> +#define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
>   #define ENV_PATH_TOKEN ":"
> 
>   static int parse_path(char *env_path, const char ***const path_list)
> @@ -71,6 +73,20 @@ static int parse_path(char *env_path, const char ***const path_list)
>   	return num_paths;
>   }
> 
> +static int parse_port_num(char *env_port)
> +{
> +	int i, num_ports = 0;
> +
> +	if (env_port) {
> +		num_ports++;
> +		for (i = 0; env_port[i]; i++) {
> +			if (env_port[i] == ENV_PATH_TOKEN[0])
> +				num_ports++;
> +		}
> +	}
> +	return num_ports;
> +}
> +
>   /* clang-format off */
> 
>   #define ACCESS_FILE ( \
> @@ -80,7 +96,7 @@ static int parse_path(char *env_path, const char ***const path_list)
> 
>   /* clang-format on */
> 
> -static int populate_ruleset(const char *const env_var, const int ruleset_fd,
> +static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
>   			    const __u64 allowed_access)
>   {
>   	int num_paths, i, ret = 1;
> @@ -142,6 +158,49 @@ static int populate_ruleset(const char *const env_var, const int ruleset_fd,
>   	return ret;
>   }
> 
> +static int populate_ruleset_net(const char *const env_var,
> +				const int ruleset_fd,
> +				const __u64 allowed_access)
> +{
> +	int num_ports, i, ret = 1;
> +	char *env_port_name;
> +	struct landlock_net_service_attr net_service = {
> +		.allowed_access = 0,
> +		.port = 0,
> +	};
> +
> +	env_port_name = getenv(env_var);
> +	if (!env_port_name) {
> +		/* Prevents users to forget a setting. */
> +		fprintf(stderr, "Missing environment variable %s\n", env_var);
> +		return 1;

I think network ports should be optional to be able to test without that 
(and not break compatibility). You can pass &ruleset_attr as argument to 
update it accordingly:
- without environment variable: no network restriction;
- with empty environment variable: all connect (or bind) denied;
- otherwise: only allow the listed ports.


> +	}
> +	env_port_name = strdup(env_port_name);
> +	unsetenv(env_var);
> +	num_ports = parse_port_num(env_port_name);
> +
> +	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
> +		ret = 0;
> +		goto out_free_name;
> +	}
> +
> +	for (i = 0; i < num_ports; i++) {
> +		net_service.allowed_access = allowed_access;
> +		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +					&net_service, 0)) {
> +			fprintf(stderr, "Failed to update the ruleset with port \"%d\": %s\n",
> +					net_service.port, strerror(errno));
> +			goto out_free_name;
> +		}
> +	}
> +	ret = 0;
> +
> +out_free_name:
> +	free(env_port_name);
> +	return ret;
> +}
> +
>   /* clang-format off */
> 
>   #define ACCESS_FS_ROUGHLY_READ ( \
> @@ -173,19 +232,24 @@ int main(const int argc, char *const argv[], char *const *const envp)
>   	char *const *cmd_argv;
>   	int ruleset_fd, abi;
>   	__u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
> -	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE;
> +	      access_fs_rw = ACCESS_FS_ROUGHLY_READ | ACCESS_FS_ROUGHLY_WRITE,
> +	      access_net_tcp = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					LANDLOCK_ACCESS_NET_CONNECT_TCP;
>   	struct landlock_ruleset_attr ruleset_attr = {
>   		.handled_access_fs = access_fs_rw,
> +		.handled_access_net = access_net_tcp,
>   	};
> 
>   	if (argc < 2) {
>   		fprintf(stderr,
> -			"usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
> -			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
> +			"usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
> +			"<cmd> [args]...\n\n", ENV_FS_RO_NAME, ENV_FS_RW_NAME,
> +			ENV_TCP_BIND_NAME, ENV_TCP_CONNECT_NAME, argv[0]);
>   		fprintf(stderr,
>   			"Launch a command in a restricted environment.\n\n");
> -		fprintf(stderr, "Environment variables containing paths, "
> -				"each separated by a colon:\n");
> +		fprintf(stderr,
> +			"Environment variables containing paths and ports "
> +			"each separated by a colon:\n");
>   		fprintf(stderr,
>   			"* %s: list of paths allowed to be used in a read-only way.\n",
>   			ENV_FS_RO_NAME);
> @@ -193,11 +257,19 @@ int main(const int argc, char *const argv[], char *const *const envp)
>   			"* %s: list of paths allowed to be used in a read-write way.\n",
>   			ENV_FS_RW_NAME);
>   		fprintf(stderr,
> -			"\nexample:\n"
> +			"* %s: list of ports allowed to bind (server).\n",
> +			ENV_TCP_BIND_NAME);
> +		fprintf(stderr,
> +			"* %s: list of ports allowed to connect (client).\n",
> +			ENV_TCP_CONNECT_NAME);

This is good and will be better with clang-format. ;)

> +		fprintf(stderr, "\nexample:\n"
>   			"%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
>   			"%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
> +			"%s=\"15000:16000\" "

Bind ports example should reference unprivileged ports such as "9418" 
(git, not well-known but OK).


> +			"%s=\"10000:12000\" "

Connect ports example should reference well-known ports such as "80:443".

>   			"%s bash -i\n",
> -			ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
> +			ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
> +			ENV_TCP_CONNECT_NAME, argv[0]);
>   		return 1;
>   	}
> 
> @@ -234,16 +306,25 @@ int main(const int argc, char *const argv[], char *const *const envp)
> 
>   	ruleset_fd =
>   		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +

Why?


>   	if (ruleset_fd < 0) {
>   		perror("Failed to create a ruleset");
>   		return 1;
>   	}
> -	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
> +	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro))
>   		goto err_close_ruleset;
> -	}

Why? I know that checkpatch.pl prints a warning for that but I 
delibirately chooe to use curly braces even for "if" statements with one 
line because it is safer. This code may be copied/pasted and I'd like 
others to avoid introducing goto-fail-like issues.



> -	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
> +
> +	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw))
>   		goto err_close_ruleset;
> -	}
> +
> +	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
> +				 LANDLOCK_ACCESS_NET_BIND_TCP))

So please use curly braces here too.

> +		goto err_close_ruleset;
> +
> +	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
> +				 LANDLOCK_ACCESS_NET_CONNECT_TCP))
> +		goto err_close_ruleset;
> +
>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>   		perror("Failed to restrict privileges");
>   		goto err_close_ruleset;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 916b30b31c06..e1ff40f238a6 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -19,7 +19,7 @@
>   #include "limits.h"
>   #include "object.h"
> 
> -typedef u16 access_mask_t;
> +typedef u32 access_mask_t;

What‽


> 
>   /* Makes sure all filesystem access rights can be stored. */
>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
> @@ -157,7 +157,7 @@ struct landlock_ruleset {
>   			 * layers are set once and never changed for the
>   			 * lifetime of the ruleset.
>   			 */
> -			u32 access_masks[];
> +			access_mask_t access_masks[];
>   		};
>   	};
>   };
> --
> 2.25.1
> 
