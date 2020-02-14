Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6213615F610
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389892AbgBNSrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:47:52 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:37722 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgBNSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:47:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581706065; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08Fa+pLah8UyWV+8NCdksFLq62eYzwJRp9fI48pdQnk=;
        b=L7MVffhWzexPuicAmUqPog06SMxfj5O7CDE2vc1RWVM6USElGRW+LN139Sv5TaDSWiMQko
        P2VWt9Xpt05R0PchjqTgh8tX2qKvJNMvrM2f9rRNTGZF6mnzLzlo5MYnuH1UUH/zjJ5GfK
        26OPpn0spUs1k860KGn30J1FDU+cWO8=
Date:   Fri, 14 Feb 2020 15:47:28 -0300
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v2] net: davicom: dm9000: allow to pass MAC address
 through mac_addr module parameter
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Petr =?UTF-8?b?xaB0ZXRpYXI=?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Message-Id: <1581706048.3.3@crapouillou.net>
In-Reply-To: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
References: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolaus,

What I'd suggest is to write a NVMEM driver for the efuse and retrieve=20
the MAC address cleanly with nvmem_get_mac_address().

It shouldn't be hard to do (there's already code for it in the=20
non-upstream 3.18 kernel for the CI20) and you remove the dependency on=20
uboot.

-Paul


Le ven., f=E9vr. 14, 2020 at 17:07, H. Nikolaus Schaller=20
<hns@goldelico.com> a =E9crit :
> The MIPS Ingenic CI20 board is shipped with a quite old u-boot
> (ci20-v2013.10 see https://elinux.org/CI20_Dev_Zone). This passes
> the MAC address through dm9000.mac_addr=3Dxx:xx:xx:xx:xx:xx
> kernel module parameter to give the board a fixed MAC address.
>=20
> This is not processed by the dm9000 driver which assigns a random
> MAC address on each boot, making DHCP assign a new IP address
> each time.
>=20
> So we add a check for the mac_addr module parameter as a last
> resort before assigning a random one. This mechanism can also
> be used outside of u-boot to provide a value through modprobe
> config.
>=20
> To parse the MAC address in a new function get_mac_addr() we
> use an copy adapted from the ksz884x.c driver which provides
> the same functionality.
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/net/ethernet/davicom/dm9000.c | 42=20
> +++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/davicom/dm9000.c=20
> b/drivers/net/ethernet/davicom/dm9000.c
> index 1ea3372775e6..7402030b0352 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -1409,6 +1409,43 @@ static struct dm9000_plat_data=20
> *dm9000_parse_dt(struct device *dev)
>  	return pdata;
>  }
>=20
> +static char *mac_addr =3D ":";
> +module_param(mac_addr, charp, 0);
> +MODULE_PARM_DESC(mac_addr, "MAC address");
> +
> +static void get_mac_addr(struct net_device *ndev, char *macaddr)
> +{
> +	int i =3D 0;
> +	int j =3D 0;
> +	int got_num =3D 0;
> +	int num =3D 0;
> +
> +	while (j < ETH_ALEN) {
> +		if (macaddr[i]) {
> +			int digit;
> +
> +			got_num =3D 1;
> +			digit =3D hex_to_bin(macaddr[i]);
> +			if (digit >=3D 0)
> +				num =3D num * 16 + digit;
> +			else if (':' =3D=3D macaddr[i])
> +				got_num =3D 2;
> +			else
> +				break;
> +		} else if (got_num) {
> +			got_num =3D 2;
> +		} else {
> +			break;
> +		}
> +		if (got_num =3D=3D 2) {
> +			ndev->dev_addr[j++] =3D (u8)num;
> +			num =3D 0;
> +			got_num =3D 0;
> +		}
> +		i++;
> +	}
> +}
> +
>  /*
>   * Search DM9000 board, allocate space and register it
>   */
> @@ -1679,6 +1716,11 @@ dm9000_probe(struct platform_device *pdev)
>  			ndev->dev_addr[i] =3D ior(db, i+DM9000_PAR);
>  	}
>=20
> +	if (!is_valid_ether_addr(ndev->dev_addr)) {
> +		mac_src =3D "param";
> +		get_mac_addr(ndev, mac_addr);
> +	}
> +
>  	if (!is_valid_ether_addr(ndev->dev_addr)) {
>  		inv_mac_addr =3D true;
>  		eth_hw_addr_random(ndev);
> --
> 2.23.0
>=20

=

