Return-Path: <netdev+bounces-6122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2C2714D8F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 718B11C20A6C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876131119A;
	Mon, 29 May 2023 15:51:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576411196;
	Mon, 29 May 2023 15:51:02 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF40CF;
	Mon, 29 May 2023 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375460; x=1716911460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KIxYAJTX1HXf9qG9oPpa2qNiCKMKWw47fIZSNt4aIhU=;
  b=YmXicTpn7dSrRg93rYI6JwWmxN41eyuYHK6oJs4G3v8CZunL/i8eRhLt
   zCD14zuqdivBSB6J6n2kAIDGAutWjgJ3594WGSsqSh+20XKrurhFjrlz3
   xGMU5rR/3X2k4duaFfwXoCb5gu9AoTDWnD4ffMk3sD6LZIexT536zFa1p
   P4dzi/mCIA/ng526KY7ZWfgy+OwSQVpWAzEM2bPbgaiwcCVUnbZpIfLa2
   +E12j3XQggV0zx1lSCc4EuTl069ndXwcSLTz1rXthHzgIt6LE5GGGBZq3
   t30utdWNKjI8V68yqWcQtrj/2TPffqPcJ+MhxRfntd9wRZtlBPtO+hdB5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229035"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229035"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:51:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441159"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441159"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:50:58 -0700
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
Subject: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability via xdp_features
Date: Mon, 29 May 2023 17:50:15 +0200
Message-Id: <20230529155024.222213-14-maciej.fijalkowski@intel.com>
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

Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
find out if user space that wants to do ZC multi-buffer will be able to
do so against underlying ZC driver.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/uapi/linux/netdev.h | 4 ++--
 net/xdp/xsk_buff_pool.c     | 6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..bfca07224f7b 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -33,8 +33,8 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
-
-	NETDEV_XDP_ACT_MASK = 127,
+	NETDEV_XDP_ACT_NDO_ZC_SG = 128,
+	NETDEV_XDP_ACT_MASK = 255,
 };
 
 enum {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 0a9f8ea68de3..43cca5fa90cf 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -189,6 +189,12 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		goto err_unreg_pool;
 	}
 
+	if (!(netdev->xdp_features & NETDEV_XDP_ACT_NDO_ZC_SG) &&
+	    flags & XDP_USE_SG) {
+		err = -EOPNOTSUPP;
+		goto err_unreg_pool;
+	}
+
 	bpf.command = XDP_SETUP_XSK_POOL;
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
-- 
2.35.3


