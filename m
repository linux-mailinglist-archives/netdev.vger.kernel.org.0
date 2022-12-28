Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484416573FD
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 09:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiL1Ikb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 03:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1Ikb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 03:40:31 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2634DF12;
        Wed, 28 Dec 2022 00:40:29 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VYGgwdw_1672216825;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VYGgwdw_1672216825)
          by smtp.aliyun-inc.com;
          Wed, 28 Dec 2022 16:40:26 +0800
Message-ID: <1672216748.7057884-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
Date:   Wed, 28 Dec 2022 16:39:08 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        edumazet@google.com, maxime.coquelin@redhat.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, mst@redhat.com
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-5-jasowang@redhat.com>
 <1672107557.0142956-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
In-Reply-To: <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Dec 2022 12:33:53 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Dec 27, 2022 at 10:25 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Mon, 26 Dec 2022 15:49:08 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > We used to busy waiting on the cvq command this tends to be
> > > problematic since:
> > >
> > > 1) CPU could wait for ever on a buggy/malicous device
> > > 2) There's no wait to terminate the process that triggers the cvq
> > >    command
> > >
> > > So this patch switch to use virtqueue_wait_for_used() to sleep with a
> > > timeout (1s) instead of busy polling for the cvq command forever. This
> >
> > I don't think that a fixed 1S is a good choice.
>
> Well, it could be tweaked to be a little bit longer.
>
> One way, as discussed, is to let the device advertise a timeout then
> the driver can validate if it's valid and use that timeout. But it
> needs extension to the spec.
>
> > Some of the DPUs are very
> > lazy for cvq handle.
>
> Such design needs to be revisited, cvq (control path) should have a
> better priority or QOS than datapath.
>
> > In particular, we will also directly break the device.
>
> It's kind of hardening for malicious devices.

Just based on timeout, it is judged that it is a malicious device. I think it is
too arbitrary.

Thanks.


>
> >
> > I think it is necessary to add a Virtio-Net parameter to allow users to define
> > this timeout by themselves. Although I don't think this is a good way.
>
> Very hard and unfriendly to the end users.
>
> Thanks
>
> >
> > Thanks.
> >
> >
> > > gives the scheduler a breath and can let the process can respond to
> > > asignal. If the device doesn't respond in the timeout, break the
> > > device.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Changes since V1:
> > > - break the device when timeout
> > > - get buffer manually since the virtio core check more_used() instead
> > > ---
> > >  drivers/net/virtio_net.c | 24 ++++++++++++++++--------
> > >  1 file changed, 16 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index efd9dd55828b..6a2ea64cfcb5 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
> > >       vi->rx_mode_work_enabled = false;
> > >       spin_unlock_bh(&vi->rx_mode_lock);
> > >
> > > +     virtqueue_wake_up(vi->cvq);
> > >       flush_work(&vi->rx_mode_work);
> > >  }
> > >
> > > @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> > >       return !oom;
> > >  }
> > >
> > > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > > +{
> > > +     virtqueue_wake_up(cvq);
> > > +}
> > > +
> > >  static void skb_recv_done(struct virtqueue *rvq)
> > >  {
> > >       struct virtnet_info *vi = rvq->vdev->priv;
> > > @@ -1984,6 +1990,8 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
> > >       return err;
> > >  }
> > >
> > > +static int virtnet_close(struct net_device *dev);
> > > +
> > >  /*
> > >   * Send command via the control virtqueue and check status.  Commands
> > >   * supported by the hypervisor, as indicated by feature bits, should
> > > @@ -2026,14 +2034,14 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> > >       if (unlikely(!virtqueue_kick(vi->cvq)))
> > >               return vi->ctrl->status == VIRTIO_NET_OK;
> > >
> > > -     /* Spin for a response, the kick causes an ioport write, trapping
> > > -      * into the hypervisor, so the request should be handled immediately.
> > > -      */
> > > -     while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > > -            !virtqueue_is_broken(vi->cvq))
> > > -             cpu_relax();
> > > +     if (virtqueue_wait_for_used(vi->cvq)) {
> > > +             virtqueue_get_buf(vi->cvq, &tmp);
> > > +             return vi->ctrl->status == VIRTIO_NET_OK;
> > > +     }
> > >
> > > -     return vi->ctrl->status == VIRTIO_NET_OK;
> > > +     netdev_err(vi->dev, "CVQ command timeout, break the virtio device.");
> > > +     virtio_break_device(vi->vdev);
> > > +     return VIRTIO_NET_ERR;
> > >  }
> > >
> > >  static int virtnet_set_mac_address(struct net_device *dev, void *p)
> > > @@ -3526,7 +3534,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >
> > >       /* Parameters for control virtqueue, if any */
> > >       if (vi->has_cvq) {
> > > -             callbacks[total_vqs - 1] = NULL;
> > > +             callbacks[total_vqs - 1] = virtnet_cvq_done;
> > >               names[total_vqs - 1] = "control";
> > >       }
> > >
> > > --
> > > 2.25.1
> > >
> > > _______________________________________________
> > > Virtualization mailing list
> > > Virtualization@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> >
>
