Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A2255678
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgH1I2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:28:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:23546 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgH1I1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:33 -0400
IronPort-SDR: cs1bDCGHq+ung9zkRUbBLc94sb4l4eWkpU/Rp6preod6RPc/OojdfSjOqyLKSe+5vMszUpkrDW
 0G0D8rJzlpsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156634033"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156634033"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:27:23 -0700
IronPort-SDR: GuagjEB+7TaCDY3i4pjQyHWZsmxWQoTYy4qogpmY+DHbOKYqfHnk0qSnEsev20vW/TOINz0DE1
 3HbWe+WdZaqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762856"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:27:19 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 11/15] xsk: add shared umem support between queue ids
Date:   Fri, 28 Aug 2020 10:26:25 +0200
Message-Id: <1598603189-32145-12-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to share a umem between queue ids on the same
device. This mode can be invoked with the XDP_SHARED_UMEM bind
flag. Previously, sharing was only supported within the same
queue id and device, and you shared one set of fill and
completion rings. However, note that when sharing a umem between
queue ids, you need to create a fill ring and a completion ring
and tie them to the socket before you do the bind with the
XDP_SHARED_UMEM flag. This so that the single-producer
single-consumer semantics can be upheld.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xsk_buff_pool.h |  2 ++
 net/xdp/xsk.c               | 44 ++++++++++++++++++++++++++++++--------------
 net/xdp/xsk_buff_pool.c     | 26 ++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 907537d..0140d08 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -81,6 +81,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+			 struct net_device *dev, u16 queue_id);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 067e854..ea8d2ec 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -689,12 +689,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			goto out_unlock;
 		}
 
-		if (xs->fq_tmp || xs->cq_tmp) {
-			/* Do not allow setting your own fq or cq. */
-			err = -EINVAL;
-			goto out_unlock;
-		}
-
 		sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
 		if (IS_ERR(sock)) {
 			err = PTR_ERR(sock);
@@ -707,15 +701,41 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			sockfd_put(sock);
 			goto out_unlock;
 		}
-		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
+		if (umem_xs->dev != dev) {
 			err = -EINVAL;
 			sockfd_put(sock);
 			goto out_unlock;
 		}
 
-		/* Share the buffer pool with the other socket. */
-		xp_get_pool(umem_xs->pool);
-		xs->pool = umem_xs->pool;
+		if (umem_xs->queue_id != qid) {
+			/* Share the umem with another socket on another qid */
+			xs->pool = xp_create_and_assign_umem(xs,
+							     umem_xs->umem);
+			if (!xs->pool) {
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+
+			err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
+						   dev, qid);
+			if (err) {
+				xp_destroy(xs->pool);
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+		} else {
+			/* Share the buffer pool with the other socket. */
+			if (xs->fq_tmp || xs->cq_tmp) {
+				/* Do not allow setting your own fq or cq. */
+				err = -EINVAL;
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+
+			xp_get_pool(umem_xs->pool);
+			xs->pool = umem_xs->pool;
+		}
+
 		xdp_get_umem(umem_xs->umem);
 		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
@@ -847,10 +867,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			mutex_unlock(&xs->mutex);
 			return -EBUSY;
 		}
-		if (!xs->umem) {
-			mutex_unlock(&xs->mutex);
-			return -EINVAL;
-		}
 
 		q = (optname == XDP_UMEM_FILL_RING) ? &xs->fq_tmp :
 			&xs->cq_tmp;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 547eb41..795d7c8 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -123,8 +123,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
-		  u16 queue_id, u16 flags)
+static int __xp_assign_dev(struct xsk_buff_pool *pool,
+			   struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -193,6 +193,28 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
 	return err;
 }
 
+int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
+		  u16 queue_id, u16 flags)
+{
+	return __xp_assign_dev(pool, dev, queue_id, flags);
+}
+
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+			 struct net_device *dev, u16 queue_id)
+{
+	u16 flags;
+
+	/* One fill and completion ring required for each queue id. */
+	if (!pool->fq || !pool->cq)
+		return -EINVAL;
+
+	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
+	if (pool->uses_need_wakeup)
+		flags |= XDP_USE_NEED_WAKEUP;
+
+	return __xp_assign_dev(pool, dev, queue_id, flags);
+}
+
 void xp_clear_dev(struct xsk_buff_pool *pool)
 {
 	if (!pool->netdev)
-- 
2.7.4

