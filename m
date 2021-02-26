Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A3325F1F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 09:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBZIe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 03:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBZIeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 03:34:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD29C061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 00:33:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lFYYp-00083f-NX; Fri, 26 Feb 2021 09:33:19 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:adc1:3ee1:6274:c5d0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BFCFC5E9929;
        Fri, 26 Feb 2021 08:33:16 +0000 (UTC)
Date:   Fri, 26 Feb 2021 09:33:15 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210226083315.cutpxc4iety4qedp@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-6-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ydqkgs77xla5x3p"
Content-Disposition: inline
In-Reply-To: <20210225215155.30509-6-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3ydqkgs77xla5x3p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.02.2021 22:51:54, Dario Binacchi wrote:
> As pointed by commit c0a9f4d396c9 ("can: c_can: Reduce register access")
> the "driver casts the 16 message objects in stone, which is completely
> braindead as contemporary hardware has up to 128 message objects".
>=20
> The patch prepares the module to extend the number of message objects
> beyond the 32 currently managed. This was achieved by transforming the
> constants used to manage RX/TX messages into variables without changing
> the driver policy.
>=20
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> ---
>=20
> Changes in v2:
> - Fix compiling error reported by kernel test robot.
> - Add Reported-by tag.
> - Pass larger size to alloc_candev() routine to avoid an additional
>   memory allocation/deallocation.
>=20
>  drivers/net/can/c_can/c_can.c          | 50 ++++++++++++++++----------
>  drivers/net/can/c_can/c_can.h          | 23 ++++++------
>  drivers/net/can/c_can/c_can_pci.c      |  2 +-
>  drivers/net/can/c_can/c_can_platform.c |  2 +-
>  4 files changed, 43 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index 7081cfaf62e2..df1ad6b3fd3b 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
> @@ -173,9 +173,6 @@
>  /* Wait for ~1 sec for INIT bit */
>  #define INIT_WAIT_MS		1000
> =20
> -/* napi related */
> -#define C_CAN_NAPI_WEIGHT	C_CAN_MSG_OBJ_RX_NUM
> -
>  /* c_can lec values */
>  enum c_can_lec_type {
>  	LEC_NO_ERROR =3D 0,
> @@ -325,7 +322,7 @@ static void c_can_setup_tx_object(struct net_device *=
dev, int iface,
>  	 * first, i.e. clear the MSGVAL flag in the arbiter.
>  	 */
>  	if (rtr !=3D (bool)test_bit(idx, &priv->tx_dir)) {
> -		u32 obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> +		u32 obj =3D idx + priv->msg_obj_tx_first;
> =20
>  		c_can_inval_msg_object(dev, iface, obj);
>  		change_bit(idx, &priv->tx_dir);
> @@ -463,10 +460,10 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff =
*skb,
>  	 * prioritized. The lowest buffer number wins.
>  	 */
>  	idx =3D fls(atomic_read(&priv->tx_active));
> -	obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> +	obj =3D idx + priv->msg_obj_tx_first;
> =20
>  	/* If this is the last buffer, stop the xmit queue */
> -	if (idx =3D=3D C_CAN_MSG_OBJ_TX_NUM - 1)
> +	if (idx =3D=3D priv->msg_obj_tx_num - 1)
>  		netif_stop_queue(dev);
>  	/*
>  	 * Store the message in the interface so we can call
> @@ -549,17 +546,18 @@ static int c_can_set_bittiming(struct net_device *d=
ev)
>   */
>  static void c_can_configure_msg_objects(struct net_device *dev)
>  {
> +	struct c_can_priv *priv =3D netdev_priv(dev);
>  	int i;
> =20
>  	/* first invalidate all message objects */
> -	for (i =3D C_CAN_MSG_OBJ_RX_FIRST; i <=3D C_CAN_NO_OF_OBJECTS; i++)
> +	for (i =3D priv->msg_obj_rx_first; i <=3D priv->msg_obj_num; i++)
>  		c_can_inval_msg_object(dev, IF_RX, i);
> =20
>  	/* setup receive message objects */
> -	for (i =3D C_CAN_MSG_OBJ_RX_FIRST; i < C_CAN_MSG_OBJ_RX_LAST; i++)
> +	for (i =3D priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
>  		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
> =20
> -	c_can_setup_receive_object(dev, IF_RX, C_CAN_MSG_OBJ_RX_LAST, 0, 0,
> +	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
>  				   IF_MCONT_RCV_EOB);
>  }
> =20
> @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
>  	while ((idx =3D ffs(pend))) {
>  		idx--;
>  		pend &=3D ~(1 << idx);
> -		obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> +		obj =3D idx + priv->msg_obj_tx_first;
>  		c_can_inval_tx_object(dev, IF_TX, obj);
>  		can_get_echo_skb(dev, idx, NULL);
>  		bytes +=3D priv->dlc[idx];
> @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
>  	/* Clear the bits in the tx_active mask */
>  	atomic_sub(clr, &priv->tx_active);
> =20
> -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
>  		netif_wake_queue(dev);
> =20
>  	if (pkts) {
> @@ -755,11 +753,11 @@ static void c_can_do_tx(struct net_device *dev)
>   * raced with the hardware or failed to readout all upper
>   * objects in the last run due to quota limit.
>   */
> -static u32 c_can_adjust_pending(u32 pend)
> +static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
>  {
>  	u32 weight, lasts;
> =20
> -	if (pend =3D=3D RECEIVE_OBJECT_BITS)
> +	if (pend =3D=3D rx_mask)
>  		return pend;
> =20
>  	/*
> @@ -862,8 +860,7 @@ static int c_can_do_rx_poll(struct net_device *dev, i=
nt quota)
>  	 * It is faster to read only one 16bit register. This is only possible
>  	 * for a maximum number of 16 objects.
>  	 */
> -	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
> -			"Implementation does not support more message objects than 16");
> +	WARN_ON(priv->msg_obj_rx_last > 16);
> =20
>  	while (quota > 0) {
>  		if (!pend) {
> @@ -874,7 +871,8 @@ static int c_can_do_rx_poll(struct net_device *dev, i=
nt quota)
>  			 * If the pending field has a gap, handle the
>  			 * bits above the gap first.
>  			 */
> -			toread =3D c_can_adjust_pending(pend);
> +			toread =3D c_can_adjust_pending(pend,
> +						      priv->msg_obj_rx_mask);
>  		} else {
>  			toread =3D pend;
>  		}
> @@ -1205,17 +1203,31 @@ static int c_can_close(struct net_device *dev)
>  	return 0;
>  }
> =20
> -struct net_device *alloc_c_can_dev(void)
> +struct net_device *alloc_c_can_dev(int msg_obj_num)
>  {
>  	struct net_device *dev;
>  	struct c_can_priv *priv;
> +	int msg_obj_tx_num =3D msg_obj_num / 2;
> =20
> -	dev =3D alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> +	dev =3D alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> +			   msg_obj_tx_num);
>  	if (!dev)
>  		return NULL;
> =20
>  	priv =3D netdev_priv(dev);
> -	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
> +	priv->msg_obj_num =3D msg_obj_num;
> +	priv->msg_obj_rx_num =3D msg_obj_num - msg_obj_tx_num;
> +	priv->msg_obj_rx_first =3D 1;
> +	priv->msg_obj_rx_last =3D
> +		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
> +	priv->msg_obj_rx_mask =3D ((u64)1 << priv->msg_obj_rx_num) - 1;
> +
> +	priv->msg_obj_tx_num =3D msg_obj_tx_num;
> +	priv->msg_obj_tx_first =3D priv->msg_obj_rx_last + 1;
> +	priv->msg_obj_tx_last =3D
> +		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
> +
> +	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
> =20
>  	priv->dev =3D dev;
>  	priv->can.bittiming_const =3D &c_can_bittiming_const;
> diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
> index 90d3d2e7a086..22ae6077b489 100644
> --- a/drivers/net/can/c_can/c_can.h
> +++ b/drivers/net/can/c_can/c_can.h
> @@ -22,18 +22,7 @@
>  #ifndef C_CAN_H
>  #define C_CAN_H
> =20
> -/* message object split */
>  #define C_CAN_NO_OF_OBJECTS	32
> -#define C_CAN_MSG_OBJ_RX_NUM	16
> -#define C_CAN_MSG_OBJ_TX_NUM	16
> -
> -#define C_CAN_MSG_OBJ_RX_FIRST	1
> -#define C_CAN_MSG_OBJ_RX_LAST	(C_CAN_MSG_OBJ_RX_FIRST + \
> -				C_CAN_MSG_OBJ_RX_NUM - 1)
> -
> -#define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
> -
> -#define RECEIVE_OBJECT_BITS	0x0000ffff
> =20
>  enum reg {
>  	C_CAN_CTRL_REG =3D 0,
> @@ -193,6 +182,14 @@ struct c_can_priv {
>  	struct napi_struct napi;
>  	struct net_device *dev;
>  	struct device *device;
> +	int msg_obj_num;
> +	int msg_obj_rx_num;
> +	int msg_obj_tx_num;
> +	int msg_obj_rx_first;
> +	int msg_obj_rx_last;
> +	int msg_obj_tx_first;
> +	int msg_obj_tx_last;

I think these should/could be unsigned int.

> +	u32 msg_obj_rx_mask;

Is this variable big enough after you've extended the driver to use 64
mailboxes?

If you want to support 128 message objects converting the driver to the
linux bitmap API is another option.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3ydqkgs77xla5x3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA4skkACgkQqclaivrt
76nZTwf/c9SRJf+NPMxZZwsneaFxgV1Ph0EIMjBb/Bi3su0f+KHOZZPr8xQz4pDA
8bNp4A0RDaGVtywg9aTJLf2ft/DgI9G0jl3q9KTCxZ+pUZ0t6z2cGdA5ZpThHXg+
DUsxYj3DC5dpCmOyHNzeJTg7859clKSTdPHgvwnVkHNesouOBpmqtVUSWWKuewSF
e+0xEnUmu0ovu9zilrzj3i9BeO9s+y2yu6ryORjBshbGyAOom/JBqvzcN+tkS4Eh
VB5hnNIV5yij93rG/bhbdhMI88mMWp5Ml+Mb28kiJFwXp7fU3YwDEC/7L5DLdRX4
MFYh8jfkopBMeJY3ur0yOnfOYCA3uQ==
=dq56
-----END PGP SIGNATURE-----

--3ydqkgs77xla5x3p--
