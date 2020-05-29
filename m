Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F831E750F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgE2Ekf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:40323 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgE2EkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:19 -0400
IronPort-SDR: d7Z0mD8pV8YdpuDbKLxWuuRR4toy4xJW5XETx1oRt8bUCglHs8H5EeoGyUd2ThAJVlCID3RDM8
 964AYNgK8L5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:06 -0700
IronPort-SDR: KNb5iaduasiWCxC5ZTWsjFP5toTebWrqLlHn45NS10bZmx/q2nvDJQCcOaWLfz80KZHyKjuTvY
 K4pi2tnqoxjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850936"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/17] igc: Add Receive Error Counter
Date:   Thu, 28 May 2020 21:40:01 -0700
Message-Id: <20200529044004.3725307-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Receive error counter reflect total number of non-filtered
packets received with errors. This includes: CRC error,
symbol error, Rx data error and carrier extend error.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 9de70a24cb9e..a5a087e1ac02 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -241,6 +241,7 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_MCC);
 	rd32(IGC_LATECOL);
 	rd32(IGC_COLC);
+	rd32(IGC_RERC);
 	rd32(IGC_DC);
 	rd32(IGC_SEC);
 	rd32(IGC_RLEC);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 662f06a647e6..e0c45ffa12c4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3740,6 +3740,7 @@ void igc_update_stats(struct igc_adapter *adapter)
 
 	adapter->stats.tpt += rd32(IGC_TPT);
 	adapter->stats.colc += rd32(IGC_COLC);
+	adapter->stats.colc += rd32(IGC_RERC);
 
 	adapter->stats.algnerrc += rd32(IGC_ALGNERRC);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index a3e4ec922948..7ac3b611708c 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -134,6 +134,7 @@
 #define IGC_MCC		0x0401C  /* Multiple Collision Count - R/clr */
 #define IGC_LATECOL	0x04020  /* Late Collision Count - R/clr */
 #define IGC_COLC	0x04028  /* Collision Count - R/clr */
+#define IGC_RERC	0x0402C  /* Receive Error Count - R/clr */
 #define IGC_DC		0x04030  /* Defer Count - R/clr */
 #define IGC_TNCRS	0x04034  /* Tx-No CRS - R/clr */
 #define IGC_SEC		0x04038  /* Sequence Error Count - R/clr */
-- 
2.26.2

