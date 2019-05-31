Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ADC316D7
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfEaV6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:58:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfEaV6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 17:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 636DC3084298;
        Fri, 31 May 2019 21:58:02 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4649D1001DCD;
        Fri, 31 May 2019 21:57:55 +0000 (UTC)
Date:   Fri, 31 May 2019 23:57:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "barbette@kth.se" <barbette@kth.se>,
        "toke@redhat.com" <toke@redhat.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, brouer@redhat.com
Subject: Re: Bad XDP performance with mlx5
Message-ID: <20190531235753.3cf8b199@carbon>
In-Reply-To: <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
        <20190529191602.71eb6c87@carbon>
        <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
        <20190530094053.364b1147@carbon>
        <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
        <20190531181817.34039c9f@carbon>
        <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 31 May 2019 21:58:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 31 May 2019 18:06:01 +0000 Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Fri, 2019-05-31 at 18:18 +0200, Jesper Dangaard Brouer wrote:
[...]
> > 
> > To understand why this is happening, you first have to know that the
> > difference is between the two RX-memory modes used by mlx5 for non-
> > XDP vs XDP. With non-XDP two frames are stored per memory-page,
> > while for XDP only a single frame per page is used.  The packets
> > available in the RX- rings are  actually the same, as the ring
> > sizes are non-XDP=512 vs. XDP=1024. 
> 
> Thanks Jesper ! this was a well put together explanation.
> I want to point out that some other drivers are using alloc_skb APIs
> which provide a good caching mechanism, which is even better than the
> mlx5 internal one (which uses the alloc_page APIs directly), this can
> explain the difference, and your explanation shows the root cause of
> the higher cpu util with XDP on mlx5, since the mlx5 page cache works
> with half of its capacity when enabling XDP.
> 
> Now do we really need to keep this page per packet in mlx5 when XDP is
> enabled ? i think it is time to drop that .. 

No, we need to keep the page per packet (at least until, I've solved
some corner-cases with page_pool, which could likely require getting a
page-flag).

> > I believe, the real issue is that TCP use the SKB->truesize (based
> > on frame size) for different memory pressure and window
> > calculations, which is why it solved the issue to increase the
> > window size manually. 

The TCP performance issue is not solely a SKB->truesize issue, but also
an issue with how the driver level page-cache works.  It is actually
very fragile, as single page with elevated refcnt can block the cache
(see mlx5e_rx_cache_get()).  Which easily happens with TCP packets
that is waiting to be re-transmitted in-case of loss.  This is
happening here, as indicated by the rx_cache_busy and rx_cache_full
being the same.

We (Ilias, Tariq and I) have been planning to remove this small driver
cache, and instead use the page_pool, and create a page-return path for
SKBs.  Which should make this problem go away.  I'm going to be working
on this the next couple of weeks (the tricky part is all the corner
cases).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

On Fri, 31 May 2019 18:18:17 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> It was clear that the mlx5 driver page-cache was not working:
>  Ethtool(mlx5p1  ) stat:     6653761 (   6,653,761) <= rx_cache_busy /sec
>  Ethtool(mlx5p1  ) stat:     6653732 (   6,653,732) <= rx_cache_full /sec
>  Ethtool(mlx5p1  ) stat:      669481 (     669,481) <= rx_cache_reuse /sec
>  Ethtool(mlx5p1  ) stat:           1 (           1) <= rx_congst_umr /sec
>  Ethtool(mlx5p1  ) stat:     7323230 (   7,323,230) <= rx_csum_unnecessary /sec
>  Ethtool(mlx5p1  ) stat:        1034 (       1,034) <= rx_discards_phy /sec
>  Ethtool(mlx5p1  ) stat:     7323230 (   7,323,230) <= rx_packets /sec
>  Ethtool(mlx5p1  ) stat:     7324244 (   7,324,244) <= rx_packets_phy /sec


