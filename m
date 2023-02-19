Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2629869C083
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBSNzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBSNzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:55:39 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16EE1166D;
        Sun, 19 Feb 2023 05:55:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBm2wW3xx1ID90E3XAlggZIJRSy/U6F+Ooo7gbmTlkslWkujEfN9FRQKYYqd3lvKc3f0VoCWwLttKgXTyHaviRYorE6kGzkhrq8spzJEtTiGM79lxXDs6R4tPacVx2/PvdbqJEmD3S8hMjcDKCcUcB0tkz8wiCtu9g+yPUuuJpbw+cW2Edrc+YUlxZy3aDHViWUcBGgESeNyN0nlyqqnPi+h1z3nXubt6XxOEPHx+vwkqCL4WRIUeV8HZTXd1u0m3iQMwPMV48rYUDdEd6kan+m8Mx1+FiXVP/4rkjA63gOv4lccemCu0V/GqVv5zErzHFzbhv6mj2L3QS7fTbMlHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knxDSXXbyoJv/0vvC/G3NE1Qp+zteBCa6Ip6NcPFFV4=;
 b=UIxXQ2R8uyZsz6xRzZADNHZO8U/hLZ3rQvWVDe0++uZBnoUAyW2uztLIJHnYxlZoDZvRF8hcMo8+Mrmu4CiXNn+8XOtXarCep9K5CLblxIzhSAf2HPKp+Vog47m03TKFD5KGY53OS0fS4mGcI98m6ShXvzuMmGZaPZmK2d8rgkmmAhlyIPeAUJQCJAWpm5UbcWgF0cP8pnTM+SVBfFlWJ35ay3k/cmf8TQCbLsMXpRW/IyM5pItLzsnpO2cv5qXcoxcJ7qCKQbrF1SZqc4D6/iGkMqAYkeEr6sYKeqw/D3KScgqeXTNwTDYXJeGVJywixjSrzW7Gu1O1YxjIqgvLSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knxDSXXbyoJv/0vvC/G3NE1Qp+zteBCa6Ip6NcPFFV4=;
 b=CLxkB7wP3phZEw9UM9X9dZzJ5gUtv2ZfYj8GFGR8KrtG0+MD0kTIjtFQ1o7Dr0zpqYoUgPr2coTdLs/CkgNT48HMirkg8bTBdfw9Bk7iNlPa7GxOC6Knhcak2zwsnGuHVMjzeV1wGV1T7vjxxRHlkld7n+oNsjI/zCluOXm7Xb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:54:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:54:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 12/12] net: enetc: add support for preemptible traffic classes
Date:   Sun, 19 Feb 2023 15:53:08 +0200
Message-Id: <20230219135309.594188-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bdeaec7-ecf3-4bde-f55e-08db1280c133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPOjGp52WVf/DGonI2X/5thaJUOAfRqslqL5c+qcCqYpPLsfwiNG6jcDcJsLKS1P3Xaa/w9YWX/01bnME6+YelaGUWCAomjTauUi+hwrEGjjWTuGqJuGL547jTMyORZy7Npc0yjrsy8wP0HWEa8FSzEEc+yHwSDvJEXml3WVy7AQbaRWDnyW9MZt/FYtO7e7dCSIIoDLv/kQkpBrCNG/VXSjRc+fKV8vfUwk3bwNcVC59hXAeZXlOsfwISFz468ijNulabSGkMmTZtYw3FxpOiniKFA/b2Lwx3A7b0obglU3CYY37Kf7mKXMfn7UiSGWvrbKUSk+RX+oVa5tSEPwQTfk6U2kLyhykUYgmHwDkz//jlBnoxb+1BKpDUmsTOlMT+ip7e9M2NDU4kSalf4YdTAkcDHKg1vF7MfK1olwfITRb8VGTz02oLwqCkOu9TsEOA8VXukfxCcNtdLD9zjXC0vp1mJJQ++oAMVumc3TEYZFBZBOPx9+20Wdvhl2Uo/Og2YOYHS+qNy/lh+XszmR5ufQSOxrFJIj3d+W1lvcpH4MVGgjA/ZMQ6FWs2SQEjZuWk17gOyzjfDFgovjNF/a4CZnrPqKYSxHz2pjYmnjp9N9OpOuzrIAqV5gUXR8rdzOgD85kAo0zQxBmbIe2dG88B3pbeP72awv7q6xQo7CcXED2177xyYFpeA18AxbgwR1od++R6MPpCu1AsLA36PT7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aACVf/2hmLj/M/8n2HsK5z2xn0puVLrAkuYclXIwTKl32vAEGTffOtoh8jbf?=
 =?us-ascii?Q?IJEPDfbu7xYJzh8hR67cJCsRy4a3wU9skfDmHDoTfgzc0vkY395GDJyWRj3x?=
 =?us-ascii?Q?NHLI1lxy18h8Qi0o9FcIptpbrTmnkltCSw04ruJg6crP4OJeVKsxPq6xDQo8?=
 =?us-ascii?Q?MT0RnEKc4x1DO4yAl/EyAgxZPVjsbmltmUjj9rdjGpYtb32qoc14HVXtl6Vm?=
 =?us-ascii?Q?JyLmC4iYCbpNBgJwrKLQwek7oYzzHUzxHQ9IGUdz81OQ/eowv/pzkwzoojrm?=
 =?us-ascii?Q?sagV3mLAGQoHDKRdloeggIjx4/6SyvGAihH9pl+a5giIiHA1Rz9uQg7pb++h?=
 =?us-ascii?Q?tpPvP5cDiL/ttAinclRrJ17eF0b3qZIzt8yRHZmlrXFwhgXUAwqls+C+Mq0I?=
 =?us-ascii?Q?XWXb6/I8XtDg5R8MHBvJ8941Ey9H6iiDlRSil07SZ0jchqbo9YL+XJ06nfND?=
 =?us-ascii?Q?65lhTE3hYopFfOQ6bwo8jVCZPf4fHlO72JoQR+D7ChuhXeLUhXV7QWkF4Bs7?=
 =?us-ascii?Q?H+Oe0G64RPx8cFyjPUTLdyQO1DpSsmpLKAHY+sb7tb7wQlQAHS7cta+uandR?=
 =?us-ascii?Q?VeP/ueMIwOoH0t5H0kAEhpav9TDFuuL7XFy7DvxBTrICZy3vhWLsrQLhgDw8?=
 =?us-ascii?Q?PDIoDiYtXaFrJKmq5Q2xB8L/BmjZjSoWqowagjcr3t2eDcWYpIug8oWNwUyp?=
 =?us-ascii?Q?L+J26+HDdhmayUkN4SlSG7JvL4Az+KO2AM390WCOMo/oMJcwVs8cclv4G9tZ?=
 =?us-ascii?Q?aYdm72f3ajV1BcDWQbDvmkrL0I/6CDb/bLB+GvgnKhLR/2Crjy4dCxsGyNI+?=
 =?us-ascii?Q?KTnkqubrdmak8J2kYh4opKuL/SjRkcv3Y3NdiGm/YJi8q5FpMcmz02XvCozr?=
 =?us-ascii?Q?Umper1Jbcv5Js8ulO5VbJHlLXI37wt8wyGP8ef+NMIiHg+FrIKzuP1bGcYnP?=
 =?us-ascii?Q?TDpE5jXg3rx7fpJ1WoYZEJvsZcP3rsQe9t9Nwu7vnGa6IKLqT3MRu/PE4bO4?=
 =?us-ascii?Q?+vAXr6rHWHAWnXp3qBR45ekcfj6fKQ1J2NBk16JNm44XQ0fI8OiDfRKvD5B3?=
 =?us-ascii?Q?1N+YJvH+NbFqW+C0lV3Ss35CD8WhkZfKzWJd7JZ79sXFlQ6fQ6heiIRybDyy?=
 =?us-ascii?Q?9SNKsa+OMM7v9g3RfY5zE92reu2c6vAiXs3JQmmmf80PLI4EeetFvXKkp0Mv?=
 =?us-ascii?Q?sCLbO+0T4qVnTjILQ/lHtKvI8McPnpPMm1Rp855oBc77aaOOhvCru17nw7Dw?=
 =?us-ascii?Q?LSji2VV6GdWyFG3ytIO+WNBhMIXvxzzbOm5Vnuy1HZzMKNSgy/lJV16W7kBV?=
 =?us-ascii?Q?BTrSa7aAbPRW8madnqMkZ91FdOZO2q6PeflQfApDmg7KXAhN93onAUetP42d?=
 =?us-ascii?Q?QTzFgGVc8nKQXBrP9M+Mp8Y9NPV5p/RiIoaAR6N8cqLQN14wi0vn/Wgi7jkO?=
 =?us-ascii?Q?1ygESts3nOJnpo+4vU4mNjEGYD4OlBkl3YIzG6l6sYCcNTp3RiYX7YoqgFZh?=
 =?us-ascii?Q?nROImNZ5CEQ0Aie7LJ9AOSCN8Cbq9Xa2KvAUUyzJKnbtmw+sJedD1Sc0FL+n?=
 =?us-ascii?Q?6bFPTSG8UZ51YQh0SyUqMLL0cqkgWFJqs5mxsQTYvRnSYCNYsvw0wT7eMEzQ?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdeaec7-ecf3-4bde-f55e-08db1280c133
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:54:01.2547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YARr60V9KyXNVRFZjsLzsYPNNrXdp4SP+wy6P2EUcmItrV+6sVrCf4fvXXZKID1KZxyWUk6w2KDD34s/2VT44g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PFs which support the MAC Merge layer also have a set of 8 registers
called "Port traffic class N frame preemption register (PTC0FPR - PTC7FPR)".
Through these, a traffic class (group of TX rings of same dequeue
priority) can be mapped to the eMAC or to the pMAC.

There's nothing particularly spectacular here. We should probably only
commit the preemptible TCs to hardware once the MAC Merge layer became
active, but unlike Felix, we don't have an IRQ that notifies us of that.
We'd have to sleep for up to verifyTime (127 ms) to wait for a
resolution coming from the verification state machine; not only from the
ndo_setup_tc() code path, but also from enetc_mm_link_state_update().
Since it's relatively complicated and has a relatively small benefit,
I'm not doing it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/freescale/enetc/enetc.c  | 22 +++++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e0207b01ddd6..41c194c1672d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -25,6 +25,24 @@ void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val)
 }
 EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs)
+{
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(hw, ENETC_PTCFPR(tc));
+
+		if (preemptible_tcs & BIT(tc))
+			val |= ENETC_PTCFPR_FPE;
+		else
+			val &= ~ENETC_PTCFPR_FPE;
+
+		enetc_port_wr(hw, ENETC_PTCFPR(tc), val);
+	}
+}
+EXPORT_SYMBOL_GPL(enetc_set_ptcfpr);
+
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
@@ -2640,6 +2658,8 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 	}
 
 	enetc_debug_tx_ring_prios(priv);
+
+	enetc_set_ptcfpr(hw, 0);
 }
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
@@ -2694,6 +2714,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	enetc_debug_tx_ring_prios(priv);
 
+	enetc_set_ptcfpr(hw, mqprio->preemptible_tcs);
+
 	return 0;
 
 err_reset_tc:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 8010f31cd10d..143078a9ef16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -486,6 +486,7 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 
 void enetc_reset_ptcmsdur(struct enetc_hw *hw);
 void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index de2e0ee8cdcb..36bb2d6d5658 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -965,6 +965,10 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 	return (u32)div_u64(usecs * ENETC_CLK, 1000000ULL);
 }
 
+/* Port traffic class frame preemption register */
+#define ENETC_PTCFPR(n)			(0x1910 + (n) * 4) /* n = [0 ..7] */
+#define ENETC_PTCFPR_FPE		BIT(31)
+
 /* port time gating control register */
 #define ENETC_PTGCR			0x11a00
 #define ENETC_PTGCR_TGE			BIT(31)
-- 
2.34.1

