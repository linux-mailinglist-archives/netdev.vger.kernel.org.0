Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF91563B3CC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiK1VBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiK1VBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:01:06 -0500
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A412D20347
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:01:01 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLdDC66VQzMpnfG;
        Mon, 28 Nov 2022 22:00:59 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLdDC0lNdzMppBY;
        Mon, 28 Nov 2022 22:00:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669669259;
        bh=/1ZK7U9AzdLPF2AzAv3gVXDTqS8e0Pql7sOQaGFCoj8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h5DVGB+sEU0SPVa/H8FPfV9BLrjIOopwRqVm7HVnryhfe6hS/lq9VbiReGQ1rP274
         hfdpcSg1QNbQlEktf+unfFj9bc3X0/zjpqJDdbxnRO2gSgB8zLKQh9tP3c8wJ0oed/
         8icgp58Dov6ZP3tzdkQw3VaLSx0A9QggznS98KfM=
Message-ID: <6071d053-a4b4-61f0-06f6-f94e6ce1e6d6@digikod.net>
Date:   Mon, 28 Nov 2022 22:00:58 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 08/12] landlock: Implement TCP network hooks
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com,
        linux-api@vger.kernel.org,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-9-konstantin.meskhidze@huawei.com>
 <3452964b-04d3-b297-92a1-1220e087323e@digikod.net>
 <335a5372-e444-5deb-c04d-664cbc7cdc2e@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <335a5372-e444-5deb-c04d-664cbc7cdc2e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit provides an interface to theoretically restrict 
network access (i.e. ruleset handled network accesses), but in fact this 
is not enforced until this commit. I like this split but to avoid any 
inconsistency, please squash this commit into the previous one: "7/12 
landlock: Add network rules support"
You should keep all the commit messages but maybe tweak them a bit.


On 28/11/2022 09:21, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> This patch adds support of socket_bind() and socket_connect() hooks.
>>> It's possible to restrict binding and connecting of TCP sockets to
>>> particular ports.
>>
>> Implement socket_bind() and socket_connect LSM hooks, which enable to
>> restrict TCP socket binding and connection to specific ports.
>>
>     Ok. Thanks.
>>
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---

[...]

>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>>> +			       int addrlen)
>>> +{
>>> +	const struct landlock_ruleset *const dom =
>>> +		landlock_get_current_domain();
>>> +
>>> +	if (!dom)
>>> +		return 0;
>>> +
>>> +	/* Check if it's a TCP socket. */
>>> +	if (sock->type != SOCK_STREAM)
>>> +		return 0;
>>> +
>>> +	/* Check if the hook is AF_INET* socket's action. */
>>> +	switch (address->sa_family) {
>>> +	case AF_INET:
>>> +#if IS_ENABLED(CONFIG_IPV6)
>>> +	case AF_INET6:
>>> +#endif
>>> +		return check_socket_access(dom, get_port(address),
>>> +					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>> +	case AF_UNSPEC: {
>>> +		u16 i;
>>
>> You can move "i" after the "dom" declaration to remove the extra braces.
>>
>     Ok. Thanks.
>>
>>> +
>>> +		/*
>>> +		 * If just in a layer a mask supports connect access,
>>> +		 * the socket_connect() hook with AF_UNSPEC family flag
>>> +		 * must be banned. This prevents from disconnecting already
>>> +		 * connected sockets.
>>> +		 */
>>> +		for (i = 0; i < dom->num_layers; i++) {
>>> +			if (landlock_get_net_access_mask(dom, i) &
>>> +			    LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>> +				return -EACCES;
>>
>> I'm wondering if this is the right error code for this case. EPERM may
>> be more appropriate.
> 
>     Ok. Will be refactored.
>>
>> Thinking more about this case, I don't understand what is the rationale
>> to deny such action. What would be the consequence to always allow
>> connection with AF_UNSPEC (i.e. to disconnect a socket)?
>>
>     I thought we have come to a conclusion about connect(...AF_UNSPEC..)
>    behaviour in the patchset V3:
> https://lore.kernel.org/linux-security-module/19ad3a01-d76e-0e73-7833-99acd4afd97e@huawei.com/

The conclusion was that AF_UNSPEC disconnects a socket, but I'm asking 
if this is a security issue. I don't think it is more dangerous than a 
new (unconnected) socket. Am I missing something? Which kind of rule 
could be bypassed? What are we protecting against by restricting AF_UNSPEC?

We could then reduce the hook codes to just:
return current_check_access_socket(sock, address, LANDLOCK_ACCESS_NET_*);
