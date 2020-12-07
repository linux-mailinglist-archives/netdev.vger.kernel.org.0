Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A086E2D08F1
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 02:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgLGBwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 20:52:39 -0500
Received: from mga07.intel.com ([134.134.136.100]:58125 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgLGBwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 20:52:39 -0500
IronPort-SDR: 0vet0LMhVY8pvDX+I3hPbmCMOrHmddmro/ThQcS3ujHnK/w0wOSVoZlrlNYSqiHaz5mYp/vbeF
 TSsGBMkPojGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="237737234"
X-IronPort-AV: E=Sophos;i="5.78,398,1599548400"; 
   d="scan'208";a="237737234"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 17:51:58 -0800
IronPort-SDR: jz/DL1lQ8dyh4nWDBvfo2IKLv0CC3GtIfxAATLJ68hHhediwQ7ZMAs9nqv9qv9b2DNOmq2OX8u
 3PCUU2mDOrWQ==
X-IronPort-AV: E=Sophos;i="5.78,398,1599548400"; 
   d="scan'208";a="362917991"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.16.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 17:51:58 -0800
Date:   Sun, 6 Dec 2020 17:51:57 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ionic: fix array overflow on receiving too many
 fragments for a packet
Message-ID: <20201206175157.0000170d@intel.com>
In-Reply-To: <20201206133537.30135-1-ruc_zhangxiaohui@163.com>
References: <20201206133537.30135-1-ruc_zhangxiaohui@163.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaohui Zhang wrote:

> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> 
> If the hardware receives an oversized packet with too many rx fragments,
> skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
> This becomes especially visible if it corrupts the freelist pointer of
> a slab page.
> 
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

Hi, thanks for your patch.

It appears this is a part of a series of patches (at least this one and
one to the ice driver) - please send as one series, with a cover letter
explanation.

Please justify how this is a bug and how this is found / reproduced.

I'll respond separately to the ice driver patch as I don't know this
hardware and it's limits, but I suspect that you've tried to fix a bug
where there was none. (It seems like something a code scanner might find
and be confused about)

> ---
>  drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index 169ac4f54..a3e274c65 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -102,8 +102,12 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>  
>  		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>  			       PAGE_SIZE, DMA_FROM_DEVICE);
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> +		struct skb_shared_info *shinfo = skb_shinfo(skb);

you can't declare variables in the middle of a code flow in C, did you
compile this?

> +
> +		if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
> +			skb_add_rx_frag(skb, shinfo->nr_frags,
>  				page_info->page, 0, frag_len, PAGE_SIZE);
> +		}
>  		page_info->page = NULL;
>  		page_info++;
>  		i--;


