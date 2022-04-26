Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF750F644
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345535AbiDZIqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbiDZIp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:45:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F1438BF;
        Tue, 26 Apr 2022 01:36:14 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KnZqx13Dtz67K73;
        Tue, 26 Apr 2022 16:32:13 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:36:11 +0200
Message-ID: <e27593e5-0171-0d5c-6a96-f1549350747f@huawei.com>
Date:   Tue, 26 Apr 2022 11:36:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 09/15] landlock: TCP network hooks implementation
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-10-konstantin.meskhidze@huawei.com>
 <665c3677-d931-351a-b934-41267cd0355c@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <665c3677-d931-351a-b934-41267cd0355c@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/11/2022 7:24 PM, Mickaël Salaün пишет:
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>> Support of socket_bind() and socket_connect() hooks.
>> Its possible to restrict binding and connecting of TCP
>> types of sockets to particular ports. Its just basic idea
>> how Landlock could support network confinement.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Split commit.
>> * Add SECURITY_NETWORK in config.
>> * Add IS_ENABLED(CONFIG_INET) if a kernel has no INET configuration.
>> * Add hook_socket_bind and hook_socket_connect hooks.
>>
>> ---
>>   security/landlock/Kconfig    |   1 +
>>   security/landlock/Makefile   |   2 +-
>>   security/landlock/net.c      | 180 +++++++++++++++++++++++++++++++++++
>>   security/landlock/net.h      |  22 +++++
>>   security/landlock/ruleset.h  |   6 ++
>>   security/landlock/setup.c    |   2 +
>>   security/landlock/syscalls.c |  61 +++++++++++-
>>   7 files changed, 271 insertions(+), 3 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>
>> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
>> index 8e33c4e8ffb8..2741f97169a7 100644
>> --- a/security/landlock/Kconfig
>> +++ b/security/landlock/Kconfig
>> @@ -4,6 +4,7 @@ config SECURITY_LANDLOCK
>>       bool "Landlock support"
>>       depends on SECURITY && !ARCH_EPHEMERAL_INODES
>>       select SECURITY_PATH
>> +    select SECURITY_NETWORK
> 
> Nit: please move SECURITY_NETWORK before SECURITY_PATH (alphanumeric 
> order).

  I got it. Thanks
> 
> 
>>       help
>>         Landlock is a sandboxing mechanism that enables processes to 
>> restrict
>>         themselves (and their future children) by gradually enforcing
>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>> index 7bbd2f413b3e..afa44baaa83a 100644
>> --- a/security/landlock/Makefile
>> +++ b/security/landlock/Makefile
>> @@ -1,4 +1,4 @@
>>   obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>
>>   landlock-y := setup.o syscalls.o object.o ruleset.o \
>> -    cred.o ptrace.o fs.o
>> +    cred.o ptrace.o fs.o net.o
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> new file mode 100644
>> index 000000000000..7fbb857c39e2
>> --- /dev/null
>> +++ b/security/landlock/net.c
>> @@ -0,0 +1,180 @@
>> +// SPDX-License-Identifier: GPL-2.0
> 
> Others files are tagged with GPL-2.0-only (which means that GPL-3 is 
> excluded).
> 
  Ok. It's being refactored.
> 
>> +/*
>> + * Landlock LSM - Network management and hooks
>> + *
>> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
>> + * Author: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> I would like to avoid putting all authors in file headers (including 
> from moved or copied code), but keep it small with only the copyright 
> holders. All authors are part of the Git history, which is taken into 
> account by tools such as ./scripts/get_maintainer.pl so you'll be CCed 
> for relevant patches.
> 
> 
>> + *
> 
> nit: useless line
> 
  Yep. thanks.
>> + */
>> +
>> +#include <linux/in.h>
>> +#include <linux/net.h>
>> +#include <linux/socket.h>
>> +#include <net/ipv6.h>
>> +
>> +#include "cred.h"
>> +#include "limits.h"
>> +#include "net.h"
>> +
>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> +                 u16 port, u32 access_rights)
>> +{
>> +    int err;
>> +
>> +    /* Transforms relative access rights to absolute ones. */
>> +    access_rights |= LANDLOCK_MASK_ACCESS_NET &
>> +             ~landlock_get_net_access_mask(ruleset, 0);
>> +
>> +    mutex_lock(&ruleset->lock);
>> +    err = landlock_insert_rule(ruleset, NULL, (uintptr_t)port, 
>> access_rights,
> 
> Type casting should not be required, but you can add this instead just 
> before the landlock_insert_rule() call:
> BUILD_BUG_ON(sizeof(port) > sizeof(uintptr_t));
> 
  Ok. Thanks.
> 
>> +                   LANDLOCK_RULE_NET_SERVICE);
>> +    mutex_unlock(&ruleset->lock);
>> +
>> +    return err;
>> +}
>> +
>> +static int check_socket_access(const struct landlock_ruleset *const 
>> domain,
>> +                   u16 port, u32 access_request)
>> +{
>> +    bool allowed = false;
>> +    u64 layer_mask;
>> +    size_t i;
>> +
>> +    /* Make sure all layers can be checked. */
> 
> nit: Make*s* sure…
> 
  Sorry for typos. I will fix it.
> 
>> +    BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
>> +
>> +    if (WARN_ON_ONCE(!domain))
>> +        return 0;
>> +    if (WARN_ON_ONCE(domain->num_layers < 1))
>> +        return -EACCES;
>> +
>> +    /*
>> +     * Saves all layers handling a subset of requested
>> +     * socket access rules.
>> +     */
>> +    layer_mask = 0;
>> +    for (i = 0; i < domain->num_layers; i++) {
>> +        if (landlock_get_net_access_mask(domain, i) & access_request)
>> +            layer_mask |= BIT_ULL(i);
>> +    }
>> +    /* An access request not handled by the domain is allowed. */
>> +    if (layer_mask == 0)
>> +        return 0;
>> +
>> +    /*
>> +     * We need to walk through all the hierarchy to not miss any 
>> relevant
>> +     * restriction.
>> +     */
>> +    layer_mask = landlock_unmask_layers(domain, NULL, port,
>> +                        access_request, layer_mask,
>> +                        LANDLOCK_RULE_NET_SERVICE);
>> +    if (layer_mask == 0)
>> +        allowed = true;
>> +
>> +    return allowed ? 0 : -EACCES;
>> +}
>> +
>> +static int hook_socket_bind(struct socket *sock, struct sockaddr 
>> *address, int addrlen)
>> +{
>> +#if IS_ENABLED(CONFIG_INET)
>> +    short socket_type;
>> +    struct sockaddr_in *sockaddr;
>> +    struct sockaddr_in6 *sockaddr_ip6;
>> +    u16 port;
>> +    const struct landlock_ruleset *const dom = 
>> landlock_get_current_domain();
>> +
>> +    if (!dom)
>> +        return 0;
>> +
>> +    /* Check if the hook is AF_INET* socket's action */
>> +    if ((address->sa_family != AF_INET) && (address->sa_family != 
>> AF_INET6))
> 
> You also need to add CONFIG_IPV6 in 
> tools/testing/selftest/landlock/config and do similar IPv4 and IPv6 
> tests. I think it would be easier with variant tests (see 
> FIXTURE_VARIANT in ptrace_test.c) and appropriate socket helpers.
> 
> Using such test variants will also help for the UDP support. Please try 
> to make it easy to add (some) UDP tests with a new alternative when it 
> will be available to make your tests reusable.
> 
   Ok. I got it.
> 
>> +        return 0;
>> +
>> +    socket_type = sock->type;
>> +    /* Check if it's a TCP socket */
>> +    if (socket_type != SOCK_STREAM)
>> +        return 0;
>> +
>> +    /* Get port value in host byte order */
>> +    switch (address->sa_family) {
>> +    case AF_INET:
>> +        sockaddr = (struct sockaddr_in *)address;
>> +        port = ntohs(sockaddr->sin_port);
>> +        break;
>> +    case AF_INET6:
>> +        sockaddr_ip6 = (struct sockaddr_in6 *)address;
>> +        port = ntohs(sockaddr_ip6->sin6_port);
>> +        break;
>> +    }
>> +
>> +    return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_BIND_TCP);
>> +#else
>> +    return 0;
>> +#endif
>> +}
>> +
>> +static int hook_socket_connect(struct socket *sock, struct sockaddr 
>> *address, int addrlen)
>> +{
>> +#if IS_ENABLED(CONFIG_INET)
>> +    short socket_type;
>> +    struct sockaddr_in *sockaddr;
>> +    struct sockaddr_in6 *sockaddr_ip6;
>> +    u16 port;
>> +    const struct landlock_ruleset *const dom = 
>> landlock_get_current_domain();
>> +
>> +    if (!dom)
>> +        return 0;
>> +
>> +    /* Check if the hook is AF_INET* socket's action */
>> +    if ((address->sa_family != AF_INET) && (address->sa_family != 
>> AF_INET6)) {
>> +        /* Check if the socket_connect() hook has AF_UNSPEC flag*/
>> +        if (address->sa_family == AF_UNSPEC) {
>> +            u16 i;
>> +            /*
>> +             * If just in a layer a mask supports connect access,
>> +             * the socket_connect() hook with AF_UNSPEC family flag
>> +             * must be banned. This prevents from disconnecting already
>> +             * connected sockets.
>> +             */
>> +            for (i = 0; i < dom->num_layers; i++) {
>> +                if (landlock_get_net_access_mask(dom, i) &
>> +                            LANDLOCK_ACCESS_NET_CONNECT_TCP)
>> +                    return -EACCES;
>> +            }
>> +        }
>> +        return 0;
>> +    }
>> +
>> +    socket_type = sock->type;
>> +    /* Check if it's a TCP socket */
>> +    if (socket_type != SOCK_STREAM)
>> +        return 0;
>> +
>> +    /* Get port value in host byte order */
>> +    switch (address->sa_family) {
>> +    case AF_INET:
>> +        sockaddr = (struct sockaddr_in *)address;
>> +        port = ntohs(sockaddr->sin_port);
>> +        break;
>> +    case AF_INET6:
>> +        sockaddr_ip6 = (struct sockaddr_in6 *)address;
>> +        port = ntohs(sockaddr_ip6->sin6_port);
>> +        break;
>> +    }
>> +
>> +    return check_socket_access(dom, port, 
>> LANDLOCK_ACCESS_NET_CONNECT_TCP);
>> +#else
>> +    return 0;
>> +#endif
>> +}
>> +
>> +static struct security_hook_list landlock_hooks[] __lsm_ro_after_init 
>> = {
>> +    LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>> +    LSM_HOOK_INIT(socket_connect, hook_socket_connect),
>> +};
>> +
>> +__init void landlock_add_net_hooks(void)
>> +{
>> +    security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
>> +            LANDLOCK_NAME);
>> +}
>> diff --git a/security/landlock/net.h b/security/landlock/net.h
>> new file mode 100644
>> index 000000000000..345bdc1dc84f
>> --- /dev/null
>> +++ b/security/landlock/net.h
>> @@ -0,0 +1,22 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Landlock LSM - Network management and hooks
>> + *
>> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
>> + * Author: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> + *
>> + */
>> +
>> +#ifndef _SECURITY_LANDLOCK_NET_H
>> +#define _SECURITY_LANDLOCK_NET_H
>> +
>> +#include "common.h"
>> +#include "ruleset.h"
>> +#include "setup.h"
>> +
>> +__init void landlock_add_net_hooks(void);
>> +
>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> +                 u16 port, u32 access_hierarchy);
>> +
>> +#endif /* _SECURITY_LANDLOCK_NET_H */
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index abf3e09a65cd..74e9d3d26bd6 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -193,6 +193,12 @@ void landlock_set_fs_access_mask(struct 
>> landlock_ruleset *ruleset,
>>
>>   u32 landlock_get_fs_access_mask(const struct landlock_ruleset 
>> *ruleset, u16 mask_level);
>>
>> +void landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
>> +                  const struct landlock_access_mask *access_mask_set,
>> +                  u16 mask_level);
>> +
>> +u32 landlock_get_net_access_mask(const struct landlock_ruleset 
>> *ruleset, u16 mask_level);
> 
> These can be made static inline here.
> 
  Already done!
> 
>> +
>>   u64 landlock_unmask_layers(const struct landlock_ruleset *const domain,
>>                  const struct landlock_object *object_ptr,
>>                  const u16 port, const u32 access_request,
>> diff --git a/security/landlock/setup.c b/security/landlock/setup.c
>> index f8e8e980454c..8059dc0b47d3 100644
>> --- a/security/landlock/setup.c
>> +++ b/security/landlock/setup.c
>> @@ -14,6 +14,7 @@
>>   #include "fs.h"
>>   #include "ptrace.h"
>>   #include "setup.h"
>> +#include "net.h"
>>
>>   bool landlock_initialized __lsm_ro_after_init = false;
>>
>> @@ -28,6 +29,7 @@ static int __init landlock_init(void)
>>       landlock_add_cred_hooks();
>>       landlock_add_ptrace_hooks();
>>       landlock_add_fs_hooks();
>> +    landlock_add_net_hooks();
>>       landlock_initialized = true;
>>       pr_info("Up and running.\n");
>>       return 0;
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index b91455a19356..2d45ea94e6d2 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -29,6 +29,7 @@
>>   #include "cred.h"
>>   #include "fs.h"
>>   #include "limits.h"
>> +#include "net.h"
>>   #include "ruleset.h"
>>   #include "setup.h"
>>
>> @@ -73,7 +74,8 @@ static void build_check_abi(void)
>>   {
>>       struct landlock_ruleset_attr ruleset_attr;
>>       struct landlock_path_beneath_attr path_beneath_attr;
>> -    size_t ruleset_size, path_beneath_size;
>> +    struct landlock_net_service_attr net_service_attr;
>> +    size_t ruleset_size, path_beneath_size, net_service_size;
>>
>>       /*
>>        * For each user space ABI structures, first checks that there 
>> is no
>> @@ -89,6 +91,11 @@ static void build_check_abi(void)
>>       path_beneath_size += sizeof(path_beneath_attr.parent_fd);
>>       BUILD_BUG_ON(sizeof(path_beneath_attr) != path_beneath_size);
>>       BUILD_BUG_ON(sizeof(path_beneath_attr) != 12);
>> +
>> +    net_service_size = sizeof(net_service_attr.allowed_access);
>> +    net_service_size += sizeof(net_service_attr.port);
>> +    BUILD_BUG_ON(sizeof(net_service_attr) != net_service_size);
>> +    BUILD_BUG_ON(sizeof(net_service_attr) != 10);
>>   }
>>
>>   /* Ruleset handling */
>> @@ -311,7 +318,6 @@ static int add_rule_path_beneath(const int 
>> ruleset_fd, const void *const rule_at
>>        * Checks that allowed_access matches the @ruleset constraints
>>        * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>>        */
>> -
>>       if ((path_beneath_attr.allowed_access | 
>> landlock_get_fs_access_mask(ruleset, 0)) !=
>>                           landlock_get_fs_access_mask(ruleset, 0)) {
>>           err = -EINVAL;
>> @@ -333,6 +339,50 @@ static int add_rule_path_beneath(const int 
>> ruleset_fd, const void *const rule_at
>>       return err;
>>   }
>>
>> +static int add_rule_net_service(const int ruleset_fd, const void 
>> *const rule_attr)
> 
> 
> 
> Here is a patch for other changes:
> 
> * Clean up and factor out landlock_add_rule(2).
> * Only build network part if CONFIG_INET is set and make
>    landlock_add_rule(2) returns -EAFNOSUPPORT otherwise.
> * Use CONFIG_IPV6 ifdef.
> * Cosmetic fixes.
> * Add TODOs.
> ---
>   security/landlock/Makefile   |   4 +-
>   security/landlock/net.c      | 146 ++++++++++++++++++-----------------
>   security/landlock/net.h      |   9 +++
>   security/landlock/syscalls.c |  90 ++++++++++-----------
>   4 files changed, 126 insertions(+), 123 deletions(-)
> 
> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
> index afa44baaa83a..c2e116f2a299 100644
> --- a/security/landlock/Makefile
> +++ b/security/landlock/Makefile
> @@ -1,4 +1,6 @@
>   obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
> 
>   landlock-y := setup.o syscalls.o object.o ruleset.o \
> -    cred.o ptrace.o fs.o net.o
> +    cred.o ptrace.o fs.o
> +
> +landlock-$(CONFIG_INET) += net.o
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index 7fbb857c39e2..23dd842a4628 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -26,8 +26,8 @@ int landlock_append_net_rule(struct landlock_ruleset 
> *const ruleset,
>                ~landlock_get_net_access_mask(ruleset, 0);
> 
>       mutex_lock(&ruleset->lock);
> -    err = landlock_insert_rule(ruleset, NULL, (uintptr_t)port, 
> access_rights,
> -                   LANDLOCK_RULE_NET_SERVICE);
> +    err = landlock_insert_rule(ruleset, NULL, (uintptr_t)port,
> +            access_rights, LANDLOCK_RULE_NET_SERVICE);
>       mutex_unlock(&ruleset->lock);
> 
>       return err;
> @@ -65,107 +65,109 @@ static int check_socket_access(const struct 
> landlock_ruleset *const domain,
>        * We need to walk through all the hierarchy to not miss any relevant
>        * restriction.
>        */
> -    layer_mask = landlock_unmask_layers(domain, NULL, port,
> -                        access_request, layer_mask,
> -                        LANDLOCK_RULE_NET_SERVICE);
> +    layer_mask = landlock_unmask_layers(domain, NULL, port, 
> access_request,
> +            layer_mask, LANDLOCK_RULE_NET_SERVICE);
>       if (layer_mask == 0)
>           allowed = true;
> 
>       return allowed ? 0 : -EACCES;
>   }
> 
> -static int hook_socket_bind(struct socket *sock, struct sockaddr 
> *address, int addrlen)
> +static u16 get_port(const struct sockaddr *const address)
>   {
> -#if IS_ENABLED(CONFIG_INET)
> -    short socket_type;
> -    struct sockaddr_in *sockaddr;
> -    struct sockaddr_in6 *sockaddr_ip6;
> -    u16 port;
> -    const struct landlock_ruleset *const dom = 
> landlock_get_current_domain();
> +    /* Gets port value in host byte order. */
> +    switch (address->sa_family) {
> +    case AF_INET:
> +        const struct sockaddr_in *const sockaddr =
> +            (struct sockaddr_in *)address;
> 
> -    if (!dom)
> -        return 0;
> +        return ntohs(sockaddr->sin_port);
> +#if IS_ENABLED(CONFIG_IPV6)
> +    case AF_INET6:
> +        struct sockaddr_in6 *sockaddr_ip6 =
> +            (struct sockaddr_in6 *)address;
> 
> -    /* Check if the hook is AF_INET* socket's action */
> -    if ((address->sa_family != AF_INET) && (address->sa_family != 
> AF_INET6))
> +        return ntohs(sockaddr_ip6->sin6_port);
> +#endif
> +    /*
> +     * TODO: What about AF_UNSPEC and other values? Add tests for these
> +     * cases.
> +     */
> +    }
> +    WARN_ON_ONCE(1);
> +    return 0;
> +}
> +
> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
> +        int addrlen)
> +{
> +    const struct landlock_ruleset *const dom =
> +        landlock_get_current_domain();
> +
> +    if (!dom)
>           return 0;
> 
> -    socket_type = sock->type;
> -    /* Check if it's a TCP socket */
> -    if (socket_type != SOCK_STREAM)
> +    /* Checks if it is a TCP socket. */
> +    if (sock->type != SOCK_STREAM)
>           return 0;
> 
> -    /* Get port value in host byte order */
>       switch (address->sa_family) {
>       case AF_INET:
> -        sockaddr = (struct sockaddr_in *)address;
> -        port = ntohs(sockaddr->sin_port);
> -        break;
> +#if IS_ENABLED(CONFIG_IPV6)
>       case AF_INET6:
> -        sockaddr_ip6 = (struct sockaddr_in6 *)address;
> -        port = ntohs(sockaddr_ip6->sin6_port);
> -        break;
> -    }
> -
> -    return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_BIND_TCP);
> -#else
> -    return 0;
>   #endif
> +        /* TODO: Add tests with different source and destination ports. */
> +        return check_socket_access(dom, get_port(address),
> +                LANDLOCK_ACCESS_NET_BIND_TCP);
> +    default:
> +        /*
> +         * TODO: What about AF_UNSPEC and other values? Add tests for
> +         * these cases.
> +         */
> +        return 0;
> +    }
>   }
> 
> -static int hook_socket_connect(struct socket *sock, struct sockaddr 
> *address, int addrlen)
> +static int hook_socket_connect(struct socket *sock, struct sockaddr 
> *address,
> +        int addrlen)
>   {
> -#if IS_ENABLED(CONFIG_INET)
> -    short socket_type;
> -    struct sockaddr_in *sockaddr;
> -    struct sockaddr_in6 *sockaddr_ip6;
> -    u16 port;
> -    const struct landlock_ruleset *const dom = 
> landlock_get_current_domain();
> +    const struct landlock_ruleset *const dom =
> +        landlock_get_current_domain();
> 
>       if (!dom)
>           return 0;
> 
> -    /* Check if the hook is AF_INET* socket's action */
> -    if ((address->sa_family != AF_INET) && (address->sa_family != 
> AF_INET6)) {
> -        /* Check if the socket_connect() hook has AF_UNSPEC flag*/
> -        if (address->sa_family == AF_UNSPEC) {
> -            u16 i;
> -            /*
> -             * If just in a layer a mask supports connect access,
> -             * the socket_connect() hook with AF_UNSPEC family flag
> -             * must be banned. This prevents from disconnecting already
> -             * connected sockets.
> -             */
> -            for (i = 0; i < dom->num_layers; i++) {
> -                if (landlock_get_net_access_mask(dom, i) &
> -                            LANDLOCK_ACCESS_NET_CONNECT_TCP)
> -                    return -EACCES;
> -            }
> -        }
> -        return 0;
> -    }
> -
> -    socket_type = sock->type;
> -    /* Check if it's a TCP socket */
> -    if (socket_type != SOCK_STREAM)
> +    /* Checks if it is a TCP socket. */
> +    if (sock->type != SOCK_STREAM)
>           return 0;
> 
> -    /* Get port value in host byte order */
> +    /* Check if the hook is AF_INET* socket's action */
>       switch (address->sa_family) {
>       case AF_INET:
> -        sockaddr = (struct sockaddr_in *)address;
> -        port = ntohs(sockaddr->sin_port);
> -        break;
> +#if IS_ENABLED(CONFIG_IPV6)
>       case AF_INET6:
> -        sockaddr_ip6 = (struct sockaddr_in6 *)address;
> -        port = ntohs(sockaddr_ip6->sin6_port);
> -        break;
> +#endif
> +        /* TODO: Add tests with different source and destination ports. */
> +        return check_socket_access(dom, get_port(address),
> +                LANDLOCK_ACCESS_NET_CONNECT_TCP);
> +    case AF_UNSPEC:
> +        u16 i;
> +
> +        /*
> +         * If just in a layer a mask supports connect access,
> +         * the socket_connect() hook with AF_UNSPEC family flag
> +         * must be banned. This prevents from disconnecting already
> +         * connected sockets.
> +         */
> +        /* TODO: Add tests for this case, with UDP and TCP. */
> +        for (i = 0; i < dom->num_layers; i++) {
> +            if (landlock_get_net_access_mask(dom, i) &
> +                    LANDLOCK_ACCESS_NET_CONNECT_TCP)
> +                return -EACCES;
> +        }
>       }
> -
> -    return check_socket_access(dom, port, 
> LANDLOCK_ACCESS_NET_CONNECT_TCP);
> -#else
>       return 0;
> -#endif
> +
>   }
> 
>   static struct security_hook_list landlock_hooks[] __lsm_ro_after_init = {
> diff --git a/security/landlock/net.h b/security/landlock/net.h
> index 345bdc1dc84f..4cf32c89d352 100644
> --- a/security/landlock/net.h
> +++ b/security/landlock/net.h
> @@ -14,9 +14,18 @@
>   #include "ruleset.h"
>   #include "setup.h"
> 
> +#if IS_ENABLED(CONFIG_INET)
> +
>   __init void landlock_add_net_hooks(void);
> 
>   int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>                    u16 port, u32 access_hierarchy);
> 
> +#else /* IS_ENABLED(CONFIG_INET) */
> +
> +static inline void landlock_add_net_hooks(void)
> +{}
> +
> +#endif /* IS_ENABLED(CONFIG_INET) */
> +
>   #endif /* _SECURITY_LANDLOCK_NET_H */
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 2d45ea94e6d2..b8dcd981872e 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -288,12 +288,13 @@ static int get_path_from_fd(const s32 fd, struct 
> path *const path)
>       return err;
>   }
> 
> -static int add_rule_path_beneath(const int ruleset_fd, const void 
> *const rule_attr)
> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
> +        const void *const rule_attr)
>   {
>       struct landlock_path_beneath_attr path_beneath_attr;
>       struct path path;
> -    struct landlock_ruleset *ruleset;
>       int res, err;
> +    u32 mask;
> 
>       /* Copies raw user space buffer, only one type for now. */
>       res = copy_from_user(&path_beneath_attr, rule_attr,
> @@ -301,49 +302,39 @@ static int add_rule_path_beneath(const int 
> ruleset_fd, const void *const rule_at
>       if (res)
>           return -EFAULT;
> 
> -    /* Gets and checks the ruleset. */
> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
> -    if (IS_ERR(ruleset))
> -        return PTR_ERR(ruleset);
> -
>       /*
>        * Informs about useless rule: empty allowed_access (i.e. deny rules)
>        * are ignored in path walks.
>        */
> -    if (!path_beneath_attr.allowed_access) {
> -        err = -ENOMSG;
> -        goto out_put_ruleset;
> -    }
> +    if (!path_beneath_attr.allowed_access)
> +        return -ENOMSG;
>       /*
>        * Checks that allowed_access matches the @ruleset constraints
>        * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>        */
> -    if ((path_beneath_attr.allowed_access | 
> landlock_get_fs_access_mask(ruleset, 0)) !=
> -                        landlock_get_fs_access_mask(ruleset, 0)) {
> -        err = -EINVAL;
> -        goto out_put_ruleset;
> -    }
> +    mask = landlock_get_fs_access_mask(ruleset, 0);
> +    if ((path_beneath_attr.allowed_access | mask) != mask)
> +        return -EINVAL;
> 
>       /* Gets and checks the new rule. */
>       err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>       if (err)
> -        goto out_put_ruleset;
> +        return err;
> 
>       /* Imports the new rule. */
>       err = landlock_append_fs_rule(ruleset, &path,
>               path_beneath_attr.allowed_access);
>       path_put(&path);
> -
> -out_put_ruleset:
> -    landlock_put_ruleset(ruleset);
>       return err;
>   }
> 
> -static int add_rule_net_service(const int ruleset_fd, const void *const 
> rule_attr)
> +static int add_rule_net_service(struct landlock_ruleset *const ruleset,
> +        const void *const rule_attr)
>   {
> -    struct landlock_net_service_attr  net_service_attr;
> -    struct landlock_ruleset *ruleset;
> -    int res, err;
> +#if IS_ENABLED(CONFIG_INET)
> +    struct landlock_net_service_attr net_service_attr;
> +    int res;
> +    u32 mask;
> 
>       /* Copies raw user space buffer, only one type for now. */
>       res = copy_from_user(&net_service_attr, rule_attr,
> @@ -351,36 +342,28 @@ static int add_rule_net_service(const int 
> ruleset_fd, const void *const rule_att
>       if (res)
>           return -EFAULT;
> 
> -    /* Gets and checks the ruleset. */
> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
> -    if (IS_ERR(ruleset))
> -        return PTR_ERR(ruleset);
> -
>       /*
>        * Informs about useless rule: empty allowed_access (i.e. deny rules)
>        * are ignored by network actions
>        */
> -    if (!net_service_attr.allowed_access) {
> -        err = -ENOMSG;
> -        goto out_put_ruleset;
> -    }
> +    if (!net_service_attr.allowed_access)
> +        return -ENOMSG;
>       /*
>        * Checks that allowed_access matches the @ruleset constraints
>        * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>        */
> -    if ((net_service_attr.allowed_access | 
> landlock_get_net_access_mask(ruleset, 0)) !=
> -                           landlock_get_net_access_mask(ruleset, 0)) {
> -        err = -EINVAL;
> -        goto out_put_ruleset;
> -    }
> +    mask = landlock_get_net_access_mask(ruleset, 0);
> +    if ((net_service_attr.allowed_access | mask) != mask)
> +        return -EINVAL;
> 
>       /* Imports the new rule. */
> -    err = landlock_append_net_rule(ruleset, net_service_attr.port,
> +    return landlock_append_net_rule(ruleset, net_service_attr.port,
>                          net_service_attr.allowed_access);
> 
> -out_put_ruleset:
> -    landlock_put_ruleset(ruleset);
> -    return err;
> +#else /* IS_ENABLED(CONFIG_INET) */
> +
> +    return -EAFNOSUPPORT;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   }
> 
>   /**
> @@ -388,8 +371,8 @@ static int add_rule_net_service(const int 
> ruleset_fd, const void *const rule_att
>    *
>    * @ruleset_fd: File descriptor tied to the ruleset that should be 
> extended
>    *        with the new rule.
> - * @rule_type: Identify the structure type pointed to by @rule_attr (only
> - *             LANDLOCK_RULE_PATH_BENEATH for now).
> + * @rule_type: Identify the structure type pointed to by @rule_attr:
> + *             LANDLOCK_RULE_PATH_BENEATH or LANDLOCK_RULE_NET_SERVICE.
>    * @rule_attr: Pointer to a rule (only of type &struct
>    *             landlock_path_beneath_attr for now).
>    * @flags: Must be 0.
> @@ -400,6 +383,8 @@ static int add_rule_net_service(const int 
> ruleset_fd, const void *const rule_att
>    * Possible returned errors are:
>    *
>    * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at 
> boot time;
> + * - EAFNOSUPPORT: @rule_type is LANDLOCK_RULE_NET_SERVICE but TCP/IP 
> is not
> + *   supported by the running kernel;
>    * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
>    *   &landlock_path_beneath_attr.allowed_access is not a subset of the 
> rule's
>    *   accesses);
> @@ -416,6 +401,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
>           const int, ruleset_fd, const enum landlock_rule_type, rule_type,
>           const void __user *const, rule_attr, const __u32, flags)
>   {
> +    struct landlock_ruleset *ruleset;
>       int err;
> 
>       if (!landlock_initialized)
> @@ -425,20 +411,24 @@ SYSCALL_DEFINE4(landlock_add_rule,
>       if (flags)
>           return -EINVAL;
> 
> +    /* Gets and checks the ruleset. */
> +    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
> +    if (IS_ERR(ruleset))
> +        return PTR_ERR(ruleset);
> +
>       switch (rule_type) {
>       case LANDLOCK_RULE_PATH_BENEATH:
> -        err = add_rule_path_beneath(ruleset_fd, rule_attr);
> +        err = add_rule_path_beneath(ruleset, rule_attr);
>           break;
>       case LANDLOCK_RULE_NET_SERVICE:
> -#if IS_ENABLED(CONFIG_INET)
> -        err = add_rule_net_service(ruleset_fd, rule_attr);
> -#else
> -        err = -EOPNOTSUPP;
> -#endif
> +        err = add_rule_net_service(ruleset, rule_attr);
>           break;
>       default:
>           err = -EINVAL;
> +        break;
>       }
> +
> +    landlock_put_ruleset(ruleset);
>       return err;
>   }
> 
   Thanks for this patch. Im testing it.
