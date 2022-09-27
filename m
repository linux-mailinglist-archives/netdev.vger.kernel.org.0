Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E04A5ED143
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiI0Xuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiI0XuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:50:03 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E771DCC64;
        Tue, 27 Sep 2022 16:48:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Df3nawH1pmTO/RWpmXmt1REnf0GRbC1Zp9l14CTYkjV0eJpodQos9Kgn110ticNymYgk8tBFBWULwAuTo2c8alIK4IGlfXYLP5ocILwG5mii9MWYx73ElIbZhMCU5qNUcD/MYo4yD9mghavfhrWxouGMjh5zZQRjY6z6bVqcNOuYUXSLUe79brKtpO9iEcP0/onkHMqXv8GYSzWSN5RzhRshGrPot/v0s5QJ1sjnmSmbujVNjbr23olwiuPpBCsMcGOmGk/q37Eeh3r3TotzlC3/DvIeP7ruqlHgQTJLJ/9m1pv8mtIHYJIHaJnS6wF+pFkisaaB6TQ1mhhyP4hRqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqcjgH6LKi3PibKIAig3lHNnby+SLPB7547ljDCPQKo=;
 b=BsJXeRNOjpVkRCRDlXn0MYr92xJ0fmX9KTNhee6U7A1NlZDqWrahVXUhRZdmD5BAdcc4iXXQq85lazuFbf6Cp3YItVcYkX9BtkBtjoa2aNejWhMJ8TmzErlJtKlGnPQjl9MDTsaXew9ITPjMgdt7fanGLfEbJWNg8AzyR/PXkpT2HyfEJNjQ1z+SaZWBpFZ+gBLVof2K8nWZdQTpljrp5b/JLTK/tZAzJc99JRTv2K9Bqgd+CgVxZTulro5Ea5g+NTMDy1JLN9QGQhkVYngeF38+Hwmv/MagKMNx+C/S9cj/G4W3S8B0K8OUB5q3yS5EwSEGVSl+DYmKCUxjcUnVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqcjgH6LKi3PibKIAig3lHNnby+SLPB7547ljDCPQKo=;
 b=STXfqC4MiJUUrGJl7tGgfACPxfEq+J0Vg7MANDXRwFFDvjxrERH10lLQWHZpFGVauUpaXAI53SIrlR3Xq25QV6jzXb3zLEvqFc2uprxmA3PwNNLNrugGh4fIXIA4xZwx3REBs5qNx58tkVNIeJCyMRyykHtuUhPvVDS2RC2ysIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 8/8] net: enetc: offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 02:47:46 +0300
Message-Id: <20220927234746.1823648-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c77b51-1823-482e-5f64-08daa0e2bbb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9iQYplfH2pgDmZ1Au9/tzQydGwwULzkahrH52UxiIf8vnlYVfaNErLDXkvkM283IS0qqHaA8cqBEecmaUdA0/plg4WdjFVHtS0wm0fvgMdGpk15tIBMagNB9dfvGeJPmGnz23WQlHka1YDyLykp49jMhAIphlRIRMMawmM26rvcron57OV5fOVqobOgQCkusHlg54GuFvBWjs1fP8t5Nimt1pGD1+9apo3X228xitF7oQRTXquLKi2tJMri2m0I/QklhoVUL/eMq7YNTz3u1Zktv0gNRdd41trMqE/wMPpgSMiNOBDN9nLB9G935asvUIT0/ai2bTDZyvTetRAvePLqzyU07UYs7RNCCty9lhf42uLh4+AOjQ8rf2rN5fqbeGX7Ug8cNQAwlHVsbtUm/F+8hD0rykAqLXoCOsQepa6PS5jYbpJA1Qjv9PLHKYY+nmg2GU0y22dCFYXqpA23tvp/vYW5a2Eke1634kDFBisS/7TYtNB0+iPSZFGmIqG3c83f01oen3k4IeyW8sEwpin9xYYQNCsTTjPUJlwehkGGk5OzcVVvxyNF7NXBum92xR5byHwtiG4SbaxCK3UsO8oebWR7+/n4SzcFQrw9SLWMHFSlz5izgIU4ZdT1i79VeT+Ws4DX33SRpf5Hp1qi5w/Zw7nKM+vmSEOnfmk4BSHUJAfM0x5uBvo9n8vdzwaymg44pTscmruyVr2ED9hMUqYpF3kHIBNV3KfYrLSCZuRdgOJo8cpDerJJbh037+DWbBdDhJgopZdshaFvlLu2qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BNnv0jzRgAK3OuhP8VbFsFgCnk4mRIUuKj1Z13HfaZ0jEhK3dMRfDaiyH61y?=
 =?us-ascii?Q?5q+HdiiRlIJL3YrKSTZb3tO9PbklueydZiiabXq8ma7Mc0pACMHRoTaw7nP2?=
 =?us-ascii?Q?XZk9taI7Iy6P0M0S12zsnrBv3+W5qibH661wv8P8A7I9ADRKJbG3GHFt4QtX?=
 =?us-ascii?Q?TRxP4N+lKwXk8IALE8LFASLFYzbRd72AT158JnHkVu5c+Ni8d4sB4blnelm6?=
 =?us-ascii?Q?bpgnIuBYVpr8xs9T5VbQ7m9fwrFpgTzdswAXf/5ujgDrPKXzqbCSE3p1nzN4?=
 =?us-ascii?Q?Y5UP9vvOfaiNyglBUFLmrNu8cFTqm5rGPhV0z3uWqruIw1P3c3fVvV92KiGG?=
 =?us-ascii?Q?+mP1QJkF7NlcHhCk3qteEoBsK5/VVoixlm94pS96krlTT2Otl17Xt9FuMpDy?=
 =?us-ascii?Q?RQAaZVlplX9fq4IA7FzEraQyEDi13saIHOxS2ca7dfKcSiYEh2aMqnRwxuYD?=
 =?us-ascii?Q?4+0W6ehXs1iYrys6WVLGCSV0d1aw7jKPPqEC5ifM1WXWIkvVQxcgFXqk1fJW?=
 =?us-ascii?Q?psLLzx1fpoCUbB3IuL06wM7mp8CdXI5IWlwJECLVjLnFxUyEWjFt+1lBLCzW?=
 =?us-ascii?Q?XRC6kS1NYvyXtpP0D95utK8/KacQWhGCTListIPbWf6xuqk8qOzTwHLprRgC?=
 =?us-ascii?Q?ohzxYtJebH/21sKlfe/XPxFzun4cVyilvpnYVybeup0oBL5+YD58J+8Bj0Hn?=
 =?us-ascii?Q?rwwqkkgTVHem4rSSzUp2WwUBqkvZHa0kRELaDrYsZYJZr7dpXoZt7W5752B7?=
 =?us-ascii?Q?Opmfbu0KKD7HjuemRm0juNG9qQG7QPB+k07kJuqWl1ydjRwv+hvOLbGI/G0P?=
 =?us-ascii?Q?T//isVH1bSLQp70VWW1Y8Cid975rXYvKqmg1BSIbb/n1Awy45STE1tZWMqq5?=
 =?us-ascii?Q?dmn0CCDdLsMr5Po+UL1/MF4s3AIGZTH05HW2PjldckdjwBU9OVc5zoIa8jnO?=
 =?us-ascii?Q?DZiwL+0o3VfOKxtE64Xq9LUnuSxo3y0bAlTC3yXJMfwx5pq52dvFnoMgCGeO?=
 =?us-ascii?Q?/j0B/fM0M7bHBm1l1WE+YT1n08TPypwh/ggdyi69nE+fED8uPQFApPpGD3Yy?=
 =?us-ascii?Q?OkUxdTjS5e1IDEygb5YmD28eyy6RaSG56wlhe6xwxWiKE5hQ2oU8VRJjUhWV?=
 =?us-ascii?Q?27xn6inSCd8A5lu7+i27r8YYxmngJfQ+4qd4Dxr4fGNgVUrKa07PpdNcDeog?=
 =?us-ascii?Q?T79//snW0DigcCyw26iD+Rm4NLBC9OuRM9ATE+cham6WPz7AYGRUEF/fyNp7?=
 =?us-ascii?Q?7e07K5yLf43ZySnUjbIQ0BVbWdsbRVXBg6plExc53rvMp1Qsuyk0QdeS14B2?=
 =?us-ascii?Q?X1CNW6nuuRr5EtthTPc+f+utZ/+0IaN1OkLd6R5zawrKwNApsm8hiSK/EjNr?=
 =?us-ascii?Q?5rFpmtuuaBch94GTyiEnJJ4eVmzB7/221cH9FEBvZ32a6Z9NowvQ8mF7SEth?=
 =?us-ascii?Q?Q44o3KHf7IXbJdFsl16nchdnCwxj6UAnHnwJE90NYA2+92zFwKFRdyrtmatm?=
 =?us-ascii?Q?NFS4ejoQljk3QZTpYkbgLAXxKGk3z5ZKcplSctPvwo9n39atIG/fM/f0U9Mu?=
 =?us-ascii?Q?dnO7kiqosYgvwqPqdUpFZ/dCt7CtU6QbujA58IrcqGL+XcfNin8OTzh+NF5H?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c77b51-1823-482e-5f64-08daa0e2bbb8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:10.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhMgC7g1+cxTODtIQZA8o1qqFzat0mmEi28p7QjVBOjewtgxnsEhdKZuHZv0lAJPLej+P21YGTYRJYhAY2C3IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently sets the PTCMSDUR register statically to the max
MTU supported by the interface. Keep this logic if tc-taprio is absent
or if the max_sdu for a traffic class is 0, and follow the requested max
SDU size otherwise.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none
v2->v3: implement TC_QUERY_CAPS with TC_SETUP_QDISC_TAPRIO

 drivers/net/ethernet/freescale/enetc/enetc.h  |  5 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 27 ++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++++++++--
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 748677b2ce1f..161930a65f61 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -453,7 +453,11 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 			  data, *dma);
 }
 
+void enetc_reset_ptcmsdur(struct enetc_hw *hw);
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+
 #ifdef CONFIG_FSL_ENETC_QOS
+int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
@@ -521,6 +525,7 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 }
 
 #else
+#define enetc_qos_query_caps(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(priv, speed) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bb7750222691..bdf94335ee99 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -516,15 +516,34 @@ static void enetc_port_si_configure(struct enetc_si *si)
 	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw)
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *max_sdu)
 {
 	int tc;
 
-	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
-		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
+	for (tc = 0; tc < 8; tc++) {
+		u32 val = ENETC_MAC_MAXFRM_SIZE;
+
+		if (max_sdu[tc])
+			val = max_sdu[tc] + VLAN_ETH_HLEN;
+
+		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), val);
+	}
+}
+
+void enetc_reset_ptcmsdur(struct enetc_hw *hw)
+{
+	int tc;
 
 	for (tc = 0; tc < 8; tc++)
 		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), ENETC_MAC_MAXFRM_SIZE);
+}
+
+static void enetc_configure_port_mac(struct enetc_hw *hw)
+{
+	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
+		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
+
+	enetc_reset_ptcmsdur(hw);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
@@ -738,6 +757,8 @@ static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			     void *type_data)
 {
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return enetc_qos_query_caps(ndev, type_data);
 	case TC_SETUP_QDISC_MQPRIO:
 		return enetc_setup_tc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index ee28cb62afe8..e6416332ec79 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -7,6 +7,7 @@
 #include <linux/math64.h>
 #include <linux/refcount.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_gate.h>
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
@@ -67,6 +68,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
 		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
+		enetc_reset_ptcmsdur(hw);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -122,10 +124,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
-	if (!err)
-		priv->active_offloads |= ENETC_F_QBV;
+	if (err)
+		return err;
 
-	return err;
+	enetc_set_ptcmsdur(hw, admin_conf->max_sdu);
+	priv->active_offloads |= ENETC_F_QBV;
+
+	return 0;
 }
 
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
@@ -1594,3 +1599,23 @@ int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
 
 	return 0;
 }
+
+int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_query_caps_base *base = type_data;
+	struct enetc_si *si = priv->si;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (si->hw_features & ENETC_SI_F_QBV)
+			caps->supports_queue_max_sdu = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
-- 
2.34.1

