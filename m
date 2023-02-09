Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A396903A0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjBIJ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBIJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:27:48 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B6A5EF92;
        Thu,  9 Feb 2023 01:27:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l73stH4eIKF5BFVjp9o0WACo4A4tgm+jRgBAlD0GfjUNs2d2SouxxZiiAe5O7ynJhR/2JLeGe3AaJQvbk6sXbZmchr00UDtzJOZkVb/QHPucu+/5EObKS3qaQ2rfRln1HBhnXgooWCpvSejrWpDz4GD9bw8+VQpEGV+FEO5zGnPdjc0O0y5/jfws7vhOBdKbRmtLp1WgVu3Vt33LYO7VY36YNuSvp1OcX7iGT/Vqw1GYLWn07lPwYlHkwjrTPWVV/h5Ywkvut+cKQBMl5zAEnOY1I6NaJglW3J8XX3fWPqZVHzHlXOc5lpn5z5w6H02ZqtIbbhYSyJ7q3pUEusAz2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZnrfaHF4rTjWKGPVg20/MdeMZf4uO2yZJy8KciVYg8=;
 b=XDKfqXnVyTMRHpso5S6gBeNvaCcDEVs3aBH1AmNyJr0p+ukgWQ5P07cJYTCS98Kcidgx3xvVVzuSdZ4jYzSCD54gCHoCLAwBxa9FnEisyE9qKo4ZtE5yBN3RPntCYyNkBiuunhRn4dkob3RyqL1FWIzhD1/Z1Fo6Pekr9psKkaTuT9rTxmkmbvW4vQCcs3cmpFt31wwTEndz1CzGSUlvrohrQ304Svw5WgrB3CwadFIH/LiFhx6fsEU+ydZbTsCwIsezmGoQNENUFs+cSuEHsioLOMBge9HoJ1I70eOCHJZtFjYfZz/Iy5BOuqJ1IwqLpipxALGpEukE2f3rXTJzYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZnrfaHF4rTjWKGPVg20/MdeMZf4uO2yZJy8KciVYg8=;
 b=eucn8/Z1tYQlmrJKSxfTqXDXHgNPTPD+G2cAqm3LAtkG95dcjqrq06d0uaAOAqO7eR/aQqLm3dNrF6fpuY9PGggQLTLu1De/ga1hRwci+6IPBrwDiw5DFo6+zDgvAiojfNkZji7eCha0tUfR1j2onGpmEvBDBUYsVVAfwJp82Sg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM7PR04MB6904.eurprd04.prod.outlook.com (2603:10a6:20b:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 09:27:43 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 09:27:43 +0000
From:   wei.fang@nxp.com
To:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     linux-imx@nxp.com, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: fec: add CBS offload support
Date:   Thu,  9 Feb 2023 17:24:22 +0800
Message-Id: <20230209092422.1655062-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AM7PR04MB6904:EE_
X-MS-Office365-Filtering-Correlation-Id: 3105f5e6-a5f3-4159-79e1-08db0a7fe5a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkw9bVjoXvbtTBnG35z78MzGnk2DFOSlm8Eevj1mHr40QxkzWMxL6KA8nXN67luoHBWd5pNGIV9kqSfcPy6XOOmVOoJ27g5RSysgfTk46nUfsc1kD8c10oIQGb+KgTGG4SDEBBNPHAcLpmbRDc+OT5hsOauGmNIMFGaEa8sWkqvTu9GTEqgZUYMZZvC3+SsoDqdqSvCJAtzKGWuzYOBORE14rX8SB2/mdUV+1WGgWTKcZivK5+QnQpqPYoGZwD8CiYVJ5Ofh2Qz0H7wyI3B91O0tIaocPD2k8vkSevFTghtBg4L4CE0Bj34xd9m7s1D+fOjNQcdRY9gf3S7blQi5cdVrxncJzwmBCn2uTWOhSALdbmstc4LJGJ4MD7BnhurtmqaasAViZVCqdN0/9LvXlIetjoFjWawFgI/vuF1EgqAt/V1kJyb625qKHAiO7cKGj329FR7PN5YGgcA/RdI55Vxriy5fRIFM4/+5kzB3MemespObjxGFjiyO2ur43U+SPTSyeFTYikgx/tXPgdyGggCfqXUAVhHxP4/rYFIPF5xZuQmgy4yirx1ZeVwDG2nIRY8TmdY7QG5wQP46uzEq+skyBkPjYaB+RD1xCfcLvkErZF+a/skofHabjG9PoYh3V4lS97sqsA88VcUNg3va6IVCJLmW/lVsm5nqSW6hW29PcNl7Wk5ytR4ktdXbMAKqDvIHMy2rTityGUSj+a5Z3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(451199018)(52116002)(5660300002)(8936002)(2616005)(66476007)(66556008)(66946007)(6486002)(8676002)(4326008)(38100700002)(38350700002)(478600001)(41300700001)(86362001)(36756003)(2906002)(316002)(83380400001)(9686003)(26005)(186003)(6512007)(6666004)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KfJWK5JG8ySiOCroHzLY0fSc3TrqNTG4n+majXV/swcYtICPz4+GOi5KQeL?=
 =?us-ascii?Q?WkMhiLxUkfPjbXG1L2FFe5TY3wtd75yWLD7pN/s5uXMpisgzo6LZTMLW6FD7?=
 =?us-ascii?Q?yfHiCMvL/5kJ8LvLjqvr/mBwtVoOn31EIL51bqcL4dDM1N5iwgreZp/y62qu?=
 =?us-ascii?Q?a8M82ECgXVXxM/5kUDaNTEmAValmNaGt3pSb35sy4HK1SJFmgFcC0auQxgvC?=
 =?us-ascii?Q?lGDB4BglLXJERhkZHyAJc2+Qm8/FZrxiObb41HJ+q5/rxp3LdSae3G32WjeO?=
 =?us-ascii?Q?RRCa7P91wm+u5WnYJZVbE93NXQU0I6fqeMsgWKcn2ZCYOs1ak2YmKb6G84TQ?=
 =?us-ascii?Q?PyrW7AMpPTdyWEmNBMAg6/uoyHl2XIOGecmfHJuyTaavEEJgzJ/scz/OKYma?=
 =?us-ascii?Q?8vyblhIBUFLpDFs9Ur6hWDjLZ4g/cbypYdBvr1rQVPp5YP6ZWIBQixVyQ15r?=
 =?us-ascii?Q?Xizbl3L96hoxy4g40yjOR3E85uVK3VyU3VIiPNlvOcfN3RTSjUYnqxv6VrjE?=
 =?us-ascii?Q?Z0bFmxLg+aLMzpDMpO2nLB8DXRJ611K+OxGIhTEyczcPy8t0LVhSTgSbdV1t?=
 =?us-ascii?Q?mL49QQuunppYgoBJYgw5EphvsEQZPiGSs0BxYdtY2uFzkDijELOZUpKpjO7E?=
 =?us-ascii?Q?vY9xYcIAoHrI6Zv223G4ND4Kgoj4IPMMLixSXpK9jdBf7QVORetRGYiSCsdo?=
 =?us-ascii?Q?T/seH9g15W91Pl6Rng55x/o4HJK4n49/u2hJ9gNqRpWkEGnQcfo/rW9+yCvM?=
 =?us-ascii?Q?enV6bZ7eZF5mpakRG8x3e13gG3mTKDxeuKn2dMs5U2bnY5yuYg/F74LhetpN?=
 =?us-ascii?Q?NHUXdde8CF0rcswFfpggRE8RsSSD9W7RR03fbk8xlUIz3gQobyUKhp/6Fp4M?=
 =?us-ascii?Q?W1ykBWvFd6ftD1guxzT5pJwIkbwNh2V23QjJldoq2VfLlYQ9p6hfmILgGKOa?=
 =?us-ascii?Q?cA7B5tiwI/w1SmBgnldGPqhBLQjqKuWTqt8yACKyh6VtxG9SdVJVKzpLZzbV?=
 =?us-ascii?Q?0Z5CbMnig7MJqRDxFh6uhkioVGk5z7xRW/1ljcdRGhg5T+GbvrZlnFiFEHCE?=
 =?us-ascii?Q?NJTS+yPsVJIGTDvy/9+KY92POtPOND+l1po5rKDWlbyMnCx42ENYn4RE4hvX?=
 =?us-ascii?Q?DzbDA0y/dCly5K34aVnpMhvu/X+r1hpIYvDkOyxwBvV1rLOvM1AoE6XCFxSv?=
 =?us-ascii?Q?XV2HQRxUwJXd4D46lJxNg5g2xJxVRcdjfimrnX245JSsZo0LusxSD0GNPT34?=
 =?us-ascii?Q?PiUI34/5jAX8U+SrVnEPz5eOCJPzgJ1t6CBi5KD/YNc49O7y26erUveXze97?=
 =?us-ascii?Q?pzKUpz/Ock2DLMfpjBVtJDnHlTbmJTq6v00bURZq9ucZYMNF2MNLpNfYAAKn?=
 =?us-ascii?Q?WgnifJg/k2yMg0Kd7E08xPZZpjWN4qn5Hq70XFtD2kHTxuKu7CWItMaWdFIT?=
 =?us-ascii?Q?VAtZ6OVX6SM6CIWYbOQSderKeApt64NU7T/8pAmBlwCc/3zglSKuF2zLIMrM?=
 =?us-ascii?Q?EcGFiumr0Hq0c1PN118zYuXyoQqmcWpLJ52R0NiwKjqTKdD/6AbdUt/AOasy?=
 =?us-ascii?Q?ubdmT0vGd7GrKq61TwjpnIksR5RVcJETFDo3QJUj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3105f5e6-a5f3-4159-79e1-08db0a7fe5a1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:27:43.5415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CfyANMzEt61Jl08iDj+72d6X1Smn3P0XJTSbBypBQWFLz2cXX4JXO5ywZeeEGb6HY+2EN9oXCauiWcxbIo4yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6904
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/freescale/fec.h      |   4 +
 drivers/net/ethernet/freescale/fec_main.c | 106 ++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 5ba1e0d71c68..ad5f968aa086 100644
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
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..3bb3a071fa0c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -66,6 +66,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <net/pkt_sched.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
 
@@ -3232,6 +3233,110 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 	return phy_mii_ioctl(phydev, rq, cmd);
 }
 
+static u32 fec_enet_get_idle_slope(u8 bw)
+{
+	u32 idle_slope, quotient, msb;
+
+	/* Convert bw to hardware idle slope */
+	idle_slope = (512 * bw) / (100 - bw);
+
+	if (idle_slope >= 128) {
+		/* For values equal to or greater than 128, idle_slope = 128 * m,
+		 * where m = 1, 2, 3, ...12. Here we use the rounding method.
+		 */
+		quotient = idle_slope / 128;
+		if (idle_slope >= quotient * 128 + 64)
+			idle_slope = 128 * (quotient + 1);
+		else
+			idle_slope = 128 * quotient;
+
+		goto end;
+	}
+
+	/* For values less than 128, idle_slope = 2 ^ n, where
+	 * n = 0, 1, 2, ...6. Here we use the rounding method.
+	 * So the minimum of idle_slope is 1.
+	 */
+	msb = fls(idle_slope);
+
+	if (msb == 0 || msb == 1) {
+		idle_slope = 1;
+		goto end;
+	}
+
+	msb -= 1;
+	if (idle_slope >= (1 << msb) + (1 << (msb - 1)))
+		idle_slope = 1 << (msb + 1);
+	else
+		idle_slope = 1 << msb;
+
+end:
+	return idle_slope;
+}
+
+static int fec_enet_setup_tc_cbs(struct net_device *ndev, void *type_data)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct tc_cbs_qopt_offload *cbs = type_data;
+	int queue =  cbs->queue;
+	u32 speed = fep->speed;
+	u32 val, idle_slope;
+	u8 bw;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return -EOPNOTSUPP;
+
+	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must has
+	 * three queues.
+	 */
+	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
+		return -EOPNOTSUPP;
+
+	/* Queue 0 is not AVB capable */
+	if (queue <= 0 || queue >= fep->num_tx_queues)
+		return -EINVAL;
+
+	val = readl(fep->hwp + FEC_QOS_SCHEME);
+	val &= ~FEC_QOS_TX_SHEME_MASK;
+	if (!cbs->enable) {
+		val |= ROUND_ROBIN_SCHEME;
+		writel(val, fep->hwp + FEC_QOS_SCHEME);
+
+		return 0;
+	}
+
+	val |= CREDIT_BASED_SCHEME;
+	writel(val, fep->hwp + FEC_QOS_SCHEME);
+
+	/* cbs->idleslope is in kilobits per second. speed is the port rate
+	 * in megabits per second. So bandwidth ratio bw = (idleslope /
+	 * (speed * 1000)) * 100, the unit is percentage.
+	 */
+	bw = cbs->idleslope / (speed * 10UL);
+	/* bw% can not >= 100% */
+	if (bw >= 100)
+		return -EINVAL;
+	idle_slope = fec_enet_get_idle_slope(bw);
+
+	val = readl(fep->hwp + FEC_DMA_CFG(queue));
+	val &= ~IDLE_SLOPE_MASK;
+	val |= idle_slope & IDLE_SLOPE_MASK;
+	writel(val, fep->hwp + FEC_DMA_CFG(queue));
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
 static void fec_enet_free_buffers(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3882,6 +3987,7 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_tx_timeout		= fec_timeout,
 	.ndo_set_mac_address	= fec_set_mac_address,
 	.ndo_eth_ioctl		= fec_enet_ioctl,
+	.ndo_setup_tc	= fec_enet_setup_tc,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= fec_poll_controller,
 #endif
-- 
2.25.1

