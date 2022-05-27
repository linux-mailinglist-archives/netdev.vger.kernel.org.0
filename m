Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8153578F
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 04:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiE0C04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 22:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiE0C0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 22:26:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AB7DE277A
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 19:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653618410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oaDAshEcGYeYhJ5+Zo99OPfgNFs1k3b7zVlzbxHYNl0=;
        b=MsoZxVsdQq/zRH23U6ED0gdtz1Yg9cjvDnfEgPZDQ9N4Pxa5/ps8AN/SXeYjIzQ8J3gkWe
        P41sW5r71Ndz4fOchno3wy7tBk1UAVTCV75BTmjC3vn/FZRYi+5Yfb+qPfhvbKGVcig60P
        iUfbLulsOda9qOalJHCsQ+ZwzDfk68o=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-D3yyiHIsNpu8NoUkeahycQ-1; Thu, 26 May 2022 22:26:49 -0400
X-MC-Unique: D3yyiHIsNpu8NoUkeahycQ-1
Received: by mail-lf1-f71.google.com with SMTP id bu3-20020a056512168300b0047791fb1d68so1331006lfb.23
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 19:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oaDAshEcGYeYhJ5+Zo99OPfgNFs1k3b7zVlzbxHYNl0=;
        b=JsT3VowTWR02MQ8mxtiuL6V6fjWDClhzLQDiwufBMegVBRo34Qd5JUCHwaQP8XjC9/
         un8fRV6KclmAoeiDYgLXwvyAZW56+XDRdXg7WLq9xwNuO7aYBqMClI8J4IsbspzRFHjO
         M9Iu3XjfdwLReaIenl9r49zq14o8tn2G513h6wVdX8P1ePflqvuZEZVr17ThoaRC1z8u
         uRWzZF4I1PNP6l5r6STJDPjpcsSl/Pp/nMawdiy8dsdRa1vYph6LdSV77kxq4A0O6SFo
         EqjKecvptK4zJeVLZLrYE59YwqNFRh/z9H6nTv4SROFQAmpL/qHV0Sh7ICGT1uGBhOBt
         BxJg==
X-Gm-Message-State: AOAM530tMsyQuwr9SwcqEq2e3L5njfOZxlMnh5z5XVs2hyx0WTb6PvGw
        iWGvEUIY6cgpQep/6enVUSqcN7Q3AWiASRwv3OHfhINVcCwltKpZpJvkAgIzaJmfp5P9qC3xMjp
        b6rvebANeHdiosCVcbggHovAuEH/P62/H
X-Received: by 2002:a2e:954c:0:b0:253:d9bf:9f55 with SMTP id t12-20020a2e954c000000b00253d9bf9f55mr21308471ljh.300.1653618407867;
        Thu, 26 May 2022 19:26:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHcqEOz1xk1ptv4/JAwcVxyXOZtbrjI3QyKwE3Rw+KFfhLBm5gZOZJQQUeuqyIULlx21HHjnfaD0MAV67KrFc=
X-Received: by 2002:a2e:954c:0:b0:253:d9bf:9f55 with SMTP id
 t12-20020a2e954c000000b00253d9bf9f55mr21308435ljh.300.1653618407570; Thu, 26
 May 2022 19:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 27 May 2022 10:26:35 +0800
Message-ID: <CACGkMEu1YenjBHAssP=FvKX6WxDQ5Aa50r-BsnkfR4zqNTk6hg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 8:54 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > Sent: Thursday, May 26, 2022 8:44 AM
>
> > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> >
> > that backend feature and userspace can effectively stop the device.
> >
> >
> >
> > This is a must before get virtqueue indexes (base) for live migration,
> >
> > since the device could modify them after userland gets them. There are
> >
> > individual ways to perform that action for some devices
> >
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there
> > was no
> >
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> >
> >
> > After the return of ioctl with stop !=3D 0, the device MUST finish any
> >
> > pending operations like in flight requests. It must also preserve all
> >
> > the necessary state (the virtqueue vring base plus the possible device
> >
> > specific states) that is required for restoring in the future. The
> >
> > device must not change its configuration after that point.
> >
> >
> >
> > After the return of ioctl with stop =3D=3D 0, the device can continue
> >
> > processing buffers as long as typical conditions are met (vq is enabled=
,
> >
> > DRIVER_OK status bit is enabled, etc).
>
> Just to be clear, we are adding vdpa level new ioctl() that doesn=E2=80=
=99t map to any mechanism in the virtio spec.

We try to provide forward compatibility to VIRTIO_CONFIG_S_STOP. That
means it is expected to implement at least a subset of
VIRTIO_CONFIG_S_STOP.

>
> Why can't we use this ioctl() to indicate driver to start/stop the device=
 instead of driving it through the driver_ok?

So the idea is to add capability that does not exist in the spec. Then
came the stop/resume which can't be done via DRIVER_OK. I think we
should only allow the stop/resume to succeed after DRIVER_OK is set.

> This is in the context of other discussion we had in the LM series.

Do you see any issue that blocks the live migration?

Thanks

