Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C750B6DEBEB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjDLGia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjDLGi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233425B90
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681281450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwCbzAAjwbVI6L1+WlkLHSTqF7zMVDO5V+z4G1Cyt20=;
        b=BvhxvaHehdvyXdqrTh+zT4rCcmB/LhUrT2N5kxWmHceJKaWGXnopu+kfHjs4i9HZOURqeu
        Kmlf8BiNyU0CJ00M7QrP4vDsaDCzIjuaDjVfBrlBH1U/96LV0M6keREKKDKDcTTOc8i6tj
        yyrrB2ahCQ8KF1Ey5nDebRg13x8nJ/I=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-h5KMnHOoOXOiu9mEq34spg-1; Wed, 12 Apr 2023 02:37:27 -0400
X-MC-Unique: h5KMnHOoOXOiu9mEq34spg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1842f32da75so5927464fac.23
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681281446; x=1683873446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwCbzAAjwbVI6L1+WlkLHSTqF7zMVDO5V+z4G1Cyt20=;
        b=hUIdE680KlI5sfCCBl7jBSiWrVPBwePG466dFWYjOVUGUyDu+mQplfRE7NsLvSvGex
         fxVGri7OtVhZwxULESQQpAH7xjy9qa4WScyV/G1nVYLliAlVtYp1lfxqGK9PbpPyZuk5
         WZl0JV4wCx6wTUd7HX1ebk8w/czwmvJd76dNB7QsF3PGHxQuiDXn52/4R/HfTKtscqru
         aYCOHWOTp2kvxvIIi1j71KuD0EB82VeyBhb/N0H6KVZnGoUSkSMZvjAEUN3rofpANo2I
         g9//87cRRXW1r8GjZWjx0q6yxOrJDkjGx37T7OAak568ud6Aw180LLK8nzCv9RqMioK7
         q2kw==
X-Gm-Message-State: AAQBX9ccqroCHtCUEgcXoTwWeZTXOXSzbaBAfF3o7JE29PZ+CuDZx2V2
        LGbXD54rlb7Q1vmwFplJ1TBPK6pruv6WHYkHPMvCYAumiqoxAlCT+gnz1ogD82dvQpfByyw2vnI
        5EHQP2C/CLh6k50VHlz7+3sX4NdmS6LxWM4qullSJlKFaMFkz
X-Received: by 2002:a05:6870:96a3:b0:184:4c39:fe30 with SMTP id o35-20020a05687096a300b001844c39fe30mr4140723oaq.9.1681281446155;
        Tue, 11 Apr 2023 23:37:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZPI/ee2C3stnJNNuh0m3DxO1fUoT+0+j0FBOVNZyRv0Dqeao5UDr6cePplhgphOC+r4L2fQnDCBJAhIEVRckY=
X-Received: by 2002:a05:6870:96a3:b0:184:4c39:fe30 with SMTP id
 o35-20020a05687096a300b001844c39fe30mr4140719oaq.9.1681281445936; Tue, 11 Apr
 2023 23:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com> <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
 <CACLfguWKw68=wZNa7Ga+Jm8xTE93A_5za3Dc=S_z7ds9FCkRKg@mail.gmail.com>
 <CACGkMEv3aca0Thx+X3WZxbV2HK7514G3RzR+A0PqRu7k6Deztg@mail.gmail.com> <CACLfguXBeodQ=b-RAQ4JsaSnjS_ZNutr2nbunmdv1S8Gxz8gfg@mail.gmail.com>
In-Reply-To: <CACLfguXBeodQ=b-RAQ4JsaSnjS_ZNutr2nbunmdv1S8Gxz8gfg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 12 Apr 2023 14:37:14 +0800
Message-ID: <CACGkMEtwx7jMc2j=rhe8S1+uYVfs7UX9TCwRZsnW9tWR29uo5w@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 2:32=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> On Tue, Apr 11, 2023 at 5:14=E2=80=AFPM Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Tue, Apr 11, 2023 at 3:29=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrot=
e:
> > >
> > > On Tue, Apr 11, 2023 at 11:10=E2=80=AFAM Jason Wang <jasowang@redhat.=
com> wrote:
> > > >
> > > > On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com>=
 wrote:
> > > > >
> > > > > While using the no-batch mode, the process will not begin with
> > > > > VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> > > > > VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> > > > > same as VHOST_IOTLB_UPDATE
> > > > >
> > > > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > > > ---
> > > > >  drivers/vhost/vdpa.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > >
> > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > index 7be9d9d8f01c..32636a02a0ab 100644
> > > > > --- a/drivers/vhost/vdpa.c
> > > > > +++ b/drivers/vhost/vdpa.c
> > > > > @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(str=
uct vhost_dev *dev, u32 asid,
> > > > >                 goto unlock;
> > > > >
> > > > >         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> > > > > +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||
> > > >
> > > > I'm not sure I get here, invalidation doesn't need to create a new =
AS.
> > > >
> > > > Or maybe you can post the userspace code that can trigger this issu=
e?
> > > >
> > > > Thanks
> > > >
> > > sorry I didn't write it clearly
> > > For this issue can reproduce in vIOMMU no-batch mode support because
> > > while the vIOMMU enabled, it will
> > > flash a large memory to unmap, and this memory are haven't been mappe=
d
> > > before, so this unmapping will fail
> > >
> > > qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address=
)
> > > qemu-system-x86_64: vhost_vdpa_dma_unmap(0x7fa26d1dd190, 0x0,
> > > 0x80000000) =3D -5 (Bad address)
> >
> > So if this is a simple unmap, which error condition had you met in
> > vhost_vdpa_process_iotlb_msg()?
> >
> > I think you need to trace to see what happens. For example:
> >
> this happens when vIOMMU enable and vdpa binds to vfio-pci run testpmd
> the qemu will unmapped whole memory that was used and then mapped the
> iommu MR section

So it's a map after an unmap, not an invalidation?

> This memory much larger than the memory mapped to vdpa(this is what
> actually mapped to
> vdpa device in no-iommu MR)
>
> > 1) can the code pass asid_to_iotlb()
> > 2) if not, ASID 0 has been deleted since all the mappings have been unm=
apped
> >
> > if ASID 0 has been completely unmap, any reason we need to unmap it
> > again? And do we need to drop the vhost_vdpa_remove_as() from both
> >
>
> > 1) vhost_vdpa_unmap()
> > and
> > 2) vhost_vdpa_process_iotlb_msg()
> > ?
> >
> > Thanks
> >
> the code passed the asid_to_iotlb(), The iotlb is NULL at this situation
> and the vhost_vdpa_process_iotlb_msg will return fail. this will cause
> the mapping
>  in qemu fail

Yes, so what I meant:

Instead of free the AS in vhost_vdpa_unmap() or
vhost_vdpa_process_iotlb_msg() and allocate it again here.

Is it better to not remove the AS in those two functions even if
there's no maps?

Thanks

>
> thanks
> cindy
>
> > > qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address=
)
> > > ....
> > > in batch mode this operation will begin with VHOST_IOTLB_BATCH_BEGIN,
> > > so don't have this issue
> > >
> > > Thanks
> > > cindy
> > > > >             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
> > > > >                 as =3D vhost_vdpa_find_alloc_as(v, asid);
> > > > >                 if (!as) {
> > > > > --
> > > > > 2.34.3
> > > > >
> > > >
> > >
> >
>

