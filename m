Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63226F9B6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgIRJ4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:56:20 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42108 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgIRJ4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:56:19 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 44FB12014D1;
        Fri, 18 Sep 2020 11:56:17 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0BA0B201161;
        Fri, 18 Sep 2020 11:56:14 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id D2B07402C3;
        Fri, 18 Sep 2020 11:56:09 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [v2, 2/2] ptp_qoriq: support FIPER3
Date:   Fri, 18 Sep 2020 17:48:01 +0800
Message-Id: <20200918094801.37514-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918094801.37514-1-yangbo.lu@nxp.com>
References: <20200918094801.37514-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIPER3 (fixed interval period pulse generator) is supported on
DPAA2 and ENETC network controller hardware. This patch is to support
it in ptp_qoriq driver.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes for v2:
	- Some improvement in code.
	- Added ACK from Vladimir.
---
 drivers/ptp/ptp_qoriq.c       | 20 +++++++++++++++++++-
 include/linux/fsl/ptp_qoriq.h |  3 +++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index c09c16be..beb5f74 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -72,6 +72,10 @@ static void set_fipers(struct ptp_qoriq *ptp_qoriq)
 	set_alarm(ptp_qoriq);
 	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1);
 	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2);
+
+	if (ptp_qoriq->fiper3_support)
+		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
+				 ptp_qoriq->tmr_fiper3);
 }
 
 int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool update_event)
@@ -366,6 +370,7 @@ static u32 ptp_qoriq_nominal_freq(u32 clk_src)
  *   "fsl,tmr-add"
  *   "fsl,tmr-fiper1"
  *   "fsl,tmr-fiper2"
+ *   "fsl,tmr-fiper3" (required only for DPAA2 and ENETC hardware)
  *   "fsl,max-adj"
  *
  * Return 0 if success
@@ -412,6 +417,7 @@ static int ptp_qoriq_auto_config(struct ptp_qoriq *ptp_qoriq,
 	ptp_qoriq->tmr_add = freq_comp;
 	ptp_qoriq->tmr_fiper1 = DEFAULT_FIPER1_PERIOD - ptp_qoriq->tclk_period;
 	ptp_qoriq->tmr_fiper2 = DEFAULT_FIPER2_PERIOD - ptp_qoriq->tclk_period;
+	ptp_qoriq->tmr_fiper3 = DEFAULT_FIPER3_PERIOD - ptp_qoriq->tclk_period;
 
 	/* max_adj = 1000000000 * (freq_ratio - 1.0) - 1
 	 * freq_ratio = reference_clock_freq / nominal_freq
@@ -446,6 +452,10 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 	else
 		ptp_qoriq->extts_fifo_support = false;
 
+	if (of_device_is_compatible(node, "fsl,dpaa2-ptp") ||
+	    of_device_is_compatible(node, "fsl,enetc-ptp"))
+		ptp_qoriq->fiper3_support = true;
+
 	if (of_property_read_u32(node,
 				 "fsl,tclk-period", &ptp_qoriq->tclk_period) ||
 	    of_property_read_u32(node,
@@ -457,7 +467,10 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 	    of_property_read_u32(node,
 				 "fsl,tmr-fiper2", &ptp_qoriq->tmr_fiper2) ||
 	    of_property_read_u32(node,
-				 "fsl,max-adj", &ptp_qoriq->caps.max_adj)) {
+				 "fsl,max-adj", &ptp_qoriq->caps.max_adj) ||
+	    (ptp_qoriq->fiper3_support &&
+	     of_property_read_u32(node, "fsl,tmr-fiper3",
+				  &ptp_qoriq->tmr_fiper3))) {
 		pr_warn("device tree node missing required elements, try automatic configuration\n");
 
 		if (ptp_qoriq_auto_config(ptp_qoriq, node))
@@ -502,6 +515,11 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_prsc, ptp_qoriq->tmr_prsc);
 	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper1, ptp_qoriq->tmr_fiper1);
 	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2);
+
+	if (ptp_qoriq->fiper3_support)
+		ptp_qoriq->write(&regs->fiper_regs->tmr_fiper3,
+				 ptp_qoriq->tmr_fiper3);
+
 	set_alarm(ptp_qoriq);
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_ctrl,
 			 tmr_ctrl|FIPERST|RTPE|TE|FRD);
diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index 884b8f8..01acebe 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -136,6 +136,7 @@ struct ptp_qoriq_registers {
 #define DEFAULT_TMR_PRSC	2
 #define DEFAULT_FIPER1_PERIOD	1000000000
 #define DEFAULT_FIPER2_PERIOD	1000000000
+#define DEFAULT_FIPER3_PERIOD	1000000000
 
 struct ptp_qoriq {
 	void __iomem *base;
@@ -147,6 +148,7 @@ struct ptp_qoriq {
 	struct dentry *debugfs_root;
 	struct device *dev;
 	bool extts_fifo_support;
+	bool fiper3_support;
 	int irq;
 	int phc_index;
 	u32 tclk_period;  /* nanoseconds */
@@ -155,6 +157,7 @@ struct ptp_qoriq {
 	u32 cksel;
 	u32 tmr_fiper1;
 	u32 tmr_fiper2;
+	u32 tmr_fiper3;
 	u32 (*read)(unsigned __iomem *addr);
 	void (*write)(unsigned __iomem *addr, u32 val);
 };
-- 
2.7.4

