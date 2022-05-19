Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9432852D41F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiESNdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiESNd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:33:29 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167061180C;
        Thu, 19 May 2022 06:33:25 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L3rMH2N9yz67Ncp;
        Thu, 19 May 2022 21:30:19 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 19 May 2022 15:33:22 +0200
Message-ID: <7a5671cd-6bf3-9d17-ef17-ac9129386447@huawei.com>
Date:   Thu, 19 May 2022 16:33:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 15/15] samples/landlock: adds network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-16-konstantin.meskhidze@huawei.com>
 <179ac2ee-37ff-92da-c381-c2c716725045@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <179ac2ee-37ff-92da-c381-c2c716725045@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 12:19 PM, Mickaël Salaün пишет:
> 
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to
>> allow a sandoxer to bind/connect to a list of
>> particular ports restricting networks actions to
>> the rest of ports.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v4:
>> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
>> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
>> to insert TCP ports.
>> * Renames populate_ruleset() to populate_ruleset_fs().
>> * Adds populate_ruleset_net() and parse_port_num() helpers.
>> * Refactoring main() to support network sandboxing.
>>
>> ---
>>   samples/landlock/sandboxer.c | 105 +++++++++++++++++++++++++++++++----
>>   security/landlock/ruleset.h  |   4 +-
>>   2 files changed, 95 insertions(+), 14 deletions(-)
>>
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index 3e404e51ec64..4006c42eec1c 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
>> @@ -51,6 +51,8 @@ static inline int landlock_restrict_self(const int 
>> ruleset_fd,
>>
>>   #define ENV_FS_RO_NAME "LL_FS_RO"
>>   #define ENV_FS_RW_NAME "LL_FS_RW"
>> +#define ENV_TCP_BIND_NAME "LL_TCP_BIND"
>> +#define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
>>   #define ENV_PATH_TOKEN ":"
>>
>>   static int parse_path(char *env_path, const char ***const path_list)
>> @@ -71,6 +73,20 @@ static int parse_path(char *env_path, const char 
>> ***const path_list)
>>       return num_paths;
>>   }
>>
>> +static int parse_port_num(char *env_port)
>> +{
>> +    int i, num_ports = 0;
>> +
>> +    if (env_port) {
>> +        num_ports++;
>> +        for (i = 0; env_port[i]; i++) {
>> +            if (env_port[i] == ENV_PATH_TOKEN[0])
>> +                num_ports++;
>> +        }
>> +    }
>> +    return num_ports;
>> +}
>> +
>>   /* clang-format off */
>>
>>   #define ACCESS_FILE ( \
>> @@ -80,7 +96,7 @@ static int parse_path(char *env_path, const char 
>> ***const path_list)
>>
>>   /* clang-format on */
>>
>> -static int populate_ruleset(const char *const env_var, const int 
>> ruleset_fd,
>> +static int populate_ruleset_fs(const char *const env_var, const int 
>> ruleset_fd,
>>                   const __u64 allowed_access)
>>   {
>>       int num_paths, i, ret = 1;
>> @@ -142,6 +158,49 @@ static int populate_ruleset(const char *const 
>> env_var, const int ruleset_fd,
>>       return ret;
>>   }
>>
>> +static int populate_ruleset_net(const char *const env_var,
>> +                const int ruleset_fd,
>> +                const __u64 allowed_access)
>> +{
>> +    int num_ports, i, ret = 1;
>> +    char *env_port_name;
>> +    struct landlock_net_service_attr net_service = {
>> +        .allowed_access = 0,
>> +        .port = 0,
>> +    };
>> +
>> +    env_port_name = getenv(env_var);
>> +    if (!env_port_name) {
>> +        /* Prevents users to forget a setting. */
>> +        fprintf(stderr, "Missing environment variable %s\n", env_var);
>> +        return 1;
> 
> I think network ports should be optional to be able to test without that 
> (and not break compatibility). You can pass &ruleset_attr as argument to 
> update it accordingly:
> - without environment variable: no network restriction;
> - with empty environment variable: all connect (or bind) denied;
> - otherwise: only allow the listed ports.
> 
   Great. That makes sense. Cause anyway fs restrictions are major ones.
> 
>> +    }
>> +    env_port_name = strdup(env_port_name);
>> +    unsetenv(env_var);
>> +    num_ports = parse_port_num(env_port_name);
>> +
>> +    if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == 
>> NULL)) {
>> +        ret = 0;
>> +        goto out_free_name;
>> +    }
>> +
>> +    for (i = 0; i < num_ports; i++) {
>> +        net_service.allowed_access = allowed_access;
>> +        net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
>> +        if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +                    &net_service, 0)) {
>> +            fprintf(stderr, "Failed to update the ruleset with port 
>> \"%d\": %s\n",
>> +                    net_service.port, strerror(errno));
>> +            goto out_free_name;
>> +        }
>> +    }
>> +    ret = 0;
>> +
>> +out_free_name:
>> +    free(env_port_name);
>> +    return ret;
>> +}
>> +
>>   /* clang-format off */
>>
>>   #define ACCESS_FS_ROUGHLY_READ ( \
>> @@ -173,19 +232,24 @@ int main(const int argc, char *const argv[], 
>> char *const *const envp)
>>       char *const *cmd_argv;
>>       int ruleset_fd, abi;
>>       __u64 access_fs_ro = ACCESS_FS_ROUGHLY_READ,
>> -          access_fs_rw = ACCESS_FS_ROUGHLY_READ | 
>> ACCESS_FS_ROUGHLY_WRITE;
>> +          access_fs_rw = ACCESS_FS_ROUGHLY_READ | 
>> ACCESS_FS_ROUGHLY_WRITE,
>> +          access_net_tcp = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                    LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>       struct landlock_ruleset_attr ruleset_attr = {
>>           .handled_access_fs = access_fs_rw,
>> +        .handled_access_net = access_net_tcp,
>>       };
>>
>>       if (argc < 2) {
>>           fprintf(stderr,
>> -            "usage: %s=\"...\" %s=\"...\" %s <cmd> [args]...\n\n",
>> -            ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +            "usage: %s=\"...\" %s=\"...\" %s=\"...\" %s=\"...\"%s "
>> +            "<cmd> [args]...\n\n", ENV_FS_RO_NAME, ENV_FS_RW_NAME,
>> +            ENV_TCP_BIND_NAME, ENV_TCP_CONNECT_NAME, argv[0]);
>>           fprintf(stderr,
>>               "Launch a command in a restricted environment.\n\n");
>> -        fprintf(stderr, "Environment variables containing paths, "
>> -                "each separated by a colon:\n");
>> +        fprintf(stderr,
>> +            "Environment variables containing paths and ports "
>> +            "each separated by a colon:\n");
>>           fprintf(stderr,
>>               "* %s: list of paths allowed to be used in a read-only 
>> way.\n",
>>               ENV_FS_RO_NAME);
>> @@ -193,11 +257,19 @@ int main(const int argc, char *const argv[], 
>> char *const *const envp)
>>               "* %s: list of paths allowed to be used in a read-write 
>> way.\n",
>>               ENV_FS_RW_NAME);
>>           fprintf(stderr,
>> -            "\nexample:\n"
>> +            "* %s: list of ports allowed to bind (server).\n",
>> +            ENV_TCP_BIND_NAME);
>> +        fprintf(stderr,
>> +            "* %s: list of ports allowed to connect (client).\n",
>> +            ENV_TCP_CONNECT_NAME);
> 
> This is good and will be better with clang-format. ;)

   Yep. I will fix it. Thanks.
> 
>> +        fprintf(stderr, "\nexample:\n"
>>               "%s=\"/bin:/lib:/usr:/proc:/etc:/dev/urandom\" "
>>               "%s=\"/dev/null:/dev/full:/dev/zero:/dev/pts:/tmp\" "
>> +            "%s=\"15000:16000\" "
> 
> Bind ports example should reference unprivileged ports such as "9418" 
> (git, not well-known but OK).
> 
  Ok. I will change it
> 
>> +            "%s=\"10000:12000\" "
> 
> Connect ports example should reference well-known ports such as "80:443".
> 
   Ditto.
>>               "%s bash -i\n",
>> -            ENV_FS_RO_NAME, ENV_FS_RW_NAME, argv[0]);
>> +            ENV_FS_RO_NAME, ENV_FS_RW_NAME, ENV_TCP_BIND_NAME,
>> +            ENV_TCP_CONNECT_NAME, argv[0]);
>>           return 1;
>>       }
>>
>> @@ -234,16 +306,25 @@ int main(const int argc, char *const argv[], 
>> char *const *const envp)
>>
>>       ruleset_fd =
>>           landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 
>> 0);
>> +
> 
> Why?

   Oh. Sorry. My mistake. I will fix it as it was.
> 
> 
>>       if (ruleset_fd < 0) {
>>           perror("Failed to create a ruleset");
>>           return 1;
>>       }
>> -    if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +    if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro))
>>           goto err_close_ruleset;
>> -    }
> 
> Why? I know that checkpatch.pl prints a warning for that but I 
> delibirately chooe to use curly braces even for "if" statements with one 
> line because it is safer. This code may be copied/pasted and I'd like 
> others to avoid introducing goto-fail-like issues.
> 

  It was done just to reduce the number of checkpatch.pl warnings.
  If you want it to be formated in your way I will fix it.
> 
> 
>> -    if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +
>> +    if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw))
>>           goto err_close_ruleset;
>> -    }
>> +
>> +    if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
>> +                 LANDLOCK_ACCESS_NET_BIND_TCP))
> 
> So please use curly braces here too.

   Ok. No problems.
> 
>> +        goto err_close_ruleset;
>> +
>> +    if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
>> +                 LANDLOCK_ACCESS_NET_CONNECT_TCP))
>> +        goto err_close_ruleset;
>> +
>>       if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>>           perror("Failed to restrict privileges");
>>           goto err_close_ruleset;
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 916b30b31c06..e1ff40f238a6 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -19,7 +19,7 @@
>>   #include "limits.h"
>>   #include "object.h"
>>
>> -typedef u16 access_mask_t;
>> +typedef u32 access_mask_t;
> 
> What‽

   You are right. I will move this changes to another commit, related 
the kernel updates. I might have forgotten to rebase this change and 
left it in sandboxer patch. Thank you..
> 
> 
>>
>>   /* Makes sure all filesystem access rights can be stored. */
>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>> @@ -157,7 +157,7 @@ struct landlock_ruleset {
>>                * layers are set once and never changed for the
>>                * lifetime of the ruleset.
>>                */
>> -            u32 access_masks[];
>> +            access_mask_t access_masks[];
>>           };
>>       };
>>   };
>> -- 
>> 2.25.1
>>
> .
