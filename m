Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFFE65679F
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 07:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiL0G7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 01:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiL0G7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 01:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB418D84
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672124308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEQnE9PVAxMt3NN5busw/86CF7CMlanPyO97TM74NVQ=;
        b=Zk1M4/+Ot37IzYXK6uaZk7K1ZYQ6Wp9/IN4Tw/6FoqSQpSdAWjl1/dZh7IjNzNvL3C6Maq
        gbH9PV5pbVMvqfp3o8X1gW2kX5g63UE+vgEfx1zzm13s1SBCBIukkaBZJGIVVxZLzWKJOJ
        M6fGO5cYsPgb5BaIX/WNZsrpKslODLg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-z7UHhSVrNhWbnmmn5p_9Ag-1; Tue, 27 Dec 2022 01:58:27 -0500
X-MC-Unique: z7UHhSVrNhWbnmmn5p_9Ag-1
Received: by mail-wm1-f69.google.com with SMTP id bd6-20020a05600c1f0600b003d96f7f2396so6032561wmb.3
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEQnE9PVAxMt3NN5busw/86CF7CMlanPyO97TM74NVQ=;
        b=tEt/0ezgh/WWeZ7MBVDijq3XcpoDMBv4nm80bbB9c1T0OEEh0zhD+AhQ3KsYmSu+zE
         6zoU3hInX+poA2ZAPI7rh5ChJj139raBvFHCIobpgg8P5l6t/NZBSBvifIQzZITptCZB
         DRGAZ5/HO4MFevyIZejv3DRIlNlPYAplGu3VmFsZ3lJPWOVOqiYFcp3+GXM6vPA5TEpJ
         QvB19z6Ztr3fdXks3zmGdL00JYBE5tWGliFr+Jxunra8E4t2ofvn4l4+oSVJLQOsDYEQ
         xqITnloIVRIjl/yPBWkmYkreZxUZfCGXnNdYIzePtIjjtFW0Uo6qMYemzeF3JXt8XCZp
         mS8Q==
X-Gm-Message-State: AFqh2kpaULvHXHEY+FZzTpUmqnZcuzgkQS3aXTPDjUaKnAdghwEVBf61
        phcOyFE0znNfYkdRVpuNIadVvBkORy1U1X6F5kQYPnBo7Y/UehWLbHYAxnsJv1G5kTXcof/07WD
        l3x29Eet+lMOn+IQT
X-Received: by 2002:a05:6000:408b:b0:242:8404:6b66 with SMTP id da11-20020a056000408b00b0024284046b66mr16317866wrb.1.1672124306087;
        Mon, 26 Dec 2022 22:58:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsQCt0+AaMD4RxNYOoeOnSYvfwzUkVJfqDViHWgn3ChjJ9wRZbivi34ts/r3cP93RBNHKXVag==
X-Received: by 2002:a05:6000:408b:b0:242:8404:6b66 with SMTP id da11-20020a056000408b00b0024284046b66mr16317856wrb.1.1672124305675;
        Mon, 26 Dec 2022 22:58:25 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id p18-20020a056000019200b00279d23574c4sm6850233wrx.13.2022.12.26.22.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 22:58:25 -0800 (PST)
Date:   Tue, 27 Dec 2022 01:58:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        edumazet@google.com, maxime.coquelin@redhat.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq
 command
Message-ID: <20221227014641-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-5-jasowang@redhat.com>
 <1672107557.0142956-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 12:33:53PM +0800, Jason Wang wrote:
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

Controlling timeout from device is a good idea, e.g. hardware devices
would benefit from a shorter timeout, hypervisor devices from a longer
timeout or no timeout.

> 
> > Some of the DPUs are very
> > lazy for cvq handle.
> 
> Such design needs to be revisited, cvq (control path) should have a
> better priority or QOS than datapath.

Spec says nothing about this, so driver can't assume this either.

> > In particular, we will also directly break the device.
> 
> It's kind of hardening for malicious devices.

ATM no amount of hardening can prevent a malicious hypervisor from
blocking the guest. Recovering when a hardware device is broken would be
nice but I think if we do bother then we should try harder to recover,
such as by driving device reset.


Also, does your patch break surprise removal? There's no callback
in this case ATM.

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

