Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B641A1F53F0
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgFJLza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:55:30 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:59907
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728788AbgFJLz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 07:55:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVEPWcWeES1RiRfDjBZy0/45VIdW1HSQtEA1DFE5C/4hhd4Gg/1RXogjFAibn0558VtKMGO2UCkyL4LjML9b2E5wmshaND4O4bFb08jqqKfFrjf94bsWy6VxHFS2G45YEbNnYPqWuyl5AN9CIvro3nv/2TdvroJQX8vmH7jdP9HB/F0sttTxkBsIc1PZDFwgxRCbSJ+cZVJqS39frbXimhPoMJrtZSR3h64hjN8D0G2jg/cCXN2P1PIoTlQycwriaiUbN8LFsD5YpSbFl4IvG1o4utEWdPSs+3+uHxiK2YTgJEVQxSdrFOslq4GNRjMed+XRk4GYJdtalG/yRCJmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsh+V/Xa/WU3fdOnR91UO7aoiqe84pK/e0OiL4TmkBc=;
 b=hhp6YV2VEWehbz4VJN2/fhEuy6akXboh/owOwPWhyyIpOQsCfELrECMqsPlKX+9VWNC4xxirkAUStFbUUMK6oSKS1pYLl2WrcoZoKeMyV7435tuMjO64nKvd4719mGnNSJTcXJTRyk3Pa2mYb9shus24DrUq2Gs26UcL/5UXoGIHdxMLzs4WwMvvHmw2hvy8jUSxJEjTKAjuw//MxuStvOHu2e/+waAW0oTN+SHB8WeZIDnZTfMN7lfLeSWeSAsF20pm9z1VRkP0nAnSYO9Tr0Cv4OCZg/bCyKM0odzjOxgfV5nnyg3rknrhDWDkQxaOze76KAQWTrPx7g/KJcWcPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsh+V/Xa/WU3fdOnR91UO7aoiqe84pK/e0OiL4TmkBc=;
 b=bV1fGLeM5mGhmmY1SehA9YXGLLjHoQiJb+ueXN/7bmh5c69dm78aYVihWiQe+WbUoBEC5c1o0/Lkh6ItNZ8KUuP6NONVGWIXchHDVP1T8b0oFcjvukMoocvb4s7vpRlE4eHq7QgWlk/ZFH5inzLdSaDx4d6jnDs7DgEUeAMbDyU=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB4016.eurprd06.prod.outlook.com (2603:10a6:802:68::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Wed, 10 Jun
 2020 11:55:22 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3088.019; Wed, 10 Jun 2020
 11:55:22 +0000
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Artem Panfilov <panfilov.artyom@gmail.com>,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Subject: [PATCH 1/1] net: stmmac: gmac3: add auxiliary snapshot support
Date:   Wed, 10 Jun 2020 13:55:08 +0200
Message-Id: <20200610115508.303844-1-olivier.dautricourt@orolia.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0043.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::18) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a01:e35:1390:8ba0:c065:230a:531:8b0a) by PR3P189CA0043.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Wed, 10 Jun 2020 11:55:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:1390:8ba0:c065:230a:531:8b0a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e72e8a8-9d96-4c84-b3a0-08d80d352769
X-MS-TrafficTypeDiagnostic: VI1PR06MB4016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB4016C882CE08ABD70FA7ADCF8F830@VI1PR06MB4016.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0430FA5CB7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQY5N5CWZiVaq/45U/HTaiwwQmbaT58Hcmj57eEhHAhjZ9pk6kIosBz2BgB6GN9Qt+sVJkU5NP5z3Km4UdkdRR1oimlTXvq7LV0nbUmOrRIN+oHxRGBbxtfzs8YhxMJriXTfkSSUsulaEtKR8lw93GQnroCc+oW2mVZuDYJZgTmg01g73Ch2YinSJiY1DNiKcVVA+5+wD3MNW2zIUSy/NEhMYPx1ExeVqotdpIab1kbFjD/UygqFb7AMW0B91LHb6E/rFt2B+CpP5XjGOATQYUGZ/QIzlcdKd5evOrVwXMYqh1HnaGQDLze7orWTnfiiXyre2pQX/sK/GUeM0Zxd7L5v30uNMfuszisuqB+tQjb4nu45i3h5ddbhKvZQ2Dks
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39850400004)(366004)(396003)(136003)(110136005)(54906003)(69590400007)(478600001)(5660300002)(8936002)(44832011)(86362001)(4326008)(2616005)(186003)(2906002)(6666004)(66476007)(66946007)(8676002)(83380400001)(36756003)(6506007)(6486002)(6512007)(66556008)(30864003)(52116002)(16526019)(316002)(107886003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A7IuR7IlXw326/MoFwUSHPiF7PNI4Ntq0mm4VbCCrWsUhghpaL/Ij5lKfjIXKE51qZSibFhaWPx8R5jN5kMyopa37Nq3/Tfdjcpz5sZLzh0rn57JoU5LCu7ZkqZABV1GfVTt1QnRRZvGYQnrvCSg7Jgxd2lZn02+c/21ODehEnzn5oHCTh53UFOiCmx4Vf+NOIIqaBp5w2zdHFayVVihKt9QbftzVoCUutgYmTPGySL784QuYZEo2L5Quu24yS9cLDKfI0ahZH32+K0BhNbjeCA4Tgrp8Z8Y2k7jqMX3ijRfYaczgWAJoKVs/IqI71aahm2TY+55GLYucJ53JuO6EOocONmBIz9aV/+KrBepPqrFRD88vvku3QM1Sk/UrDifWd37a1QlNqZh2//7hITrSXMtcBOa7sUvrX3iSifNBBhRD1Wb5NueTrrpS3TA32eFvmgN5qe5ReXWh8b7B3mbC7fBkB458KMJPUfDTGEfEemwv15dQLEN+ARrWhEuM2Yd1DyAW+wf+MKrbDpXHu0OWcOUKnE9lkOg+wWU3af1fWY=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e72e8a8-9d96-4c84-b3a0-08d80d352769
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2020 11:55:22.2314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPVXxiEANCaXHgV/9wsW7BpEbuB3DsCcc6kkQwVStdQEz85xbm0DDT7AXC5aCj1Im9i/NJq8r93FqqGbFtvcinBeZLfAaLFq5rYEp0L1b5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB4016
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
index 73677c3b33b6..b4476ef8b6c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -687,13 +687,14 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
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
2.25.1

