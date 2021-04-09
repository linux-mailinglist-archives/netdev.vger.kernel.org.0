Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF42235A3A0
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhDIQm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:42:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:9785 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234148AbhDIQm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:42:26 -0400
IronPort-SDR: PFuA6UOpwNJZa7iat9t1JrVqK5BXaIKusAoi/h5DDoV7hlAXKGORhzMQKcdgBbirRNhsA2CY3P
 kQR/mBJbP6AA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="214235092"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="214235092"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:42:13 -0700
IronPort-SDR: CK1K1n3zmzwlPqWRIq9mDEXHoh5YvaVyerUwegprCWf4A63l+QMKUG4H9k6jAA3Mq+9TxU4aVG
 h/hiEWr13pUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="531055061"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Apr 2021 09:42:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 2/9] igc: Refactor __igc_xdp_run_prog()
Date:   Fri,  9 Apr 2021 09:43:44 -0700
Message-Id: <20210409164351.188953-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Refactor __igc_xdp_run_prog() helper from igc_xdp_run_prog(),
preparing the code for AF_XDP zero-copy support which is added
by upcoming patches.

The existing igc_xdp_run_prog() caters to regular XDP rx path
which has to verify if bpf_prog is not NULL. Zero-copy
path assumes that bpf_prog is not NULL and hence this check is
not required. Therefore it makes sense to refactor the common
code into a helper function, to avoid code duplication.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 56 +++++++++++------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index eef2e195dd37..86ec04972a64 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2020,38 +2020,22 @@ static int igc_xdp_xmit_back(struct igc_adapter *adapter, struct xdp_buff *xdp)
 	return res;
 }
 
-static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
-					struct xdp_buff *xdp)
+/* This function assumes rcu_read_lock() is held by the caller. */
+static int __igc_xdp_run_prog(struct igc_adapter *adapter,
+			      struct bpf_prog *prog,
+			      struct xdp_buff *xdp)
 {
-	struct bpf_prog *prog;
-	int res;
-	u32 act;
-
-	rcu_read_lock();
-
-	prog = READ_ONCE(adapter->xdp_prog);
-	if (!prog) {
-		res = IGC_XDP_PASS;
-		goto unlock;
-	}
+	u32 act = bpf_prog_run_xdp(prog, xdp);
 
-	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		res = IGC_XDP_PASS;
-		break;
+		return IGC_XDP_PASS;
 	case XDP_TX:
-		if (igc_xdp_xmit_back(adapter, xdp) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_TX;
-		break;
+		return igc_xdp_xmit_back(adapter, xdp) < 0 ?
+			IGC_XDP_CONSUMED : IGC_XDP_TX;
 	case XDP_REDIRECT:
-		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_REDIRECT;
-		break;
+		return xdp_do_redirect(adapter->netdev, xdp, prog) < 0 ?
+			IGC_XDP_CONSUMED : IGC_XDP_REDIRECT;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -2059,9 +2043,25 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 		trace_xdp_exception(adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-		res = IGC_XDP_CONSUMED;
-		break;
+		return IGC_XDP_CONSUMED;
 	}
+}
+
+static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
+					struct xdp_buff *xdp)
+{
+	struct bpf_prog *prog;
+	int res;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(adapter->xdp_prog);
+	if (!prog) {
+		res = IGC_XDP_PASS;
+		goto unlock;
+	}
+
+	res = __igc_xdp_run_prog(adapter, prog, xdp);
 
 unlock:
 	rcu_read_unlock();
-- 
2.26.2

