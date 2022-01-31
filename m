Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E6D4A3ECD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 09:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbiAaIod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 03:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiAaIod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 03:44:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA9BC061714;
        Mon, 31 Jan 2022 00:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8319CB829D4;
        Mon, 31 Jan 2022 08:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D526DC340E8;
        Mon, 31 Jan 2022 08:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643618670;
        bh=saJIIIE6VKH0mPHcJf9BDEM/BezCCYAr1aM541i3RVY=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=cGHPRpQLR7DxXwRgYOsUDBy8VcoMeIZ3r0XZCRYuINs8wnBtiuwPw8qrIwCryKQYW
         wN1q/OMpizzEpAqwOd3ztPVlTl7pgGjF6K+fFgKvWoD3T7VYz+yofZ2tOKnbnjvEZa
         NuuHx+v33K7DW6s1pf9oXzhO1oyUIQyb0whvhNWyOCr4REuNYX7/VnD3AOT1eejhbl
         8yqIXjyX6XaoWbI/Gdn3eYvfkRl7yTmLQhTs6FoDUHkHodSWjSDq8Y5W/Ipx6VEfnI
         RU4bKoFtucW1M8zwphRO3INT2iAdL8RayOwD54x+12SkoWLYbj8sPgSq2RNUXc8ynk
         HSkVUE7WQlc8w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1643542141-28956-1-git-send-email-raeds@nvidia.com>
References: <1643542141-28956-1-git-send-email-raeds@nvidia.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     Raed Salem <raeds@nvidia.com>, kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net] net: macsec: Fix offload support for NETDEV_UNREGISTER event
Message-ID: <164361866706.4133.9367433003115932230@kwain>
Date:   Mon, 31 Jan 2022 09:44:27 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Raed Salem (2022-01-30 12:29:01)
> From: Lior Nahmanson <liorna@nvidia.com>
>=20
> Current macsec netdev notify handler handles NETDEV_UNREGISTER event by
> releasing relevant SW resources only, this causes resources leak in case
> of macsec HW offload, as the underlay driver was not notified to clean
> it's macsec offload resources.
>=20
> Fix by calling the underlay driver to clean it's relevant resources
> by moving offload handling from macsec_dellink() to macsec_common_dellink=
()
> when handling NETDEV_UNREGISTER event.
>=20
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Raed Salem <raeds@nvidia.com>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
Antoine

> ---
>  drivers/net/macsec.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 16aa3a4..33ff33c 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -3870,6 +3870,18 @@ static void macsec_common_dellink(struct net_devic=
e *dev, struct list_head *head
>         struct macsec_dev *macsec =3D macsec_priv(dev);
>         struct net_device *real_dev =3D macsec->real_dev;
> =20
> +       /* If h/w offloading is available, propagate to the device */
> +       if (macsec_is_offloaded(macsec)) {
> +               const struct macsec_ops *ops;
> +               struct macsec_context ctx;
> +
> +               ops =3D macsec_get_ops(netdev_priv(dev), &ctx);
> +               if (ops) {
> +                       ctx.secy =3D &macsec->secy;
> +                       macsec_offload(ops->mdo_del_secy, &ctx);
> +               }
> +       }
> +
>         unregister_netdevice_queue(dev, head);
>         list_del_rcu(&macsec->secys);
>         macsec_del_dev(macsec);
> @@ -3884,18 +3896,6 @@ static void macsec_dellink(struct net_device *dev,=
 struct list_head *head)
>         struct net_device *real_dev =3D macsec->real_dev;
>         struct macsec_rxh_data *rxd =3D macsec_data_rtnl(real_dev);
> =20
> -       /* If h/w offloading is available, propagate to the device */
> -       if (macsec_is_offloaded(macsec)) {
> -               const struct macsec_ops *ops;
> -               struct macsec_context ctx;
> -
> -               ops =3D macsec_get_ops(netdev_priv(dev), &ctx);
> -               if (ops) {
> -                       ctx.secy =3D &macsec->secy;
> -                       macsec_offload(ops->mdo_del_secy, &ctx);
> -               }
> -       }
> -
>         macsec_common_dellink(dev, head);
> =20
>         if (list_empty(&rxd->secys)) {
> --=20
> 1.8.3.1
>=20
