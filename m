Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D03B3558
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhFXSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:14:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:28682 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232469AbhFXSOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:14:09 -0400
IronPort-SDR: a8swSL3lxwp2B25icBQOZNKeS3zDAvgQguJ7HgB42JOncfo8qqsK9ATL8Z+3datNd0vGqI4wle
 jGyh6yw++K1w==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="271382696"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="271382696"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 11:11:47 -0700
IronPort-SDR: jUoe1GjV+n2v5NNva2+r4pfRME9LnaaEpfEDF/0TZ0hP1tjPPX0Qnn8gUCqTdINV8tg/zVOmnu
 k3tvsval4UdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487866630"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2021 11:11:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, stable@vger.kernel.org,
        Alex Sergeev <asergeev@carbonrobotics.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/4] i40e: fix PTP on 5Gb links
Date:   Thu, 24 Jun 2021 11:14:33 -0700
Message-Id: <20210624181434.751511-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
References: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

As reported by Alex Sergeev, the i40e driver is incrementing the PTP
clock at 40Gb speeds when linked at 5Gb. Fix this bug by making
sure that the right multiplier is selected when linked at 5Gb.

Fixes: 3dbdd6c2f70a ("i40e: Add support for 5Gbps cards")
Cc: stable@vger.kernel.org
Reported-by: Alex Sergeev <asergeev@carbonrobotics.com>
Suggested-by: Alex Sergeev <asergeev@carbonrobotics.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index f1f6fc3744e9..7b971b205d36 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -11,13 +11,14 @@
  * operate with the nanosecond field directly without fear of overflow.
  *
  * Much like the 82599, the update period is dependent upon the link speed:
- * At 40Gb link or no link, the period is 1.6ns.
- * At 10Gb link, the period is multiplied by 2. (3.2ns)
+ * At 40Gb, 25Gb, or no link, the period is 1.6ns.
+ * At 10Gb or 5Gb link, the period is multiplied by 2. (3.2ns)
  * At 1Gb link, the period is multiplied by 20. (32ns)
  * 1588 functionality is not supported at 100Mbps.
  */
 #define I40E_PTP_40GB_INCVAL		0x0199999999ULL
 #define I40E_PTP_10GB_INCVAL_MULT	2
+#define I40E_PTP_5GB_INCVAL_MULT	2
 #define I40E_PTP_1GB_INCVAL_MULT	20
 
 #define I40E_PRTTSYN_CTL1_TSYNTYPE_V1  BIT(I40E_PRTTSYN_CTL1_TSYNTYPE_SHIFT)
@@ -465,6 +466,9 @@ void i40e_ptp_set_increment(struct i40e_pf *pf)
 	case I40E_LINK_SPEED_10GB:
 		mult = I40E_PTP_10GB_INCVAL_MULT;
 		break;
+	case I40E_LINK_SPEED_5GB:
+		mult = I40E_PTP_5GB_INCVAL_MULT;
+		break;
 	case I40E_LINK_SPEED_1GB:
 		mult = I40E_PTP_1GB_INCVAL_MULT;
 		break;
-- 
2.26.2

