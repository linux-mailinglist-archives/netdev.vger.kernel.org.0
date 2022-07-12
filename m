Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE35716E9
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiGLKNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiGLKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:12:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 911DBACEF7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657620753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GzcFi+vPIgQomELE8X8bD71ocK65f+Pq/zDznCpD/A=;
        b=T4JRpY7LR0E+L3L61MHjvF3wktLF7yS9Nvqw2NSc7oVnDQ0kLfivGCxpgld9SN6OfuGoc9
        2aPLcAIrAur4hOEeqcVBIPqpO82QzDocHN55zGzaDlXKJKqsUSI6zHdCFSIsO/ie3e+SF9
        9kRbz/yOlOcfFPGBTnNW5+6eJ8MylaA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-t4ZP1_AFPzyD_87xOamRVw-1; Tue, 12 Jul 2022 06:12:32 -0400
X-MC-Unique: t4ZP1_AFPzyD_87xOamRVw-1
Received: by mail-wm1-f71.google.com with SMTP id t25-20020a7bc3d9000000b003a2ea772bd2so1161541wmj.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:12:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9GzcFi+vPIgQomELE8X8bD71ocK65f+Pq/zDznCpD/A=;
        b=sRDf1erlmX3IK5gBT3xcV45nHgPRc6gVpzMH+4s51aVrs73dkc6z7i0dHCsJDXLUTq
         ByydMFZDKLWFtuF9RrKVeG+n+K3kBwKgLxSkOTfwBuPeQkOyZUwFwCPB1COKJkBsThUk
         MziyD84fNxixNg/sIoZYgExLHfcwl1pvqsQik3Qv5HwseFGuU46OJuZBKpWqBwjImppx
         gvtcN2f+Qx9zwlhuGLu6kM+QHxQbLuN3pdfWcQ0RAVcFZ81Kx7SZqUdI9kpHOzsHqNfc
         NTHMpJqPw2By6S/0PGom3UjeiGW271ZrMnMqhW1ikQpukB5f8HxCowRrkZji6vIHdsG7
         /4qg==
X-Gm-Message-State: AJIora95ndOClxB89WyjEjmtVGTA1J0ZSJryu+JRw/URDTZ6cMMWPNth
        AtxDOVobrnhhTpC2e5Lgw7/g+Mra57DSys0WJGIFCAYrnvwnkhY+oG60YUF3+Mb0npXjiKZDxrD
        5EcFYhq77k/VxjFNr
X-Received: by 2002:adf:f14d:0:b0:21d:ad67:c2e0 with SMTP id y13-20020adff14d000000b0021dad67c2e0mr4957630wro.247.1657620751058;
        Tue, 12 Jul 2022 03:12:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usRquEy8dwdRl0HJMJ8j+JYqzqJnTapkyaV2RE+c1r9tWr5ZRFbOxvkYpWLP2w1063WeSpwA==
X-Received: by 2002:adf:f14d:0:b0:21d:ad67:c2e0 with SMTP id y13-20020adff14d000000b0021dad67c2e0mr4957606wro.247.1657620750800;
        Tue, 12 Jul 2022 03:12:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id v5-20020a7bcb45000000b0039c811077d3sm8848135wmj.22.2022.07.12.03.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:12:30 -0700 (PDT)
Message-ID: <9c0b3cef3029ea71f7802eab6214062aad48d509.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] net: ethernet: mtk_eth_soc: add basic XDP
 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Date:   Tue, 12 Jul 2022 12:12:28 +0200
In-Reply-To: <dc3235fd20b74f78f4f42550ca7513063269a752.1657381057.git.lorenzo@kernel.org>
References: <cover.1657381056.git.lorenzo@kernel.org>
         <dc3235fd20b74f78f4f42550ca7513063269a752.1657381057.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-09 at 17:48 +0200, Lorenzo Bianconi wrote:
> Introduce basic XDP support to mtk_eth_soc driver.
> Supported XDP verdicts:
> - XDP_PASS
> - XDP_DROP
> - XDP_REDIRECT
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 146 +++++++++++++++++---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |   2 +
>  2 files changed, 130 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 9a92d602ebd5..3b583abb599d 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1494,22 +1494,55 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
>  		skb_free_frag(data);
>  }
>  
> +static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
> +		       struct xdp_buff *xdp, struct net_device *dev)
> +{
> +	u32 act = XDP_PASS;
> +
> +	if (!prog)
> +		return XDP_PASS;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +		return XDP_PASS;
> +	case XDP_REDIRECT:
> +		if (unlikely(xdp_do_redirect(dev, xdp, prog)))
> +			break;
> +		return XDP_REDIRECT;
> +	default:
> +		bpf_warn_invalid_xdp_action(dev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(dev, prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		break;
> +	}
> +
> +	page_pool_put_full_page(ring->page_pool,
> +				virt_to_head_page(xdp->data), true);
> +	return XDP_DROP;
> +}
> +
>  static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  		       struct mtk_eth *eth)
>  {
> +	struct bpf_prog *prog = READ_ONCE(eth->prog);
>  	struct dim_sample dim_sample = {};
>  	struct mtk_rx_ring *ring;
>  	int idx;
>  	struct sk_buff *skb;
>  	u8 *data, *new_data;
>  	struct mtk_rx_dma_v2 *rxd, trxd;
> +	bool xdp_do_redirect = false;
>  	int done = 0, bytes = 0;
>  
>  	while (done < budget) {
>  		unsigned int pktlen, *rxdcsum;
> -		u32 hash, reason, reserve_len;
>  		struct net_device *netdev;
>  		dma_addr_t dma_addr;
> +		u32 hash, reason;
>  		int mac = 0;
>  
>  		ring = mtk_get_rx_ring(eth);
> @@ -1539,8 +1572,14 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  		if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
>  			goto release_desc;
>  
> +		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
> +
>  		/* alloc new buffer */
>  		if (ring->page_pool) {
> +			struct page *page = virt_to_head_page(data);
> +			struct xdp_buff xdp;
> +			u32 ret;
> +
>  			new_data = mtk_page_pool_get_buff(ring->page_pool,
>  							  &dma_addr,
>  							  GFP_ATOMIC);
> @@ -1548,6 +1587,34 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  				netdev->stats.rx_dropped++;
>  				goto release_desc;
>  			}
> +
> +			dma_sync_single_for_cpu(eth->dma_dev,
> +				page_pool_get_dma_addr(page) + MTK_PP_HEADROOM,
> +				pktlen, page_pool_get_dma_dir(ring->page_pool));
> +
> +			xdp_init_buff(&xdp, PAGE_SIZE, &ring->xdp_q);
> +			xdp_prepare_buff(&xdp, data, MTK_PP_HEADROOM, pktlen,
> +					 false);
> +			xdp_buff_clear_frags_flag(&xdp);
> +
> +			ret = mtk_xdp_run(ring, prog, &xdp, netdev);
> +			if (ret != XDP_PASS) {
> +				if (ret == XDP_REDIRECT)
> +					xdp_do_redirect = true;
> +				goto skip_rx;
> +			}
> +
> +			skb = build_skb(data, PAGE_SIZE);
> +			if (unlikely(!skb)) {
> +				page_pool_put_full_page(ring->page_pool,
> +							page, true);
> +				netdev->stats.rx_dropped++;
> +				goto skip_rx;
> +			}
> +
> +			skb_reserve(skb, xdp.data - xdp.data_hard_start);
> +			skb_put(skb, xdp.data_end - xdp.data);
> +			skb_mark_for_recycle(skb);
>  		} else {
>  			if (ring->frag_size <= PAGE_SIZE)
>  				new_data = napi_alloc_frag(ring->frag_size);
> @@ -1571,27 +1638,20 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  
>  			dma_unmap_single(eth->dma_dev, trxd.rxd1,
>  					 ring->buf_size, DMA_FROM_DEVICE);
> -		}
>  
> -		/* receive data */
> -		skb = build_skb(data, ring->frag_size);
> -		if (unlikely(!skb)) {
> -			mtk_rx_put_buff(ring, data, true);
> -			netdev->stats.rx_dropped++;
> -			goto skip_rx;
> -		}
> +			skb = build_skb(data, ring->frag_size);
> +			if (unlikely(!skb)) {
> +				netdev->stats.rx_dropped++;
> +				skb_free_frag(data);
> +				goto skip_rx;
> +			}
>  
> -		if (ring->page_pool) {
> -			reserve_len = MTK_PP_HEADROOM;
> -			skb_mark_for_recycle(skb);
> -		} else {
> -			reserve_len = NET_SKB_PAD + NET_IP_ALIGN;
> +			skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
> +			skb_put(skb, pktlen);
>  		}
> -		skb_reserve(skb, reserve_len);
>  
> -		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
>  		skb->dev = netdev;
> -		skb_put(skb, pktlen);
> +		bytes += skb->len;
>  
>  		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
>  			rxdcsum = &trxd.rxd3;
> @@ -1603,7 +1663,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  		else
>  			skb_checksum_none_assert(skb);
>  		skb->protocol = eth_type_trans(skb, netdev);
> -		bytes += pktlen;
>  
>  		hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
>  		if (hash != MTK_RXD4_FOE_ENTRY) {
> @@ -1666,6 +1725,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  			  &dim_sample);
>  	net_dim(&eth->rx_dim, dim_sample);
>  
> +	if (prog && xdp_do_redirect)
> +		xdp_do_flush_map();
> +
>  	return done;
>  }
>  
> @@ -2750,6 +2812,48 @@ static int mtk_stop(struct net_device *dev)
>  	return 0;
>  }
>  
> +static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct mtk_mac *mac = netdev_priv(dev);
> +	struct mtk_eth *eth = mac->hw;
> +	struct bpf_prog *old_prog;
> +	bool need_update;
> +
> +	if (eth->hwlro) {
> +		NL_SET_ERR_MSG_MOD(extack, "XDP not supported with HWLRO");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (dev->mtu > MTK_PP_MAX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	need_update = !!eth->prog != !!prog;
> +	if (netif_running(dev) && need_update)
> +		mtk_stop(dev);
> +
> +	old_prog = xchg(&eth->prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	if (netif_running(dev) && need_update)
> +		return mtk_open(dev);
> +
> +	return 0;
> +}
> +
> +static int mtk_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return mtk_xdp_setup(dev, xdp->prog, xdp->extack);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static void ethsys_reset(struct mtk_eth *eth, u32 reset_bits)
>  {
>  	regmap_update_bits(eth->ethsys, ETHSYS_RSTCTRL,
> @@ -3045,6 +3149,11 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
>  	struct mtk_eth *eth = mac->hw;
>  	u32 mcr_cur, mcr_new;
>  
> +	if (eth->prog && length > MTK_PP_MAX_BUF_SIZE) {
> +		netdev_err(dev, "Invalid MTU for XDP mode\n");
> +		return -EINVAL;
> +	}
> +
>  	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
>  		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
> @@ -3372,6 +3481,7 @@ static const struct net_device_ops mtk_netdev_ops = {
>  	.ndo_poll_controller	= mtk_poll_controller,
>  #endif
>  	.ndo_setup_tc		= mtk_eth_setup_tc,
> +	.ndo_bpf		= mtk_xdp,
>  };
>  
>  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index 26c019319055..a1cea93300c1 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -1088,6 +1088,8 @@ struct mtk_eth {
>  
>  	struct mtk_ppe			*ppe;
>  	struct rhashtable		flow_table;
> +
> +	struct bpf_prog			*prog;

The XDP program is apparently under an RCU protection schema (otherwise
you will get UaF when replacing it). Why don't you have explicit RCU
annotations? (here, and where the 'prog' field is touched).

Thanks!

Paolo

