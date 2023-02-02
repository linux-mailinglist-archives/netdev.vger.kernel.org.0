Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D5687A89
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjBBKpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjBBKot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE75F8CA95;
        Thu,  2 Feb 2023 02:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334683; x=1706870683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eYSUSNvcMtkcencWWMzkog0EFZDpyw2n8vcZMXE9pIg=;
  b=o8yYbE3k09OY2O53aqJlzzZjc2gKO0r6p8T7QXOdmd5mX7X5IIR7XOtR
   DpuSM/vb2Dk+srdNtQYRq4lHJ8WpXuTroT/VT/O/y6m6NF9HGNC97XdrW
   GWWF6m+JIgxrZyq+1hQ0mgDj4CyF5+GrRPWd4jJ+vzIH5SvP9D/wNeO+7
   Pvjc9BPMi7bMn4U5/CW597clgAkwCxbh294vKkbqVWsiJ2sdmHUvrNKS+
   cu3y1xvXZIBvv+ndOFi7wUHp1KRXA4sjwef5WjO6OxqSCehu7dB66425O
   LFeQA9AqB/D8jBP7j6u2UnLEEhu/IHjMbmJbkYWh13uT5tOmw0YsDOqw0
   w==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="199297152"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:41 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:38 -0700
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
Subject: [PATCH net-next 06/10] net: microchip: sparx5: add function for calculating PTP basetime
Date:   Thu, 2 Feb 2023 11:43:51 +0100
Message-ID: <20230202104355.1612823-7-daniel.machon@microchip.com>
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

Add a new function for calculating PTP basetime, required by the stream
gate scheduler to calculate gate state (open / close).

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.h   |  5 ++
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |  3 +-
 .../ethernet/microchip/sparx5/sparx5_qos.c    | 57 +++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 709cad534f50..fd71b2ede49a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -396,6 +396,7 @@ int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
 void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
 				 struct sk_buff *skb);
 irqreturn_t sparx5_ptp_irq_handler(int irq, void *args);
+int sparx5_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 
 /* sparx5_vcap_impl.c */
 int sparx5_vcap_init(struct sparx5 *sparx5);
@@ -481,6 +482,10 @@ int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_fm *fm, u32 *id);
 int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id);
 
+/* sparx5_qos.c */
+void sparx5_new_base_time(struct sparx5 *sparx5, const u32 cycle_time,
+			  const ktime_t org_base_time, ktime_t *new_base_time);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0ed1ea7727c5..af85d66248b2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -476,8 +476,7 @@ static int sparx5_ptp_settime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
-static int sparx5_ptp_gettime64(struct ptp_clock_info *ptp,
-				struct timespec64 *ts)
+int sparx5_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
 	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
 	struct sparx5 *sparx5 = phc->sparx5;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index 379e540e5e6a..ebfdbbf0a1ce 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -9,6 +9,63 @@
 #include "sparx5_main.h"
 #include "sparx5_qos.h"
 
+/* Calculate new base_time based on cycle_time.
+ *
+ * The hardware requires a base_time that is always in the future.
+ * We define threshold_time as current_time + (2 * cycle_time).
+ * If base_time is below threshold_time this function recalculates it to be in
+ * the interval:
+ * threshold_time <= base_time < (threshold_time + cycle_time)
+ *
+ * A very simple algorithm could be like this:
+ * new_base_time = org_base_time + N * cycle_time
+ * using the lowest N so (new_base_time >= threshold_time
+ */
+void sparx5_new_base_time(struct sparx5 *sparx5, const u32 cycle_time,
+			  const ktime_t org_base_time, ktime_t *new_base_time)
+{
+	ktime_t current_time, threshold_time, new_time;
+	struct timespec64 ts;
+	u64 nr_of_cycles_p2;
+	u64 nr_of_cycles;
+	u64 diff_time;
+
+	new_time = org_base_time;
+
+	sparx5_ptp_gettime64(&sparx5->phc[SPARX5_PHC_PORT].info, &ts);
+	current_time = timespec64_to_ktime(ts);
+	threshold_time = current_time + (2 * cycle_time);
+	diff_time = threshold_time - new_time;
+	nr_of_cycles = div_u64(diff_time, cycle_time);
+	nr_of_cycles_p2 = 1; /* Use 2^0 as start value */
+
+	if (new_time >= threshold_time) {
+		*new_base_time = new_time;
+		return;
+	}
+
+	/* Calculate the smallest power of 2 (nr_of_cycles_p2)
+	 * that is larger than nr_of_cycles.
+	 */
+	while (nr_of_cycles_p2 < nr_of_cycles)
+		nr_of_cycles_p2 <<= 1; /* Next (higher) power of 2 */
+
+	/* Add as big chunks (power of 2 * cycle_time)
+	 * as possible for each power of 2
+	 */
+	while (nr_of_cycles_p2) {
+		if (new_time < threshold_time) {
+			new_time += cycle_time * nr_of_cycles_p2;
+			while (new_time < threshold_time)
+				new_time += cycle_time * nr_of_cycles_p2;
+			new_time -= cycle_time * nr_of_cycles_p2;
+		}
+		nr_of_cycles_p2 >>= 1; /* Next (lower) power of 2 */
+	}
+	new_time += cycle_time;
+	*new_base_time = new_time;
+}
+
 /* Max rates for leak groups */
 static const u32 spx5_hsch_max_group_rate[SPX5_HSCH_LEAK_GRP_CNT] = {
 	1048568, /*  1.049 Gbps */
-- 
2.34.1

