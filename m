Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05F727B88C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgI1X6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:58:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:45838 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgI1X6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:58:43 -0400
IronPort-SDR: xKLwt+1kixPp7J8whcoDC3qbSymY/r7KqAWngfXj1CwqcUtH3PLx58fjj3qQXutzDPLqWo8FvL
 /0UOp6Pk9VQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086327"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086327"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:29 -0700
IronPort-SDR: 2uQgv85voh5rK2X/G8q+CEUFXmJpfh7a2jHAgKcM3WTJqZgxWDC71Yz9/Afx6kfvf4l0EV/XZv
 HQSbryjQfOJg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962117"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 08/15] igc: Expose LPI counters
Date:   Mon, 28 Sep 2020 14:50:11 -0700
Message-Id: <20200928215018.952991-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Completion to commit 900d1e8b346b ("igc: Add LPI counters")
LPI counters exposed by statistics update method.
A EEE TX LPI counter reflect the transmitter entries EEE (IEEE 802.3az)
into the LPI state. A EEE RX LPI counter reflect the receiver link
partner entries into EEE(IEEE 802.3az) LPI state.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_hw.h      | 2 ++
 drivers/net/ethernet/intel/igc/igc_main.c    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 44410c2265d6..61d331ce38cd 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -321,6 +321,9 @@ static void igc_ethtool_get_regs(struct net_device *netdev,
 
 	for (i = 0; i < 8; i++)
 		regs_buff[205 + i] = rd32(IGC_ETQF(i));
+
+	regs_buff[213] = adapter->stats.tlpic;
+	regs_buff[214] = adapter->stats.rlpic;
 }
 
 static void igc_ethtool_get_wol(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 6defdb8a31fe..b70253fb8ebc 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -244,6 +244,8 @@ struct igc_hw_stats {
 	u64 prc511;
 	u64 prc1023;
 	u64 prc1522;
+	u64 tlpic;
+	u64 rlpic;
 	u64 gprc;
 	u64 bprc;
 	u64 mprc;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7a46b22413f2..7576dbfdac99 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3683,6 +3683,8 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.prc511 += rd32(IGC_PRC511);
 	adapter->stats.prc1023 += rd32(IGC_PRC1023);
 	adapter->stats.prc1522 += rd32(IGC_PRC1522);
+	adapter->stats.tlpic += rd32(IGC_TLPIC);
+	adapter->stats.rlpic += rd32(IGC_RLPIC);
 
 	mpc = rd32(IGC_MPC);
 	adapter->stats.mpc += mpc;
-- 
2.26.2

