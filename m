Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808CE534F92
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347408AbiEZMoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347478AbiEZMon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:44:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0466F95499
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653569080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHe1LaBtedJ5JV6CIRJWahlJ1EFaGN6YwiuH4nEgZ+o=;
        b=ciYRdY8WaY8hjk16N5ZWvG6uUSXazxyeuoXEzPlQVhBBr4W7pNzNguMnMod1f5vWjVMORY
        +lwANqaSk2NdUTw9cLg/uI+1tQsXv1+boIqjFlwdfQsrzBJIgqRV4A2Qt51V61Cmm1Z3J5
        wWYmqZU1zmDixSpzTzDBFtdAzrZUvFU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-auimFXr0NRGBcgxRTiX0UA-1; Thu, 26 May 2022 08:44:39 -0400
X-MC-Unique: auimFXr0NRGBcgxRTiX0UA-1
Received: by mail-qt1-f197.google.com with SMTP id t25-20020a05622a181900b002f3b32a6e30so1448403qtc.11
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HHe1LaBtedJ5JV6CIRJWahlJ1EFaGN6YwiuH4nEgZ+o=;
        b=4oyO/50bT0LknVwivYOdOUNZ3OyBIT5NGaDvnIumgY+omCWWTviRxhBnx4+loo2QVk
         xpUjXVOUCjWt/RheE2n7jwN3ecalVw0yKgtGZDG3X+EtzEaDSU7sak9mhlqGosKJaPED
         MALWqwxWheUrnMaWFNamWtk3s3R+85rCBA3CwkKcWQXcgNi7qnw4nBOLwVj0rXdF1tDI
         8tPcMsQ/Vp0+jbfynqp7ZbGPX/+fEJLw3BElD7Zogqk2O2AfUNtXD7yCIYn6h+zUeYeG
         /dzpjLmheRwD/drHz2VKVaIQ/WA/8CT3xWVsG2cZVHhCQ0NH638Usef2EVT4CSlYjkPn
         +3fQ==
X-Gm-Message-State: AOAM530kBZf8EQ6BmwWK4qydgtyMj5wcl77cJSxQyWz9CaT7V6Gw0Ltx
        BSWa7zrO+JvMpy+vxjrY1di/q7/uC1Zn92pCAAtqCwO0WELczY32ebyrj0v46F/5jIViUH6MmUe
        0V8d0n8FxZUqVh28syuv2ymGmTGvxxmYv
X-Received: by 2002:ad4:5b8e:0:b0:45e:727e:581 with SMTP id 14-20020ad45b8e000000b0045e727e0581mr30237100qvp.91.1653569078520;
        Thu, 26 May 2022 05:44:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTl9yJTk2JrKnbnArl1cV+yqaFHYBSE1pAtknvOk2bGcdp/tAN7eXyHvYiEKU3nIXbW6aFqgIXYPRGcEKbmNI=
X-Received: by 2002:ad4:5b8e:0:b0:45e:727e:581 with SMTP id
 14-20020ad45b8e000000b0045e727e0581mr30237079qvp.91.1653569078322; Thu, 26
 May 2022 05:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220525105922.2413991-1-eperezma@redhat.com> <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com> <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
In-Reply-To: <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 26 May 2022 14:44:02 +0200
Message-ID: <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 11:07 AM Stefano Garzarella <sgarzare@redhat.com> w=
rote:
>
> On Thu, May 26, 2022 at 10:57:03AM +0200, Eugenio Perez Martin wrote:
> >On Wed, May 25, 2022 at 1:23 PM Dawar, Gautam <gautam.dawar@amd.com> wro=
te:
> >>
> >> [AMD Official Use Only - General]
> >>
> >> -----Original Message-----
> >> From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >> Sent: Wednesday, May 25, 2022 4:29 PM
> >> To: Michael S. Tsirkin <mst@redhat.com>; netdev@vger.kernel.org; linux=
-kernel@vger.kernel.org; kvm@vger.kernel.org; virtualization@lists.linux-fo=
undation.org; Jason Wang <jasowang@redhat.com>
> >> Cc: Zhu Lingshan <lingshan.zhu@intel.com>; martinh@xilinx.com; Stefano=
 Garzarella <sgarzare@redhat.com>; ecree.xilinx@gmail.com; Eli Cohen <elic@=
nvidia.com>; Dan Carpenter <dan.carpenter@oracle.com>; Parav Pandit <parav@=
nvidia.com>; Wu Zongyong <wuzongyong@linux.alibaba.com>; dinang@xilinx.com;=
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>; Xie Yongji <xieyongji@=
bytedance.com>; Dawar, Gautam <gautam.dawar@amd.com>; lulu@redhat.com; mart=
inpo@xilinx.com; pabloc@xilinx.com; Longpeng <longpeng2@huawei.com>; Piotr.=
Uminski@intel.com; Kamde, Tanuj <tanuj.kamde@amd.com>; Si-Wei Liu <si-wei.l=
iu@oracle.com>; habetsm.xilinx@gmail.com; lvivier@redhat.com; Zhang Min <zh=
ang.min9@zte.com.cn>; hanand@xilinx.com
> >> Subject: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
> >>
> >> [CAUTION: External Email]
> >>
> >> Userland knows if it can stop the device or not by checking this featu=
re bit.
> >>
> >> It's only offered if the vdpa driver backend implements the stop() ope=
ration callback, and try to set it if the backend does not offer that callb=
ack is an error.
> >>
> >> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >> ---
> >>  drivers/vhost/vdpa.c             | 16 +++++++++++++++-
> >>  include/uapi/linux/vhost_types.h |  2 ++
> >>  2 files changed, 17 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index 1f1d1c4=
25573..32713db5831d 100644
> >> --- a/drivers/vhost/vdpa.c
> >> +++ b/drivers/vhost/vdpa.c
> >> @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vd=
pa *v,
> >>         return 0;
> >>  }
> >>
> >> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v) {
> >> +       struct vdpa_device *vdpa =3D v->vdpa;
> >> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> >> +
> >> +       return ops->stop;
> >> [GD>>] Would it be better to explicitly return a bool to match the ret=
urn type?
> >
> >I'm not sure about the kernel code style regarding that casting. Maybe
> >it's better to return !!ops->stop here. The macros likely and unlikely
> >do that.
>
> IIUC `ops->stop` is a function pointer, so what about
>
>      return ops->stop !=3D NULL;
>

I'm ok with any method proposed. Both three ways can be found in the
kernel so I think they are all valid (although the double negation is
from bool to integer in (0,1) set actually).

Maybe Jason or Michael (as maintainers) can state the preferred method here=
.

Generally I prefer explicit conversions, both signed and from/to
different types length. But I find conversion to bool to be simple
enough to be an exception to the rule. Same with void *. Let's see!

Sending v4 without this changed, waiting for answers.

Thanks!

