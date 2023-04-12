Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD4F6DEBD5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjDLGdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLGdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:33:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BD64ECD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681281140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYkU2h5uuqeCAix2xVoQ4YssyuBrvdvQQLmL8KGrxsM=;
        b=UUCwMGadrki5JWKlGDd5YjsjNgtVCTlnEpCZt6j+HLOJjofGhPeyd2f4mk6t3iGow0CjMe
        ctdATfOLqFNk3wIFeRSF2Amgv5hpoMJsQx+LQ8Renv/oCF00vf8nWjF5RAtZpg/1fhBbrQ
        qKxHSLFai7Q4MAeJVMnbPDj+25CDEJY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408--RiG1QrtNoWvQjrm1-Rsxw-1; Wed, 12 Apr 2023 02:32:18 -0400
X-MC-Unique: -RiG1QrtNoWvQjrm1-Rsxw-1
Received: by mail-wr1-f70.google.com with SMTP id j15-20020adfb30f000000b002d34203df59so1475840wrd.9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681281137; x=1683873137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYkU2h5uuqeCAix2xVoQ4YssyuBrvdvQQLmL8KGrxsM=;
        b=kQpHg2HfN+U8iKP0uQpN4QqKb7SZ0ZpcK6vO2AnrUIENuu9uBi8FfnIGdzYMlds6b6
         tGrlXCC7hhN0Ue6N/nHRc2Zf68mgHND8bJGjSaMMMFFAbv6/WJ6swW6DCMlb6JQIgvvo
         Ma2uKTivIBVHEMKOsQ/w5icVrFb7mAwDB2qYoXS6i/J6vj8HwCSDbrR53rIShcsSs4jx
         XJpR9q4k8Gi8WdvFwhWYeeAuAW61vmOaCNChvvtANGurMtHhYdsRqc13QCIr2h3Y2hva
         qR5J6sVIJCPGaQexM4MVSHAV942Ljk35P7Ue3RNfxVFk1oZJ7fA2AC9oaVNUksNhCfaj
         KNDg==
X-Gm-Message-State: AAQBX9dQ9xvZGoqamY5lP9/dfiPYViqs/zPdMInDY6lVLeT+TkyxvVse
        y9JrKiCs9POBNF16JFAE6AsaqizmzuvVStqWiMdy1NXzOTZf0b13z0KWzbBdzqNzBffYDNsExWy
        OJiHMoedb/NPoT6Au6zwPcxq8jBIa80FO
X-Received: by 2002:a5d:4f0e:0:b0:2ef:b5e1:f6f9 with SMTP id c14-20020a5d4f0e000000b002efb5e1f6f9mr1138576wru.8.1681281137428;
        Tue, 11 Apr 2023 23:32:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350bq+8zhP15Uz7cAyV/Z2wcK+XlbYPBXQnmfbUh0oOiNvYPBIB4YmU5DtGfzZWjmjnceIOMDqjcTSn3ph7ZNmlE=
X-Received: by 2002:a5d:4f0e:0:b0:2ef:b5e1:f6f9 with SMTP id
 c14-20020a5d4f0e000000b002efb5e1f6f9mr1138568wru.8.1681281137152; Tue, 11 Apr
 2023 23:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com> <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
 <CACLfguWKw68=wZNa7Ga+Jm8xTE93A_5za3Dc=S_z7ds9FCkRKg@mail.gmail.com> <CACGkMEv3aca0Thx+X3WZxbV2HK7514G3RzR+A0PqRu7k6Deztg@mail.gmail.com>
In-Reply-To: <CACGkMEv3aca0Thx+X3WZxbV2HK7514G3RzR+A0PqRu7k6Deztg@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 12 Apr 2023 14:31:38 +0800
Message-ID: <CACLfguXBeodQ=b-RAQ4JsaSnjS_ZNutr2nbunmdv1S8Gxz8gfg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Jason Wang <jasowang@redhat.com>
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

On Tue, Apr 11, 2023 at 5:14=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Tue, Apr 11, 2023 at 3:29=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
> >
> > On Tue, Apr 11, 2023 at 11:10=E2=80=AFAM Jason Wang <jasowang@redhat.co=
m> wrote:
> > >
> > > On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com> w=
rote:
> > > >
> > > > While using the no-batch mode, the process will not begin with
> > > > VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> > > > VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> > > > same as VHOST_IOTLB_UPDATE
> > > >
> > > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > > ---
> > > >  drivers/vhost/vdpa.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > index 7be9d9d8f01c..32636a02a0ab 100644
> > > > --- a/drivers/vhost/vdpa.c
> > > > +++ b/drivers/vhost/vdpa.c
> > > > @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struc=
t vhost_dev *dev, u32 asid,
> > > >                 goto unlock;
> > > >
> > > >         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> > > > +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||
> > >
> > > I'm not sure I get here, invalidation doesn't need to create a new AS=
.
> > >
> > > Or maybe you can post the userspace code that can trigger this issue?
> > >
> > > Thanks
> > >
> > sorry I didn't write it clearly
> > For this issue can reproduce in vIOMMU no-batch mode support because
> > while the vIOMMU enabled, it will
> > flash a large memory to unmap, and this memory are haven't been mapped
> > before, so this unmapping will fail
> >
> > qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
> > qemu-system-x86_64: vhost_vdpa_dma_unmap(0x7fa26d1dd190, 0x0,
> > 0x80000000) =3D -5 (Bad address)
>
> So if this is a simple unmap, which error condition had you met in
> vhost_vdpa_process_iotlb_msg()?
>
> I think you need to trace to see what happens. For example:
>
this happens when vIOMMU enable and vdpa binds to vfio-pci run testpmd
the qemu will unmapped whole memory that was used and then mapped the
iommu MR section
This memory much larger than the memory mapped to vdpa(this is what
actually mapped to
vdpa device in no-iommu MR)

> 1) can the code pass asid_to_iotlb()
> 2) if not, ASID 0 has been deleted since all the mappings have been unmap=
ped
>
> if ASID 0 has been completely unmap, any reason we need to unmap it
> again? And do we need to drop the vhost_vdpa_remove_as() from both
>

> 1) vhost_vdpa_unmap()
> and
> 2) vhost_vdpa_process_iotlb_msg()
> ?
>
> Thanks
>
the code passed the asid_to_iotlb(), The iotlb is NULL at this situation
and the vhost_vdpa_process_iotlb_msg will return fail. this will cause
the mapping
 in qemu fail

thanks
cindy

> > qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
> > ....
> > in batch mode this operation will begin with VHOST_IOTLB_BATCH_BEGIN,
> > so don't have this issue
> >
> > Thanks
> > cindy
> > > >             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
> > > >                 as =3D vhost_vdpa_find_alloc_as(v, asid);
> > > >                 if (!as) {
> > > > --
> > > > 2.34.3
> > > >
> > >
> >
>

