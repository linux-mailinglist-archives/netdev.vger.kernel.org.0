Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9F18C966
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgCTJAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:00:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57908 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTJAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kexvH5XYjVdm9Ag6sXP3kOpw4limHzQ4DvcT2X2S0oA=; b=R4GdYGWB8i9YpRd6LLAfjYdpd
        Jg3zGWOtTfRKv+9v1h2eTBBlXwnycHUFuDksDYsMuqBLELgiIGcymNkwPqJuKlu9LTWnFzko7Mi/R
        xqqrRlC43efhPtynGmwfRBksho8gpQISXBmI2LMpwhEqc3FSfNDiQGpBZuqf5o5Ot3UOoE2uobKTU
        v6NtqU3pFbBen9qn9tBzkKvYBxiSf/6E+oL1nGLxPCZTAECPtAtwLYWocxw8pfvOXRNaxO+50pveB
        8WXnYKCeeKJAiv9BWgJUmwPYqQ2KTQY5uKtEGzSDAapUaZalhCZ87f7lMyVti+K54a0JUsfx1Z5O4
        ha4/XMzOg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55510)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jFDWB-0007JY-58; Fri, 20 Mar 2020 09:00:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jFDW8-0005e0-Ld; Fri, 20 Mar 2020 09:00:36 +0000
Date:   Fri, 20 Mar 2020 09:00:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Add support for the SGMII
 port
Message-ID: <20200320090036.GK25745@shell.armlinux.org.uk>
References: <20200320005420.1459-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320005420.1459-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 02:54:20AM +0200, Vladimir Oltean wrote:
> +static void sja1105_sgmii_config(struct sja1105_private *priv, int port,
> +				 int speed)
> +{
> +	int pcs_speed;
> +
> +	/* DIGITAL_CONTROL_1: Enable vendor-specific MMD1, allow the PHY to
> +	 * stop the clock during LPI mode, make the MAC reconfigure
> +	 * autonomously after PCS autoneg is done, flush the internal FIFOs.
> +	 */
> +	sja1105_sgmii_write(priv, 0x8000, SJA1105_DC1_EN_VSMMD1 |
> +					  SJA1105_DC1_CLOCK_STOP_EN |
> +					  SJA1105_DC1_MAC_AUTO_SW |
> +					  SJA1105_DC1_INIT);
> +	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
> +	sja1105_sgmii_write(priv, 0x80e1, SJA1105_DC2_TX_POL_INV_DISABLE);
> +	/* AUTONEG_CONTROL: Use SGMII autoneg */
> +	sja1105_sgmii_write(priv, 0x8001, SJA1105_AC_AUTONEG_MODE_SGMII);

The above should be configured at mac_config() time.

> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		pcs_speed = BMCR_SPEED1000;
> +		break;
> +	case SPEED_100:
> +		pcs_speed = BMCR_SPEED100;
> +		break;
> +	case SPEED_10:
> +		pcs_speed = BMCR_SPEED10;
> +		break;
> +	default:
> +		dev_err(priv->ds->dev, "Invalid speed %d\n", speed);
> +		return;
> +	}
> +	sja1105_sgmii_write(priv, MII_BMCR, pcs_speed | BMCR_FULLDPLX);

And this should be (as it now is) at mac_link_up().

If you want in-band AN (slave) to work, and that is documented as
working by enabling the AN bit in MII_BMCR, then I would suggest
setting that bit in the part called from mac_config() only if
phylink_autoneg_inband(mode) returns true, and avoiding the above
in mac_link_up() if phylink_autoneg_inband(mode) is also true.
Yes, I realise you can't actually test that, but up to you whether
or not to add that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
