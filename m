Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58F120BDA7
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgF0Byx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:29242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgF0Byq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:46 -0400
IronPort-SDR: pT9ELLI0+Ye/OT7syd9qctHJqIOXfxQgrF/qf6DViIgN5T8qiVq2lnrWmtpJrMQAJALy3L6UNu
 e51o1mse7cOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588589"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588589"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:38 -0700
IronPort-SDR: hbWRnEzmYgrKbkQuB2pKO0qU5MmKp2DwLbmAT6WQdvWmMTa/cn3g+R9t2p38CqnMB2czb85K5c
 rNvb/sb2yfvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495126"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/13] igc: Remove TCP segmentation TX fail counter
Date:   Fri, 26 Jun 2020 18:54:28 -0700
Message-Id: <20200627015431.3579234-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

TCP segmentation TX context fail counter is not
applicable for i225 devices.
This patch comes to clean up this counter.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown<aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index f3f7717b6233..9a5e44ef45f4 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -289,7 +289,6 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_TNCRS);
 	rd32(IGC_HTDPMC);
 	rd32(IGC_TSCTC);
-	rd32(IGC_TSCTFC);
 
 	rd32(IGC_MGTPRC);
 	rd32(IGC_MGTPDC);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1b71f63d0e86..6a11f897aa62 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3740,7 +3740,6 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.algnerrc += rd32(IGC_ALGNERRC);
 
 	adapter->stats.tsctc += rd32(IGC_TSCTC);
-	adapter->stats.tsctfc += rd32(IGC_TSCTFC);
 
 	adapter->stats.iac += rd32(IGC_IAC);
 	adapter->stats.icrxoc += rd32(IGC_ICRXOC);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index eb3e8e70501d..1c46cec5a799 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -181,7 +181,6 @@
 #define IGC_MPTC	0x040F0  /* Multicast Packets Tx Count - R/clr */
 #define IGC_BPTC	0x040F4  /* Broadcast Packets Tx Count - R/clr */
 #define IGC_TSCTC	0x040F8  /* TCP Segmentation Context Tx - R/clr */
-#define IGC_TSCTFC	0x040FC  /* TCP Segmentation Context Tx Fail - R/clr */
 #define IGC_IAC		0x04100  /* Interrupt Assertion Count */
 #define IGC_ICTXPTC	0x0410C  /* Interrupt Cause Tx Pkt Timer Expire Count */
 #define IGC_ICTXATC	0x04110  /* Interrupt Cause Tx Abs Timer Expire Count */
-- 
2.26.2

