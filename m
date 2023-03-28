Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74B86CB52C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjC1Dy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjC1Dyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD4919A4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 20:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679975602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ap2W7rICg75yU+OVQdWf7kfBcx1hCk4Lyy4ZTxBSTOg=;
        b=TrPFjw0MFiZzP9MGIhCptZ8KWpmV6FLDTqqpnDdZlEXqpKgJrh2nHFmikRAC1um/HRNEf2
        JxLJKzUfksT+H5B6ZRh1vUXJnLwjylPfximbG7CoMDo4ZSHmnyOYq/zrkrArzxnKHRlVIu
        UiOi3OrRJts8jl4iaYh9NTPLl0f9BGg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502--0NIYSNeORCOLTrvBzPMqQ-1; Mon, 27 Mar 2023 23:53:20 -0400
X-MC-Unique: -0NIYSNeORCOLTrvBzPMqQ-1
Received: by mail-ot1-f71.google.com with SMTP id m1-20020a0568301e6100b0069f94fdab6fso4516143otr.21
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 20:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679975599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ap2W7rICg75yU+OVQdWf7kfBcx1hCk4Lyy4ZTxBSTOg=;
        b=WIpVIIJCB5eb9vO+2vnitHA1dtiZi/gQU8l951kpP0utQnnX8URXM4EZcTOhCHCtu3
         S2Vrl3WyMWk7XqfGUIOUyHjygSDgbm7LRql8W8A9xdZ2nzWP12t8xSzZ0FvFfz2EKNJ3
         apmLXAoaPh/WQJzF6KWNBxXN4Fj+NMF9XnWoVEJzedZvc92m8CEEQldQXkOFsTGAPdKM
         de+9A3e/D6y+09HnmFt4LY8QH03pdHprS9cMBigULsXaiinUZa3FtuH0BStzXSa2GobZ
         yw7Y77hHmSzbV6Zl+lFlcnjsvXDwH/Jyl6ebM0jROmw60bgxGkmWBBEKFq6n2CVwOoyf
         udiA==
X-Gm-Message-State: AAQBX9cBWfn6D13tknZv5drkJ28G5dUaL7HDoe8/et9cQBGUb/XtKuRp
        lqAKHqF2szXfpVh5oL3b55vmGWdk1v0zN2MtzJf+VXJbC83np2OeG69Ikun6oTNBi9EbAGhZGZ1
        PqQ8eiWRFw8cnwGLq9CejFetmv2o67v+L
X-Received: by 2002:a05:6808:f12:b0:389:4edd:deb8 with SMTP id m18-20020a0568080f1200b003894edddeb8mr650901oiw.9.1679975599699;
        Mon, 27 Mar 2023 20:53:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350YReprdYf6cd/1IwBzLSwvTjjoTN4no5pRuxYfL6LUkxj0OTHXmA/1f8lsroZgUVcz4EsWQTsu+XCDM1p8SiTw=
X-Received: by 2002:a05:6808:f12:b0:389:4edd:deb8 with SMTP id
 m18-20020a0568080f1200b003894edddeb8mr650895oiw.9.1679975599494; Mon, 27 Mar
 2023 20:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-7-shannon.nelson@amd.com> <CACGkMEvacgachSZK8J4zpSXAYaCBkyJrqp8_rYV7-k1O7arC7Q@mail.gmail.com>
 <efa1bda9-6b12-54c1-8d98-7838469cee03@amd.com>
In-Reply-To: <efa1bda9-6b12-54c1-8d98-7838469cee03@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 28 Mar 2023 11:53:08 +0800
Message-ID: <CACGkMEvOF7Qb-d61+GG5c5-QnrM2qsRe7Z-6Q+S-vNOdic3Law@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 6/8] pds_vdpa: add support for vdpa and vdpamgmt interfaces
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
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

On Sat, Mar 25, 2023 at 8:27=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.=
com> wrote:
>
> On 3/22/23 10:18 PM, Jason Wang wrote:
> > On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Shannon Nelson <shannon.nelson@=
amd.com> wrote:
> >>
> >> This is the vDPA device support, where we advertise that we can
> >> support the virtio queues and deal with the configuration work
> >> through the pds_core's adminq.
> >>
> >> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> >> ---
> >>   drivers/vdpa/pds/aux_drv.c  |  15 +
> >>   drivers/vdpa/pds/aux_drv.h  |   1 +
> >>   drivers/vdpa/pds/debugfs.c  | 260 +++++++++++++++++
> >>   drivers/vdpa/pds/debugfs.h  |  10 +
> >>   drivers/vdpa/pds/vdpa_dev.c | 560 ++++++++++++++++++++++++++++++++++=
+-
> >>   5 files changed, 845 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> >> index 8f3ae3326885..e54f0371c60e 100644
> >> --- a/drivers/vdpa/pds/aux_drv.c
> >> +++ b/drivers/vdpa/pds/aux_drv.c
> >
> > [...]
> >
> >> +
> >> +static struct vdpa_notification_area
> >> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
> >> +{
> >> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> >> +       struct virtio_pci_modern_device *vd_mdev;
> >> +       struct vdpa_notification_area area;
> >> +
> >> +       area.addr =3D pdsv->vqs[qid].notify_pa;
> >> +
> >> +       vd_mdev =3D &pdsv->vdpa_aux->vd_mdev;
> >> +       if (!vd_mdev->notify_offset_multiplier)
> >> +               area.size =3D PDS_PAGE_SIZE;
> >
> > This hasn't been defined so far? Others look good.
>
> Sorry, I don't understand your question.
> sln

I mean I don't see the definition of PDS_PAGE_SIZE so far.

Thanks

>
>
> >
> > Thanks
> >
>

