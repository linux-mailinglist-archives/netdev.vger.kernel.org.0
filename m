Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCE529A9A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiEQHOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiEQHN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:13:59 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B5847AE8;
        Tue, 17 May 2022 00:13:57 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 544C824000B;
        Tue, 17 May 2022 07:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652771636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xitUkq6bcM9fi9wtca3gUKwmXKGzceoo2Uwj87umL3M=;
        b=ic2ayfE8pirXVkiRfeQEXjc+pUm9p2S9hs0tZCRPD5ogHX2kOc8JwJxpjPIwKp25ltQHqy
        LHAk2iEYeip1QrIugBL8BX+aO9GLEwRy1EA7KceqO54A7EUW5l5MqA99VKAxmNpouR7DQ/
        zKST4YHmoe9TLU326QQJF2x3OYU6tbExyk7DRB97tj61GiKHhBqT8jXxt091g9EgyuRJuN
        Hcn0bkMSKPHSPOKzPDiqBmiBydhnGEzGPl0BvOlt+qf5MRrmkr6zOGney2Cr3td79Wi2ax
        iSVCaq1ucJrg0I+xduBEtu7GL9+rNsFXc9NKwxn5J4pG/HAvyRZaIu0CrG3wrw==
Date:   Tue, 17 May 2022 09:13:52 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <20220517091352.13795c8e@pc-20.home>
In-Reply-To: <YoG8F8V0Z+7hz/jw@lunn.ch>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-2-maxime.chevallier@bootlin.com>
        <YoG8F8V0Z+7hz/jw@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 16 May 2022 04:51:03 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +static int ipqess_tx_ring_alloc(struct ipqess *ess)
> > +{
> > +	struct device *dev = &ess->pdev->dev;
> > +	int i;
> > +
> > +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> > +		struct ipqess_tx_ring *tx_ring = &ess->tx_ring[i];
> > +		size_t size;
> > +		u32 idx;
> > +
> > +		tx_ring->ess = ess;
> > +		tx_ring->ring_id = i;
> > +		tx_ring->idx = i * 4;
> > +		tx_ring->count = IPQESS_TX_RING_SIZE;
> > +		tx_ring->nq = netdev_get_tx_queue(ess->netdev, i);
> > +
> > +		size = sizeof(struct ipqess_buf) *
> > IPQESS_TX_RING_SIZE;
> > +		tx_ring->buf = devm_kzalloc(dev, size, GFP_KERNEL);
> > +		if (!tx_ring->buf) {
> > +			netdev_err(ess->netdev, "buffer alloc of
> > tx ring failed");
> > +			return -ENOMEM;
> > +		}  
> 
> kzalloc() is pretty loud when there is no memory. So you see patches
> removing such warning messages.

Ack, I'll remove that

> > +static int ipqess_rx_napi(struct napi_struct *napi, int budget)
> > +{
> > +	struct ipqess_rx_ring *rx_ring = container_of(napi, struct
> > ipqess_rx_ring,
> > +						    napi_rx);
> > +	struct ipqess *ess = rx_ring->ess;
> > +	u32 rx_mask = BIT(rx_ring->idx);
> > +	int remain_budget = budget;
> > +	int rx_done;
> > +	u32 status;
> > +
> > +poll_again:
> > +	ipqess_w32(ess, IPQESS_REG_RX_ISR, rx_mask);
> > +	rx_done = ipqess_rx_poll(rx_ring, remain_budget);
> > +
> > +	if (rx_done == remain_budget)
> > +		return budget;
> > +
> > +	status = ipqess_r32(ess, IPQESS_REG_RX_ISR);
> > +	if (status & rx_mask) {
> > +		remain_budget -= rx_done;
> > +		goto poll_again;
> > +	}  
> 
> Could this be turned into a do while() loop?

Yes indeed, I'll fix this for v3

> > +static void ipqess_irq_enable(struct ipqess *ess)
> > +{
> > +	int i;
> > +
> > +	ipqess_w32(ess, IPQESS_REG_RX_ISR, 0xff);
> > +	ipqess_w32(ess, IPQESS_REG_TX_ISR, 0xffff);
> > +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> > +		ipqess_w32(ess,
> > IPQESS_REG_RX_INT_MASK_Q(ess->rx_ring[i].idx), 1);
> > +		ipqess_w32(ess,
> > IPQESS_REG_TX_INT_MASK_Q(ess->tx_ring[i].idx), 1);
> > +	}
> > +}
> > +
> > +static void ipqess_irq_disable(struct ipqess *ess)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> > +		ipqess_w32(ess,
> > IPQESS_REG_RX_INT_MASK_Q(ess->rx_ring[i].idx), 0);
> > +		ipqess_w32(ess,
> > IPQESS_REG_TX_INT_MASK_Q(ess->tx_ring[i].idx), 0);
> > +	}
> > +}  
> 
> Enable and disable are not symmetric?

Ah nice catch too, I'll dig into this, either to make it symmetric or
to explain with a comment why it isn't

> 
> > +static inline void ipqess_kick_tx(struct ipqess_tx_ring *tx_ring)  
> 
> No inline functions please in .c files. Let the compiler decide.

Ack, I'll address that.

>    Andrew

Thanks again for the review

Maxime
