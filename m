Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8ED63FE8E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiLBDNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLBDN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:13:29 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C340989303;
        Thu,  1 Dec 2022 19:13:27 -0800 (PST)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNdGx2wBmz67xX3;
        Fri,  2 Dec 2022 11:10:17 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Fri, 2 Dec 2022 04:13:25 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 03:13:24 +0000
Message-ID: <56f9af17-f824-ff5d-7fee-8de0ae520cc2@huawei.com>
Date:   Fri, 2 Dec 2022 06:13:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 08/12] landlock: Implement TCP network hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>,
        <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-9-konstantin.meskhidze@huawei.com>
 <3452964b-04d3-b297-92a1-1220e087323e@digikod.net>
 <335a5372-e444-5deb-c04d-664cbc7cdc2e@huawei.com>
 <6071d053-a4b4-61f0-06f6-f94e6ce1e6d6@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <6071d053-a4b4-61f0-06f6-f94e6ce1e6d6@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/29/2022 12:00 AM, Mickaël Salaün пишет:
> The previous commit provides an interface to theoretically restrict
> network access (i.e. ruleset handled network accesses), but in fact this
> is not enforced until this commit. I like this split but to avoid any
> inconsistency, please squash this commit into the previous one: "7/12
> landlock: Add network rules support"
> You should keep all the commit messages but maybe tweak them a bit.
> 
   Ok. Will be squashed.
> 
> On 28/11/2022 09:21, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
>>>
>>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>>> This patch adds support of socket_bind() and socket_connect() hooks.
>>>> It's possible to restrict binding and connecting of TCP sockets to
>>>> particular ports.
>>>
>>> Implement socket_bind() and socket_connect LSM hooks, which enable to
>>> restrict TCP socket binding and connection to specific ports.
>>>
>>     Ok. Thanks.
>>>
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
> 
> [...]
> 
>>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address,
>>>> +			       int addrlen)
>>>> +{
>>>> +	const struct landlock_ruleset *const dom =
>>>> +		landlock_get_current_domain();
>>>> +
>>>> +	if (!dom)
>>>> +		return 0;
>>>> +
>>>> +	/* Check if it's a TCP socket. */
>>>> +	if (sock->type != SOCK_STREAM)
>>>> +		return 0;
>>>> +
>>>> +	/* Check if the hook is AF_INET* socket's action. */
>>>> +	switch (address->sa_family) {
>>>> +	case AF_INET:
>>>> +#if IS_ENABLED(CONFIG_IPV6)
>>>> +	case AF_INET6:
>>>> +#endif
>>>> +		return check_socket_access(dom, get_port(address),
>>>> +					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>>> +	case AF_UNSPEC: {
>>>> +		u16 i;
>>>
>>> You can move "i" after the "dom" declaration to remove the extra braces.
>>>
>>     Ok. Thanks.
>>>
>>>> +
>>>> +		/*
>>>> +		 * If just in a layer a mask supports connect access,
>>>> +		 * the socket_connect() hook with AF_UNSPEC family flag
>>>> +		 * must be banned. This prevents from disconnecting already
>>>> +		 * connected sockets.
>>>> +		 */
>>>> +		for (i = 0; i < dom->num_layers; i++) {
>>>> +			if (landlock_get_net_access_mask(dom, i) &
>>>> +			    LANDLOCK_ACCESS_NET_CONNECT_TCP)
>>>> +				return -EACCES;
>>>
>>> I'm wondering if this is the right error code for this case. EPERM may
>>> be more appropriate.
>> 
>>     Ok. Will be refactored.
>>>
>>> Thinking more about this case, I don't understand what is the rationale
>>> to deny such action. What would be the consequence to always allow
>>> connection with AF_UNSPEC (i.e. to disconnect a socket)?
>>>
>>     I thought we have come to a conclusion about connect(...AF_UNSPEC..)
>>    behaviour in the patchset V3:
>> https://lore.kernel.org/linux-security-module/19ad3a01-d76e-0e73-7833-99acd4afd97e@huawei.com/
> 
> The conclusion was that AF_UNSPEC disconnects a socket, but I'm asking
> if this is a security issue. I don't think it is more dangerous than a
> new (unconnected) socket. Am I missing something? Which kind of rule
> could be bypassed? What are we protecting against by restricting AF_UNSPEC?

I just follow Willem de Bruijn concerns about this issue:

quote: "It is valid to pass an address with AF_UNSPEC to a PF_INET(6) 
socket. And there are legitimate reasons to want to deny this. Such as 
passing a connection to a unprivileged process and disallow it from 
disconnect and opening a different new connection."

https://lore.kernel.org/linux-security-module/CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com/


quote: "The intended use-case is for a privileged process to open a 
connection (i.e., bound and connected socket) and pass that to a 
restricted process. The intent is for that process to only be allowed to
communicate over this pre-established channel.

In practice, it is able to disconnect (while staying bound) and
elevate its privileges to that of a listening server: ..."

https://lore.kernel.org/linux-security-module/CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com/

Looks like it's a security issue here.

> 
> We could then reduce the hook codes to just:
> return current_check_access_socket(sock, address, LANDLOCK_ACCESS_NET_*);
> .
