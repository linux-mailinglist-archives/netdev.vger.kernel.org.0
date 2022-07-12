Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741C357152A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiGLI4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGLI4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F43EA9E4F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657616178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLcTYLAK7OO1gU3u/jl0Yl/dEb2Q4HteFWvGNq3wdJo=;
        b=TjpwkCYYZeljq6+NVc1f1FIHyEXnUmBWkJhUhm+b3sDcKQxg3UX8BVAncKcTYKFQ5u161v
        3+SFSXJWL7jZtvta53EKYy1Tj8u6SDozLYoQ2pi5NtkzFo3LHOSK+M8nKVMw/9hGA6WkCF
        bxly6nFcRRi7JPOHEaIshfTU4gJLsUM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-KLnmAtvdN9G8BRZALXz7nw-1; Tue, 12 Jul 2022 04:56:10 -0400
X-MC-Unique: KLnmAtvdN9G8BRZALXz7nw-1
Received: by mail-qv1-f72.google.com with SMTP id d18-20020a0cfe92000000b0047342562073so1438690qvs.1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=iLcTYLAK7OO1gU3u/jl0Yl/dEb2Q4HteFWvGNq3wdJo=;
        b=3DErD2eN0PQ7Qp3ckk4vNMwhuMuo5jVZSczu0vlBa9ync+BzkQkbwhO9h4HG9vUO9X
         LLOrNlKyGWMXzyVaGnEZjqCyg4J2iIZa/+cgUWbQGknodwM4bMFdvSqd79aNzOHwlhVz
         i01B+heDlp57kW4CNARVVXxm+Y/SH6t6spkstrWOQEZ+cULzR/YfSf0wbVpBXX1c6r8s
         DqwSloZ3lysxqCvHEgrn5xnzbIRNG/tojckSD1MxmhauqZOxOWCKIhTLlvQqem/BrE+J
         1+ru0HNEMV8/3Elo4aeZB+czNSXcrmZvrhRau5o87WpHISQnFH1LCEZCNrA+FA3mXF6K
         SgpA==
X-Gm-Message-State: AJIora/+OPLwvAt19rS26eMKnvqx9NscMXfxVC+FAP58buAA8tj6l5oB
        kzkQoEC3fiuqYaUUxpXV2vDsWsb02btmW8ni1Oybxko4jvYcZQkrF4dNzHwlV4IxJ04aLaOIIxf
        sbOwcTSL/0svcEgV6P74XgTD+nCE8Wb30
X-Received: by 2002:ac8:58d0:0:b0:31d:3287:10fe with SMTP id u16-20020ac858d0000000b0031d328710femr17121964qta.557.1657616170169;
        Tue, 12 Jul 2022 01:56:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sKK5s03uR+06SsGS0H+06SoB3Jj4D1i0ueVLfAfx6dJu9ikclKzbRzBmbL1QBEt23Ip3lLcokmYIFDiOGuYME=
X-Received: by 2002:ac8:58d0:0:b0:31d:3287:10fe with SMTP id
 u16-20020ac858d0000000b0031d328710femr17121952qta.557.1657616169886; Tue, 12
 Jul 2022 01:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220712062642.6915-1-ihuguet@redhat.com> <Ys0pNQWAJneX1gQ8@gmail.com>
In-Reply-To: <Ys0pNQWAJneX1gQ8@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 12 Jul 2022 10:55:59 +0200
Message-ID: <CACT4oud_43SGMoZtRZxyAWfaFbVAPdJcLRMLcU84Q90d=8XOxA@mail.gmail.com>
Subject: Re: [PATCH v2 net] sfc: fix use after free when disabling sriov
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, sshah@solarflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Yanghang Liu <yanghliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Tue, Jul 12, 2022 at 9:56 AM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> On Tue, Jul 12, 2022 at 08:26:42AM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > Use after free is detected by kfence when disabling sriov. What was rea=
d
> > after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> > and later read in efx_ef10_sriov_free_vf_vports, called from
> > efx_ef10_sriov_free_vf_vswitching.
> >
> > Set the pointer to NULL at release time to not trying to read it later.
>
> This solution just bypasses the check we have in
> efx_ef10_sriov_free_vf_vports():
>                 /* If VF is assigned, do not free the vport  */
>                 if (vf->pci_dev && pci_is_dev_assigned(vf->pci_dev))
>                         continue;
>
> If we don't want to detect this any more we should remove this
> check in stead of this patch.

It doesn't really bypass it, because sriov is disabled and vf->pci_dev
set to NULL only if there are no devices assigned: the check is done
by the `if (!vfs_assigned)` in `efx_ef10_pci_sriov_disable`. If there
are any assigned devices, SRIOV is not disabled and vf->pci_dev is not
set to NULL.

> There is another issue here, in efx_ef10_sriov_free_vf_vswitching()
> we do free the memory even if a VF was still assigned. This leads me
> to think that removing the check above is the better thing to do.

Note that `pci_is_dev_assigned` and `pci_vfs_assigned` only count VFs
assigned to Xen, but not with other methods (kvm, vfio...). That means
that we are not really able to know when a VF is actually assigned to
an VM.

Right now:
* If any VF is assigned to Xen VM: driver doesn't disable SRVIO and
doesn't free memory of assigned VFs, but it does free memory of
unassigned VFs
* If any VF is assigned to a non-Xen VM: driver disables SRVIO and
free memory of all VFs

kvm/vfio case: I don't think we can or should do anything to avoid
disabling SRIOV.

Xen case: I didn't know very well what it should be done, so I just
assumed that the driver was doing the right thing. If it's not, there
are 2 possibilities:
* Option 1: Do the same thing that in the kvm/vfio case: Free memory
anyway, as you say, but also disable SRIOV even if there are assigned
VFs.
* Option 2: Continue with the current driver's behaviour (but fixing
it): don't allow to disable SRIOV if there are assigned VFs.

For option1, I don't know what happens if VFs assigned to Xen suddenly
disappear. This option could have more unintended side effects than
option 2....

For option 2, my guess is that we shouldn't free any memory at all if
we don't disable SRIOV. So we should move the call to
`efx_ef10_sriov_free_vf_vswitching` into the `if (!vfs_assigned)`
block. Also, remove that "is_assigned" check inside
`efx_ef10_sriov_free_vf_vswitching`, as you say.

What do you think? Option 1 or option 2?

>
> Martin
>
> > Reproducer and dmesg log (note that kfence doesn't detect it every time=
):
> > $ echo 1 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> > $ echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
> >
> >  BUG: KFENCE: use-after-free read in efx_ef10_sriov_free_vf_vswitching+=
0x82/0x170 [sfc]
> >
> >  Use-after-free read at 0x00000000ff3c1ba5 (in kfence-#224):
> >   efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
> >   efx_ef10_pci_sriov_disable+0x38/0x70 [sfc]
> >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> >   sriov_numvfs_store+0xfe/0x140
> >   kernfs_fop_write_iter+0x11c/0x1b0
> >   new_sync_write+0x11f/0x1b0
> >   vfs_write+0x1eb/0x280
> >   ksys_write+0x5f/0xe0
> >   do_syscall_64+0x5c/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> >  kfence-#224: 0x00000000edb8ef95-0x00000000671f5ce1, size=3D2792, cache=
=3Dkmalloc-4k
> >
> >  allocated by task 6771 on cpu 10 at 3137.860196s:
> >   pci_alloc_dev+0x21/0x60
> >   pci_iov_add_virtfn+0x2a2/0x320
> >   sriov_enable+0x212/0x3e0
> >   efx_ef10_sriov_configure+0x67/0x80 [sfc]
> >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> >   sriov_numvfs_store+0xba/0x140
> >   kernfs_fop_write_iter+0x11c/0x1b0
> >   new_sync_write+0x11f/0x1b0
> >   vfs_write+0x1eb/0x280
> >   ksys_write+0x5f/0xe0
> >   do_syscall_64+0x5c/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> >  freed by task 6771 on cpu 12 at 3170.991309s:
> >   device_release+0x34/0x90
> >   kobject_cleanup+0x3a/0x130
> >   pci_iov_remove_virtfn+0xd9/0x120
> >   sriov_disable+0x30/0xe0
> >   efx_ef10_pci_sriov_disable+0x57/0x70 [sfc]
> >   efx_pci_sriov_configure+0x24/0x40 [sfc]
> >   sriov_numvfs_store+0xfe/0x140
> >   kernfs_fop_write_iter+0x11c/0x1b0
> >   new_sync_write+0x11f/0x1b0
> >   vfs_write+0x1eb/0x280
> >   ksys_write+0x5f/0xe0
> >   do_syscall_64+0x5c/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Fixes: 3c5eb87605e85 ("sfc: create vports for VFs and assign random MAC=
 addresses")
> > Reported-by: Yanghang Liu <yanghliu@redhat.com>
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> > v2: add missing Fixes tag
> >
> >  drivers/net/ethernet/sfc/ef10_sriov.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethern=
et/sfc/ef10_sriov.c
> > index 7f5aa4a8c451..92550c7e85ce 100644
> > --- a/drivers/net/ethernet/sfc/ef10_sriov.c
> > +++ b/drivers/net/ethernet/sfc/ef10_sriov.c
> > @@ -408,8 +408,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic=
 *efx, int num_vfs)
> >  static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
> >  {
> >       struct pci_dev *dev =3D efx->pci_dev;
> > +     struct efx_ef10_nic_data *nic_data =3D efx->nic_data;
> >       unsigned int vfs_assigned =3D pci_vfs_assigned(dev);
> > -     int rc =3D 0;
> > +     int i, rc =3D 0;
> >
> >       if (vfs_assigned && !force) {
> >               netif_info(efx, drv, efx->net_dev, "VFs are assigned to g=
uests; "
> > @@ -417,10 +418,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_=
nic *efx, bool force)
> >               return -EBUSY;
> >       }
> >
> > -     if (!vfs_assigned)
> > +     if (!vfs_assigned) {
> > +             for (i =3D 0; i < efx->vf_count; i++)
> > +                     nic_data->vf[i].pci_dev =3D NULL;
> >               pci_disable_sriov(dev);
> > -     else
> > +     } else {
> >               rc =3D -EBUSY;
> > +     }
> >
> >       efx_ef10_sriov_free_vf_vswitching(efx);
> >       efx->vf_count =3D 0;
> > --
> > 2.34.1
>


--
=C3=8D=C3=B1igo Huguet

