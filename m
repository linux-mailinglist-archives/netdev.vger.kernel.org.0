Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFCE6E3A2B
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDPQMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDPQLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:11:53 -0400
Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [IPv6:2001:1600:3:17::42a9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D302698
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:11:46 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwDK2qHhzMqLlK;
        Sun, 16 Apr 2023 18:11:45 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwDJ0pfZzMppw8;
        Sun, 16 Apr 2023 18:11:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661505;
        bh=Cqx/PFbJgR9VY4brK/bQnZAyPIKlPuQBAx5Z6tXpj2s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Q6jn1BIeScxyK5CfYdsDuGZT0f7PTznNU+Vkc0e+2NSf/qn/HsrCV82zLu0rQX9Y/
         JhluXrNTXX73yUS0RrZ04aCcrKV1FFN951qQLQygputN34eh/1yqF/c9NmsChQTjLk
         ndRDQJzE2hr0dODKib0v+TvcWm258IUpIFj1+oq0=
Message-ID: <9147b444-dec4-52c3-c724-f19b3f842738@digikod.net>
Date:   Sun, 16 Apr 2023 18:11:49 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 09/13] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-10-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-10-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> This commit adds network rules support in the ruleset management
> helpers and the landlock_create_ruleset syscall.
> Refactor user space API to support network actions. Add new network
> access flags, network rule and network attributes. Increment Landlock
> ABI version. Expand access_masks_t to u32 to be sure network access
> rights can be stored. Implement socket_bind() and socket_connect()
> LSM hooks, which enable to restrict TCP socket binding and connection

"which enables to"


> to specific ports.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * Changes UAPI port field to __u64.
> * Moves shared code into check_socket_access().
> * Adds get_raw_handled_net_accesses() and
> get_current_net_domain() helpers.
> * Minor fixes.
> 
> Changes since v8:
> * Squashes commits.
> * Refactors commit message.
> * Changes UAPI port field to __be16.
> * Changes logic of bind/connect hooks with AF_UNSPEC families.
> * Adds address length checking.
> * Minor fixes.
> 
> Changes since v7:
> * Squashes commits.
> * Increments ABI version to 4.
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v6:
> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>    because it OR values.
> * Makes landlock_add_net_access_mask() more resilient incorrect values.
> * Refactors landlock_get_net_access_mask().
> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>    LANDLOCK_NUM_ACCESS_FS as value.
> * Updates access_masks_t to u32 to support network access actions.
> * Refactors landlock internal functions to support network actions with
>    landlock_key/key_type/id types.
> 
> Changes since v5:
> * Gets rid of partial revert from landlock_add_rule
> syscall.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors landlock_create_ruleset() - splits ruleset and
> masks checks.
> * Refactors landlock_create_ruleset() and landlock mask
> setters/getters to support two rule types.
> * Refactors landlock_add_rule syscall add_rule_path_beneath
> function by factoring out get_ruleset_from_fd() and
> landlock_put_ruleset().
> 
> Changes since v3:
> * Splits commit.
> * Adds network rule support for internal landlock functions.
> * Adds set_mask and get_mask for network.
> * Adds rb_root root_net_port.
> 
> ---
>   include/uapi/linux/landlock.h                |  49 +++++
>   security/landlock/Kconfig                    |   1 +
>   security/landlock/Makefile                   |   2 +
>   security/landlock/limits.h                   |   6 +-
>   security/landlock/net.c                      | 198 +++++++++++++++++++
>   security/landlock/net.h                      |  26 +++
>   security/landlock/ruleset.c                  |  52 ++++-
>   security/landlock/ruleset.h                  |  63 +++++-
>   security/landlock/setup.c                    |   2 +
>   security/landlock/syscalls.c                 |  72 ++++++-
>   tools/testing/selftests/landlock/base_test.c |   2 +-
>   11 files changed, 450 insertions(+), 23 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
> 
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index 81d09ef9aa50..09b70fb6a9a6 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>   	 * this access right.
>   	 */
>   	__u64 handled_access_fs;
> +
> +	/**
> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_net;
>   };
> 
>   /*
> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>   	 * landlock_path_beneath_attr .
>   	 */
>   	LANDLOCK_RULE_PATH_BENEATH = 1,
> +	/**
> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
> +	 * landlock_net_service_attr .
> +	 */
> +	LANDLOCK_RULE_NET_SERVICE = 2,
>   };
> 
>   /**
> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>   	 */
>   } __attribute__((packed));
> 
> +/**
> + * struct landlock_net_service_attr - TCP subnet definition
> + *
> + * Argument of sys_landlock_add_rule().
> + */
> +struct landlock_net_service_attr {
> +	/**
> +	 * @allowed_access: Bitmask of allowed access network for services
> +	 * (cf. `Network flags`_).
> +	 */
> +	__u64 allowed_access;
> +	/**
> +	 * @port: Network port.
> +	 */
> +	__u64 port;
> +
> +} __attribute__((packed));

You can remove the empty line and the packed attribute.


> +
>   /**
>    * DOC: fs_access
>    *
> @@ -189,4 +219,23 @@ struct landlock_path_beneath_attr {
>   #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>   /* clang-format on */
> 
> +/**
> + * DOC: net_access
> + *
> + * Network flags
> + * ~~~~~~~~~~~~~~~~
> + *
> + * These flags enable to restrict a sandboxed process to a set of network
> + * actions.
> + *
> + * TCP sockets with allowed actions:
> + *
> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
> + *   a remote port.
> + */
> +/* clang-format off */
> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> +/* clang-format on */
>   #endif /* _UAPI_LINUX_LANDLOCK_H */
> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
> index 8e33c4e8ffb8..10c099097533 100644
> --- a/security/landlock/Kconfig
> +++ b/security/landlock/Kconfig
> @@ -3,6 +3,7 @@
>   config SECURITY_LANDLOCK
>   	bool "Landlock support"
>   	depends on SECURITY && !ARCH_EPHEMERAL_INODES
> +	select SECURITY_NETWORK
>   	select SECURITY_PATH
>   	help
>   	  Landlock is a sandboxing mechanism that enables processes to restrict
> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
> index 7bbd2f413b3e..53d3c92ae22e 100644
> --- a/security/landlock/Makefile
> +++ b/security/landlock/Makefile
> @@ -2,3 +2,5 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
> 
>   landlock-y := setup.o syscalls.o object.o ruleset.o \
>   	cred.o ptrace.o fs.o
> +
> +landlock-$(CONFIG_INET) += net.o
> \ No newline at end of file
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index bafb3b8dc677..8a1a6463c64e 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -23,6 +23,10 @@
>   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>   #define LANDLOCK_SHIFT_ACCESS_FS	0
> 
> -/* clang-format on */
> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
> 
> +/* clang-format on */
>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> new file mode 100644
> index 000000000000..e19c339906e7
> --- /dev/null
> +++ b/security/landlock/net.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock LSM - Network management and hooks
> + *
> + * Copyright © 2022 Huawei Tech. Co., Ltd.
> + * Copyright © 2022 Microsoft Corporation
> + */
> +
> +#include <linux/in.h>
> +#include <linux/net.h>
> +#include <linux/socket.h>
> +#include <net/ipv6.h>
> +
> +#include "common.h"
> +#include "cred.h"
> +#include "limits.h"
> +#include "net.h"
> +#include "ruleset.h"
> +
> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
> +			     const u16 port, access_mask_t access_rights)
> +{
> +	int err;
> +	const struct landlock_id id = {
> +		.key.data = port,
> +		.type = LANDLOCK_KEY_NET_PORT,
> +	};
> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> +
> +	/* Transforms relative access rights to absolute ones. */
> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
> +			 ~landlock_get_net_access_mask(ruleset, 0);
> +
> +	mutex_lock(&ruleset->lock);
> +	err = landlock_insert_rule(ruleset, id, access_rights);
> +	mutex_unlock(&ruleset->lock);
> +
> +	return err;
> +}
> +
> +static access_mask_t
> +get_raw_handled_net_accesses(const struct landlock_ruleset *const domain)
> +{
> +	access_mask_t access_dom = 0;
> +	size_t layer_level;
> +
> +	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
> +		access_dom |= landlock_get_net_access_mask(domain, layer_level);
> +	return access_dom;
> +}
> +
> +static const struct landlock_ruleset *get_current_net_domain(void)
> +{
> +	const struct landlock_ruleset *const dom =
> +		landlock_get_current_domain();
> +
> +	if (!dom || !get_raw_handled_net_accesses(dom))
> +		return NULL;
> +
> +	return dom;
> +}
> +
> +static int check_addrlen(const struct sockaddr *const address, int addrlen)
> +{
> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
> +		return -EINVAL;
> +	switch (address->sa_family) {
> +	case AF_UNSPEC:
> +	case AF_INET:
> +		if (addrlen < sizeof(struct sockaddr_in))
> +			return -EINVAL;
> +		return 0;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return -EINVAL;
> +		return 0;
> +#endif
> +	}
> +	WARN_ON_ONCE(1);
> +	return 0;

With this code, using any non-TCP socket would print a warning.

All these switch/case make difficult to check consistency across 
check_addrlen() and get_port() helpers, they should be inlined into 
check_socket_access(), with only one switch statement, but we need to be 
careful about the return error orders: first EINVAL and after 
EAFNOSUPPORT. Inlining all this also enables to get rid of impossible 
cases (that lead to these WARN_ON_ONCE calls).



> +}
> +
> +static u16 get_port(const struct sockaddr *const address)
> +{
> +	/* Gets port value in host byte order. */
> +	switch (address->sa_family) {
> +	case AF_UNSPEC:
> +	case AF_INET: {
> +		const struct sockaddr_in *const sockaddr =
> +			(struct sockaddr_in *)address;
> +		return ntohs(sockaddr->sin_port);
> +	}
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6: {
> +		const struct sockaddr_in6 *const sockaddr_ip6 =
> +			(struct sockaddr_in6 *)address;
> +		return ntohs(sockaddr_ip6->sin6_port);
> +	}
> +#endif
> +	}
> +	WARN_ON_ONCE(1);
> +	return 0;
> +}
> +
> +static int check_socket_access(struct socket *sock, struct sockaddr *address, int addrlen, u16 port,
> +			       access_mask_t access_request)
> +{
> +	int ret;
> +	bool allowed = false;
> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
> +	const struct landlock_rule *rule;
> +	access_mask_t handled_access;
> +	const struct landlock_id id = {
> +		.key.data = port,
> +		.type = LANDLOCK_KEY_NET_PORT,
> +	};
> +	const struct landlock_ruleset *const domain = get_current_net_domain();
> +
> +	if (WARN_ON_ONCE(!domain))
> +		return 0;
> +	if (WARN_ON_ONCE(domain->num_layers < 1))
> +		return -EACCES;
> +	/* Check if it's a TCP socket. */
> +	if (sock->type != SOCK_STREAM)
> +		return 0;
> +
> +	ret = check_addrlen(address, addrlen);
> +	if (ret)
> +		return ret;

As explained above, this should be replaced with:

if (addrlen < offsetofend(struct sockaddr, sa_family))
	return -EINVAL;


> +
> +	switch (address->sa_family) {


This below block should be moved after the generic switch statement 
(i.e. once port is checked).



> +	case AF_UNSPEC:
> +		/*
> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
> +		 * association, which have the same effect as closing the
> +		 * connection while retaining the socket object (i.e., the file
> +		 * descriptor).  As for dropping privileges, closing
> +		 * connections is always allowed.
> +		 */
> +		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
> +			return 0;
> +
> +		/*
> +		 * For compatibility reason, accept AF_UNSPEC for bind
> +		 * accesses (mapped to AF_INET) only if the address is
> +		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
> +		 * required to not wrongfully return -EACCES instead of
> +		 * -EAFNOSUPPORT.
> +		 */
> +		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
> +			const struct sockaddr_in *const sockaddr =
> +				(struct sockaddr_in *)address;
> +
> +			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
> +				return -EAFNOSUPPORT;
> +		}
> +
> +		fallthrough;



case AF_UNSPEC:

> +	case AF_INET:

if (addrlen < sizeof(struct sockaddr_in))
	return -EINVAL;

port = ((struct sockaddr_in *)address)->sin_port;
break;


> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:

if (addrlen < SIN6_LEN_RFC2133)
	return -EINVAL;

port = ((struct sockaddr_in6 *)address)->sin6_port;
break;


> +#endif

/* Allows unhandled protocols. */
default:
	return 0;
}

if (address->sa_family == AF_UNSPEC) {

// Add here the above AF_UNSPEC checks to be consistent with the 
EINVAL/EAFNOSUPPORT return ordering.

}

id.key.data = (__force uintprt_t)port;
BUID_BUG_ON(...);



> +		rule = landlock_find_rule(domain, id);
> +		handled_access = landlock_init_layer_masks(
> +			domain, access_request, &layer_masks,
> +			LANDLOCK_KEY_NET_PORT);
> +		allowed = landlock_unmask_layers(rule, handled_access,
> +						 &layer_masks,
> +						 ARRAY_SIZE(layer_masks));
> +	}

This curly brace can now be removed and the following return line is now OK.


> +	return allowed ? 0 : -EACCES;
> +}
> +
> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
> +			    int addrlen)
> +{
> +	return check_socket_access(sock, address, addrlen, get_port(address),
> +				   LANDLOCK_ACCESS_NET_BIND_TCP);
> +}
> +
> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
> +			       int addrlen)
> +{
> +	return check_socket_access(sock, address, addrlen, get_port(address),
> +				   LANDLOCK_ACCESS_NET_CONNECT_TCP);
> +}
> +
> +static struct security_hook_list landlock_hooks[] __lsm_ro_after_init = {
> +	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
> +	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> +};
> +
> +__init void landlock_add_net_hooks(void)
> +{
> +	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
> +			   LANDLOCK_NAME);
> +}
> diff --git a/security/landlock/net.h b/security/landlock/net.h
> new file mode 100644
> index 000000000000..0da1d9dff5ab
> --- /dev/null
> +++ b/security/landlock/net.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Landlock LSM - Network management and hooks
> + *
> + * Copyright © 2022 Huawei Tech. Co., Ltd.
> + */
> +
> +#ifndef _SECURITY_LANDLOCK_NET_H
> +#define _SECURITY_LANDLOCK_NET_H
> +
> +#include "common.h"
> +#include "ruleset.h"
> +#include "setup.h"
> +
> +#if IS_ENABLED(CONFIG_INET)
> +__init void landlock_add_net_hooks(void);
> +
> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
> +			     const u16 port, access_mask_t access_rights);
> +#else /* IS_ENABLED(CONFIG_INET) */
> +static inline void landlock_add_net_hooks(void)
> +{
> +}
> +#endif /* IS_ENABLED(CONFIG_INET) */
> +
> +#endif /* _SECURITY_LANDLOCK_NET_H */
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 14207b666095..53cb62701280 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -36,6 +36,9 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   	refcount_set(&new_ruleset->usage, 1);
>   	mutex_init(&new_ruleset->lock);
>   	new_ruleset->root_inode = RB_ROOT;
> +#if IS_ENABLED(CONFIG_INET)
> +	new_ruleset->root_net_port = RB_ROOT;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	new_ruleset->num_layers = num_layers;
>   	/*
>   	 * hierarchy = NULL
> @@ -46,16 +49,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   }
> 
>   struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t fs_access_mask)
> +landlock_create_ruleset(const access_mask_t fs_access_mask,
> +			const access_mask_t net_access_mask)
>   {
>   	struct landlock_ruleset *new_ruleset;
> 
>   	/* Informs about useless ruleset. */
> -	if (!fs_access_mask)
> +	if (!fs_access_mask && !net_access_mask)
>   		return ERR_PTR(-ENOMSG);
>   	new_ruleset = create_ruleset(1);
> -	if (!IS_ERR(new_ruleset))
> +	if (IS_ERR(new_ruleset))
> +		return new_ruleset;
> +	if (fs_access_mask)
>   		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
> +	if (net_access_mask)
> +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>   	return new_ruleset;
>   }
> 
> @@ -73,6 +81,10 @@ static bool is_object_pointer(const enum landlock_key_type key_type)
>   	switch (key_type) {
>   	case LANDLOCK_KEY_INODE:
>   		return true;
> +#if IS_ENABLED(CONFIG_INET)
> +	case LANDLOCK_KEY_NET_PORT:
> +		return false;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	}
>   	WARN_ON_ONCE(1);
>   	return false;
> @@ -126,6 +138,11 @@ static struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>   	case LANDLOCK_KEY_INODE:
>   		root = &ruleset->root_inode;
>   		break;
> +#if IS_ENABLED(CONFIG_INET)
> +	case LANDLOCK_KEY_NET_PORT:
> +		root = &ruleset->root_net_port;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	}
>   	if (WARN_ON_ONCE(!root))
>   		return ERR_PTR(-EINVAL);
> @@ -154,7 +171,8 @@ static void build_check_ruleset(void)
>   	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>   	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>   	BUILD_BUG_ON(access_masks <
> -		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
> +		     ((LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) |
> +		      (LANDLOCK_MASK_ACCESS_NET << LANDLOCK_SHIFT_ACCESS_NET)));
>   }
> 
>   /**
> @@ -373,6 +391,12 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   	if (err)
>   		goto out_unlock;
> 
> +#if IS_ENABLED(CONFIG_INET)
> +	/* Merges the @src network port tree. */
> +	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
> +	if (err)
> +		goto out_unlock;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   out_unlock:
>   	mutex_unlock(&src->lock);
>   	mutex_unlock(&dst->lock);
> @@ -429,6 +453,12 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>   	if (err)
>   		goto out_unlock;
> 
> +#if IS_ENABLED(CONFIG_INET)
> +	/* Copies the @parent network port tree. */
> +	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
> +	if (err)
> +		goto out_unlock;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>   		err = -EINVAL;
>   		goto out_unlock;
> @@ -461,6 +491,11 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>   	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
>   					     node)
>   		free_rule(freeme, LANDLOCK_KEY_INODE);
> +#if IS_ENABLED(CONFIG_INET)
> +	rbtree_postorder_for_each_entry_safe(freeme, next,
> +					     &ruleset->root_net_port, node)
> +		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	put_hierarchy(ruleset->hierarchy);
>   	kfree(ruleset);
>   }
> @@ -641,7 +676,8 @@ get_access_mask_t(const struct landlock_ruleset *const ruleset,
>    *
>    * @domain: The domain that defines the current restrictions.
>    * @access_request: The requested access rights to check.
> - * @layer_masks: The layer masks to populate.
> + * @layer_masks: It must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
> + * elements according to @key_type.
>    * @key_type: The key type to switch between access masks of different types.
>    *
>    * Returns: An access mask where each access right bit is set which is handled
> @@ -662,6 +698,12 @@ landlock_init_layer_masks(const struct landlock_ruleset *const domain,
>   		get_access_mask = landlock_get_fs_access_mask;
>   		num_access = LANDLOCK_NUM_ACCESS_FS;
>   		break;
> +#if IS_ENABLED(CONFIG_INET)
> +	case LANDLOCK_KEY_NET_PORT:
> +		get_access_mask = landlock_get_net_access_mask;
> +		num_access = LANDLOCK_NUM_ACCESS_NET;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	default:
>   		WARN_ON_ONCE(1);
>   		return 0;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 2251e6048ccf..dcf7fbac8367 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -33,13 +33,16 @@
>   typedef u16 access_mask_t;
>   /* Makes sure all filesystem access rights can be stored. */
>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
> +/* Makes sure all network access rights can be stored. */
> +static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>   /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>   static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
> 
>   /* Ruleset access masks. */
> -typedef u16 access_masks_t;
> +typedef u32 access_masks_t;
>   /* Makes sure all ruleset access rights can be stored. */
> -static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
> +static_assert(BITS_PER_TYPE(access_masks_t) >=
> +	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);
> 
>   typedef u16 layer_mask_t;
>   /* Makes sure all layers can be checked. */
> @@ -84,6 +87,13 @@ enum landlock_key_type {
>   	 * keys.
>   	 */
>   	LANDLOCK_KEY_INODE = 1,
> +#if IS_ENABLED(CONFIG_INET)
> +	/**
> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
> +	 * node keys.
> +	 */
> +	LANDLOCK_KEY_NET_PORT = 2,
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   };
> 
>   /**
> @@ -158,6 +168,15 @@ struct landlock_ruleset {
>   	 * reaches zero.
>   	 */
>   	struct rb_root root_inode;
> +#if IS_ENABLED(CONFIG_INET)
> +	/**
> +	 * @root_net_port: Root of a red-black tree containing &struct
> +	 * landlock_rule nodes with network port. Once a ruleset is tied to a
> +	 * process (i.e. as a domain), this tree is immutable until @usage
> +	 * reaches zero.
> +	 */
> +	struct rb_root root_net_port;
> +#endif /* IS_ENABLED(CONFIG_INET) */
>   	/**
>   	 * @hierarchy: Enables hierarchy identification even when a parent
>   	 * domain vanishes.  This is needed for the ptrace protection.
> @@ -196,13 +215,13 @@ struct landlock_ruleset {
>   			 */
>   			u32 num_layers;
>   			/**
> -			 * @access_masks: Contains the subset of filesystem
> -			 * actions that are restricted by a ruleset.  A domain
> -			 * saves all layers of merged rulesets in a stack
> -			 * (FAM), starting from the first layer to the last
> -			 * one.  These layers are used when merging rulesets,
> -			 * for user space backward compatibility (i.e.
> -			 * future-proof), and to properly handle merged
> +			 * @access_masks: Contains the subset of filesystem and
> +			 * network actions that are restricted by a ruleset.
> +			 * A domain saves all layers of merged rulesets in a
> +			 * stack (FAM), starting from the first layer to the
> +			 * last one.  These layers are used when merging
> +			 * rulesets, for user space backward compatibility
> +			 * (i.e. future-proof), and to properly handle merged
>   			 * rulesets without overlapping access rights.  These
>   			 * layers are set once and never changed for the
>   			 * lifetime of the ruleset.
> @@ -213,7 +232,8 @@ struct landlock_ruleset {
>   };
> 
>   struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t access_mask);
> +landlock_create_ruleset(const access_mask_t access_mask_fs,
> +			const access_mask_t access_mask_net);
> 
>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
> @@ -249,6 +269,19 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>   		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
>   }
> 
> +static inline void
> +landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
> +			     const access_mask_t net_access_mask,
> +			     const u16 layer_level)
> +{
> +	access_mask_t net_mask = net_access_mask & LANDLOCK_MASK_ACCESS_NET;
> +
> +	/* Should already be checked in sys_landlock_create_ruleset(). */
> +	WARN_ON_ONCE(net_access_mask != net_mask);
> +	ruleset->access_masks[layer_level] |=
> +		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
> +}
> +
>   static inline access_mask_t
>   landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   				const u16 layer_level)
> @@ -266,6 +299,16 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
>   	       LANDLOCK_ACCESS_FS_INITIALLY_DENIED;
>   }
> +
> +static inline access_mask_t
> +landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
> +			     const u16 layer_level)
> +{
> +	return (ruleset->access_masks[layer_level] >>
> +		LANDLOCK_SHIFT_ACCESS_NET) &
> +	       LANDLOCK_MASK_ACCESS_NET;
> +}
> +
>   bool landlock_unmask_layers(const struct landlock_rule *const rule,
>   			    const access_mask_t access_request,
>   			    layer_mask_t (*const layer_masks)[],
> diff --git a/security/landlock/setup.c b/security/landlock/setup.c
> index 3f196d2ce4f9..7e4a598177b8 100644
> --- a/security/landlock/setup.c
> +++ b/security/landlock/setup.c
> @@ -14,6 +14,7 @@
>   #include "fs.h"
>   #include "ptrace.h"
>   #include "setup.h"
> +#include "net.h"
> 
>   bool landlock_initialized __lsm_ro_after_init = false;
> 
> @@ -29,6 +30,7 @@ static int __init landlock_init(void)
>   	landlock_add_cred_hooks();
>   	landlock_add_ptrace_hooks();
>   	landlock_add_fs_hooks();
> +	landlock_add_net_hooks();
>   	landlock_initialized = true;
>   	pr_info("Up and running.\n");
>   	return 0;
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 8a54e87dbb17..1f0edd605bc4 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -29,6 +29,7 @@
>   #include "cred.h"
>   #include "fs.h"
>   #include "limits.h"
> +#include "net.h"
>   #include "ruleset.h"
>   #include "setup.h"
> 
> @@ -74,7 +75,8 @@ static void build_check_abi(void)
>   {
>   	struct landlock_ruleset_attr ruleset_attr;
>   	struct landlock_path_beneath_attr path_beneath_attr;
> -	size_t ruleset_size, path_beneath_size;
> +	struct landlock_net_service_attr net_service_attr;
> +	size_t ruleset_size, path_beneath_size, net_service_size;
> 
>   	/*
>   	 * For each user space ABI structures, first checks that there is no
> @@ -82,13 +84,19 @@ static void build_check_abi(void)
>   	 * struct size.
>   	 */
>   	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
> +	ruleset_size += sizeof(ruleset_attr.handled_access_net);
>   	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
> -	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
> +	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
> 
>   	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
>   	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
>   	BUILD_BUG_ON(sizeof(path_beneath_attr) != path_beneath_size);
>   	BUILD_BUG_ON(sizeof(path_beneath_attr) != 12);
> +
> +	net_service_size = sizeof(net_service_attr.allowed_access);
> +	net_service_size += sizeof(net_service_attr.port);
> +	BUILD_BUG_ON(sizeof(net_service_attr) != net_service_size);
> +	BUILD_BUG_ON(sizeof(net_service_attr) != 16);
>   }
> 
>   /* Ruleset handling */
> @@ -129,7 +137,7 @@ static const struct file_operations ruleset_fops = {
>   	.write = fop_dummy_write,
>   };
> 
> -#define LANDLOCK_ABI_VERSION 3
> +#define LANDLOCK_ABI_VERSION 4
> 
>   /**
>    * sys_landlock_create_ruleset - Create a new ruleset
> @@ -188,8 +196,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>   	    LANDLOCK_MASK_ACCESS_FS)
>   		return -EINVAL;
> 
> +	/* Checks network content (and 32-bits cast). */
> +	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
> +	    LANDLOCK_MASK_ACCESS_NET)
> +		return -EINVAL;
> +
>   	/* Checks arguments and transforms to kernel struct. */
> -	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
> +	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
> +					  ruleset_attr.handled_access_net);
>   	if (IS_ERR(ruleset))
>   		return PTR_ERR(ruleset);
> 
> @@ -315,13 +329,54 @@ static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
>   	return err;
>   }
> 
> +static int add_rule_net_service(struct landlock_ruleset *ruleset,
> +				const void __user *const rule_attr)
> +{
> +#if IS_ENABLED(CONFIG_INET)
> +	struct landlock_net_service_attr net_service_attr;
> +	int res;
> +	access_mask_t mask;
> +
> +	/* Copies raw user space buffer, only one type for now. */
> +	res = copy_from_user(&net_service_attr, rule_attr,
> +			     sizeof(net_service_attr));
> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored by network actions.
> +	 */
> +	if (!net_service_attr.allowed_access)
> +		return -ENOMSG;
> +
> +	/*
> +	 * Checks that allowed_access matches the @ruleset constraints
> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> +	 */
> +	mask = landlock_get_net_access_mask(ruleset, 0);
> +	if ((net_service_attr.allowed_access | mask) != mask)
> +		return -EINVAL;
> +
> +	/* Denies inserting a rule with port 0 or more than U16_MAX. */
"Denies inserting a rule with port 0 or higher than 65535."

A test should check that it works with 65535 but not with 65536.


> +	if ((net_service_attr.port == 0) || (net_service_attr.port > U16_MAX))
> +		return -EINVAL;
> +
> +	/* Imports the new rule. */
> +	return landlock_append_net_rule(ruleset, net_service_attr.port,
> +					net_service_attr.allowed_access);
> +#else /* IS_ENABLED(CONFIG_INET) */
> +	return -EAFNOSUPPORT;
> +#endif /* IS_ENABLED(CONFIG_INET) */
> +}
> +
>   /**
>    * sys_landlock_add_rule - Add a new rule to a ruleset
>    *
>    * @ruleset_fd: File descriptor tied to the ruleset that should be extended
>    *		with the new rule.
> - * @rule_type: Identify the structure type pointed to by @rule_attr (only
> - *             %LANDLOCK_RULE_PATH_BENEATH for now).
> + * @rule_type: Identify the structure type pointed to by @rule_attr:
> + *             %LANDLOCK_RULE_PATH_BENEATH or %LANDLOCK_RULE_NET_SERVICE.
>    * @rule_attr: Pointer to a rule (only of type &struct
>    *             landlock_path_beneath_attr for now).
>    * @flags: Must be 0.
> @@ -332,6 +387,8 @@ static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
>    * Possible returned errors are:
>    *
>    * - %EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
> + * - %EAFNOSUPPORT: @rule_type is LANDLOCK_RULE_NET_SERVICE but TCP/IP is not
> + *   supported by the running kernel;
>    * - %EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
>    *   &landlock_path_beneath_attr.allowed_access is not a subset of the
>    *   ruleset handled accesses);
> @@ -366,6 +423,9 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>   	case LANDLOCK_RULE_PATH_BENEATH:
>   		err = add_rule_path_beneath(ruleset, rule_attr);
>   		break;
> +	case LANDLOCK_RULE_NET_SERVICE:
> +		err = add_rule_net_service(ruleset, rule_attr);
> +		break;
>   	default:
>   		err = -EINVAL;
>   		break;
> diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
> index 792c3f0a59b4..646f778dfb1e 100644
> --- a/tools/testing/selftests/landlock/base_test.c
> +++ b/tools/testing/selftests/landlock/base_test.c
> @@ -75,7 +75,7 @@ TEST(abi_version)
>   	const struct landlock_ruleset_attr ruleset_attr = {
>   		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
>   	};
> -	ASSERT_EQ(3, landlock_create_ruleset(NULL, 0,
> +	ASSERT_EQ(4, landlock_create_ruleset(NULL, 0,
>   					     LANDLOCK_CREATE_RULESET_VERSION));
> 
>   	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
> --
> 2.25.1
> 
