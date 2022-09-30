Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D595F1370
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbiI3UQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiI3UPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:15:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E79EDEF6;
        Fri, 30 Sep 2022 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AL0vAaOv9ksnhaGXf4V4nnJuSUkCNqDdWkCatIEah0k=; b=ndip50q8BCZqkbgHXfC+wFjbsQ
        da9GPaMgztIxX3AhneS7F9ixWqKvRGdJGGI5qV0ANroDztvK5DTbZ1pfcnXR3ovD6hsxVfb8IDwnA
        l7yn6tYw6OyOwmNycytJ+XE6/kOgTw6hm4/+skJ5JbWloT1EZb1ZVXMpCHER61po2G1g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeMPd-000jzg-CD; Fri, 30 Sep 2022 22:15:09 +0200
Date:   Fri, 30 Sep 2022 22:15:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: using page pool to manage RX buffers
Message-ID: <YzdOTSNEUR2hi/dv@lunn.ch>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930193751.1249054-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct fec_enet_xdp_stats {
> +	u64	xdp_pass;
> +	u64	xdp_drop;
> +	u64	xdp_xmit;
> +	u64	xdp_redirect;
> +	u64	xdp_xmit_err;
> +	u64	xdp_tx;
> +	u64	xdp_tx_err;
> +};

These are not used in this patch. Please don't add anything until it
is actually used. The danger is, when you add the actual increments,
we miss that they are u64 and so need protecting. If they are in the
same patch, it is much more obvious.

> +
>  struct fec_enet_priv_tx_q {
>  	struct bufdesc_prop bd;
>  	unsigned char *tx_bounce[TX_RING_SIZE];
> @@ -532,7 +552,15 @@ struct fec_enet_priv_tx_q {
>  
>  struct fec_enet_priv_rx_q {
>  	struct bufdesc_prop bd;
> -	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
> +	struct  fec_enet_priv_txrx_info rx_skb_info[RX_RING_SIZE];
> +
> +	/* page_pool */
> +	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
> +	struct fec_enet_xdp_stats stats;
> +
> +	/* rx queue number, in the range 0-7 */
> +	u8 id;
>  };
>  
>  struct fec_stop_mode_gpr {
> @@ -644,6 +672,9 @@ struct fec_enet_private {
>  
>  	struct imx_sc_ipc *ipc_handle;
>  
> +	/* XDP BPF Program */
> +	struct bpf_prog *xdp_prog;

Not in this patch.

>  fec_enet_alloc_rxq_buffers(struct net_device *ndev, unsigned int queue)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> -	unsigned int i;
> -	struct sk_buff *skb;
> +	int i, err;
>  	struct bufdesc	*bdp;
>  	struct fec_enet_priv_rx_q *rxq;
>  
> +	dma_addr_t phys_addr;
> +	struct page *page;

Reverse Christmas tree is messed up in this driver, but please don't
make it worse. int i, err; should probably be last, and don't add a
blank line.

      Andrew
