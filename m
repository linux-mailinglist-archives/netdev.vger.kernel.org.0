Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2F650FA64
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348824AbiDZK2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348840AbiDZK2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:28:08 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21565DE64;
        Tue, 26 Apr 2022 03:01:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0VBLW6ip_1650967268;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VBLW6ip_1650967268)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Apr 2022 18:01:09 +0800
Message-ID: <1650967148.2873914-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 00/32] virtio pci support VIRTIO_F_RING_RESET (refactor vring)
Date:   Tue, 26 Apr 2022 17:59:08 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220426055423-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220426055423-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 05:55:41 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Apr 06, 2022 at 11:43:14AM +0800, Xuan Zhuo wrote:
> > The virtio spec already supports the virtio queue reset function. This patch set
> > is to add this function to the kernel. The relevant virtio spec information is
> > here:
> >
> >     https://github.com/oasis-tcs/virtio-spec/issues/124
> >
> > Also regarding MMIO support for queue reset, I plan to support it after this
> > patch is passed.
>
> Regarding the spec, there's now an issue proposing
> some changes to the interface. What do you think about that
> proposal? Could you respond on that thread on the virtio TC mailing list?

I have read that thread. And also asked some questions.  I will follow that
thread.

Grateful.

>
>
> > This patch set implements the refactoring of vring. Finally, the
> > virtuque_resize() interface is provided based on the reset function of the
> > transport layer.
> >
> > Test environment:
> >     Host: 4.19.91
> >     Qemu: QEMU emulator version 6.2.50 (with vq reset support)
> >     Test Cmd:  ethtool -G eth1 rx $1 tx $2; ethtool -g eth1
> >
> >     The default is split mode, modify Qemu virtio-net to add PACKED feature to test
> >     packed mode.
> >
> > Qemu code:
> >     https://github.com/fengidri/qemu/compare/89f3bfa3265554d1d591ee4d7f1197b6e3397e84...master
> >
> > In order to simplify the review of this patch set, the function of reusing
> > the old buffers after resize will be introduced in subsequent patch sets.
> >
> > Please review. Thanks.
> >
> > v9:
> >   1. Provide a virtqueue_resize() interface directly
> >   2. A patch set including vring resize, virtio pci reset, virtio-net resize
> >   3. No more separate structs
> >
> > v8:
> >   1. Provide a virtqueue_reset() interface directly
> >   2. Split the two patch sets, this is the first part
> >   3. Add independent allocation helper for allocating state, extra
> >
> > v7:
> >   1. fix #6 subject typo
> >   2. fix #6 ring_size_in_bytes is uninitialized
> >   3. check by: make W=12
> >
> > v6:
> >   1. virtio_pci: use synchronize_irq(irq) to sync the irq callbacks
> >   2. Introduce virtqueue_reset_vring() to implement the reset of vring during
> >      the reset process. May use the old vring if num of the vq not change.
> >   3. find_vqs() support sizes to special the max size of each vq
> >
> > v5:
> >   1. add virtio-net support set_ringparam
> >
> > v4:
> >   1. just the code of virtio, without virtio-net
> >   2. Performing reset on a queue is divided into these steps:
> >     1. reset_vq: reset one vq
> >     2. recycle the buffer from vq by virtqueue_detach_unused_buf()
> >     3. release the ring of the vq by vring_release_virtqueue()
> >     4. enable_reset_vq: re-enable the reset queue
> >   3. Simplify the parameters of enable_reset_vq()
> >   4. add container structures for virtio_pci_common_cfg
> >
> > v3:
> >   1. keep vq, irq unreleased
> >
> > Xuan Zhuo (32):
> >   virtio: add helper virtqueue_get_vring_max_size()
> >   virtio: struct virtio_config_ops add callbacks for queue_reset
> >   virtio_ring: update the document of the virtqueue_detach_unused_buf
> >     for queue reset
> >   virtio_ring: remove the arg vq of vring_alloc_desc_extra()
> >   virtio_ring: extract the logic of freeing vring
> >   virtio_ring: split: extract the logic of alloc queue
> >   virtio_ring: split: extract the logic of alloc state and extra
> >   virtio_ring: split: extract the logic of attach vring
> >   virtio_ring: split: extract the logic of vq init
> >   virtio_ring: split: introduce virtqueue_reinit_split()
> >   virtio_ring: split: introduce virtqueue_resize_split()
> >   virtio_ring: packed: extract the logic of alloc queue
> >   virtio_ring: packed: extract the logic of alloc state and extra
> >   virtio_ring: packed: extract the logic of attach vring
> >   virtio_ring: packed: extract the logic of vq init
> >   virtio_ring: packed: introduce virtqueue_reinit_packed()
> >   virtio_ring: packed: introduce virtqueue_resize_packed()
> >   virtio_ring: introduce virtqueue_resize()
> >   virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
> >   virtio: queue_reset: add VIRTIO_F_RING_RESET
> >   virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
> >     option functions
> >   virtio_pci: queue_reset: extract the logic of active vq for modern pci
> >   virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
> >   virtio: find_vqs() add arg sizes
> >   virtio_pci: support the arg sizes of find_vqs()
> >   virtio_mmio: support the arg sizes of find_vqs()
> >   virtio: add helper virtio_find_vqs_ctx_size()
> >   virtio_net: set the default max ring size by find_vqs()
> >   virtio_net: get ringparam by virtqueue_get_vring_max_size()
> >   virtio_net: split free_unused_bufs()
> >   virtio_net: support rx/tx queue resize
> >   virtio_net: support set_ringparam
> >
> >  arch/um/drivers/virtio_uml.c             |   3 +-
> >  drivers/net/virtio_net.c                 | 219 +++++++-
> >  drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +
> >  drivers/remoteproc/remoteproc_virtio.c   |   3 +
> >  drivers/s390/virtio/virtio_ccw.c         |   4 +
> >  drivers/virtio/virtio_mmio.c             |  11 +-
> >  drivers/virtio/virtio_pci_common.c       |  28 +-
> >  drivers/virtio/virtio_pci_common.h       |   3 +-
> >  drivers/virtio/virtio_pci_legacy.c       |   8 +-
> >  drivers/virtio/virtio_pci_modern.c       | 149 +++++-
> >  drivers/virtio/virtio_pci_modern_dev.c   |  36 ++
> >  drivers/virtio/virtio_ring.c             | 626 ++++++++++++++++++-----
> >  drivers/virtio/virtio_vdpa.c             |   3 +
> >  include/linux/virtio.h                   |   6 +
> >  include/linux/virtio_config.h            |  38 +-
> >  include/linux/virtio_pci_modern.h        |   2 +
> >  include/uapi/linux/virtio_config.h       |   7 +-
> >  include/uapi/linux/virtio_pci.h          |  14 +
> >  18 files changed, 964 insertions(+), 199 deletions(-)
> >
> > --
> > 2.31.0
>
