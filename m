Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BB06DE0C7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjDKQP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjDKQPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C9572A1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D61FD6290C
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 16:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E58C433EF;
        Tue, 11 Apr 2023 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681229623;
        bh=h086mKIZSUNWZ+vWa77OK9mUOGmn/lVxERkEiKWN1YU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uZudd/XWQannejx01ig2ZJMSFLORf3bolrw8VngoBXS8MHUsAnnSH2jRZG/nw81Tv
         SoEmAqTkzSoyr3wL+gNkqz1aVhnZruWveKCZrpncqVCKDkhvBQaAanuPumC4cwOrDI
         hDUPxNUgH6S0bD+16IcI3IXOOMn16xtR6fS5vV36aAx0X8ZZiTOT9oGg0yoqaL3jqr
         sisKqX/4P/Mxs1r30CMAaV1n4Kk0qFPBVknB74/h3W8hR1rxxajXBuY78jZMLBrzBE
         xrWRGWQ2CAI5IJsrSo5lvIee6peYcTYUPqQp/VyMpEqmX7okkonFs5Rif6TGMDOll4
         3pZB/xAFaQpnQ==
Date:   Tue, 11 Apr 2023 10:13:41 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Matt Whitlock <kernel@mattwhitlock.name>
Cc:     netdev@vger.kernel.org
Subject: Re: Memory leak in __ip6_rt_update_pmtu (net/ipv6/route.c)
Message-ID: <20230411161341.GA26208@u2004-local>
References: <241aa97b-4e6a-4b57-a80b-8f711c135b91@mattwhitlock.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241aa97b-4e6a-4b57-a80b-8f711c135b91@mattwhitlock.name>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 04:03:29PM -0400, Matt Whitlock wrote:
> Found while running 6.1.23-gentoo with kmemleak while trying to diagnose a
> probably unrelated memory leak:
> 
> unreferenced object 0xffff888042fc7b00 (size 256):
>  comm "softirq", pid 0, jiffies 4328682724 (age 5739.246s)
>  hex dump (first 32 bytes):
>    00 80 4d 01 81 88 ff ff 00 49 e3 94 ff ff ff ff  ..M......I......
>    60 ef 70 b5 81 88 ff ff a4 9c 0b 02 01 00 00 00  `.p.............
>  backtrace:
>    [<000000000b4f8d52>] dst_alloc+0x3c/0x140
>    [<0000000075b21562>] ip6_rt_cache_alloc.constprop.0+0x7b/0x190
>    [<00000000236d18fe>] __ip6_rt_update_pmtu+0x119/0x250
>    [<00000000e4b766f3>] inet6_csk_update_pmtu+0x42/0x80
>    [<00000000b86e1f12>] tcp_v6_mtu_reduced+0x35/0x80
>    [<00000000a854cc14>] tcp_v6_err+0x41f/0x480
>    [<00000000eff3ef2f>] icmpv6_notify+0xbb/0x180
>    [<00000000e4924371>] icmpv6_rcv+0x34a/0x3d0
>    [<000000007163d548>] ip6_protocol_deliver_rcu+0x75/0x3b0
>    [<00000000fdb6a323>] ip6_input_finish+0x35/0x60
>    [<00000000ebde6920>] ip6_sublist_rcv_finish+0x2d/0x40
>    [<00000000105dd24d>] ip6_sublist_rcv+0x191/0x210
>    [<00000000e87845f8>] ipv6_list_rcv+0xed/0x100
>    [<00000000206d66ad>] __netif_receive_skb_list_core+0x16c/0x1c0
>    [<0000000000117935>] netif_receive_skb_list_internal+0x173/0x270
>    [<00000000ea0594e7>] napi_complete_done+0x69/0x170
> unreferenced object 0xffff8881b570ef60 (size 96):
>  comm "softirq", pid 0, jiffies 4328682724 (age 5739.246s)
>  hex dump (first 32 bytes):
>    00 00 00 00 c8 05 00 00 00 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<00000000adeef916>] kmalloc_trace+0x11/0x20
>    [<000000002752b81a>] dst_cow_metrics_generic+0x22/0x100
>    [<00000000b9c32bc3>] rt6_do_update_pmtu+0x34/0xb0
>    [<00000000c53e4e49>] __ip6_rt_update_pmtu+0x12c/0x250
>    [<00000000e4b766f3>] inet6_csk_update_pmtu+0x42/0x80
>    [<00000000b86e1f12>] tcp_v6_mtu_reduced+0x35/0x80
>    [<00000000a854cc14>] tcp_v6_err+0x41f/0x480
>    [<00000000eff3ef2f>] icmpv6_notify+0xbb/0x180
>    [<00000000e4924371>] icmpv6_rcv+0x34a/0x3d0
>    [<000000007163d548>] ip6_protocol_deliver_rcu+0x75/0x3b0
>    [<00000000fdb6a323>] ip6_input_finish+0x35/0x60
>    [<00000000ebde6920>] ip6_sublist_rcv_finish+0x2d/0x40
>    [<00000000105dd24d>] ip6_sublist_rcv+0x191/0x210
>    [<00000000e87845f8>] ipv6_list_rcv+0xed/0x100
>    [<00000000206d66ad>] __netif_receive_skb_list_core+0x16c/0x1c0
>    [<0000000000117935>] netif_receive_skb_list_internal+0x173/0x270
> 
> Note: The bottom object is referenced by the top object. (Look in the hex
> dump to see the address 0xffff8881b570ef60 in little-endian byte order at
> offset 16.)
> 
> To my unfamiliar eyes this would appear to be the most suspect bit of code
> (in __ip6_rt_update_pmtu at net/ipv6/route.c:2907):
> 
> 	nrt6 = ip6_rt_cache_alloc(&res, daddr, saddr);
> 	if (nrt6) {
> 		rt6_do_update_pmtu(nrt6, mtu);
> 		if (rt6_insert_exception(nrt6, &res))
> 			dst_release_immediate(&nrt6->dst);
> 	}
> 
> If rt6_insert_exception returns an error, we release the struct dst_entry
> (nrt6->dst), but what about the struct rt6_info (*nrt6) that we just
> allocated?

rt6_info is a container of dst_entry. As the stack trace above shows,
ip6_rt_cache_alloc -> dst_alloc. ie., freeing the dst_entry frees the
rt6_info.
