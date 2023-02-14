Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A24696098
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjBNKT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjBNKT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:19:58 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2876A7C;
        Tue, 14 Feb 2023 02:19:57 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGHCT6XHGz67K2K;
        Tue, 14 Feb 2023 18:15:33 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 10:19:54 +0000
Message-ID: <2d25dbd5-f7b1-ba32-d971-36c86870661e@huawei.com>
Date:   Tue, 14 Feb 2023 13:19:53 +0300
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
 <5198f456-91f5-5c65-76c2-45b82ccb05eb@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <5198f456-91f5-5c65-76c2-45b82ccb05eb@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/10/2023 8:39 PM, Mickaël Salaün пишет:
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
> 
> [...]
> 
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
> 
> You can remove this fallthrough.

   Got it.
> 
> 
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
> 
> landlock_get_current_domain() should only be called by a
> get_current_net_domain() wrapper that checks if the current domain
> handles network accesses. See get_current_fs_domain() in patch 2/12.
> 
   Ok. Thanks for a tip.
> 
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
>> +}
> .
