Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947454C2A30
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiBXLEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbiBXLEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:37 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C85E28F972;
        Thu, 24 Feb 2022 03:04:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5O5g7L_1645700642;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5O5g7L_1645700642)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:03 +0800
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
Subject: [PATCH v2 0/9] virtio: support advance DMA
Date:   Thu, 24 Feb 2022 19:03:53 +0800
Message-Id: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-Git-Hash: d02e086a8668
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

virtqueue_add() only supports virtual addresses, dma is completed in
virtqueue_add().

In some scenarios (such as the AF_XDP scenario), DMA is completed in advance, so
it is necessary for us to support passing the DMA address to virtqueue_add().

v2:
    1. rename predma -> premapped
    2. virtio net xdp tx use virtio dma api

v1:
   1. All sgs requested at one time are required to be unified PREDMA, and several
      of them are not supported to be PREDMA
   2. virtio_dma_map() is removed from this patch set and will be submitted
      together with the next time AF_XDP supports virtio dma
   3. Added patch #2 #3 to remove the check for flags when performing unmap
      indirect desc

Xuan Zhuo (9):
  virtio_ring: rename vring_unmap_state_packed() to
    vring_unmap_extra_packed()
  virtio_ring: remove flags check for unmap split indirect desc
  virtio_ring: remove flags check for unmap packed indirect desc
  virtio_ring: virtqueue_add() support premapped
  virtio_ring: split: virtqueue_add_split() support premapped
  virtio_ring: packed: virtqueue_add_packed() support premapped
  virtio_ring: add api virtio_dma_map() for advance dma
  virtio_ring: introduce virtqueue_add_outbuf_premapped()
  virtio_net: xdp xmit use virtio dma api

 drivers/net/virtio_net.c     |  42 +++++-
 drivers/virtio/virtio_ring.c | 280 ++++++++++++++++++++++++++---------
 include/linux/virtio.h       |  12 ++
 3 files changed, 254 insertions(+), 80 deletions(-)

--
2.31.0

