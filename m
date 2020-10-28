Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8686429DA01
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgJ1XKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgJ1XKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:10:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E39E20790;
        Wed, 28 Oct 2020 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603926608;
        bh=r9Zy2d7qonECfYn+ukG4XqOXK6cjfQvsTZGTxsOyDY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o7lTD/lW88bXfc5c5Hg5/vzYWVNlGk+4AfMZ0JyF25ERnV6bthVoeqIu+fFXQ9tZx
         pIjJXFW3o1s5Jbq5wpgHzatK9YOwkfS2J97YAJuwJMhNeFG7QVtdpVk0UeTLU0Of7k
         4jKflrPtlcGR3IkF/Po1y7tVVykV3E8yT9JfCyKw=
Date:   Wed, 28 Oct 2020 16:10:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8720
Message-ID: <20201028161006.2dcd2a62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 23:25:01 +0000 Badel, Laurent wrote:
> =EF=BB=BFSubject: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8=
720
>=20
> Description:
> A recent patchset [1] added support in the SMSC PHY driver for managing
> the ref clock and therefore removed the PHY_RST_AFTER_CLK_EN flag for the
> LAN8720 chip. The ref clock is passed to the SMSC driver through a new
> property "clocks" in the device tree.
>=20
> There appears to be two potential caveats:
> (i) Building kernel 5.9 without updating the DT with the "clocks"
> property for SMSC PHY, would break systems previously relying on the PHY
> reset workaround (SMSC driver cannot grab the ref clock, so it is still
> managed by FEC, but the PHY is not reset because PHY_RST_AFTER_CLK_EN is
> not set). This may lead to occasional loss of ethernet connectivity in
> these systems, that is difficult to debug.
>=20
> (ii) This defeats the purpose of a previous commit [2] that disabled the
> ref clock for power saving reasons. If a ref clock for the PHY is
> specified in DT, the SMSC driver will keep it always on (confirmed with=20
> scope). While this removes the need for additional PHY resets (only a=20
> single reset is needed after power up), this prevents the FEC from saving
> power by disabling the refclk. Since there may be use cases where one is
> interested in saving power, keep this option available when no ref clock
> is specified for the PHY, by fixing issues with the PHY reset.
>=20
> Main changes proposed to address this:
> (a) Restore PHY_RST_AFTER_CLK_EN for LAN8720, but explicitly clear it if
> the SMSC driver succeeds in retrieving the ref clock.
> (b) Fix phy_reset_after_clk_enable() to work in interrupt mode, by
> re-configuring the PHY registers after reset.
>=20
> Tests: against net tree 5.9, including allyes/no/modconfig. 10 pieces of
> an iMX28-EVK-based board were tested, 3 of which were found to exhibit
> issues when the "clocks" property was left unset. Issues were fixed by
> the present patchset.
>=20
> References:
> [1] commit d65af21842f8 ("net: phy: smsc: LAN8710/20: remove
>     PHY_RST_AFTER_CLK_EN flag")
>     commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
>     support")
> [2] commit e8fcfcd5684a ("net: fec: optimize the clock management to save
>     power")

Please resend with git send-email, if you can.

All the patches have a "Subject: [PATCH" line in the message body,
and Fixes tags are line-wrapped (they should be one line even if they
are long).

> Laurent Badel (5):
>   net:phy:smsc: enable PHY_RST_AFTER_CLK_EN if ref clock is not set
>   net:phy:smsc: expand documentation of clocks property
>   net:phy: add phy_device_reset_status() support
>   net:phy: fix phy_reset_after_clk_enable()
>   net:phy: add SMSC PHY reset on PM restore

There are only 4 patches in the series.

