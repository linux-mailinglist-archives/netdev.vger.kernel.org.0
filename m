Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714921232C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgGBMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:20:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgGBMUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:20:04 -0400
IronPort-SDR: TYYyw9tJpuBiIEe7F79SKtYuvEOQZXMgVIm5iayhN4BHw+7q2koH88yReTv9vUg7hGCgWT6GjN
 2lXUhzsF4nyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486118"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:20:02 -0700
IronPort-SDR: FwU//7qtj0Et4wVU8AQ2QIezjHvpL2b88enQvA6wGF6R6IBakYgwxEDKMPnLS40YMf7Q3NlCXO
 EiKJsHe6B9iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933369"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:58 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 10/14] xsk: add shared umem support between queue ids
Date:   Thu,  2 Jul 2020 14:19:09 +0200
Message-Id: <1593692353-15102-11-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
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
 include/net/xsk_buff_pool.h |  3 +++
 net/xdp/xsk.c               | 51 +++++++++++++++++++++++++++++----------------
 net/xdp/xsk_buff_pool.c     | 27 ++++++++++++++++++++++--
 3 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 7513a17..844901c 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -76,6 +76,9 @@ struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool,
 				     struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 		  struct net_device *dev, u16 queue_id, u16 flags);
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+			 struct xdp_umem *umem, struct net_device *dev,
+			 u16 queue_id);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4d0028c..1abc222 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -627,6 +627,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
+	struct xsk_buff_pool *new_pool;
 	struct net_device *dev;
 	u32 flags, qid;
 	int err = 0;
@@ -679,12 +680,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			goto out_unlock;
 		}
 
-		if (xs->pool->fq || xs->pool->cq) {
-			/* Do not allow setting your own fq or cq. */
-			err = -EINVAL;
-			goto out_unlock;
-		}
-
 		sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
 		if (IS_ERR(sock)) {
 			err = PTR_ERR(sock);
@@ -697,17 +692,43 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
-		curr_pool = xs->pool;
-		xs->pool = umem_xs->pool;
-		xp_destroy(curr_pool);
+		if (umem_xs->queue_id != qid) {
+			/* Share the umem with another socket on another qid */
+			new_pool = xp_assign_umem(xs->pool, umem_xs->umem);
+			if (!new_pool) {
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+
+			err = xp_assign_dev_shared(new_pool, xs, umem_xs->umem,
+						   dev, qid);
+			if (err) {
+				xp_destroy(new_pool);
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+			xs->pool = new_pool;
+		} else {
+			/* Share the buffer pool with the other socket. */
+			if (xs->pool->fq || xs->pool->cq) {
+				/* Do not allow setting your own fq or cq. */
+				err = -EINVAL;
+				sockfd_put(sock);
+				goto out_unlock;
+			}
+
+			xp_get_pool(umem_xs->pool);
+			curr_pool = xs->pool;
+			xs->pool = umem_xs->pool;
+			xp_destroy(curr_pool);
+		}
+
 		xdp_get_umem(umem_xs->umem);
 		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
@@ -715,8 +736,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		err = -EINVAL;
 		goto out_unlock;
 	} else {
-		struct xsk_buff_pool *new_pool;
-
 		/* This xsk has its own umem. */
 		new_pool = xp_assign_umem(xs->pool, xs->umem);
 		if (!new_pool) {
@@ -841,10 +860,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			mutex_unlock(&xs->mutex);
 			return -EBUSY;
 		}
-		if (!xs->umem) {
-			mutex_unlock(&xs->mutex);
-			return -EINVAL;
-		}
 
 		q = (optname == XDP_UMEM_FILL_RING) ? &xs->pool->fq :
 			&xs->pool->cq;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 3c58d76..7987c17 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -126,8 +126,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
-		  struct net_device *netdev, u16 queue_id, u16 flags)
+static int __xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+			   struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -196,6 +196,29 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 	return err;
 }
 
+int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		  struct net_device *dev, u16 queue_id, u16 flags)
+{
+	return __xp_assign_dev(pool, xs, dev, queue_id, flags);
+}
+
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+			 struct xdp_umem *umem, struct net_device *dev,
+			 u16 queue_id)
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
+	return __xp_assign_dev(pool, xs, dev, queue_id, flags);
+}
+
 void xp_clear_dev(struct xsk_buff_pool *pool)
 {
 	if (!pool->netdev)
-- 
2.7.4

