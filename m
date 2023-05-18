Return-Path: <netdev+bounces-3728-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E31B970877B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F5E7281A51
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AC828C2F;
	Thu, 18 May 2023 18:06:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64CD28C19;
	Thu, 18 May 2023 18:06:01 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B65C2;
	Thu, 18 May 2023 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433160; x=1715969160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JNw2+5ey9ocL32lJ1PKr+CnICVACGjPFwW5GuE1o/fA=;
  b=JF7fBUlrmrprvh7GpZHx6SmgVRClI3KHK6NdUt8hUgVBOyunrZmebA7n
   IJnn7DwWqX/klF4shZYa088yXujiRhT4H2BXqAU8JjkDJjKjs364CT8QC
   gmOpNPcHu8JbBBTmLYW0oCF9fIhzsG8GsF/wfbtHaJQ9C9JjvaATzByIr
   FrwAaU4sOHrAMZkmYwczOjFrVpunsquhEtYaCHPQJ1JgBjkQrO+m3Oixv
   9Z4C9DPsh0fmt86AyTJEpKdXdZ7v2N0NNliZd7ijmSDYCoyZZdHy7fa2x
   WO+8mc4yz5Gyhd/56wkmrY+ksfpRxFxH/m3tK5nRsI5cLQW2KtdNa1QDI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984709"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984709"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780116"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780116"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:05:56 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 02/21] xsk: introduce XSK_USE_SG bind flag for xsk socket
Date: Thu, 18 May 2023 20:05:26 +0200
Message-Id: <20230518180545.159100-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

As of now xsk core drops any xdp_buff with data size greater than the
xsk frame_size as set by the af_xdp application. With multi-buffer
support introduced in the next patch xsk core can now split those
buffers into multiple descriptors provided the af_xdp application can
handle them. Such capability of the application needs to be independent
of the xdp_prog's frag support capability since there are cases where
even a single xdp_buffer may need to be split into multiple descriptors
owing to a smaller xsk frame size.

For e.g., with NIC rx_buffer size set to 4kB, a 3kB packet will
constitute of a single buffer and so will be sent as such to AF_XDP layer
irrespective of 'xdp.frags' capability of the XDP program. Now if the xsk
frame size is set to 2kB by the AF_XDP application, then the packet will
need to be split into 2 descriptors if AF_XDP application can handle
multi-buffer, else it needs to be dropped.

Applications can now advertise their frag handling capability to xsk core
so that xsk core can decide if it should drop or split xdp_buffs that
exceed xsk frame size. This is done using a new 'XSK_USE_SG' bind flag
for the xdp socket.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 include/net/xdp_sock.h      | 1 +
 include/uapi/linux/if_xdp.h | 6 ++++++
 net/xdp/xsk.c               | 5 +++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e96a1151ec75..36b0411a0d1b 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -52,6 +52,7 @@ struct xdp_sock {
 	struct xsk_buff_pool *pool;
 	u16 queue_id;
 	bool zc;
+	bool sg;
 	enum {
 		XSK_READY = 0,
 		XSK_BOUND,
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index 4acc3a9430f3..870c18f96365 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -25,6 +25,12 @@
  * application.
  */
 #define XDP_USE_NEED_WAKEUP (1 << 3)
+/* By setting this option, userspace application indicates that it can
+ * handle multiple descriptors per packet thus enabling AF_XDP to split
+ * multi-buffer XDP frames into multiple Rx descriptors. Without this set
+ * such frames will be dropped.
+ */
+#define XDP_USE_SG	(1 << 4)
 
 /* Flags for xsk_umem_config flags */
 #define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << 0)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 99f90a0d04ae..62d49a81d5f6 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -896,7 +896,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 
 	flags = sxdp->sxdp_flags;
 	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY |
-		      XDP_USE_NEED_WAKEUP))
+		      XDP_USE_NEED_WAKEUP | XDP_USE_SG))
 		return -EINVAL;
 
 	rtnl_lock();
@@ -924,7 +924,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		struct socket *sock;
 
 		if ((flags & XDP_COPY) || (flags & XDP_ZEROCOPY) ||
-		    (flags & XDP_USE_NEED_WAKEUP)) {
+		    (flags & XDP_USE_NEED_WAKEUP) || (flags & XDP_USE_SG)) {
 			/* Cannot specify flags for shared sockets. */
 			err = -EINVAL;
 			goto out_unlock;
@@ -1023,6 +1023,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
+	xs->sg = !!(flags & XDP_USE_SG);
 	xs->queue_id = qid;
 	xp_add_xsk(xs->pool, xs);
 
-- 
2.34.1


