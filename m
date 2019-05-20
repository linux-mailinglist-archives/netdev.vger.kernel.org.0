Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9F2298C
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 02:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfETAdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 20:33:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbfETAdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 20:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MUOX718qoN0nr8jmwyI3xtQbOr7oQTYpKc2V8gTbMCE=; b=rX5m0x0B3yqk7j3YWZWw1w/LhH
        SlGAFNt6/pKCaSkIN+ieVBcYPaWPQPcdgDvofTmUYcVaD0idFyMDLyYaMQj5W+wnc0E0WI4rf9ShT
        77TRnTNU3OkWpPR5OxveuytkNo8WW20Z7iutJcigyBDlpRMjniJ3lu5aD9QXODpnRPqQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hSWEg-00016b-BC; Mon, 20 May 2019 02:33:02 +0200
Date:   Mon, 20 May 2019 02:33:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: Re: [PATCH v4 3/3] net: ethernet: add ag71xx driver
Message-ID: <20190520003302.GA1695@lunn.ch>
References: <20190519080304.5811-1-o.rempel@pengutronix.de>
 <20190519080304.5811-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519080304.5811-4-o.rempel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

> +static int ag71xx_mdio_mii_read(struct mii_bus *bus, int addr, int reg)
> +{
> +	struct ag71xx *ag = bus->priv;
> +	struct net_device *ndev = ag->ndev;
> +	int err;
> +	int ret;
> +
> +	err = ag71xx_mdio_wait_busy(ag);
> +	if (err)
> +		return err;
> +
> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);

It looks like you have not removed this.

> +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
> +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));
> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_READ);
> +
> +	err = ag71xx_mdio_wait_busy(ag);
> +	if (err)
> +		return err;
> +
> +	ret = ag71xx_rr(ag, AG71XX_REG_MII_STATUS);
> +	/*
> +	 * ar9331 doc: bits 31:16 are reserved and must be must be written
> +	 * with zero.
> +	 */
> +	ret &= 0xffff;
> +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);

Or this.

> +
> +	netif_dbg(ag, link, ndev, "mii_read: addr=%04x, reg=%04x, value=%04x\n",
> +		  addr, reg, ret);
> +
> +	return ret;
> +}
> +
> +static int ag71xx_mdio_mii_write(struct mii_bus *bus, int addr, int reg,
> +				 u16 val)
> +{
> +	struct ag71xx *ag = bus->priv;
> +	struct net_device *ndev = ag->ndev;
> +
> +	netif_dbg(ag, link, ndev, "mii_write: addr=%04x, reg=%04x, value=%04x\n",
> +		  addr, reg, val);
> +
> +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
> +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));

addr have the vale 0-31. So a mask of 0xff is a couple of bits too
big.

> +	ag71xx_wr(ag, AG71XX_REG_MII_CTRL, val);
> +
> +	return ag71xx_mdio_wait_busy(ag);
> +}

> +static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
> +{
> +	struct net_device *ndev = ag->ndev;
> +	struct phy_device *phydev = ndev->phydev;
> +	u32 cfg2;
> +	u32 ifctl;
> +	u32 fifo5;
> +
> +	if (!phydev->link && update) {
> +		ag71xx_hw_stop(ag);
> +		netif_carrier_off(ag->ndev);

phylib will take care of the carrier for you.

       Andrew
