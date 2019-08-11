Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1A88F05
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 03:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHKB5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 21:57:03 -0400
Received: from mail.nic.cz ([217.31.204.67]:46684 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfHKB5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 21:57:03 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 7F3CE140BB6;
        Sun, 11 Aug 2019 03:47:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565488062; bh=VUbzR1diTFcPxuQ4KhHZImhBUkMdHZ0VbIlnKoYDvDg=;
        h=Date:From:To;
        b=JKnHWRnESsP8mtWhhU3eqznA+HI2I0f0mXIGVjSmD1C6LzOp1eJ6FKr2yr3wJB4kq
         1kpLiqEkFKfLwaQWiCoewMCYqIh3m0LL34Zy2/ArmckQmFtvo0pbUarMA9RFQPhtns
         Vk69u9gZxQbejqkBW65P9yH6fJ/JSdE/EipLRy2o=
Date:   Sun, 11 Aug 2019 03:47:42 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/1] net: dsa: fix fixed-link port registration
Message-ID: <20190811034742.349f0ef1@nic.cz>
In-Reply-To: <20190811014650.28141-1-marek.behun@nic.cz>
References: <20190811014650.28141-1-marek.behun@nic.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should probably go into stable as well, after review.

Marek

On Sun, 11 Aug 2019 03:46:50 +0200
Marek Beh=C3=BAn <marek.behun@nic.cz> wrote:

> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
> genphy_read_status") broke fixed link DSA port registration in
> dsa_port_fixed_link_register_of: the genphy_read_status does not do what
> it is supposed to and the following adjust_link is given wrong
> parameters.
>=20
> This causes a regression on Turris Omnia, where the mvneta driver for
> the interface connected to the switch reports crc errors, for some
> reason.
>=20
> I realize this fix is not ideal, something else could change in genphy
> functions which could cause DSA fixed-link port to break again.
> Hopefully DSA fixed-link port functionality will be converted to phylink
> API soon.
>=20
> Signed-off-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  net/dsa/port.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 363eab6df51b..c424ebb373e1 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -485,6 +485,17 @@ static int dsa_port_fixed_link_register_of(struct ds=
a_port *dp)
>  	phydev->interface =3D mode;
> =20
>  	genphy_config_init(phydev);
> +
> +	/*
> +	 * Commit 88d6272acaaa caused genphy_read_status not to do it's work if
> +	 * autonegotiation is enabled and link status did not change. This is
> +	 * the case for fixed_phy. By setting phydev->link =3D 0 before the call
> +	 * to genphy_read_status we force it to read and fill in the parameters.
> +	 *
> +	 * Hopefully this dirty hack will be removed soon by converting DSA
> +	 * fixed link ports to phylink API.
> +	 */
> +	phydev->link =3D 0;
>  	genphy_read_status(phydev);
> =20
>  	if (ds->ops->adjust_link)

