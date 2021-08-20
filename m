Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642C83F3042
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbhHTP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:53677 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240865AbhHTP4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:56:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10082"; a="197050456"
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="197050456"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 08:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="680126979"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2021 08:55:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Yee Li <seven.yi.lee@gmail.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 3/4] e1000e: Fix the max snoop/no-snoop latency for 10M
Date:   Fri, 20 Aug 2021 08:59:14 -0700
Message-Id: <20210820155915.1119889-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
References: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We should decode the latency and the max_latency before directly compare.
The latency should be presented as lat_enc = scale x value:
lat_enc_d = (lat_enc & 0x0x3ff) x (1U << (5*((max_ltr_enc & 0x1c00)
>> 10)))

Fixes: cf8fb73c23aa ("e1000e: add support for LTR on I217/I218")
Suggested-by: Yee Li <seven.yi.lee@gmail.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 14 +++++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index cf7b3887da1d..2c412bf9232a 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1006,6 +1006,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
+	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u16 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
@@ -1059,7 +1061,17 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 				     E1000_PCI_LTR_CAP_LPT + 2, &max_nosnoop);
 		max_ltr_enc = max_t(u16, max_snoop, max_nosnoop);
 
-		if (lat_enc > max_ltr_enc)
+		lat_enc_d = (lat_enc & E1000_LTRV_VALUE_MASK) *
+			     (1U << (E1000_LTRV_SCALE_FACTOR *
+			     ((lat_enc & E1000_LTRV_SCALE_MASK)
+			     >> E1000_LTRV_SCALE_SHIFT)));
+
+		max_ltr_enc_d = (max_ltr_enc & E1000_LTRV_VALUE_MASK) *
+				 (1U << (E1000_LTRV_SCALE_FACTOR *
+				 ((max_ltr_enc & E1000_LTRV_SCALE_MASK)
+				 >> E1000_LTRV_SCALE_SHIFT)));
+
+		if (lat_enc_d > max_ltr_enc_d)
 			lat_enc = max_ltr_enc;
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 1502895eb45d..e757896287eb 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -274,8 +274,11 @@
 
 /* Latency Tolerance Reporting */
 #define E1000_LTRV			0x000F8
+#define E1000_LTRV_VALUE_MASK		0x000003FF
 #define E1000_LTRV_SCALE_MAX		5
 #define E1000_LTRV_SCALE_FACTOR		5
+#define E1000_LTRV_SCALE_SHIFT		10
+#define E1000_LTRV_SCALE_MASK		0x00001C00
 #define E1000_LTRV_REQ_SHIFT		15
 #define E1000_LTRV_NOSNOOP_SHIFT	16
 #define E1000_LTRV_SEND			(1 << 30)
-- 
2.26.2

