Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0E750FA44
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348653AbiDZKZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349115AbiDZKYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A45F7DA98
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650966961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bKv/ULkJ/wp3hIqk7Hk8ciyskY/Ggu219LeUKhk8ymM=;
        b=gMZ/qAfe23PBBDS/SD9QN9//hCLloij1nC+LWB0DznNn5U5SwWjrTvbOCYUBUN0aZszSo+
        /kE4/h48pbbbRRJ203VpNKUSppeHBdZKOCUE/SKsv1c1rSvsKJ/w8RnWD1V7KT9C6rZSrN
        bcbYKfwOb9CQUohiuaE3D4Z94GXXPSg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-WE-rh_qUPomteHMxaiV-VQ-1; Tue, 26 Apr 2022 05:55:51 -0400
X-MC-Unique: WE-rh_qUPomteHMxaiV-VQ-1
Received: by mail-wr1-f71.google.com with SMTP id d28-20020adf9b9c000000b0020ad4a50e14so1911207wrc.3
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bKv/ULkJ/wp3hIqk7Hk8ciyskY/Ggu219LeUKhk8ymM=;
        b=eDefdkh1oV8DrWBeTtnqRTIPTbSJCCoYLFMSf/PT9sdclmwfr2I0oWqT1wkJ6Qjjpb
         CPuyggyEjOgmO/bBb8+1X4R0dfYrjhQxFUV9QN7INklZcwBeYlEHnFCRAfM1SHb58LS8
         mionbNn099xs6e2dg19WL8ule3NM1EtSykVZTuyLi9x7x8BVXBJ/PpzcJ82gg1IHZVjy
         HIZL9o/R5AOrev4lAkG1QYBy5mB2Fm4YbUcjoGN+obNxRLr9jkAo/X+cyXEA3P1ekvTW
         T8AlaFSXQfVz15oYAXGb6OTIt38eslP/zlGDinuJm7QqJvNJo/8pZ3qC8WSGc2/NUDpJ
         VPcw==
X-Gm-Message-State: AOAM533v0hA/E9vsbquKmqO+oUd6p0TM61sAOkzwM/BTmmt6gJTjvEC3
        h+jUiJ4PlQIaAS4Cb4SzzrgQJTg/E94aUqlAZqKSMmtYEfyXZ8biM46c2qyQvTZuQiyk+vtpXxe
        /iVdDdZFhSynyFXWs
X-Received: by 2002:a05:600c:3587:b0:393:ec32:d84e with SMTP id p7-20020a05600c358700b00393ec32d84emr7912287wmq.92.1650966950534;
        Tue, 26 Apr 2022 02:55:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8XKSGFc+0NUl8DKUeaivozN8xsVuR8eLs8RZ1+VRkX8o21nZkof7/x4aaezYJYxtUVEyOAg==
X-Received: by 2002:a05:600c:3587:b0:393:ec32:d84e with SMTP id p7-20020a05600c358700b00393ec32d84emr7912255wmq.92.1650966950289;
        Tue, 26 Apr 2022 02:55:50 -0700 (PDT)
Received: from redhat.com ([2.53.22.137])
        by smtp.gmail.com with ESMTPSA id 204-20020a1c02d5000000b003928c42d02asm13036414wmc.23.2022.04.26.02.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 02:55:49 -0700 (PDT)
Date:   Tue, 26 Apr 2022 05:55:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v9 00/32] virtio pci support VIRTIO_F_RING_RESET
 (refactor vring)
Message-ID: <20220426055423-mutt-send-email-mst@kernel.org>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 11:43:14AM +0800, Xuan Zhuo wrote:
> The virtio spec already supports the virtio queue reset function. This patch set
> is to add this function to the kernel. The relevant virtio spec information is
> here:
> 
>     https://github.com/oasis-tcs/virtio-spec/issues/124
> 
> Also regarding MMIO support for queue reset, I plan to support it after this
> patch is passed.

Regarding the spec, there's now an issue proposing
some changes to the interface. What do you think about that
proposal? Could you respond on that thread on the virtio TC mailing list?


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
> 
> In order to simplify the review of this patch set, the function of reusing
> the old buffers after resize will be introduced in subsequent patch sets.
> 
> Please review. Thanks.
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
> Xuan Zhuo (32):
>   virtio: add helper virtqueue_get_vring_max_size()
>   virtio: struct virtio_config_ops add callbacks for queue_reset
>   virtio_ring: update the document of the virtqueue_detach_unused_buf
>     for queue reset
>   virtio_ring: remove the arg vq of vring_alloc_desc_extra()
>   virtio_ring: extract the logic of freeing vring
>   virtio_ring: split: extract the logic of alloc queue
>   virtio_ring: split: extract the logic of alloc state and extra
>   virtio_ring: split: extract the logic of attach vring
>   virtio_ring: split: extract the logic of vq init
>   virtio_ring: split: introduce virtqueue_reinit_split()
>   virtio_ring: split: introduce virtqueue_resize_split()
>   virtio_ring: packed: extract the logic of alloc queue
>   virtio_ring: packed: extract the logic of alloc state and extra
>   virtio_ring: packed: extract the logic of attach vring
>   virtio_ring: packed: extract the logic of vq init
>   virtio_ring: packed: introduce virtqueue_reinit_packed()
>   virtio_ring: packed: introduce virtqueue_resize_packed()
>   virtio_ring: introduce virtqueue_resize()
>   virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
>   virtio: queue_reset: add VIRTIO_F_RING_RESET
>   virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
>     option functions
>   virtio_pci: queue_reset: extract the logic of active vq for modern pci
>   virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
>   virtio: find_vqs() add arg sizes
>   virtio_pci: support the arg sizes of find_vqs()
>   virtio_mmio: support the arg sizes of find_vqs()
>   virtio: add helper virtio_find_vqs_ctx_size()
>   virtio_net: set the default max ring size by find_vqs()
>   virtio_net: get ringparam by virtqueue_get_vring_max_size()
>   virtio_net: split free_unused_bufs()
>   virtio_net: support rx/tx queue resize
>   virtio_net: support set_ringparam
> 
>  arch/um/drivers/virtio_uml.c             |   3 +-
>  drivers/net/virtio_net.c                 | 219 +++++++-
>  drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +
>  drivers/remoteproc/remoteproc_virtio.c   |   3 +
>  drivers/s390/virtio/virtio_ccw.c         |   4 +
>  drivers/virtio/virtio_mmio.c             |  11 +-
>  drivers/virtio/virtio_pci_common.c       |  28 +-
>  drivers/virtio/virtio_pci_common.h       |   3 +-
>  drivers/virtio/virtio_pci_legacy.c       |   8 +-
>  drivers/virtio/virtio_pci_modern.c       | 149 +++++-
>  drivers/virtio/virtio_pci_modern_dev.c   |  36 ++
>  drivers/virtio/virtio_ring.c             | 626 ++++++++++++++++++-----
>  drivers/virtio/virtio_vdpa.c             |   3 +
>  include/linux/virtio.h                   |   6 +
>  include/linux/virtio_config.h            |  38 +-
>  include/linux/virtio_pci_modern.h        |   2 +
>  include/uapi/linux/virtio_config.h       |   7 +-
>  include/uapi/linux/virtio_pci.h          |  14 +
>  18 files changed, 964 insertions(+), 199 deletions(-)
> 
> --
> 2.31.0

