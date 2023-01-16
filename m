Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F084B66B986
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjAPI4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjAPI4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:56:15 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E42213D50;
        Mon, 16 Jan 2023 00:56:14 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G8tsFj047639;
        Mon, 16 Jan 2023 02:55:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673859354;
        bh=eQGeU/joVMiHsxsFt6zqr2/z4nsq/vb7Ljj2B2rtXIM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Lr4Ga52mTMbXnfnocNKOPZmEd+1CEP/x3JE+LnylwKLzVEvWxs3FRzHRbPLWgn3yN
         7TMQ+bDkF0X97dRs4HvHAcGjtjkJ7O7D9fN7pzbB8TSJ1tg/aM7QRXWIlFITOFbt2r
         o76F2EhbTohyYi5qn3+f2TW6CmRWpqHYzfAsRLe0=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G8tsvI085935
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 02:55:54 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 02:55:53 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 02:55:54 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G8tZwK040368;
        Mon, 16 Jan 2023 02:55:49 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vigneshr@ti.com>,
        <rogerq@kernel.org>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 3/3] net: ethernet: ti: am65-cpts: adjust pps following ptp changes
Date:   Mon, 16 Jan 2023 14:25:34 +0530
Message-ID: <20230116085534.440820-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116085534.440820-1-s-vadapalli@ti.com>
References: <20230116085534.440820-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

When CPTS clock is sync/adjusted by running linuxptp (ptp4l) it will cause
PPS jitter as Genf running PPS is not adjusted.

The same PPM adjustment has to be applied to GenF as to PHC clock to
correct PPS length and keep them in sync.

Testing:
 Master:
  ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp1 -f ptp.cfg &
  testptp -d /dev/ptp1 -P 1
  ppstest /dev/pps0

 Slave:
  linuxptp/ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp1 -f ptp1.cfg -s &
    <port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED;>
  testptp -d /dev/ptp1 -P 1
  ppstest /dev/pps0

Master log:
source 0 - assert 620.000000689, sequence: 530
source 0 - assert 621.000000689, sequence: 531
source 0 - assert 622.000000689, sequence: 532
source 0 - assert 623.000000689, sequence: 533
source 0 - assert 624.000000689, sequence: 534
source 0 - assert 625.000000689, sequence: 535
source 0 - assert 626.000000689, sequence: 536
source 0 - assert 627.000000689, sequence: 537
source 0 - assert 628.000000689, sequence: 538
source 0 - assert 629.000000689, sequence: 539
source 0 - assert 630.000000689, sequence: 540
source 0 - assert 631.000000689, sequence: 541
source 0 - assert 632.000000689, sequence: 542
source 0 - assert 633.000000689, sequence: 543
source 0 - assert 634.000000689, sequence: 544
source 0 - assert 635.000000689, sequence: 545

Slave log:
source 0 - assert 620.000000706, sequence: 252
source 0 - assert 621.000000709, sequence: 253
source 0 - assert 622.000000707, sequence: 254
source 0 - assert 623.000000707, sequence: 255
source 0 - assert 624.000000706, sequence: 256
source 0 - assert 625.000000705, sequence: 257
source 0 - assert 626.000000709, sequence: 258
source 0 - assert 627.000000709, sequence: 259
source 0 - assert 628.000000707, sequence: 260
source 0 - assert 629.000000706, sequence: 261
source 0 - assert 630.000000710, sequence: 262
source 0 - assert 631.000000708, sequence: 263
source 0 - assert 632.000000705, sequence: 264
source 0 - assert 633.000000710, sequence: 265
source 0 - assert 634.000000708, sequence: 266
source 0 - assert 635.000000707, sequence: 267

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 59 ++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index c405af266b41..bf0f74b20ba6 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -405,10 +405,13 @@ static irqreturn_t am65_cpts_interrupt(int irq, void *dev_id)
 static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct am65_cpts *cpts = container_of(ptp, struct am65_cpts, ptp_info);
+	u32 pps_ctrl_val = 0, pps_ppm_hi = 0, pps_ppm_low = 0;
 	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+	int pps_index = cpts->pps_genf_idx;
+	u64 adj_period, pps_adj_period;
+	u32 ctrl_val, ppm_hi, ppm_low;
+	unsigned long flags;
 	int neg_adj = 0;
-	u64 adj_period;
-	u32 val;
 
 	if (ppb < 0) {
 		neg_adj = 1;
@@ -428,17 +431,53 @@ static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&cpts->ptp_clk_lock);
 
-	val = am65_cpts_read32(cpts, control);
+	ctrl_val = am65_cpts_read32(cpts, control);
 	if (neg_adj)
-		val |= AM65_CPTS_CONTROL_TS_PPM_DIR;
+		ctrl_val |= AM65_CPTS_CONTROL_TS_PPM_DIR;
 	else
-		val &= ~AM65_CPTS_CONTROL_TS_PPM_DIR;
-	am65_cpts_write32(cpts, val, control);
+		ctrl_val &= ~AM65_CPTS_CONTROL_TS_PPM_DIR;
+
+	ppm_hi = upper_32_bits(adj_period) & 0x3FF;
+	ppm_low = lower_32_bits(adj_period);
+
+	if (cpts->pps_enabled) {
+		pps_ctrl_val = am65_cpts_read32(cpts, genf[pps_index].control);
+		if (neg_adj)
+			pps_ctrl_val &= ~BIT(1);
+		else
+			pps_ctrl_val |= BIT(1);
+
+		/* GenF PPM will do correction using cpts refclk tick which is
+		 * (cpts->ts_add_val + 1) ns, so GenF length PPM adj period
+		 * need to be corrected.
+		 */
+		pps_adj_period = adj_period * (cpts->ts_add_val + 1);
+		pps_ppm_hi = upper_32_bits(pps_adj_period) & 0x3FF;
+		pps_ppm_low = lower_32_bits(pps_adj_period);
+	}
+
+	spin_lock_irqsave(&cpts->lock, flags);
 
-	val = upper_32_bits(adj_period) & 0x3FF;
-	am65_cpts_write32(cpts, val, ts_ppm_hi);
-	val = lower_32_bits(adj_period);
-	am65_cpts_write32(cpts, val, ts_ppm_low);
+	/* All below writes must be done extremely fast:
+	 *  - delay between PPM dir and PPM value changes can cause err due old
+	 *    PPM correction applied in wrong direction
+	 *  - delay between CPTS-clock PPM cfg and GenF PPM cfg can cause err
+	 *    due CPTS-clock PPM working with new cfg while GenF PPM cfg still
+	 *    with old for short period of time
+	 */
+
+	am65_cpts_write32(cpts, ctrl_val, control);
+	am65_cpts_write32(cpts, ppm_hi, ts_ppm_hi);
+	am65_cpts_write32(cpts, ppm_low, ts_ppm_low);
+
+	if (cpts->pps_enabled) {
+		am65_cpts_write32(cpts, pps_ctrl_val, genf[pps_index].control);
+		am65_cpts_write32(cpts, pps_ppm_hi, genf[pps_index].ppm_hi);
+		am65_cpts_write32(cpts, pps_ppm_low, genf[pps_index].ppm_low);
+	}
+
+	/* All GenF/EstF can be updated here the same way */
+	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	mutex_unlock(&cpts->ptp_clk_lock);
 
-- 
2.25.1

