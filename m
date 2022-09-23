Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A4C5E7B7F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiIWNMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiIWNLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:11:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DA65D0D8;
        Fri, 23 Sep 2022 06:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xuVCXIa/TPpmYY8fHhGwDK/MmbReamcjwszP+MviEcs=; b=Yg+/eTLPcNlrktCGDt+F1FzFYf
        r8BWI7JEu/zEiOVjP99B7ogfSUJhxrhsSuqWJqYC/aw+hgT618np0In4VHxRGLKDW0ZcsHNDFUDPh
        Hpzui+tJFwYq/3nyg+k4JFTrTUGRi1FeNjq9ne0J6EzsXEA9EUrPpbWjXvkPCkBbohtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obiSw-0001Vg-Nn; Fri, 23 Sep 2022 15:11:38 +0200
Date:   Fri, 23 Sep 2022 15:11:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <Yy2wivbzUA2zroqy@lunn.ch>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Forwarding engine block (MFWD) */
> +static void rswitch_fwd_init(struct rswitch_private *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_NUM_HW; i++) {
> +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> +		iowrite32(0, priv->addr + FWPBFC(i));
> +	}

What is RSWITCH_NUM_HW?

> +
> +	for (i = 0; i < RSWITCH_NUM_ETHA; i++) {

RSWITCH_NUM_ETHA appears to be the number of ports?

> +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
> +{
> +	u32 gwgrlulc, gwgrlc;
> +
> +	switch (rate) {
> +	case 1000:
> +		gwgrlulc = 0x0000005f;
> +		gwgrlc = 0x00010260;
> +		break;
> +	default:
> +		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", __func__, rate);
> +		return;
> +	}

Is this setting the Mbps between the switch matrix and the CPU? Why
limit the rate? Especially if you have 3 ports, would not 3000 make
sense?

> +static void rswitch_get_data_irq_status(struct rswitch_private *priv, u32 *dis)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> +		dis[i] = ioread32(priv->addr + GWDIS(i));
> +		dis[i] &= ioread32(priv->addr + GWDIE(i));
> +	}
> +}
> +
> +static void rswitch_enadis_data_irq(struct rswitch_private *priv, int index, bool enable)
> +{
> +	u32 offs = enable ? GWDIE(index / 32) : GWDID(index / 32);
> +
> +	iowrite32(BIT(index % 32), priv->addr + offs);
> +}
> +
> +static void rswitch_ack_data_irq(struct rswitch_private *priv, int index)
> +{
> +	u32 offs = GWDIS(index / 32);
> +
> +	iowrite32(BIT(index % 32), priv->addr + offs);
> +}
> +
> +static bool rswitch_is_chain_rxed(struct rswitch_gwca_chain *c)
> +{
> +	struct rswitch_ext_ts_desc *desc;
> +	int entry;
> +
> +	entry = c->dirty % c->num_ring;
> +	desc = &c->ts_ring[entry];
> +
> +	if ((desc->die_dt & DT_MASK) != DT_FEMPTY)
> +		return true;
> +
> +	return false;

Is a chain a queue? Also known as a ring? The naming is different to
most drivers, which is making this harder to understand. Ideally, you
want to follow the basic naming the majority of other drivers use.

> +}
> +
> +static int rswitch_gwca_chain_alloc_skb(struct rswitch_gwca_chain *c,
> +					int start, int num)
> +{
> +	int i, index;
> +
> +	for (i = start; i < (start + num); i++) {
> +		index = i % c->num_ring;

Why this? Would it not make more sense to validate that start + num <
num_ring? It seems like bad parameters passed here could destroy some
other skb in the ring?

More naming... Here you use num_ring, not num_chain. Try to be
consistent. Also, num_ring makes my think of ring 7 of 9 rings. When
this actually appears to be the size of the ring. So c->ring_size
would be a better name.

> +		if (c->skb[index])
> +			continue;
> +		c->skb[index] = dev_alloc_skb(PKT_BUF_SZ + RSWITCH_ALIGN - 1);
> +		if (!c->skb[index])
> +			goto err;
> +		skb_reserve(c->skb[index], NET_IP_ALIGN);

netdev_alloc_skb_ip_align()?

> +static void rswitch_gwca_chain_free(struct net_device *ndev,
> +				    struct rswitch_gwca_chain *c)
> +{
> +	int i;
> +
> +	if (c->gptp) {
> +		dma_free_coherent(ndev->dev.parent,
> +				  sizeof(struct rswitch_ext_ts_desc) *
> +				  (c->num_ring + 1), c->ts_ring, c->ring_dma);
> +		c->ts_ring = NULL;
> +	} else {
> +		dma_free_coherent(ndev->dev.parent,
> +				  sizeof(struct rswitch_ext_desc) *
> +				  (c->num_ring + 1), c->ring, c->ring_dma);
> +		c->ring = NULL;
> +	}
> +
> +	if (!c->dir_tx) {
> +		for (i = 0; i < c->num_ring; i++)
> +			dev_kfree_skb(c->skb[i]);
> +	}
> +
> +	kfree(c->skb);
> +	c->skb = NULL;

When i see code like this, i wonder why an API call like
dev_kfree_skb() is not being used. I would suggest reaming this to
something other than skb, which has a very well understood meaning.

> +static bool rswitch_rx(struct net_device *ndev, int *quota)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_gwca_chain *c = rdev->rx_chain;
> +	int entry = c->cur % c->num_ring;
> +	struct rswitch_ext_ts_desc *desc;
> +	int limit, boguscnt, num, ret;
> +	struct sk_buff *skb;
> +	dma_addr_t dma_addr;
> +	u16 pkt_len;
> +
> +	boguscnt = min_t(int, c->dirty + c->num_ring - c->cur, *quota);
> +	limit = boguscnt;
> +
> +	desc = &c->ts_ring[entry];
> +	while ((desc->die_dt & DT_MASK) != DT_FEMPTY) {
> +		dma_rmb();
> +		pkt_len = le16_to_cpu(desc->info_ds) & RX_DS;
> +		if (--boguscnt < 0)
> +			break;

Why the barrier, read the length and then decide to break out of the
loop?

> +static int rswitch_open(struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct device_node *phy;
> +	int err = 0;
> +
> +	if (rdev->etha) {

Can this happen? What would a netdev without an etha mean?

    Andrew
