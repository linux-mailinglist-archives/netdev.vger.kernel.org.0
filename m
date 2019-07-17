Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587906BA9C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbfGQKxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfGQKxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5AE2C5D674;
        Wed, 17 Jul 2019 10:53:13 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CF9B1001B16;
        Wed, 17 Jul 2019 10:53:10 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 02/15] vhost: remove the unnecessary parameter of vhost_vq_avail_empty()
Date:   Wed, 17 Jul 2019 06:52:42 -0400
Message-Id: <20190717105255.63488-3-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 17 Jul 2019 10:53:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its dev parameter is not even used, so remove it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 8 ++++----
 drivers/vhost/vhost.c | 2 +-
 drivers/vhost/vhost.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 3beb401235c0..7d34e8cbc89b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -498,7 +498,7 @@ static int sock_has_rx_data(struct socket *sock)
 static void vhost_net_busy_poll_try_queue(struct vhost_net *net,
 					  struct vhost_virtqueue *vq)
 {
-	if (!vhost_vq_avail_empty(&net->dev, vq)) {
+	if (!vhost_vq_avail_empty(vq)) {
 		vhost_poll_queue(&vq->poll);
 	} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
 		vhost_disable_notify(&net->dev, vq);
@@ -540,8 +540,8 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 		}
 
 		if ((sock_has_rx_data(sock) &&
-		     !vhost_vq_avail_empty(&net->dev, rvq)) ||
-		    !vhost_vq_avail_empty(&net->dev, tvq))
+		     !vhost_vq_avail_empty(rvq)) ||
+		    !vhost_vq_avail_empty(tvq))
 			break;
 
 		cpu_relax();
@@ -638,7 +638,7 @@ static int get_tx_bufs(struct vhost_net *net,
 static bool tx_can_batch(struct vhost_virtqueue *vq, size_t total_len)
 {
 	return total_len < VHOST_NET_WEIGHT &&
-	       !vhost_vq_avail_empty(vq->dev, vq);
+	       !vhost_vq_avail_empty(vq);
 }
 
 #define SKB_FRAG_PAGE_ORDER     get_order(32768)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7f51c74d9aee..ec3534bcd51b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2946,7 +2946,7 @@ void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 
 /* return true if we're sure that avaiable ring is empty */
-bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+bool vhost_vq_avail_empty(struct vhost_virtqueue *vq)
 {
 	__virtio16 avail_idx;
 	int r;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 819296332913..e0451c900177 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -247,7 +247,7 @@ void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
 			       struct vring_used_elem *heads, unsigned count);
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
 void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
-bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
+bool vhost_vq_avail_empty(struct vhost_virtqueue *vq);
 bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
-- 
2.18.1

