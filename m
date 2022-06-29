Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9877555F739
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiF2G5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiF2G5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:57:08 -0400
Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3631220;
        Tue, 28 Jun 2022 23:57:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHmluRw_1656485816;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHmluRw_1656485816)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 14:56:57 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: [PATCH v11 00/40] virtio pci support VIRTIO_F_RING_RESET
Date:   Wed, 29 Jun 2022 14:56:16 +0800
Message-Id: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-Git-Hash: 3fdaf102dd89
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio spec already supports the virtio queue reset function. This patch set
is to add this function to the kernel. The relevant virtio spec information is
here:

    https://github.com/oasis-tcs/virtio-spec/issues/124
    https://github.com/oasis-tcs/virtio-spec/issues/139

Also regarding MMIO support for queue reset, I plan to support it after this
patch is passed.

This patch set implements the refactoring of vring. Finally, the
virtuque_resize() interface is provided based on the reset function of the
transport layer.

Test environment:
    Host: 4.19.91
    Qemu: QEMU emulator version 6.2.50 (with vq reset support)
    Test Cmd:  ethtool -G eth1 rx $1 tx $2; ethtool -g eth1

    The default is split mode, modify Qemu virtio-net to add PACKED feature to test
    packed mode.

Qemu code:
    https://github.com/fengidri/qemu/compare/89f3bfa3265554d1d591ee4d7f1197b6e3397e84...master

In order to simplify the review of this patch set, the function of reusing
the old buffers after resize will be introduced in subsequent patch sets.

Please review. Thanks.

v11:
  1. struct virtio_pci_common_cfg to virtio_pci_modern.h
  2. conflict resolution

v10:
  1. on top of the harden vring IRQ
  2. factor out split and packed from struct vring_virtqueue
  3. some suggest from @Jason Wang

v9:
  1. Provide a virtqueue_resize() interface directly
  2. A patch set including vring resize, virtio pci reset, virtio-net resize
  3. No more separate structs

v8:
  1. Provide a virtqueue_reset() interface directly
  2. Split the two patch sets, this is the first part
  3. Add independent allocation helper for allocating state, extra

v7:
  1. fix #6 subject typo
  2. fix #6 ring_size_in_bytes is uninitialized
  3. check by: make W=12

v6:
  1. virtio_pci: use synchronize_irq(irq) to sync the irq callbacks
  2. Introduce virtqueue_reset_vring() to implement the reset of vring during
     the reset process. May use the old vring if num of the vq not change.
  3. find_vqs() support sizes to special the max size of each vq

v5:
  1. add virtio-net support set_ringparam

v4:
  1. just the code of virtio, without virtio-net
  2. Performing reset on a queue is divided into these steps:
    1. reset_vq: reset one vq
    2. recycle the buffer from vq by virtqueue_detach_unused_buf()
    3. release the ring of the vq by vring_release_virtqueue()
    4. enable_reset_vq: re-enable the reset queue
  3. Simplify the parameters of enable_reset_vq()
  4. add container structures for virtio_pci_common_cfg

v3:
  1. keep vq, irq unreleased

Xuan Zhuo (40):
  virtio: add helper virtqueue_get_vring_max_size()
  virtio: struct virtio_config_ops add callbacks for queue_reset
  virtio_ring: update the document of the virtqueue_detach_unused_buf
    for queue reset
  virtio_ring: extract the logic of freeing vring
  virtio_ring: split vring_virtqueue
  virtio_ring: introduce virtqueue_init()
  virtio_ring: split: introduce vring_free_split()
  virtio_ring: split: extract the logic of alloc queue
  virtio_ring: split: extract the logic of alloc state and extra
  virtio_ring: split: extract the logic of attach vring
  virtio_ring: split: extract the logic of vring init
  virtio_ring: split: introduce virtqueue_reinit_split()
  virtio_ring: split: reserve vring_align, may_reduce_num
  virtio_ring: split: introduce virtqueue_resize_split()
  virtio_ring: packed: introduce vring_free_packed
  virtio_ring: packed: extract the logic of alloc queue
  virtio_ring: packed: extract the logic of alloc state and extra
  virtio_ring: packed: extract the logic of attach vring
  virtio_ring: packed: extract the logic of vring init
  virtio_ring: packed: introduce virtqueue_reinit_packed()
  virtio_ring: packed: introduce virtqueue_resize_packed()
  virtio_ring: introduce virtqueue_resize()
  virtio_pci: move struct virtio_pci_common_cfg to virtio_pci_modern.h
  virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
  virtio: allow to unbreak/break virtqueue individually
  virtio: queue_reset: add VIRTIO_F_RING_RESET
  virtio_pci: struct virtio_pci_common_cfg add queue_reset
  virtio_pci: introduce helper to get/set queue reset
  virtio_pci: extract the logic of active vq for modern pci
  virtio_pci: support VIRTIO_F_RING_RESET
  virtio: find_vqs() add arg sizes
  virtio_pci: support the arg sizes of find_vqs()
  virtio_mmio: support the arg sizes of find_vqs()
  virtio: add helper virtio_find_vqs_ctx_size()
  virtio_net: set the default max ring size by find_vqs()
  virtio_net: get ringparam by virtqueue_get_vring_max_size()
  virtio_net: split free_unused_bufs()
  virtio_net: support rx queue resize
  virtio_net: support tx queue resize
  virtio_net: support set_ringparam

 arch/um/drivers/virtio_uml.c             |   3 +-
 drivers/net/virtio_net.c                 | 209 +++++-
 drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +
 drivers/remoteproc/remoteproc_virtio.c   |   3 +
 drivers/s390/virtio/virtio_ccw.c         |   4 +
 drivers/virtio/virtio_mmio.c             |  11 +-
 drivers/virtio/virtio_pci_common.c       |  32 +-
 drivers/virtio/virtio_pci_common.h       |   3 +-
 drivers/virtio/virtio_pci_legacy.c       |   8 +-
 drivers/virtio/virtio_pci_modern.c       | 161 ++++-
 drivers/virtio/virtio_pci_modern_dev.c   |  35 +
 drivers/virtio/virtio_ring.c             | 785 +++++++++++++++++------
 drivers/virtio/virtio_vdpa.c             |   3 +
 include/linux/virtio.h                   |   9 +
 include/linux/virtio_config.h            |  38 +-
 include/linux/virtio_pci_modern.h        |  30 +
 include/uapi/linux/virtio_config.h       |   7 +-
 include/uapi/linux/virtio_pci.h          |  28 +-
 18 files changed, 1068 insertions(+), 304 deletions(-)

--
2.31.0

