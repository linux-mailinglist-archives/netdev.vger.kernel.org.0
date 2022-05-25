Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D881A5336D7
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 08:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244191AbiEYGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 02:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiEYGnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 02:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 420ED5D657
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653461010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2Zld6JK1r8zgbUydwUdmco7GN3nEwbTaFoGldh5jsg=;
        b=abmB+yS2IO2djQn1lWcV1T6g0o7r7MlMUx60sb9J2zMjTEOZ/9jdA/IdxTdlLCOLXPDmcF
        b3LcZtixnRHVLq0P+SnqeBAbj0I6bzoyN4bsvBRvdCUcZnJek8F2h7t0lHpHCqZEzP5y1T
        Ip90vgVI4a4s9sQpsZt+lwEbmc6+HNw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-K2NBDRDRO-6ETqQfsp30LQ-1; Wed, 25 May 2022 02:43:28 -0400
X-MC-Unique: K2NBDRDRO-6ETqQfsp30LQ-1
Received: by mail-qk1-f200.google.com with SMTP id i2-20020a05620a144200b006a3a8651de1so4379611qkl.14
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t2Zld6JK1r8zgbUydwUdmco7GN3nEwbTaFoGldh5jsg=;
        b=eGcByA573zeccy1L1zLLDAE/PI1rx6y5zeV6xFeMPfXHXltvmeDvjOrTnJdZfjJMW7
         jbdtZLuDLs7zZ+xAUPHRXgpgjO2TxKdOyK6b1KbgB0n4wLMQ2t1bL+RAcS4u26t6AijO
         rt/aLVpMA4ZQSXNFrR7lT75ZIEparzJRDvtTPrZSxBvj6Qy1A/Nd9DM7cy1e5X+rJr1S
         A+OlBK3nIOUPV2AnL+ex8M7O+ZnsLZHa36C/vET+6/W/i8KuOPJA/OyGgyAimUFCXawA
         1eyGbPmx6y+QKPHEMJ3y6dFf790duwlE6pQ9MV0GYFVi2nWS8CVc3NhD1LIJmQVCmhht
         5d+Q==
X-Gm-Message-State: AOAM5321d9HLzPvyAQckV9dyI1eiwVUfSIkK9XmX4+akGw+7Vc/grlSY
        9M6YwImNZM93rXMxzu5cbaBZKSnawtU9linIWALU/C/vt0/iTmVkgZfC1VbXE1/sEncTAP7aRDm
        c69FAf91K9fGSz6QmZ6n7oSEkaoh3xKag
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id e12-20020a05622a110c00b002f3d3476f8dmr23194811qty.403.1653461008266;
        Tue, 24 May 2022 23:43:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ8dcSHGHtQp++R04NfX6dSXKduh/QL7dOUX4GVwi7PAAfVXD8vq1JEMSqOxOdTaSi+fQ4h/y0zxXauU4VgvY=
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id
 e12-20020a05622a110c00b002f3d3476f8dmr23194805qty.403.1653461008055; Tue, 24
 May 2022 23:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com> <CACGkMEvHRL7a6njivA0+ae-+nXUB9Dng=oaQny0cHu-Ra+bcFg@mail.gmail.com>
In-Reply-To: <CACGkMEvHRL7a6njivA0+ae-+nXUB9Dng=oaQny0cHu-Ra+bcFg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 25 May 2022 08:42:52 +0200
Message-ID: <CAJaqyWd6vwPJqFRrY6z0-Q9CpW-FABE_8+hw77q_x5qXQTXKfw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Implement vdpasim stop operation
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cindy Lu <lulu@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Martin Porter <martinpo@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 4:49 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> =
wrote:
> >
> > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > that backend feature and userspace can effectively stop the device.
> >
> > This is a must before get virtqueue indexes (base) for live migration,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After the return of ioctl with stop !=3D 0, the device MUST finish any
> > pending operations like in flight requests. It must also preserve all
> > the necessary state (the virtqueue vring base plus the possible device
> > specific states) that is required for restoring in the future. The
> > device must not change its configuration after that point.
>
> I'd suggest documenting this in the code maybe around ops->stop()?
>

I agree it'd be better to put in the source code, but both
vdpa_config_ops and ops->stop don't have a lot of space for docs.

Would it work to document at drivers/vdpa/vdpa.c:vhost_vdpa_stop() and
redirect config ops like "for more info, see vhost_vdpa_stop"?

Thanks!

> Thanks
>
> >
> > After the return of ioctl with stop =3D=3D 0, the device can continue
> > processing buffers as long as typical conditions are met (vq is enabled=
,
> > DRIVER_OK status bit is enabled, etc).
> >
> > In the future, we will provide features similar to VHOST_USER_GET_INFLI=
GHT_FD
> > so the device can save pending operations.
> >
> > Comments are welcome.
> >
> > v2:
> > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > * Add stop to vdpa_sim_blk.
> >
> > Eugenio P=C3=A9rez (4):
> >   vdpa: Add stop operation
> >   vhost-vdpa: introduce STOP backend feature bit
> >   vhost-vdpa: uAPI to stop the device
> >   vdpa_sim: Implement stop vdpa op
> >
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> >  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
> >  include/linux/vdpa.h                 |  6 +++++
> >  include/uapi/linux/vhost.h           |  3 +++
> >  include/uapi/linux/vhost_types.h     |  2 ++
> >  8 files changed, 72 insertions(+), 1 deletion(-)
> >
> > --
> > 2.27.0
> >
> >
>

