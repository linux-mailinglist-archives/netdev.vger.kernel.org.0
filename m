Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DC329EC07
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJ2Mmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2Mmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 08:42:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ED4C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 05:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=teU0zFrW3jRy913SBYt3cbawJ1gs0avHcIWwN1NfvV0=; b=wSkZ5JmG0xaxxA7iH3pDd1VNg
        aVaOeFmmt/3WyETbwLNMK2vA9QaGurixGDUf8PMyAmKNkTF2fAbHdH5ms1Pce4ZBRqdpIHK/UufEI
        VoKQhRxJs7JujFi8ahejpgp+uxqoY7aSbDH6BAFItK62pqg/SOiLKgmcNlYpkbZcE86STz84SBKB4
        PnvMdD2v/YVUZpvAML8hF3rgeb+5t1HfyIqQ6DEQkSlHl/CROHxyotNsSX9pdE+4ph7RWMyvPpkki
        EenTdOLKpeNKWUHkck/wzeuA7Q6IJUPNSYYfQu94y6bG7+6rKAbSJLNv8V+6fzv3MpkwEzsI5TkWs
        X+HTRFU8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52448)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kY7FO-0004KS-2u; Thu, 29 Oct 2020 12:41:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kY7FN-00067B-I4; Thu, 29 Oct 2020 12:41:41 +0000
Date:   Thu, 29 Oct 2020 12:41:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029124141.GR1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
 <20201028221427.22968-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028221427.22968-2-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:14:23PM +0100, Marek Behún wrote:
> Some multigig SFPs from RollBall and Hilink do not expose functional
> MDIO access to the internal PHY of the SFP via I2C address 0x56
> (although there seems to be read-only clause 22 access on this address).
> 
> Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> Digital Diagnostic Interface - I2C address 0x51.
> 
> This extends the mdio-i2c driver to support this protocol by adding a
> special parameter to mdio_i2c_alloc function via which this RollBall
> protocol can be selected.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

I think this is probably a better way forward, and I suspect we're going
to see more of this stuff. I wonder, however, whether the configuration
should be done here too (selecting page 1). Also, shouldn't we ensure
that we are on page 1 before attempting any access?

It would be good to pass this through checkpatch - I notice some lines
seem to be over the 80 character limit now.

A few comments below...

> +static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf, size_t len)
> +{
> +	struct i2c_adapter *i2c = bus->priv;
> +	struct i2c_msg msgs[2];
> +	u8 buf0[2], *res;
> +	int i, ret;
> +
> +	buf0[0] = ROLLBALL_CMD_ADDR;
> +
> +	msgs[0].addr = bus_addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 1;
> +	msgs[0].buf = &buf0[0];
> +
> +	res = buf ? buf : &buf0[1];
> +
> +	msgs[1].addr = bus_addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = buf ? len : 1;
> +	msgs[1].buf = res;
> +
> +	/* By experiment it takes up to 70 ms to access a register for these SFPs. Sleep 20ms
> +	 * between iteratios and try 10 times.

"iterations"

> +static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
> +{
> +	u8 buf[4], res[6];
> +	int bus_addr, ret;
> +	u16 val;
> +
> +	if (!(reg & MII_ADDR_C45))
> +		return -EOPNOTSUPP;
> +
> +	bus_addr = i2c_mii_phy_addr(phy_id);
> +	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
> +		return 0xffff;
> +
> +	buf[0] = ROLLBALL_DATA_ADDR;
> +	buf[1] = (reg >> 16) & 0x1f;
> +	buf[2] = (reg >> 8) & 0xff;
> +	buf[3] = reg & 0xff;
> +
> +	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_READ, buf, sizeof(buf));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_rollball_mii_poll(bus, bus_addr, res, sizeof(res));
> +	if (ret == -ETIMEDOUT)
> +		return 0xffff;
> +	else if (ret < 0)
> +		return ret;
> +
> +	val = res[4];
> +	val <<= 8;
> +	val |= res[5];

Was there something wrong with:

	val = res[4] << 8 | res[5];

here?

> +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> +			       enum mdio_i2c_type type)

Maybe call this "protocol" rather than "type" ?

> +enum mdio_i2c_type {
> +	MDIO_I2C_DEFAULT,
> +	MDIO_I2C_ROLLBALL,
> +};
> +
> +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> +			       enum mdio_i2c_type type);

Same here (protocol vs type).

Otherwise, I don't see much else wrong.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
