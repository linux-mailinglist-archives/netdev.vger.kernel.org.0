Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613F7A07D1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfH1QtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:49:12 -0400
Received: from mail.nic.cz ([217.31.204.67]:33592 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfH1QtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:49:12 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 54C491407C6;
        Wed, 28 Aug 2019 18:49:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1567010949; bh=/khu59f2u8Q9XuJ1yt9oBsAiTTqHHUyYBoEphrGVsRk=;
        h=Date:From:To;
        b=QfoUtpL7JhOJCiZ4f9TeVmApn4R3A4jYyHYHR9Fpe9ACrRuV4Vu8zKR6+oR1Tojp6
         gKDGpMeLOdaboedlx9BRtrqHe6MdhzPb7uTrNjrp3+6Rr/MCrhSZyEwAkWHgbhvhhM
         p5dF9FD0pY8n9O7uCtHAHCmZs2TaPxR1OzbXeshU=
Date:   Wed, 28 Aug 2019 18:49:09 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: keep CMODE writable code
 private
Message-ID: <20190828184909.300fdae1@dellmb.labs.office.nic.cz>
In-Reply-To: <20190828162659.10306-1-vivien.didelot@gmail.com>
References: <20190828162659.10306-1-vivien.didelot@gmail.com>
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

On Wed, 28 Aug 2019 12:26:59 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> This is a follow-up patch for commit 7a3007d22e8d ("net: dsa:
> mv88e6xxx: fully support SERDES on Topaz family").
>=20
> Since .port_set_cmode is only called from mv88e6xxx_port_setup_mac and
> mv88e6xxx_phylink_mac_config, it is fine to keep this "make writable"
> code private to the mv88e6341_port_set_cmode implementation, instead
> of adding yet another operation to the switch info structure.
>=20
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 8 --------
>  drivers/net/dsa/mv88e6xxx/chip.h | 1 -
>  drivers/net/dsa/mv88e6xxx/port.c | 9 ++++++++-
>  drivers/net/dsa/mv88e6xxx/port.h | 1 -
>  4 files changed, 8 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> b/drivers/net/dsa/mv88e6xxx/chip.c index 54e88aafba2f..6525075f6bd3
> 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -454,12 +454,6 @@ int mv88e6xxx_port_setup_mac(struct
> mv88e6xxx_chip *chip, int port, int link, goto restore_link;
>  	}
> =20
> -	if (chip->info->ops->port_set_cmode_writable) {
> -		err =3D chip->info->ops->port_set_cmode_writable(chip,
> port);
> -		if (err && err !=3D -EOPNOTSUPP)
> -			goto restore_link;
> -	}
> -
>  	if (chip->info->ops->port_set_cmode) {
>  		err =3D chip->info->ops->port_set_cmode(chip, port,
> mode); if (err && err !=3D -EOPNOTSUPP)
> @@ -2919,7 +2913,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops
> =3D { .port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
>  	.port_link_state =3D mv88e6352_port_link_state,
>  	.port_get_cmode =3D mv88e6352_port_get_cmode,
> -	.port_set_cmode_writable =3D mv88e6341_port_set_cmode_writable,
>  	.port_set_cmode =3D mv88e6341_port_set_cmode,
>  	.port_setup_message_port =3D mv88e6xxx_setup_message_port,
>  	.stats_snapshot =3D mv88e6390_g1_stats_snapshot,
> @@ -3618,7 +3611,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops
> =3D { .port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
>  	.port_link_state =3D mv88e6352_port_link_state,
>  	.port_get_cmode =3D mv88e6352_port_get_cmode,
> -	.port_set_cmode_writable =3D mv88e6341_port_set_cmode_writable,
>  	.port_set_cmode =3D mv88e6341_port_set_cmode,
>  	.port_setup_message_port =3D mv88e6xxx_setup_message_port,
>  	.stats_snapshot =3D mv88e6390_g1_stats_snapshot,
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h
> b/drivers/net/dsa/mv88e6xxx/chip.h index d6b1aa35aa1a..421e8b84bec3
> 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -400,7 +400,6 @@ struct mv88e6xxx_ops {
>  	/* CMODE control what PHY mode the MAC will use, eg. SGMII,
> RGMII, etc.
>  	 * Some chips allow this to be configured on specific ports.
>  	 */
> -	int (*port_set_cmode_writable)(struct mv88e6xxx_chip *chip,
> int port); int (*port_set_cmode)(struct mv88e6xxx_chip *chip, int
> port, phy_interface_t mode);
>  	int (*port_get_cmode)(struct mv88e6xxx_chip *chip, int port,
> u8 *cmode); diff --git a/drivers/net/dsa/mv88e6xxx/port.c
> b/drivers/net/dsa/mv88e6xxx/port.c index 542201214c36..4f841335ea32
> 100644 --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -510,7 +510,8 @@ int mv88e6390_port_set_cmode(struct
> mv88e6xxx_chip *chip, int port, return mv88e6xxx_port_set_cmode(chip,
> port, mode); }
> =20
> -int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
> int port) +static int mv88e6341_port_set_cmode_writable(struct
> mv88e6xxx_chip *chip,
> +					     int port)
>  {
>  	int err, addr;
>  	u16 reg, bits;
> @@ -537,6 +538,8 @@ int mv88e6341_port_set_cmode_writable(struct
> mv88e6xxx_chip *chip, int port) int mv88e6341_port_set_cmode(struct
> mv88e6xxx_chip *chip, int port, phy_interface_t mode)
>  {
> +	int err;
> +
>  	if (port !=3D 5)
>  		return -EOPNOTSUPP;
> =20
> @@ -551,6 +554,10 @@ int mv88e6341_port_set_cmode(struct
> mv88e6xxx_chip *chip, int port, break;
>  	}
> =20
> +	err =3D mv88e6341_port_set_cmode_writable(chip, port);
> +	if (err)
> +		return err;
> +
>  	return mv88e6xxx_port_set_cmode(chip, port, mode);
>  }
> =20
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h
> b/drivers/net/dsa/mv88e6xxx/port.h index e78d68c3e671..d4e9bea6e82f
> 100644 --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -336,7 +336,6 @@ int mv88e6097_port_pause_limit(struct
> mv88e6xxx_chip *chip, int port, u8 in, u8 out);
>  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int
> port, u8 in, u8 out);
> -int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
> int port); int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip,
> int port, phy_interface_t mode);
>  int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,

Reviewed-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
