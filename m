Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29895571698
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiGLKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiGLKIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:08:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B30C7AB6B4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657620496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asP8dhyxSUgO0L29Od55/p+ittqGFcnMIB0u28ju8Tk=;
        b=YNm2e9KFCt8VPVNzd5IDyIk3IQmC6ox8wti+1FF+F6ANmD5P+Gu/cbWNBju//BlFG/0mGH
        /qk2nnLGGyfngrj9HDc/OrgC01KWnlKL2rIhlXVDvqMSF/OT8QfSj8v7p0g7AwWRKdPPd+
        6S7qPrZKMLsQ+TwTHKlYstg8PJ2GQYc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-58oR-c52Psq50MClkpW0Tg-1; Tue, 12 Jul 2022 06:08:09 -0400
X-MC-Unique: 58oR-c52Psq50MClkpW0Tg-1
Received: by mail-wm1-f72.google.com with SMTP id m20-20020a05600c4f5400b003a03aad6bdfso3873221wmq.6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=asP8dhyxSUgO0L29Od55/p+ittqGFcnMIB0u28ju8Tk=;
        b=NB/u27ntyx/U39+2JVsciHlz8h0E2QIa8KkiVOHf6ZeR9nT+7wSXFlhy/mOQQXvx41
         OJfr3M//KcDaXLBcK8/7qu/XKRpCJbMHn5E/t0JaS55D5WEq5N+WoBtDb/dB6yE10XzP
         VksesZHjP9Qc/VrCzT4t3Q9uF2xPDk+YNh1ua1PJ9rZzX6mZ0wCU+Pt+NlzDdh22UGr5
         Vatrex/KGmu3AWitjQVfpIu5PtmuT1IrwC2skoDB9eu1q7Ex9Z9zN8xRVWdo1J4RZOT0
         HcoTqnC0uhyNmKRQyZ/sXdbDTZQBDnpYQ9UgHcQYV7lMHf+AxVb4qTWOaAcjBKvwjmpn
         VR/g==
X-Gm-Message-State: AJIora/KrviQXEL3kctpeDARHpHn6UGrx/5Ssly/D7VcPVNGI0x8QYsl
        TraJvp2VTcuQ6JslBm7Bw7vX+mMwkk/aAeVIQzjQ1HSisUvDpdlT1m+wBP61gpWZxvRXnj+IMLq
        zW+QnEVhqjrfyb34i
X-Received: by 2002:a05:600c:19cd:b0:3a1:77b6:cf1d with SMTP id u13-20020a05600c19cd00b003a177b6cf1dmr2833028wmq.141.1657620488721;
        Tue, 12 Jul 2022 03:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t1SefFmZkzyMfcY527GGFtqz++KRFKTRxAYUMCOJyY2MyCpI06LmrS10U0FyeLhmcsKyHfcQ==
X-Received: by 2002:a05:600c:19cd:b0:3a1:77b6:cf1d with SMTP id u13-20020a05600c19cd00b003a177b6cf1dmr2833006wmq.141.1657620488462;
        Tue, 12 Jul 2022 03:08:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id c9-20020adfed89000000b0021d9233e7e6sm9505539wro.54.2022.07.12.03.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:08:07 -0700 (PDT)
Message-ID: <2112728b3e53609c46d6403bffd563d62846a1d6.camel@redhat.com>
Subject: Re: [PATCH net-next 3/4] net: ethernet: mtk_eth_soc: introduce xdp
 ethtool counters
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Date:   Tue, 12 Jul 2022 12:08:05 +0200
In-Reply-To: <6a522ca5588fde75f42d4d812e8990eca6d8952d.1657381057.git.lorenzo@kernel.org>
References: <cover.1657381056.git.lorenzo@kernel.org>
         <6a522ca5588fde75f42d4d812e8990eca6d8952d.1657381057.git.lorenzo@kernel.org>
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
> Report xdp stats through ethtool
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 54 +++++++++++++++++----
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 12 +++++
>  2 files changed, 57 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 3b583abb599d..ae7ba2e09df8 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -34,6 +34,10 @@ MODULE_PARM_DESC(msg_level, "Message level (-1=defaults,0=none,...,16=all)");
>  #define MTK_ETHTOOL_STAT(x) { #x, \
>  			      offsetof(struct mtk_hw_stats, x) / sizeof(u64) }
>  
> +#define MTK_ETHTOOL_XDP_STAT(x) { #x, \
> +				  offsetof(struct mtk_hw_stats, xdp_stats.x) / \
> +				  sizeof(u64) }
> +
>  static const struct mtk_reg_map mtk_reg_map = {
>  	.tx_irq_mask		= 0x1a1c,
>  	.tx_irq_status		= 0x1a18,
> @@ -141,6 +145,13 @@ static const struct mtk_ethtool_stats {
>  	MTK_ETHTOOL_STAT(rx_long_errors),
>  	MTK_ETHTOOL_STAT(rx_checksum_errors),
>  	MTK_ETHTOOL_STAT(rx_flow_control_packets),
> +	MTK_ETHTOOL_XDP_STAT(rx_xdp_redirect),
> +	MTK_ETHTOOL_XDP_STAT(rx_xdp_pass),
> +	MTK_ETHTOOL_XDP_STAT(rx_xdp_drop),
> +	MTK_ETHTOOL_XDP_STAT(rx_xdp_tx),
> +	MTK_ETHTOOL_XDP_STAT(rx_xdp_tx_errors),
> +	MTK_ETHTOOL_XDP_STAT(tx_xdp_xmit),
> +	MTK_ETHTOOL_XDP_STAT(tx_xdp_xmit_errors),
>  };
>  
>  static const char * const mtk_clks_source_name[] = {
> @@ -1495,7 +1506,8 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
>  }
>  
>  static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
> -		       struct xdp_buff *xdp, struct net_device *dev)
> +		       struct xdp_buff *xdp, struct net_device *dev,
> +		       struct mtk_xdp_stats *stats)
>  {
>  	u32 act = XDP_PASS;
>  
> @@ -1505,10 +1517,13 @@ static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
>  	act = bpf_prog_run_xdp(prog, xdp);
>  	switch (act) {
>  	case XDP_PASS:
> +		stats->rx_xdp_pass++;
>  		return XDP_PASS;
>  	case XDP_REDIRECT:
>  		if (unlikely(xdp_do_redirect(dev, xdp, prog)))
>  			break;
> +
> +		stats->rx_xdp_redirect++;
>  		return XDP_REDIRECT;
>  	default:
>  		bpf_warn_invalid_xdp_action(dev, prog, act);
> @@ -1520,14 +1535,38 @@ static u32 mtk_xdp_run(struct mtk_rx_ring *ring, struct bpf_prog *prog,
>  		break;
>  	}
>  
> +	stats->rx_xdp_drop++;
>  	page_pool_put_full_page(ring->page_pool,
>  				virt_to_head_page(xdp->data), true);
>  	return XDP_DROP;
>  }
>  
> +static void mtk_xdp_rx_complete(struct mtk_eth *eth,
> +				struct mtk_xdp_stats *stats)
> +{
> +	int i, xdp_do_redirect = 0;
> +
> +	/* update xdp ethtool stats */
> +	for (i = 0; i < MTK_MAX_DEVS; i++) {
> +		struct mtk_hw_stats *hw_stats = eth->mac[i]->hw_stats;
> +		struct mtk_xdp_stats *xdp_stats = &hw_stats->xdp_stats;
> +
> +		u64_stats_update_begin(&hw_stats->syncp);
> +		xdp_stats->rx_xdp_redirect += stats[i].rx_xdp_redirect;
> +		xdp_do_redirect += stats[i].rx_xdp_pass;
> +		xdp_stats->rx_xdp_pass += stats[i].rx_xdp_pass;
> +		xdp_stats->rx_xdp_drop += stats[i].rx_xdp_drop;
> +		u64_stats_update_end(&hw_stats->syncp);
> +	}
> +
> +	if (xdp_do_redirect)
> +		xdp_do_flush_map();
> +}
> +
>  static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  		       struct mtk_eth *eth)
>  {
> +	struct mtk_xdp_stats xdp_stats[MTK_MAX_DEVS] = {};

This is allocating on the stack and clearing a relatively large struct
for every poll() call, which is not good.

Why can't you touch directly the eth->mac[i]->hw_stats.xdp_stats
counters where needed?

>  	struct bpf_prog *prog = READ_ONCE(eth->prog);
>  	struct dim_sample dim_sample = {};
>  	struct mtk_rx_ring *ring;
> @@ -1535,7 +1574,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  	struct sk_buff *skb;
>  	u8 *data, *new_data;
>  	struct mtk_rx_dma_v2 *rxd, trxd;
> -	bool xdp_do_redirect = false;
>  	int done = 0, bytes = 0;
>  
>  	while (done < budget) {
> @@ -1597,12 +1635,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  					 false);
>  			xdp_buff_clear_frags_flag(&xdp);
>  
> -			ret = mtk_xdp_run(ring, prog, &xdp, netdev);
> -			if (ret != XDP_PASS) {
> -				if (ret == XDP_REDIRECT)
> -					xdp_do_redirect = true;
> +			ret = mtk_xdp_run(ring, prog, &xdp, netdev,
> +					  &xdp_stats[mac]);
> +			if (ret != XDP_PASS)
>  				goto skip_rx;
> -			}
>  
>  			skb = build_skb(data, PAGE_SIZE);
>  			if (unlikely(!skb)) {
> @@ -1725,8 +1761,8 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>  			  &dim_sample);
>  	net_dim(&eth->rx_dim, dim_sample);
>  
> -	if (prog && xdp_do_redirect)
> -		xdp_do_flush_map();
> +	if (prog)
> +		mtk_xdp_rx_complete(eth, xdp_stats);
>  
>  	return done;
>  }
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index a1cea93300c1..629cdcdd632a 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -570,6 +570,16 @@ struct mtk_tx_dma_v2 {
>  struct mtk_eth;
>  struct mtk_mac;
>  
> +struct mtk_xdp_stats {
> +	u64 rx_xdp_redirect;
> +	u64 rx_xdp_pass;
> +	u64 rx_xdp_drop;
> +	u64 rx_xdp_tx;
> +	u64 rx_xdp_tx_errors;
> +	u64 tx_xdp_xmit;
> +	u64 tx_xdp_xmit_errors;
> +};
> +
>  /* struct mtk_hw_stats - the structure that holds the traffic statistics.
>   * @stats_lock:		make sure that stats operations are atomic
>   * @reg_offset:		the status register offset of the SoC
> @@ -593,6 +603,8 @@ struct mtk_hw_stats {
>  	u64 rx_checksum_errors;
>  	u64 rx_flow_control_packets;
>  
> +	struct mtk_xdp_stats	xdp_stats;
> +
>  	spinlock_t		stats_lock;
>  	u32			reg_offset;
>  	struct u64_stats_sync	syncp;

