Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9333F6804B0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 05:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbjA3EAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 23:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbjA3EAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 23:00:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802BC24135
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 19:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675051136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QsSvm36Xk+HrOf60OemtCyImDVL0MFVHI7P7OR8LM6g=;
        b=M/V5eldwKQ9t/8cdjIRSTMKGsuAOJoMV7X9bnXE3xoGdywR3aSqcSfsCGtBak4ubD1KLf4
        L0/mUGxBac5FSdO8oILBp8NdGfO7098PqFJohaw5M3GZeIpe97geUvVX3D4k2qS4KD8p2f
        9g9ri4bu3HZVb7LzB3zdKPazsB0fhic=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-Cq-o4IFFMLuA1uNPtJh5UQ-1; Sun, 29 Jan 2023 22:58:54 -0500
X-MC-Unique: Cq-o4IFFMLuA1uNPtJh5UQ-1
Received: by mail-ot1-f71.google.com with SMTP id w15-20020a056830144f00b00687ec8c75cdso5128130otp.2
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 19:58:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QsSvm36Xk+HrOf60OemtCyImDVL0MFVHI7P7OR8LM6g=;
        b=CLKAC10GYg5+IWf1GMgLaeyvOjPcP1PBU5CwJHuIvcO0Vm1FHx/vBn7hmYJcysnwE+
         kjzWrHd2CpkrKWS/bzCrR4WauFKIKmG0gLGBDc4SYmSMBjR6sBG5FqTw9tlU2f2Mp0C/
         52zEfBGc1Ztgzh4MCdNsHlnH1jQdrsCg2Sp9jlhM2M/Vbe4tEfnB4pcqeTsAe9beXXuU
         b8VRZDqGMqQEtGhoAXtk1QI4tLX9JD24c6lViJcGTLusqxPF+wcB/QjdVNpXn+vBFfnd
         /14xcidvIDpCZM/2AhT5qUffEHgk+kVwoK/Yakxwn4wlybyLydK0ZwDJSEoKCKMiPLVN
         gW7A==
X-Gm-Message-State: AFqh2krAtUjRMxIzBzcMqn8eunbDCzJU3ew5Bccr//bWmplElMtHhsRr
        NG2STUiwF3wR5F7gYM7hSWlPrX5c2mEptNTVQn6VevX2jBX2pBWTFbfVMgdr45LDMkaDjKxe/wS
        rQitSVh0MP1IRSbMLhoytPZ496wAvnlHk
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id y14-20020a056871010e00b0015b96b59916mr3936904oab.280.1675051133875;
        Sun, 29 Jan 2023 19:58:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuM5wHn4sTMJyFxc8JJT0li6BZ912wXTAByPVQnh6DAkYFaVUTfYozLdOXqMoX/5eBKpP3njBrqsOtckLHf0bI=
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id
 y14-20020a056871010e00b0015b96b59916mr3936902oab.280.1675051133632; Sun, 29
 Jan 2023 19:58:53 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-1-jasowang@redhat.com> <20221226074908.8154-4-jasowang@redhat.com>
 <20230129073713.5236-1-hdanton@sina.com>
In-Reply-To: <20230129073713.5236-1-hdanton@sina.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 30 Jan 2023 11:58:42 +0800
Message-ID: <CACGkMEtUf=23oxwe=QjhD9AhSRHPNuHfNKBJHPrAPLQk3oLFWA@mail.gmail.com>
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
To:     Hillf Danton <hdanton@sina.com>
Cc:     mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 3:37 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mon, 26 Dec 2022 15:49:07 +0800 Jason Wang <jasowang@redhat.com>
> > @@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
> >  {
> >       struct vring_virtqueue *vq = to_vvq(_vq);
> >
> > +     wake_up_interruptible(&vq->wq);
> > +
> >       if (vq->we_own_ring) {
> >               if (vq->packed_ring) {
> >                       vring_free_queue(vq->vq.vdev,
> > @@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
> >  }
> >  EXPORT_SYMBOL_GPL(virtqueue_get_vring);
> >
> > +int virtqueue_wait_for_used(struct virtqueue *_vq)
> > +{
> > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > +
> > +     /* TODO: Tweak the timeout. */
> > +     return wait_event_interruptible_timeout(vq->wq,
> > +            virtqueue_is_broken(_vq) || more_used(vq), HZ);
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
>
>         waker           waiter
>         ---             ---
>         vring_del_virtqueue
>           vring_free(_vq);
>             wakeup
>           kfree(vq);
>                         get on CPU a tick later
>                         uaf ?
>

Exactly, this wakeup of vring_free is not needed. It's up to the
driver to do the proper wake up to avoid race when subsystem un
registration.

Thanks

