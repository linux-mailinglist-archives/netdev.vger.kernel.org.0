Return-Path: <netdev+bounces-8055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 865E2722926
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E631C20A09
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB751F92C;
	Mon,  5 Jun 2023 14:45:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06E1F92B;
	Mon,  5 Jun 2023 14:45:08 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC759E;
	Mon,  5 Jun 2023 07:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976307; x=1717512307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wLt5cFhr6dUJTNj++uS4GYd0eezKpS66tJZvL1PiiTc=;
  b=KphTMx6G9wWL82AbQUi++KQkMgcYEvfQUyoIEN/y6WHb1kW/HnIBi1fN
   Ppnfc4wkUEFd/4M+BdrB3SRIptBN3C7/UQ8ZxdkJTwwrvp6u0XyIkD9DD
   odrm/Xpw2VxInS3E9K3hKs/ITbbogqWu2pkagZj1nY6xtVaFf1vwVx1fs
   f9XvbGfqSFHLa0imUPqr4nPcukMIp+njXqnblPIL9xws6GV5eq57QqUT3
   84MJcKIQc1GSiC7lzRHPfOL4uQBhQ9vZrh4Amj1RgFCNxuJqdYIi+f6CI
   YMtQEC0trHUWTTLnCuKG0dyASOxHFikYCMn4yMqZwLNE7tt97zDi+f+O+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442757825"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442757825"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464123"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464123"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:04 -0700
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
	simon.horman@corigine.com
Subject: [PATCH v3 bpf-next 04/22] xsk: move xdp_buff's data length check to xsk_rcv_check
Date: Mon,  5 Jun 2023 16:44:15 +0200
Message-Id: <20230605144433.290114-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
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

If the data in xdp_buff exceeds the xsk frame length, the packet needs
to be dropped. This check is currently being done in __xsk_rcv(). Move
the described logic to xsk_rcv_check() so that such a xdp_buff will
only be dropped if the application does not support multi-buffer
(absence of XDP_USE_SG bind flag). This is applicable for all cases:
copy mode, zero copy mode as well as skb mode.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 net/xdp/xsk.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3a68988dd06f..22eeb7f6ac05 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -177,18 +177,11 @@ static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 	memcpy(to_buf, from_buf, len + metalen);
 }
 
-static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	struct xdp_buff_xsk *xskb;
 	struct xdp_buff *xsk_xdp;
 	int err;
-	u32 len;
-
-	len = xdp->data_end - xdp->data;
-	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
-		xs->rx_dropped++;
-		return -ENOSPC;
-	}
 
 	xsk_xdp = xsk_buff_alloc(xs->pool);
 	if (!xsk_xdp) {
@@ -224,7 +217,7 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 	return false;
 }
 
-static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
+static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	if (!xsk_is_bound(xs))
 		return -ENXIO;
@@ -232,6 +225,11 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
+	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
+		xs->rx_dropped++;
+		return -ENOSPC;
+	}
+
 	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
 	return 0;
 }
@@ -245,12 +243,13 @@ static void xsk_flush(struct xdp_sock *xs)
 
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
+	u32 len = xdp_get_buff_len(xdp);
 	int err;
 
 	spin_lock_bh(&xs->rx_lock);
-	err = xsk_rcv_check(xs, xdp);
+	err = xsk_rcv_check(xs, xdp, len);
 	if (!err) {
-		err = __xsk_rcv(xs, xdp);
+		err = __xsk_rcv(xs, xdp, len);
 		xsk_flush(xs);
 	}
 	spin_unlock_bh(&xs->rx_lock);
@@ -259,10 +258,10 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 
 static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
+	u32 len = xdp_get_buff_len(xdp);
 	int err;
-	u32 len;
 
-	err = xsk_rcv_check(xs, xdp);
+	err = xsk_rcv_check(xs, xdp, len);
 	if (err)
 		return err;
 
@@ -271,7 +270,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		return xsk_rcv_zc(xs, xdp, len);
 	}
 
-	err = __xsk_rcv(xs, xdp);
+	err = __xsk_rcv(xs, xdp, len);
 	if (!err)
 		xdp_return_buff(xdp);
 	return err;
-- 
2.34.1


