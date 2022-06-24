Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BED5593E0
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiFXHA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiFXHAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C94E96926C
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656054022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wmJan+T8jkPhz0Jx0HS+GqAkBjBvRA/O1PfxaSokA/k=;
        b=NyHCQyoPKW4PTip4n4FFTTjsk+AkhOupO2tpMY4Np7kS3dVm+rGrJMTqGiWvoc+wIMUD8K
        9jla6Je3Ev5F61bllpvv44BLwhWarkuUtpay2ETRzAAaQtYmVS1gJxal4E2dfqnfEMJo5l
        iRoG/ylAU3LiXb0X3e0e57YW9NnELMQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-5hGPKrTHM1WTKkdaLmqVbQ-1; Fri, 24 Jun 2022 03:00:21 -0400
X-MC-Unique: 5hGPKrTHM1WTKkdaLmqVbQ-1
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a05640250d000b00435bab1a7b4so1215634edb.10
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wmJan+T8jkPhz0Jx0HS+GqAkBjBvRA/O1PfxaSokA/k=;
        b=dALXx24G6oCC97XlxeN9Fi1vH/dgurjVLbol5GST+ROWIF8lT1ySti2gViIIBV1Eov
         amGisPjO7Nu9UlHiblsH+PNpu5p3Y1cH3DlRofCxh/VWjsCOdoQXBub3YZK7JIeti9uF
         KOhWdn8PiS719gEk7QNm9K5Qd1ufP7qP1BGtafHcvACmz81hd2kHlRCVo3Ivszu4qCHH
         rG7ktvn+hIfLsPqoTu6dM0IGPlocLdTCkN6zswI48BvS9z5SH68wIcyrRUCVtZ3YcQob
         0pIpCDwR8KypSPWt3kmxIzQgbiw81hh8NPYYIJH9r8LTq9o2ll4Hg3ogm9qrOYl6vF40
         05Xg==
X-Gm-Message-State: AJIora85EE6c74DNBkMSf+KWclwc+5u5js5O+Zlq+s5PKIPSyQs0YHgV
        BXdmlG9LfymrN1TQz+zxxCR29xCgVmY1LVIX7IHrnH9pRNjImnAWKgwAfyeUfzEAdp0h4ZDcp+C
        rcW+wbv2DyTDetsqL
X-Received: by 2002:a17:906:51de:b0:722:e9a7:83de with SMTP id v30-20020a17090651de00b00722e9a783demr11981772ejk.130.1656054020053;
        Fri, 24 Jun 2022 00:00:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vuZPrYT6oN35kbqkreO6xutvaC1wAQFjbV9H/fxZNSgI7sAYj2ZRT+vtMwhuJY/8e+TdPqZg==
X-Received: by 2002:a17:906:51de:b0:722:e9a7:83de with SMTP id v30-20020a17090651de00b00722e9a783demr11981742ejk.130.1656054019815;
        Fri, 24 Jun 2022 00:00:19 -0700 (PDT)
Received: from redhat.com ([2.55.188.216])
        by smtp.gmail.com with ESMTPSA id n22-20020a1709067b5600b00722ea7a7febsm576805ejo.194.2022.06.24.00.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 00:00:19 -0700 (PDT)
Date:   Fri, 24 Jun 2022 03:00:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: Re: [PATCH v10 00/41] virtio pci support VIRTIO_F_RING_RESET
Message-ID: <20220624025954-mutt-send-email-mst@kernel.org>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 10:55:40AM +0800, Xuan Zhuo wrote:
> The virtio spec already supports the virtio queue reset function. This patch set
> is to add this function to the kernel. The relevant virtio spec information is
> here:
> 
>     https://github.com/oasis-tcs/virtio-spec/issues/124
>     https://github.com/oasis-tcs/virtio-spec/issues/139
> 
> Also regarding MMIO support for queue reset, I plan to support it after this
> patch is passed.
> 
> This patch set implements the refactoring of vring. Finally, the
> virtuque_resize() interface is provided based on the reset function of the
> transport layer.
> 
> Test environment:
>     Host: 4.19.91
>     Qemu: QEMU emulator version 6.2.50 (with vq reset support)
>     Test Cmd:  ethtool -G eth1 rx $1 tx $2; ethtool -g eth1
> 
>     The default is split mode, modify Qemu virtio-net to add PACKED feature to test
>     packed mode.
> 
> Qemu code:
>     https://github.com/fengidri/qemu/compare/89f3bfa3265554d1d591ee4d7f1197b6e3397e84...master


Pls rebase on top of my latest tree, there are some conflicts.

> In order to simplify the review of this patch set, the function of reusing
> the old buffers after resize will be introduced in subsequent patch sets.
> 
> Please review. Thanks.
> 
> v10:
>   1. on top of the harden vring IRQ
>   2. factor out split and packed from struct vring_virtqueue
>   3. some suggest from @Jason Wang
> 
> v9:
>   1. Provide a virtqueue_resize() interface directly
>   2. A patch set including vring resize, virtio pci reset, virtio-net resize
>   3. No more separate structs
> 
> v8:
>   1. Provide a virtqueue_reset() interface directly
>   2. Split the two patch sets, this is the first part
>   3. Add independent allocation helper for allocating state, extra
> 
> v7:
>   1. fix #6 subject typo
>   2. fix #6 ring_size_in_bytes is uninitialized
>   3. check by: make W=12
> 
> v6:
>   1. virtio_pci: use synchronize_irq(irq) to sync the irq callbacks
>   2. Introduce virtqueue_reset_vring() to implement the reset of vring during
>      the reset process. May use the old vring if num of the vq not change.
>   3. find_vqs() support sizes to special the max size of each vq
> 
> v5:
>   1. add virtio-net support set_ringparam
> 
> v4:
>   1. just the code of virtio, without virtio-net
>   2. Performing reset on a queue is divided into these steps:
>     1. reset_vq: reset one vq
>     2. recycle the buffer from vq by virtqueue_detach_unused_buf()
>     3. release the ring of the vq by vring_release_virtqueue()
>     4. enable_reset_vq: re-enable the reset queue
>   3. Simplify the parameters of enable_reset_vq()
>   4. add container structures for virtio_pci_common_cfg
> 
> v3:
>   1. keep vq, irq unreleased
> 
> *** BLURB HERE ***
> 
> Xuan Zhuo (41):
>   remoteproc: rename len of rpoc_vring to num
>   virtio: add helper virtqueue_get_vring_max_size()
>   virtio: struct virtio_config_ops add callbacks for queue_reset
>   virtio_ring: update the document of the virtqueue_detach_unused_buf
>     for queue reset
>   virtio_ring: remove the arg vq of vring_alloc_desc_extra()
>   virtio_ring: extract the logic of freeing vring
>   virtio_ring: split vring_virtqueue
>   virtio_ring: introduce virtqueue_init()
>   virtio_ring: split: introduce vring_free_split()
>   virtio_ring: split: extract the logic of alloc queue
>   virtio_ring: split: extract the logic of alloc state and extra
>   virtio_ring: split: extract the logic of attach vring
>   virtio_ring: split: extract the logic of vring init
>   virtio_ring: split: introduce virtqueue_reinit_split()
>   virtio_ring: split: reserve vring_align, may_reduce_num
>   virtio_ring: split: introduce virtqueue_resize_split()
>   virtio_ring: packed: introduce vring_free_packed
>   virtio_ring: packed: extract the logic of alloc queue
>   virtio_ring: packed: extract the logic of alloc state and extra
>   virtio_ring: packed: extract the logic of attach vring
>   virtio_ring: packed: extract the logic of vring init
>   virtio_ring: packed: introduce virtqueue_reinit_packed()
>   virtio_ring: packed: introduce virtqueue_resize_packed()
>   virtio_ring: introduce virtqueue_resize()
>   virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
>   virtio: queue_reset: add VIRTIO_F_RING_RESET
>   virtio: allow to unbreak/break virtqueue individually
>   virtio_pci: update struct virtio_pci_common_cfg
>   virtio_pci: introduce helper to get/set queue reset
>   virtio_pci: extract the logic of active vq for modern pci
>   virtio_pci: support VIRTIO_F_RING_RESET
>   virtio: find_vqs() add arg sizes
>   virtio_pci: support the arg sizes of find_vqs()
>   virtio_mmio: support the arg sizes of find_vqs()
>   virtio: add helper virtio_find_vqs_ctx_size()
>   virtio_net: set the default max ring size by find_vqs()
>   virtio_net: get ringparam by virtqueue_get_vring_max_size()
>   virtio_net: split free_unused_bufs()
>   virtio_net: support rx queue resize
>   virtio_net: support tx queue resize
>   virtio_net: support set_ringparam
> 
>  arch/um/drivers/virtio_uml.c             |   3 +-
>  drivers/net/virtio_net.c                 | 209 +++++-
>  drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +
>  drivers/remoteproc/remoteproc_core.c     |   4 +-
>  drivers/remoteproc/remoteproc_virtio.c   |  13 +-
>  drivers/s390/virtio/virtio_ccw.c         |   4 +
>  drivers/virtio/virtio_mmio.c             |  11 +-
>  drivers/virtio/virtio_pci_common.c       |  32 +-
>  drivers/virtio/virtio_pci_common.h       |   3 +-
>  drivers/virtio/virtio_pci_legacy.c       |   8 +-
>  drivers/virtio/virtio_pci_modern.c       | 157 ++++-
>  drivers/virtio/virtio_pci_modern_dev.c   |  39 ++
>  drivers/virtio/virtio_ring.c             | 794 +++++++++++++++++------
>  drivers/virtio/virtio_vdpa.c             |   3 +
>  include/linux/remoteproc.h               |   4 +-
>  include/linux/virtio.h                   |   9 +
>  include/linux/virtio_config.h            |  38 +-
>  include/linux/virtio_pci_modern.h        |   2 +
>  include/uapi/linux/virtio_config.h       |   7 +-
>  include/uapi/linux/virtio_pci.h          |  14 +
>  20 files changed, 1063 insertions(+), 294 deletions(-)
> 
> --
> 2.31.0

