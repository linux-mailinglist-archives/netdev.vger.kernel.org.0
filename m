Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D32FAE2A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391360AbhASAmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:42:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:38531 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391079AbhASAlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 19:41:49 -0500
IronPort-SDR: Slg/xgOLDzXHo7kZymF1wobJKSZixeJdJb//HLzxcyvnUtmlfRwkTez3GEw6YWdZ/Ef2WcFqML
 uTXCC+JkSuoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="179011264"
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="179011264"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:54 -0800
IronPort-SDR: QZSJrKENayqnnMspYJoz4fxLDekgzyytlj8vot2EsqqKPDZa3urdDUgiSGo/37+qiRQyYvGlUo
 LNLblCTgfMKQ==
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="426285778"
Received: from cemillan-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.57.184])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:52 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v2 5/8] igc: Avoid TX Hangs because long cycles
Date:   Mon, 18 Jan 2021 16:40:25 -0800
Message-Id: <20210119004028.2809425-6-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210119004028.2809425-1-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
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
index afd6a62da29d..f1b31fa04734 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4693,12 +4693,12 @@ static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
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

