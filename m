Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57231AFDCA
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgDSTve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgDSTvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:33 -0400
IronPort-SDR: K2c6VQE1kD3ez2MDNqU76AKbH3epRJiBaRsxurrp2JyLsGEtEuzhPwYiFv8Lhpqf6p5NDOOAH+
 Z6sxyX/bmpJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:33 -0700
IronPort-SDR: FSQDliRP6n6texw4R3FH691u0ab11nZpL09MSpEZzzpbsxaJY26lPYFYlK7/qi+Pp8d/GbI4Ra
 m6Khf3zHTqRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034398"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/14] e1000e: fix S0ix flows for cable connected case
Date:   Sun, 19 Apr 2020 12:51:19 -0700
Message-Id: <20200419195131.1068144-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Added a fix to S0ix entry and exit flows for TGP and above
MAC types, to the case when the Ethernet cable is connected
and the link is up. With that the system is able to reach
SLP_S0 when going to freeze power state.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 54 ++++++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/regs.h   |  3 ++
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 177c6da80c57..e0b074820b47 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6404,6 +6404,31 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	mac_data |= BIT(3);
 	ew32(CTRL_EXT, mac_data);
 
+	/* Disable disconnected cable conditioning for Power Gating */
+	mac_data = er32(DPGFR);
+	mac_data |= BIT(2);
+	ew32(DPGFR, mac_data);
+
+	/* Don't wake from dynamic Power Gating with clock request */
+	mac_data = er32(FEXTNVM12);
+	mac_data |= BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data |= BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Enable K1 off to enable mPHY Power Gating */
+	mac_data = er32(FEXTNVM6);
+	mac_data |= BIT(31);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Enable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data |= BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
 	/* Enable the Dynamic Clock Gating in the DMA and MAC */
 	mac_data = er32(CTRL_EXT);
 	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
@@ -6433,6 +6458,35 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	mac_data |= BIT(0);
 	ew32(FEXTNVM7, mac_data);
 
+	/* Disable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data &= ~BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* Disable K1 off */
+	mac_data = er32(FEXTNVM6);
+	mac_data &= ~BIT(31);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Disable Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data &= ~BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Cancel not waking from dynamic
+	 * Power Gating with clock request
+	 */
+	mac_data = er32(FEXTNVM12);
+	mac_data &= ~BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Cancel disable disconnected cable conditioning
+	 * for Power Gating
+	 */
+	mac_data = er32(DPGFR);
+	mac_data &= ~BIT(2);
+	ew32(DPGFR, mac_data);
+
 	/* Disable Dynamic Power Gating */
 	mac_data = er32(CTRL_EXT);
 	mac_data &= 0xFFFFFFF7;
diff --git a/drivers/net/ethernet/intel/e1000e/regs.h b/drivers/net/ethernet/intel/e1000e/regs.h
index df59fd1d660c..8165ba2619a4 100644
--- a/drivers/net/ethernet/intel/e1000e/regs.h
+++ b/drivers/net/ethernet/intel/e1000e/regs.h
@@ -21,9 +21,12 @@
 #define E1000_FEXTNVM5	0x00014	/* Future Extended NVM 5 - RW */
 #define E1000_FEXTNVM6	0x00010	/* Future Extended NVM 6 - RW */
 #define E1000_FEXTNVM7	0x000E4	/* Future Extended NVM 7 - RW */
+#define E1000_FEXTNVM8	0x5BB0	/* Future Extended NVM 8 - RW */
 #define E1000_FEXTNVM9	0x5BB4	/* Future Extended NVM 9 - RW */
 #define E1000_FEXTNVM11	0x5BBC	/* Future Extended NVM 11 - RW */
+#define E1000_FEXTNVM12	0x5BC0	/* Future Extended NVM 12 - RW */
 #define E1000_PCIEANACFG	0x00F18	/* PCIE Analog Config */
+#define E1000_DPGFR	0x00FAC	/* Dynamic Power Gate Force Control Register */
 #define E1000_FCT	0x00030	/* Flow Control Type - RW */
 #define E1000_VET	0x00038	/* VLAN Ether Type - RW */
 #define E1000_ICR	0x000C0	/* Interrupt Cause Read - R/clr */
-- 
2.25.2

