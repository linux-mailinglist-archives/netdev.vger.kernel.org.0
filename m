Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB764D1816
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiCHMjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346959AbiCHMhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:37:40 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6EF483B2;
        Tue,  8 Mar 2022 04:36:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eQtdd_1646742968;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eQtdd_1646742968)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:36:09 +0800
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
Subject: [PATCH v7 23/26] virtio_net: split free_unused_bufs()
Date:   Tue,  8 Mar 2022 20:35:15 +0800
Message-Id: <20220308123518.33800-24-xuanzhuo@linux.alibaba.com>
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

This patch separates two functions for freeing sq buf and rq buf from
free_unused_bufs().

When supporting the enable/disable tx/rq queue in the future, it is
necessary to support separate recovery of a sq buf or a rq buf.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 59b1ea82f5f0..409a8e180918 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2804,36 +2804,45 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 			put_page(vi->rq[i].alloc_frag.page);
 }
 
-static void free_unused_bufs(struct virtnet_info *vi)
+static void virtnet_sq_free_unused_bufs(struct virtnet_info *vi,
+					struct send_queue *sq)
 {
 	void *buf;
-	int i;
 
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->sq[i].vq;
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (!is_xdp_frame(buf))
-				dev_kfree_skb(buf);
-			else
-				xdp_return_frame(ptr_to_xdp(buf));
-		}
+	while ((buf = virtqueue_detach_unused_buf(sq->vq)) != NULL) {
+		if (!is_xdp_frame(buf))
+			dev_kfree_skb(buf);
+		else
+			xdp_return_frame(ptr_to_xdp(buf));
 	}
+}
 
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->rq[i].vq;
-
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (vi->mergeable_rx_bufs) {
-				put_page(virt_to_head_page(buf));
-			} else if (vi->big_packets) {
-				give_pages(&vi->rq[i], buf);
-			} else {
-				put_page(virt_to_head_page(buf));
-			}
-		}
+static void virtnet_rq_free_unused_bufs(struct virtnet_info *vi,
+					struct receive_queue *rq)
+{
+	void *buf;
+
+	while ((buf = virtqueue_detach_unused_buf(rq->vq)) != NULL) {
+		if (vi->mergeable_rx_bufs)
+			put_page(virt_to_head_page(buf));
+		else if (vi->big_packets)
+			give_pages(rq, buf);
+		else
+			put_page(virt_to_head_page(buf));
 	}
 }
 
+static void free_unused_bufs(struct virtnet_info *vi)
+{
+	int i;
+
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		virtnet_sq_free_unused_bufs(vi, vi->sq + i);
+
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		virtnet_rq_free_unused_bufs(vi, vi->rq + i);
+}
+
 static void virtnet_del_vqs(struct virtnet_info *vi)
 {
 	struct virtio_device *vdev = vi->vdev;
-- 
2.31.0

