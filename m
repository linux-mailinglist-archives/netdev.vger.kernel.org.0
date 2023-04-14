Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0916E1D0A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 09:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDNHWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 03:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDNHWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 03:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7F4C2C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 00:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681456905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTjJsirhlxDEZc4I718p3t7VvXQAdTVuI0oKV3etEqI=;
        b=TdexjmFgr916LEWtY7pL8NMoyr4g9u3qm4YyiYXdZelVdzfsy14Z52F+vFtiLVXvZAb7HW
        Lfg9i3slLTWJJY+H+Fjx5B78VMELugk+fnO38ULZgEOMelMiT/7gzfwBdsclcCyKdcQfI0
        EjSiMlJJzd5koRKsO8kZgzWQVjMgCy8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-QHU2SeZJP5KygONcnG0m6A-1; Fri, 14 Apr 2023 03:21:43 -0400
X-MC-Unique: QHU2SeZJP5KygONcnG0m6A-1
Received: by mail-wm1-f69.google.com with SMTP id p4-20020a05600c468400b003f140953152so64764wmo.7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 00:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681456902; x=1684048902;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTjJsirhlxDEZc4I718p3t7VvXQAdTVuI0oKV3etEqI=;
        b=DVC80ilAPQfXHfgHUz9ZXmxCBNMge7QZ4VPgLnhi2YJU0SlIUtuD9b2mGlZfkCaYKj
         Pokv00kdUww1X5NKWwhrlaFh8ybMVV/jWPbo4zb4G+I33D2t33E/rAPfKI/Ply849WSR
         1S7X0/lyUmnpuYYrIQNyNR/rfEUDHAtv9DeA9hjN2tjPJRpM6zhsrTm8A64zTlzE2k+X
         f6Fb9mO+psix4XbfJkMYIbgWIROIWZGgySQiHsFq7jai6D7Ahsn2rdIr7uiSqcHye3zq
         268b/I8UvVs6lXRifu22FUoz/rV1WPpZOhN/rYiqgSJnyifDiUF5ciwCaNvnva5OUatS
         IT5w==
X-Gm-Message-State: AAQBX9eq/X4dni7ac1nZXClK/Wh8VF020D//4T+Vg14w/YUZSogXOb6e
        yCQ64jvT3wlz8T3WKaTBxlEX9jn1sUUL2OVPNn8S5trdyjiPCujhHv4M4/INRcIiriq+DofkB4M
        GnL8Ba+r4qI/1v6hW
X-Received: by 2002:a5d:4a08:0:b0:2f5:ac53:c04f with SMTP id m8-20020a5d4a08000000b002f5ac53c04fmr3170055wrq.28.1681456902559;
        Fri, 14 Apr 2023 00:21:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350bqKuA6wEn8KG9TLRorONonLbSvcTi6eFu6zegtkFvV5OooP0P7OCyktwlDyHT+JvevAlI3IQ==
X-Received: by 2002:a5d:4a08:0:b0:2f5:ac53:c04f with SMTP id m8-20020a5d4a08000000b002f5ac53c04fmr3170036wrq.28.1681456902179;
        Fri, 14 Apr 2023 00:21:42 -0700 (PDT)
Received: from redhat.com ([2a06:c701:742d:fd00:c847:221d:9254:f7ce])
        by smtp.gmail.com with ESMTPSA id h8-20020adfe988000000b002efdf3e5be0sm2905088wrm.44.2023.04.14.00.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 00:21:41 -0700 (PDT)
Date:   Fri, 14 Apr 2023 03:21:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, david.marchand@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
Message-ID: <20230414031947-mutt-send-email-mst@kernel.org>
References: <20230413064027.13267-1-jasowang@redhat.com>
 <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org>
 <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> Forget to cc netdev, adding.
> 
> On Fri, Apr 14, 2023 at 12:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > This patch convert rx mode setting to be done in a workqueue, this is
> > > a must for allow to sleep when waiting for the cvq command to
> > > response since current code is executed under addr spin lock.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> >
> > I don't like this frankly. This means that setting RX mode which would
> > previously be reliable, now becomes unreliable.
> 
> It is "unreliable" by design:
> 
>       void                    (*ndo_set_rx_mode)(struct net_device *dev);
> 
> > - first of all configuration is no longer immediate
> 
> Is immediate a hard requirement? I can see a workqueue is used at least:
> 
> mlx5e, ipoib, efx, ...
> 
> >   and there is no way for driver to find out when
> >   it actually took effect
> 
> But we know rx mode is best effort e.g it doesn't support vhost and we
> survive from this for years.
> 
> > - second, if device fails command, this is also not
> >   propagated to driver, again no way for driver to find out
> >
> > VDUSE needs to be fixed to do tricks to fix this
> > without breaking normal drivers.
> 
> It's not specific to VDUSE. For example, when using virtio-net in the
> UP environment with any software cvq (like mlx5 via vDPA or cma
> transport).
> 
> Thanks

Hmm. Can we differentiate between these use-cases?

> >
> >
> > > ---
> > > Changes since V1:
> > > - use RTNL to synchronize rx mode worker
> > > ---
> > >  drivers/net/virtio_net.c | 55 +++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 52 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index e2560b6f7980..2e56bbf86894 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -265,6 +265,12 @@ struct virtnet_info {
> > >       /* Work struct for config space updates */
> > >       struct work_struct config_work;
> > >
> > > +     /* Work struct for config rx mode */
> > > +     struct work_struct rx_mode_work;
> > > +
> > > +     /* Is rx mode work enabled? */
> > > +     bool rx_mode_work_enabled;
> > > +
> > >       /* Does the affinity hint is set for virtqueues? */
> > >       bool affinity_hint_set;
> > >
> > > @@ -388,6 +394,20 @@ static void disable_delayed_refill(struct virtnet_info *vi)
> > >       spin_unlock_bh(&vi->refill_lock);
> > >  }
> > >
> > > +static void enable_rx_mode_work(struct virtnet_info *vi)
> > > +{
> > > +     rtnl_lock();
> > > +     vi->rx_mode_work_enabled = true;
> > > +     rtnl_unlock();
> > > +}
> > > +
> > > +static void disable_rx_mode_work(struct virtnet_info *vi)
> > > +{
> > > +     rtnl_lock();
> > > +     vi->rx_mode_work_enabled = false;
> > > +     rtnl_unlock();
> > > +}
> > > +
> > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > >                                   struct virtqueue *vq)
> > >  {
> > > @@ -2310,9 +2330,11 @@ static int virtnet_close(struct net_device *dev)
> > >       return 0;
> > >  }
> > >
> > > -static void virtnet_set_rx_mode(struct net_device *dev)
> > > +static void virtnet_rx_mode_work(struct work_struct *work)
> > >  {
> > > -     struct virtnet_info *vi = netdev_priv(dev);
> > > +     struct virtnet_info *vi =
> > > +             container_of(work, struct virtnet_info, rx_mode_work);
> > > +     struct net_device *dev = vi->dev;
> > >       struct scatterlist sg[2];
> > >       struct virtio_net_ctrl_mac *mac_data;
> > >       struct netdev_hw_addr *ha;
> > > @@ -2325,6 +2347,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
> > >               return;
> > >
> > > +     rtnl_lock();
> > > +
> > >       vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
> > >       vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
> > >
> > > @@ -2342,14 +2366,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >               dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
> > >                        vi->ctrl->allmulti ? "en" : "dis");
> > >
> > > +     netif_addr_lock_bh(dev);
> > > +
> > >       uc_count = netdev_uc_count(dev);
> > >       mc_count = netdev_mc_count(dev);
> > >       /* MAC filter - use one buffer for both lists */
> > >       buf = kzalloc(((uc_count + mc_count) * ETH_ALEN) +
> > >                     (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
> > >       mac_data = buf;
> > > -     if (!buf)
> > > +     if (!buf) {
> > > +             netif_addr_unlock_bh(dev);
> > > +             rtnl_unlock();
> > >               return;
> > > +     }
> > >
> > >       sg_init_table(sg, 2);
> > >
> > > @@ -2370,6 +2399,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >       netdev_for_each_mc_addr(ha, dev)
> > >               memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
> > >
> > > +     netif_addr_unlock_bh(dev);
> > > +
> > >       sg_set_buf(&sg[1], mac_data,
> > >                  sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
> > >
> > > @@ -2377,9 +2408,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
> > >                                 VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
> > >               dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
> > >
> > > +     rtnl_unlock();
> > > +
> > >       kfree(buf);
> > >  }
> > >
> > > +static void virtnet_set_rx_mode(struct net_device *dev)
> > > +{
> > > +     struct virtnet_info *vi = netdev_priv(dev);
> > > +
> > > +     if (vi->rx_mode_work_enabled)
> > > +             schedule_work(&vi->rx_mode_work);
> > > +}
> > > +
> > >  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
> > >                                  __be16 proto, u16 vid)
> > >  {
> > > @@ -3150,6 +3191,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> > >
> > >       /* Make sure no work handler is accessing the device */
> > >       flush_work(&vi->config_work);
> > > +     disable_rx_mode_work(vi);
> > > +     flush_work(&vi->rx_mode_work);
> > >
> > >       netif_tx_lock_bh(vi->dev);
> > >       netif_device_detach(vi->dev);
> >
> > So now configuration is not propagated to device.
> > Won't device later wake up in wrong state?
> >
> >
> > > @@ -3172,6 +3215,7 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> > >       virtio_device_ready(vdev);
> > >
> > >       enable_delayed_refill(vi);
> > > +     enable_rx_mode_work(vi);
> > >
> > >       if (netif_running(vi->dev)) {
> > >               err = virtnet_open(vi->dev);
> > > @@ -3969,6 +4013,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       vdev->priv = vi;
> > >
> > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > +     INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
> > >       spin_lock_init(&vi->refill_lock);
> > >
> > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
> > > @@ -4077,6 +4122,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       if (vi->has_rss || vi->has_rss_hash_report)
> > >               virtnet_init_default_rss(vi);
> > >
> > > +     enable_rx_mode_work(vi);
> > > +
> > >       /* serialize netdev register + virtio_device_ready() with ndo_open() */
> > >       rtnl_lock();
> > >
> > > @@ -4174,6 +4221,8 @@ static void virtnet_remove(struct virtio_device *vdev)
> > >
> > >       /* Make sure no work handler is accessing the device. */
> > >       flush_work(&vi->config_work);
> > > +     disable_rx_mode_work(vi);
> > > +     flush_work(&vi->rx_mode_work);
> > >
> > >       unregister_netdev(vi->dev);
> > >
> > > --
> > > 2.25.1
> >

