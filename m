Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632716EA43F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjDUHFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjDUHFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAB01FE7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682060658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sQJO95UUdAAV3qDudgkbVRn+BO9giFeNO5BoGKzmtSE=;
        b=ULjCEbC1HHlThcDjwnDThnX6p1hLj+UvK5cpp59fReCbhct1pLkN/kXSvIwYYgpzQscL+a
        ANp+f9KM1ryBgBNHYHJ7h5S5/At4tZFLYHe3V6icEpjJq6RVKesIMYjl/cjKXJOXqVgPCk
        LFykfKvErKGFoB4lBi21QHFwM7+fLCk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-oY33XmnDM4-01H5_Inms0A-1; Fri, 21 Apr 2023 03:04:17 -0400
X-MC-Unique: oY33XmnDM4-01H5_Inms0A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f170a1fbe7so8321395e9.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682060656; x=1684652656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQJO95UUdAAV3qDudgkbVRn+BO9giFeNO5BoGKzmtSE=;
        b=MbV2MdWvid7tmN9LUyoKjzvsF9v3BEcGi9UsA1jZGZpbnqGPuSqSaybnitbML1BW0v
         OI2AJfmsGkrtLLHf4DpmRnQrk5h/VSTYBbYSKI2dnhp0P7QSdGx9ot+fj19V+m7KKiTP
         3ETLwDBmDSWpHrOn6dlxEGObdTT8Uw00E39RoTNU87aVG9hBklWsYWDJQGKHdoXVmPJN
         lQByK5r/oFx4ODgr5NwBPPxONczYs6PjNrOSYpMPiL/0och5ioTDN2EEndZaz0EXfWwm
         2xxovQH8J2nCunhg8TWGF5LaAuUSN6Hf0xAyo5MAXOJTRWnjLW4TJcoQdSDXdlgQlc/U
         p2lQ==
X-Gm-Message-State: AAQBX9fWYF+AxWp3qjZd+1n3rVRTbu94Yhq9jNcId6ZRlI0A7U5FexVt
        hj5H1QpQNTelbdxAsXav0+eJj1FohxPQnockHJ3+F/CjgkqDfknxr1kL0uMNaytjzk6GhnJ21l2
        +pPUpRt1DFf3ADR11
X-Received: by 2002:adf:dc89:0:b0:2f7:faa0:3f19 with SMTP id r9-20020adfdc89000000b002f7faa03f19mr3151253wrj.28.1682060656347;
        Fri, 21 Apr 2023 00:04:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350aHGati/ymbZ+DxYiF2QaRNV5Ff23Y+Nuvqn19bIrzunMC8mgm4mQ7wFV57Pwfs/5R1bDroBQ==
X-Received: by 2002:adf:dc89:0:b0:2f7:faa0:3f19 with SMTP id r9-20020adfdc89000000b002f7faa03f19mr3151237wrj.28.1682060656055;
        Fri, 21 Apr 2023 00:04:16 -0700 (PDT)
Received: from redhat.com ([2.55.62.70])
        by smtp.gmail.com with ESMTPSA id g2-20020a5d5402000000b002da75c5e143sm3732830wrv.29.2023.04.21.00.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 00:04:15 -0700 (PDT)
Date:   Fri, 21 Apr 2023 03:04:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Andrey Smetanin <asmetanin@yandex-team.ru>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
Message-ID: <20230421030345-mutt-send-email-mst@kernel.org>
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
 <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:01:58PM +0800, Jason Wang wrote:
> On Wed, Nov 23, 2022 at 6:24 PM Andrey Smetanin
> <asmetanin@yandex-team.ru> wrote:
> >
> > Fix possible virtqueue used buffers leak and corresponding stuck
> > in case of temporary -EIO from sendmsg() which is produced by
> > tun driver while backend device is not up.
> >
> > In case of no-retriable error and zcopy do not revert upend_idx
> > to pass packet data (that is update used_idx in corresponding
> > vhost_zerocopy_signal_used()) as if packet data has been
> > transferred successfully.
> 
> Should we mark head.len as VHOST_DMA_DONE_LEN in this case?
> 
> Thanks

Jason do you want to take over this work? It's been stuck
in my inbox for a while.

> >
> > Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
> > ---
> >  drivers/vhost/net.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 20265393aee7..93e9166039b9 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -934,13 +934,16 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> >
> >                 err = sock->ops->sendmsg(sock, &msg, len);
> >                 if (unlikely(err < 0)) {
> > +                       bool retry = err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS;
> > +
> >                         if (zcopy_used) {
> >                                 if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
> >                                         vhost_net_ubuf_put(ubufs);
> > -                               nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> > -                                       % UIO_MAXIOV;
> > +                               if (retry)
> > +                                       nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> > +                                               % UIO_MAXIOV;
> >                         }
> > -                       if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> > +                       if (retry) {
> >                                 vhost_discard_vq_desc(vq, 1);
> >                                 vhost_net_enable_vq(net, vq);
> >                                 break;
> > --
> > 2.25.1
> >

