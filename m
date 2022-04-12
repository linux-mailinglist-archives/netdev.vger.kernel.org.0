Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D804FDE70
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbiDLLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353413AbiDLLs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:48:26 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355A314007;
        Tue, 12 Apr 2022 03:29:42 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23CATWKK070826;
        Tue, 12 Apr 2022 05:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649759372;
        bh=EjUXxWw2ygoGMEKMiSNvIbyBo+AJIui7TU2V7XZPxEQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=p3ycFfD7k77aPwdbLQJ9zz/CwNSW2UK95zZ+r3qaj2Cqc7S7xM4ukWlX5adMyLGf1
         T8fdIZYom57lxa7JO1kho3IKGi5Nfjkjmoq8j//mOgHahdB2Ab9wHf/2C8Ywxv3Nbk
         9BX9YAgkRtHS2Rk9+SQFNr21lVl22qcyMYWoFdow=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23CATWwG018339
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 05:29:32 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 05:29:31 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 05:29:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23CATUFT014590;
        Tue, 12 Apr 2022 05:29:31 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 1/3] drivers: net: cpsw: ale: add broadcast/multicast rate limit support
Date:   Tue, 12 Apr 2022 13:29:27 +0300
Message-ID: <20220412102929.30719-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220412102929.30719-1-grygorii.strashko@ti.com>
References: <20220412102929.30719-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPSW ALE supports feature to rate limit number ingress
broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/MC
storm prevention.

The ALE BC/MC packet rate limit configuration consist of two parts:
- global
  ALE_CONTROL.ENABLE_RATE_LIMIT bit 0 which enables rate limiting globally
  ALE_PRESCALE.PRESCALE specifies rate limiting interval
- per-port
  ALE_PORTCTLx.BCASTMCAST/_LIMIT specifies number of BC/MC packets allowed
  per rate limiting interval.
  When port.BCASTMCAST/_LIMIT is 0 rate limiting is disabled for Port.

When BC/MC packet rate limiting is enabled the number of allowed packets
per/sec is defined as:
  number_of_packets/sec = (Fclk / ALE_PRESCALE) * port.BCASTMCAST/_LIMIT

Hence, the ALE_PRESCALE configuration is common for all ports the 1ms
interval is selected and configured during ALE initialization while
port.BCAST/MCAST_LIMIT are configured per-port.
This allows to achieve:
 - min number_of_packets = 1000 when port.BCAST/MCAST_LIMIT = 1
 - max number_of_packets = 1000 * 255 = 255000
   when port.BCAST/MCAST_LIMIT = 0xFF

The ALE_CONTROL.ENABLE_RATE_LIMIT can also be enabled once during ALE
initialization as rate limiting enabled by non zero port.BCASTMCAST/_LIMIT
values.

This patch implements above logic in ALE and adds new ALE APIs
 cpsw_ale_rx_ratelimit_bc();
 cpsw_ale_rx_ratelimit_mc();

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 66 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_ale.h |  2 +
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 1ef0aaef5c61..231370e9a801 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -50,6 +50,8 @@
 /* ALE_AGING_TIMER */
 #define ALE_AGING_TIMER_MASK	GENMASK(23, 0)
 
+#define ALE_RATE_LIMIT_MIN_PPS 1000
+
 /**
  * struct ale_entry_fld - The ALE tbl entry field description
  * @start_bit: field start bit
@@ -1136,6 +1138,50 @@ int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control)
 	return tmp & BITMASK(info->bits);
 }
 
+int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps)
+
+{
+	int val = ratelimit_pps / ALE_RATE_LIMIT_MIN_PPS;
+	u32 remainder = ratelimit_pps % ALE_RATE_LIMIT_MIN_PPS;
+
+	if (ratelimit_pps && !val) {
+		dev_err(ale->params.dev, "ALE MC port:%d ratelimit min value 1000pps\n", port);
+		return -EINVAL;
+	}
+
+	if (remainder)
+		dev_info(ale->params.dev, "ALE port:%d MC ratelimit set to %dpps (requested %d)\n",
+			 port, ratelimit_pps - remainder, ratelimit_pps);
+
+	cpsw_ale_control_set(ale, port, ALE_PORT_MCAST_LIMIT, val);
+
+	dev_dbg(ale->params.dev, "ALE port:%d MC ratelimit set %d\n",
+		port, val * ALE_RATE_LIMIT_MIN_PPS);
+	return 0;
+}
+
+int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps)
+
+{
+	int val = ratelimit_pps / ALE_RATE_LIMIT_MIN_PPS;
+	u32 remainder = ratelimit_pps % ALE_RATE_LIMIT_MIN_PPS;
+
+	if (ratelimit_pps && !val) {
+		dev_err(ale->params.dev, "ALE port:%d BC ratelimit min value 1000pps\n", port);
+		return -EINVAL;
+	}
+
+	if (remainder)
+		dev_info(ale->params.dev, "ALE port:%d BC ratelimit set to %dpps (requested %d)\n",
+			 port, ratelimit_pps - remainder, ratelimit_pps);
+
+	cpsw_ale_control_set(ale, port, ALE_PORT_BCAST_LIMIT, val);
+
+	dev_dbg(ale->params.dev, "ALE port:%d BC ratelimit set %d\n",
+		port, val * ALE_RATE_LIMIT_MIN_PPS);
+	return 0;
+}
+
 static void cpsw_ale_timer(struct timer_list *t)
 {
 	struct cpsw_ale *ale = from_timer(ale, t, timer);
@@ -1199,6 +1245,26 @@ static void cpsw_ale_aging_stop(struct cpsw_ale *ale)
 
 void cpsw_ale_start(struct cpsw_ale *ale)
 {
+	unsigned long ale_prescale;
+
+	/* configure Broadcast and Multicast Rate Limit
+	 * number_of_packets = (Fclk / ALE_PRESCALE) * port.BCAST/MCAST_LIMIT
+	 * ALE_PRESCALE width is 19bit and min value 0x10
+	 * port.BCAST/MCAST_LIMIT is 8bit
+	 *
+	 * For multi port configuration support the ALE_PRESCALE is configured to 1ms interval,
+	 * which allows to configure port.BCAST/MCAST_LIMIT per port and achieve:
+	 * min number_of_packets = 1000 when port.BCAST/MCAST_LIMIT = 1
+	 * max number_of_packets = 1000 * 255 = 255000 when port.BCAST/MCAST_LIMIT = 0xFF
+	 */
+	ale_prescale = ale->params.bus_freq / ALE_RATE_LIMIT_MIN_PPS;
+	writel((u32)ale_prescale, ale->params.ale_regs + ALE_PRESCALE);
+
+	/* Allow MC/BC rate limiting globally.
+	 * The actual Rate Limit cfg enabled per-port by port.BCAST/MCAST_LIMIT
+	 */
+	cpsw_ale_control_set(ale, 0, ALE_RATE_LIMIT, 1);
+
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 1);
 	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 13fe47687fde..aba4572cfa3b 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -120,6 +120,8 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 			int reg_mcast, int unreg_mcast);
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port);
 void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port);
+int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps);
+int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps);
 
 int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control);
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port,
-- 
2.17.1

