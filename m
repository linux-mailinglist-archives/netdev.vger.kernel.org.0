Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33541A2821
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgDHRxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 13:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgDHRxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 13:53:47 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E7DF20784;
        Wed,  8 Apr 2020 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586368426;
        bh=z+SPgaHA02z9647wj2ySzrv1EZh+likLpUfJJMD4h/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H/2Bhu39oVVdbAGuBVEIphu6Hu3Qpyy2oYVsKFzF5/pcnLFth+cd+J+/jM95eh0mC
         PfYk3LBHYktjwbJ2pX/JPRVMDQhNM8jqTsRk5ctdTNhBsc9mqVuWeFZs8E5RlgEqzs
         Qf0XL2EO02BI3BuDWQcw/64LZ/lWKWmvfznwTF+k=
Date:   Wed, 8 Apr 2020 10:53:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH RFC v2 19/33] nfp: add XDP frame size to netronome
 driver
Message-ID: <20200408105344.11d1a33f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <158634673086.707275.8905781490793267908.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634673086.707275.8905781490793267908.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Apr 2020 13:52:10 +0200 Jesper Dangaard Brouer wrote:
> The netronome nfp driver already had a true_bufsz variable
> that contains what was needed for xdp.frame_sz.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  .../net/ethernet/netronome/nfp/nfp_net_common.c    |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index 9bfb3b077bc1..b9b8c30eab33 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -1817,6 +1817,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
>  	rcu_read_lock();
>  	xdp_prog = READ_ONCE(dp->xdp_prog);
>  	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
> +	xdp.frame_sz = true_bufsz;

Since this matters only with XDP on - we can set to PAGE_SIZE directly?

But more importantly the correct value is:

	PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM

as we set hard_start at an offset. 

	xdp.data_hard_start = rxbuf->frag + NFP_NET_RX_BUF_HEADROOM;

Cause NFP_NET_RX_BUF_HEADROOM is not DMA mapped.

>  	xdp.rxq = &rx_ring->xdp_rxq;
>  	tx_ring = r_vec->xdp_ring;
