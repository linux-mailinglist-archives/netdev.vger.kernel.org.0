Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E247A39BCF4
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFDQXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:23:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:53967 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhFDQXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:39 -0400
IronPort-SDR: Ozpi3VbMe4QEMaiO/mKFnVfQ5JecH/TFTFwFmDOunOwoxbJZPAzzuazgp086NfYjKEGJCFDMiO
 8c5hzYQ7UTCw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184003816"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184003816"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:21:52 -0700
IronPort-SDR: WAFCgBJ+jn6bp3sGwel5IfIdEdI8rj22kg0yR+Reg6bM9fiQ+3Ic76NjbTla69IRHu6y/Z9pGw
 TCgaw9ZOO6NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448309154"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 09:21:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com, Alexander Duyck <alexanderduyck@fb.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/5] igc: Update driver to use ethtool_sprintf
Date:   Fri,  4 Jun 2021 09:24:17 -0700
Message-Id: <20210604162421.3392644-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
References: <20210604162421.3392644-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Complete to commit c8d4725e985d ("intel: Update drivers to use
ethtool_sprintf")
Update the igc driver to make use of ethtool_sprintf. The general idea
is to reduce code size and overhead by replacing the repeated pattern of
string printf statements and ETH_STRING_LEN counter increments.

Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 39 +++++++-------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 2cb12431c371..fa4171860623 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -765,35 +765,22 @@ static void igc_ethtool_get_strings(struct net_device *netdev, u32 stringset,
 		       IGC_TEST_LEN * ETH_GSTRING_LEN);
 		break;
 	case ETH_SS_STATS:
-		for (i = 0; i < IGC_GLOBAL_STATS_LEN; i++) {
-			memcpy(p, igc_gstrings_stats[i].stat_string,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-		for (i = 0; i < IGC_NETDEV_STATS_LEN; i++) {
-			memcpy(p, igc_gstrings_net_stats[i].stat_string,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < IGC_GLOBAL_STATS_LEN; i++)
+			ethtool_sprintf(&p, igc_gstrings_stats[i].stat_string);
+		for (i = 0; i < IGC_NETDEV_STATS_LEN; i++)
+			ethtool_sprintf(&p,
+					igc_gstrings_net_stats[i].stat_string);
 		for (i = 0; i < adapter->num_tx_queues; i++) {
-			sprintf(p, "tx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_restart", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "tx_queue_%u_restart", i);
 		}
 		for (i = 0; i < adapter->num_rx_queues; i++) {
-			sprintf(p, "rx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_drops", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_csum_err", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_alloc_failed", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "rx_queue_%u_drops", i);
+			ethtool_sprintf(&p, "rx_queue_%u_csum_err", i);
+			ethtool_sprintf(&p, "rx_queue_%u_alloc_failed", i);
 		}
 		/* BUG_ON(p - data != IGC_STATS_LEN * ETH_GSTRING_LEN); */
 		break;
-- 
2.26.2

