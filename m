Return-Path: <netdev+bounces-11203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA35731F1F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8800328155A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B876F2E0E2;
	Thu, 15 Jun 2023 17:27:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD041ACA0;
	Thu, 15 Jun 2023 17:27:08 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83972964;
	Thu, 15 Jun 2023 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850022; x=1718386022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e7qtKIU7qxpxshvWWEzij/oKOwc+QxhWYqmnBkTZl/M=;
  b=PrUHD6G7PUmQvrWwe4wylWDEU6wS+csSV7hGapVBzDe6QQRCNoqme+Db
   e52ydf2yFBglvtHWZAQYG7J7gAAR1JOeSSxBIwaWjsQKpmx/FGU9zmja2
   f8bNLC+eoIB4KYwmDDyj/7dzFTVvL1BMood1Aqc+sdnAk7NbnyBIEoNhL
   55/rpTROHWUtAjE+irVEOdQ1u/BcagMJxQAB6nYCS8RoYGvBUZC0y5TMc
   i2Yd8+wYZKc+rd7WclP+Ez36dXswENJtUjQwBwagfnT9/sYqhXjF9K514
   4QzouMSu3fee32R/gcNbVtBjwH/EP2sJ7skPIKpov1ZH1EVO6Kng3Yy/l
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983585"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983585"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:26:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689858756"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689858756"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:26:50 -0700
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
Subject: [PATCH v4 bpf-next 13/22] xsk: report zero-copy multi-buffer capability via xdp_features
Date: Thu, 15 Jun 2023 19:25:57 +0200
Message-Id: <20230615172606.349557-14-maciej.fijalkowski@intel.com>
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

Introduce new xdp_feature NETDEV_XDP_ACT_ZC_SG that will be used to
find out if user space that wants to do ZC multi-buffer will be able to
do so against underlying ZC driver.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 Documentation/netlink/specs/netdev.yaml | 5 +++++
 include/uapi/linux/netdev.h             | 5 ++++-
 net/xdp/xsk_buff_pool.c                 | 6 ++++++
 tools/include/uapi/linux/netdev.h       | 5 ++++-
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index b99e7ffef7a1..ba69c3196980 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -42,6 +42,11 @@ definitions:
         doc:
           This feature informs if netdev implements non-linear XDP buffer
           support in ndo_xdp_xmit callback.
+      -
+        name: zc-sg
+        doc:
+          This feature informs if netdev implements non-linear XDP buffer
+          support in zero-copy mode.
 
 attribute-sets:
   -
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 639524b59930..1f0bf76dade6 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -24,6 +24,8 @@
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
  *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_ZC_SG: This feature informs if netdev implements non-linear
+ *   XDP buffer support in zero-copy mode.
  */
 enum netdev_xdp_act {
 	NETDEV_XDP_ACT_BASIC = 1,
@@ -33,8 +35,9 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+	NETDEV_XDP_ACT_ZC_SG = 128,
 
-	NETDEV_XDP_ACT_MASK = 127,
+	NETDEV_XDP_ACT_MASK = 255,
 };
 
 enum {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 6e2ed66fd430..f3102835803d 100644
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
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 639524b59930..1f0bf76dade6 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -24,6 +24,8 @@
  *   XDP buffer support in the driver napi callback.
  * @NETDEV_XDP_ACT_NDO_XMIT_SG: This feature informs if netdev implements
  *   non-linear XDP buffer support in ndo_xdp_xmit callback.
+ * @NETDEV_XDP_ACT_ZC_SG: This feature informs if netdev implements non-linear
+ *   XDP buffer support in zero-copy mode.
  */
 enum netdev_xdp_act {
 	NETDEV_XDP_ACT_BASIC = 1,
@@ -33,8 +35,9 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+	NETDEV_XDP_ACT_ZC_SG = 128,
 
-	NETDEV_XDP_ACT_MASK = 127,
+	NETDEV_XDP_ACT_MASK = 255,
 };
 
 enum {
-- 
2.34.1


