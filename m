Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD957769A
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiGQOJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiGQOJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:09:54 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3AB13D2C
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:09:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so6065808wmb.3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ILptddcH3YHjrQFyPRJLcsFq20oUw0jeyBSU/fMdxaM=;
        b=oq2qDUZsAPgdENTZPVMkBq0wBtbaK2Xzk5BIsgl/v1iJm+EUvp++Ctw9Fgcpzwcj1f
         pkttil61yWCYdLa9BuepY548353Efm8wtWSm4Ui5/l/HJ7M43wPP68eOERxstGd9c06q
         M9Ucrab0toPPx6Jx+R0T6PsW75DBLF5Y5Vu4LTTbJJRB8+74NqNWhyycVN3DE5RqdiGE
         vKMim3da5EZ6DIMZ0i9pUpfJcSAnRRbbRymPusoyD3CM7AzfkMMdy7QyTwQ725FgfvCT
         o5IIfkEzxrXKdKyxlgLe0pIxg73lti+ANl89pNdD0FKUPpe98rfpXQIczWphLzorXMj1
         gQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ILptddcH3YHjrQFyPRJLcsFq20oUw0jeyBSU/fMdxaM=;
        b=bzpQvTcHPNynE3YligvJtsWqyCax2rrJGNIa8DpBtoH8/SZPeHkN48Ky6illQekmMO
         l77skSU09pIfMGRR2VKM3pue3yk4h31aZxfunuo8kFnXsmNBZHy/IUc0/p9yrNNMtNFj
         BLTv8/udK7YAeYV+o6MtvMBTNuI6JyDcabmAsVET7YPQzPo1ldVeh4Ms0sH15twlAIVb
         N7e1evB2NhlVp/i+LcwJv0GC0QSTMT7BUDcm0bbj66h7oC5eCPs3xx3vtuVNKHoseWQ2
         ADEuQDQdKYs/g5uaCjvh1Mr/nvUobehxxFky71/IfzltTfzb7c1HkbtsGoPUvXAv0wjW
         46qQ==
X-Gm-Message-State: AJIora+tkUZxUl3nC//j236fCzzNBGlMZl5AF0cRBsK0GCjefLprO6Au
        6TBoE94q0p35OGHbd/ftibwwZu8cOCdBvjAADyI=
X-Google-Smtp-Source: AGRyM1v/0PDpPgzWl4vUex/PX2/bnvqvW1aeGNqTzUw1ZaWJl2ZKSwauyerhX/S7w5RUbnQc9I8qHeeI0yhteZheWQ8=
X-Received: by 2002:a7b:cd84:0:b0:3a2:ddbe:220a with SMTP id
 y4-20020a7bcd84000000b003a2ddbe220amr22507506wmj.128.1658066991281; Sun, 17
 Jul 2022 07:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220714142027.3684622-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20220714142027.3684622-1-alvaro.karsz@solid-run.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 17 Jul 2022 07:09:38 -0700
Message-ID: <CAA93jw6Z2vfh3cAVbmnHTsvbfNoqhdjdfAjrbKDyCeV9wHHv7w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v3] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 7:29 AM Alvaro Karsz <alvaro.karsz@solid-run.com> w=
rote:
>
> New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
>
> Control a Virtio network device notifications coalescing parameters
> using the control virtqueue.

What are a typical range of settings for these?


> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_NOTF_COAL control commands.
>
> - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
>   Ask the network device to change the following parameters:
>   - tx_usecs: Maximum number of usecs to delay a TX notification.
>   - tx_max_packets: Maximum number of packets to send before a
>     TX notification.
>
> - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
>   Ask the network device to change the following parameters:
>   - rx_usecs: Maximum number of usecs to delay a RX notification.
>   - rx_max_packets: Maximum number of packets to receive before a
>     RX notification.

Bytes =3D time.  Packets nowadays have a dynamic range of 64-64k bytes,
and with big TCP even more. would there be any way to use
bytes rather than packets?

https://lwn.net/Articles/469652/
>
> VirtIO spec. patch:
> https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
> v2:
>         - Fix type assignments warnings found with sparse.
>         - Fix a few typos.
>
> v3:
>   - Change the coalescing parameters in a dedicated function.
>   - Return -EBUSY from the set coalescing function when the device's
>     link is up, even if the notifications coalescing feature is negotiate=
d.
>
> ---
>  drivers/net/virtio_net.c        | 127 +++++++++++++++++++++++++++-----
>  include/uapi/linux/virtio_net.h |  34 ++++++++-
>  2 files changed, 140 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd416..00905f2e2f2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -261,6 +261,12 @@ struct virtnet_info {
>         u8 duplex;
>         u32 speed;
>
> +       /* Interrupt coalescing settings */
> +       u32 tx_usecs;
> +       u32 rx_usecs;
> +       u32 tx_max_packets;
> +       u32 rx_max_packets;
> +
>         unsigned long guest_offloads;
>         unsigned long guest_offloads_capable;
>
> @@ -2587,44 +2593,115 @@ static int virtnet_get_link_ksettings(struct net=
_device *dev,
>         return 0;
>  }
>
> -static int virtnet_set_coalesce(struct net_device *dev,
> -                               struct ethtool_coalesce *ec,
> -                               struct kernel_ethtool_coalesce *kernel_co=
al,
> -                               struct netlink_ext_ack *extack)
> +static int virtnet_update_napi_weight(struct net_device *dev,
> +                                     int napi_weight)
>  {
>         struct virtnet_info *vi =3D netdev_priv(dev);
> -       int i, napi_weight;
> -
> -       if (ec->tx_max_coalesced_frames > 1 ||
> -           ec->rx_max_coalesced_frames !=3D 1)
> -               return -EINVAL;
> +       int i;
>
> -       napi_weight =3D ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : =
0;
>         if (napi_weight ^ vi->sq[0].napi.weight) {
>                 if (dev->flags & IFF_UP)
>                         return -EBUSY;
>                 for (i =3D 0; i < vi->max_queue_pairs; i++)
>                         vi->sq[i].napi.weight =3D napi_weight;
>         }
> -
>         return 0;
>  }
>
> +static int virtnet_set_notf_coal(struct net_device *dev,
> +                                struct ethtool_coalesce *ec)
> +{
> +       struct virtnet_info *vi =3D netdev_priv(dev);
> +       struct scatterlist sgs_tx, sgs_rx;
> +       struct virtio_net_ctrl_coal_tx coal_tx;
> +       struct virtio_net_ctrl_coal_rx coal_rx;
> +       int ret, napi_weight;
> +
> +       coal_tx.tx_usecs =3D cpu_to_le32(ec->tx_coalesce_usecs);
> +       coal_tx.tx_max_packets =3D cpu_to_le32(ec->tx_max_coalesced_frame=
s);
> +       sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +
> +       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +                                 VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> +                                 &sgs_tx))
> +               return -EINVAL;
> +
> +       /* Save parameters */
> +       vi->tx_usecs =3D ec->tx_coalesce_usecs;
> +       vi->tx_max_packets =3D ec->tx_max_coalesced_frames;
> +
> +       coal_rx.rx_usecs =3D cpu_to_le32(ec->rx_coalesce_usecs);
> +       coal_rx.rx_max_packets =3D cpu_to_le32(ec->rx_max_coalesced_frame=
s);
> +       sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +
> +       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +                                 VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> +                                 &sgs_rx))
> +               return -EINVAL;
> +
> +       /* Save parameters */
> +       vi->rx_usecs =3D ec->rx_coalesce_usecs;
> +       vi->rx_max_packets =3D ec->rx_max_coalesced_frames;
> +
> +       napi_weight =3D ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : =
0;
> +       ret =3D virtnet_update_napi_weight(dev, napi_weight);
> +       return ret;
> +}
> +
> +static int virtnet_set_notf_coal_napi(struct net_device *dev,
> +                                     struct ethtool_coalesce *ec)
> +{
> +       int ret, napi_weight;
> +
> +       /* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
> +        * feature is negotiated.
> +        */
> +       if (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs)
> +               return -EOPNOTSUPP;
> +
> +       if (ec->tx_max_coalesced_frames > 1 ||
> +           ec->rx_max_coalesced_frames !=3D 1)
> +               return -EINVAL;
> +
> +       napi_weight =3D ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : =
0;
> +       ret =3D virtnet_update_napi_weight(dev, napi_weight);
> +       return ret;
> +}
> +
> +static int virtnet_set_coalesce(struct net_device *dev,
> +                               struct ethtool_coalesce *ec,
> +                               struct kernel_ethtool_coalesce *kernel_co=
al,
> +                               struct netlink_ext_ack *extack)
> +{
> +       struct virtnet_info *vi =3D netdev_priv(dev);
> +       int ret;
> +
> +       if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
> +               ret =3D virtnet_set_notf_coal(dev, ec);
> +       else
> +               ret =3D virtnet_set_notf_coal_napi(dev, ec);
> +
> +       return ret;
> +}
> +
>  static int virtnet_get_coalesce(struct net_device *dev,
>                                 struct ethtool_coalesce *ec,
>                                 struct kernel_ethtool_coalesce *kernel_co=
al,
>                                 struct netlink_ext_ack *extack)
>  {
> -       struct ethtool_coalesce ec_default =3D {
> -               .cmd =3D ETHTOOL_GCOALESCE,
> -               .rx_max_coalesced_frames =3D 1,
> -       };
>         struct virtnet_info *vi =3D netdev_priv(dev);
>
> -       memcpy(ec, &ec_default, sizeof(ec_default));
> +       if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> +               ec->rx_coalesce_usecs =3D vi->rx_usecs;
> +               ec->tx_coalesce_usecs =3D vi->tx_usecs;
> +               ec->tx_max_coalesced_frames =3D vi->tx_max_packets;
> +               ec->rx_max_coalesced_frames =3D vi->rx_max_packets;
> +       } else {
> +               ec->rx_max_coalesced_frames =3D 1;
>
> -       if (vi->sq[0].napi.weight)
> -               ec->tx_max_coalesced_frames =3D 1;
> +               if (vi->sq[0].napi.weight)
> +                       ec->tx_max_coalesced_frames =3D 1;
> +       }
>
>         return 0;
>  }
> @@ -2743,7 +2820,8 @@ static int virtnet_set_rxnfc(struct net_device *dev=
, struct ethtool_rxnfc *info)
>  }
>
>  static const struct ethtool_ops virtnet_ethtool_ops =3D {
> -       .supported_coalesce_params =3D ETHTOOL_COALESCE_MAX_FRAMES,
> +       .supported_coalesce_params =3D ETHTOOL_COALESCE_MAX_FRAMES |
> +               ETHTOOL_COALESCE_USECS,
>         .get_drvinfo =3D virtnet_get_drvinfo,
>         .get_link =3D ethtool_op_get_link,
>         .get_ringparam =3D virtnet_get_ringparam,
> @@ -3411,6 +3489,8 @@ static bool virtnet_validate_features(struct virtio=
_device *vdev)
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>                              "VIRTIO_NET_F_CTRL_VQ") ||
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +                            "VIRTIO_NET_F_CTRL_VQ") ||
> +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
>                              "VIRTIO_NET_F_CTRL_VQ"))) {
>                 return false;
>         }
> @@ -3546,6 +3626,13 @@ static int virtnet_probe(struct virtio_device *vde=
v)
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>                 vi->mergeable_rx_bufs =3D true;
>
> +       if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> +               vi->rx_usecs =3D 0;
> +               vi->tx_usecs =3D 0;
> +               vi->tx_max_packets =3D 0;
> +               vi->rx_max_packets =3D 0;
> +       }
> +
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
>                 vi->has_rss_hash_report =3D true;
>
> @@ -3780,7 +3867,7 @@ static struct virtio_device_id id_table[] =3D {
>         VIRTIO_NET_F_CTRL_MAC_ADDR, \
>         VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>         VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> +       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COA=
L
>
>  static unsigned int features[] =3D {
>         VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_=
net.h
> index 3f55a4215f1..29ced55514d 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>  #define VIRTIO_NET_F_MQ        22      /* Device supports Receive Flow
>                                          * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23  /* Set MAC address */
> -
> +#define VIRTIO_NET_F_NOTF_COAL 53      /* Guest can handle notifications=
 coalescing */
>  #define VIRTIO_NET_F_HASH_REPORT  57   /* Supports hash report */
>  #define VIRTIO_NET_F_RSS         60    /* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT     61    /* extended coalescing info */
> @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
>
> +/*
> + * Control notifications coalescing.
> + *
> + * Request the device to change the notifications coalescing parameters.
> + *
> + * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
> + */
> +#define VIRTIO_NET_CTRL_NOTF_COAL              6
> +/*
> + * Set the tx-usecs/tx-max-packets patameters.
> + * tx-usecs - Maximum number of usecs to delay a TX notification.
> + * tx-max-packets - Maximum number of packets to send before a TX notifi=
cation.
> + */
> +struct virtio_net_ctrl_coal_tx {
> +       __le32 tx_max_packets;
> +       __le32 tx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET               0
> +
> +/*
> + * Set the rx-usecs/rx-max-packets patameters.
> + * rx-usecs - Maximum number of usecs to delay a RX notification.
> + * rx-max-frames - Maximum number of packets to receive before a RX noti=
fication.
> + */
> +struct virtio_net_ctrl_coal_rx {
> +       __le32 rx_max_packets;
> +       __le32 rx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET               1
> +
>  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> --
> 2.32.0



--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
