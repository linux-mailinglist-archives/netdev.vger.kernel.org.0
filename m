Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7645CAF8
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242902AbhKXR2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:28:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:35662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243195AbhKXR2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734822"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734822"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738889"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 05/12] iavf: don't be so alarming
Date:   Wed, 24 Nov 2021 09:16:45 -0800
Message-Id: <20211124171652.831184-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

Reduce the log level of a couple of messages. These can appear during normal
reset and rmmod processing, and the driver recovers just fine. Debug
level is fine for these.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index cc1b3caa5136..bb2e91cb9cd4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3405,7 +3405,7 @@ static int iavf_close(struct net_device *netdev)
 				    adapter->state == __IAVF_DOWN,
 				    msecs_to_jiffies(500));
 	if (!status)
-		netdev_warn(netdev, "Device resources not yet released\n");
+		netdev_dbg(netdev, "Device resources not yet released\n");
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 250dc8bcaedd..9c0c9a7ee06d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1899,8 +1899,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		break;
 	default:
 		if (adapter->current_op && (v_opcode != adapter->current_op))
-			dev_warn(&adapter->pdev->dev, "Expected response %d from PF, received %d\n",
-				 adapter->current_op, v_opcode);
+			dev_dbg(&adapter->pdev->dev, "Expected response %d from PF, received %d\n",
+				adapter->current_op, v_opcode);
 		break;
 	} /* switch v_opcode */
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.31.1

