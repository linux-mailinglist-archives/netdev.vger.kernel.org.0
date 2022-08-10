Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37058F2EB
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiHJTUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiHJTUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:20:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72B2A2873F
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660159205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mg9jfkgOJMJfQD+UBNUpUZRupW9q/o+qow5RgcfsokI=;
        b=c6/RojSa6dwXMDtxI3lm2Q1KHgizIbwElXwxCsUT3JDwvoohX1aq2GO9PMg2wr5W+FsSkA
        49jKxN3CDyhPUoPyTlPVKcq/p1GPtveextmwpg2+Lb3I8So8PzcRvG4qCRBUlAbQtJQnCb
        cvP1U1wqIwwAtutzqhfQzwfeJfN8xRc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-19-qPsI-bPxMqK1AoXziyHu9A-1; Wed, 10 Aug 2022 15:20:04 -0400
X-MC-Unique: qPsI-bPxMqK1AoXziyHu9A-1
Received: by mail-ed1-f70.google.com with SMTP id x20-20020a05640226d400b0043d50aadf3fso9919835edd.23
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=mg9jfkgOJMJfQD+UBNUpUZRupW9q/o+qow5RgcfsokI=;
        b=HpTpNBtDg3kX8Z0wOlIKm8PCO0lW4M54WzxZNG25j32xYPd4UJi9g+D9KBpCH0sBlJ
         NtFCCV6gElCQ+LjkgPva1mfSxLgLGphbhT3E6pqWb5dKZdpK2RB6boznbwW7UNnCVnWC
         qKeg8EiKKxILfSfI7va3k38CRBNeMZQxOB+i66S8RfTSIdhlN59VrsinUaSYE3hzN3kZ
         670R3/834rI3bu+MygW5yOtfrmMPOd7sQGNHN9dlLtm15ERWyr6mWyjqJ6Breuqr0vyk
         82FhGkwLwzqtfERw8/B+81hy5JFIZ/CPdRFgKvK+K9S8134DPDytXDAn1ydqJ2mRXMuj
         nQ/Q==
X-Gm-Message-State: ACgBeo18W0TjI2GkdEha9V9hB0AY/ZY9LrVaqNiH9vKzMyxQ9inJMVtK
        mfIAp5ngW40pFQom7+qTacjrisw/nu92yLtknKufM+GlArjWPxFEW9wef6NTCwuRn2RP0e4jBr6
        ZlEe+stwPeTMumyYP
X-Received: by 2002:a05:6402:11cb:b0:43c:c7a3:ff86 with SMTP id j11-20020a05640211cb00b0043cc7a3ff86mr28501467edw.383.1660159203364;
        Wed, 10 Aug 2022 12:20:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR513nGcOyEx/cZZy+oLMyNgfYHlcNGvOvBbmD5iBHW2tkSoDlCb8kDWjvUl/mnZVx0X2sxUhw==
X-Received: by 2002:a05:6402:11cb:b0:43c:c7a3:ff86 with SMTP id j11-20020a05640211cb00b0043cc7a3ff86mr28501439edw.383.1660159203147;
        Wed, 10 Aug 2022 12:20:03 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id d15-20020aa7d5cf000000b0043d6ece495asm8111225eds.55.2022.08.10.12.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 12:20:02 -0700 (PDT)
Date:   Wed, 10 Aug 2022 15:19:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 0/4] Implement vdpasim suspend operation
Message-ID: <20220810151907-mutt-send-email-mst@kernel.org>
References: <20220810171512.2343333-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220810171512.2343333-1-eperezma@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 07:15:08PM +0200, Eugenio Pérez wrote:
> Implement suspend operation for vdpa_sim devices, so vhost-vdpa will offer
> that backend feature and userspace can effectively suspend the device.
> 
> This is a must before getting virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
> 
> After a successful return of ioctl the device must not process more virtqueue
> descriptors. The device can answer to read or writes of config fields as if it
> were not suspended. In particular, writing to "queue_enable" with a value of 1
> will not make the device start processing virtqueue buffers.
> 
> In the future, we will provide features similar to
> VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.
> 
> Applied on top of [1] branch after removing the old commits.

Except, I can't really do this without invaliding all testing.
Can't you post an incremental patch?

> Comments are welcome.
> 
> v7:
> * Remove ioctl leftover argument and update doc accordingly.

> v6:
> * Remove the resume operation, making the ioctl simpler. We can always add
>   another ioctl for VM_STOP/VM_RESUME operation later.
> * s/stop/suspend/ to differentiate more from reset.
> * Clarify scope of the suspend operation.
> 
> v5:
> * s/not stop/resume/ in doc.
> 
> v4:
> * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> 
> v3:
> * s/VHOST_STOP/VHOST_VDPA_STOP/
> * Add documentation and requirements of the ioctl above its definition.
> 
> v2:
> * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> * Fix obtaining of stop ioctl arg (it was not obtained but written).
> * Add stop to vdpa_sim_blk.
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> 
> Eugenio Pérez (4):
>   vdpa: Add suspend operation
>   vhost-vdpa: introduce SUSPEND backend feature bit
>   vhost-vdpa: uAPI to suspend the device
>   vdpa_sim: Implement suspend vdpa op
> 
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 14 +++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>  drivers/vhost/vdpa.c                 | 35 +++++++++++++++++++++++++++-
>  include/linux/vdpa.h                 |  4 ++++
>  include/uapi/linux/vhost.h           |  9 +++++++
>  include/uapi/linux/vhost_types.h     |  2 ++
>  8 files changed, 70 insertions(+), 1 deletion(-)
> 
> -- 
> 2.31.1
> 

