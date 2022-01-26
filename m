Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A43349C461
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiAZHfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:39 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:43101 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237870AbiAZHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uVHkt_1643182533;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uVHkt_1643182533)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:33 +0800
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
Subject: [PATCH v3 00/17] virtio pci support VIRTIO_F_RING_RESET
Date:   Wed, 26 Jan 2022 15:35:16 +0800
Message-Id: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

================================================================================
The virtio spec already supports the virtio queue reset function. This patch set
is to add this function to the kernel. The relevant virtio spec information is
here:

    https://github.com/oasis-tcs/virtio-spec/issues/124

Also regarding MMIO support for queue reset, I plan to support it after this
patch is passed.

#14-#17 is the disable/enable function of rx/tx pair implemented by virtio-net
using the new helper. This function is not currently referenced by other
functions. It is more to show the usage of the new helper, I not sure if they
are going to be merged together.

Please review. Thanks.

v3:
  1. keep vq, irq unreleased

Xuan Zhuo (17):
  virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
  virtio: queue_reset: add VIRTIO_F_RING_RESET
  virtio: queue_reset: struct virtio_config_ops add callbacks for
    queue_reset
  virtio: queue_reset: add helper
  vritio_ring: queue_reset: extract the release function of the vq ring
  virtio_ring: queue_reset: split: add __vring_init_virtqueue()
  virtio_ring: queue_reset: split: support enable reset queue
  virtio_ring: queue_reset: packed: support enable reset queue
  virtio_ring: queue_reset: add vring_reset_virtqueue()
  virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
    option functions
  virtio_pci: queue_reset: release vq by vp_dev->vqs
  virtio_pci: queue_reset: setup_vq use vring_setup_virtqueue()
  virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
  virtio_net: virtnet_tx_timeout() fix style
  virtio_net: virtnet_tx_timeout() stop ref sq->vq
  virtio_net: split free_unused_bufs()
  virtio_net: support pair disable/enable

 drivers/net/virtio_net.c               | 220 ++++++++++++++++++++++---
 drivers/virtio/virtio_pci_common.c     |  62 ++++---
 drivers/virtio/virtio_pci_common.h     |  11 +-
 drivers/virtio/virtio_pci_legacy.c     |   5 +-
 drivers/virtio/virtio_pci_modern.c     | 120 +++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
 drivers/virtio/virtio_ring.c           | 144 +++++++++++-----
 include/linux/virtio.h                 |   1 +
 include/linux/virtio_config.h          |  75 ++++++++-
 include/linux/virtio_pci_modern.h      |   2 +
 include/linux/virtio_ring.h            |  42 +++--
 include/uapi/linux/virtio_config.h     |   7 +-
 include/uapi/linux/virtio_pci.h        |   2 +
 13 files changed, 618 insertions(+), 101 deletions(-)

--
2.31.0

