Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C904761D1
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhLOTft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:35:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:59490 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhLOTfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639596948; x=1671132948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzjaHAIvcRP/eZo4F6Zu9IwnCEGr7i0Km6/rkFmhL6M=;
  b=YI6FPuylOCX2oPaJkPOFes+voOCa8Tsce0AlTjQMSu4MPcPY6cTo++uH
   798nfQUOkHzSW/B/EW7yJwSzRxurSEXpRQ56GUPycv2kLG/gtPQhatmVM
   pKStPMG27ymysMjTEixcbXoA8GZIVFDyYGuRT60NQWMYMxjzyKfKLjPdw
   UApo2FQHlsPPq95nEu6fck5DBATHn1fzlVpBPJvtwQm9f6VufLDu93AM5
   jgIvgaGPcYjVGHMSedGRoqLuctY/OTD6zcYUfKQCp3ChmVi9z7Bn7kmxC
   p+aORLUITOu08wM7TxVL2TBesHRRQGOkvVSnSf1yW2ybPrGPvlnqDdv9n
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236856407"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236856407"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 11:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465746691"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 11:35:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vinschen@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/5] igb: Fix removal of unicast MAC filters of VFs
Date:   Wed, 15 Dec 2021 11:34:30 -0800
Message-Id: <20211215193434.3253664-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
References: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Move checking condition of VF MAC filter before clearing
or adding MAC filter to VF to prevent potential blackout caused
by removal of necessary and working VF's MAC filter.

Fixes: 1b8b062a99dc ("igb: add VF trust infrastructure")
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index fd54d3ef890b..b597b8bfb910 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7648,6 +7648,20 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
 	struct vf_mac_filter *entry = NULL;
 	int ret = 0;
 
+	if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
+	    !vf_data->trusted) {
+		dev_warn(&pdev->dev,
+			 "VF %d requested MAC filter but is administratively denied\n",
+			  vf);
+		return -EINVAL;
+	}
+	if (!is_valid_ether_addr(addr)) {
+		dev_warn(&pdev->dev,
+			 "VF %d attempted to set invalid MAC filter\n",
+			  vf);
+		return -EINVAL;
+	}
+
 	switch (info) {
 	case E1000_VF_MAC_FILTER_CLR:
 		/* remove all unicast MAC filters related to the current VF */
@@ -7661,20 +7675,6 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
 		}
 		break;
 	case E1000_VF_MAC_FILTER_ADD:
-		if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
-		    !vf_data->trusted) {
-			dev_warn(&pdev->dev,
-				 "VF %d requested MAC filter but is administratively denied\n",
-				 vf);
-			return -EINVAL;
-		}
-		if (!is_valid_ether_addr(addr)) {
-			dev_warn(&pdev->dev,
-				 "VF %d attempted to set invalid MAC filter\n",
-				 vf);
-			return -EINVAL;
-		}
-
 		/* try to find empty slot in the list */
 		list_for_each(pos, &adapter->vf_macs.l) {
 			entry = list_entry(pos, struct vf_mac_filter, l);
-- 
2.31.1

