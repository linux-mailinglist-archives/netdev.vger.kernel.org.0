Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83347463FD6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344048AbhK3VYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:24:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:13470 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344031AbhK3VYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 16:24:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236263992"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236263992"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 13:21:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="744895435"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2021 13:21:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next v2 02/10] iavf: Log info when VF is entering and leaving Allmulti mode
Date:   Tue, 30 Nov 2021 13:19:56 -0800
Message-Id: <20211130212004.198898-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
References: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

Add log when VF is entering and leaving Allmulti mode.
The change of VF state is visible in dmesg now.
Without this commit, entering and leaving Allmulti mode
is not logged in dmesg.

Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index d60bf7c21200..5c64f06d44f8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -762,15 +762,23 @@ void iavf_set_promiscuous(struct iavf_adapter *adapter, int flags)
 	if (flags & FLAG_VF_MULTICAST_PROMISC) {
 		adapter->flags |= IAVF_FLAG_ALLMULTI_ON;
 		adapter->aq_required &= ~IAVF_FLAG_AQ_REQUEST_ALLMULTI;
-		dev_info(&adapter->pdev->dev, "Entering multicast promiscuous mode\n");
+		dev_info(&adapter->pdev->dev, "%s is entering multicast promiscuous mode\n",
+			 adapter->netdev->name);
 	}
 
 	if (!flags) {
-		adapter->flags &= ~(IAVF_FLAG_PROMISC_ON |
-				    IAVF_FLAG_ALLMULTI_ON);
-		adapter->aq_required &= ~(IAVF_FLAG_AQ_RELEASE_PROMISC |
-					  IAVF_FLAG_AQ_RELEASE_ALLMULTI);
-		dev_info(&adapter->pdev->dev, "Leaving promiscuous mode\n");
+		if (adapter->flags & IAVF_FLAG_PROMISC_ON) {
+			adapter->flags &= ~IAVF_FLAG_PROMISC_ON;
+			adapter->aq_required &= ~IAVF_FLAG_AQ_RELEASE_PROMISC;
+			dev_info(&adapter->pdev->dev, "Leaving promiscuous mode\n");
+		}
+
+		if (adapter->flags & IAVF_FLAG_ALLMULTI_ON) {
+			adapter->flags &= ~IAVF_FLAG_ALLMULTI_ON;
+			adapter->aq_required &= ~IAVF_FLAG_AQ_RELEASE_ALLMULTI;
+			dev_info(&adapter->pdev->dev, "%s is leaving multicast promiscuous mode\n",
+				 adapter->netdev->name);
+		}
 	}
 
 	adapter->current_op = VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE;
-- 
2.31.1

