Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B22F656E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbhANQIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbhANQIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:08:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63880C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SMrs3P+5EdO//YJvMfhcjIDwq4DzTSXhEXZyMIdqlAE=; b=JyZGY/ezUMaFrYiYRfYwR4tH+
        3AzxbpsbM91dNbQTbxD+l80242NNGmYwWlvEug7/cavbo1Zt8rfcTb65mzlq0aAr83Fnsg+RX7CzQ
        uLIRjwaUvqtBVAtaKp1XYugcLQ+NGsmxkDGY0P3Ng0gaWSoomWyyOjbyN/U33XP1cO26TmZ9awj6S
        RIfRC20XQjdUAKUcGTw5fS51US+wNaweZ8heXiMorPMuyiJXH6mpDjoXrhJQ3HOAe5eA/XJ5DnRsP
        9fqLzN3bG34V91PI9Ffq5AVSJK4dJQk7wltSLlMk8wGAkBti1ylHjjGdYkJXobO3k62Ue8MapuXge
        DYQY9oWCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47938)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l059c-0002eB-Gj; Thu, 14 Jan 2021 16:07:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l059b-0008TQ-G2; Thu, 14 Jan 2021 16:07:19 +0000
Date:   Thu, 14 Jan 2021 16:07:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v5 4/5] net: sfp: create/destroy I2C mdiobus
 before PHY probe/after PHY release
Message-ID: <20210114160719.GV1551@shell.armlinux.org.uk>
References: <20210114044331.5073-1-kabel@kernel.org>
 <20210114044331.5073-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114044331.5073-5-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:43:30AM +0100, Marek Behún wrote:
> Instead of configuring the I2C mdiobus when SFP driver is probed,
> create/destroy the mdiobus before the PHY is probed for/after it is
> released.
> 
> This way we can tell the mdio-i2c code which protocol to use for each
> SFP transceiver.

I've been thinking a bit more about this. It looks like it will
allocate and free the MDIO bus each time any module is inserted or
removed, even a fiber module that wouldn't ever have a PHY. This adds
unnecessary noise to the kernel message log.

We only probe for a PHY if one of:

- id.base.extended_cc is SFF8024_ECC_10GBASE_T_SFI,
  SFF8024_ECC_10GBASE_T_SR, SFF8024_ECC_5GBASE_T, or
  SFF8024_ECC_2_5GBASE_T.
- id.base.e1000_base_t is set.

So, we only need the MDIO bus to be registered if one of those is true.

As you are introducing "enum mdio_i2c_proto", I'm wondering whether
that should include "MDIO_I2C_NONE", and we should only register the
bus and probe for a PHY if it is not MDIO_I2C_NONE.

Maybe we should have:

enum mdio_i2c_proto {
	MDIO_I2C_NONE,
	MDIO_I2C_MARVELL_C22,
	MDIO_I2C_C45,
	MDIO_I2C_ROLLBALL,
	...
};

with:

	sfp->mdio_protocol = MDIO_I2C_NONE;
	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
		sfp->module_t_wait = T_WAIT_ROLLBALL;
	} else {
		switch (id.base.extended_cc) {
		...
		}
	}

static int sfp_sm_add_mdio_bus(struct sfp *sfp)
{
	int err = 0;

	if (sfp->mdio_protocol != MDIO_I2C_NONE)
		err = sfp_i2c_mdiobus_create(sfp);

	return err;
}

called from the place you call sfp_i2c_mdiobus_create(), and
sfp_sm_probe_for_phy() becomes:

static int sfp_sm_probe_for_phy(struct sfp *sfp)
{
	int err = 0;

	switch (sfp->mdio_protocol) {
	case MDIO_I2C_NONE:
		break;

	case MDIO_I2C_MARVELL_C22:
		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, false);
		break;

	case MDIO_I2C_C45:
		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, true);
		break;

	case MDIO_I2C_ROLLBALL:
		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR_ROLLBALL, true);
		break;
	}

	return err;
}

This avoids having to add the PHY address, as well as fudge around with
id.base.extended_cc to get the PHY probed.

Thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
