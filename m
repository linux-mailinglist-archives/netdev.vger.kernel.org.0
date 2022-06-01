Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44E7539D7A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349923AbiFAGx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349215AbiFAGx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E75F488AF
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 23:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654066436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWmZwzFVpRksBO4BOLojz9NUjcykvBgvkXhMFxoUwY0=;
        b=SUvqI2yud/hJezmgwK7tLL5n1BprhNBblapWRuco7yEV1EOZHnJXQq4jVGoyHL0D3Nv++D
        DZ+9lJ2/vRzG/Ysdket+MWYcgCFXSkofMxHofgDZLUsDeB+67e9bpZ7C/B62KpmsTKGPJs
        kaQrhiGKNJJoZOYpAgmRJTe1y1bxRWE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-d3i9non4Npe3qnjCRaoAVg-1; Wed, 01 Jun 2022 02:53:55 -0400
X-MC-Unique: d3i9non4Npe3qnjCRaoAVg-1
Received: by mail-qk1-f197.google.com with SMTP id i2-20020a05620a144200b006a3a8651de1so666993qkl.14
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 23:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MWmZwzFVpRksBO4BOLojz9NUjcykvBgvkXhMFxoUwY0=;
        b=iluoFGHOa2spl/FNF0IxhkCjpdPrLfS7zCp8PDW9TPNewqkpz7ebsyNRgmO3YLZFHh
         ST1WlZhaVs5LJoFOwPzhrMqivhMxlVsghX+YJUdhB51ifUdg5OoGqJFicckrm/Lk0wIR
         b9+4LvusQTSvdXlw0h3t/57RMbqUpwOmDRhldzRp+2hqDVlz4SmDLprdYfwAykwxkQAz
         xFP2Nd1vv09/cKRcF+4tuMa5XPW/pXgHLm2CvQz7HSeBdCDUreWfXr90outw0XoYRXVN
         8bWuQ74X42exZc15tp4k8T5uYWFogbmq08eHYCQfbKi4zWgk+OGtwdXB/HRwvX1DTi6G
         S6tA==
X-Gm-Message-State: AOAM530pgx2tgOmha3PbX/EcH+0EQqoxinZewEBhpR2pj1KzHceB4ghG
        lMl+XL4FI8hIwvzkKd2Zwt9k2ozZvnHuTT3vTlrRcsrmcrPS+ZzlO16XfnX59VMUVlIfvR/rJgO
        cga1fYno6d8ETXGTXACGluhRtOhFXTIR8
X-Received: by 2002:ac8:5ad0:0:b0:2f3:e37a:e768 with SMTP id d16-20020ac85ad0000000b002f3e37ae768mr50097546qtd.592.1654066435024;
        Tue, 31 May 2022 23:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfPCaM1Mb2ZZ2MmLFAvNODRxUeZ4/DdHaMTc0SpE9AKwfijcq0lYwmMmaTnm8BsgB2V8pYGab8IEx/HQXQOwg=
X-Received: by 2002:ac8:5ad0:0:b0:2f3:e37a:e768 with SMTP id
 d16-20020ac85ad0000000b002f3e37ae768mr50097535qtd.592.1654066434799; Tue, 31
 May 2022 23:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <20220526124338.36247-2-eperezma@redhat.com>
 <DM8PR12MB5400573627EEB71D774892C4ABDF9@DM8PR12MB5400.namprd12.prod.outlook.com>
In-Reply-To: <DM8PR12MB5400573627EEB71D774892C4ABDF9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jun 2022 08:53:18 +0200
Message-ID: <CAJaqyWfHLtcFokus3PB1K+19gcD1yeazox426Ur0LoMqOPy7FQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] vdpa: Add stop operation
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Parav Pandit <parav@nvidia.com>,
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 7:35 AM Eli Cohen <elic@nvidia.com> wrote:
>
> > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > Sent: Thursday, May 26, 2022 3:44 PM
> > To: Michael S. Tsirkin <mst@redhat.com>; kvm@vger.kernel.org; virtualiz=
ation@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> > Jason Wang <jasowang@redhat.com>; netdev@vger.kernel.org
> > Cc: martinh@xilinx.com; Stefano Garzarella <sgarzare@redhat.com>; marti=
npo@xilinx.com; lvivier@redhat.com; pabloc@xilinx.com;
> > Parav Pandit <parav@nvidia.com>; Eli Cohen <elic@nvidia.com>; Dan Carpe=
nter <dan.carpenter@oracle.com>; Xie Yongji
> > <xieyongji@bytedance.com>; Christophe JAILLET <christophe.jaillet@wanad=
oo.fr>; Zhang Min <zhang.min9@zte.com.cn>; Wu Zongyong
> > <wuzongyong@linux.alibaba.com>; lulu@redhat.com; Zhu Lingshan <lingshan=
.zhu@intel.com>; Piotr.Uminski@intel.com; Si-Wei Liu <si-
> > wei.liu@oracle.com>; ecree.xilinx@gmail.com; gautam.dawar@amd.com; habe=
tsm.xilinx@gmail.com; tanuj.kamde@amd.com;
> > hanand@xilinx.com; dinang@xilinx.com; Longpeng <longpeng2@huawei.com>
> > Subject: [PATCH v4 1/4] vdpa: Add stop operation
> >
> > This operation is optional: It it's not implemented, backend feature bi=
t
> > will not be exposed.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  include/linux/vdpa.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index 15af802d41c4..ddfebc4e1e01 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
> >   * @reset:                   Reset device
> >   *                           @vdev: vdpa device
> >   *                           Returns integer: success (0) or error (< =
0)
> > + * @stop:                    Stop or resume the device (optional, but =
it must
> > + *                           be implemented if require device stop)
> > + *                           @vdev: vdpa device
> > + *                           @stop: stop (true), not stop (false)
> > + *                           Returns integer: success (0) or error (< =
0)
>
> I assume after successful "stop" the device is guaranteed to stop process=
ing descriptors and after resume it may process descriptors?
> If that is so, I think it should be clear in the change log.
>

Yes.

It's better described in the changelog of vdpa sim change, maybe it's
better to move here.

Thanks!

> >   * @get_config_size:         Get the size of the configuration space i=
ncludes
> >   *                           fields that are conditional on feature bi=
ts.
> >   *                           @vdev: vdpa device
> > @@ -316,6 +321,7 @@ struct vdpa_config_ops {
> >       u8 (*get_status)(struct vdpa_device *vdev);
> >       void (*set_status)(struct vdpa_device *vdev, u8 status);
> >       int (*reset)(struct vdpa_device *vdev);
> > +     int (*stop)(struct vdpa_device *vdev, bool stop);
> >       size_t (*get_config_size)(struct vdpa_device *vdev);
> >       void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> >                          void *buf, unsigned int len);
> > --
> > 2.31.1
>

