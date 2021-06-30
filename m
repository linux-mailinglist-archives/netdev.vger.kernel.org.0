Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C193A3B886B
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhF3S3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:29:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:35751 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhF3S3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:29:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="205403283"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="205403283"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="626106560"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2021 11:27:16 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 2/5] net: wwan: iosm: remove reduandant check
Date:   Wed, 30 Jun 2021 23:56:39 +0530
Message-Id: <20210630182638.3377-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove reduandant IP session id check since required checks
are in place under caller.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 46f76e8aae92..e4e9461b603e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -24,15 +24,7 @@ int ipc_imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id)
 		return -EIO;
 	}
 
-	/* check for the interafce id
-	 * if if_id 1 to 8 then create IP MUX channel sessions.
-	 * To start MUX session from 0 as network interface id would start
-	 * from 1 so map it to if_id = if_id - 1
-	 */
-	if (if_id >= IP_MUX_SESSION_START && if_id <= IP_MUX_SESSION_END)
-		return ipc_mux_open_session(ipc_imem->mux, if_id - 1);
-
-	return -EINVAL;
+	return ipc_mux_open_session(ipc_imem->mux, if_id - 1);
 }
 
 /* Release a net link to CP. */
@@ -83,13 +75,8 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem *ipc_imem,
 		goto out;
 	}
 
-	if (if_id >= IP_MUX_SESSION_START && if_id <= IP_MUX_SESSION_END)
-		/* Route the UL packet through IP MUX Layer */
-		ret = ipc_mux_ul_trigger_encode(ipc_imem->mux,
-						if_id - 1, skb);
-	else
-		dev_err(ipc_imem->dev,
-			"invalid if_id %d: ", if_id);
+	/* Route the UL packet through IP MUX Layer */
+	ret = ipc_mux_ul_trigger_encode(ipc_imem->mux, if_id - 1, skb);
 out:
 	return ret;
 }
-- 
2.25.1

