Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FED21311
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfEQEaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 00:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfEQEaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 00:30:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 365DF3001C61;
        Fri, 17 May 2019 04:30:09 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A7791001E61;
        Fri, 17 May 2019 04:30:02 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, stefanha@redhat.com
Subject: [PATCH V2 1/4] vhost: introduce vhost_exceeds_weight()
Date:   Fri, 17 May 2019 00:29:49 -0400
Message-Id: <1558067392-11740-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 17 May 2019 04:30:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to have vhost_exceeds_weight() for vhost-net to:

- prevent vhost kthread from hogging the cpu
- balance the time spent between TX and RX

This function could be useful for vsock and scsi as well. So move it
to vhost.c. Device must specify a weight which counts the number of
requests, or it can also specific a byte_weight which counts the
number of bytes that has been processed.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 22 ++++++----------------
 drivers/vhost/scsi.c  |  9 ++++++++-
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  5 ++++-
 drivers/vhost/vsock.c | 12 +++++++++++-
 5 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df51a35..061a06d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -604,12 +604,6 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 	return iov_iter_count(iter);
 }
 
-static bool vhost_exceeds_weight(int pkts, int total_len)
-{
-	return total_len >= VHOST_NET_WEIGHT ||
-	       pkts >= VHOST_NET_PKT_WEIGHT;
-}
-
 static int get_tx_bufs(struct vhost_net *net,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
@@ -845,10 +839,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
 		vq->heads[nvq->done_idx].len = 0;
 		++nvq->done_idx;
-		if (vhost_exceeds_weight(++sent_pkts, total_len)) {
-			vhost_poll_queue(&vq->poll);
+		if (vhost_exceeds_weight(vq, ++sent_pkts, total_len))
 			break;
-		}
 	}
 
 	vhost_tx_batch(net, nvq, sock, &msg);
@@ -951,10 +943,9 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
-		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
+						  total_len)))
 			break;
-		}
 	}
 }
 
@@ -1239,10 +1230,8 @@ static void handle_rx(struct vhost_net *net)
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
-			vhost_poll_queue(&vq->poll);
+		if (unlikely(vhost_exceeds_weight(vq, ++recv_pkts, total_len)))
 			goto out;
-		}
 	}
 	if (unlikely(busyloop_intr))
 		vhost_poll_queue(&vq->poll);
@@ -1338,7 +1327,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       UIO_MAXIOV + VHOST_NET_BATCH);
+		       UIO_MAXIOV + VHOST_NET_BATCH,
+		       VHOST_NET_WEIGHT, VHOST_NET_PKT_WEIGHT);
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 618fb64..d830579 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -57,6 +57,12 @@
 #define VHOST_SCSI_PREALLOC_UPAGES 2048
 #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
 
+/* Max number of requests before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * request.
+ */
+#define VHOST_SCSI_WEIGHT 256
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -1622,7 +1628,8 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV);
+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+		       VHOST_SCSI_WEIGHT, 0);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 351af88..290d6e5 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -413,8 +413,24 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 		vhost_vq_free_iovecs(dev->vqs[i]);
 }
 
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
+			  int pkts, int total_len)
+{
+	struct vhost_dev *dev = vq->dev;
+
+	if ((dev->byte_weight && total_len >= dev->byte_weight) ||
+	    pkts >= dev->weight) {
+		vhost_poll_queue(&vq->poll);
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vhost_exceeds_weight);
+
 void vhost_dev_init(struct vhost_dev *dev,
-		    struct vhost_virtqueue **vqs, int nvqs, int iov_limit)
+		    struct vhost_virtqueue **vqs, int nvqs,
+		    int iov_limit, int weight, int byte_weight)
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -428,6 +444,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->mm = NULL;
 	dev->worker = NULL;
 	dev->iov_limit = iov_limit;
+	dev->weight = weight;
+	dev->byte_weight = byte_weight;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9490e7d..27a78a9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -171,10 +171,13 @@ struct vhost_dev {
 	struct list_head pending_list;
 	wait_queue_head_t wait;
 	int iov_limit;
+	int weight;
+	int byte_weight;
 };
 
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit);
+		    int nvqs, int iov_limit, int weight, int byte_weight);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index bb5fc0e..47c6d4d 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -21,6 +21,14 @@
 #include "vhost.h"
 
 #define VHOST_VSOCK_DEFAULT_HOST_CID	2
+/* Max number of bytes transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others. */
+#define VHOST_VSOCK_WEIGHT 0x80000
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving others with
+ * small pkts.
+ */
+#define VHOST_VSOCK_PKT_WEIGHT 256
 
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES,
@@ -531,7 +539,9 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs), UIO_MAXIOV);
+	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
+		       VHOST_VSOCK_WEIGHT);
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
-- 
1.8.3.1

