Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FAD54F7A2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382160AbiFQMdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381218AbiFQMdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 08:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F67013E9F
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 05:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655469184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=92UlDs3RgFNfmwdasYrOfS3jw16tdOBEhgL58+p+c74=;
        b=TnrOm3AIu4Ex8hBQ4LzzBkgkTwlc/xlf4iBKBMJGIBR82SMVF2nKY35NejwryaTXnS4iLn
        CuwM2iSYgVmOmQKeuokM4Xoso5kisdT4DeA4BNf7rj0tpUp4nWYlNHesX0ti9iRhjGKYLW
        8Nv+zGbp4FwOpIR9yeAjy/A4I+la5hw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Sdh0fXuXN-O3BLjrGVsMOg-1; Fri, 17 Jun 2022 08:33:01 -0400
X-MC-Unique: Sdh0fXuXN-O3BLjrGVsMOg-1
Received: by mail-wm1-f71.google.com with SMTP id r83-20020a1c4456000000b0039c8f5804c4so2662755wma.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 05:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=92UlDs3RgFNfmwdasYrOfS3jw16tdOBEhgL58+p+c74=;
        b=5XugSE7PkYdWl2Ag+NbORD46HMFiq9jW2m/lMaUcKB7BEuvzCUm6e9+kLXz/1x/MqX
         BQOLiB1tx2/iTIeOnwZMDlxYaislLj2yx2Ynb2O0vNeDJRsenkwxgGLW/nD072mnNoy0
         n+kZvxarORfMKjqrPAoIc+c9zY7JSq8Uwxq0kJknk1nLAEn4MqsPCAVx4sid/Wv0IU1G
         r9KlzQQWLVEtnMSRFRdGFQ7nCr/BZcvEB5FIol+L6nkgaP5feg886+FJQ0fR+sKM5Xrt
         RucHTLHffvf1siMYHZ7xZm8QCgKPTV12nCmrP3qFAz0ZSEqVdoqr+rv8GBeshsdtC/Jb
         YNoA==
X-Gm-Message-State: AJIora9KCg0gH7rY+RfBKHRS0Wh3IsadHDpHEWRh2iO97LoB4espsldh
        x4nvoIe5LhMHybfoZrOcASK5cVIoDFJUykENWj72gQUngDkSF08NcZLu2iy+nCdouwDHtZnL9qw
        GbEjdLT4avOz/tFad
X-Received: by 2002:a5d:4dc9:0:b0:215:c611:db73 with SMTP id f9-20020a5d4dc9000000b00215c611db73mr9566018wru.551.1655469179983;
        Fri, 17 Jun 2022 05:32:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vrMleQODBYjJTSi8fIIhoUhRue0NuBsJFkxO9IRFJgdZFWFEeDm8+sGhF94gyh54rHFnh3Dw==
X-Received: by 2002:a5d:4dc9:0:b0:215:c611:db73 with SMTP id f9-20020a5d4dc9000000b00215c611db73mr9565992wru.551.1655469179714;
        Fri, 17 Jun 2022 05:32:59 -0700 (PDT)
Received: from redhat.com ([2.54.189.19])
        by smtp.gmail.com with ESMTPSA id c5-20020a05600c0a4500b0039c4ba160absm18336881wmq.2.2022.06.17.05.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 05:32:59 -0700 (PDT)
Date:   Fri, 17 Jun 2022 08:32:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio-net: fix race between ndo_open() and
 virtio_device_ready()
Message-ID: <20220617083141-mutt-send-email-mst@kernel.org>
References: <20220617072949.30734-1-jasowang@redhat.com>
 <20220617060632-mutt-send-email-mst@kernel.org>
 <CACGkMEtTVs5W+qqt9Z6BcorJ6wcqcnSVuCBrHrLZbbKzG-7ULQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtTVs5W+qqt9Z6BcorJ6wcqcnSVuCBrHrLZbbKzG-7ULQ@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 07:46:23PM +0800, Jason Wang wrote:
> On Fri, Jun 17, 2022 at 6:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Jun 17, 2022 at 03:29:49PM +0800, Jason Wang wrote:
> > > We used to call virtio_device_ready() after netdev registration. This
> > > cause a race between ndo_open() and virtio_device_ready(): if
> > > ndo_open() is called before virtio_device_ready(), the driver may
> > > start to use the device before DRIVER_OK which violates the spec.
> > >
> > > Fixing this by switching to use register_netdevice() and protect the
> > > virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> > > only be called after virtio_device_ready().
> > >
> > > Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index db05b5e930be..8a5810bcb839 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       if (vi->has_rss || vi->has_rss_hash_report)
> > >               virtnet_init_default_rss(vi);
> > >
> > > -     err = register_netdev(dev);
> > > +     /* serialize netdev register + virtio_device_ready() with ndo_open() */
> > > +     rtnl_lock();
> > > +
> > > +     err = register_netdevice(dev);
> > >       if (err) {
> > >               pr_debug("virtio_net: registering device failed\n");
> > > +             rtnl_unlock();
> > >               goto free_failover;
> > >       }
> > >
> > >       virtio_device_ready(vdev);
> > >
> > > +     rtnl_unlock();
> > > +
> > >       err = virtnet_cpu_notif_add(vi);
> > >       if (err) {
> > >               pr_debug("virtio_net: registering cpu notifier failed\n");
> >
> >
> > Looks good but then don't we have the same issue when removing the
> > device?
> >
> > Actually I looked at  virtnet_remove and I see
> >         unregister_netdev(vi->dev);
> >
> >         net_failover_destroy(vi->failover);
> >
> >         remove_vq_common(vi); <- this will reset the device
> >
> > a window here?
> 
> Probably. For safety, we probably need to reset before unregistering.


careful not to create new races, let's analyse this one to be
sure first.

> >
> >
> > Really, I think what we had originally was a better idea -
> > instead of dropping interrupts they were delayed and
> > when driver is ready to accept them it just enables them.
> 
> The problem is that it works only on some specific setup:
> 
> - doesn't work on shared IRQ
> - doesn't work on some specific driver e.g virtio-blk

can some core irq work fix that?

> > We just need to make sure driver does not wait for
> > interrupts before enabling them.
> >
> > And I suspect we need to make this opt-in on a per driver
> > basis.
> 
> Exactly.
> 
> Thanks
> 
> >
> >
> >
> > > --
> > > 2.25.1
> >

