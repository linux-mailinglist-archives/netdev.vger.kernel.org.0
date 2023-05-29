Return-Path: <netdev+bounces-6112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ADD9714D65
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 424BD1C20A41
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3196CAD2E;
	Mon, 29 May 2023 15:50:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364AA94C;
	Mon, 29 May 2023 15:50:38 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF61D2;
	Mon, 29 May 2023 08:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375437; x=1716911437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkI+u7NjR1z5LPEwmE3rD1pz9rJqcDwtVBQ+0mhO1zE=;
  b=GMrM6KESsBpmKGiYjcxzyRYBBhSXi/UHnysaZO/79Y2Bd17fQP8acPh+
   8QCOdrhi0PO+ccDsKWBFI5E671tUT4JgrJ8VXYB8cHh2y5Nkp+cuHR12M
   L9NY5BAj9RXZn+bftnAordGqHmieoXk463F8Q3DP1YCG02tvoE55swG2r
   dTNPXBYgZr1cL0w4Xkq296KJJYhsV/z20PCtedsmlUUWJB3NouvWH/TnP
   8iPrOIwqIOfcmGdXA65zAM+Q2cFFwGA68v9WJJ7pvr4l0QzQGAC/hIKL4
   ftxcZkpKZzj5s7kkoHOOI6eVTlPeJG2350cn4yQ65JRlzRMPeqqoMVIhI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344228975"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344228975"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:50:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441019"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441019"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:50:34 -0700
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
Subject: [PATCH v2 bpf-next 03/22] xsk: prepare both copy and zero-copy modes to co-exist
Date: Mon, 29 May 2023 17:50:05 +0200
Message-Id: <20230529155024.222213-4-maciej.fijalkowski@intel.com>
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

Currently, __xsk_rcv_zc() is a function that is responsible for
producing AF_XDP Rx descriptors. It is used by both copy and zero-copy
mode. Both of these modes are going to differ when multi-buffer support
is going to be added. ZC will work on a chain of xdp_buff_xsk structs
whereas copy-mode is going to utilize skb_shared_info contents. This
means that ZC-specific changes would affect the copy mode.

Let's modify __xsk_rcv_zc() to work directly on xdp_buff_xsk so the
callsites have to retrieve this from xdp_buff. Also, introduce
xsk_rcv_zc() which will carry all the needed later changes for
supporting multi-buffer on ZC side that do not apply to copy mode.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 62d49a81d5f6..3a68988dd06f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -135,9 +135,9 @@ int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 	return 0;
 }
 
-static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len, u32 flags)
+static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
+			u32 flags)
 {
-	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
 	u64 addr;
 	int err;
 
@@ -152,6 +152,13 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len, u32
 	return 0;
 }
 
+static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
+{
+	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
+
+	return __xsk_rcv_zc(xs, xskb, len, 0);
+}
+
 static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 {
 	void *from_buf, *to_buf;
@@ -172,6 +179,7 @@ static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 
 static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
+	struct xdp_buff_xsk *xskb;
 	struct xdp_buff *xsk_xdp;
 	int err;
 	u32 len;
@@ -189,7 +197,8 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	}
 
 	xsk_copy_xdp(xsk_xdp, xdp, len);
-	err = __xsk_rcv_zc(xs, xsk_xdp, len, 0);
+	xskb = container_of(xsk_xdp, struct xdp_buff_xsk, xdp);
+	err = __xsk_rcv_zc(xs, xskb, len, 0);
 	if (err) {
 		xsk_buff_free(xsk_xdp);
 		return err;
@@ -259,7 +268,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 
 	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
 		len = xdp->data_end - xdp->data;
-		return __xsk_rcv_zc(xs, xdp, len, 0);
+		return xsk_rcv_zc(xs, xdp, len);
 	}
 
 	err = __xsk_rcv(xs, xdp);
-- 
2.35.3


