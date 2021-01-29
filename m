Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F66308FBE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhA2WCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhA2WCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 17:02:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7605664D7F;
        Fri, 29 Jan 2021 22:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957681;
        bh=VC+OT4kyfgmZZcdKlfJ2Gu/2uwTNCfc3tfNRXYWunFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m7GGZi45DfINPk8PuhRCyyE6Z18P9X8dqT08fZWZWK3xPnI/B+8xdYgDisPxUsZnh
         VkVivp81JLTQyrzeQy9f58X1qqKrFCFXFMXsNVEYBVkQDU/8DmougJeZhQzFI5oM9b
         dsP1WH4gnVUdd028wRMFFPeg2EXB/HVPLNUua/SaZkj//3Xtti0xU/ZX0SMLUVwP05
         PD32lUnXwG7GPIuoyyzEy/gQWm30pnOpIUH4XY4SlfigPRB6Gv0pFvzif2dpo84c5d
         z2t3YetPsV0qsbrDuO9MuaUVyAhOO/72F55wZ/cl+8Wg5SYnOq1B6PtkoPOdHlnfjX
         c5kiPO0G0144Q==
Date:   Fri, 29 Jan 2021 14:01:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        Anders =?UTF-8?B?UsO4bm5pbmdlbg==?= <anders@ronningen.priv.no>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Message-ID: <20210129140120.29ae5062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129195240.31871-2-TheSven73@gmail.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
        <20210129195240.31871-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 14:52:35 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The buffers in the lan743x driver's receive ring are always 9K,
> even when the largest packet that can be received (the mtu) is
> much smaller. This performs particularly badly on cpu archs
> without dma cache snooping (such as ARM): each received packet
> results in a 9K dma_{map|unmap} operation, which is very expensive
> because cpu caches need to be invalidated.
> 
> Careful measurement of the driver rx path on armv7 reveals that
> the cpu spends the majority of its time waiting for cache
> invalidation.
> 
> Optimize as follows:
> 
> 1. set rx ring buffer size equal to the mtu. this limits the
>    amount of cache that needs to be invalidated per dma_map().
> 
> 2. when dma_unmap()ping, skip cpu sync. Sync only the packet data
>    actually received, the size of which the chip will indicate in
>    its rx ring descriptors. this limits the amount of cache that
>    needs to be invalidated per dma_unmap().
> 
> These optimizations double the rx performance on armv7.
> Third parties report 3x rx speedup on armv8.
> 
> Performance on dma cache snooping architectures (such as x86)
> is expected to stay the same.
> 
> Tested with iperf3 on a freescale imx6qp + lan7430, both sides
> set to mtu 1500 bytes, measure rx performance:
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec   550 MBytes   231 Mbits/sec    0
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-20.00  sec  1.33 GBytes   570 Mbits/sec    0
> 
> Test by Anders Roenningen (anders@ronningen.priv.no) on armv8,
>     rx iperf3:
> Before 102 Mbits/sec
> After  279 Mbits/sec
> 
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

You may need to rebase to see this:

drivers/net/ethernet/microchip/lan743x_main.c:2123:41: warning: restricted __le32 degrades to integer
