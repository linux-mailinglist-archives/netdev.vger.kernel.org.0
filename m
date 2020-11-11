Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EDD2AF659
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKKQ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgKKQ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:28:58 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F4A20678;
        Wed, 11 Nov 2020 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605112138;
        bh=0NjO8soZFF76i5lglSfHtT1dSXx3aoySJfwLc6sFW5U=;
        h=In-Reply-To:References:Subject:To:Cc:From:Date:From;
        b=Tk8qigXxNsXiQ7iF4IVVOfDhTaZg/DnDIIemvFZgnWuN3sLMNxOPw/LRSre7fIG3E
         9oxzrmCefW5Dq+RvNGxOT91QXf3PfZdX4qSLSWXJUS72SQaDyIwgos3WO4RoveWZvL
         SmKybzUnq8Jur5azjgPNlGJENzPgxp29Kcct6sQ4=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201111151753.840364-1-steen.hegelund@microchip.com>
References: <20201111151753.840364-1-steen.hegelund@microchip.com>
Subject: Re: [net v2] net: phy: mscc: adjust the phy support for PTP and MACsec
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <160511213375.165477.17752694389005766821@surface.local>
Date:   Wed, 11 Nov 2020 17:28:54 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

Quoting Steen Hegelund (2020-11-11 16:17:53)
> The MSCC PHYs selected for PTP and MACSec was not correct
>=20
> - PTP
>     - Add VSC8572 and VSC8574
>=20
> - MACsec
>     - Removed VSC8575
>=20
> The relevant datasheets can be found here:
>   - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
>   - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574
>   - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575
>=20
> History:
> v1 -> v2:
>   - Added "fixes:" tags to the commit message
>=20
> Fixes: bb56c016a1257 ("net: phy: mscc: split the driver into separate fil=
es")

This commit splitting the driver didn't introduced the issue, it only
moved code around. You can remove this Fixes tag. (You usually/should
have a single Fixes tag per patch).

> Fixes: ab2bf93393571 ("net: phy: mscc: 1588 block initialization")

The PTP and the MACsec support were introduced in separate patches (and
were introduced in different releases of the kernel). This patch is
fixing two different issues then, and its changes can't apply to the
same kernel versions. You should send them in two separate patches.

With the changes sent in two different patches, I would suggest to only
send the MACsec one as a fix for net (it's really fixing something, by
removing a non-compatible PHY from using MACsec) and the PTP one for
net-next as it's adding PTP support for two new PHYs (not fixing
anything).

When you do so, please use the following commands to format the patches,
to end up with the correct prefix in the subject:
git format-patch --subject-prefix=3D'PATCH net' ...
git format-patch --subject-prefix=3D'PATCH net-next' ...

Thanks!
Antoine

> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  drivers/net/phy/mscc/mscc_macsec.c | 1 -
>  drivers/net/phy/mscc/mscc_ptp.c    | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/ms=
cc_macsec.c
> index 1d4c012194e9..72292bf6c51c 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)
> =20
>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
>         case PHY_ID_VSC856X:
> -       case PHY_ID_VSC8575:
>         case PHY_ID_VSC8582:
>         case PHY_ID_VSC8584:
>                 INIT_LIST_HEAD(&vsc8531->macsec_flows);
> diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_=
ptp.c
> index b97ee79f3cdf..f0537299c441 100644
> --- a/drivers/net/phy/mscc/mscc_ptp.c
> +++ b/drivers/net/phy/mscc/mscc_ptp.c
> @@ -1510,6 +1510,8 @@ void vsc8584_config_ts_intr(struct phy_device *phyd=
ev)
>  int vsc8584_ptp_init(struct phy_device *phydev)
>  {
>         switch (phydev->phy_id & phydev->drv->phy_id_mask) {
> +       case PHY_ID_VSC8572:
> +       case PHY_ID_VSC8574:
>         case PHY_ID_VSC8575:
>         case PHY_ID_VSC8582:
>         case PHY_ID_VSC8584:
> --=20
> 2.29.2
>=20
