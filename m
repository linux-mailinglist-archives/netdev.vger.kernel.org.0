Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF5665AC7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjAKLt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbjAKLrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:47:39 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213841B9F9;
        Wed, 11 Jan 2023 03:45:07 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30BBikp1037016;
        Wed, 11 Jan 2023 05:44:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673437486;
        bh=RUXoMj/ujWbksjIw8O5icz+dONmjMye2yKjJ5W1B/hM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=T7G/xtGP5e5svTjPTxcz3oz/XaPoI9ppXOMYH7F5OIDVobyC9SToR1fV6KiZCB6wG
         NPHvpHMVTBZLrgIhMKcQE9R8+TKfJhe1ms27U0gjc68TrsEFESqAdTvhL2qdzgq+lA
         85Gz82UJBvG1VmiKF8OReah2fzcQMyYPkcRh61fs=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30BBijCS011974
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Jan 2023 05:44:45 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 11
 Jan 2023 05:44:45 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 11 Jan 2023 05:44:45 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiUkJ093892;
        Wed, 11 Jan 2023 05:44:41 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <rogerq@kernel.org>,
        <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 2/5] net: ethernet: ti: am65-cpts: add pps support
Date:   Wed, 11 Jan 2023 17:14:26 +0530
Message-ID: <20230111114429.1297557-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111114429.1297557-1-s-vadapalli@ti.com>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
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

CPTS doesn't have HW support for PPS ("pulse per second”) signal
generation, but it can be modeled by using Time Sync Router and routing
GenFx (periodic signal generator) output to CPTS_HWy_TS_PUSH (hardware time
stamp) input, and configuring GenFx to generate 1sec pulses.

     +------------------------+
     |          CPTS          |
     |                        |
 +--->CPTS_HW4_PUSH      GENFx+---+
 |   |                        |   |
 |   +------------------------+   |
 |                                |
 +--------------------------------+

Add corresponding support to am65-cpts driver. The DT property "ti,pps"
has to be used to enable PPS support and configure pair
[CPTS_HWy_TS_PUSH, GenFx].

Once enabled, PPS can be tested using ppstest tool:
 # ./ppstest /dev/pps0

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 85 +++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 9535396b28cd..6a0f09b497d1 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -176,6 +176,10 @@ struct am65_cpts {
 	u32 genf_enable;
 	u32 hw_ts_enable;
 	struct sk_buff_head txq;
+	bool pps_enabled;
+	bool pps_present;
+	u32 pps_hw_ts_idx;
+	u32 pps_genf_idx;
 	/* context save/restore */
 	u64 sr_cpts_ns;
 	u64 sr_ktime_ns;
@@ -319,8 +323,15 @@ static int am65_cpts_fifo_read(struct am65_cpts *cpts)
 		case AM65_CPTS_EV_HW:
 			pevent.index = am65_cpts_event_get_port(event) - 1;
 			pevent.timestamp = event->timestamp;
-			pevent.type = PTP_CLOCK_EXTTS;
-			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW p:%d t:%llu\n",
+			if (cpts->pps_enabled && pevent.index == cpts->pps_hw_ts_idx) {
+				pevent.type = PTP_CLOCK_PPSUSR;
+				pevent.pps_times.ts_real = ns_to_timespec64(pevent.timestamp);
+			} else {
+				pevent.type = PTP_CLOCK_EXTTS;
+			}
+			dev_dbg(cpts->dev, "AM65_CPTS_EV_HW:%s p:%d t:%llu\n",
+				pevent.type == PTP_CLOCK_EXTTS ?
+				"extts" : "pps",
 				pevent.index, event->timestamp);
 
 			ptp_clock_event(cpts->ptp_clock, &pevent);
@@ -507,7 +518,13 @@ static void am65_cpts_extts_enable_hw(struct am65_cpts *cpts, u32 index, int on)
 
 static int am65_cpts_extts_enable(struct am65_cpts *cpts, u32 index, int on)
 {
-	if (!!(cpts->hw_ts_enable & BIT(index)) == !!on)
+	if (index >= cpts->ptp_info.n_ext_ts)
+		return -ENXIO;
+
+	if (cpts->pps_present && index == cpts->pps_hw_ts_idx)
+		return -EINVAL;
+
+	if (((cpts->hw_ts_enable & BIT(index)) >> index) == on)
 		return 0;
 
 	mutex_lock(&cpts->ptp_clk_lock);
@@ -591,6 +608,12 @@ static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
 static int am65_cpts_perout_enable(struct am65_cpts *cpts,
 				   struct ptp_perout_request *req, int on)
 {
+	if (req->index >= cpts->ptp_info.n_per_out)
+		return -ENXIO;
+
+	if (cpts->pps_present && req->index == cpts->pps_genf_idx)
+		return -EINVAL;
+
 	if (!!(cpts->genf_enable & BIT(req->index)) == !!on)
 		return 0;
 
@@ -604,6 +627,48 @@ static int am65_cpts_perout_enable(struct am65_cpts *cpts,
 	return 0;
 }
 
+static int am65_cpts_pps_enable(struct am65_cpts *cpts, int on)
+{
+	int ret = 0;
+	struct timespec64 ts;
+	struct ptp_clock_request rq;
+	u64 ns;
+
+	if (!cpts->pps_present)
+		return -EINVAL;
+
+	if (cpts->pps_enabled == !!on)
+		return 0;
+
+	mutex_lock(&cpts->ptp_clk_lock);
+
+	if (on) {
+		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
+
+		ns = am65_cpts_gettime(cpts, NULL);
+		ts = ns_to_timespec64(ns);
+		rq.perout.period.sec = 1;
+		rq.perout.period.nsec = 0;
+		rq.perout.start.sec = ts.tv_sec + 2;
+		rq.perout.start.nsec = 0;
+		rq.perout.index = cpts->pps_genf_idx;
+
+		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
+		cpts->pps_enabled = true;
+	} else {
+		rq.perout.index = cpts->pps_genf_idx;
+		am65_cpts_perout_enable_hw(cpts, &rq.perout, on);
+		am65_cpts_extts_enable_hw(cpts, cpts->pps_hw_ts_idx, on);
+		cpts->pps_enabled = false;
+	}
+
+	mutex_unlock(&cpts->ptp_clk_lock);
+
+	dev_dbg(cpts->dev, "%s: pps: %s\n",
+		__func__, on ? "enabled" : "disabled");
+	return ret;
+}
+
 static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
 				struct ptp_clock_request *rq, int on)
 {
@@ -614,6 +679,8 @@ static int am65_cpts_ptp_enable(struct ptp_clock_info *ptp,
 		return am65_cpts_extts_enable(cpts, rq->extts.index, on);
 	case PTP_CLK_REQ_PEROUT:
 		return am65_cpts_perout_enable(cpts, &rq->perout, on);
+	case PTP_CLK_REQ_PPS:
+		return am65_cpts_pps_enable(cpts, on);
 	default:
 		break;
 	}
@@ -926,6 +993,12 @@ static int am65_cpts_of_parse(struct am65_cpts *cpts, struct device_node *node)
 	if (!of_property_read_u32(node, "ti,cpts-periodic-outputs", &prop[0]))
 		cpts->genf_num = prop[0];
 
+	if (!of_property_read_u32_array(node, "ti,pps", prop, 2)) {
+		cpts->pps_present = true;
+		cpts->pps_hw_ts_idx = prop[0];
+		cpts->pps_genf_idx = prop[1];
+	}
+
 	return cpts_of_mux_clk_setup(cpts, node);
 }
 
@@ -993,6 +1066,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 		cpts->ptp_info.n_ext_ts = cpts->ext_ts_inputs;
 	if (cpts->genf_num)
 		cpts->ptp_info.n_per_out = cpts->genf_num;
+	if (cpts->pps_present)
+		cpts->ptp_info.pps = 1;
 
 	am65_cpts_set_add_val(cpts);
 
@@ -1028,9 +1103,9 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 		return ERR_PTR(ret);
 	}
 
-	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u\n",
+	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u pps:%d\n",
 		 am65_cpts_read32(cpts, idver),
-		 cpts->refclk_freq, cpts->ts_add_val);
+		 cpts->refclk_freq, cpts->ts_add_val, cpts->pps_present);
 
 	return cpts;
 
-- 
2.25.1

