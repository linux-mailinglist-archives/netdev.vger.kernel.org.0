Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F347C580562
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiGYURy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGYURu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:17:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE976211;
        Mon, 25 Jul 2022 13:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TPITMpvXjBG/Gx+wTpvX8dLpisVQnfvP/emYuB9nmrc=; b=axLZvsqw10kYj7R/aLxLH0jUsb
        SDOaTSm0/XCJh4KaeFZULJRSeDpGr/ahpeDK9fJr4XEmUU/8LlF+iS5x7dMh7aXEqYlnM+6u2zDuH
        C2Ng2PXid420w8/ACRFks1jV010kjd+6ciLpys0n2XVbmp5G96j8WrZki0kCHNWzF/ss=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oG4WB-00BUpy-A4; Mon, 25 Jul 2022 22:17:31 +0200
Date:   Mon, 25 Jul 2022 22:17:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gerhard@engleder-embedded.com,
        geert+renesas@glider.be, joel@jms.id.au, stefan.wahren@i2se.com,
        wellslutw@gmail.com, geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next v2 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <Yt76W+MbeHucJj0f@lunn.ch>
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
 <20220725165312.59471-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725165312.59471-3-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
> +{
> +	struct spi_transfer t[2] = {0};
> +	__le16 __reg = cpu_to_le16(reg);
> +	u32 header_len = ADIN1110_RD_HEADER_LEN;
> +	u32 read_len = ADIN1110_REG_LEN;
> +	int ret;

Reverse Christmass tree. Here and everywhere.

I would also drop the __ from __reg. Maybe call it le_reg?

> +static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
> +{

...

> +	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
> +
> +	rxb = netdev_alloc_skb(port_priv->netdev, frame_size_no_fcs);
> +	if (!rxb)
> +		return -ENOMEM;
> +
> +	memset(priv->data, 0, round_len + ADIN1110_RD_HEADER_LEN);
> +
> +	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), __reg);
> +	priv->data[1] = FIELD_GET(GENMASK(7, 0), __reg);
> +
> +	if (priv->append_crc) {
> +		priv->data[2] = adin1110_crc_data(&priv->data[0], 2);
> +		header_len++;
> +	}
> +
> +	t[0].tx_buf = &priv->data[0];
> +	t[0].len = header_len;
> +
> +	t[1].rx_buf = &priv->data[header_len];
> +	t[1].len = round_len;
> +
> +	ret = spi_sync_transfer(priv->spidev, t, 2);
> +	if (ret) {
> +		kfree_skb(rxb);
> +		return ret;
> +	}
> +
> +	/* Already forwarded to the other port if it did not match any MAC Addresses. */
> +	if (priv->forwarding)
> +		rxb->offload_fwd_mark = 1;
> +
> +	skb_put(rxb, frame_size_no_fcs);
> +	skb_copy_to_linear_data(rxb, &priv->data[header_len + ADIN1110_FRAME_HEADER_LEN],
> +				frame_size_no_fcs);

It looks like you could receive the frame direction into the skb. You
can consider the header_len + ADIN1110_FRAME_HEADER_LEN as just
another protocol header on the frame, which you remove using the
normal skb_ API, before passing the frame to the stack. That will save
you this memcpy.

> +
> +	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
> +
> +	netif_rx(rxb);
> +
> +	port_priv->rx_bytes += frame_size - ADIN1110_FRAME_HEADER_LEN;
> +	port_priv->rx_packets++;
> +
> +	return 0;
> +}
> +

> +/* ADIN1110 MAC-PHY contains an ADIN1100 PHY.
> + * ADIN2111 MAC-PHY contains two ADIN1100 PHYs.
> + * By registering a new MDIO bus we allow the PAL to discover
> + * the encapsulated PHY and probe the ADIN1100 driver.
> + */
> +static int adin1110_register_mdiobus(struct adin1110_priv *priv, struct device *dev)
> +{
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	mii_bus = devm_mdiobus_alloc(dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
> +		 priv->cfg->name, priv->spidev->chip_select);
> +
> +	mii_bus->name = priv->mii_bus_name;
> +	mii_bus->read = adin1110_mdio_read;
> +	mii_bus->write = adin1110_mdio_write;
> +	mii_bus->priv = priv;
> +	mii_bus->parent = dev;
> +	mii_bus->phy_mask = ~((u32)GENMASK(2, 0));
> +	mii_bus->probe_capabilities = MDIOBUS_C22_C45;

Your read/write functions return -EOPNOTSUPP on C45. So this is wrong.

> +static irqreturn_t adin1110_irq(int irq, void *p)
> +{
> +	struct adin1110_priv *priv = p;
> +	u32 status1;
> +	u32 val;
> +	int ret;
> +	int i;
> +
> +	mutex_lock(&priv->lock);

The MDIO bus operations are using the same lock. MDIO can be quite
slow. Do you really need mutual exclusion between MDIO and interrupts?
What exactly is this lock protecting?

  Andrew
