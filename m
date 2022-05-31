Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60F538FCA
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343752AbiEaLXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiEaLXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:23:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 883922BB1D
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 04:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653996227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cb0uCHMo8aU2h1eNWnUmV0rqWGFcvOyZ9KFWz5IpS3o=;
        b=h22ZTXxxwt9hyc7KbHSr62yigwFCCTio7owsb2WAm5cp6e8Kiuk3fJGffx8nfPDdVJJkFN
        OREBfOrrzVHd+ASgkpchKc0gLVuQ6fqS/T0+zTlFfQfviUXAQsUZyFBgXUB7+hYmxkX5n8
        F/2G78qChsTPJo2XWwVmmZHI/gYbzbw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-GWizKkDIMmmFTXf0_GNIlw-1; Tue, 31 May 2022 07:23:46 -0400
X-MC-Unique: GWizKkDIMmmFTXf0_GNIlw-1
Received: by mail-qt1-f198.google.com with SMTP id f40-20020a05622a1a2800b002fcc151deebso11127138qtb.4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 04:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cb0uCHMo8aU2h1eNWnUmV0rqWGFcvOyZ9KFWz5IpS3o=;
        b=fjTNlYvC4jE3dnNPaQJdC1N2f2Hdyv6mfj45TZNS4dFK/ADmMlEx+RwEYvqYl/3Qdf
         tfI6wu8xpUwhC1PimfwsCgorrRDIW1T6oeV9Ak0QqbLOVXP5CykGyYgL3NCIL+31n8Ea
         UgybEivTScqDt7t2wtFShHnhr0PdSBfriMb8xR1Dw8X99ukGVG0DggF/xFIEgc1UoY/l
         hcqQWyu+DYxtkFIGHt47w/8theVRaow+1cvGs8idrivuttm/aQ/k5nMS5laq6dbG+d9B
         2fi0Sn4Ma9ky0EgZkDoDxHVtGHE6WXVAtesxint/0DTE4lag7/3j+0EQjYBQNotrWFWq
         sd3w==
X-Gm-Message-State: AOAM530IzTcs2nqiZQw2xYx+Dmrb/r8qF/TqJZGqkEDqElwsn6hWrFuY
        7lGu0VTc85UacDGyy2L/ANKHJgTvF/IKmeGXCe1jdGEdzvAEzuMX0YTYhnw0dREWY1Xvr+FIP65
        ShrSprnjGS4yifcZ7
X-Received: by 2002:a05:620a:12fb:b0:6a5:816e:43d6 with SMTP id f27-20020a05620a12fb00b006a5816e43d6mr23692509qkl.692.1653996226021;
        Tue, 31 May 2022 04:23:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcKltOlg/kYOsBwY4ck89LyJGn1h8RwebGLbLyGZQf6VOtbjGuWUhQQKGVPYXnPktvmybIag==
X-Received: by 2002:a05:620a:12fb:b0:6a5:816e:43d6 with SMTP id f27-20020a05620a12fb00b006a5816e43d6mr23692486qkl.692.1653996225758;
        Tue, 31 May 2022 04:23:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id b26-20020a05620a271a00b0069fe1fc72e7sm9204894qkp.90.2022.05.31.04.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 04:23:45 -0700 (PDT)
Message-ID: <fee7c767e1a57822bddc88fb6096673838e93ee4.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
From:   Paolo Abeni <pabeni@redhat.com>
To:     Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org,
        rogerq@kernel.org, grygorii.strashko@ti.com, vigneshr@ti.com,
        kishon@ti.com, robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
Date:   Tue, 31 May 2022 13:23:40 +0200
In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
References: <20220531095108.21757-1-p-mohan@ti.com>
         <20220531095108.21757-3-p-mohan@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-31 at 15:21 +0530, Puranjay Mohan wrote:
[...]
> +static int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
> +				    int budget)
> +{
> +	struct net_device *ndev = emac->ndev;
> +	struct cppi5_host_desc_t *desc_tx;
> +	struct netdev_queue *netif_txq;
> +	struct prueth_tx_chn *tx_chn;
> +	unsigned int total_bytes = 0;
> +	struct sk_buff *skb;
> +	dma_addr_t desc_dma;
> +	int res, num_tx = 0;
> +	void **swdata;
> +
> +	tx_chn = &emac->tx_chns[chn];
> +
> +	while (budget--) {
> +		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
> +		if (res == -ENODATA)
> +			break;
> +
> +		/* teardown completion */
> +		if (cppi5_desc_is_tdcm(desc_dma)) {
> +			if (atomic_dec_and_test(&emac->tdown_cnt))
> +				complete(&emac->tdown_complete);
> +			break;
> +		}
> +
> +		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
> +						     desc_dma);
> +		swdata = cppi5_hdesc_get_swdata(desc_tx);
> +
> +		skb = *(swdata);
> +		prueth_xmit_free(tx_chn, desc_tx);
> +
> +		ndev = skb->dev;
> +		ndev->stats.tx_packets++;
> +		ndev->stats.tx_bytes += skb->len;
> +		total_bytes += skb->len;
> +		napi_consume_skb(skb, budget);

The above is uncorrect. In this loop's last iteration 'budget' will  be
0 and napi_consume_skb will wrongly assume the caller is not in NAPI
context. 

> +static int prueth_dma_rx_push(struct prueth_emac *emac,
> +			      struct sk_buff *skb,
> +			      struct prueth_rx_chn *rx_chn)
> +{
> +	struct cppi5_host_desc_t *desc_rx;
> +	struct net_device *ndev = emac->ndev;
> +	dma_addr_t desc_dma;
> +	dma_addr_t buf_dma;
> +	u32 pkt_len = skb_tailroom(skb);
> +	void **swdata;
> +
> +	desc_rx = k3_cppi_desc_pool_alloc(rx_chn->desc_pool);
> +	if (!desc_rx) {
> +		netdev_err(ndev, "rx push: failed to allocate descriptor\n");
> +		return -ENOMEM;
> +	}
> +	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
> +
> +	buf_dma = dma_map_single(rx_chn->dma_dev, skb->data, pkt_len, DMA_FROM_DEVICE);
> +	if (unlikely(dma_mapping_error(rx_chn->dma_dev, buf_dma))) {
> +		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
> +		netdev_err(ndev, "rx push: failed to map rx pkt buffer\n");
> +		return -EINVAL;
> +	}
> +
> +	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
> +			 PRUETH_NAV_PS_DATA_SIZE);
> +	k3_udma_glue_rx_dma_to_cppi5_addr(rx_chn->rx_chn, &buf_dma);
> +	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
> +
> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
> +	*swdata = skb;
> +
> +	return k3_udma_glue_push_rx_chn(rx_chn->rx_chn, 0,
> +					desc_rx, desc_dma);
> +}
> +
> +static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id)
> +{
> +	struct prueth_rx_chn *rx_chn = &emac->rx_chns;
> +	struct net_device *ndev = emac->ndev;
> +	struct cppi5_host_desc_t *desc_rx;
> +	dma_addr_t desc_dma, buf_dma;
> +	u32 buf_dma_len, pkt_len, port_id = 0;
> +	int ret;
> +	void **swdata;
> +	struct sk_buff *skb, *new_skb;
> +
> +	ret = k3_udma_glue_pop_rx_chn(rx_chn->rx_chn, flow_id, &desc_dma);
> +	if (ret) {
> +		if (ret != -ENODATA)
> +			netdev_err(ndev, "rx pop: failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (cppi5_desc_is_tdcm(desc_dma)) /* Teardown ? */
> +		return 0;
> +
> +	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
> +
> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
> +	skb = *swdata;
> +
> +	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
> +	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
> +	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
> +	/* firmware adds 4 CRC bytes, strip them */
> +	pkt_len -= 4;
> +	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
> +
> +	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
> +	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
> +
> +	skb->dev = ndev;
> +	if (!netif_running(skb->dev)) {
> +		dev_kfree_skb_any(skb);
> +		return 0;
> +	}
> +
> +	new_skb = netdev_alloc_skb_ip_align(ndev, PRUETH_MAX_PKT_SIZE);
> +	/* if allocation fails we drop the packet but push the
> +	 * descriptor back to the ring with old skb to prevent a stall
> +	 */
> +	if (!new_skb) {
> +		ndev->stats.rx_dropped++;
> +		new_skb = skb;
> +	} else {
> +		/* send the filled skb up the n/w stack */
> +		skb_put(skb, pkt_len);
> +		skb->protocol = eth_type_trans(skb, ndev);
> +		netif_receive_skb(skb);

This is (apparently) in napi context. You should use napi_gro_receive()
or napi_gro_frags()


Cheers!

Paolo

