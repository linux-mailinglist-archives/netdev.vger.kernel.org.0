Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6562F3FD3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394719AbhALWhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbhALWhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 17:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18A54230FC;
        Tue, 12 Jan 2021 22:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610491025;
        bh=jMuozw1wk6urfXjX2p+Gvg1jkF8790rG3jwMomrxAKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gFlMsW3xP3BQBLmimfOdw7Zh/DEtowgqMrvJiojDV/v9VD7TIVHTf8emVa2G7HHK1
         yUQaBTIf6aaOw2I3XH3X4B0GEORy0MWPdPA30YiHUnJEs7Rre6zFBg4JcDBoOMItsy
         2BjAEGxsv3vcB77ZQD7ZeUe+PRVqNBc5T1NoGlHA1jq/ucLHROpw4p0ExxtMQY4fmS
         Gt8tENOg/ClT8yjqlEXb0I+TP9tU0h3VGt8vRwa8/aNevAJmoJMwst62GAWcJBoNzq
         ZZK0jgK8b0OKD21ttoaPMv992zAxfz4zOXS/oM1Etx101UeC8IzbynHQn+cC40CKxO
         Ot6snn6UOZVZA==
Date:   Tue, 12 Jan 2021 23:36:58 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112233658.4c938348@kernel.org>
In-Reply-To: <20210112195405.12890-6-kabel@kernel.org>
References: <20210112195405.12890-1-kabel@kernel.org>
        <20210112195405.12890-6-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 20:54:04 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> +	/* mv88e6393x family errata 3.7 :
> +	 * When changing cmode on SERDES port from any other mode to 1000BASE-X
> +	 * mode the link may not come up due to invalid 1000BASE-X
> +	 * advertisement.
> +	 * Workaround: Correct advertisement and reset PHY core.
> +	 */
> +	if (cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
> +		reg =3D MV88E6390_SGMII_ANAR_1000BASEX_FD;
> +		err =3D mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +					     MV88E6390_SGMII_ANAR, reg);
> +		if (err)
> +			return err;
> +
> +		/* soft reset the PCS/PMA */
> +		err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +					    MV88E6390_SGMII_CONTROL, &reg);
> +		if (err)
> +			return err;
> +
> +		reg |=3D MV88E6390_SGMII_CONTROL_RESET;
> +		err =3D mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +					     MV88E6390_SGMII_CONTROL, reg);
> +		if (err)
> +			return err;

It would seem that this is already done in
mv88e6390_serdes_pcs_config, just without the last reset.

> +#define MV88E6390_SGMII_STATUS_AN_ABLE	BIT(3)
> +#define MV88E6390_SGMII_ANAR	0x2004
> +#define MV88E6390_SGMII_ANAR_1000BASEX_FD	BIT(5)
> +#define MV88E6390_SGMII_CONTROL		0x2000

This register is already called MV88E6390_SGMII_BMCR and the bits are
defined as BMCR_* macros. Thse same for MV88E6390_SGMII_STATUS and
MV88E6390_SGMII_ANAR.

> +#define MV88E6390_SGMII_CONTROL_RESET		BIT(15)
> +#define MV88E6390_SGMII_CONTROL_LOOPBACK	BIT(14)
> +#define MV88E6390_SGMII_CONTROL_PDOWN		BIT(11)
> +#define MV88E6390_SGMII_STATUS		0x2001

I shall fix this in another version.
