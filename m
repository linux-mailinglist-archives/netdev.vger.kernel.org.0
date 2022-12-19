Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED73E650822
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 08:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiLSHlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 02:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiLSHkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 02:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980DEA44B
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 23:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671435607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w11vatQNVAnUlnMv1dmIAsVTD8BgrqYdlE5ppWAhfcU=;
        b=YJSaekx83GcDGgjvMKYGJ0c6CjEx+8L5VuK7g4uxbuCUWF6LwhjODB1OQcwxjNZom/4n81
        w9xAUK9el/7EyEJsFIKjfVkDammHQLvNBhMZul3brOvXZMWCnf2MFkK84qmZslMsipTjjH
        N1PQlBtmgt5xmZEB0jafMcxeoq93rUc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-673-u3w0BI8wPICHya0N7GtDVw-1; Mon, 19 Dec 2022 02:39:52 -0500
X-MC-Unique: u3w0BI8wPICHya0N7GtDVw-1
Received: by mail-qk1-f199.google.com with SMTP id bl3-20020a05620a1a8300b0070240ff36a0so2862521qkb.19
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 23:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w11vatQNVAnUlnMv1dmIAsVTD8BgrqYdlE5ppWAhfcU=;
        b=54FyNjXN5MPlln2TC2+ptRZPmP2JW3L+F/nxBltXrtJRQbWjBnukCtMaFmM1PsCKql
         h96SBsW9n5MHY5H0d7kupbzkAZ/g8m9SGhC1CEbED8zr17NOyukGvLDXY9fwARyvo+Mw
         FmC2exwadiPY5U1AdAJTx2KjKdv3CEFEFW9/2M0CqsbH5S2bzxFoKv582zbXAJjID4zG
         BZZ57bw6eG0fH77dm1u0KQ311og8rGdJFLQwwinyCZaw8ODcbTKKm8HSOnhAOiV4IJXL
         TkMYTgBTm7XPbYQJ5+2VYIhdE1maEmJX940vgPjb/6lzxLtCoylIaZjiy+dFQj0/ucOC
         rwJA==
X-Gm-Message-State: ANoB5pkOmANQ7Xzg6Px4Ppla5x2sL8dEojwAYkPe8ztFhIjCtpFDAssh
        nXWMWpWj4a7WBgZxd693Frk0UElxPaiRl+6zCJf/1scTXegHeUxK+bk3NzJRw5ng/kN7ub0UizI
        ttRZFEdOlKbb8NUvZ
X-Received: by 2002:ac8:5544:0:b0:3a8:b88:c1 with SMTP id o4-20020ac85544000000b003a80b8800c1mr51790077qtr.66.1671435591904;
        Sun, 18 Dec 2022 23:39:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7+jlbEi9Hng1kQBhZFIW+Ck6EaPnOm37evbb26ZWZOc9ge1j5bCv1B5OdL+PMwpgyh21WQcw==
X-Received: by 2002:ac8:5544:0:b0:3a8:b88:c1 with SMTP id o4-20020ac85544000000b003a80b8800c1mr51790067qtr.66.1671435591645;
        Sun, 18 Dec 2022 23:39:51 -0800 (PST)
Received: from redhat.com ([45.144.113.29])
        by smtp.gmail.com with ESMTPSA id cj23-20020a05622a259700b003a7f597dc60sm5645751qtb.72.2022.12.18.23.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 23:39:51 -0800 (PST)
Date:   Mon, 19 Dec 2022 02:39:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Andrey Smetanin <asmetanin@yandex-team.ru>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
Message-ID: <20221219023900-mutt-send-email-mst@kernel.org>
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
 <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Any response here?


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

