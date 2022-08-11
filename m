Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94458F74D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiHKFgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiHKFgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CE0117061
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 22:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660196159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1PCUDSqmLKN2Mlp7gJOvD0wMAFZjw97KA+2ssjA/d5A=;
        b=AKETq6hRC+MpzLUhdZkgVgmGYxQ79LTtqDJXRP/ATanl06xhVGnVZZyEyL/pNJ9rlDqxUU
        p2mwvqWSd0v3iKp1H9CVSh8N590w7b4rO0GB9ETgtR/cIOoX/2bkMO87wsmhdPFv7lGOsP
        miqzZvxccd7SSbY5ap8lhooiop/klNY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-fz-ZKfYEM_eR1YB_uN7LFA-1; Thu, 11 Aug 2022 01:35:58 -0400
X-MC-Unique: fz-ZKfYEM_eR1YB_uN7LFA-1
Received: by mail-qv1-f69.google.com with SMTP id op9-20020a056214458900b00475a72eeb4dso8855848qvb.11
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 22:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=1PCUDSqmLKN2Mlp7gJOvD0wMAFZjw97KA+2ssjA/d5A=;
        b=yBx8Ccaxj6DqVt5ngJyGa0iwd8yUS1kA281my1Qr8vNUaMzYiKiuP15ORHFgkX0ONp
         s/OcYzRaTjwM9HBECoaQpC2CYJe5lq0C/iZiyfnGnfRHKoKdMhRq0YL1RGll1F3bITon
         +XxRbZFCPH9MA7HgP8TlzwXfDMNRjNNGRw04lGAHu7gra8guA/AbhImelDXZoAx1N7+s
         750g1wed+eH5MEiNxvs+Mh2uljT+DC94RjvIRhcbUGvczMxaUvL7djNZ6TG39MCksiYG
         +yGBdobjEMR/NiOUolrSb7dQpoMToVHqZdvo3kCDB8QAWiFEtvpCVZwjFkzBP2rLGUBH
         fljg==
X-Gm-Message-State: ACgBeo3aLmIjRgzqZ8Sm1ER64trey32XZoFyYpE4ahxIVGC4bN9hNDAR
        wTtoBSv6PieXsa3ypXtjY+aQ9ODyObRj+M977PHdHw9gJ710FJZWjHC1yZj9dwCnYPyJkn5ipFI
        S+M+kRMNJdvG21+uWJ9s+GZHuTE+sNyI8
X-Received: by 2002:a37:74f:0:b0:6b9:c9ce:b86f with SMTP id 76-20020a37074f000000b006b9c9ceb86fmr575987qkh.193.1660196157672;
        Wed, 10 Aug 2022 22:35:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR45v/I+FF3SnUkGenVkbLRvx2Dlfsel/4Yt8Xh4sSTFVFijLac+a/dkfGCbHEAx8EzuNsSMP06jx0ECj3Fcois=
X-Received: by 2002:a37:74f:0:b0:6b9:c9ce:b86f with SMTP id
 76-20020a37074f000000b006b9c9ceb86fmr575975qkh.193.1660196157457; Wed, 10 Aug
 2022 22:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220810171512.2343333-1-eperezma@redhat.com> <20220810151907-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220810151907-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 11 Aug 2022 07:35:21 +0200
Message-ID: <CAJaqyWdyFt5tvjFQuC3pO6eXV0ogtV8DeCTCRw0y6HFeON0_+w@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Implement vdpasim suspend operation
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>, ecree.xilinx@gmail.com,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        habetsm.xilinx@gmail.com, Laurent Vivier <lvivier@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Longpeng <longpeng2@huawei.com>, Cindy Lu <lulu@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 9:20 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Aug 10, 2022 at 07:15:08PM +0200, Eugenio P=C3=A9rez wrote:
> > Implement suspend operation for vdpa_sim devices, so vhost-vdpa will of=
fer
> > that backend feature and userspace can effectively suspend the device.
> >
> > This is a must before getting virtqueue indexes (base) for live migrati=
on,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After a successful return of ioctl the device must not process more vir=
tqueue
> > descriptors. The device can answer to read or writes of config fields a=
s if it
> > were not suspended. In particular, writing to "queue_enable" with a val=
ue of 1
> > will not make the device start processing virtqueue buffers.
> >
> > In the future, we will provide features similar to
> > VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.
> >
> > Applied on top of [1] branch after removing the old commits.
>
> Except, I can't really do this without invaliding all testing.
> Can't you post an incremental patch?
>

Oops, sorry.

I can send it for doc and internal code. But is it ok to remove an
ioctl arg with incremental patches?

Thanks!

> > Comments are welcome.
> >
> > v7:
> > * Remove ioctl leftover argument and update doc accordingly.
>
> > v6:
> > * Remove the resume operation, making the ioctl simpler. We can always =
add
> >   another ioctl for VM_STOP/VM_RESUME operation later.
> > * s/stop/suspend/ to differentiate more from reset.
> > * Clarify scope of the suspend operation.
> >
> > v5:
> > * s/not stop/resume/ in doc.
> >
> > v4:
> > * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> >
> > v3:
> > * s/VHOST_STOP/VHOST_VDPA_STOP/
> > * Add documentation and requirements of the ioctl above its definition.
> >
> > v2:
> > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > * Add stop to vdpa_sim_blk.
> >
> > [1] git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> >
> > Eugenio P=C3=A9rez (4):
> >   vdpa: Add suspend operation
> >   vhost-vdpa: introduce SUSPEND backend feature bit
> >   vhost-vdpa: uAPI to suspend the device
> >   vdpa_sim: Implement suspend vdpa op
> >
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 14 +++++++++++
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> >  drivers/vhost/vdpa.c                 | 35 +++++++++++++++++++++++++++-
> >  include/linux/vdpa.h                 |  4 ++++
> >  include/uapi/linux/vhost.h           |  9 +++++++
> >  include/uapi/linux/vhost_types.h     |  2 ++
> >  8 files changed, 70 insertions(+), 1 deletion(-)
> >
> > --
> > 2.31.1
> >
>

