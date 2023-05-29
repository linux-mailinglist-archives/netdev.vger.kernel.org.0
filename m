Return-Path: <netdev+bounces-6119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D13714D81
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 175961C20A1A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B731095D;
	Mon, 29 May 2023 15:50:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3336107A0;
	Mon, 29 May 2023 15:50:54 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F627DE;
	Mon, 29 May 2023 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375453; x=1716911453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TfVoz87qpEFgK5ifXVQFDV2Kicze8w77gtAMOYlBW/Y=;
  b=gzlTejf3PgV+Kh8whqj/cQvPUoC+HFExeJtL3EvJNx02LUHanFg5Xt4X
   YXkcaN9+6qAKdH6TjMu1IifEGDb+4cRPdhVmJwR5PeIE6fqTtQJghip4Y
   36q+1BfLA8Y38bfZcda/v4g2oC7JTPZKq4An9x8wYE3wouF31TZbyEyhm
   ds7YY9kJN9thwUCbCcCr863u31fTj+ZfkVHUAvlNKneMGjVo2aMYUoG6G
   8M9FamNsGLpAljrc++u8ORh9fcamfLN2+D6TRHOQyR4nslJPEX2hSrMrC
   jNooVUNjcZUCbcop2eOF6WU4t21HT3GAzhiFxWDpOhO2r+jidnNIKy+PB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229018"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229018"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:50:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441099"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441099"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:50:50 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 10/22] xsk: support mbuf on ZC RX
Date: Mon, 29 May 2023 17:50:12 +0200
Message-Id: <20230529155024.222213-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Extend xdp_buff_xsk with two new list_head members - xskb_list and
xskb_list_node. This means that each xdp_buff_xsk can be a node in the
chain of these structs and also each xskb can carry the list by itself.
This is needed so ZC drivers can add frags as xskb nodes which will make
it possible to handle it both when producing AF_XDP Rx descriptors as
well as freeing/recycling all the frags that a single frame carries.

Speaking of latter, update xsk_buff_free() to take care of list nodes.
For the former (adding as frags), introduce xsk_buff_add_frag() for ZC
drivers usage that is going to be used to add a frag to the first xskb.

xsk_buff_get_frag() will be utilized by XDP_TX and, on contrary, will
return xdp_buff.

One of the previous patches added a wrapper for ZC Rx so implement xskb
list walk and production of Rx descriptors there.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/net/xdp_sock_drv.h  | 46 +++++++++++++++++++++++++++++++++++++
 include/net/xsk_buff_pool.h |  2 ++
 net/xdp/xsk.c               | 24 ++++++++++++++++++-
 net/xdp/xsk_buff_pool.c     |  2 ++
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index a3e18b958d93..36984c7b1393 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -108,10 +108,46 @@ static inline bool xsk_buff_can_alloc(struct xsk_buff_pool *pool, u32 count)
 static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
+	struct xdp_buff_xsk *pos, *tmp;
 
+	if (likely(!xdp_buff_has_frags(xdp)))
+		goto out;
+
+	list_for_each_entry_safe(pos, tmp, &xskb->xskb_list, xskb_list_node) {
+		list_del(&pos->xskb_list_node);
+		xp_free(pos);
+	}
+
+	xdp_get_shared_info_from_buff(xdp)->nr_frags = 0;
+out:
 	xp_free(xskb);
 }
 
+static inline void xsk_buff_add_frag(struct xdp_buff *first,
+				     struct xdp_buff *xdp)
+{
+	struct xdp_buff_xsk *xskb = container_of(first, struct xdp_buff_xsk, xdp);
+	struct xdp_buff_xsk *frag = container_of(xdp, struct xdp_buff_xsk, xdp);
+
+	list_add_tail(&frag->xskb_list_node, &xskb->xskb_list);
+}
+
+static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
+{
+	struct xdp_buff_xsk *xskb = container_of(first, struct xdp_buff_xsk, xdp);
+	struct xdp_buff *ret = NULL;
+	struct xdp_buff_xsk *frag;
+
+	frag = list_first_entry_or_null(&xskb->xskb_list, struct xdp_buff_xsk,
+					xskb_list_node);
+	if (frag) {
+		list_del(&frag->xskb_list_node);
+		ret = &frag->xdp;
+	}
+
+	return ret;
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
@@ -265,6 +301,16 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 }
 
+static inline void xsk_buff_add_frag(struct xdp_buff *first,
+				     struct xdp_buff *xdp)
+{
+}
+
+static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
+{
+	return NULL;
+}
+
 static inline void xsk_buff_discard(struct xdp_buff *xdp)
 {
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 4dcca163e076..8a430163512c 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -29,6 +29,8 @@ struct xdp_buff_xsk {
 	struct xsk_buff_pool *pool;
 	u64 orig_addr;
 	struct list_head free_list_node;
+	struct list_head xskb_list_node;
+	struct list_head xskb_list;
 };
 
 #define XSK_CHECK_PRIV_TYPE(t) BUILD_BUG_ON(sizeof(t) > offsetofend(struct xdp_buff_xsk, cb))
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index bc8dbd9f5312..b519fe4456bc 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -155,8 +155,30 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
 static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
+	u32 frags = xdp_buff_has_frags(xdp);
+	struct xdp_buff_xsk *pos, *tmp;
+	u32 contd = 0;
+	int err;
+
+	if (frags)
+		contd = XDP_PKT_CONTD;
 
-	return __xsk_rcv_zc(xs, xskb, len, 0);
+	err = __xsk_rcv_zc(xs, xskb, len, contd);
+	if (err || likely(!frags))
+		goto out;
+
+	list_for_each_entry_safe(pos, tmp, &xskb->xskb_list, xskb_list_node) {
+		if (list_is_singular(&xskb->xskb_list))
+			contd = 0;
+		len = pos->xdp.data_end - pos->xdp.data;
+		err = __xsk_rcv_zc(xs, pos, len, contd);
+		if (err)
+			return err;
+		list_del(&pos->xskb_list_node);
+	}
+
+out:
+	return err;
 }
 
 static void *xsk_copy_xdp_start(struct xdp_buff *from)
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 26f6d304451e..0a9f8ea68de3 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -99,6 +99,8 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		xskb->pool = pool;
 		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
 		INIT_LIST_HEAD(&xskb->free_list_node);
+		INIT_LIST_HEAD(&xskb->xskb_list_node);
+		INIT_LIST_HEAD(&xskb->xskb_list);
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-- 
2.35.3


