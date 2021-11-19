Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C40D457947
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhKSXI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:08:59 -0500
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:54401
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231799AbhKSXI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 18:08:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuNWQd3EMUWPJA6g0Bv+WEyk3jCkpVa6AfbY0oAWerVgzIUNyARBjmNwlnuX+mH/C9c8tD8X+xLL2wWznG/Uc7wK6/m6hsQRmKymjTDtsMFcyxekNXkLLG9uzYn7uIdhyT09+6jPRJkQ8kKv+PzodiUwSokQLemeSSyrq04+Ob22CZZCO7tdlkahutYe8hCNj/7McrzM1PhQEb9rskffTSeSR84QCZpUsI9XabAMTpoq/7lwCDziXwjOqL+ySYL6TVXycxVN8hU9jPEjMBZwQi4eOKbBuXltBHcnbrrHjXw22iBVP4GGqCA9+SzpVqwY7LGKnR43EAkZnEClEB4Egw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooEdzmANwIbA8VRE4M88/+YL5Rw9LujmDmMOEEjE3d4=;
 b=j+6ysXI3/73zJPeagEXPADD5UfVGdBXe8yh47aIz377PfuhGItKlz37yfhOxGDautYYf2Vas/rZbSNV94k2ES3IcE4a9Jb7CeSKl4y6lXDv/EBsPPDBNrbMnFgYFseQOnIQzNWOPMPeCQWOE6Qv5ki1UpxnDNOZiU7CVe+R9+l7hEYVhrE0eBheOxDpQQ+CcHQD97LWsQsat6l7Ds7slkFQNEJ3lpsDD5VrLgjvLhS7f43TWU9TvfaCV75Vp6p+KEwrx+Te9wCR9+YqpoBMnT2nr8193hidvmP4jq3nAhcwML4G3W5gOWa6Yqa8ZMp7VcQQx+36uT+DSnQ2bxkC6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooEdzmANwIbA8VRE4M88/+YL5Rw9LujmDmMOEEjE3d4=;
 b=qaPil6RlAE4cBbrM7yZNQd/9ytPie2CdV+UogUhIZwhyAKNeyZKhWttZRHyiPzmgbrolX5bsGa1V6HeMVi5W0a0W08XxIp+dXXdP5ovdhKt6MyhYVm1tBgYiHLJjAvLMtc2A/x7s0q+5L24PvQXSwJJLbAjFGF3PWMNbpqNJcz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 23:05:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 23:05:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>,
        kernel@pengutronix.de, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net] net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls
Date:   Sat, 20 Nov 2021 01:05:42 +0200
Message-Id: <20211119230542.3402726-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0077.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS9PR06CA0077.eurprd06.prod.outlook.com (2603:10a6:20b:464::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 23:05:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3dec049-25e1-4bbb-67cf-08d9abb12355
X-MS-TrafficTypeDiagnostic: VI1PR04MB4814:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48147E533B09322B87AD8EA3E09C9@VI1PR04MB4814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scuIBbf95qgr9e1nN+9rsTJgUQEQfgaYBoaByyKPd8eB/5JdyNE5mplRusWnLjNWstDysE5tWdnZTpcCA2IcU//vwQSfoXJJFki3kSnNN5mwN19v+wC0kR54XJEWlgjVABbgJWL2A78mMK1r9bDTx6nHaOtKXc52XfIjrLXZuI/DqaI1kj4MSJY5gr8JzLemTmBnbmOR20IRLvJDBlxVLkxsP/v4+c8hQs9JtQHYvVsIn185f/PVIlPJM+jxpWhdJizNvxCP3t0H+jtcuLmNTXZqsfIO/fwv9Q2Bi88C3DQCbnkXYPi99pcpTgOk2/m+YRn8MWVI2JvdmmrBAVxDc9mRlVhBwlfFV8b7t1/SlWt5D6tQoVtuvCyqFnNfWEl3kqUs6xfqumvOt3wjQPFrMWymKC+pNJMSVUn2PoKsOpnVKi6kKY1M91MEsoyWtagnrI4rBQ+MT5OycBIhy6Ux2o/vUecPN8TlSCypkwdzbzVNPIQ48RDLppQCeNIJ7VnqFO5HhUj6IQnh9zRSYtqTA27MOe6icyj+MGsE4lC8cHTsQ5dXvSvU7VhRjMC//D9GPoYXSVlpqXxi76aXCmA0R99uF6PXFfqatrIHhBAtQjiypdFqjAdvVhYxq+FbjTbh7ZpKHS7SDggu5xfpzwpa4rZm7LDOyGdX1NUdKxNjSojaNroH45V1+CwnICCaDo/B8NumaG/2de7CQtEa4g9w5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(86362001)(8676002)(6506007)(1076003)(44832011)(83380400001)(956004)(36756003)(2616005)(5660300002)(2906002)(6916009)(6512007)(7416002)(54906003)(66946007)(66476007)(66556008)(316002)(508600001)(52116002)(6666004)(4326008)(6486002)(38350700002)(38100700002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ay6UaOHBoZuqOUEgsZCxm9p2eWRpkIPywFRJ9JUDaYaUdfrIx+3bJJpWNkH1?=
 =?us-ascii?Q?0FGq6ADdIhp/KA0TL+6PxqVmhJeVCvJ0s1SuIaiXDikUiGyt78E5U+i6zNpP?=
 =?us-ascii?Q?H2NF+Tjk96pJPxu1AKEVcTZGJMtZp8R57/tKdHrqJixjUIJEEvXKFcLne6qL?=
 =?us-ascii?Q?kgMv1rcqbx6O+bh0CJ3BqMPaiUHyq13qTz1d+jG666yF4PSblgQEptkWpgRi?=
 =?us-ascii?Q?RuM1iqhvyZDq/oRLPP4gtoT4WF2yXS/lkhT3OLeV4Yq9K6dxrExxWsQFoicg?=
 =?us-ascii?Q?+EuQlkixVXl2/85imuTTr9blmBLNn+A4JEV9YG/fx0RJU2MaBnPFjdXGt2jK?=
 =?us-ascii?Q?6w4ug/EfUKux2hGsqAxw5S8nGhYESCPpjcz4a/syrF0wydctdWHMp9k9A1Jp?=
 =?us-ascii?Q?v3igaWlsopkocZUjA20O7WLB/jj/+Peo7JGra90N6f45Z00iX5mnp6P32x+m?=
 =?us-ascii?Q?d8FWxwMyfc5dtN0/Yxo5oJh8F908fs9OxYfIzcnoMK2/ufEcEODk6e5w87eD?=
 =?us-ascii?Q?MgKInNxI+4GFruD3GgDJle4yg9H8aDJUGITvXiVhgOo+1DPDBRmCNXdf00GJ?=
 =?us-ascii?Q?FJYAwfT+9ee7FQuVN7TjxgRNIIY9abFke2oIXTxQC+YcKudFSmwOLuORHCLI?=
 =?us-ascii?Q?2nh2Vd+Y4YgzvoGkMypwDQj8pfAspD8/H1bbDVzI7rdx6bDH/rtMA1JJzjgu?=
 =?us-ascii?Q?9/wOy1e5rPHa1foS1o5MdsJPIQnSQH7YgOY/KY1cEaImEcL0SfKBSUDzq73L?=
 =?us-ascii?Q?8pV64AUykH744o94Am7oQfApj1E/TqPTHpxBIKJbzlV7MhgEznje46j8Vpq9?=
 =?us-ascii?Q?dhBAh4uyv1y9Gkgd2rgwhfUONKSQL+8fAxSXXRtbYZQfK9Bpx7IK9ZPe43y2?=
 =?us-ascii?Q?Wy3GC0E0AqRkz+IBGzpyDbiGNbnom/o3auZMU2smXoD6FuqaITOxsNKI2o0g?=
 =?us-ascii?Q?Qx49BfJNwdquUnRgGCmdKCjIdDLqZBdssAimJtTAn7evMvwWpaNcLEimhKKK?=
 =?us-ascii?Q?YxkNA5JSVCdtLGNskQIK3vq4+3ZTZlZBECfDmpzyKg+Hy6QoUMx9itIw387m?=
 =?us-ascii?Q?+5jRkbfMOr8cKVLHFO2DxZ62WLo/aYbp0N5ZGZDHHqDq6ofiiZeHo31sa21O?=
 =?us-ascii?Q?Hn3lMbt3YvbzzVFUUYK+RhCxd1o6QME0tloWbhi/pMHUkNg1wU9A/qU3D9I2?=
 =?us-ascii?Q?qFO0n+0f0ddLDzusdcF4jeqnZ2iX3NfYOQ4mdl0blwiTEJXWo9zyvf+j345D?=
 =?us-ascii?Q?43/Kswqxr/q+4SwAu8YfZIFNUPFGYyqp+AU9rlVbnqDQzVXA8C8+IvzOgG2U?=
 =?us-ascii?Q?f96crTeucBAb+r9gcWKDeSLdzo8bGmqh5lMazExGsTaF6hIyKxnr2JXGs2Yv?=
 =?us-ascii?Q?O2LHIj0k23jpVLcJlXFE9DUG6G5VwoTjPbTrebeEAoIFelUbNCuF+tJ0LRtL?=
 =?us-ascii?Q?oD95T1V6C1FwdoLagq1cWJDZ5Jcu22Kht6ecSHDs7Wb3KnzZLiYwc+3fCzhe?=
 =?us-ascii?Q?gZcvxbKcDt6JIyH5uVvh4I7O30EZVVKHBHDnmjqVXXqkvocHn9A3pdSztePn?=
 =?us-ascii?Q?FrgOC/RKRl2QYgz+wHYH1761ujczENxzw/eV3QqeP1EC/GePECiRaxeBdrZr?=
 =?us-ascii?Q?AAJ4kAVG5FZCBetbS6ERwPk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3dec049-25e1-4bbb-67cf-08d9abb12355
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 23:05:54.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4b0jygUsfr/FRVSZ3QPgg19d3yv4MMPEYwlp2R61pHl+lnXq96eWD3Y21NKqX5xBd/ft8USQSL4mjV9qHnP/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Holger Assmann <h.assmann@pengutronix.de>

Currently, when user space emits SIOCSHWTSTAMP ioctl calls such as
enabling/disabling timestamping or changing filter settings, the driver
reads the current CLOCK_REALTIME value and programming this into the
NIC's hardware clock. This might be necessary during system
initialization, but at runtime, when the PTP clock has already been
synchronized to a grandmaster, a reset of the timestamp settings might
result in a clock jump. Furthermore, if the clock is also controlled by
phc2sys in automatic mode (where the UTC offset is queried from ptp4l),
that UTC-to-TAI offset (currently 37 seconds in 2021) would be
temporarily reset to 0, and it would take a long time for phc2sys to
readjust so that CLOCK_REALTIME and the PHC are apart by 37 seconds
again.

To address the issue, we introduce a new function called
stmmac_init_tstamp_counter(), which gets called during ndo_open().
It contains the code snippet moved from stmmac_hwtstamp_set() that
manages the time synchronization. Besides, the sub second increment
configuration is also moved here since the related values are hardware
dependent and runtime invariant.

Furthermore, the hardware clock must be kept running even when no time
stamping mode is selected in order to retain the synchronized time base.
That way, timestamping can be enabled again at any time only with the
need to compensate the clock's natural drifting.

As a side effect, this patch fixes the issue that ptp_clock_info::enable
can be called before SIOCSHWTSTAMP and the driver (which looks at
priv->systime_flags) was not prepared to handle that ordering.

Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")
Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Holger Assmann <h.assmann@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 124 +++++++++++-------
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   2 +-
 3 files changed, 80 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 43eead726886..5f129733aabd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -314,6 +314,7 @@ int stmmac_mdio_reset(struct mii_bus *mii);
 int stmmac_xpcs_setup(struct mii_bus *mii);
 void stmmac_set_ethtool_ops(struct net_device *netdev);
 
+int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags);
 void stmmac_ptp_register(struct stmmac_priv *priv);
 void stmmac_ptp_unregister(struct stmmac_priv *priv);
 int stmmac_open(struct net_device *dev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4caf66898c51..2a0da64736ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -50,6 +50,13 @@
 #include "dwxgmac2.h"
 #include "hwif.h"
 
+/* As long as the interface is active, we keep the timestamping counter enabled
+ * with fine resolution and binary rollover. This avoid non-monotonic behavior
+ * (clock jumps) when changing timestamping settings at runtime.
+ */
+#define STMMAC_HWTS_ACTIVE	(PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | \
+				 PTP_TCR_TSCTRLSSR)
+
 #define	STMMAC_ALIGN(x)		ALIGN(ALIGN(x, SMP_CACHE_BYTES), 16)
 #define	TSO_MAX_BUFF_SIZE	(SZ_16K - 1)
 
@@ -617,8 +624,6 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct hwtstamp_config config;
-	struct timespec64 now;
-	u64 temp = 0;
 	u32 ptp_v2 = 0;
 	u32 tstamp_all = 0;
 	u32 ptp_over_ipv4_udp = 0;
@@ -627,11 +632,6 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	u32 snap_type_sel = 0;
 	u32 ts_master_en = 0;
 	u32 ts_event_en = 0;
-	u32 sec_inc = 0;
-	u32 value = 0;
-	bool xmac;
-
-	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 
 	if (!(priv->dma_cap.time_stamp || priv->adv_ts)) {
 		netdev_alert(priv->dev, "No support for HW time stamping\n");
@@ -793,42 +793,17 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	priv->hwts_rx_en = ((config.rx_filter == HWTSTAMP_FILTER_NONE) ? 0 : 1);
 	priv->hwts_tx_en = config.tx_type == HWTSTAMP_TX_ON;
 
-	if (!priv->hwts_tx_en && !priv->hwts_rx_en)
-		stmmac_config_hw_tstamping(priv, priv->ptpaddr, 0);
-	else {
-		value = (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR |
-			 tstamp_all | ptp_v2 | ptp_over_ethernet |
-			 ptp_over_ipv6_udp | ptp_over_ipv4_udp | ts_event_en |
-			 ts_master_en | snap_type_sel);
-		stmmac_config_hw_tstamping(priv, priv->ptpaddr, value);
-
-		/* program Sub Second Increment reg */
-		stmmac_config_sub_second_increment(priv,
-				priv->ptpaddr, priv->plat->clk_ptp_rate,
-				xmac, &sec_inc);
-		temp = div_u64(1000000000ULL, sec_inc);
-
-		/* Store sub second increment and flags for later use */
-		priv->sub_second_inc = sec_inc;
-		priv->systime_flags = value;
-
-		/* calculate default added value:
-		 * formula is :
-		 * addend = (2^32)/freq_div_ratio;
-		 * where, freq_div_ratio = 1e9ns/sec_inc
-		 */
-		temp = (u64)(temp << 32);
-		priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
-		stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
-
-		/* initialize system time */
-		ktime_get_real_ts64(&now);
+	priv->systime_flags = STMMAC_HWTS_ACTIVE;
 
-		/* lower 32 bits of tv_sec are safe until y2106 */
-		stmmac_init_systime(priv, priv->ptpaddr,
-				(u32)now.tv_sec, now.tv_nsec);
+	if (priv->hwts_tx_en || priv->hwts_rx_en) {
+		priv->systime_flags |= tstamp_all | ptp_v2 |
+				       ptp_over_ethernet | ptp_over_ipv6_udp |
+				       ptp_over_ipv4_udp | ts_event_en |
+				       ts_master_en | snap_type_sel;
 	}
 
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
+
 	memcpy(&priv->tstamp_config, &config, sizeof(config));
 
 	return copy_to_user(ifr->ifr_data, &config,
@@ -856,6 +831,65 @@ static int stmmac_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
 			    sizeof(*config)) ? -EFAULT : 0;
 }
 
+/**
+ * stmmac_init_tstamp_counter - init hardware timestamping counter
+ * @priv: driver private structure
+ * @systime_flags: timestamping flags
+ * Description:
+ * Initialize hardware counter for packet timestamping.
+ * This is valid as long as the interface is open and not suspended.
+ * Will be rerun after resuming from suspend, case in which the timestamping
+ * flags updated by stmmac_hwtstamp_set() also need to be restored.
+ */
+int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
+{
+	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	struct timespec64 now;
+	u32 sec_inc = 0;
+	u64 temp = 0;
+	int ret;
+
+	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
+		return -EOPNOTSUPP;
+
+	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+	if (ret < 0) {
+		netdev_warn(priv->dev,
+			    "failed to enable PTP reference clock: %pe\n",
+			    ERR_PTR(ret));
+		return ret;
+	}
+
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
+	priv->systime_flags = systime_flags;
+
+	/* program Sub Second Increment reg */
+	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
+					   priv->plat->clk_ptp_rate,
+					   xmac, &sec_inc);
+	temp = div_u64(1000000000ULL, sec_inc);
+
+	/* Store sub second increment for later use */
+	priv->sub_second_inc = sec_inc;
+
+	/* calculate default added value:
+	 * formula is :
+	 * addend = (2^32)/freq_div_ratio;
+	 * where, freq_div_ratio = 1e9ns/sec_inc
+	 */
+	temp = (u64)(temp << 32);
+	priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
+	stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
+
+	/* initialize system time */
+	ktime_get_real_ts64(&now);
+
+	/* lower 32 bits of tv_sec are safe until y2106 */
+	stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec, now.tv_nsec);
+
+	return 0;
+}
+
 /**
  * stmmac_init_ptp - init PTP
  * @priv: driver private structure
@@ -866,9 +900,11 @@ static int stmmac_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
 static int stmmac_init_ptp(struct stmmac_priv *priv)
 {
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	int ret;
 
-	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
-		return -EOPNOTSUPP;
+	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE);
+	if (ret)
+		return ret;
 
 	priv->adv_ts = 0;
 	/* Check if adv_ts can be enabled for dwmac 4.x / xgmac core */
@@ -3276,10 +3312,6 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	stmmac_mmc_setup(priv);
 
 	if (init_ptp) {
-		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-		if (ret < 0)
-			netdev_warn(priv->dev, "failed to enable PTP reference clock: %d\n", ret);
-
 		ret = stmmac_init_ptp(priv);
 		if (ret == -EOPNOTSUPP)
 			netdev_warn(priv->dev, "PTP not supported by HW\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 232ac98943cd..5d29f336315b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -816,7 +816,7 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 		if (ret)
 			return ret;
 
-		clk_prepare_enable(priv->plat->clk_ptp_ref);
+		stmmac_init_tstamp_counter(priv, priv->systime_flags);
 	}
 
 	return 0;
-- 
2.25.1

