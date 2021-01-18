Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688092FA38D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392971AbhARObl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390822AbhARLn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:43:28 -0500
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE9DC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 03:42:48 -0800 (PST)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id B753D140567;
        Mon, 18 Jan 2021 12:42:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1610970165; bh=bkKjD8V4h7TpYhFZK3dDiFCYVq1pnWFwnXIz0Fn/F88=;
        h=Date:From:To;
        b=vMxyKxBZYbIWOzbGx0/9DR1XhpXfx5X5g2RzF5lyc4M7Sf+HTkuPXxyCfJq2/yCBt
         ySenQWxgBZ7epRsDEysj9HseAN9daI45quIw0M1FTFzCmsbZPLxKunsJBrYpWT8E3h
         W98JMqTdbIi/xELIDQw2uKSbuKPscbSAcCuKXMTM=
Date:   Mon, 18 Jan 2021 12:42:35 +0100
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v5 4/5] net: sfp: create/destroy I2C mdiobus
 before PHY probe/after PHY release
Message-ID: <20210118124235.467f047e@dellmb.labs.office.nic.cz>
In-Reply-To: <20210118093832.kcbciojnjlcuetb2@pali>
References: <20210114044331.5073-1-kabel@kernel.org>
        <20210114044331.5073-5-kabel@kernel.org>
        <20210114160719.GV1551@shell.armlinux.org.uk>
        <20210118093832.kcbciojnjlcuetb2@pali>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 10:38:32 +0100
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> On Thursday 14 January 2021 16:07:19 Russell King - ARM Linux admin
> wrote:
> > On Thu, Jan 14, 2021 at 05:43:30AM +0100, Marek Beh=C3=BAn wrote: =20
> > > Instead of configuring the I2C mdiobus when SFP driver is probed,
> > > create/destroy the mdiobus before the PHY is probed for/after it
> > > is released.
> > >=20
> > > This way we can tell the mdio-i2c code which protocol to use for
> > > each SFP transceiver. =20
> >=20
> > I've been thinking a bit more about this. It looks like it will
> > allocate and free the MDIO bus each time any module is inserted or
> > removed, even a fiber module that wouldn't ever have a PHY. This
> > adds unnecessary noise to the kernel message log.
> >=20
> > We only probe for a PHY if one of:
> >=20
> > - id.base.extended_cc is SFF8024_ECC_10GBASE_T_SFI,
> >   SFF8024_ECC_10GBASE_T_SR, SFF8024_ECC_5GBASE_T, or
> >   SFF8024_ECC_2_5GBASE_T.
> > - id.base.e1000_base_t is set.
> >=20
> > So, we only need the MDIO bus to be registered if one of those is
> > true.
> >=20
> > As you are introducing "enum mdio_i2c_proto", I'm wondering whether
> > that should include "MDIO_I2C_NONE", and we should only register the
> > bus and probe for a PHY if it is not MDIO_I2C_NONE.
> >=20
> > Maybe we should have:
> >=20
> > enum mdio_i2c_proto {
> > 	MDIO_I2C_NONE,
> > 	MDIO_I2C_MARVELL_C22,
> > 	MDIO_I2C_C45,
> > 	MDIO_I2C_ROLLBALL,
> > 	...
> > };
> >=20
> > with:
> >=20
> > 	sfp->mdio_protocol =3D MDIO_I2C_NONE;
> > 	if (((!memcmp(id.base.vendor_name, "OEM             ", 16)
> > || !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> > 	     (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> > 	      !memcmp(id.base.vendor_pn, "RTSFP-10", 8)))) {
> > 		sfp->mdio_protocol =3D MDIO_I2C_ROLLBALL;
> > 		sfp->module_t_wait =3D T_WAIT_ROLLBALL;
> > 	} else {
> > 		switch (id.base.extended_cc) {
> > 		...
> > 		}
> > 	}
> >=20
> > static int sfp_sm_add_mdio_bus(struct sfp *sfp)
> > {
> > 	int err =3D 0;
> >=20
> > 	if (sfp->mdio_protocol !=3D MDIO_I2C_NONE)
> > 		err =3D sfp_i2c_mdiobus_create(sfp);
> >=20
> > 	return err;
> > }
> >=20
> > called from the place you call sfp_i2c_mdiobus_create(), and
> > sfp_sm_probe_for_phy() becomes:
> >=20
> > static int sfp_sm_probe_for_phy(struct sfp *sfp)
> > {
> > 	int err =3D 0;
> >=20
> > 	switch (sfp->mdio_protocol) {
> > 	case MDIO_I2C_NONE:
> > 		break;
> >=20
> > 	case MDIO_I2C_MARVELL_C22:
> > 		err =3D sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, false);
> > 		break;
> >=20
> > 	case MDIO_I2C_C45:
> > 		err =3D sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, true);
> > 		break;
> >=20
> > 	case MDIO_I2C_ROLLBALL:
> > 		err =3D sfp_sm_probe_phy(sfp, SFP_PHY_ADDR_ROLLBALL,
> > true); break;
> > 	}
> >=20
> > 	return err;
> > }
> >=20
> > This avoids having to add the PHY address, as well as fudge around
> > with id.base.extended_cc to get the PHY probed.
> >=20
> > Thoughts? =20
>=20
> Hello Russell! For me this solution looks more cleaner. As all those
> MDIO access protocols are vendor dependent, kernel code should not
> detect them only from the standard (non-vendor) extended_cc property.

I shall respin this series with this modified, then.

Marek
