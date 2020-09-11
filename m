Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A3A26767F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgIKXW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:22:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:17589 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgIKXWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:22:22 -0400
IronPort-SDR: F1s6dQayubU7h5TqgCahZV3aK2V7jgTQdnpw+dj+YunqpXuZKISXXCMH9BialmqAixy9E0Ky/5
 0LzWu2GxAPJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220426162"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="220426162"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:13 -0700
IronPort-SDR: lu/M6l1B6OkZwFCcub4Vwe3H7xEqCRnSgu4IRBWPIaWD/Jsg/jNafmxOoZZmXtJEagloGivbBG
 N1mSJcG2+rRQ==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="505656587"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [RESEND net 3/4] igc: Fix wrong timestamp latency numbers
Date:   Fri, 11 Sep 2020 16:22:06 -0700
Message-Id: <20200911232207.3417169-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
References: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

The previous timestamping latency numbers were obtained by
interpolating the i210 numbers with the i225 crystal clock value. That
calculation was wrong.

Use the correct values from real measurements.

Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 3070dfdb7eb4..2d566f3c827b 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -299,18 +299,14 @@ extern char igc_driver_name[];
 #define IGC_RX_HDR_LEN			IGC_RXBUFFER_256
 
 /* Transmit and receive latency (for PTP timestamps) */
-/* FIXME: These values were estimated using the ones that i225 has as
- * basis, they seem to provide good numbers with ptp4l/phc2sys, but we
- * need to confirm them.
- */
-#define IGC_I225_TX_LATENCY_10		9542
-#define IGC_I225_TX_LATENCY_100		1024
-#define IGC_I225_TX_LATENCY_1000	178
-#define IGC_I225_TX_LATENCY_2500	64
-#define IGC_I225_RX_LATENCY_10		20662
-#define IGC_I225_RX_LATENCY_100		2213
-#define IGC_I225_RX_LATENCY_1000	448
-#define IGC_I225_RX_LATENCY_2500	160
+#define IGC_I225_TX_LATENCY_10		240
+#define IGC_I225_TX_LATENCY_100		58
+#define IGC_I225_TX_LATENCY_1000	80
+#define IGC_I225_TX_LATENCY_2500	1325
+#define IGC_I225_RX_LATENCY_10		6450
+#define IGC_I225_RX_LATENCY_100		185
+#define IGC_I225_RX_LATENCY_1000	300
+#define IGC_I225_RX_LATENCY_2500	1485
 
 /* RX and TX descriptor control thresholds.
  * PTHRESH - MAC will consider prefetch if it has fewer than this number of
-- 
2.26.2

