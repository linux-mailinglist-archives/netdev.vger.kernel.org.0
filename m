Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974E549C469
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiAZHfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:42 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:34290 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237881AbiAZHfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2ubkjl_1643182537;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2ubkjl_1643182537)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:38 +0800
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
Subject: [PATCH v3 04/17] virtio: queue_reset: add helper
Date:   Wed, 26 Jan 2022 15:35:20 +0800
Message-Id: <20220126073533.44994-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper for virtio queue reset.

* virtio_reset_vq: reset a queue individually
* virtio_enable_resetq: enable a reset queue

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/virtio_config.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 51dd8461d1b6..3c971d9a0a59 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -260,6 +260,38 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 				      desc);
 }
 
+/**
+ * virtio_reset_vq - reset a queue individually
+ * @param: struct virtio_reset_vq
+ *
+ * returns 0 on success or error status
+ *
+ */
+static inline
+int virtio_reset_vq(struct virtio_reset_vq *param)
+{
+	if (!param->vdev->config->reset_vq)
+		return -ENOENT;
+
+	return param->vdev->config->reset_vq(param);
+}
+
+/**
+ * virtio_enable_resetq - enable a reset queue
+ * @param: struct virtio_reset_vq
+ *
+ * returns vq on success or error status
+ *
+ */
+static inline
+struct virtqueue *virtio_enable_resetq(struct virtio_reset_vq *param)
+{
+	if (!param->vdev->config->enable_reset_vq)
+		return ERR_PTR(-ENOENT);
+
+	return param->vdev->config->enable_reset_vq(param);
+}
+
 /**
  * virtio_device_ready - enable vq use in probe function
  * @vdev: the device
-- 
2.31.0

