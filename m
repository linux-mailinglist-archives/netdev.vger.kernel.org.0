Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B7C301054
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbhAVWwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:52:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:1521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbhAVWrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:47:40 -0500
IronPort-SDR: 9jwSmcKUP4UBKYwACnZXRs+F9MUU+UI830u/yrJl8UkPRCkLa4uP8h9kk1gzO7fzbBOB5GGQkv
 LlP6nUtibKxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619682"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:22 -0800
IronPort-SDR: 54SFS4YN912CN45idCmyaBSceqkku9GpUb4JP/Pt6cal7IxLugX5YMGBIkfAMaD4KPXJWtX0Gv
 XuRzcF7IDH2w==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390563"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:21 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 5/8] igc: Avoid TX Hangs because long cycles
Date:   Fri, 22 Jan 2021 14:44:50 -0800
Message-Id: <20210122224453.4161729-6-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid possible TX Hangs caused by using long Qbv cycles. In some
cases, using long cycles (more than 1 second) can cause transmissions
to be blocked for that time. As the TX Hang timeout is close to 1
second, we may need to reduce the cycle time to something more
reasonable: the value chosen is 1ms.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ++--
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 43aec42e6d9d..1ae5f29d1b70 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4681,12 +4681,12 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
 	if (adapter->base_time)
 		return 0;
 
-	adapter->cycle_time = NSEC_PER_SEC;
+	adapter->cycle_time = NSEC_PER_MSEC;
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		ring = adapter->tx_ring[i];
 		ring->start_time = 0;
-		ring->end_time = NSEC_PER_SEC;
+		ring->end_time = NSEC_PER_MSEC;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 38451cf05ac6..f5a5527adb21 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -54,11 +54,11 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 
 		wr32(IGC_TXQCTL(i), 0);
 		wr32(IGC_STQT(i), 0);
-		wr32(IGC_ENDQT(i), NSEC_PER_SEC);
+		wr32(IGC_ENDQT(i), NSEC_PER_MSEC);
 	}
 
-	wr32(IGC_QBVCYCLET_S, NSEC_PER_SEC);
-	wr32(IGC_QBVCYCLET, NSEC_PER_SEC);
+	wr32(IGC_QBVCYCLET_S, NSEC_PER_MSEC);
+	wr32(IGC_QBVCYCLET, NSEC_PER_MSEC);
 
 	adapter->flags &= ~IGC_FLAG_TSN_QBV_ENABLED;
 
-- 
2.30.0

