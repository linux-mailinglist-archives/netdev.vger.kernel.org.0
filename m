Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5263E1D94
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241239AbhHEUv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:51:58 -0400
Received: from novek.ru ([213.148.174.62]:45760 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhHEUv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:51:57 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D0682503EA8;
        Thu,  5 Aug 2021 23:49:00 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D0682503EA8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1628196542; bh=AvRIgv68spDFkRN2aW/DbsgeWmJgDf2pBShLl7FdmzM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Bhhq3HOYmzhQq6yOimh6laALNHxrARMVnxQZ6MvRYKMspaLze87zjqNsUBploeokM
         eQTRIzPNHZ5NBwUNDYc9TwarCZ4Y/0UFUTiyVuZFx+52hXCIOl0sq4XW4sn0E0wwxG
         jjhASayLtnsGsdKUKTHlhCzPIy/l89da1LrEL4gM=
Subject: Re: [PATCH net] net: ipv4: fix path MTU for multi path routes
To:     David Ahern <dsahern@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210731011729.4357-1-vfedorenko@novek.ru>
 <dc6aafb6-cd1f-2006-6f45-55a4f224e319@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <71b3384d-6d9c-4841-c610-463879f993b2@novek.ru>
Date:   Thu, 5 Aug 2021 21:51:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dc6aafb6-cd1f-2006-6f45-55a4f224e319@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2021 18:12, David Ahern wrote:
> On 7/30/21 7:17 PM, Vadim Fedorenko wrote:
>> Bug 213729 showed that MTU check could be used against route that
>> will not be used in actual transmit if source ip is not specified.
>> But path MTU update is always done on route with defined source ip.
>> Fix route selection by updating flow info in case when source ip
>> is not explicitly defined in raw and udp sockets.
> 
> There is more to it than just setting the source address and doing a
> second lookup.
> 
You are right. Update of source address fixes only some specific cases.
Also, I'm not fun of doing several lookups just because we found additional
next hops. It looks like (for ipv4 case) fib_table_lookup() should select
correct next-hop based on hash and update source ip and output interface
for flowi4. But right now flowi4 is constant and such change looks more
like net-next improvement. Or do you have another solution?

> Attached is a test script I started last summer which shows the problem
> at hand and is setup to cover various permutations of routing (legacy
> routing, nexthop objects, and vrf), network protocols (v4 and v6) and
> should cover tcp, udp and icmp:
> 
> # PMTU handling with multipath routing.
> #
> #          .-- sw1 --.
> #   h1 ----|-- sw2 --|---- h2 -------- h3
> #          |   ...   |       reduced mtu
> #          .-- swN --.
> #
> # h2-h3 segment has reduced mtu.
> # Exceptions created in h1 for h3.
> 
> N=8 (8-way multipath) seems to always demonstrate it; N=2 is a 50-50 chance.
> 
> Snippet from a run this morning:
> 
> # ip netns exec h1 ping -s 1450 10.100.2.254
> PING 10.100.2.254 (10.100.2.254) 1450(1478) bytes of data.
>  From 10.2.22.254 icmp_seq=1 Frag needed and DF set (mtu = 1420)
>  From 10.2.22.254 icmp_seq=2 Frag needed and DF set (mtu = 1420)
>  From 10.2.22.254 icmp_seq=3 Frag needed and DF set (mtu = 1420)
>  From 10.2.22.254 icmp_seq=4 Frag needed and DF set (mtu = 1420)
> 
> ok, an MTU message makes it back to h1, but that it continues shows the
> exception is not created on the right interface:
> 
> # ip -netns h1 ro ls cache
> 10.100.2.254 via 10.1.15.5 dev eth5
>      cache expires 580sec mtu 1420
> 
> But the selected path is:
> # ip -netns h1 ro get 10.100.2.254
> 10.100.2.254 via 10.1.12.2 dev eth2 src 10.1.12.254 uid 0
>      cache
> 
> Adding in the source address does not fix it but it does change the
> selected path. .e.g,
> 
> # ip -netns h1 ro get 10.100.2.254 from 10.1.16.254
> 10.100.2.254 from 10.1.16.254 via 10.1.14.4 dev eth4 uid 0
>      cache
> 
> If 10.1.16.254 is the set source address then egress should be eth6, not
> eth4, since that is an address on eth6.
> 

