Return-Path: <netdev+bounces-3406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 389F4706EE9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA29B281248
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2737924EA0;
	Wed, 17 May 2023 16:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D6442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:23 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E175BBD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342759; x=1715878759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=38+aBYL1bNV11C9ufDOC2zVeSJh5Oz4L12PT57lrWJk=;
  b=OcyPsu6/hgYrGytXAG3ozh5sJNMTcIJAP66RsPow2vsrGwlXOpsv9132
   aVS/IjHCCvNjBI7N73nr/pubE04K3YmraKQVvhkDPLbVzHiQ94YtdDTOJ
   i7XnAPk+ZAtNQC4XgvXhg05F3ZPQP/QkFJzA1n/H7DI7OGKbs+Y0YERUX
   NA95d5bmGab6JQnz88uGzq7lL6lExfKXqpothdbFE+j5DKbRSC+OYxEba
   HqhJb7SoK/qHK5R+l2FSqqUrAO1vMbhbHKOBzB4q6kPdCJx/kr1z90guG
   aFA/GvM84c9l5qkSVPbmaDed+wSAMixQtJxzmNkoLba1v0YE42XVU1kni
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011553"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011553"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876776"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876776"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:16 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Paul Greenwalt <paul.greenwalt@intel.com>,
	anthony.l.nguyen@intel.com,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 3/5] ice: update PHY type to ethtool link mode mapping
Date: Wed, 17 May 2023 09:55:28 -0700
Message-Id: <20230517165530.3179965-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Paul Greenwalt <paul.greenwalt@intel.com>

Some link modes can be more accurately reported due to newer link mode
values that have been added to the kernel; update those PHY type to report
modes that better reflect the link mode.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.h | 38 ++++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.h b/drivers/net/ethernet/intel/ice/ice_ethtool.h
index 00043ea9469a..b403ee79cd5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.h
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.h
@@ -36,11 +36,11 @@ phy_type_low_lkup[] = {
 	[10] = ICE_PHY_TYPE(5GB, 5000baseT_Full),
 	[11] = ICE_PHY_TYPE(5GB, 5000baseT_Full),
 	[12] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
-	[13] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
+	[13] = ICE_PHY_TYPE(10GB, 10000baseCR_Full),
 	[14] = ICE_PHY_TYPE(10GB, 10000baseSR_Full),
 	[15] = ICE_PHY_TYPE(10GB, 10000baseLR_Full),
 	[16] = ICE_PHY_TYPE(10GB, 10000baseKR_Full),
-	[17] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
+	[17] = ICE_PHY_TYPE(10GB, 10000baseCR_Full),
 	[18] = ICE_PHY_TYPE(10GB, 10000baseKR_Full),
 	[19] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
 	[20] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
@@ -51,36 +51,36 @@ phy_type_low_lkup[] = {
 	[25] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
 	[26] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
 	[27] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
-	[28] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
-	[29] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
+	[28] = ICE_PHY_TYPE(25GB, 25000baseSR_Full),
+	[29] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
 	[30] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
 	[31] = ICE_PHY_TYPE(40GB, 40000baseSR4_Full),
 	[32] = ICE_PHY_TYPE(40GB, 40000baseLR4_Full),
 	[33] = ICE_PHY_TYPE(40GB, 40000baseKR4_Full),
-	[34] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
+	[34] = ICE_PHY_TYPE(40GB, 40000baseSR4_Full),
 	[35] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
 	[36] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
 	[37] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
 	[38] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
 	[39] = ICE_PHY_TYPE(50GB, 50000baseKR2_Full),
-	[40] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[40] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
 	[41] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
-	[42] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[42] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
 	[43] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
-	[44] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
-	[45] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
-	[46] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
-	[47] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
-	[48] = ICE_PHY_TYPE(50GB, 50000baseKR2_Full),
-	[49] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
-	[50] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[44] = ICE_PHY_TYPE(50GB, 50000baseCR_Full),
+	[45] = ICE_PHY_TYPE(50GB, 50000baseSR_Full),
+	[46] = ICE_PHY_TYPE(50GB, 50000baseLR_ER_FR_Full),
+	[47] = ICE_PHY_TYPE(50GB, 50000baseLR_ER_FR_Full),
+	[48] = ICE_PHY_TYPE(50GB, 50000baseKR_Full),
+	[49] = ICE_PHY_TYPE(50GB, 50000baseSR_Full),
+	[50] = ICE_PHY_TYPE(50GB, 50000baseCR_Full),
 	[51] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
 	[52] = ICE_PHY_TYPE(100GB, 100000baseSR4_Full),
 	[53] = ICE_PHY_TYPE(100GB, 100000baseLR4_ER4_Full),
 	[54] = ICE_PHY_TYPE(100GB, 100000baseKR4_Full),
 	[55] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
 	[56] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
-	[57] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[57] = ICE_PHY_TYPE(100GB, 100000baseSR4_Full),
 	[58] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
 	[59] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
 	[60] = ICE_PHY_TYPE(100GB, 100000baseKR4_Full),
@@ -96,10 +96,10 @@ phy_type_low_lkup[] = {
 static const struct ice_phy_type_to_ethtool
 phy_type_high_lkup[] = {
 	[0] = ICE_PHY_TYPE(100GB, 100000baseKR2_Full),
-	[1] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
-	[2] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
-	[3] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
-	[4] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[1] = ICE_PHY_TYPE(100GB, 100000baseSR2_Full),
+	[2] = ICE_PHY_TYPE(100GB, 100000baseCR2_Full),
+	[3] = ICE_PHY_TYPE(100GB, 100000baseSR2_Full),
+	[4] = ICE_PHY_TYPE(100GB, 100000baseCR2_Full),
 };
 
 #endif /* !_ICE_ETHTOOL_H_ */
-- 
2.38.1


