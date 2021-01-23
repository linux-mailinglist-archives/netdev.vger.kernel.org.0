Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593E30120E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbhAWBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbhAWBhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:37:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625FF23B55;
        Sat, 23 Jan 2021 01:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611365793;
        bh=kZIXz5RL0YNBD+BfkX8CUOfgUtS7jsLyaO6rWl6A9T4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OtJjDBi9fyNQWx5MffCII2uFS+7W5aNO6478BdWACi16iZX1i21Ny5Y08ZBpaSTsV
         0uPt/v8xgp05HGBhFGna/l/bKKySt+UBzsTcgXeqyBp+3i0/ELepfDAfJ52FTeiJKC
         8dLq4gj8iLAxqycDH4KPfdzr0pDsftvwYAekAFK/6qPwaEpJQ7P9WObttlSno6aP4f
         59N1OTt9AMWAwHAokk1PkRM3WulGYVHmYGqm8RYBcabRu9U8gZbYhDp1d3go+9KrYC
         jMX1ycC68iFKvPAldeiN9XcAzIWoIR34WRDBwSZHbPBh7AsNjEA2lRgnF3LSm+U7nH
         LBloYRfy885Cg==
Date:   Fri, 22 Jan 2021 17:36:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Laurent Badel <laurentbadel@eaton.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/1] net: fec: Fix temporary RMII clock reset on
 link up
Message-ID: <20210122173632.25db0d09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122151347.30417-2-laurentbadel@eaton.com>
References: <20210122151347.30417-1-laurentbadel@eaton.com>
        <20210122151347.30417-2-laurentbadel@eaton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 16:13:47 +0100 Laurent Badel wrote:
> =EF=BB=BFfec_restart() does a hard reset of the MAC module when the link =
status
> changes to up. This temporarily resets the R_CNTRL register which controls
> the MII mode of the ENET_OUT clock. In the case of RMII, the clock
> frequency momentarily drops from 50MHz to 25MHz until the register is
> reconfigured. Some link partners do not tolerate this glitch and
> invalidate the link causing failure to establish a stable link when using
> PHY polling mode. Since as per IEEE802.11 the criteria for link validity=
=20
> are PHY-specific, what the partner should tolerate cannot be assumed, so=
=20
> avoid resetting the MII clock by using software reset instead of hardware=
=20
> reset when the link is up. This is generally relevant only if the SoC=20
> provides the clock to an external PHY and the PHY is configured for RMII.

>  static const struct fec_devinfo fec_imx6q_info =3D {
> @@ -953,7 +954,8 @@ fec_restart(struct net_device *ndev)
>  	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
>  	 * instead of reset MAC itself.
>  	 */
> -	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
> +	if (fep->quirks & FEC_QUIRK_HAS_AVB ||
> +	    (fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link) {
>  		writel(0, fep->hwp + FEC_ECNTRL);
>  	} else {
>  		writel(1, fep->hwp + FEC_ECNTRL);

drivers/net/ethernet/freescale/fec_main.c: In function =E2=80=98fec_restart=
=E2=80=99:
drivers/net/ethernet/freescale/fec_main.c:958:46: warning: suggest parenthe=
ses around =E2=80=98&&=E2=80=99 within =E2=80=98||=E2=80=99 [-Wparentheses]
  958 |      (fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link) {
      |      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
