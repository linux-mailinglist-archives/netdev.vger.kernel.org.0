Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C518394831
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE1VQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhE1VQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F21611C2;
        Fri, 28 May 2021 21:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622236513;
        bh=nIfoBErs1of9jasC9RQquIGr8gvSQ+CYSavjkkyDdvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dHHABB6oVyIxhPxVGrORxTSs/FVhmVRGGTxxwZb/C4pz/wiIOZAZzona98BXilDBk
         7IbfxoL+6wumHVAb/aAeANE3zomi86S3/HwdUGwk4ADM5Mq4xFhUlTowSLqR3cM5hh
         nHn7l0YRRb95sDCyJXX+98EMJhWNV7ToSJOv2zvIivVOQWXPX3MY4WiiWUl9wiW9ie
         9mYpw8zqM70hGuzJFIriVZv0/Q4gOclxoQ57hO9H4TOTOAl1s5JMh4BLzp/gkiw3W6
         CmYc0TglYb/igW2hvtr0QUjldUH501kQfRIA/MOFMsUmiOO8yVA9bmPdzw/WcyxklV
         FPHNpO+ROeCHw==
Date:   Fri, 28 May 2021 14:15:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next 1/2] net: dsa: qca8k: check return value of read
 functions correctly
Message-ID: <20210528141512.6677afec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528082240.3863991-2-yangyingliang@huawei.com>
References: <20210528082240.3863991-1-yangyingliang@huawei.com>
        <20210528082240.3863991-2-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:22:39 +0800 Yang Yingliang wrote:
> Current return type of qca8k_mii_read32() and qca8k_read() are
> unsigned, it can't be negative, so the return value check is
> unuseful. For check the return value correctly, change return
> type of the read functions and add a output parameter to store
> the read value.
>=20
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

> @@ -1141,6 +1128,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int=
 port, unsigned int mode,
>  {
>  	struct qca8k_priv *priv =3D ds->priv;
>  	u32 reg, val;
> +	int ret;
> =20
>  	switch (port) {
>  	case 0: /* 1st CPU port */
> @@ -1211,7 +1199,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int=
 port, unsigned int mode,
>  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> =20
>  		/* Enable/disable SerDes auto-negotiation as necessary */
> -		val =3D qca8k_read(priv, QCA8K_REG_PWS);
> +		ret =3D qca8k_read(priv, QCA8K_REG_PWS, &val);
>  		if (phylink_autoneg_inband(mode))
>  			val &=3D ~QCA8K_PWS_SERDES_AEN_DIS;
>  		else
> @@ -1219,7 +1207,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int=
 port, unsigned int mode,
>  		qca8k_write(priv, QCA8K_REG_PWS, val);
> =20
>  		/* Configure the SGMII parameters */
> -		val =3D qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> +		ret =3D qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
> =20
>  		val |=3D QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
>  			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;

drivers/net/dsa/qca8k.c: In function =E2=80=98qca8k_phylink_mac_config=E2=
=80=99:
drivers/net/dsa/qca8k.c:1131:6: warning: variable =E2=80=98ret=E2=80=99 set=
 but not used [-Wunused-but-set-variable]
 1131 |  int ret;
      |      ^~~
