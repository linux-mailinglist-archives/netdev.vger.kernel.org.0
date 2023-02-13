Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B820669414D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjBMJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjBMJea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:34:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ABC199DB;
        Mon, 13 Feb 2023 01:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ur2pGe3cAC/MTxvijlj8v0jaHGnNjU0mCFoglXCsoEr+2JXzwLPQwYClL1gcT6xBXcqnuqpup47nhl4v1KjmGCc26Ry64UlSnodx7AWef+ccPRCvLA8IPpS5iHpVWijak8eZRdEFY4xKYNIO0m9/kyr48ucnFkoMYADsymGM3v1JIB8OVd+hT0CHSfAo+98kMSQjILUf6sMGKxHT/G5psUzQIoC1O8yUDUP0Wp0Ow4vndieya1S02Nfl23MucSMgG9HIX8OdLskZMWI+uL40r9T8yV5Z0V/vLp61q0XUSV7Sdle8hAv7OwNCK5tYnxYQz42pCwgi1CsxbTsuLnyZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Joma7leDbLw5b6vo7VS2oolTGwst9fqSi6W+s+pKFRE=;
 b=RoNGJw000b0xCHelKN3ZVMek0Bp3o9/haVDkTP9aexpZdgK2Q/ZObxvlh7SzYFiTsh6tARWa9WfwjhF2ZuOvyvGtLdL3KoKBqHRCI9kyXpkdZLza3EAiMcXCrUk2zI2vHOPZKUhAuTG0bH9VG/jNsZdBY0W0e3LMSPIMeQG02msiDRZqwrfTPrcIWoLpSY9pUB1/JThjDdbdWTHUSxWGG+aMm34oOoC49980sxMm184AraGlVENeLFZpex4QQMUjsGCfwlXbdsCiHofomYjPYGHNAYubr950pKyX2IlTbSR5jAEF0RXfVHAItTlXVqVfwkV/IPgLrfhQUN5i6hO7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Joma7leDbLw5b6vo7VS2oolTGwst9fqSi6W+s+pKFRE=;
 b=PrvT9Y3oca8vT+IKiyjg+OohDOKyAPo6B9dZuEgbxBx3fxAwWg1Adis+nOeW7kS3+diB3YwKFCe+gdMUU7er291s3XU/HiMX/4HAfevIrLDv2OgxzbKqvCLqPPrECxb2+TZuf1yEfL0DTQTbfSepz/Zb8ZAylS8T5rbrAEXKIRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB8296.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 09:32:28 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 09:32:28 +0000
From:   wei.fang@nxp.com
To:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, simon.horman@corigine.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next] net: fec: add CBS offload support
Date:   Mon, 13 Feb 2023 17:29:12 +0800
Message-Id: <20230213092912.2314029-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AS8PR04MB8296:EE_
X-MS-Office365-Filtering-Correlation-Id: f264e2d2-1c6c-4711-8108-08db0da53919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1jCe2eROuY5TKvZ3O5YiAqHsm6XiIMyz1YRBJHZV3hBIfiCzaD4QnmE416905zqk0RGzFEGg2Wg4DTcPDl7FLpy3q7EA08JN1Nz3W+aombTVsYNb2PglU/JPUe7gFdTwjlDombfJvFRdBSKFMrXjz0qiQxYKWS0vpqtoYZF0uHP03qhDOjcDZ/OUDZ+2k84tqr8/NuLW0mF7B6pFyhRpbQxSPD16H0hICT5EWTaYRly2dPfoGf49R4FAbOQbGcuTCBie0rWAji+ESrYi5JJhRX/OQJZD9yZckhjiOuyw0iwNwbb06JIMWthFtVs6OGJcQXhdY/WxPv5FaQa6FtWTih9/KOBxZ9ljV/r05CUS6y+kc9hkSL8ljGXWgv8H4HPlkemKw64F3TXKGsp5mKB/5S+knWh0hNxSKJEXOkOkdfz0sVzWAxJtwy/x2xJFzYZnDiqNfLENYyjZBaMVPJA/Lh/uFU8IG6aWKCLbgcRuj0ZQi+fUuWG7Su5q3b3H6EV+LiQQxmX5hFUz/nbIPM/+LkmgwZR0Pibvx4rDuu6cHsPiGJS3ymNJhVj1JuPl8iS/4rBDScmnWvhqy+wKICE8JbS5/WxhdTdacmvrHSGNA9Ym1usIU/ErcXXbVQMoKEbb/whd2QHcJNdIT1+5iJTgJgwSjv2/AWms+f2Hov0/P19hhwj8Lef6wl8BEH9QG0CxnW26ZfPNs4hPrYyJlmTfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199018)(6512007)(26005)(186003)(52116002)(9686003)(316002)(6506007)(1076003)(6486002)(2616005)(478600001)(66556008)(66946007)(66476007)(8676002)(4326008)(6666004)(8936002)(5660300002)(41300700001)(83380400001)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oxXFeMwS2X1JsoT3lsoDC5s+CZEftkhhgaJNUK+AuvUzmMNZbLwcHlS2/B7v?=
 =?us-ascii?Q?BtQgSbT/rpCpTVFqL8vyZZyDpHFbsOY5d4cFP9eCBQtjMRVfHOOiCfIOg7tf?=
 =?us-ascii?Q?jl99qv/1HeLtuyRukL2+njMdXB4FrPiflYb8zKF2HiRBuB5u3QO5f4Uw9lcr?=
 =?us-ascii?Q?PJ3HdrjuPKOpYY6uOA21ToAn299w69txHHHOJHcMJdL0ahhTHTvR6FbeXGKv?=
 =?us-ascii?Q?8P3tYJvOMw9zLGIPSfr7TFsd41VSE3tyVOjPTpGQkpMYfSc/lBNfjpbD0IXA?=
 =?us-ascii?Q?rDauyNDcMXJ9YENnEEuf7YcT0Qz/Dc/tyhkN6BYk5I9dh5HvlpvCDjBG0DDG?=
 =?us-ascii?Q?Jj+tJzfxAcBEjo/iYtG24gOxW12J1VkX5x8CWWIHnO5HA90aXH2psdsPNCDh?=
 =?us-ascii?Q?lSDNijtOW9iDj6Z5DnYWcLLyohCoanM04DAeTAfm+ci6OfGtYXLyDvH281CV?=
 =?us-ascii?Q?blKE8dV3hS5G1KUuI3oS9OLFLFZXax5w//iIM3uWOjWqDF7WPOW2/KNqlyz/?=
 =?us-ascii?Q?Hxo+CDQlK3jGNZdpJPdj0r9B6mZRTmhJilIuliWF7Z7/i1s3+NX8XVyy682n?=
 =?us-ascii?Q?cPCCsn2AYFOn6OB2uHLUhSyGCTyD4S60LOnSH2EkUdKjI1IAIObSuO/sTFhb?=
 =?us-ascii?Q?cEArcXmmsrcHYgp7jiiwJfjhx59woJupAUPwXCXgqJW4oAcuOTp6YLs9oNFe?=
 =?us-ascii?Q?vUNf6RRggVavkOAfEFy5AOUpFUJLWb6nhogP3QV08W+YE3Cucl1oG0FZCgRt?=
 =?us-ascii?Q?YTxkaN4Vls9Z7412bnSlzsPeOMCpEQEv6I5QRahR2TaIewJeltsU4bH52WEV?=
 =?us-ascii?Q?OUMGT5Qv1MD/rON0bfWx0293tDZse1a+PN74ev4wVMdUMckcXZm/ImAD9Vjn?=
 =?us-ascii?Q?6W37H+zkhZWzzFjt7u/PZBBNwUs25lmUdVs0DWf/TZIp+fEgOZq7YaQfJeXB?=
 =?us-ascii?Q?ST63j/0kdT+WWivL0jezVmjzzE22ySlxi8ST35yoxVzAyLHw/HVMtcGkIlGk?=
 =?us-ascii?Q?vBmSWHTUdD2LgBhuOAZfIDUPEM0ZRMtlPTQuiJuEPnW5b9U03h3VYZKT7b2Y?=
 =?us-ascii?Q?S72Gc1QGTB3c5YW5gY/+Kj/36pgJ1MlJTdz0dOy3yiU0ZGDLi4PAXNfjvAX3?=
 =?us-ascii?Q?02E7PTj05b5mzdhhWz2d/9l7j1hT/o6pTxeiVrvJ61azjWk+OE+AGbg3aCYd?=
 =?us-ascii?Q?I2jitMMPAsFZUJciIThMZ5IfAkQQHVk2Vi3DH82pfPk+PBs3/SeNBukTyEl+?=
 =?us-ascii?Q?IAsP36DEqRQI/vZ4gf8dzZ/iLCh03dizRPgssxWnut49t+tzyupqcfBflT7K?=
 =?us-ascii?Q?Gh6X/uURMipeWJb5Mojrb2DuW7xbvH6XGCCG0ksZdBb+DAB/xC7iwAWhs9lR?=
 =?us-ascii?Q?aW/tiFwO/xGOCMDFQYrpriFphr/AaOFFMhFa3J9Drhp5t/Ll/mDb/rAadG5z?=
 =?us-ascii?Q?GdUhePek5BMn3M8IEdPXEF/AGa7jU3cZplIb6G5Wzv1bau5Ei4iDdQ8RKLn8?=
 =?us-ascii?Q?09dnlECuLZIIhrN3iNp6leFT7C3jsNNjn0piRnICzEZB5/JgXg7hk1DpbilG?=
 =?us-ascii?Q?ZbxN8un8sw8VDgQSFy0bjsuOi/Pil8u25g5GOK9F?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f264e2d2-1c6c-4711-8108-08db0da53919
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 09:32:28.4450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJU7ocpdItSJk+Uy6BRu7B2CIUNsudL2u6dwEBQnKeRCqggGOhvnOjiwG4MDrd/wOF4euh/G2j1IqWEWg7/jjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8296
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The FEC hardware supports the Credit-based shaper (CBS) which control
the bandwidth distribution between normal traffic and time-sensitive
traffic with respect to the total link bandwidth available.
But notice that the bandwidth allocation of hardware is restricted to
certain values. Below is the equation which is used to calculate the
BW (bandwidth) fraction for per class:
	BW fraction = 1 / (1 + 512 / idle_slope)

For values of idle_slope less than 128, idle_slope = 2 ^ n, when n =
0,1,2,...,6. For values equal to or greater than 128, idle_slope =
128 * m, where m = 1,2,3,...,12.
Example 1. idle_slope = 64, therefore BW fraction = 0.111.
Example 2. idle_slope = 128, therefore BW fraction = 0.200.

Here is an example command to set 200Mbps bandwidth on 1000Mbps port
for TC 2 and 111Mbps for TC 3.
tc qdisc add dev eth0 parent root handle 100 mqprio num_tc 3 map \
0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0 queues 1@0 1@1 1@2 hw 0
tc qdisc replace dev eth0 parent 100:2 cbs idleslope 200000 \
sendslope -800000 hicredit 153 locredit -1389 offload 1
tc qdisc replace dev eth0 parent 100:3 cbs idleslope 111000 \
sendslope -889000 hicredit 90 locredit -892 offload 1

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 changes:
1. Based on Simon's suggestion, modified the description in
   fec_enet_get_idle_slope to make it more clear.
2. Adopted Simon's suggestion to use macro DIV_ROUND_CLOSEST to calculate
   idle_slope. And also amended some nits.
3. According to Andrew's comments, the speed may be equal to 0 when the
   link is not up, so added a check to see if speed is equal to 0. In
   addtion, the change in link speed also need to be taken into account.
   Considering that the change of link speed has invalidated the original
   configuration, so we just fall back to the default setting.
4. Considering that some events will cause the MAC reset and clear the CBS
   registers (such as link status change, transmit timeout, checksum offload
   feature change and so on), so reconfigure the CBS in fec_restart.
5. Added more checks for parameters passed in from user space.
---
 drivers/net/ethernet/freescale/fec.h      |  13 ++
 drivers/net/ethernet/freescale/fec_main.c | 179 ++++++++++++++++++++++
 2 files changed, 192 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 5ba1e0d71c68..5383681ac273 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -340,6 +340,10 @@ struct bufdesc_ex {
 #define RCMR_CMP(X)		(((X) == 1) ? RCMR_CMP_1 : RCMR_CMP_2)
 #define FEC_TX_BD_FTYPE(X)	(((X) & 0xf) << 20)
 
+#define FEC_QOS_TX_SHEME_MASK	GENMASK(2, 0)
+#define CREDIT_BASED_SCHEME	0
+#define ROUND_ROBIN_SCHEME	1
+
 /* The number of Tx and Rx buffers.  These are allocated from the page
  * pool.  The code may assume these are power of two, so it it best
  * to keep them that size.
@@ -571,6 +575,12 @@ struct fec_stop_mode_gpr {
 	u8 bit;
 };
 
+struct fec_cbs_params {
+	bool enable[FEC_ENET_MAX_TX_QS];
+	int idleslope[FEC_ENET_MAX_TX_QS];
+	int sendslope[FEC_ENET_MAX_TX_QS];
+};
+
 /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and
  * tx_bd_base always point to the base of the buffer descriptors.  The
  * cur_rx and cur_tx point to the currently available buffer.
@@ -679,6 +689,9 @@ struct fec_enet_private {
 	/* XDP BPF Program */
 	struct bpf_prog *xdp_prog;
 
+	/* CBS parameters */
+	struct fec_cbs_params cbs;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..91394ad05121 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -66,6 +66,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <net/pkt_sched.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
 
@@ -1023,6 +1024,174 @@ static void fec_enet_reset_skb(struct net_device *ndev)
 	}
 }
 
+static u32 fec_enet_get_idle_slope(u8 bw)
+{
+	int msb, power;
+	u32 idle_slope;
+
+	if (bw >= 100)
+		return 0;
+
+	/* Convert bw to hardware idle slope */
+	idle_slope = (512 * bw) / (100 - bw);
+
+	if (idle_slope >= 128) {
+		/* For values greater than or equal to 128, idle_slope
+		 * rounded to the nearest multiple of 128.
+		 */
+		idle_slope = DIV_ROUND_CLOSEST(idle_slope, 128U) * 128U;
+
+		return idle_slope;
+	}
+
+	/* For values less than 128, idle_slope is rounded to
+	 * nearst power of 2.
+	 */
+	if (idle_slope <= 1)
+		return 1;
+
+	msb = __fls(idle_slope);
+	power = BIT(msb);
+	idle_slope = DIV_ROUND_CLOSEST(idle_slope, power) * power;
+
+	return idle_slope;
+}
+
+static void fec_enet_set_cbs_idle_slope(struct fec_enet_private *fep)
+{
+	u32 bw, val, idle_slope;
+	int speed = fep->speed;
+	int idle_slope_sum = 0;
+	int i;
+
+	if (!speed)
+		return;
+
+	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {
+		int port_tx_rate;
+
+		/* As defined in IEEE 802.1Q-2014 Section 8.6.8.2 item:
+		 *       sendslope = idleslope -  port_tx_rate
+		 * So we need to check whether port_tx_rate is equal to
+		 * the current link rate.
+		 */
+		port_tx_rate = fep->cbs.idleslope[i] - fep->cbs.sendslope[i];
+		if (port_tx_rate != speed * 1000)
+			return;
+
+		idle_slope_sum += fep->cbs.idleslope[i];
+	}
+
+	/* The all bandwidth of Queue 1 and Queue 2 can't greater than
+	 * the link rate.
+	 */
+	if (idle_slope_sum > speed * 1000)
+		return;
+
+	/* idleslope is in kilobits per second.
+	 * speed is the port rate in megabits per second.
+	 * So bandwidth the ratio, bw, is idleslope / (speed * 1000) * 100,
+	 * the unit of bw is percentage.
+	 */
+	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {
+		bw = fep->cbs.idleslope[i] / (speed * 10);
+		idle_slope = fec_enet_get_idle_slope(bw);
+
+		val = readl(fep->hwp + FEC_DMA_CFG(i));
+		val &= ~IDLE_SLOPE_MASK;
+		val |= idle_slope & IDLE_SLOPE_MASK;
+		writel(val, fep->hwp + FEC_DMA_CFG(i));
+	}
+
+	/* Enable Credit-based shaper. */
+	val = readl(fep->hwp + FEC_QOS_SCHEME);
+	val &= ~FEC_QOS_TX_SHEME_MASK;
+	val |= CREDIT_BASED_SCHEME;
+	writel(val, fep->hwp + FEC_QOS_SCHEME);
+}
+
+static int fec_enet_setup_tc_cbs(struct net_device *ndev, void *type_data)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct tc_cbs_qopt_offload *cbs = type_data;
+	int queue = cbs->queue;
+	int speed = fep->speed;
+	int queue2;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return -EOPNOTSUPP;
+
+	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must
+	 * have three queues.
+	 */
+	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
+		return -EOPNOTSUPP;
+
+	if (!speed) {
+		netdev_err(ndev, "Link speed is 0!\n");
+		return -ECANCELED;
+	}
+
+	/* Queue 0 is not AVB capable */
+	if (queue <= 0 || queue >= fep->num_tx_queues) {
+		netdev_err(ndev, "The queue: %d is invalid!\n", queue);
+		return -EINVAL;
+	}
+
+	if (!cbs->enable) {
+		u32 val;
+
+		val = readl(fep->hwp + FEC_QOS_SCHEME);
+		val &= ~FEC_QOS_TX_SHEME_MASK;
+		val |= ROUND_ROBIN_SCHEME;
+		writel(val, fep->hwp + FEC_QOS_SCHEME);
+
+		memset(&fep->cbs, 0, sizeof(fep->cbs));
+
+		return 0;
+	}
+
+	if (cbs->idleslope - cbs->sendslope != speed * 1000 ||
+	    cbs->idleslope <= 0 || cbs->sendslope >= 0)
+		return -EINVAL;
+
+	/* Another AVB queue */
+	queue2 = (queue == 1) ? 2 : 1;
+	if (cbs->idleslope + fep->cbs.idleslope[queue2] > speed * 1000) {
+		netdev_err(ndev,
+			   "The sum of all idle slope can't exceed link speed!\n");
+		return -EINVAL;
+	}
+
+	fep->cbs.enable[queue] = true;
+	fep->cbs.idleslope[queue] = cbs->idleslope;
+	fep->cbs.sendslope[queue] = cbs->sendslope;
+	/* We need to configure the credit-based shaper of hardware after
+	 * the CBS parameters of queue 1 and queue 2 are both configured.
+	 * Avoid parameter conflicts between queue 1 and queue 2, causing
+	 * one of the queues to fail to be configured. Additionally, once
+	 * the FEC_QOS_SCHEME field is set to credit-based scheme, queue 1
+	 * and queue 2 are taking effective as AVB queues immediately. So
+	 * it's better to set credit-based shaper after both queues are
+	 * configured.
+	 */
+	if (fep->cbs.enable[queue2])
+		fec_enet_set_cbs_idle_slope(fep);
+
+	return 0;
+}
+
+static int fec_enet_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_CBS:
+		return fec_enet_setup_tc_cbs(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /*
  * This function is called to start or restart the FEC during a link
  * change, transmit timeout, or to reconfigure the FEC.  The network
@@ -1173,6 +1342,15 @@ fec_restart(struct net_device *ndev)
 
 	writel(rcntl, fep->hwp + FEC_R_CNTRL);
 
+	/* We need to reconfigure the CBS due to some events will cause
+	 * the MAC reset such as link change, transmit timeout, checksum
+	 * feature change and so on.
+	 */
+	if (fep->quirks & FEC_QUIRK_HAS_AVB &&
+	    fep->num_tx_queues == FEC_ENET_MAX_TX_QS &&
+	    fep->cbs.enable[1] && fep->cbs.enable[2])
+		fec_enet_set_cbs_idle_slope(fep);
+
 	/* Setup multicast filter. */
 	set_multicast_list(ndev);
 #ifndef CONFIG_M5272
@@ -3882,6 +4060,7 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
 	.ndo_eth_ioctl		= fec_enet_ioctl,
+	.ndo_setup_tc	= fec_enet_setup_tc,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
-- 
2.25.1

