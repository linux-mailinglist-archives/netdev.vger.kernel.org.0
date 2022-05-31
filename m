Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1023F538D9F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245135AbiEaJX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiEaJX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16BE585ECC
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653989006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R1t1NBmkNMBO5DYdEINGWFlHVzMhXZpx3lk8YtT0vEg=;
        b=W6wc+5ouBAahyhZbpUPawAdMewMw2yGzFt6g41+AbVnREWipdHvpP7tGGLzDbhAxjXd4cU
        /wanc2jL5QP0MdOwgnUyM/78HjtcUWNlcvpKjqd61o2+iZ3vjoy7C4eJLFfua9nbne4/zA
        YQ4AasMqpHBVEBDnXb4MvgBh18vf4Xg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-6U0tVZW4PciEOrwUVL-MMQ-1; Tue, 31 May 2022 05:23:24 -0400
X-MC-Unique: 6U0tVZW4PciEOrwUVL-MMQ-1
Received: by mail-wm1-f70.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso1154594wms.0
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=R1t1NBmkNMBO5DYdEINGWFlHVzMhXZpx3lk8YtT0vEg=;
        b=qR5jS1dJYD9raDwHznCRoxPg1CZSW2PqnZSbEms9yz0s5+jKxQwL7PkHbahtzHsYgz
         sV/Khuy6Oy7orHNzGMQAo5tZ25kmFA577kZtxXgpfStwBQJC3a1Mhbm2mdwHnR/DOAnt
         DrYQRoZvA/gtA8L1Ov44pnnY7OuwNHcBJleFLGz2eItLZw2EIFRBk9Cw75QMCKwbOkU1
         pGIMwCJqc6u/zTfw4FoHZICCNZX2spx1KL7q/HMWyJfvM/uEs25IKY7ociY/80pcvJeA
         U2SnNkt2ufbfvw7CcmHomOXBy4d2ifXvXB7+HLQcWRIPLY1IC0jQGMJWBw35RXFSrDcE
         RpoQ==
X-Gm-Message-State: AOAM532RFdZxm0SXCSn58t75FDhp2fVO5A0bzNIWNBfpJ2WHzjSrurop
        Sk4Wy/GUr7Ntp7A9iBqG+Msyf8fCzWBe8RAg9j4KNuNtExGpLS/t0ibVKRRgOthSKsUvGkpbbeA
        MFmtq1BKC9ypPtkq/
X-Received: by 2002:adf:fb0d:0:b0:20d:97e:17ce with SMTP id c13-20020adffb0d000000b0020d097e17cemr50794559wrr.585.1653989003673;
        Tue, 31 May 2022 02:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzXciEmGxzFbd78RU5NlgInASiXlfG+r9fWr3h5yZzU+8WJoDJl/m3AngyKgTZnA+DlsQGmQ==
X-Received: by 2002:adf:fb0d:0:b0:20d:97e:17ce with SMTP id c13-20020adffb0d000000b0020d097e17cemr50794524wrr.585.1653989003358;
        Tue, 31 May 2022 02:23:23 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id k66-20020a1ca145000000b0039c15861001sm1605939wme.21.2022.05.31.02.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 02:23:22 -0700 (PDT)
Date:   Tue, 31 May 2022 05:23:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Cindy Lu <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>, habetsm.xilinx@gmail.com,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Message-ID: <20220531052240-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220531014108-mutt-send-email-mst@kernel.org>
 <CAJaqyWfRSD6xiS8DROkPvjJ4Y4dotOPWqUzaQeM3X=q_XgABdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWfRSD6xiS8DROkPvjJ4Y4dotOPWqUzaQeM3X=q_XgABdw@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 09:13:38AM +0200, Eugenio Perez Martin wrote:
> On Tue, May 31, 2022 at 7:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, May 26, 2022 at 02:43:34PM +0200, Eugenio Pérez wrote:
> > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > > that backend feature and userspace can effectively stop the device.
> > >
> > > This is a must before get virtqueue indexes (base) for live migration,
> > > since the device could modify them after userland gets them. There are
> > > individual ways to perform that action for some devices
> > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > > way to perform it for any vhost device (and, in particular, vhost-vdpa).
> > >
> > > After the return of ioctl with stop != 0, the device MUST finish any
> > > pending operations like in flight requests. It must also preserve all
> > > the necessary state (the virtqueue vring base plus the possible device
> > > specific states) that is required for restoring in the future. The
> > > device must not change its configuration after that point.
> > >
> > > After the return of ioctl with stop == 0, the device can continue
> > > processing buffers as long as typical conditions are met (vq is enabled,
> > > DRIVER_OK status bit is enabled, etc).
> > >
> > > In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_FD
> > > so the device can save pending operations.
> > >
> > > Comments are welcome.
> >
> >
> > So given this is just for simulator and affects UAPI I think it's fine
> > to make it wait for the next merge window, until there's a consensus.
> > Right?
> >
> 
> While the change is only implemented in the simulator at this moment,
> it's just the very last missing piece in the kernel to implement
> complete live migration for net devices with cvq :). All vendor
> drivers can implement this call with current code, just a little bit
> of plumbing is needed. And it was accepted in previous meetings.
> 
> If it proves it works for every configuration (nested, etc), the
> implementation can forward the call to the admin vq for example. At
> the moment, it follows the proposed stop status bit sematic to stop
> the device, which POC has been tested in these circumstances.
> 
> Thanks!

Oh absolutely, but I am guessing this plumbing won't
be ready for this merge window.

> > > v4:
> > > * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> > >
> > > v3:
> > > * s/VHOST_STOP/VHOST_VDPA_STOP/
> > > * Add documentation and requirements of the ioctl above its definition.
> > >
> > > v2:
> > > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > > * Add stop to vdpa_sim_blk.
> > >
> > > Eugenio Pérez (4):
> > >   vdpa: Add stop operation
> > >   vhost-vdpa: introduce STOP backend feature bit
> > >   vhost-vdpa: uAPI to stop the device
> > >   vdpa_sim: Implement stop vdpa op
> > >
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> > >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> > >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> > >  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
> > >  include/linux/vdpa.h                 |  6 +++++
> > >  include/uapi/linux/vhost.h           | 14 ++++++++++++
> > >  include/uapi/linux/vhost_types.h     |  2 ++
> > >  8 files changed, 83 insertions(+), 1 deletion(-)
> > >
> > > --
> > > 2.31.1
> > >
> >

