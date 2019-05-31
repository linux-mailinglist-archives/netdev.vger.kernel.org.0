Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93E83121F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfEaQS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfEaQS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 12:18:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 198BF30842A8;
        Fri, 31 May 2019 16:18:26 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 060925DE89;
        Fri, 31 May 2019 16:18:18 +0000 (UTC)
Date:   Fri, 31 May 2019 18:18:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tom Barbette <barbette@kth.se>
Cc:     xdp-newbies@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Bad XDP performance with mlx5
Message-ID: <20190531181817.34039c9f@carbon>
In-Reply-To: <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
        <20190529191602.71eb6c87@carbon>
        <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
        <20190530094053.364b1147@carbon>
        <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 31 May 2019 16:18:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 31 May 2019 08:51:43 +0200 Tom Barbette <barbette@kth.se> wrote:

> CCing mlx5 maintainers and commiters of bce2b2b. TLDK: there is a huge 
> CPU increase on CX5 when introducing a XDP program.
>
> See https://www.youtube.com/watch?v=o5hlJZbN4Tk&feature=youtu.be
> around 0:40. We're talking something like 15% while it's near 0 for
> other drivers. The machine is a recent Skylake. For us it makes XDP
> unusable. Is that a known problem?

I have a similar test setup, and I can reproduce. I have found the
root-cause see below.  But on my system it was even worse, with an
XDP_PASS program loaded, and iperf (6 parallel TCP flows) I would see
100% CPU usage and total 83.3 Gbits/sec. With non-XDP case, I saw 58%
CPU (43% idle) and total 89.7 Gbits/sec.

 
> I wonder if it doesn't simply come from mlx5/en_main.c:
> rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> 

Nope, that is not the problem.

> Which would be inline from my observation that memory access seems 
> heavier. I guess this is for the XDP_TX case.
> 
> If this is indeed the problem. Any chance we can:
> a) detect automatically that a program will not return XDP_TX (I'm not 
> quite sure about what the BPF limitations allow to guess in advance) or
> b) add a flag to such as XDP_FLAGS_NO_TX to avoid such hit in 
> performance when not needed?

This was kind of hard to root-cause, but I solved it by increasing the TCP
socket size used by the iperf tool, like this (please reproduce):

$ iperf -s --window 4M
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  416 KByte (WARNING: requested 4.00 MByte)
------------------------------------------------------------

Given I could reproduce, I took at closer look at perf record/report stats,
and it was actually quite clear that this was related to stalling on getting
pages from the page allocator (function calls top#6 get_page_from_freelist
and free_pcppages_bulk).

Using my tool: ethtool_stats.pl
 https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_stats.pl

It was clear that the mlx5 driver page-cache was not working:
 Ethtool(mlx5p1  ) stat:     6653761 (   6,653,761) <= rx_cache_busy /sec
 Ethtool(mlx5p1  ) stat:     6653732 (   6,653,732) <= rx_cache_full /sec
 Ethtool(mlx5p1  ) stat:      669481 (     669,481) <= rx_cache_reuse /sec
 Ethtool(mlx5p1  ) stat:           1 (           1) <= rx_congst_umr /sec
 Ethtool(mlx5p1  ) stat:     7323230 (   7,323,230) <= rx_csum_unnecessary /sec
 Ethtool(mlx5p1  ) stat:        1034 (       1,034) <= rx_discards_phy /sec
 Ethtool(mlx5p1  ) stat:     7323230 (   7,323,230) <= rx_packets /sec
 Ethtool(mlx5p1  ) stat:     7324244 (   7,324,244) <= rx_packets_phy /sec

While the non-XDP case looked like this:
 Ethtool(mlx5p1  ) stat:      298929 (     298,929) <= rx_cache_busy /sec
 Ethtool(mlx5p1  ) stat:      298971 (     298,971) <= rx_cache_full /sec
 Ethtool(mlx5p1  ) stat:     3548789 (   3,548,789) <= rx_cache_reuse /sec
 Ethtool(mlx5p1  ) stat:     7695476 (   7,695,476) <= rx_csum_complete /sec
 Ethtool(mlx5p1  ) stat:     7695476 (   7,695,476) <= rx_packets /sec
 Ethtool(mlx5p1  ) stat:     7695169 (   7,695,169) <= rx_packets_phy /sec
Manual consistence calc: 7695476-((3548789*2)+(298971*2)) = -44

With the increased TCP window size, the mlx5 driver cache is working better,
but not optimally, see below. I'm getting 88.0 Gbits/sec with 68% CPU usage.
 Ethtool(mlx5p1  ) stat:      894438 (     894,438) <= rx_cache_busy /sec
 Ethtool(mlx5p1  ) stat:      894453 (     894,453) <= rx_cache_full /sec
 Ethtool(mlx5p1  ) stat:     6638518 (   6,638,518) <= rx_cache_reuse /sec
 Ethtool(mlx5p1  ) stat:           6 (           6) <= rx_congst_umr /sec
 Ethtool(mlx5p1  ) stat:     7532983 (   7,532,983) <= rx_csum_unnecessary /sec
 Ethtool(mlx5p1  ) stat:         164 (         164) <= rx_discards_phy /sec
 Ethtool(mlx5p1  ) stat:     7532983 (   7,532,983) <= rx_packets /sec
 Ethtool(mlx5p1  ) stat:     7533193 (   7,533,193) <= rx_packets_phy /sec
Manual consistence calc: 7532983-(6638518+894453) = 12

To understand why this is happening, you first have to know that the
difference is between the two RX-memory modes used by mlx5 for non-XDP vs
XDP. With non-XDP two frames are stored per memory-page, while for XDP only
a single frame per page is used.  The packets available in the RX-rings are
actually the same, as the ring sizes are non-XDP=512 vs. XDP=1024.

I believe, the real issue is that TCP use the SKB->truesize (based on frame
size) for different memory pressure and window calculations, which is why it
solved the issue to increase the window size manually.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
