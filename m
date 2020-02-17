Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC5160F7A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgBQKEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:04:42 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:24972 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgBQKEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581933879;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=WlFXLxvyuSdeLPVhHeNf/htnxgHvI08mk7X1kR98xrc=;
        b=UDRImApxtyQPSHA+HEpIP/YcOGowSkqAeGIAYueMHugTgStfBO2GuyZYddLv3B5nQF
        IuEJVml3jCalRJhafxM8QlN63t56K2ml/PFIYUos1By+BvsojGrUHF7sZn2YW3nlaW8X
        6I+VZ1DIHlUfIPEb9dwfxj7EP6cXb75e3XuKAymwj8M0hWLvPvuCpRSXNQEQ3xsdlTp1
        U4+9su0qU7hnF35/Hhx+iOdp9vTk78Jiekf88xht7UvJt8hSt4xFFZ96EjH1ZRGzoDE1
        HqiUZ6o/7CSb1U4EYrFLzhc0+pF2bc1R52emI/HaR3s929SUgmAx+xH0fa0sVskEPnmM
        X1BA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDVCaXA0OXQ=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1HA4aLrs
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Mon, 17 Feb 2020 11:04:36 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200216193943.81134-1-paul@crapouillou.net>
Date:   Mon, 17 Feb 2020 11:04:35 +0100
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mathieu Malaterre <malat@debian.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1513E253-0E58-4088-84E2-E35F3067BB4B@goldelico.com>
References: <20200216193943.81134-1-paul@crapouillou.net>
To:     Paul Cercueil <paul@crapouillou.net>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

> Am 16.02.2020 um 20:39 schrieb Paul Cercueil <paul@crapouillou.net>:
>=20
> The call to of_get_mac_address() can return -EPROBE_DEFER, for =
instance
> when the MAC address is read from a NVMEM driver that did not probe =
yet.

a quick test on the CI20 board shows that it seems to work. Especially
in this config, which would be broken otherwise:

CONFIG_JZ4780_EFUSE=3Dm
CONFIG_DM9000=3Dy

The other way round is not expected to be a problem.

It also serializes

CONFIG_JZ4780_EFUSE=3Dm
CONFIG_DM9000=3Dm

properly.

What I am not sure is if it handles

CONFIG_JZ4780_EFUSE=3Dy
CONFIG_DM9000=3Dy

always correct.

Is the EPROBE_DEFER mechanism also working for drivers
fully compiled into the kernel (I may have been mislead
since EPROBE_DEFER patches are almost always done to make
drivers work as modules)?

If not, it depends on luck to have the EFUSE driver probed
successfully before DM9000.

Anyways you can add my Tested-by: H. Nikolaus Schaller =
<hns@goldelico.com>

BR and thanks,
Nikolaus

>=20
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Mathieu Malaterre <malat@debian.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
> drivers/net/ethernet/davicom/dm9000.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/davicom/dm9000.c =
b/drivers/net/ethernet/davicom/dm9000.c
> index 1ea3372775e6..e94ae9b94dbf 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -1405,6 +1405,8 @@ static struct dm9000_plat_data =
*dm9000_parse_dt(struct device *dev)
> 	mac_addr =3D of_get_mac_address(np);
> 	if (!IS_ERR(mac_addr))
> 		ether_addr_copy(pdata->dev_addr, mac_addr);
> +	else if (PTR_ERR(mac_addr) =3D=3D -EPROBE_DEFER)
> +		return ERR_CAST(mac_addr);
>=20
> 	return pdata;
> }
> --=20
> 2.25.0
>=20

