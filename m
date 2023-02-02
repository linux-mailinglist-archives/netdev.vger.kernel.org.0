Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F75687A8B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjBBKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjBBKox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F7089373;
        Thu,  2 Feb 2023 02:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334687; x=1706870687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B9RCm+okppDiGlqjIHT3vn8ERvt9WgnVpJcJyAWYLSo=;
  b=hahRFjVTxsxn4rbW4ASPeg8alqYyZa+xV1R3Prn7ejm6n3DrDmHTK6XX
   bzgfbyBP/kh9hbzsO8z3mAj+qeBQNLzaai+AMwrqMT3KfRRLnruZQeATS
   jL/ZxWL2s7qNnhR/KWVjbpQNP1aLaysi3gWE0jhv9o5hB7Cccy66qhib9
   g0dUgSr6pF92yjkGo1TCGNyk1j6YIHpsnt6ezIZ+GQGi+w4Kz8MMVuoGR
   rzmeIu3hcBZPNMbCb0JccpAhdS5BhuqTvnaKDRAPm/J1PaXt0nzB+jBCH
   z0mlZSeH7S/LY8bJPWd+oA5GR5KtqXM165kWFlcxVAOrHpv/bUbV/RWsw
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="198600189"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:45 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:42 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <horatiu.vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 07/10] net: microchip: sparx5: add support for PSFP stream gates
Date:   Thu, 2 Feb 2023 11:43:52 +0100
Message-ID: <20230202104355.1612823-8-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202104355.1612823-1-daniel.machon@microchip.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring PSFP stream gates (IEEE 802.1Q-2018,
8.6.5.1.2).

Stream gates are time-based policers used by PSFP. Frames are dropped
based on the gate state (OPEN/ CLOSE), whose state will be altered based
on the Gate Control List (GCL) and current PTP time. Apart from
time-based policing, stream gates can alter egress queue selection for
the frames that pass through the Gate. This is done through Internal
Priority Selector (IPS). Stream gates are mapped from stream filters.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.h   |  31 ++++
 .../ethernet/microchip/sparx5/sparx5_psfp.c   | 148 ++++++++++++++++++
 2 files changed, 179 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index fd71b2ede49a..5a2d893749fd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -474,14 +474,45 @@ struct sparx5_policer {
 int sparx5_policer_conf_set(struct sparx5 *sparx5, struct sparx5_policer *pol);
 
 /* sparx5_psfp.c */
+#define SPX5_PSFP_GCE_CNT 4
+#define SPX5_PSFP_SG_CNT 1024
+#define SPX5_PSFP_SG_MIN_CYCLE_TIME_NS (1 * NSEC_PER_USEC)
+#define SPX5_PSFP_SG_MAX_CYCLE_TIME_NS ((1 * NSEC_PER_SEC) - 1)
+#define SPX5_PSFP_SG_MAX_IPV (SPX5_PRIOS - 1)
+#define SPX5_PSFP_SG_OPEN (SPX5_PSFP_SG_CNT - 1)
+#define SPX5_PSFP_SG_CYCLE_TIME_DEFAULT 1000000
+#define SPX5_PSFP_SF_MAX_SDU 16383
+
 struct sparx5_psfp_fm {
 	struct sparx5_policer pol;
 };
 
+struct sparx5_psfp_gce {
+	bool gate_state;            /* StreamGateState */
+	u32 interval;               /* TimeInterval */
+	u32 ipv;                    /* InternalPriorityValue */
+	u32 maxoctets;              /* IntervalOctetMax */
+};
+
+struct sparx5_psfp_sg {
+	bool gate_state;            /* PSFPAdminGateStates */
+	bool gate_enabled;          /* PSFPGateEnabled */
+	u32 ipv;                    /* PSFPAdminIPV */
+	struct timespec64 basetime; /* PSFPAdminBaseTime */
+	u32 cycletime;              /* PSFPAdminCycleTime */
+	u32 cycletimeext;           /* PSFPAdminCycleTimeExtension */
+	u32 num_entries;            /* PSFPAdminControlListLength */
+	struct sparx5_psfp_gce gce[SPX5_PSFP_GCE_CNT];
+};
+
 int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_fm *fm, u32 *id);
 int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id);
 
+int sparx5_psfp_sg_add(struct sparx5 *sparx5, u32 uidx,
+		       struct sparx5_psfp_sg *sg, u32 *id);
+int sparx5_psfp_sg_del(struct sparx5 *sparx5, u32 id);
+
 /* sparx5_qos.c */
 void sparx5_new_base_time(struct sparx5 *sparx5, const u32 cycle_time,
 			  const ktime_t org_base_time, ktime_t *new_base_time);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
index 7c7390372c71..883becd6781b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -7,9 +7,26 @@
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
 
+#define SPX5_PSFP_SG_CONFIG_CHANGE_SLEEP 1000
+#define SPX5_PSFP_SG_CONFIG_CHANGE_TIMEO 100000
+
 /* Pool of available service policers */
 static struct sparx5_pool_entry sparx5_psfp_fm_pool[SPX5_SDLB_CNT];
 
+/* Pool of available stream gates */
+static struct sparx5_pool_entry sparx5_psfp_sg_pool[SPX5_PSFP_SG_CNT];
+
+static int sparx5_psfp_sg_get(u32 idx, u32 *id)
+{
+	return sparx5_pool_get_with_idx(sparx5_psfp_sg_pool, SPX5_PSFP_SG_CNT,
+					idx, id);
+}
+
+static int sparx5_psfp_sg_put(u32 id)
+{
+	return sparx5_pool_put(sparx5_psfp_sg_pool, SPX5_PSFP_SG_CNT, id);
+}
+
 static int sparx5_psfp_fm_get(u32 idx, u32 *id)
 {
 	return sparx5_pool_get_with_idx(sparx5_psfp_fm_pool, SPX5_SDLB_CNT, idx,
@@ -21,6 +38,97 @@ static int sparx5_psfp_fm_put(u32 id)
 	return sparx5_pool_put(sparx5_psfp_fm_pool, SPX5_SDLB_CNT, id);
 }
 
+/* Internal priority value to internal priority selector */
+static u32 sparx5_psfp_ipv_to_ips(s32 ipv)
+{
+	return ipv > 0 ? (ipv | BIT(3)) : 0;
+}
+
+static int sparx5_psfp_sgid_get_status(struct sparx5 *sparx5)
+{
+	return spx5_rd(sparx5, ANA_AC_SG_ACCESS_CTRL);
+}
+
+static int sparx5_psfp_sgid_wait_for_completion(struct sparx5 *sparx5)
+{
+	u32 val;
+
+	return readx_poll_timeout(sparx5_psfp_sgid_get_status, sparx5, val,
+				  !ANA_AC_SG_ACCESS_CTRL_CONFIG_CHANGE_GET(val),
+				  SPX5_PSFP_SG_CONFIG_CHANGE_SLEEP,
+				  SPX5_PSFP_SG_CONFIG_CHANGE_TIMEO);
+}
+
+static void sparx5_psfp_sg_config_change(struct sparx5 *sparx5, u32 id)
+{
+	spx5_wr(ANA_AC_SG_ACCESS_CTRL_SGID_SET(id), sparx5,
+		ANA_AC_SG_ACCESS_CTRL);
+
+	spx5_wr(ANA_AC_SG_ACCESS_CTRL_CONFIG_CHANGE_SET(1) |
+		ANA_AC_SG_ACCESS_CTRL_SGID_SET(id),
+		sparx5, ANA_AC_SG_ACCESS_CTRL);
+
+	if (sparx5_psfp_sgid_wait_for_completion(sparx5) < 0)
+		pr_debug("%s:%d timed out waiting for sgid completion",
+			 __func__, __LINE__);
+}
+
+static int sparx5_psfp_sg_set(struct sparx5 *sparx5, u32 id,
+			      const struct sparx5_psfp_sg *sg)
+{
+	u32 ips, base_lsb, base_msb, accum_time_interval = 0;
+	const struct sparx5_psfp_gce *gce;
+	int i;
+
+	ips = sparx5_psfp_ipv_to_ips(sg->ipv);
+	base_lsb = sg->basetime.tv_sec & 0xffffffff;
+	base_msb = sg->basetime.tv_sec >> 32;
+
+	/* Set stream gate id */
+	spx5_wr(ANA_AC_SG_ACCESS_CTRL_SGID_SET(id), sparx5,
+		ANA_AC_SG_ACCESS_CTRL);
+
+	/* Write AdminPSFP values */
+	spx5_wr(sg->basetime.tv_nsec, sparx5, ANA_AC_SG_CONFIG_REG_1);
+	spx5_wr(base_lsb, sparx5, ANA_AC_SG_CONFIG_REG_2);
+
+	spx5_rmw(ANA_AC_SG_CONFIG_REG_3_BASE_TIME_SEC_MSB_SET(base_msb) |
+		ANA_AC_SG_CONFIG_REG_3_INIT_IPS_SET(ips) |
+		ANA_AC_SG_CONFIG_REG_3_LIST_LENGTH_SET(sg->num_entries) |
+		ANA_AC_SG_CONFIG_REG_3_INIT_GATE_STATE_SET(sg->gate_state) |
+		ANA_AC_SG_CONFIG_REG_3_GATE_ENABLE_SET(1),
+		ANA_AC_SG_CONFIG_REG_3_BASE_TIME_SEC_MSB |
+		ANA_AC_SG_CONFIG_REG_3_INIT_IPS |
+		ANA_AC_SG_CONFIG_REG_3_LIST_LENGTH |
+		ANA_AC_SG_CONFIG_REG_3_INIT_GATE_STATE |
+		ANA_AC_SG_CONFIG_REG_3_GATE_ENABLE,
+		sparx5, ANA_AC_SG_CONFIG_REG_3);
+
+	spx5_wr(sg->cycletime, sparx5, ANA_AC_SG_CONFIG_REG_4);
+	spx5_wr(sg->cycletimeext, sparx5, ANA_AC_SG_CONFIG_REG_5);
+
+	/* For each scheduling entry */
+	for (i = 0; i < sg->num_entries; i++) {
+		gce = &sg->gce[i];
+		ips = sparx5_psfp_ipv_to_ips(gce->ipv);
+		/* hardware needs TimeInterval to be cumulative */
+		accum_time_interval += gce->interval;
+		/* Set gate state */
+		spx5_wr(ANA_AC_SG_GCL_GS_CONFIG_IPS_SET(ips) |
+			ANA_AC_SG_GCL_GS_CONFIG_GATE_STATE_SET(gce->gate_state),
+			sparx5, ANA_AC_SG_GCL_GS_CONFIG(i));
+
+		/* Set time interval */
+		spx5_wr(accum_time_interval, sparx5,
+			ANA_AC_SG_GCL_TI_CONFIG(i));
+
+		/* Set maximum octets */
+		spx5_wr(gce->maxoctets, sparx5, ANA_AC_SG_GCL_OCT_CONFIG(i));
+	}
+
+	return 0;
+}
+
 static int sparx5_sdlb_conf_set(struct sparx5 *sparx5,
 				struct sparx5_psfp_fm *fm)
 {
@@ -37,6 +145,46 @@ static int sparx5_sdlb_conf_set(struct sparx5 *sparx5,
 	return sparx5_sdlb_group_action(sparx5, fm->pol.group, fm->pol.idx);
 }
 
+int sparx5_psfp_sg_add(struct sparx5 *sparx5, u32 uidx,
+		       struct sparx5_psfp_sg *sg, u32 *id)
+{
+	ktime_t basetime;
+	int ret;
+
+	ret = sparx5_psfp_sg_get(uidx, id);
+	if (ret < 0)
+		return ret;
+	/* Was already in use, no need to reconfigure */
+	if (ret > 1)
+		return 0;
+
+	/* Calculate basetime for this stream gate */
+	sparx5_new_base_time(sparx5, sg->cycletime, 0, &basetime);
+	sg->basetime = ktime_to_timespec64(basetime);
+
+	sparx5_psfp_sg_set(sparx5, *id, sg);
+
+	/* Signal hardware to copy AdminPSFP values into OperPSFP values */
+	sparx5_psfp_sg_config_change(sparx5, *id);
+
+	return 0;
+}
+
+int sparx5_psfp_sg_del(struct sparx5 *sparx5, u32 id)
+{
+	const struct sparx5_psfp_sg sg = { 0 };
+	int ret;
+
+	ret = sparx5_psfp_sg_put(id);
+	if (ret < 0)
+		return ret;
+	/* Stream gate still in use ? */
+	if (ret > 0)
+		return 0;
+
+	return sparx5_psfp_sg_set(sparx5, id, &sg);
+}
+
 int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_fm *fm, u32 *id)
 {
-- 
2.34.1

