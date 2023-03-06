Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711916ABBAD
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCFKTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCFKTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:19:11 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A04FD32B;
        Mon,  6 Mar 2023 02:18:44 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PVZKN6w6Pz6J6mk;
        Mon,  6 Mar 2023 18:18:16 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 10:18:41 +0000
Message-ID: <41a17dab-3697-5c02-3fd2-66f5fc3a37e1@huawei.com>
Date:   Mon, 6 Mar 2023 13:18:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-9-konstantin.meskhidze@huawei.com>
 <866f6633-4360-13b5-7d25-ef7acb6255a0@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <866f6633-4360-13b5-7d25-ef7acb6255a0@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/21/2023 9:04 PM, Mickaël Salaün пишет:
> 
> 
> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>> This commit adds network rules support in the ruleset management
>> helpers and the landlock_create_ruleset syscall.
>> Refactor user space API to support network actions. Add new network
>> access flags, network rule and network attributes. Increment Landlock
>> ABI version. Expand access_masks_t to u32 to be sure network access
>> rights can be stored. Implement socket_bind() and socket_connect()
>> LSM hooks, which enable to restrict TCP socket binding and connection
>> to specific ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v8:
>> * Squashes commits.
>> * Refactors commit message.
>> * Changes UAPI port field to __be16.
>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>> * Adds address length checking.
>> * Minor fixes.
>> 
>> Changes since v7:
>> * Squashes commits.
>> * Increments ABI version to 4.
>> * Refactors commit message.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>    because it OR values.
>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>> * Refactors landlock_get_net_access_mask().
>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>    LANDLOCK_NUM_ACCESS_FS as value.
>> * Updates access_masks_t to u32 to support network access actions.
>> * Refactors landlock internal functions to support network actions with
>>    landlock_key/key_type/id types.
>> 
>> Changes since v5:
>> * Gets rid of partial revert from landlock_add_rule
>> syscall.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors landlock_create_ruleset() - splits ruleset and
>> masks checks.
>> * Refactors landlock_create_ruleset() and landlock mask
>> setters/getters to support two rule types.
>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>> function by factoring out get_ruleset_from_fd() and
>> landlock_put_ruleset().
>> 
>> Changes since v3:
>> * Splits commit.
>> * Adds network rule support for internal landlock functions.
>> * Adds set_mask and get_mask for network.
>> * Adds rb_root root_net_port.
>> 
>> ---
>>   include/uapi/linux/landlock.h                |  49 +++++
>>   security/landlock/Kconfig                    |   1 +
>>   security/landlock/Makefile                   |   2 +
>>   security/landlock/limits.h                   |   6 +-
>>   security/landlock/net.c                      | 200 +++++++++++++++++++
>>   security/landlock/net.h                      |  26 +++
>>   security/landlock/ruleset.c                  |  52 ++++-
>>   security/landlock/ruleset.h                  |  63 +++++-
>>   security/landlock/setup.c                    |   2 +
>>   security/landlock/syscalls.c                 |  72 ++++++-
>>   tools/testing/selftests/landlock/base_test.c |   2 +-
>>   11 files changed, 452 insertions(+), 23 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>> 
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index f3223f964691..ae11c663c975 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>   	 * this access right.
>>   	 */
>>   	__u64 handled_access_fs;
>> +
>> +	/**
>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>> +	 * that is handled by this ruleset and should then be forbidden if no
>> +	 * rule explicitly allow them.
>> +	 */
>> +	__u64 handled_access_net;
>>   };
>>   
>>   /*
>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>   	 * landlock_path_beneath_attr .
>>   	 */
>>   	LANDLOCK_RULE_PATH_BENEATH = 1,
>> +	/**
>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>> +	 * landlock_net_service_attr .
>> +	 */
>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>   };
>>   
>>   /**
>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>   	 */
>>   } __attribute__((packed));
>>   
>> +/**
>> + * struct landlock_net_service_attr - TCP subnet definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_net_service_attr {
>> +	/**
>> +	 * @allowed_access: Bitmask of allowed access network for services
>> +	 * (cf. `Network flags`_).
>> +	 */
>> +	__u64 allowed_access;
>> +	/**
>> +	 * @port: Network port.
>> +	 */
>> +	__be16 port;
>> +
>> +} __attribute__((packed));
>> +
>>   /**
>>    * DOC: fs_access
>>    *
>> @@ -173,4 +203,23 @@ struct landlock_path_beneath_attr {
>>   #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>>   /* clang-format on */
>>   
>> +/**
>> + * DOC: net_access
>> + *
>> + * Network flags
>> + * ~~~~~~~~~~~~~~~~
>> + *
>> + * These flags enable to restrict a sandboxed process to a set of network
>> + * actions.
>> + *
>> + * TCP sockets with allowed actions:
>> + *
>> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>> + *   a remote port.
>> + */
>> +/* clang-format off */
>> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>> +/* clang-format on */
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
>> index 8e33c4e8ffb8..10c099097533 100644
>> --- a/security/landlock/Kconfig
>> +++ b/security/landlock/Kconfig
>> @@ -3,6 +3,7 @@
>>   config SECURITY_LANDLOCK
>>   	bool "Landlock support"
>>   	depends on SECURITY && !ARCH_EPHEMERAL_INODES
>> +	select SECURITY_NETWORK
>>   	select SECURITY_PATH
>>   	help
>>   	  Landlock is a sandboxing mechanism that enables processes to restrict
>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>> index 7bbd2f413b3e..53d3c92ae22e 100644
>> --- a/security/landlock/Makefile
>> +++ b/security/landlock/Makefile
>> @@ -2,3 +2,5 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>   
>>   landlock-y := setup.o syscalls.o object.o ruleset.o \
>>   	cred.o ptrace.o fs.o
>> +
>> +landlock-$(CONFIG_INET) += net.o
>> \ No newline at end of file
>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>> index bafb3b8dc677..8a1a6463c64e 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -23,6 +23,10 @@
>>   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>>   #define LANDLOCK_SHIFT_ACCESS_FS	0
>>   
>> -/* clang-format on */
>> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
>> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
>>   
>> +/* clang-format on */
>>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> new file mode 100644
>> index 000000000000..338bd6dd8e3f
>> --- /dev/null
>> +++ b/security/landlock/net.c
>> @@ -0,0 +1,200 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock LSM - Network management and hooks
>> + *
>> + * Copyright © 2022 Huawei Tech. Co., Ltd.
>> + * Copyright © 2022 Microsoft Corporation
>> + */
>> +
>> +#include <linux/in.h>
>> +#include <linux/net.h>
>> +#include <linux/socket.h>
>> +#include <net/ipv6.h>
>> +
>> +#include "common.h"
>> +#include "cred.h"
>> +#include "limits.h"
>> +#include "net.h"
>> +#include "ruleset.h"
>> +
>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> +			     const __be16 port, access_mask_t access_rights)
>> +{
>> +	int err;
>> +	const struct landlock_id id = {
>> +		.key.data = port,
>> +		.type = LANDLOCK_KEY_NET_PORT,
>> +	};
>> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
>> +
>> +	/* Transforms relative access rights to absolute ones. */
>> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
>> +			 ~landlock_get_net_access_mask(ruleset, 0);
>> +
>> +	mutex_lock(&ruleset->lock);
>> +	err = landlock_insert_rule(ruleset, id, access_rights);
>> +	mutex_unlock(&ruleset->lock);
>> +
>> +	return err;
>> +}
>> +
>> +static int check_addrlen(const struct sockaddr *const address, int addrlen)
>> +{
>> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
>> +		return -EINVAL;
>> +	switch (address->sa_family) {
>> +	case AF_UNSPEC:
>> +	case AF_INET:
>> +		if (addrlen < sizeof(struct sockaddr_in))
>> +			return -EINVAL;
>> +		return 0;
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	case AF_INET6:
>> +		if (addrlen < SIN6_LEN_RFC2133)
>> +			return -EINVAL;
>> +		return 0;
>> +#endif
>> +	}
>> +	WARN_ON_ONCE(1);
>> +	return 0;
>> +}
>> +
>> +static int check_socket_access(const struct landlock_ruleset *const domain,
>> +			       struct sockaddr *address, __be16 port,
>> +			       access_mask_t access_request)
>> +{
>> +	bool allowed = false;
>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>> +	const struct landlock_rule *rule;
>> +	access_mask_t handled_access;
>> +	const struct landlock_id id = {
>> +		.key.data = port,
>> +		.type = LANDLOCK_KEY_NET_PORT,
>> +	};
>> +
>> +	if (WARN_ON_ONCE(!domain))
>> +		return 0;
>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>> +		return -EACCES;
>> +
>> +	switch (address->sa_family) {
>> +	case AF_UNSPEC:
>> +		/*
>> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
>> +		 * association, which have the same effect as closing the
>> +		 * connection while retaining the socket object (i.e., the file
>> +		 * descriptor).  As for dropping privileges, closing
>> +		 * connections is always allowed.
>> +		 */
>> +		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
>> +			return 0;
>> +
>> +		/*
>> +		 * For compatibility reason, accept AF_UNSPEC for bind
>> +		 * accesses (mapped to AF_INET) only if the address is
>> +		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
>> +		 * required to not wrongfully return -EACCES instead of
>> +		 * -EAFNOSUPPORT.
>> +		 */
>> +		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
>> +			const struct sockaddr_in *const sockaddr =
>> +				(struct sockaddr_in *)address;
>> +
>> +			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
>> +				return -EAFNOSUPPORT;
>> +		}
>> +
>> +		fallthrough;
>> +	case AF_INET:
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	case AF_INET6:
>> +#endif
>> +		rule = landlock_find_rule(domain, id);
>> +		handled_access = landlock_init_layer_masks(
>> +			domain, access_request, &layer_masks,
>> +			LANDLOCK_KEY_NET_PORT);
>> +		allowed = landlock_unmask_layers(rule, handled_access,
>> +						 &layer_masks,
>> +						 ARRAY_SIZE(layer_masks));
>> +
>> +		fallthrough;
>> +	}
>> +	return allowed ? 0 : -EACCES;
>> +}
>> +
>> +static u16 get_port(const struct sockaddr *const address)
>> +{
>> +	/* Gets port value in host byte order. */
>> +	switch (address->sa_family) {
>> +	case AF_UNSPEC:
>> +	case AF_INET: {
>> +		const struct sockaddr_in *const sockaddr =
>> +			(struct sockaddr_in *)address;
>> +		return sockaddr->sin_port;
>> +	}
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	case AF_INET6: {
>> +		const struct sockaddr_in6 *const sockaddr_ip6 =
>> +			(struct sockaddr_in6 *)address;
>> +		return sockaddr_ip6->sin6_port;
>> +	}
>> +#endif
>> +	}
>> +	WARN_ON_ONCE(1);
>> +	return 0;
>> +}
>> +
>> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
>> +			    int addrlen)
>> +{
>> +	int ret;
>> +	const struct landlock_ruleset *const dom =
>> +		landlock_get_current_domain();
>> +
>> +	if (!dom)
>> +		return 0;
>> +
>> +	/* Check if it's a TCP socket. */
>> +	if (sock->type != SOCK_STREAM)
>> +		return 0;
>> +
>> +	ret = check_addrlen(address, addrlen);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return check_socket_access(dom, address, get_port(address),
>> +				   LANDLOCK_ACCESS_NET_BIND_TCP);
> 
> Both hook_socket_bind() and hook_socket_connect() looks the same except
> the access right. All this code could be moved to check_socket_access().
> get_port() would need to be defined before.
> 
   Ok. I got it.
> 
>> +}
>> +
>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>> +			       int addrlen)
>> +{
>> +	int ret;
>> +	const struct landlock_ruleset *const dom =
>> +		landlock_get_current_domain();
>> +
>> +	if (!dom)
>> +		return 0;
>> +
>> +	/* Check if it's a TCP socket. */
>> +	if (sock->type != SOCK_STREAM)
>> +		return 0;
>> +
>> +	ret = check_addrlen(address, addrlen);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return check_socket_access(dom, address, get_port(address),
>> +				   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>> +}
> .
