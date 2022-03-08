Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD604D17FA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347001AbiCHMjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235447AbiCHMhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:37:21 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98C448327;
        Tue,  8 Mar 2022 04:36:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eTXfL_1646742959;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eTXfL_1646742959)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:36:01 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 19/26] virtio_pci: support the arg sizes of find_vqs()
Date:   Tue,  8 Mar 2022 20:35:11 +0800
Message-Id: <20220308123518.33800-20-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: f06b131dbfed
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

Virtio PCI supports new parameter sizes of find_vqs().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_common.c | 18 ++++++++++--------
 drivers/virtio/virtio_pci_common.h |  1 +
 drivers/virtio/virtio_pci_legacy.c |  6 +++++-
 drivers/virtio/virtio_pci_modern.c | 10 +++++++---
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 8e8fa7e5ad80..1faf65325060 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -208,6 +208,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
 static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 				     void (*callback)(struct virtqueue *vq),
 				     const char *name,
+				     u32 size,
 				     bool ctx,
 				     u16 msix_vec)
 {
@@ -221,7 +222,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
 		return ERR_PTR(-ENOMEM);
 
 	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
-			      msix_vec);
+			      size, msix_vec);
 	if (IS_ERR(vq))
 		goto out_info;
 
@@ -314,7 +315,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 
 static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], bool per_vq_vectors,
+		const char * const names[], u32 sizes[], bool per_vq_vectors,
 		const bool *ctx,
 		struct irq_affinity *desc)
 {
@@ -357,8 +358,8 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 		else
 			msix_vec = VP_MSIX_VQ_VECTOR;
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     ctx ? ctx[i] : false,
-				     msix_vec);
+				     sizes ? sizes[i] : 0,
+				     ctx ? ctx[i] : false, msix_vec);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto error_find;
@@ -388,7 +389,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 
 static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], const bool *ctx)
+		const char * const names[], u32 sizes[], const bool *ctx)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i, err, queue_idx = 0;
@@ -410,6 +411,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
 			continue;
 		}
 		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
+				     sizes ? sizes[i] : 0,
 				     ctx ? ctx[i] : false,
 				     VIRTIO_MSI_NO_VECTOR);
 		if (IS_ERR(vqs[i])) {
@@ -433,15 +435,15 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	int err;
 
 	/* Try MSI-X with one vector per queue. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, true, ctx, desc);
 	if (!err)
 		return 0;
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
-	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
+	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, false, ctx, desc);
 	if (!err)
 		return 0;
 	/* Finally fall back to regular interrupts. */
-	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
+	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, sizes, ctx);
 }
 
 const char *vp_bus_name(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 9dbf1d555dff..a15ac5570ddd 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -82,6 +82,7 @@ struct virtio_pci_device {
 				      void (*callback)(struct virtqueue *vq),
 				      const char *name,
 				      bool ctx,
+				      u32 size,
 				      u16 msix_vec);
 	void (*del_vq)(struct virtio_pci_vq_info *info);
 
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index b68934fe6b5d..efa98d2debe0 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -113,6 +113,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
+				  u32 size,
 				  u16 msix_vec)
 {
 	struct virtqueue *vq;
@@ -125,10 +126,13 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!num || vp_legacy_get_queue_enable(&vp_dev->ldev, index))
 		return ERR_PTR(-ENOENT);
 
+	if (!size || size > num)
+		size = num;
+
 	info->msix_vector = msix_vec;
 
 	/* create the vring */
-	vq = vring_create_virtqueue(index, num,
+	vq = vring_create_virtqueue(index, size,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
 				    true, false, ctx,
 				    vp_notify, callback, name);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 342795175c29..0e17e0df6a8a 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -289,6 +289,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  void (*callback)(struct virtqueue *vq),
 				  const char *name,
 				  bool ctx,
+				  u32 size,
 				  u16 msix_vec)
 {
 
@@ -305,15 +306,18 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!num || vp_modern_get_queue_enable(mdev, index))
 		return ERR_PTR(-ENOENT);
 
-	if (num & (num - 1)) {
-		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", num);
+	if (!size || size > num)
+		size = num;
+
+	if (size & (size - 1)) {
+		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", size);
 		return ERR_PTR(-EINVAL);
 	}
 
 	info->msix_vector = msix_vec;
 
 	/* create the vring */
-	vq = vring_create_virtqueue(index, num,
+	vq = vring_create_virtqueue(index, size,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
 				    vp_notify, callback, name);
-- 
2.31.0

