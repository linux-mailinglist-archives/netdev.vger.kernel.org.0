Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B332255159A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbiFTKSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240559AbiFTKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB6113F3E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655720321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nm+eORp3zH2jrCWgqulUmPpdYYIUAnWdQdIYkQxKCxc=;
        b=aHwZBOvwXnxeHSQH9SijEC6UouFpwgkrpV7GMZ+1He7DvJLadAr6DuElZ79QKHU6qGChZO
        OKv68teF6UUHq9gKD6b5yvZLImuzbiZab7tMWtNeQ+0gf6QHJTqNzI0VlYi93X6xLjgy3C
        Mq+aB75zZ8Yi0PnJhQx/tfuyDpYIMGA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-95p3GnWTNwaoiGlRFtZuVA-1; Mon, 20 Jun 2022 06:18:40 -0400
X-MC-Unique: 95p3GnWTNwaoiGlRFtZuVA-1
Received: by mail-wm1-f72.google.com with SMTP id p22-20020a05600c359600b0039c7b23a1c7so6717248wmq.2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nm+eORp3zH2jrCWgqulUmPpdYYIUAnWdQdIYkQxKCxc=;
        b=hMNE5wS4yulzjERKx8a3pPG4PblUleZek+dJbci9cP+ZTxZodLLUkftUO0aBxgpf2i
         RrUOuk5P3uYIzG9K7xbLLgHGFXIlltOFGYXoQEAWDS9oStQgWK+wJ5/YtXdoogdlycXy
         0p6VigEcJEoG3FgcuG66JoPc5PsXVptlCSxcvEdCJDlRnoWM7S2XJ/Yf12g84CK1B5qe
         A4ogoLV15u1t/QobWpPIRow6cmmLK4zXov5/vnynuFSqDhJzMrr1rMnb306xp8wZI73D
         XMJCgHiiuYhJy+hXqYPG4nz2EtlDwYZoOwqorHZYvrjyaTUfmRWAiYB2u+fGxy81nnjt
         uvag==
X-Gm-Message-State: AOAM531B6oJQojcYoWB5DPIXEL8DNPUO+JzlaJqqkrNiNdE+BZ5O+UMr
        vcGdGk5IS0ZRtiEwqVJ29Z1qWD9XVQTAKXiwfdOgMaet9eCEjSNGVGlng52wZc9upkGSnPKsekc
        /xZG2t1o8d4RBUnUm
X-Received: by 2002:a7b:c31a:0:b0:39c:4783:385e with SMTP id k26-20020a7bc31a000000b0039c4783385emr35408650wmj.185.1655720319434;
        Mon, 20 Jun 2022 03:18:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcakcs2Da84r0qRgyJ2AJNFnTRJfDw0r95PsCWFIAzPqNF7lYCclsTp5XJoBLwTxe6twkMaA==
X-Received: by 2002:a7b:c31a:0:b0:39c:4783:385e with SMTP id k26-20020a7bc31a000000b0039c4783385emr35408630wmj.185.1655720319132;
        Mon, 20 Jun 2022 03:18:39 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id k190-20020a1ca1c7000000b0039c587342d8sm18156471wme.3.2022.06.20.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 03:18:38 -0700 (PDT)
Date:   Mon, 20 Jun 2022 06:18:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        erwan.yvin@stericsson.com
Subject: Re: [PATCH 3/3] caif_virtio: fix the race between reset and netdev
 unregister
Message-ID: <20220620061607-mutt-send-email-mst@kernel.org>
References: <20220620051115.3142-1-jasowang@redhat.com>
 <20220620051115.3142-4-jasowang@redhat.com>
 <20220620050446-mutt-send-email-mst@kernel.org>
 <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsEq3mu6unXx1VZuEFgDCotOc9v7fcwJG-kXEqs6hXYYg@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:18:29PM +0800, Jason Wang wrote:
> On Mon, Jun 20, 2022 at 5:09 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jun 20, 2022 at 01:11:15PM +0800, Jason Wang wrote:
> > > We use to do the following steps during .remove():
> >
> > We currently do
> >
> >
> > > static void cfv_remove(struct virtio_device *vdev)
> > > {
> > >       struct cfv_info *cfv = vdev->priv;
> > >
> > >       rtnl_lock();
> > >       dev_close(cfv->ndev);
> > >       rtnl_unlock();
> > >
> > >       tasklet_kill(&cfv->tx_release_tasklet);
> > >       debugfs_remove_recursive(cfv->debugfs);
> > >
> > >       vringh_kiov_cleanup(&cfv->ctx.riov);
> > >       virtio_reset_device(vdev);
> > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > >       cfv->vr_rx = NULL;
> > >       vdev->config->del_vqs(cfv->vdev);
> > >       unregister_netdev(cfv->ndev);
> > > }
> > > This is racy since device could be re-opened after dev_close() but
> > > before unregister_netdevice():
> > >
> > > 1) RX vringh is cleaned before resetting the device, rx callbacks that
> > >    is called after the vringh_kiov_cleanup() will result a UAF
> > > 2) Network stack can still try to use TX virtqueue even if it has been
> > >    deleted after dev_vqs()
> > >
> > > Fixing this by unregistering the network device first to make sure not
> > > device access from both TX and RX side.
> > >
> > > Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/caif/caif_virtio.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> > > index 66375bea2fcd..a29f9b2df5b1 100644
> > > --- a/drivers/net/caif/caif_virtio.c
> > > +++ b/drivers/net/caif/caif_virtio.c
> > > @@ -752,9 +752,8 @@ static void cfv_remove(struct virtio_device *vdev)
> > >  {
> > >       struct cfv_info *cfv = vdev->priv;
> > >
> > > -     rtnl_lock();
> > > -     dev_close(cfv->ndev);
> > > -     rtnl_unlock();
> > > +     /* Make sure NAPI/TX won't try to access the device */
> > > +     unregister_netdev(cfv->ndev);
> > >
> > >       tasklet_kill(&cfv->tx_release_tasklet);
> > >       debugfs_remove_recursive(cfv->debugfs);
> > > @@ -764,7 +763,6 @@ static void cfv_remove(struct virtio_device *vdev)
> > >       vdev->vringh_config->del_vrhs(cfv->vdev);
> > >       cfv->vr_rx = NULL;
> > >       vdev->config->del_vqs(cfv->vdev);
> > > -     unregister_netdev(cfv->ndev);
> > >  }
> >
> >
> > This gives me pause, callbacks can now trigger after device
> > has been unregistered. Are we sure this is safe?
> 
> It looks safe, for RX NAPI is disabled. For TX, tasklet is disabled
> after tasklet_kill(). I can add a comment to explain this.

that waits for outstanding tasklets but does it really prevent
future ones?

> > Won't it be safer to just keep the rtnl_lock around
> > the whole process?
> 
> It looks to me we rtnl_lock can't help in synchronizing with the
> callbacks, anything I miss?
> 
> Thanks

good point.


> >
> > >  static struct virtio_device_id id_table[] = {
> > > --
> > > 2.25.1
> >

