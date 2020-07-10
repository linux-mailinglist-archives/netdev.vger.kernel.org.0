Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1571421B82B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgGJOR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:17:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:32698 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgGJOR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:17:27 -0400
IronPort-SDR: D9Eaw6tEUltp1ClCWS8A2uea8aFVARkNvcyuFM0hXLwYLzlVxt+PIaN3eEoKKr+Y4fmUrukEPg
 DXCRqzfgP6Dw==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="209731697"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="209731697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 07:17:26 -0700
IronPort-SDR: Ns2R3hvRJgoPqel+1MK8FCsVa/+IgEvfWx1qHpyZvfrJ9JiyoLxcb8A7pI3homSIb3oe7/eMhG
 LGa8hYFAWv4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="428575482"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.54.29])
  by orsmga004.jf.intel.com with ESMTP; 10 Jul 2020 07:17:23 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v2 10/14] xsk: add shared umem support between queue ids
Date:   Fri, 10 Jul 2020 16:16:38 +0200
Message-Id: <1594390602-7635-11-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
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
---
 include/net/xsk_buff_pool.h |  2 ++
 net/xdp/xsk.c               | 44 ++++++++++++++++++++++++++++++--------------
 net/xdp/xsk_buff_pool.c     | 26 ++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 0c5b097..9d98fea 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -75,6 +75,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+			 struct net_device *dev, u16 queue_id);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ddac554..05fadd9 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -683,12 +683,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
@@ -701,15 +695,41 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
@@ -840,10 +860,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
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
index 83c0d3c..c1d0419 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -124,8 +124,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
-		  u16 queue_id, u16 flags)
+static int __xp_assign_dev(struct xsk_buff_pool *pool,
+			   struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -194,6 +194,28 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
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

