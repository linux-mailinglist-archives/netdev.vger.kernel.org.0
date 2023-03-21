Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9E6C2A5C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 07:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCUG0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 02:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjCUG0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 02:26:34 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97883608D;
        Mon, 20 Mar 2023 23:26:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32L6Q5sG096475;
        Tue, 21 Mar 2023 01:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679379965;
        bh=a+MTT5Qkyz1YaOgv8XKSB4NSt7MeDdfso+0H1pTzxGE=;
        h=From:To:CC:Subject:Date;
        b=M3bmLqI7iJgnzrYioqv1bVKfJHY/M5e7cIkO1PIvpZFKi7OXSrLeS9/ZzRe3Xu3hm
         Jmt/9jy3j92ReCcg0LWHukVryQkHrkhcOErld8UQsJJqPlD9CwzzTL4S/yDRRDQJb8
         ghIz1jCcW7d2oyRCBROFvrgwtOn3YNmVd2TNvkZc=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32L6Q5RF104597
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 01:26:05 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 01:26:05 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 01:26:05 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32L6Q1tY089872;
        Tue, 21 Mar 2023 01:26:01 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>,
        <jacob.e.keller@intel.com>, <richardcochran@gmail.com>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpts: adjust estf following ptp changes
Date:   Tue, 21 Mar 2023 11:56:00 +0530
Message-ID: <20230321062600.2539544-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

When the CPTS clock is synced/adjusted by running linuxptp (ptp4l/phc2sys),
it will cause the TSN EST schedule to drift away over time. This is because
the schedule is driven by the EstF periodic counter whose pulse length is
defined in ref_clk cycles and it does not automatically sync to CPTS clock.
   _______
 _|
  ^
  expected cycle start time boundary
   _______________
 _|_|___|_|
  ^
  EstF drifted away -> direction

To fix it, the same PPM adjustment has to be applied to EstF as done to the
PHC CPTS clock, in order to correct the TSN EST cycle length and keep them
in sync.

Drifted cycle:
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373377017
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373877017
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374377017
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374877017
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375377017
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375877023
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376377018
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376877018
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230377377018

Stable cycle:
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193375473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193875473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194375473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194875473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195375473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195875473
AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863196375473

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 34 ++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 16ee9c29cb35..1d9a399c9661 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -175,6 +175,7 @@ struct am65_cpts {
 	u64 timestamp;
 	u32 genf_enable;
 	u32 hw_ts_enable;
+	u32 estf_enable;
 	struct sk_buff_head txq;
 	bool pps_enabled;
 	bool pps_present;
@@ -405,13 +406,13 @@ static irqreturn_t am65_cpts_interrupt(int irq, void *dev_id)
 static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct am65_cpts *cpts = container_of(ptp, struct am65_cpts, ptp_info);
-	u32 pps_ctrl_val = 0, pps_ppm_hi = 0, pps_ppm_low = 0;
+	u32 estf_ctrl_val = 0, estf_ppm_hi = 0, estf_ppm_low = 0;
 	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	int pps_index = cpts->pps_genf_idx;
 	u64 adj_period, pps_adj_period;
 	u32 ctrl_val, ppm_hi, ppm_low;
 	unsigned long flags;
-	int neg_adj = 0;
+	int neg_adj = 0, i;
 
 	if (ppb < 0) {
 		neg_adj = 1;
@@ -441,19 +442,19 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	ppm_low = lower_32_bits(adj_period);
 
 	if (cpts->pps_enabled) {
-		pps_ctrl_val = am65_cpts_read32(cpts, genf[pps_index].control);
+		estf_ctrl_val = am65_cpts_read32(cpts, genf[pps_index].control);
 		if (neg_adj)
-			pps_ctrl_val &= ~BIT(1);
+			estf_ctrl_val &= ~BIT(1);
 		else
-			pps_ctrl_val |= BIT(1);
+			estf_ctrl_val |= BIT(1);
 
 		/* GenF PPM will do correction using cpts refclk tick which is
 		 * (cpts->ts_add_val + 1) ns, so GenF length PPM adj period
 		 * need to be corrected.
 		 */
 		pps_adj_period = adj_period * (cpts->ts_add_val + 1);
-		pps_ppm_hi = upper_32_bits(pps_adj_period) & 0x3FF;
-		pps_ppm_low = lower_32_bits(pps_adj_period);
+		estf_ppm_hi = upper_32_bits(pps_adj_period) & 0x3FF;
+		estf_ppm_low = lower_32_bits(pps_adj_period);
 	}
 
 	spin_lock_irqsave(&cpts->lock, flags);
@@ -471,11 +472,18 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	am65_cpts_write32(cpts, ppm_low, ts_ppm_low);
 
 	if (cpts->pps_enabled) {
-		am65_cpts_write32(cpts, pps_ctrl_val, genf[pps_index].control);
-		am65_cpts_write32(cpts, pps_ppm_hi, genf[pps_index].ppm_hi);
-		am65_cpts_write32(cpts, pps_ppm_low, genf[pps_index].ppm_low);
+		am65_cpts_write32(cpts, estf_ctrl_val, genf[pps_index].control);
+		am65_cpts_write32(cpts, estf_ppm_hi, genf[pps_index].ppm_hi);
+		am65_cpts_write32(cpts, estf_ppm_low, genf[pps_index].ppm_low);
 	}
 
+	for (i = 0; i < AM65_CPTS_ESTF_MAX_NUM; i++) {
+		if (cpts->estf_enable & BIT(i)) {
+			am65_cpts_write32(cpts, estf_ctrl_val, estf[i].control);
+			am65_cpts_write32(cpts, estf_ppm_hi, estf[i].ppm_hi);
+			am65_cpts_write32(cpts, estf_ppm_low, estf[i].ppm_low);
+		}
+	}
 	/* All GenF/EstF can be updated here the same way */
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
@@ -596,6 +604,11 @@ int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
 	am65_cpts_write32(cpts, val, estf[idx].comp_lo);
 	val = lower_32_bits(cycles);
 	am65_cpts_write32(cpts, val, estf[idx].length);
+	am65_cpts_write32(cpts, 0, estf[idx].control);
+	am65_cpts_write32(cpts, 0, estf[idx].ppm_hi);
+	am65_cpts_write32(cpts, 0, estf[idx].ppm_low);
+
+	cpts->estf_enable |= BIT(idx);
 
 	dev_dbg(cpts->dev, "%s: ESTF:%u enabled\n", __func__, idx);
 
@@ -606,6 +619,7 @@ EXPORT_SYMBOL_GPL(am65_cpts_estf_enable);
 void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
 {
 	am65_cpts_write32(cpts, 0, estf[idx].length);
+	cpts->estf_enable &= ~BIT(idx);
 
 	dev_dbg(cpts->dev, "%s: ESTF:%u disabled\n", __func__, idx);
 }
-- 
2.25.1

