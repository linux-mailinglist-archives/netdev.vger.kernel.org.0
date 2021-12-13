Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297BE4738A3
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbhLMXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:38:49 -0500
Received: from mga17.intel.com ([192.55.52.151]:44420 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhLMXis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 18:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639438728; x=1670974728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BBAMZjCY4Q1gCRwA30Si13MVPVuNhr7ZPodVD1Zxs0I=;
  b=VkBkbCQxfjQGu8W0u7junpNwQpavNBOnZikNHIeD2YR68T0rVkMoojZD
   hEvt/BCo4+nHjU2fMyfuoR630++Z1diIhV0tpqf1sXJdK91eleXZqD3SV
   2FKN7oKFGc/6rDJ/iWiW8Z3xxPwyqeCC8tinmqsQMBWiDJcpfIzgWABYH
   HeAoJkxZKRofTe8lGwZpYklP7BAATAtnlxhS3S5Z8kaJev5vH53mfLqJr
   Pottw5TdVNig1vfSdp+hLzm1hi0smYOgjDa+7BQk/MSlLHqakhUmfIYN+
   nlAHugT9IQDn35jiQtzXiqH0hyJSWXep3cUSxO5CyWqvkEVjvhwimcuXL
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="219539646"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="219539646"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 15:38:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="661052305"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 15:38:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/2] iavf: missing unlocks in iavf_watchdog_task()
Date:   Mon, 13 Dec 2021 15:37:49 -0800
Message-Id: <20211213233750.930233-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
References: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This code was re-organized and there some unlocks missing now.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index cfdbf8c08d18..884a19c51543 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2046,6 +2046,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
@@ -2076,9 +2077,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 			iavf_detect_recover_hung(&adapter->vsi);
 		break;
 	case __IAVF_REMOVE:
-		mutex_unlock(&adapter->crit_lock);
-		return;
 	default:
+		mutex_unlock(&adapter->crit_lock);
 		return;
 	}
 
-- 
2.31.1

