Return-Path: <netdev+bounces-11192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84608731EF0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F5C82813E6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2EF2E0E5;
	Thu, 15 Jun 2023 17:26:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407522E0D3;
	Thu, 15 Jun 2023 17:26:26 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265392726;
	Thu, 15 Jun 2023 10:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686849983; x=1718385983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4h+jo/EkKRbleCDyiS1u9LX45vmcVceHMMKO4uZk5FQ=;
  b=XBUlc+Vx6ovAor0A7e92CdPtdA3gPQhTdNJ3QtP/thx0e2ippGM7LREZ
   rrR5V3i8ROwqcvt37UiXMzqOfNBKr8nE9vKUyI8gDAyWMKQ7LJGTuiTEx
   M2cOVRZaAQgGsmoPgjQLBefKMJnbgQv68qtqQezR93J4UGFnXLv9Ymurl
   QKUPlQ/DjrBp+Dz1lDgeVVi7N8wOOGdr0fglKn/YeQ3llzwN4lya2pfDm
   lOaVHV+iJ8cl2QW7iaYY5MQeYXg1BPep9hcI2lwRrwIqB5ZLN/TDBjggs
   oBc7AuAEu5FloPSrKJ01diPpaWDloMXYOHanMUIoq3kkKTU+60tpW1yi2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983461"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983461"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689858366"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689858366"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:26:19 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	simon.horman@corigine.com,
	toke@kernel.org
Subject: [PATCH v4 bpf-next 02/22] xsk: introduce XSK_USE_SG bind flag for xsk socket
Date: Thu, 15 Jun 2023 19:25:46 +0200
Message-Id: <20230615172606.349557-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
References: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
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
index 434f313dc26c..8d48863472b9 100644
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


