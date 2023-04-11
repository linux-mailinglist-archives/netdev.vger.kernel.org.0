Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7BD6DD42B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDKHaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDKH3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:29:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E52D5F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681198143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4fqI8bKtaB0NcHDktrPl8MWeP7RL/mWq8oUINt/T54=;
        b=V/R6ziqW7gXpfwPsXBDPpT8C2aKJQIRkgmgx2lvjOFBYLdIiTBEkjZngkUUa1dqoAoUagG
        vnWrsqh3eha0BVo107jnoJ23EGXzdFBcMi6vhoZHWUY1slwWpl/NT1EcuhJW9ODPiwVTJw
        J3DYyUPe9XsHFuMnbnK4lpRBU4yCHWM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-2K8HegBlNVepRgveZYsdQA-1; Tue, 11 Apr 2023 03:29:02 -0400
X-MC-Unique: 2K8HegBlNVepRgveZYsdQA-1
Received: by mail-wm1-f70.google.com with SMTP id l36-20020a05600c1d2400b003edd119ec9eso2189541wms.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681198139; x=1683790139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4fqI8bKtaB0NcHDktrPl8MWeP7RL/mWq8oUINt/T54=;
        b=y0iZrvbLI/Ts0rG+lSjcBBzSH4Oo/Hyapo03SIhG3QxPOYcu60wP4isBS+SVs5EvX+
         Svm74IY30o6W29vV8U3YV11O0ENLNSGoPhCqByATtVK214/XjPs1m4H9KA93bzXLWyPX
         gi2o7ZLf7Prn+rUpwQ7Sc8jQ8FWSq2r171TdBIw6zeS0mxvOeaLtS6Y0+3MNzvK3hZHX
         mM8s3cKPQQdNfWiz8IopPguXqwvGkgbwh1UbDy2255uOY8G30CiAehrHCvNxaEF7k3j3
         Ds1Z+WZlwWsn/D/5cY1MTOZSberZ5gJX25YWAE4Zl+645arKex/g/YuF0t7wwkUen3ZD
         PYOA==
X-Gm-Message-State: AAQBX9cElnMrJ+p102C4ysB8srYWRQbxwaJAafISfSL8atCEXCcbJoh0
        Wh1dNyuPfLomydrdx41rnUbZKMLdxl9tnZzZG85zFtnrKSMXrUGs9ZL53bt8qWXaPnhYe8tz0r+
        c3KrWzNg7tnf7M1+kbMwka6nCW+Bv0xtlDqENRkgcr5EJiQ==
X-Received: by 2002:a05:600c:3792:b0:3ed:d2ae:9aeb with SMTP id o18-20020a05600c379200b003edd2ae9aebmr2632740wmr.8.1681198139432;
        Tue, 11 Apr 2023 00:28:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350YW5IDOn+UtOVz4OnXhruknCN/7VUTSpUco2yUncWsdK7SLQjHRkIf40YFOegmhheb0QRHRYZwy7kM7Amph3GY=
X-Received: by 2002:a05:600c:3792:b0:3ed:d2ae:9aeb with SMTP id
 o18-20020a05600c379200b003edd2ae9aebmr2632737wmr.8.1681198139119; Tue, 11 Apr
 2023 00:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com> <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
In-Reply-To: <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Tue, 11 Apr 2023 15:28:21 +0800
Message-ID: <CACLfguWKw68=wZNa7Ga+Jm8xTE93A_5za3Dc=S_z7ds9FCkRKg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 11:10=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote=
:
> >
> > While using the no-batch mode, the process will not begin with
> > VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> > VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> > same as VHOST_IOTLB_UPDATE
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 7be9d9d8f01c..32636a02a0ab 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vh=
ost_dev *dev, u32 asid,
> >                 goto unlock;
> >
> >         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> > +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||
>
> I'm not sure I get here, invalidation doesn't need to create a new AS.
>
> Or maybe you can post the userspace code that can trigger this issue?
>
> Thanks
>
sorry I didn't write it clearly
For this issue can reproduce in vIOMMU no-batch mode support because
while the vIOMMU enabled, it will
flash a large memory to unmap, and this memory are haven't been mapped
before, so this unmapping will fail

qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
qemu-system-x86_64: vhost_vdpa_dma_unmap(0x7fa26d1dd190, 0x0,
0x80000000) =3D -5 (Bad address)
qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
....
in batch mode this operation will begin with VHOST_IOTLB_BATCH_BEGIN,
so don't have this issue

Thanks
cindy
> >             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
> >                 as =3D vhost_vdpa_find_alloc_as(v, asid);
> >                 if (!as) {
> > --
> > 2.34.3
> >
>

