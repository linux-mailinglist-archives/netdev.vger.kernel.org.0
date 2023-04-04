Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5A96D5BFA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjDDJdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbjDDJdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:33:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1D42133;
        Tue,  4 Apr 2023 02:33:42 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PrMwG5Nscz6J6qG;
        Tue,  4 Apr 2023 17:31:42 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 4 Apr 2023 10:33:38 +0100
Message-ID: <ae266792-3fd6-7c42-8ca0-a5cbd29c6789@huawei.com>
Date:   Tue, 4 Apr 2023 12:33:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v10 09/13] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-10-konstantin.meskhidze@huawei.com>
 <468fbb05-6d72-3570-3453-b1f8bfdd5bc2@digikod.net>
 <01bdfa52-3bac-4703-6caa-d83ea5990c87@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <01bdfa52-3bac-4703-6caa-d83ea5990c87@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/31/2023 8:30 PM, Mickaël Salaün пишет:
> 
> On 31/03/2023 19:24, Mickaël Salaün wrote:
>> 
>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in the ruleset management
>>> helpers and the landlock_create_ruleset syscall.
>>> Refactor user space API to support network actions. Add new network
>>> access flags, network rule and network attributes. Increment Landlock
>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>> rights can be stored. Implement socket_bind() and socket_connect()
>>> LSM hooks, which enable to restrict TCP socket binding and connection
>>> to specific ports.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v9:
>>> * Changes UAPI port field to __u64.
>>> * Moves shared code into check_socket_access().
>>> * Adds get_raw_handled_net_accesses() and
>>> get_current_net_domain() helpers.
>>> * Minor fixes.
>>>
>>> Changes since v8:
>>> * Squashes commits.
>>> * Refactors commit message.
>>> * Changes UAPI port field to __be16.
>>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>>> * Adds address length checking.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Squashes commits.
>>> * Increments ABI version to 4.
>>> * Refactors commit message.
>>> * Minor fixes.
>>>
>>> Changes since v6:
>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>     because it OR values.
>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>> * Refactors landlock_get_net_access_mask().
>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>     LANDLOCK_NUM_ACCESS_FS as value.
>>> * Updates access_masks_t to u32 to support network access actions.
>>> * Refactors landlock internal functions to support network actions with
>>>     landlock_key/key_type/id types.
>>>
>>> Changes since v5:
>>> * Gets rid of partial revert from landlock_add_rule
>>> syscall.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>> masks checks.
>>> * Refactors landlock_create_ruleset() and landlock mask
>>> setters/getters to support two rule types.
>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>> function by factoring out get_ruleset_from_fd() and
>>> landlock_put_ruleset().
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds network rule support for internal landlock functions.
>>> * Adds set_mask and get_mask for network.
>>> * Adds rb_root root_net_port.
>>>
>>> ---
>>>    include/uapi/linux/landlock.h                |  49 +++++
>>>    security/landlock/Kconfig                    |   1 +
>>>    security/landlock/Makefile                   |   2 +
>>>    security/landlock/limits.h                   |   6 +-
>>>    security/landlock/net.c                      | 198 +++++++++++++++++++
>>>    security/landlock/net.h                      |  26 +++
>>>    security/landlock/ruleset.c                  |  52 ++++-
>>>    security/landlock/ruleset.h                  |  63 +++++-
>>>    security/landlock/setup.c                    |   2 +
>>>    security/landlock/syscalls.c                 |  72 ++++++-
>>>    tools/testing/selftests/landlock/base_test.c |   2 +-
>>>    11 files changed, 450 insertions(+), 23 deletions(-)
>>>    create mode 100644 security/landlock/net.c
>>>    create mode 100644 security/landlock/net.h
>> 
>> [...]
>> 
>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> 
>> [...]
>> 
>>> +static int check_addrlen(const struct sockaddr *const address, int addrlen)
>> 
>> const int addrlen
>> 
>>> +{
>>> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
>>> +		return -EINVAL;
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +	case AF_INET:
>>> +		if (addrlen < sizeof(struct sockaddr_in))
>>> +			return -EINVAL;
>>> +		return 0;
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>> +		if (addrlen < SIN6_LEN_RFC2133)
>>> +			return -EINVAL;
>>> +		return 0;
>>> +#endif
>>> +	}
>>> +	WARN_ON_ONCE(1);
>>> +	return 0;
>>> +}
>>> +
>>> +static u16 get_port(const struct sockaddr *const address)
>>> +{
>>> +	/* Gets port value in host byte order. */
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +	case AF_INET: {
>>> +		const struct sockaddr_in *const sockaddr =
>>> +			(struct sockaddr_in *)address;
>>> +		return ntohs(sockaddr->sin_port);
>> 
>> Storing ports in big endian (in rulesets) would avoid converting them
>> every time the kernel checks a socket port. The above comment should
>> then be updated too.
> 
> You can then return a __be16 type here and at least also use __be16 in
> check_socket_access().

   Do you mean we need to do port converting __be16 -> u16 in 
check_socket_access()???
> 
>> 
>> 
>>> +	}
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6: {
>>> +		const struct sockaddr_in6 *const sockaddr_ip6 =
>>> +			(struct sockaddr_in6 *)address;
>>> +		return ntohs(sockaddr_ip6->sin6_port);
>>> +	}
>>> +#endif
>>> +	}
>>> +	WARN_ON_ONCE(1);
>>> +	return 0;
>>> +}
>>> +
>>> +static int check_socket_access(struct socket *sock, struct sockaddr *address, int addrlen, u16 port,
>>> +			       access_mask_t access_request)
>>> +{
>>> +	int ret;
>>> +	bool allowed = false;
>>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>> +	const struct landlock_rule *rule;
>>> +	access_mask_t handled_access;
>>> +	const struct landlock_id id = {
>>> +		.key.data = port,
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +	const struct landlock_ruleset *const domain = get_current_net_domain();
>>> +
>>> +	if (WARN_ON_ONCE(!domain))
>>> +		return 0;
>>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>>> +		return -EACCES;
>>> +	/* Check if it's a TCP socket. */
>>> +	if (sock->type != SOCK_STREAM)
>>> +		return 0;
>>> +
>>> +	ret = check_addrlen(address, addrlen);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +		/*
>>> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
>>> +		 * association, which have the same effect as closing the
>>> +		 * connection while retaining the socket object (i.e., the file
>>> +		 * descriptor).  As for dropping privileges, closing
>>> +		 * connections is always allowed.
>>> +		 */
>>> +		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>> +			return 0;
>>> +
>>> +		/*
>>> +		 * For compatibility reason, accept AF_UNSPEC for bind
>>> +		 * accesses (mapped to AF_INET) only if the address is
>>> +		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
>>> +		 * required to not wrongfully return -EACCES instead of
>>> +		 * -EAFNOSUPPORT.
>>> +		 */
>>> +		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
>>> +			const struct sockaddr_in *const sockaddr =
>>> +				(struct sockaddr_in *)address;
>>> +
>>> +			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
>>> +				return -EAFNOSUPPORT;
>>> +		}
>>> +
>>> +		fallthrough;
>>> +	case AF_INET:
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>> +#endif
>>> +		rule = landlock_find_rule(domain, id);
>>> +		handled_access = landlock_init_layer_masks(
>>> +			domain, access_request, &layer_masks,
>>> +			LANDLOCK_KEY_NET_PORT);
>>> +		allowed = landlock_unmask_layers(rule, handled_access,
>>> +						 &layer_masks,
>>> +						 ARRAY_SIZE(layer_masks));
>>> +	}
>>> +	return allowed ? 0 : -EACCES;
>>> +}
>>> +
>>> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
>>> +			    int addrlen)
>>> +{
>>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>> +				   LANDLOCK_ACCESS_NET_BIND_TCP);
>>> +}
>>> +
>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>>> +			       int addrlen)
>>> +{
>>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>> +				   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>> +}
>> 
>> [...]
> .
