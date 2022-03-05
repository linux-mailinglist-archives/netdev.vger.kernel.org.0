Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72ED4CE5FD
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiCEQrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:47:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5DC972E7
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0511761444
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEEFC004E1;
        Sat,  5 Mar 2022 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646498800;
        bh=EVEOzz8gM111qognXzH8HSnGN8ujCIaWB3fF0jOMWs4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=r2QNBn9A47F1+pVWudeV50zBSIeXmtTBwW+8dy3m5BlTueAaQDZwbbofDmLh2PoOo
         v3dO4k6LsoCZ1kHhO1//Y4uEYuiD41wsNoxmQBytLNV/rxL2JYrNf8BrGuFFy5qM9v
         rQBzZJ9BlVsZzDmJq3k6DPQzIVe8Fm/voodS3SlEPVrpcJ4j9dpk8Mtxx835amW6uf
         HvAIm94jUesoM4Y03YhoMnT1wPucDS/p2f81N1qeZvRXXmmxPhWNomx9lFYumcFhuq
         +3vAz1vw7LYc/8OCysaSUWaZ1CY7kqKEngQ6IPTew/UVyAdfURWUHDJfnndlMq2MCj
         DwD8cKtYHS38w==
Message-ID: <b66106e0-4bd6-e2ae-044d-e48c22546c87@kernel.org>
Date:   Sat, 5 Mar 2022 09:46:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com>
 <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <CANn89iL2gXRsnC20a+=YJ+Ug=3x_jacmtL+S269_0g+E0wDYSQ@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iL2gXRsnC20a+=YJ+Ug=3x_jacmtL+S269_0g+E0wDYSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/22 10:47 AM, Eric Dumazet wrote:
> On Thu, Mar 3, 2022 at 8:33 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 3/3/22 11:16 AM, Eric Dumazet wrote:
>>> From: Coco Li <lixiaoyan@google.com>
>>>
>>> Instead of simply forcing a 0 payload_len in IPv6 header,
>>> implement RFC 2675 and insert a custom extension header.
>>>
>>> Note that only TCP stack is currently potentially generating
>>> jumbograms, and that this extension header is purely local,
>>> it wont be sent on a physical link.
>>>
>>> This is needed so that packet capture (tcpdump and friends)
>>> can properly dissect these large packets.
>>>
>>
>>
>> I am fairly certain I know how you are going to respond, but I will ask
>> this anyways :-) :
>>
>> The networking stack as it stands today does not care that skb->len >
>> 64kB and nothing stops a driver from setting max gso size to be > 64kB.
>> Sure, packet socket apps (tcpdump) get confused but if the h/w supports
>> the larger packet size it just works.
> 
> Observability is key. "just works" is a bold claim.
> 
>>
>> The jumbogram header is getting adding at the L3/IPv6 layer and then
>> removed by the drivers before pushing to hardware. So, the only benefit
>> of the push and pop of the jumbogram header is for packet sockets and
>> tc/ebpf programs - assuming those programs understand the header
>> (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
>> it is a standard header so apps have a chance to understand the larger
>> packet size, but what is the likelihood that random apps or even ebpf
>> programs will understand it?
> 
> Can you explain to me what you are referring to by " random apps" exactly ?
> TCP does not expose to user space any individual packet length.

TCP apps are not affected; they do not have direct access to L3 headers.
This is about packet sockets and ebpf programs and their knowledge of
the HBH header. This does not seem like a widely used feature and even
tcpdump only recently gained support for it (e.g.,  Ubuntu 20.04 does
not support it, 21.10 does). Given that what are the odds most packet
programs are affected by the change and if they need to have support we
could just as easily add that support in a way that gets both networking
layers working.

> 
> 
> 
>>
>> Alternative solutions to the packet socket (ebpf programs have access to
>> skb->len) problem would allow IPv4 to join the Big TCP party. I am
>> wondering how feasible an alternative solution is to get large packet
>> sizes across the board with less overhead and changes.
> 
> You know, I think I already answered this question 6 months ago.
> 
> We need to carry an extra metadata to carry how much TCP payload is in a packet,
> both on RX and TX side.
> 
> Adding an skb field for that was not an option for me.

Why? skb->len is not limited to a u16. The only affect is when skb->len
is used to fill in the ipv4/ipv6 header.

> 
> Adding a 8 bytes header is basically free, the headers need to be in cpu caches
> when the header is added/removed.
> 
> This is zero cost on current cpus, compared to the gains.
> 
> I think you focus on TSO side, which is only 25% of the possible gains
> that BIG TCP was seeking for.
> 
> We covered both RX and TX with a common mechanism.

