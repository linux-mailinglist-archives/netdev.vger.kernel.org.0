Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11874CCC94
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiCDEec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiCDEeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:34:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251B07E09B
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 20:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B892B61B2D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517BEC340E9;
        Fri,  4 Mar 2022 04:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646368423;
        bh=ms5gbFrkn1tBhmSYGgFLRPeodsPSp/ox0qL8N7ANDOQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ur3g5y3/o2S8eBXZKR6Ml/uUAVstB53Fasy0u5ltzwoSIwvx2jRb7LbTbpfk9mkk5
         ZKRatQYgxt1nuZe9pEyrj9Mua9r2fETZbGsuq9P0P66rl0EAbw7J/6ljwMAqU8xPvq
         SpN9X66xa91Q3U1i3CQbnEuMkzfWYm9GjXw477khrrZ8KxPDcAXD2eb7bxBw6czu4t
         blQIqKK7qOMg4nCegKoQ+kYofejHdwymbj9qvKjLxQ/IeVm1eEY4f8+z4q8bHNlqqG
         PVuaYyzJD0i3zfMPN69jOadOARN2FavsfzotZbqTz43kE1gDtHjQ8lKT6+m6vAMOO6
         MatP+mKM3ERXg==
Message-ID: <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
Date:   Thu, 3 Mar 2022 21:33:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220303181607.1094358-9-eric.dumazet@gmail.com>
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

On 3/3/22 11:16 AM, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Instead of simply forcing a 0 payload_len in IPv6 header,
> implement RFC 2675 and insert a custom extension header.
> 
> Note that only TCP stack is currently potentially generating
> jumbograms, and that this extension header is purely local,
> it wont be sent on a physical link.
> 
> This is needed so that packet capture (tcpdump and friends)
> can properly dissect these large packets.
> 


I am fairly certain I know how you are going to respond, but I will ask
this anyways :-) :

The networking stack as it stands today does not care that skb->len >
64kB and nothing stops a driver from setting max gso size to be > 64kB.
Sure, packet socket apps (tcpdump) get confused but if the h/w supports
the larger packet size it just works.

The jumbogram header is getting adding at the L3/IPv6 layer and then
removed by the drivers before pushing to hardware. So, the only benefit
of the push and pop of the jumbogram header is for packet sockets and
tc/ebpf programs - assuming those programs understand the header
(tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
it is a standard header so apps have a chance to understand the larger
packet size, but what is the likelihood that random apps or even ebpf
programs will understand it?

Alternative solutions to the packet socket (ebpf programs have access to
skb->len) problem would allow IPv4 to join the Big TCP party. I am
wondering how feasible an alternative solution is to get large packet
sizes across the board with less overhead and changes.

