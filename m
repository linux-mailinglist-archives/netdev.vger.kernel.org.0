Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE16D9400
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbjDFK2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbjDFK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:28:36 -0400
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [IPv6:2001:1600:4:17::190c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADF0171F
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:28:31 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Psd4r46TtzMqGn3;
        Thu,  6 Apr 2023 12:28:28 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Psd4q5X5rzMprnY;
        Thu,  6 Apr 2023 12:28:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1680776908;
        bh=cKsQb6MGoDeQT47SNFXYBNWorHFjIfQ+BkR32GtIJF8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KGlUWPsdcYBUwEcsnL3qp7mgQk4Y4AwR+1hVbIdR8PbIlhKrJCo/PbryhIDUNXUpG
         KX8Sc+0og3RTSlJp8TlCR0rO+EfztdPO0RfDNCpUSYvJW5paKyy6MyWGfu7y0N9DZf
         /9w8c01DyGiGYNEuFyp5fCVN/ceRY211nqQ4Dzt8=
Message-ID: <0e08c5d4-f5fd-e025-3f14-8e2ada3b7302@digikod.net>
Date:   Thu, 6 Apr 2023 12:28:26 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 09/13] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-10-konstantin.meskhidze@huawei.com>
 <468fbb05-6d72-3570-3453-b1f8bfdd5bc2@digikod.net>
 <1f84d88f-9977-13a9-245a-c75cd3444b29@huawei.com>
 <ac4d6244-641b-e1d4-5c34-d9a9bcd10498@digikod.net>
 <39980493-6107-0117-1d32-2af03fa23fa9@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <39980493-6107-0117-1d32-2af03fa23fa9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/04/2023 19:42, Konstantin Meskhidze (A) wrote:
> 
> 
> 4/4/2023 7:42 PM, Mickaël Salaün пишет:
>>
>> On 04/04/2023 11:31, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 3/31/2023 8:24 PM, Mickaël Salaün пишет:
>>>>
>>>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>>>> This commit adds network rules support in the ruleset management
>>>>> helpers and the landlock_create_ruleset syscall.
>>>>> Refactor user space API to support network actions. Add new network
>>>>> access flags, network rule and network attributes. Increment Landlock
>>>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>>>> rights can be stored. Implement socket_bind() and socket_connect()
>>>>> LSM hooks, which enable to restrict TCP socket binding and connection
>>>>> to specific ports.
>>>>>
>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>> ---
>>>>>
>>>>> Changes since v9:
>>>>> * Changes UAPI port field to __u64.
>>>>> * Moves shared code into check_socket_access().
>>>>> * Adds get_raw_handled_net_accesses() and
>>>>> get_current_net_domain() helpers.
>>>>> * Minor fixes.
>>>>>
>>>>> Changes since v8:
>>>>> * Squashes commits.
>>>>> * Refactors commit message.
>>>>> * Changes UAPI port field to __be16.
>>>>> * Changes logic of bind/connect hooks with AF_UNSPEC families.
>>>>> * Adds address length checking.
>>>>> * Minor fixes.
>>>>>
>>>>> Changes since v7:
>>>>> * Squashes commits.
>>>>> * Increments ABI version to 4.
>>>>> * Refactors commit message.
>>>>> * Minor fixes.
>>>>>
>>>>> Changes since v6:
>>>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>>>      because it OR values.
>>>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>>>> * Refactors landlock_get_net_access_mask().
>>>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>>>      LANDLOCK_NUM_ACCESS_FS as value.
>>>>> * Updates access_masks_t to u32 to support network access actions.
>>>>> * Refactors landlock internal functions to support network actions with
>>>>>      landlock_key/key_type/id types.
>>>>>
>>>>> Changes since v5:
>>>>> * Gets rid of partial revert from landlock_add_rule
>>>>> syscall.
>>>>> * Formats code with clang-format-14.
>>>>>
>>>>> Changes since v4:
>>>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>>>> masks checks.
>>>>> * Refactors landlock_create_ruleset() and landlock mask
>>>>> setters/getters to support two rule types.
>>>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>>>> function by factoring out get_ruleset_from_fd() and
>>>>> landlock_put_ruleset().
>>>>>
>>>>> Changes since v3:
>>>>> * Splits commit.
>>>>> * Adds network rule support for internal landlock functions.
>>>>> * Adds set_mask and get_mask for network.
>>>>> * Adds rb_root root_net_port.
>>>>>
>>>>> ---
>>>>>     include/uapi/linux/landlock.h                |  49 +++++
>>>>>     security/landlock/Kconfig                    |   1 +
>>>>>     security/landlock/Makefile                   |   2 +
>>>>>     security/landlock/limits.h                   |   6 +-
>>>>>     security/landlock/net.c                      | 198 +++++++++++++++++++
>>>>>     security/landlock/net.h                      |  26 +++
>>>>>     security/landlock/ruleset.c                  |  52 ++++-
>>>>>     security/landlock/ruleset.h                  |  63 +++++-
>>>>>     security/landlock/setup.c                    |   2 +
>>>>>     security/landlock/syscalls.c                 |  72 ++++++-
>>>>>     tools/testing/selftests/landlock/base_test.c |   2 +-
>>>>>     11 files changed, 450 insertions(+), 23 deletions(-)
>>>>>     create mode 100644 security/landlock/net.c
>>>>>     create mode 100644 security/landlock/net.h
>>>>
>>>> [...]
>>>>
>>>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>>>
>>>> [...]
>>>>
>>>>> +static int check_addrlen(const struct sockaddr *const address, int addrlen)
>>>>
>>>> const int addrlen
>>>
>>>      Got it.
>>>>
>>>>> +{
>>>>> +	if (addrlen < offsetofend(struct sockaddr, sa_family))
>>>>> +		return -EINVAL;
>>>>> +	switch (address->sa_family) {
>>>>> +	case AF_UNSPEC:
>>>>> +	case AF_INET:
>>>>> +		if (addrlen < sizeof(struct sockaddr_in))
>>>>> +			return -EINVAL;
>>>>> +		return 0;
>>>>> +#if IS_ENABLED(CONFIG_IPV6)
>>>>> +	case AF_INET6:
>>>>> +		if (addrlen < SIN6_LEN_RFC2133)
>>>>> +			return -EINVAL;
>>>>> +		return 0;
>>>>> +#endif
>>>>> +	}
>>>>> +	WARN_ON_ONCE(1);
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static u16 get_port(const struct sockaddr *const address)
>>>>> +{
>>>>> +	/* Gets port value in host byte order. */
>>>>> +	switch (address->sa_family) {
>>>>> +	case AF_UNSPEC:
>>>>> +	case AF_INET: {
>>>>> +		const struct sockaddr_in *const sockaddr =
>>>>> +			(struct sockaddr_in *)address;
>>>>> +		return ntohs(sockaddr->sin_port);
>>>>
>>>> Storing ports in big endian (in rulesets) would avoid converting them
>>>> every time the kernel checks a socket port. The above comment should
>>>> then be updated too.
>>>
>>>      I thought we came to a conclusion to stick to host endianess and
>>> let kernel do the checks under the hood:
>>> https://lore.kernel.org/linux-security-module/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net/
>>>
>>> Did I misunderstand something?
>>
>> We indeed stick to the host endianess for the UAPI/syscalls, but
>> internally the kernel has to do the conversion with as it is currently
>> done by calling ntohs(). To avoid calling ntohs() every time get_port()
>> is called, we can instead only call htons() when creating rules (i.e.
>> one-time htons call instead of multiple ntohs calls).
>>
>    Do you mean we need to covert port in  landlock_append_net_rule():
> 
>    ...
> 
>           int err;
> 	const struct landlock_id id = {
> 		.key.data = ntohs(port),
> 		.type = LANDLOCK_KEY_NET_PORT,
> 	};
> 	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> ...
> ????

landlock_append_net_rule() takes a u16 (host endianess, which is the 
case with this patch series) and should store a big endian 16-bit 
integer. See my patch:

         const struct landlock_id id = {
-               .key.data = port,
+               .key.data = (__force uintptr_t)htons(port),
                 .type = LANDLOCK_KEY_NET_PORT,
         };



>>
>>>     Do you mean we need to do port converting __be16 -> u16 in
>>> check_socket_access()???
>>
>> Removing the ntohs() call from get_port() enables to return __be16
>> instead of u16, and check_socket_access() will then need to use the same
>> type.
> 
>     Ok. I got it. Thanks.
>>
>>
>>>>
>>>>
>>>>> +	}
>>>>> +#if IS_ENABLED(CONFIG_IPV6)
>>>>> +	case AF_INET6: {
>>>>> +		const struct sockaddr_in6 *const sockaddr_ip6 =
>>>>> +			(struct sockaddr_in6 *)address;
>>>>> +		return ntohs(sockaddr_ip6->sin6_port);
>>>>> +	}
>>>>> +#endif
>>>>> +	}
>>>>> +	WARN_ON_ONCE(1);
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int check_socket_access(struct socket *sock, struct sockaddr *address, int addrlen, u16 port,
>>>>> +			       access_mask_t access_request)
>>>>> +{
>>>>> +	int ret;
>>>>> +	bool allowed = false;
>>>>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>>>> +	const struct landlock_rule *rule;
>>>>> +	access_mask_t handled_access;
>>>>> +	const struct landlock_id id = {
>>>>> +		.key.data = port,
>>>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>>>> +	};
>>>>> +	const struct landlock_ruleset *const domain = get_current_net_domain();
>>>>> +
>>>>> +	if (WARN_ON_ONCE(!domain))
>>>>> +		return 0;
>>>>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>>>>> +		return -EACCES;
>>>>> +	/* Check if it's a TCP socket. */
>>>>> +	if (sock->type != SOCK_STREAM)
>>>>> +		return 0;
>>>>> +
>>>>> +	ret = check_addrlen(address, addrlen);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>> +
>>>>> +	switch (address->sa_family) {
>>>>> +	case AF_UNSPEC:
>>>>> +		/*
>>>>> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
>>>>> +		 * association, which have the same effect as closing the
>>>>> +		 * connection while retaining the socket object (i.e., the file
>>>>> +		 * descriptor).  As for dropping privileges, closing
>>>>> +		 * connections is always allowed.
>>>>> +		 */
>>>>> +		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>>>> +			return 0;
>>>>> +
>>>>> +		/*
>>>>> +		 * For compatibility reason, accept AF_UNSPEC for bind
>>>>> +		 * accesses (mapped to AF_INET) only if the address is
>>>>> +		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
>>>>> +		 * required to not wrongfully return -EACCES instead of
>>>>> +		 * -EAFNOSUPPORT.
>>>>> +		 */
>>>>> +		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
>>>>> +			const struct sockaddr_in *const sockaddr =
>>>>> +				(struct sockaddr_in *)address;
>>>>> +
>>>>> +			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
>>>>> +				return -EAFNOSUPPORT;
>>>>> +		}
>>>>> +
>>>>> +		fallthrough;
>>>>> +	case AF_INET:
>>>>> +#if IS_ENABLED(CONFIG_IPV6)
>>>>> +	case AF_INET6:
>>>>> +#endif
>>>>> +		rule = landlock_find_rule(domain, id);
>>>>> +		handled_access = landlock_init_layer_masks(
>>>>> +			domain, access_request, &layer_masks,
>>>>> +			LANDLOCK_KEY_NET_PORT);
>>>>> +		allowed = landlock_unmask_layers(rule, handled_access,
>>>>> +						 &layer_masks,
>>>>> +						 ARRAY_SIZE(layer_masks));
>>>>> +	}
>>>>> +	return allowed ? 0 : -EACCES;
>>>>> +}
>>>>> +
>>>>> +static int hook_socket_bind(struct socket *sock, struct sockaddr *address,
>>>>> +			    int addrlen)
>>>>> +{ >>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>>>> +				   LANDLOCK_ACCESS_NET_BIND_TCP);
>>
>> get_port() is called before check_addrlen(), which is an issue.
>>
>> You'll find attached a patch for these fixes, please squash it in this
>> one for the next version.
>>
>> I'll send other reviews by the end of the week.
>>
>>
>>>>> +}
>>>>> +
>>>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>>>>> +			       int addrlen)
>>>>> +{
>>>>> +	return check_socket_access(sock, address, addrlen, get_port(address),
>>>>> +				   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>>>> +}
>>>>
>>>> [...]
>>>> .
