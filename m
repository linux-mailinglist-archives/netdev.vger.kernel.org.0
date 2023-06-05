Return-Path: <netdev+bounces-8064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A14E37229C7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F07321C20BF6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C7022630;
	Mon,  5 Jun 2023 14:45:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241E922618;
	Mon,  5 Jun 2023 14:45:32 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A3E8;
	Mon,  5 Jun 2023 07:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976330; x=1717512330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Qase7JJmutlzYwh4VhOq7pZqgKUCT2RYdn1g4fXJiI=;
  b=IFWrxbFVhQgPflkvSVudJowwr1JTY3U71rzrjOlZgvY83TN/ytxgbHPl
   efTYaNDs3gtssRbYIL/S/25Su1jF/5F/z37FBLqnNcLpjxyr+lO8Qd9+S
   wNVCXIrZ9gfroJWcS5MijSj39mcCJbciPCe1lZEyaz95IQRCVDO98XEKq
   8OCYauE+TYZXfSCLFYZfLOeCIe/9mFldmHK/YlLRs3N10ASwej3oLlJRd
   f6j6j9aGzoNTTOR0LpPzqej5WFlten8a41fZ8OnJ2XgrEjRPHsCuPvGpA
   X7Y0i43iDSFVF3HZ5v3J+foMrR7ycOSKFYFf0zN7r576yfpVU91IIf2rS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442757959"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442757959"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464304"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464304"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:28 -0700
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
Subject: [PATCH v3 bpf-next 13/22] xsk: report zero-copy multi-buffer capability via xdp_features
Date: Mon,  5 Jun 2023 16:44:24 +0200
Message-Id: <20230605144433.290114-14-maciej.fijalkowski@intel.com>
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

Introduce new xdp_feature NETDEV_XDP_ACT_ZC_SG that will be used to
find out if user space that wants to do ZC multi-buffer will be able to
do so against underlying ZC driver.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/uapi/linux/netdev.h | 6 ++++--
 net/xdp/xsk_buff_pool.c     | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..c293014a4197 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -24,6 +24,8 @@
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
  *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_ZC_SG: This feature informs if netdev implements
+ *   non-linear XDP buffer support in AF_XDP zero copy mode.
  */
 enum netdev_xdp_act {
 	NETDEV_XDP_ACT_BASIC = 1,
@@ -33,8 +35,8 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
-
-	NETDEV_XDP_ACT_MASK = 127,
+	NETDEV_XDP_ACT_ZC_SG = 128,
+	NETDEV_XDP_ACT_MASK = 255,
 };
 
 enum {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 0a9f8ea68de3..c8d65e5883ec 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -189,6 +189,12 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		goto err_unreg_pool;
 	}
 
+	if (!(netdev->xdp_features & NETDEV_XDP_ACT_ZC_SG) &&
+	    flags & XDP_USE_SG) {
+		err = -EOPNOTSUPP;
+		goto err_unreg_pool;
+	}
+
 	bpf.command = XDP_SETUP_XSK_POOL;
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
-- 
2.34.1


