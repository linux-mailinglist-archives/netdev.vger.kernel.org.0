Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEBC2AF546
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgKKPno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgKKPnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 10:43:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F20C20709;
        Wed, 11 Nov 2020 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605109422;
        bh=D/AmRDEYT05VM7phYvwKqaW/ha4IDWOWyYYYSJjSNP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UDaI1GTR1WPCkGSxB8VvGHdkf+HLBasQN86OhnkUI8Llv/wZp83S+eoi9rcdtE/9d
         sD/G3mamlEG92QZL2rsvrxwcyhE5goLv3yVInPos6xxaz9lD/5/CwaUXqgmonkuK0U
         t2Evx9lmdeJtsCFDRN+IcrwHeACb524PkePlwRqA=
Date:   Wed, 11 Nov 2020 07:43:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Markus =?UTF-8?B?QmzDtmNobA==?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 16:39:58 +0100 Markus Bl=C3=B6chl wrote:
> The rx-vlan-filter feature flag prevents unexpected tagged frames on
> the wire from reaching the kernel in promiscuous mode.
> Disable this offloading feature in the lan7800 controller whenever
> IFF_PROMISC is set and make sure that the hardware features
> are updated when IFF_PROMISC changes.
>=20
> Signed-off-by: Markus Bl=C3=B6chl <markus.bloechl@ipetronik.com>
> ---
>=20
> Notes:
>     When sniffing ethernet using a LAN7800 ethernet controller, vlan-tagg=
ed
>     frames are silently dropped by the controller due to the
>     RFE_CTL_VLAN_FILTER flag being set by default since commit
>     4a27327b156e("net: lan78xx: Add support for VLAN filtering.").
>=20
>     In order to receive those tagged frames it is necessary to manually d=
isable
>     rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter off=
` or
>     corresponding ioctls ). Setting all bits in the vlan filter table to =
1 is
>     an even worse approach, imho.
>=20
>     As a user I would probably expect that setting IFF_PROMISC should be =
enough
>     in all cases to receive all valid traffic.
>     Therefore I think this behaviour is a bug in the driver, since other
>     drivers (notably ixgbe) automatically disable rx-vlan-filter when
>     IFF_PROMISC is set. Please correct me if I am wrong here.

I've been mulling over this, I'm not 100% sure that disabling VLAN
filters on promisc is indeed the right thing to do. The ixgbe doing
this is somewhat convincing. OTOH users would not expect flow filters
to get disabled when promisc is on, so why disable vlan filters?

Either way we should either document this as an expected behavior or
make the core clear the features automatically rather than force
drivers to worry about it.

Does anyone else have an opinion, please?

> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index 65b315bc60ab..ac6c0beeac21 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -2324,13 +2324,15 @@ static int lan78xx_set_mac_addr(struct net_device=
 *netdev, void *p)
>  }
>=20
>  /* Enable or disable Rx checksum offload engine */
> -static int lan78xx_set_features(struct net_device *netdev,
> -                               netdev_features_t features)
> +static void lan78xx_update_features(struct net_device *netdev,
> +                                   netdev_features_t features)
>  {
>         struct lan78xx_net *dev =3D netdev_priv(netdev);
>         struct lan78xx_priv *pdata =3D (struct lan78xx_priv *)(dev->data[=
0]);
>         unsigned long flags;
> -       int ret;
> +
> +       if (netdev->flags & IFF_PROMISC)
> +               features &=3D ~NETIF_F_HW_VLAN_CTAG_FILTER;
>=20
>         spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
>=20
> @@ -2353,12 +2355,30 @@ static int lan78xx_set_features(struct net_device=
 *netdev,
>                 pdata->rfe_ctl &=3D ~RFE_CTL_VLAN_FILTER_;
>=20
>         spin_unlock_irqrestore(&pdata->rfe_ctl_lock, flags);
> +}
> +
> +static int lan78xx_set_features(struct net_device *netdev,
> +                               netdev_features_t features)
> +{
> +       struct lan78xx_net *dev =3D netdev_priv(netdev);
> +       struct lan78xx_priv *pdata =3D (struct lan78xx_priv *)(dev->data[=
0]);
> +       int ret;
> +
> +       lan78xx_update_features(netdev, features);
>=20
>         ret =3D lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
>=20
>         return 0;
>  }
>=20
> +static void lan78xx_set_rx_mode(struct net_device *netdev)
> +{
> +       /* Enable or disable checksum offload engines */
> +       lan78xx_update_features(netdev, netdev->features);
> +
> +       lan78xx_set_multicast(netdev);
> +}
> +
>  static void lan78xx_deferred_vlan_write(struct work_struct *param)
>  {
>         struct lan78xx_priv *pdata =3D
> @@ -2528,10 +2548,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
>         pdata->rfe_ctl |=3D RFE_CTL_BCAST_EN_ | RFE_CTL_DA_PERFECT_;
>         ret =3D lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
>=20
> -       /* Enable or disable checksum offload engines */
> -       lan78xx_set_features(dev->net, dev->net->features);
> -
> -       lan78xx_set_multicast(dev->net);
> +       lan78xx_set_rx_mode(dev->net);
>=20
>         /* reset PHY */
>         ret =3D lan78xx_read_reg(dev, PMT_CTL, &buf);
> @@ -3613,7 +3630,7 @@ static const struct net_device_ops lan78xx_netdev_o=
ps =3D {
>         .ndo_set_mac_address    =3D lan78xx_set_mac_addr,
>         .ndo_validate_addr      =3D eth_validate_addr,
>         .ndo_do_ioctl           =3D phy_do_ioctl_running,
> -       .ndo_set_rx_mode        =3D lan78xx_set_multicast,
> +       .ndo_set_rx_mode        =3D lan78xx_set_rx_mode,
>         .ndo_set_features       =3D lan78xx_set_features,
>         .ndo_vlan_rx_add_vid    =3D lan78xx_vlan_rx_add_vid,
>         .ndo_vlan_rx_kill_vid   =3D lan78xx_vlan_rx_kill_vid,
>=20
> base-commit: 4e0396c59559264442963b349ab71f66e471f84d
> --
> 2.29.2
>=20
>=20
> Impressum/Imprint: https://www.ipetronik.com/impressum

