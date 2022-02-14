Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131754B43A4
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbiBNIOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:14:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbiBNIO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:27 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDDAC6C;
        Mon, 14 Feb 2022 00:14:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4NbDMb_1644826456;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4NbDMb_1644826456)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:17 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v5 00/22] virtio pci support VIRTIO_F_RING_RESET
Date:   Mon, 14 Feb 2022 16:13:54 +0800
Message-Id: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-Git-Hash: 24fd8391539b
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio spec already supports the virtio queue reset function. This patch set
is to add this function to the kernel. The relevant virtio spec information is
here:

    https://github.com/oasis-tcs/virtio-spec/issues/124

Also regarding MMIO support for queue reset, I plan to support it after this
patch is passed.

Performing reset on a queue is divided into four steps:
    1. reset_vq: reset one vq
    2. recycle the buffer from vq by virtqueue_detach_unused_buf()
    3. release the ring of the vq by vring_release_virtqueue()
    4. enable_reset_vq: re-enable the reset queue

#2-#8  : virtio ring support re-enable reset queue and release vring
#9-#14 : virtio PCI support reset queue and re-enable
#15    : add queue reset helper
#16-#17: virtio-net support rx, tx reset
#18-#22: virtio-net support set ringparam

Please review. Thanks.

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

Xuan Zhuo (22):
  virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
  virtio: queue_reset: add VIRTIO_F_RING_RESET
  virtio_ring: queue_reset: add function vring_setup_virtqueue()
  virtio_ring: queue_reset: split: add __vring_init_virtqueue()
  virtio_ring: queue_reset: split: support enable reset queue
  virtio_ring: queue_reset: packed: support enable reset queue
  virtio_ring: queue_reset: extract the release function of the vq ring
  virtio_ring: queue_reset: add vring_release_virtqueue()
  virtio: queue_reset: struct virtio_config_ops add callbacks for
    queue_reset
  virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
    option functions
  virtio_pci: queue_reset: release vq by vp_dev->vqs
  virtio_pci: queue_reset: setup_vq() support vring_setup_virtqueue()
  virtio_pci: queue_reset: reserve vq->priv for re-enable queue
  virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
  virtio: queue_reset: add helper
  virtio_net: split free_unused_bufs()
  virtio_net: support rx/tx queue reset
  virtio: add helper virtqueue_get_vring_max_size()
  virtio: add helper virtio_set_max_ring_num()
  virtio_net: set the default max ring num
  virtio_net: get max ring size by virtqueue_get_vring_max_size()
  virtio_net: support set_ringparam

 drivers/net/virtio_net.c               | 238 ++++++++++++++++++++++---
 drivers/virtio/virtio_mmio.c           |   2 +
 drivers/virtio/virtio_pci_common.c     |  61 +++++--
 drivers/virtio/virtio_pci_common.h     |  10 +-
 drivers/virtio/virtio_pci_legacy.c     |   6 +-
 drivers/virtio/virtio_pci_modern.c     |  82 ++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  36 ++++
 drivers/virtio/virtio_ring.c           | 193 +++++++++++++++-----
 include/linux/virtio.h                 |  15 ++
 include/linux/virtio_config.h          |  82 +++++++++
 include/linux/virtio_pci_modern.h      |   2 +
 include/linux/virtio_ring.h            |  37 ++--
 include/uapi/linux/virtio_config.h     |   7 +-
 include/uapi/linux/virtio_pci.h        |  14 ++
 14 files changed, 668 insertions(+), 117 deletions(-)

--
2.31.0

