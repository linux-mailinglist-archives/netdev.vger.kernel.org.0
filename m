Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1756B1D2CD1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgENK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:29:48 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:35075
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbgENK3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:29:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFaNVlWJwXUuD7uVuv4BQckNMQ2R0okIhgXKLB+49ulWy9cj3LxCMt3BXyTZPlL3GixnwlN2WesDNO/gHso93LUttQVXa2bIHl24RItMDkrbRCO1fGcIynf7G8B5pQNs0d9/iG+e+NI6DHzWlY/ijZtdz2/w8NocsE+Jg1MBG2qONEPbDdTTnA5b+zO0/JlnHm9XDaXIAUM1Ce58y3xGJqgaTUyJn3jTwvlyROVBe3RkCWjtjztWrThcTPt0ZPXPJFbdof9+u5l6h6od/8LJT8FXUaAxlk2k3+7Kmmn9GW+9t0d0dOwr6z/aRSwnxdmxO0vlTlXhUyjiS8Q5aONM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VaO7dRRNy6dDz1lAvp2G1CY41WtIzcDE8smzttzB+Y=;
 b=YgFWI+sZzeMRNNYmuFCqEjwvB/IOoXnVCXVNOobAzs+cFeyAITekytiXGfPZEEORch8eCE6s+cpXUxnw/jI9DgUeobmQdCWRXg0cmudp6GZawXtV9idAfXGU7NnWue5xJ3xyp25F57l+Ak+oSEVjvs65hTCgQNa6AVd3CplR+wqRySZ2e5BwdcWb78KnNATYBlKuX+6V3S/tYoaaqLCZ4GnhRdxbsFC8+6u0zYR7RAID3DynpIFZdg4BnH1y88Ox6CPAa7noFmojpolCjyUb5jD44phVwaAy918mFI+ZC6nrsCbRu6vUAfHquKhRiGtNEUiz9Ky9xDXo7INAkQK0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VaO7dRRNy6dDz1lAvp2G1CY41WtIzcDE8smzttzB+Y=;
 b=hGdbBrVe4eyah9/4dJvWQb8lYqBStR7S/ZenU3vm+mxqqFW7FDGamCt4fU7KsBBsFdLy17UqTXc3K/5YQn7GLqEM6b7ZRlW34WgPlcjwAFSf+sY5lRCT0VdamI3bWbvuXkEIRmx6KMZkCd7A4j7s5rvTaqLLtXIaddLG7sIh1Ww=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB6752.eurprd06.prod.outlook.com (2603:10a6:800:181::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Thu, 14 May
 2020 10:29:43 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 10:29:43 +0000
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Artem Panfilov <panfilov.artyom@gmail.com>,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Subject: [PATCH 1/3] net: stmmac: gmac3: add auxiliary snapshot support
Date:   Thu, 14 May 2020 12:28:06 +0200
Message-Id: <20200514102808.31163-2-olivier.dautricourt@orolia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:101:16::34) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR2PR09CA0022.eurprd09.prod.outlook.com (2603:10a6:101:16::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 10:29:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a68d5074-2654-4bd8-c5f5-08d7f7f1b6ff
X-MS-TrafficTypeDiagnostic: VI1PR06MB6752:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB675242121AF890380391BB088FBC0@VI1PR06MB6752.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zSWO2m+PbQaD85YRaUJ5KQDAMehB5PnkD8BY5wAY9N5VOREA3Oc4SB8G6VlcsM1Ou1CWv7CwnkrIg/hh7duYbT7lRslNeIzU05Ivv8QLAnkan9xxHmg3FAJw3UISl82kGbwtnG84JLhRz4u53EjUU8BCOqu45TFdbL0d10Q+vQs9i+eQb9PlAy1zFi5196nESr/M6OSFyodGWGEwE4NIpqSbLtmhYuM06NBXni7erWopsP0aiuv/kStwyrN0bRYdYfurij2DpwTroVp69B2n1lkx4V9u/k5xZpvUwip0BPQhCFruWBuZt6mUcPaq2vaG/3pBduuMCdvokIwuoXj0VZ3Au76sy73O3dVVq30TdHrNHtjW3UPqtZeskG9bzZ+xdebjXM9gdr9hz72iLJo/NI/fL9rFSiEuPO8lI0a5iiT/YLysTAr80Q/FQDbUVOO4sK2FHzbTsGDOaUV48RtuvSGNs6R104XXpvWqmV/b+/WyQG4xPzZ9BtqR55MBde2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(8676002)(44832011)(6486002)(66476007)(66556008)(2616005)(66946007)(110136005)(316002)(107886003)(2906002)(54906003)(4326008)(6666004)(30864003)(6512007)(69590400007)(478600001)(8936002)(52116002)(16526019)(5660300002)(1076003)(186003)(36756003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VEonB8bT8prj41Hyv2W1kd/9cadpEbXdPR8lxLdjos8An2zbi5TX48K3bcSHTaZiZCgsOCwlbzVWRYBEkhHif75hD4POpHnxsykpSddOi25iFnVEgyQ/M/SrgVr2IcMpQstD5tsFaoOLdm/Nj+OX+dBlVPzi7wa9yEQQnOV169SIQ4mlCikwcrJggLClzT60O4LO9qvSnlBetApAMsk/a/taaeTq24lZ/PqFChrDWkOilBetPSvkMsdFCT7t8NUgIG7fuZKTxl0rABUmb8YF46i8W15S/j0J4y8msmigasX35UpDbqKrvl1diqBklRClNWcMFa/epsdEPGhDa+FT/JY1iP2Y8fM3+K8mK+9aba1N+ey/qSSN3ip0KeXsadO1kkUTUkjaSNXD9M+9TNOfoGAw96vzJRfjWtkWK1FyZtK++s701TTYUActQHQcVf/bzGBb/8az+4tFoMusz7j+MiYxiFWNqYAU/n7p7xrqBJ7es/LJKPW7lfgpmA6MWjwFmHtsLYC7L85Y3g5ULE39lgilySLSAUP17Bp3NP4JJAA=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68d5074-2654-4bd8-c5f5-08d7f7f1b6ff
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 10:29:42.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2a+4srBbiGHGY8o4tsMejTZyThPYwMyCFoH36hS525wVgwrWnBnhNAxCsofEVL9bJAoynBVM1A6p585cIftd8/rlvCCoBS2yCf2r+DjsyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB6752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Artem Panfilov <panfilov.artyom@gmail.com>

This patch adds support for time stamping external inputs for GMAC3.

The documentation defines 4 auxiliary snapshots ATSEN0 to ATSEN3 which
can be toggled by writing the Timestamp Control Register.

When the gmac detects a pps rising edge on one of it's auxiliary inputs,
an isr of type GMAC_INT_STATUS_TSTAMP will be triggered.
We use this isr to generate a ptp clock event of type PTP_CLOCK_EXTTS
with the following content:

  - Time of which the event occurred in ns.
  - All the extts for which the event was generated (0000 - 1111)

Note from the documentation:
"When more than one bit is set at the same time, it means
that corresponding auxiliary triggers were sampled at the same clock"

When the GMAC writes it's auxiliary snapshots on it's fifo
and that fifo is full, it will discard any new auxiliary snapshot until
we read the fifo. By reading on each isr, it is unlikely that
we will loose the 1pps external timestamps.

Events for one auxiliary input can be requested through the
PTP_EXTTS_REQUEST ioctl and read as already implemented in the uapi.

This patch introduces 2 functions:

    stmmac_set_hw_tstamping and stmmac_get_hw_tstamping

Each time we initialize the timestamping, we read the current
value of PTP_TCR and patch with new configuration without setting
the ATSENX flags again, which are set independently by the user
through the ioctl.
This allows to not loose the activated external events between each
initialization of the timestamping, and not force the user to redo
ioctl.

Signed-off-by: Olivier Dautricourt <olivier.dautricourt@orolia.com>
Signed-off-by: Artem Panfilov <panfilov.artyom@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  3 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 24 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  9 ++--
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 10 ++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 44 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  | 20 +++++++++
 7 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index b70d44ac0990..5cff6c100258 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -41,8 +41,7 @@
 #define	GMAC_INT_DISABLE_PCS	(GMAC_INT_DISABLE_RGMII | \
 				 GMAC_INT_DISABLE_PCSLINK | \
 				 GMAC_INT_DISABLE_PCSAN)
-#define	GMAC_INT_DEFAULT_MASK	(GMAC_INT_DISABLE_TIMESTAMP | \
-				 GMAC_INT_DISABLE_PCS)
+#define	GMAC_INT_DEFAULT_MASK	GMAC_INT_DISABLE_PCS
 
 /* PMT Control and Status */
 #define GMAC_PMT		0x0000002c
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index efc6ec1b8027..3895fe9396e5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -20,6 +20,7 @@
 #include "stmmac.h"
 #include "stmmac_pcs.h"
 #include "dwmac1000.h"
+#include "stmmac_ptp.h"
 
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
@@ -300,9 +301,29 @@ static void dwmac1000_rgsmii(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 	}
 }
 
+static void dwmac1000_ptp_isr(struct stmmac_priv *priv)
+{
+	struct ptp_clock_event event;
+	u32 reg_value;
+	u64 ns;
+
+	reg_value = readl(priv->ioaddr + PTP_GMAC3_TSR);
+
+	ns = readl(priv->ioaddr + PTP_GMAC3_AUXTSLO);
+	ns += readl(priv->ioaddr + PTP_GMAC3_AUXTSHI) * 1000000000ULL;
+
+	event.timestamp = ns;
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = (reg_value & PTP_GMAC3_ATSSTN_MASK) >>
+			PTP_GMAC3_ATSSTN_SHIFT;
+	ptp_clock_event(priv->ptp_clock, &event);
+}
+
 static int dwmac1000_irq_status(struct mac_device_info *hw,
 				struct stmmac_extra_stats *x)
 {
+	struct stmmac_priv *priv =
+		container_of(x, struct stmmac_priv, xstats);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 intr_status = readl(ioaddr + GMAC_INT_STATUS);
 	u32 intr_mask = readl(ioaddr + GMAC_INT_MASK);
@@ -324,6 +345,9 @@ static int dwmac1000_irq_status(struct mac_device_info *hw,
 		x->irq_receive_pmt_irq_n++;
 	}
 
+	if (intr_status & GMAC_INT_STATUS_TSTAMP)
+		dwmac1000_ptp_isr(priv);
+
 	/* MAC tx/rx EEE LPI entry/exit interrupts */
 	if (intr_status & GMAC_INT_STATUS_LPIIS) {
 		/* Clean LPI interrupt by reading the Reg 12 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index ffe2d63389b8..8fa63d059231 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -492,7 +492,8 @@ struct stmmac_ops {
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
-	void (*config_hw_tstamping) (void __iomem *ioaddr, u32 data);
+	void (*get_hw_tstamping)(void __iomem *ioaddr, u32 *data);
+	void (*set_hw_tstamping)(void __iomem *ioaddr, u32 data);
 	void (*config_sub_second_increment)(void __iomem *ioaddr, u32 ptp_clock,
 					   int gmac4, u32 *ssinc);
 	int (*init_systime) (void __iomem *ioaddr, u32 sec, u32 nsec);
@@ -502,8 +503,10 @@ struct stmmac_hwtimestamp {
 	void (*get_systime) (void __iomem *ioaddr, u64 *systime);
 };
 
-#define stmmac_config_hw_tstamping(__priv, __args...) \
-	stmmac_do_void_callback(__priv, ptp, config_hw_tstamping, __args)
+#define stmmac_get_hw_tstamping(__priv, __args...) \
+	stmmac_do_void_callback(__priv, ptp, get_hw_tstamping, __args)
+#define stmmac_set_hw_tstamping(__priv, __args...) \
+	stmmac_do_void_callback(__priv, ptp, set_hw_tstamping, __args)
 #define stmmac_config_sub_second_increment(__priv, __args...) \
 	stmmac_do_void_callback(__priv, ptp, config_sub_second_increment, __args)
 #define stmmac_init_systime(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index d291612eeafb..b974d83afe67 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -15,7 +15,12 @@
 #include "common.h"
 #include "stmmac_ptp.h"
 
-static void config_hw_tstamping(void __iomem *ioaddr, u32 data)
+static void get_hw_tstamping(void __iomem *ioaddr, u32 *data)
+{
+	*data = readl(ioaddr + PTP_TCR);
+}
+
+static void set_hw_tstamping(void __iomem *ioaddr, u32 data)
 {
 	writel(data, ioaddr + PTP_TCR);
 }
@@ -154,7 +159,8 @@ static void get_systime(void __iomem *ioaddr, u64 *systime)
 }
 
 const struct stmmac_hwtimestamp stmmac_ptp = {
-	.config_hw_tstamping = config_hw_tstamping,
+	.get_hw_tstamping = get_hw_tstamping,
+	.set_hw_tstamping = set_hw_tstamping,
 	.init_systime = init_systime,
 	.config_sub_second_increment = config_sub_second_increment,
 	.config_addend = config_addend,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a999d6b33a64..c39fafe69b12 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -686,13 +686,14 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	priv->hwts_tx_en = config.tx_type == HWTSTAMP_TX_ON;
 
 	if (!priv->hwts_tx_en && !priv->hwts_rx_en)
-		stmmac_config_hw_tstamping(priv, priv->ptpaddr, 0);
+		stmmac_set_hw_tstamping(priv, priv->ptpaddr, 0);
 	else {
-		value = (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR |
+		stmmac_get_hw_tstamping(priv, priv->ptpaddr, &value);
+		value |= (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR |
 			 tstamp_all | ptp_v2 | ptp_over_ethernet |
 			 ptp_over_ipv6_udp | ptp_over_ipv4_udp | ts_event_en |
 			 ts_master_en | snap_type_sel);
-		stmmac_config_hw_tstamping(priv, priv->ptpaddr, value);
+		stmmac_set_hw_tstamping(priv, priv->ptpaddr, value);
 
 		/* program Sub Second Increment reg */
 		stmmac_config_sub_second_increment(priv,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 0989e2bb6ee3..920f0f3ebbca 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -45,6 +45,43 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
 	return 0;
 }
 
+static int stmmac_extts_configure(struct stmmac_priv *priv,
+				  struct ptp_clock_request *rq,
+				  int on)
+{
+	u32 tsauxc, tsauxc_mask;
+
+	if (priv->ptp_clock_ops.n_ext_ts <= rq->extts.index)
+		return -ERANGE;
+
+	switch (rq->extts.index) {
+	case 0:
+		tsauxc_mask = PTP_TCR_ATSEN0;
+		break;
+	case 1:
+		tsauxc_mask = PTP_TCR_ATSEN1;
+		break;
+	case 2:
+		tsauxc_mask = PTP_TCR_ATSEN2;
+		break;
+	case 3:
+		tsauxc_mask = PTP_TCR_ATSEN3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tsauxc = readl(priv->ptpaddr);
+
+	if (on)
+		tsauxc |= tsauxc_mask;
+	else
+		tsauxc &= ~tsauxc_mask;
+
+	writel(tsauxc, priv->ptpaddr);
+	return 0;
+}
+
 /**
  * stmmac_adjust_time
  *
@@ -158,6 +195,11 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 					     priv->systime_flags);
 		spin_unlock_irqrestore(&priv->ptp_lock, flags);
 		break;
+	case PTP_CLK_REQ_EXTTS:
+		spin_lock_irqsave(&priv->ptp_lock, flags);
+		ret = stmmac_extts_configure(priv, rq, on);
+		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		break;
 	default:
 		break;
 	}
@@ -202,6 +244,8 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 		stmmac_ptp_clock_ops.max_adj = priv->plat->ptp_max_adj;
 
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
+	if (priv->plat->has_gmac)
+		stmmac_ptp_clock_ops.n_ext_ts = 4;
 
 	spin_lock_init(&priv->ptp_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index 7abb1d47e7da..26bea23f04ac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -59,9 +59,29 @@
 #define	PTP_TCR_SNAPTYPSEL_1	BIT(16)
 /* Enable MAC address for PTP Frame Filtering */
 #define	PTP_TCR_TSENMACADDR	BIT(18)
+/* Clear Auxiliary Snapshot FIFO */
+#define PTP_TCR_ATSFC		BIT(24)
+/* Enable Auxiliary Snapshot 0 */
+#define PTP_TCR_ATSEN0		BIT(25)
+/* Enable Auxiliary Snapshot 1 */
+#define PTP_TCR_ATSEN1		BIT(26)
+/* Enable Auxiliary Snapshot 2 */
+#define PTP_TCR_ATSEN2		BIT(27)
+/* Enable Auxiliary Snapshot 3 */
+#define PTP_TCR_ATSEN3		BIT(28)
 
 /* SSIR defines */
 #define	PTP_SSIR_SSINC_MASK		0xff
 #define	GMAC4_PTP_SSIR_SSINC_SHIFT	16
 
+/* Auxiliary Timestamp Snapshot defines */
+
+#define PTP_GMAC3_TSR		0x0728	/* Timestamp Status */
+#define PTP_GMAC3_AUXTSLO	0x0730	/* Aux Timestamp - Nanoseconds Reg */
+#define PTP_GMAC3_AUXTSHI	0x0734	/* Aux Timestamp - Seconds Reg */
+
+#define PTP_GMAC3_TSR		0x0728	/* Timestamp Status */
+#define PTP_GMAC3_ATSSTN_MASK	GENMASK(19, 16)
+#define PTP_GMAC3_ATSSTN_SHIFT	16
+
 #endif	/* __STMMAC_PTP_H__ */
-- 
2.17.1

