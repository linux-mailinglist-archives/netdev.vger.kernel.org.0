Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE3118E0A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfLJQoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:44:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfLJQon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Rn2HvqUHje4jyefJaRJuKH2kWexnmyg8GPKQ4GzLFWc=; b=wVpn3HTICHNgC9ULY2Ni+q5WSm
        qKK4GV1kc8Lqc5rDEyR9hpDxFPB4NsGXGITz+Bi0AWbnAqbUqGMrgApLpKR5CtjMDadASUVPown4s
        hJPvnSKRM3gb7aI0BnYJY2YyJEJv6yJHS8AhZYj9RdytbiKywITF0ZDNnq2NT4k+wZ0s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieico-0005OE-FG; Tue, 10 Dec 2019 17:44:38 +0100
Date:   Tue, 10 Dec 2019 17:44:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        matthias.bgg@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of MT7531
 switch
Message-ID: <20191210164438.GD27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int
> +mt7531_ind_mmd_phy_read(struct mt7530_priv *priv, int port, int devad,
> +			int regnum)
> +{
> +	struct mii_bus *bus = priv->bus;
> +	struct mt7530_dummy_poll p;
> +	u32 reg, val;
> +	int ret;
> +
> +	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
> +
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
> +				 !(val & PHY_ACS_ST), 20, 100000);
> +	if (ret < 0) {
> +		dev_err(priv->dev, "poll timeout\n");
> +		goto out;
> +	}
> +
> +	reg = MDIO_CL45_ADDR | MDIO_PHY_ADDR(port) | MDIO_DEV_ADDR(devad) |
> +	      regnum;

It might be better to call this mt7531_ind_c45_phy_read()

> +static int
> +mt7531_ind_phy_read(struct dsa_switch *ds, int port, int regnum)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	struct mii_bus *bus = priv->bus;
> +	struct mt7530_dummy_poll p;
> +	int ret;
> +	u32 val;
> +
> +	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
> +
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
> +				 !(val & PHY_ACS_ST), 20, 100000);
> +	if (ret < 0) {
> +		dev_err(priv->dev, "poll timeout\n");
> +		goto out;
> +	}
> +
> +	val = MDIO_CL22_READ | MDIO_PHY_ADDR(port) | MDIO_REG_ADDR(regnum);

This is then mt7531_ind_c22_phy_read().

And then you can add a wrapper around this to provide

mt7531_phy_read() which can do both C22 and C45.

> +	[ID_MT7531] = {
> +		.id = ID_MT7531,
> +		.setup = mt7531_setup,
> +		.phy_read = mt7531_ind_phy_read,

and use it here.

  Andrew
