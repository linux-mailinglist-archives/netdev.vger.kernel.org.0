Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47976EF61A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbjDZOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241091AbjDZOPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:15:33 -0400
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CEC6A79
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:15:31 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Q619Y5NhJzMq20C;
        Wed, 26 Apr 2023 16:15:29 +0200 (CEST)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Q619Y0BqHz1C3;
        Wed, 26 Apr 2023 16:15:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1682518529;
        bh=FcZefFzib5MfGlesa1STquGjF77TMrAHm6Rc4XBvbgg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=asRumu1lxURvTBi1FJdnBXmIBRxcUKrN2uLXAaKuIq9iKmnLbsjL+Hxvx58rBFBbK
         +5aOAIg0ipTOQj53T+EKQkH9tUqRAKTaCLOIbdjc6+jCkk0R3pRFFBiId95P4TRzxP
         sX97wtguz6vHJhTwKYrKTAryGHNU9u0MUtZ4ZVfw=
Message-ID: <8db42d8b-1ed0-6b00-de5b-57f350472160@digikod.net>
Date:   Wed, 26 Apr 2023 16:15:28 +0200
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
 <9147b444-dec4-52c3-c724-f19b3f842738@digikod.net>
 <07629a06-935c-debf-d490-e02e5ee9f9ec@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <07629a06-935c-debf-d490-e02e5ee9f9ec@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/04/2023 11:39, Konstantin Meskhidze (A) wrote:
> 
> 
> 4/16/2023 7:11 PM, Mickaël Salaün пишет:
>>
>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>> This commit adds network rules support in the ruleset management
>>> helpers and the landlock_create_ruleset syscall.
>>> Refactor user space API to support network actions. Add new network
>>> access flags, network rule and network attributes. Increment Landlock
>>> ABI version. Expand access_masks_t to u32 to be sure network access
>>> rights can be stored. Implement socket_bind() and socket_connect()
>>> LSM hooks, which enable to restrict TCP socket binding and connection
>>
>> "which enables to"
>>
>      Got it.
>>
>>> to specific ports.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---

[...]

>>> +static u16 get_port(const struct sockaddr *const address)
>>> +{
>>> +	/* Gets port value in host byte order. */
>>> +	switch (address->sa_family) {
>>> +	case AF_UNSPEC:
>>> +	case AF_INET: {
>>> +		const struct sockaddr_in *const sockaddr =
>>> +			(struct sockaddr_in *)address;
>>> +		return ntohs(sockaddr->sin_port);
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
>>
>> As explained above, this should be replaced with:
>>
>> if (addrlen < offsetofend(struct sockaddr, sa_family))
>> 	return -EINVAL;
>>
>     Ok.
>>
>>> +
>>> +	switch (address->sa_family) {
>>
>>
>> This below block should be moved after the generic switch statement
>> (i.e. once port is checked).
>>
>     Do you mean checking address family after a port has been checked??


These specific AF_UNSPEC checks should be in an `if (address->sa_family 
== AF_UNSPEC)` block after the generic AF_UNSPEC, AF_INET, and AF_INET6 
checks in the address->sa_family switch/case, because the checks and 
errors order must be consistent whatever the sa_family. The AF_UNSPEC 
checks are really an exception to the AF_INET ones, and should then come 
after.

This may look like this:

switch (address->sa_family) {
case AF_UNSPEC:
case AF_INET:
	port = ...;
	break;
#if IS_ENABLED(CONFIG_IPV6)
	case AF_INET6:
	port = ...;
	break;
#endif
default:
	return 0;
}

/* Specific AF_UNSPEC handling. */
if (address->sa_family == AF_UNSPEC) {
	...
	if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
		return 0;
	...
}

id.key.data = (__force uintptr_t)port;
BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));

rule = landlock_find_rule(domain, id);
handled_access = landlock_init_layer_masks(
	domain, access_request, &layer_masks,
	LANDLOCK_KEY_NET_PORT);
if (landlock_unmask_layers(rule, handled_access,
				 &layer_masks,
				 ARRAY_SIZE(layer_masks)))
	return 0;

return -EACCES;





> 
>>
>>
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
>>
>>
>>
>> case AF_UNSPEC:
>>
>>> +	case AF_INET:
>>
>> if (addrlen < sizeof(struct sockaddr_in))
>> 	return -EINVAL;
>>
>> port = ((struct sockaddr_in *)address)->sin_port;
>> break;
>>
>>
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>
>> if (addrlen < SIN6_LEN_RFC2133)
>> 	return -EINVAL;
>>
>> port = ((struct sockaddr_in6 *)address)->sin6_port;
>> break;
>>
>>
>>> +#endif
>>
>> /* Allows unhandled protocols. */
>> default:
>> 	return 0;
>> }
>>
>> if (address->sa_family == AF_UNSPEC) {
>>
>> // Add here the above AF_UNSPEC checks to be consistent with the
>> EINVAL/EAFNOSUPPORT return ordering.
>>
>> }
>>
>> id.key.data = (__force uintprt_t)port;
>> BUID_BUG_ON(...);
>>
>     Will be refactored. Thanks.
