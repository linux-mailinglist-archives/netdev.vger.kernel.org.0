Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B553E3501
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 12:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhHGK4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 06:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhHGK4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 06:56:10 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B2CC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 03:55:53 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:ef0a:7f0c:624e:2eac:9b4])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 177AtZWN005803
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 7 Aug 2021 12:55:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1628333738; bh=UFmQOjxLHCFlD0dXZrH+NHtuOzsmGXbkLjV2rqqsSj0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=V65hbHXMlzi78rsWU1hjG/cRfmAnN9TjTW5MvGFUDrcMsf/xVgnUbTDBnXYGYq6fn
         AgtLrvTJX1LSMS1TDbXwD6aDaL2neKrodh29XkWGbbHkBogsdgND+SB1UXKKLimGe0
         VsKcVHMKxv8oBoJ7iSgS/xt3rN2qBmN5kKirsGlA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mCJzF-000Emt-Di; Sat, 07 Aug 2021 12:55:29 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     subashab@codeaurora.org
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
Organization: m
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
        <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
        <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
        <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
        <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
        <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
        <87bl6aqrat.fsf@miraculix.mork.no>
        <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
        <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
Date:   Sat, 07 Aug 2021 12:55:29 +0200
In-Reply-To: <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
        (subashab@codeaurora.org's message of "Fri, 06 Aug 2021 16:30:42
        -0600")
Message-ID: <87sfzlplr2.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subashab@codeaurora.org writes:

> Would something like this work-


Looking pretty good to me, but I believe it needs some polishing.

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 6a2e4f8..c49827e 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -75,6 +75,8 @@ struct qmimux_priv {
>         u8 mux_id;
>  };
>
> +#define MAP_DL_URB_SIZE (32768)

No need for () around a constant, is there?

>  static int qmimux_open(struct net_device *dev)
>  {
>         struct qmimux_priv *priv =3D netdev_priv(dev);
> @@ -303,6 +305,33 @@ static void qmimux_unregister_device(struct
> net_device *dev,
>         dev_put(real_dev);
>  }
>
> +static int qmi_wwan_change_mtu(struct net_device *net, int new_mtu)
> +{
> +       struct usbnet *dev =3D netdev_priv(net);
> +       struct qmi_wwan_state *info =3D (void *)&dev->data;
> +       int old_rx_urb_size =3D dev->rx_urb_size;
> +
> +       /* mux and pass through modes use a fixed rx_urb_size and the
> value
> +        * is independent of mtu
> +        */
> +       if (info->flags & (QMI_WWAN_FLAG_MUX |
> QMI_WWAN_FLAG_PASS_THROUGH)) {
> +               if (old_rx_urb_size =3D=3D MAP_DL_URB_SIZE)
> +                       return 0;
> +
> +               if (old_rx_urb_size < MAP_DL_URB_SIZE) {
> +                       usbnet_pause_rx(dev);
> +                       usbnet_unlink_rx_urbs(dev);
> +                       usbnet_resume_rx(dev);
> +                       usbnet_update_max_qlen(dev);
> +               }
> +
> +               return 0;
> +       }
> +
> +       /* rawip mode uses existing logic of setting rx_urb_size based
> on mtu */
> +       return usbnet_change_mtu(net, new_mtu);
> +}

Either I'm blind, or you don't actuelly change the rx_urb_size for the
mux and pass through modes?


I'd also prefer this to reset back to syncing with hard_mtu if/when
muxing or passthrough is disabled.  Calling usbnet_change_mtu() won't do
that. It doesn't touch rx_urb_size if it is different from hard_mtu.

I also think that it might be useful to keep the mtu/hard_mtu control,
wouldn't it?


Something like

   old_rx_urb_size =3D dev->rx_urb_size;
   if (mux|passthrough)
       dev->rx_urb_size =3D MAP_DL_URB_SIZE;
   else
       dev->rx_urb_size =3D dev->hard_mtu;
   if (dev->rx_urb_size > old_rx_urb_size)
       unlink_urbs etc;
   return usbnet_change_mtu(net, new_mtu);

should do that, I think.  Completely untested....



> +
>  static void qmi_wwan_netdev_setup(struct net_device *net)
>  {
>         struct usbnet *dev =3D netdev_priv(net);
> @@ -326,7 +355,7 @@ static void qmi_wwan_netdev_setup(struct
> net_device *net)
>         }
>
>         /* recalculate buffers after changing hard_header_len */
> -       usbnet_change_mtu(net, net->mtu);
> +       qmi_wwan_change_mtu(net, net->mtu);
>  }
>
>  static ssize_t raw_ip_show(struct device *d, struct device_attribute
>  *attr, char *buf)
> @@ -433,6 +462,7 @@ static ssize_t add_mux_store(struct device *d,
> struct device_attribute *attr, c
>         if (!ret) {
>                 info->flags |=3D QMI_WWAN_FLAG_MUX;
>                 ret =3D len;
> +               qmi_wwan_change_mtu(dev->net, dev->net->mtu);
>         }
>  err:
>         rtnl_unlock();
> @@ -514,6 +544,8 @@ static ssize_t pass_through_store(struct device *d,
>         else
>                 info->flags &=3D ~QMI_WWAN_FLAG_PASS_THROUGH;
>
> +       qmi_wwan_change_mtu(dev->net, dev->net->mtu);
> +
>         return len;
>  }


And add it to the (!qmimux_has_slaves(dev)) cas in del_mux_store() too.


Bj=C3=B8rn
