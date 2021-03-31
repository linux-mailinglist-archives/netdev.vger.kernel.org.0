Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC4534F6EC
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhCaCmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233259AbhCaCmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 22:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B759619CA;
        Wed, 31 Mar 2021 02:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617158537;
        bh=8Ue31CU6c105fo9MV/f6yIBMpQtwspY1XPEZbBfWucU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EdRwlaXM3N507LgGVvVpkBDZZmfxRwODIwE3oPg2daUdkioNPdM+6rnKVLJMMrAcK
         hKVg/+axZBuNAGIn5W5/KSQOpQJiIHTiLB/Ba96t9mEYB/C/4r/ZbkK7ic0sdRqebq
         E8usJz/zahtHBUfU5RXtNNL8nwlJ6P/pm4rkT+ArCphDWdKRJs2g9SG7uMCVqQPlIJ
         FCLgILnnr/dOkyPHLIh8PdMzbQKsYafnwqWKIZQ3cKRImOpWuj6H+53KD2hldkTiTf
         +kLESK5ae3BnskcjJyS2hYCa3Sd0GdclH4t4J8ACQarqQSadRr+4Cs2IgTkmV/nwrc
         aZiGJhFx964ow==
Date:   Tue, 30 Mar 2021 19:42:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: stmmac: Add initial XDP support
Message-ID: <20210330194215.0469324a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210330024949.14010-5-boon.leong.ong@intel.com>
References: <20210330024949.14010-1-boon.leong.ong@intel.com>
        <20210330024949.14010-5-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Mar 2021 10:49:47 +0800 Ong Boon Leong wrote:
> +		if (!skb) {
> +			dma_sync_single_for_cpu(priv->device, buf->addr,
> +						buf1_len, dma_dir);
> +
> +			xdp.data = page_address(buf->page) + buf->page_offset;
> +			xdp.data_end = xdp.data + len;
> +			xdp.data_hard_start = page_address(buf->page);
> +			xdp_set_data_meta_invalid(&xdp);
> +			xdp.frame_sz = buf_sz;
> +
> +			skb = stmmac_xdp_run_prog(priv, &xdp);
> +
> +			/* For Not XDP_PASS verdict */
> +			if (IS_ERR(skb)) {
> +				unsigned int xdp_res = -PTR_ERR(skb);
> +
> +				if (xdp_res & STMMAC_XDP_CONSUMED) {
> +					page_pool_recycle_direct(rx_q->page_pool,
> +								 buf->page);
> +					buf->page = NULL;
> +					priv->dev->stats.rx_dropped++;
> +
> +					/* Clear skb as it was set as
> +					 * status by XDP program.
> +					 */
> +					skb = NULL;
> +
> +					if (unlikely((status & rx_not_ls)))
> +						goto read_again;
> +
> +					count++;
> +					continue;
> +				}
> +			}
> +		}
> +
>  		if (!skb) {
>  			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
>  			if (!skb) {
> @@ -4322,9 +4400,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  				goto drain_data;
>  			}
>  
> -			dma_sync_single_for_cpu(priv->device, buf->addr,
> -						buf1_len, DMA_FROM_DEVICE);
> -			skb_copy_to_linear_data(skb, page_address(buf->page),
> +			skb_copy_to_linear_data(skb, page_address(buf->page) +
> +						buf->page_offset,
>  						buf1_len);

XDP can prepend or remove headers (using the bpf_xdp_adjust_head()
helper), so the start of data may no longer be page + HEADROOM, 
and the length of the frame may have changed. 

Are you accounting for this?
