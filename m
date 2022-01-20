Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACE949476B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358769AbiATGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:43:09 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:42429 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232105AbiATGnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:43:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2KWFIC_1642660983;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2KWFIC_1642660983)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:43:04 +0800
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
Subject: [PATCH v2 00/12] virtio pci support VIRTIO_F_RING_RESET
Date:   Thu, 20 Jan 2022 14:42:51 +0800
Message-Id: <20220120064303.106639-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio spec already supports the virtio queue reset function. This patch set
is to add this function to the kernel. The relevant virtio spec information is
here:

    https://github.com/oasis-tcs/virtio-spec/issues/124

Also regarding MMIO support for queue reset, I plan to support it after this
patch is passed.

#9-#12 is the disable/enable function of rx/tx pair implemented by virtio-net
using the new helper. This function is not currently referenced by other
functions. It is more to show the usage of the new helper, I not sure if they
are going to be merged together.

Please review. Thanks.

Xuan Zhuo (12):
  virtio: pci: struct virtio_pci_common_cfg add queue_notify_data
  virtio: queue_reset: add VIRTIO_F_RING_RESET
  virtio: queue_reset: struct virtio_config_ops add callbacks for
    queue_reset
  virtio: queue_reset: pci: update struct virtio_pci_common_cfg and
    option functions
  virito: queue_reset: pci: move the per queue irq logic from vp_del_vqs
    to vp_del_vq
  virtio: queue_reset: pci: add independent function to enable msix vq
  virtio: queue_reset: pci: support VIRTIO_F_RING_RESET
  virtio: queue_reset: add helper
  virtio_net: virtnet_tx_timeout() fix style
  virtio_net: virtnet_tx_timeout() stop ref sq->vq
  virtio_net: split free_unused_bufs()
  virtio-net: support pair disable/enable

 drivers/net/virtio_net.c               | 200 ++++++++++++++++++++++---
 drivers/virtio/virtio_pci_common.c     | 135 +++++++++++++----
 drivers/virtio/virtio_pci_common.h     |   4 +
 drivers/virtio/virtio_pci_modern.c     |  73 +++++++++
 drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
 include/linux/virtio_config.h          |  63 ++++++++
 include/linux/virtio_pci_modern.h      |   2 +
 include/uapi/linux/virtio_config.h     |   7 +-
 include/uapi/linux/virtio_pci.h        |   2 +
 9 files changed, 460 insertions(+), 54 deletions(-)

--
2.31.0

