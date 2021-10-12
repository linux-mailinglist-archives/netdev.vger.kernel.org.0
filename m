Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924D942A7B4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhJLO5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:57:09 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54208 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbhJLO5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:57:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 1A2541F43033
Received: by earth.universe (Postfix, from userid 1000)
        id 234D13C0CA8; Tue, 12 Oct 2021 16:55:05 +0200 (CEST)
Date:   Tue, 12 Oct 2021 16:55:05 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        m.grzeschik@pengutronix.de, balbi@kernel.org
Subject: Re: [PATCH net-next] net: remove single-byte netdev->dev_addr writes
Message-ID: <20211012145505.yddftwyvopkrm6dv@earth.universe>
References: <20211012142757.4124842-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wa6hy7npamzzcyou"
Content-Disposition: inline
In-Reply-To: <20211012142757.4124842-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wa6hy7npamzzcyou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 12, 2021 at 07:27:57AM -0700, Jakub Kicinski wrote:
> Make the drivers which use single-byte netdev addresses
> (netdev->addr_len =3D=3D 1) use the appropriate address setting
> helpers.
>=20
> arcnet copies from int variables and io reads a lot, so
> add a helper for arcnet drivers to use.
>=20
> Similar helper could be reused for phonet and appletalk
> but there isn't any good central location where we could
> put it, and netdevice.h is already very crowded.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/hsi/clients/ssi_protocol.c     | 4 +++-
>  drivers/net/appletalk/cops.c           | 2 +-
>  drivers/net/appletalk/ltpc.c           | 3 +--
>  drivers/net/arcnet/arc-rimi.c          | 5 +++--
>  drivers/net/arcnet/arcdevice.h         | 5 +++++
>  drivers/net/arcnet/com20020-isa.c      | 2 +-
>  drivers/net/arcnet/com20020-pci.c      | 2 +-
>  drivers/net/arcnet/com20020.c          | 4 ++--
>  drivers/net/arcnet/com20020_cs.c       | 2 +-
>  drivers/net/arcnet/com90io.c           | 2 +-
>  drivers/net/arcnet/com90xx.c           | 3 ++-
>  drivers/net/usb/cdc-phonet.c           | 4 +++-
>  drivers/usb/gadget/function/f_phonet.c | 5 ++++-
>  13 files changed, 28 insertions(+), 15 deletions(-)

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com> # for HSI

-- Sebastian

>=20
> diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi=
_protocol.c
> index 96d0eccca3aa..21f11a5b965b 100644
> --- a/drivers/hsi/clients/ssi_protocol.c
> +++ b/drivers/hsi/clients/ssi_protocol.c
> @@ -1055,14 +1055,16 @@ static const struct net_device_ops ssip_pn_ops =
=3D {
> =20
>  static void ssip_pn_setup(struct net_device *dev)
>  {
> +	static const u8 addr =3D PN_MEDIA_SOS;
> +
>  	dev->features		=3D 0;
>  	dev->netdev_ops		=3D &ssip_pn_ops;
>  	dev->type		=3D ARPHRD_PHONET;
>  	dev->flags		=3D IFF_POINTOPOINT | IFF_NOARP;
>  	dev->mtu		=3D SSIP_DEFAULT_MTU;
>  	dev->hard_header_len	=3D 1;
> -	dev->dev_addr[0]	=3D PN_MEDIA_SOS;
>  	dev->addr_len		=3D 1;
> +	dev_addr_set(dev, &addr);
>  	dev->tx_queue_len	=3D SSIP_TXQUEUE_LEN;
> =20
>  	dev->needs_free_netdev	=3D true;
> diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
> index f0695d68c47e..97f254bdbb16 100644
> --- a/drivers/net/appletalk/cops.c
> +++ b/drivers/net/appletalk/cops.c
> @@ -945,8 +945,8 @@ static int cops_ioctl(struct net_device *dev, struct =
ifreq *ifr, int cmd)
>                          dev->broadcast[0]       =3D 0xFF;
>  		=09
>  			/* Set hardware address. */
> -                        dev->dev_addr[0]        =3D aa->s_node;
>                          dev->addr_len           =3D 1;
> +			dev_addr_set(dev, &aa->s_node);
>                          return 0;
> =20
>                  case SIOCGIFADDR:
> diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
> index 1f8925e75b3f..388d7b3bd4c2 100644
> --- a/drivers/net/appletalk/ltpc.c
> +++ b/drivers/net/appletalk/ltpc.c
> @@ -846,9 +846,8 @@ static int ltpc_ioctl(struct net_device *dev, struct =
ifreq *ifr, int cmd)
>  			set_30 (dev,ltflags); =20
> =20
>  			dev->broadcast[0] =3D 0xFF;
> -			dev->dev_addr[0] =3D aa->s_node;
> -
>  			dev->addr_len=3D1;
> +			dev_addr_set(dev, &aa->s_node);
>    =20
>  			return 0;
> =20
> diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
> index 12d085405bd0..8c3ccc7c83cd 100644
> --- a/drivers/net/arcnet/arc-rimi.c
> +++ b/drivers/net/arcnet/arc-rimi.c
> @@ -207,7 +207,8 @@ static int __init arcrimi_found(struct net_device *de=
v)
>  	}
> =20
>  	/* get and check the station ID from offset 1 in shmem */
> -	dev->dev_addr[0] =3D arcnet_readb(lp->mem_start, COM9026_REG_R_STATION);
> +	arcnet_set_addr(dev, arcnet_readb(lp->mem_start,
> +					  COM9026_REG_R_STATION));
> =20
>  	arc_printk(D_NORMAL, dev, "ARCnet RIM I: station %02Xh found at IRQ %d,=
 ShMem %lXh (%ld*%d bytes)\n",
>  		   dev->dev_addr[0],
> @@ -324,7 +325,7 @@ static int __init arc_rimi_init(void)
>  		return -ENOMEM;
> =20
>  	if (node && node !=3D 0xff)
> -		dev->dev_addr[0] =3D node;
> +		arcnet_set_addr(dev, node);
> =20
>  	dev->mem_start =3D io;
>  	dev->irq =3D irq;
> diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevic=
e.h
> index 5d4a4c7efbbf..19e996a829c9 100644
> --- a/drivers/net/arcnet/arcdevice.h
> +++ b/drivers/net/arcnet/arcdevice.h
> @@ -364,6 +364,11 @@ netdev_tx_t arcnet_send_packet(struct sk_buff *skb,
>  			       struct net_device *dev);
>  void arcnet_timeout(struct net_device *dev, unsigned int txqueue);
> =20
> +static inline void arcnet_set_addr(struct net_device *dev, u8 addr)
> +{
> +	dev_addr_set(dev, &addr);
> +}
> +
>  /* I/O equivalents */
> =20
>  #ifdef CONFIG_SA1100_CT6001
> diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20=
020-isa.c
> index be618e4b9ed5..293a621e654c 100644
> --- a/drivers/net/arcnet/com20020-isa.c
> +++ b/drivers/net/arcnet/com20020-isa.c
> @@ -151,7 +151,7 @@ static int __init com20020_init(void)
>  		return -ENOMEM;
> =20
>  	if (node && node !=3D 0xff)
> -		dev->dev_addr[0] =3D node;
> +		arcnet_set_addr(dev, node);
> =20
>  	dev->netdev_ops =3D &com20020_netdev_ops;
> =20
> diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20=
020-pci.c
> index 3c8f665c1558..6382e1937cca 100644
> --- a/drivers/net/arcnet/com20020-pci.c
> +++ b/drivers/net/arcnet/com20020-pci.c
> @@ -194,7 +194,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
> =20
>  		SET_NETDEV_DEV(dev, &pdev->dev);
>  		dev->base_addr =3D ioaddr;
> -		dev->dev_addr[0] =3D node;
> +		arcnet_set_addr(dev, node);
>  		dev->sysfs_groups[0] =3D &com20020_state_group;
>  		dev->irq =3D pdev->irq;
>  		lp->card_name =3D "PCI COM20020";
> diff --git a/drivers/net/arcnet/com20020.c b/drivers/net/arcnet/com20020.c
> index 78043a9c5981..06e1651b594b 100644
> --- a/drivers/net/arcnet/com20020.c
> +++ b/drivers/net/arcnet/com20020.c
> @@ -157,7 +157,7 @@ static int com20020_set_hwaddr(struct net_device *dev=
, void *addr)
>  	struct arcnet_local *lp =3D netdev_priv(dev);
>  	struct sockaddr *hwaddr =3D addr;
> =20
> -	memcpy(dev->dev_addr, hwaddr->sa_data, 1);
> +	dev_addr_set(dev, hwaddr->sa_data);
>  	com20020_set_subaddress(lp, ioaddr, SUB_NODE);
>  	arcnet_outb(dev->dev_addr[0], ioaddr, COM20020_REG_W_XREG);
> =20
> @@ -220,7 +220,7 @@ int com20020_found(struct net_device *dev, int shared)
> =20
>  	/* FIXME: do this some other way! */
>  	if (!dev->dev_addr[0])
> -		dev->dev_addr[0] =3D arcnet_inb(ioaddr, 8);
> +		arcnet_set_addr(dev, arcnet_inb(ioaddr, 8));
> =20
>  	com20020_set_subaddress(lp, ioaddr, SUB_SETUP1);
>  	arcnet_outb(lp->setup, ioaddr, COM20020_REG_W_XREG);
> diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com200=
20_cs.c
> index b88a109b3b15..24150c933fcb 100644
> --- a/drivers/net/arcnet/com20020_cs.c
> +++ b/drivers/net/arcnet/com20020_cs.c
> @@ -133,7 +133,7 @@ static int com20020_probe(struct pcmcia_device *p_dev)
>  	lp->hw.owner =3D THIS_MODULE;
> =20
>  	/* fill in our module parameters as defaults */
> -	dev->dev_addr[0] =3D node;
> +	arcnet_set_addr(dev, node);
> =20
>  	p_dev->resource[0]->flags |=3D IO_DATA_PATH_WIDTH_8;
>  	p_dev->resource[0]->end =3D 16;
> diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
> index 3856b447d38e..37b47749fc8b 100644
> --- a/drivers/net/arcnet/com90io.c
> +++ b/drivers/net/arcnet/com90io.c
> @@ -252,7 +252,7 @@ static int __init com90io_found(struct net_device *de=
v)
> =20
>  	/* get and check the station ID from offset 1 in shmem */
> =20
> -	dev->dev_addr[0] =3D get_buffer_byte(dev, 1);
> +	arcnet_set_addr(dev, get_buffer_byte(dev, 1));
> =20
>  	err =3D register_netdev(dev);
>  	if (err) {
> diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
> index d8dfb9ea0de8..f49dae194284 100644
> --- a/drivers/net/arcnet/com90xx.c
> +++ b/drivers/net/arcnet/com90xx.c
> @@ -531,7 +531,8 @@ static int __init com90xx_found(int ioaddr, int airq,=
 u_long shmem,
>  	}
> =20
>  	/* get and check the station ID from offset 1 in shmem */
> -	dev->dev_addr[0] =3D arcnet_readb(lp->mem_start, COM9026_REG_R_STATION);
> +	arcnet_set_addr(dev, arcnet_readb(lp->mem_start,
> +					  COM9026_REG_R_STATION));
> =20
>  	dev->base_addr =3D ioaddr;
> =20
> diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
> index e1da9102a540..ad5121e9cf5d 100644
> --- a/drivers/net/usb/cdc-phonet.c
> +++ b/drivers/net/usb/cdc-phonet.c
> @@ -275,6 +275,8 @@ static const struct net_device_ops usbpn_ops =3D {
> =20
>  static void usbpn_setup(struct net_device *dev)
>  {
> +	const u8 addr =3D PN_MEDIA_USB;
> +
>  	dev->features		=3D 0;
>  	dev->netdev_ops		=3D &usbpn_ops;
>  	dev->header_ops		=3D &phonet_header_ops;
> @@ -284,8 +286,8 @@ static void usbpn_setup(struct net_device *dev)
>  	dev->min_mtu		=3D PHONET_MIN_MTU;
>  	dev->max_mtu		=3D PHONET_MAX_MTU;
>  	dev->hard_header_len	=3D 1;
> -	dev->dev_addr[0]	=3D PN_MEDIA_USB;
>  	dev->addr_len		=3D 1;
> +	dev_addr_set(dev, &addr);
>  	dev->tx_queue_len	=3D 3;
> =20
>  	dev->needs_free_netdev	=3D true;
> diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/=
function/f_phonet.c
> index 0b468f5d55bc..068ed8417e5a 100644
> --- a/drivers/usb/gadget/function/f_phonet.c
> +++ b/drivers/usb/gadget/function/f_phonet.c
> @@ -267,6 +267,8 @@ static const struct net_device_ops pn_netdev_ops =3D {
> =20
>  static void pn_net_setup(struct net_device *dev)
>  {
> +	const u8 addr =3D PN_MEDIA_USB;
> +
>  	dev->features		=3D 0;
>  	dev->type		=3D ARPHRD_PHONET;
>  	dev->flags		=3D IFF_POINTOPOINT | IFF_NOARP;
> @@ -274,8 +276,9 @@ static void pn_net_setup(struct net_device *dev)
>  	dev->min_mtu		=3D PHONET_MIN_MTU;
>  	dev->max_mtu		=3D PHONET_MAX_MTU;
>  	dev->hard_header_len	=3D 1;
> -	dev->dev_addr[0]	=3D PN_MEDIA_USB;
>  	dev->addr_len		=3D 1;
> +	dev_addr_set(dev, &addr);
> +
>  	dev->tx_queue_len	=3D 1;
> =20
>  	dev->netdev_ops		=3D &pn_netdev_ops;
> --=20
> 2.31.1
>=20

--wa6hy7npamzzcyou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmFlocAACgkQ2O7X88g7
+pr0aQ//Qu75H4494cOoebN3FSMxjBmf1ry65EtJ3UOA/tWDUQkVsms/v2RdyD0T
UBBcHCZVNb7OTr2IuhId4CLSvrWQK0RLoI5zGe9h7UNMee0PMAeWXUocPrH65XAQ
POikiUa0Q9Ec1cPlEwPqFgyIidCmJJTtqixzo+OqSe8Sh9YYNBpdhizY4E14ARZ7
mFdly9wvglqyUI7nvktrHDW1c7aU0W6Gv53bLH9m0RF1koFABj8Cz9AbE28hWaMb
rYTFAreFXEU6UGqPh3XmN0l7zH8yDx94WCMLpw7fSqmzv/fVRauEGoO/4K6fQIbN
pM12/7HUTaNZ0f+mJL1d5VsRUCfyLWXWSfZ6Cp4v9tK5AXFsB+5scZcu1ORtqtT5
mXVdUayAMFAW6an0CtOtYirAFCekSiaK8U1W3xPI19Mz7jzGs4pqXlLqlVOrutXc
vcX4gDXoUiJQVik9x3+HbU0NedhCHmk9W4bJGS6kvBEhGi8giXCZN7BsKITjK9we
kJu/4elpoQlwLG8QbWRJZ5r30NM1HoA/aZjx8JwCs8WVwB4mFB/rgwOY7PCMVaXB
135sLVN4ZOwR9oUsXqyeighieDUeOwDkzAcmImHvcudc0atE0bIEM8N4mai1R6YA
aQwflASWkJVOWpDY3TjAaIaV5uSFY4shp6DHtvd0VNcam6vIooc=
=BJsD
-----END PGP SIGNATURE-----

--wa6hy7npamzzcyou--
