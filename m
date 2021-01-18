Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4042F9D07
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbhARKns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388113AbhARJjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 04:39:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF6D22240;
        Mon, 18 Jan 2021 09:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610962714;
        bh=xf7ovFx31ZaLY2y+UGO3bswHVltAepIKbcx0CwbTAEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UY4vGCbCUKTB+npbtB/jKRlKWTC6P5XvBXcjOoYgiio15MuRseJApjhfxdgJO9ly8
         id4SDmLDrClxMcJAbF6VT5xFe/cPOY+oO7BH5Lg+Oc16+gl/ZZAtNkwoZl83Fejm7U
         W4bYKPeUzLxm+UbDagch3HWUvtgPka8UtA4kQef/lya5Bkd3XoKVxKStZqhR7Q3o/q
         EERRdPH9sJRmu2Wp1d4ETwDwx216RVqjQ6OIpSncU53tKO+Tn5Kaig314p6aZps9YB
         bPPRkk6IfFsu3YZjoMHmWZdwkFmtQV1wKg8cwKw/Q3AlqMdt+ZFaN0r2vYxoXpRuug
         A8594HAduFLHQ==
Received: by pali.im (Postfix)
        id 8B680889; Mon, 18 Jan 2021 10:38:32 +0100 (CET)
Date:   Mon, 18 Jan 2021 10:38:32 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v5 4/5] net: sfp: create/destroy I2C mdiobus
 before PHY probe/after PHY release
Message-ID: <20210118093832.kcbciojnjlcuetb2@pali>
References: <20210114044331.5073-1-kabel@kernel.org>
 <20210114044331.5073-5-kabel@kernel.org>
 <20210114160719.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114160719.GV1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 14 January 2021 16:07:19 Russell King - ARM Linux admin wrote:
> On Thu, Jan 14, 2021 at 05:43:30AM +0100, Marek Behún wrote:
> > Instead of configuring the I2C mdiobus when SFP driver is probed,
> > create/destroy the mdiobus before the PHY is probed for/after it is
> > released.
> > 
> > This way we can tell the mdio-i2c code which protocol to use for each
> > SFP transceiver.
> 
> I've been thinking a bit more about this. It looks like it will
> allocate and free the MDIO bus each time any module is inserted or
> removed, even a fiber module that wouldn't ever have a PHY. This adds
> unnecessary noise to the kernel message log.
> 
> We only probe for a PHY if one of:
> 
> - id.base.extended_cc is SFF8024_ECC_10GBASE_T_SFI,
>   SFF8024_ECC_10GBASE_T_SR, SFF8024_ECC_5GBASE_T, or
>   SFF8024_ECC_2_5GBASE_T.
> - id.base.e1000_base_t is set.
> 
> So, we only need the MDIO bus to be registered if one of those is true.
> 
> As you are introducing "enum mdio_i2c_proto", I'm wondering whether
> that should include "MDIO_I2C_NONE", and we should only register the
> bus and probe for a PHY if it is not MDIO_I2C_NONE.
> 
> Maybe we should have:
> 
> enum mdio_i2c_proto {
> 	MDIO_I2C_NONE,
> 	MDIO_I2C_MARVELL_C22,
> 	MDIO_I2C_C45,
> 	MDIO_I2C_ROLLBALL,
> 	...
> };
> 
> with:
> 
> 	sfp->mdio_protocol = MDIO_I2C_NONE;
> 	if (((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> 	      !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> 	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> 	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
> 		sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
> 		sfp->module_t_wait = T_WAIT_ROLLBALL;
> 	} else {
> 		switch (id.base.extended_cc) {
> 		...
> 		}
> 	}
> 
> static int sfp_sm_add_mdio_bus(struct sfp *sfp)
> {
> 	int err = 0;
> 
> 	if (sfp->mdio_protocol != MDIO_I2C_NONE)
> 		err = sfp_i2c_mdiobus_create(sfp);
> 
> 	return err;
> }
> 
> called from the place you call sfp_i2c_mdiobus_create(), and
> sfp_sm_probe_for_phy() becomes:
> 
> static int sfp_sm_probe_for_phy(struct sfp *sfp)
> {
> 	int err = 0;
> 
> 	switch (sfp->mdio_protocol) {
> 	case MDIO_I2C_NONE:
> 		break;
> 
> 	case MDIO_I2C_MARVELL_C22:
> 		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, false);
> 		break;
> 
> 	case MDIO_I2C_C45:
> 		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, true);
> 		break;
> 
> 	case MDIO_I2C_ROLLBALL:
> 		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR_ROLLBALL, true);
> 		break;
> 	}
> 
> 	return err;
> }
> 
> This avoids having to add the PHY address, as well as fudge around with
> id.base.extended_cc to get the PHY probed.
> 
> Thoughts?

Hello Russell! For me this solution looks more cleaner. As all those
MDIO access protocols are vendor dependent, kernel code should not
detect them only from the standard (non-vendor) extended_cc property.
