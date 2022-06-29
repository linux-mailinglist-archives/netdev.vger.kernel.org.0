Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA4955F7BF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiF2G7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiF2G64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:58:56 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CFD3467B;
        Tue, 28 Jun 2022 23:57:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHmddpj_1656485870;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHmddpj_1656485870)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 14:57:51 +0800
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
Subject: [PATCH v11 25/40] virtio: allow to unbreak/break virtqueue individually
Date:   Wed, 29 Jun 2022 14:56:41 +0800
Message-Id: <20220629065656.54420-26-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3fdaf102dd89
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

This patch allows the new introduced
__virtqueue_break()/__virtqueue_unbreak() to break/unbreak the
virtqueue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 24 ++++++++++++++++++++++++
 include/linux/virtio.h       |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5ec43607cc15..7b02be7fce67 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2744,6 +2744,30 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
 
+/*
+ * This function should only be called by the core, not directly by the driver.
+ */
+void __virtqueue_break(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+	WRITE_ONCE(vq->broken, true);
+}
+EXPORT_SYMBOL_GPL(__virtqueue_break);
+
+/*
+ * This function should only be called by the core, not directly by the driver.
+ */
+void __virtqueue_unbreak(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+	WRITE_ONCE(vq->broken, false);
+}
+EXPORT_SYMBOL_GPL(__virtqueue_unbreak);
+
 bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 1272566adec6..dc474a0d48d1 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -138,6 +138,9 @@ bool is_virtio_device(struct device *dev);
 void virtio_break_device(struct virtio_device *dev);
 void __virtio_unbreak_device(struct virtio_device *dev);
 
+void __virtqueue_break(struct virtqueue *_vq);
+void __virtqueue_unbreak(struct virtqueue *_vq);
+
 void virtio_config_changed(struct virtio_device *dev);
 #ifdef CONFIG_PM_SLEEP
 int virtio_device_freeze(struct virtio_device *dev);
-- 
2.31.0

