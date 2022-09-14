Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3525B8BF4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiINPeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiINPdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:46 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0105C4CA28;
        Wed, 14 Sep 2022 08:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEqC1eS9i+rItKpWwVcL0218IX1HyR0qX2Vkt06I4t3fskQbjFOdjrwXw5O/kd8RigzP6puGHEgy92IHvhD72DVVyZxK6qhN7bL33yxKTAqhH/i+gWIxPuLL370/YC6QfOsgLSsVuGnQOIAizXQaxqruHjVk4G3coL97Og6biZXifuu/wx3Zo0xrlYBRqCrUZZmGNatdNkTwDbd7VCSgXeZdr3IrwKG9G1i5Xmp3x31gPLP0fZcOkl5XlDtDBbmce9+pHds8N20pQLELQBagQLgV4Z6yTY0EwGRybiaqZhLq+lebUUeadplCm9sKEjPUZFWFZe06zfjm9TW8mYOEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tLnJQ82D/S6wt3UqVO8/oCdxwB3FY6YVPwb6n/Cjvs=;
 b=fvMmm3KsxuP53oHHYY5ySoBzjfKwFsuidUGnXO5QyMYkBlvXKU9M4nX2xZjSLFjAPFdXZa878idfE68HikfggBXR+aJCALb+xjbXKRztmJYBvZqWeYLc5Jtq4aBxIXgNFZbMp2xzplxyUNrxTfatTpWByEDN8k+iiPt31GfN/BHNQ+/vh3ViIAm8B2Ltjs5MXgdLRObqEUgOZfb+E8ODeeFQ0Y4SSID/+ln9bvT2f+x7hObCqRfKrFbILAWBqYl99s/7fOASvuGtbyUou2elmOfXxpZtz/Wy0YIdOAqHWz49X9t1UcaVB8+eP8XBDP0JBCYK1Lorzof/ZLOkpdbdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tLnJQ82D/S6wt3UqVO8/oCdxwB3FY6YVPwb6n/Cjvs=;
 b=RRLC7P7NxLs7fiZT6GCZ2U2wfLYwpgr75NjZGeuIdfuhQxWhXHkx4rfkUDJ3pWJCTRKpZ/xsKMWRxY37dIe2hx9sY8lLE2cCJxClfQWE2z2qLGUwnnQt6Hyp9POkzcMGmTGMtT39vGFMPgKMsu+Zhc9pJ8vkav+CGIL6J5RYc+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:43 +0000
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
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/13] net: enetc: offload per-tc max SDU from tc-taprio
Date:   Wed, 14 Sep 2022 18:32:57 +0300
Message-Id: <20220914153303.1792444-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 363103e8-9f42-4429-db8f-08da966681ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqWm/RaB27+CWGV/ai93rgrLdGtLU1jrEnfk3rFFvoEqSszh1EK+qH/1JD/iBuGPVp8RoQVfEuJ6xDux/kaSfmRBqAe70lVJaccv1la7t3gzGnRWMe7lFF4UoAuJK/h4lAmT8mmn1ftMph7MU0qtfAojo0jbKijaA5glee5jlT4TjBuw2qXhGAbN3a+MgfdctRvB9n1hGdcjUnk4JCawwUiZSX4HBO+m7eHJSvyiAcIKUab8LQg5Ef7RqN6h4INLbw7FEbmHEhK6w8MQ8CkSq1HKicTJU9C1mxlvisQYcYsm/fv2JQmPaMQDLKDChYpVEPXZZusrQuFFU4akv/9Ybqhh6BwyqhJXnTKPp8/0JPV4kcUJlTluxhOBhkM9nUkkc1c/eyOGQ1NXaw1HDQoTm4PQXLbd0sCjPgvy4zfleXcs1XVYTbTPfDRuhw2MLsXPjZ+ODLw02dYZ+0bG2x8PiKt4AwNXrvSLwKeUEGi98uiAlYrtvQG4tuwbsNW32mIUtX/ROhTQ+N3f8GJUcFb2xt3/wA5FrbDjF31mHjw3ZUZkHXZEmpcZiP00s/KRCF0uisQmZ9Y8kgHaf8Fngnu6HIg0QLrLaQJ6hqyuvXKs1qktT+dBk1k+diMlTmhw8HGyEUSg7RuecG4iENuySNeoOM8F9ODAWMkU4V9oJErCC6s3odZbSwNm1jTYXW1uN18caNflBPZp21/8saEDLbiYAP3Mj5FTpSmkaGLZquTEOWcsU4zQmUkiDwpbK3T14w3cT1ohpvwMD1c+mWFJVASH9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7pOt6EE8wv3KY5RcMqsrfH5tDJsjpoG0LaTKunQKmbvaXvC1qakDtysASHpK?=
 =?us-ascii?Q?a1PaMsXl/uF/DJVIY2ONKc5NjJXn7wg8ngOreFfF5ENYk+86nSWwoc0V4CHR?=
 =?us-ascii?Q?/V4TqOf8QWGzOeR1thisuM83Djg+bSd809U4Yza/UEzzbzPLB/HKqSicspqW?=
 =?us-ascii?Q?lDWLsF9BaX6SCyovm8KYCAgK2DP78W+qnhvG2SovZ8t6FTimPjcMRY7uUPoq?=
 =?us-ascii?Q?xQ7WmfkwLSuRtZlM96mrr+MpdQLAUeuXgDwbYdV5tqN2j3N6ose/QB82+wfl?=
 =?us-ascii?Q?SjuVG2wyU/ys3IArmF6FkCP35BoaooZEGlCewGKXJT2pP+9v03jxb83SmBnc?=
 =?us-ascii?Q?P+dgmMCvy0C6ADaEe1VPh+G9fmCXz2B3D86EtI+aI+a41aHtnklQzYcIfgZP?=
 =?us-ascii?Q?2M2naZmIU0C6FXN7dtRoqv+uRDnorwLR1m/XVuBAIW8SHMGetxyyEg1/Sj+1?=
 =?us-ascii?Q?/acVN0cyx4ssYzAGYw39NpBC+gjCcY29+tq+irr6n6iaQ2bVTUjvtSKFKRT9?=
 =?us-ascii?Q?aIOP6yGCmlt2it1G6Bpekvis7ofjUCABTLgH1BZOiB1slVn0z+fQhYcEtQIJ?=
 =?us-ascii?Q?83fyNSpvBul4i/T0ivu2xdmVuWVcO6fjyomW+hmzf+vaUfBXnUe/gtuGrKd1?=
 =?us-ascii?Q?9BdopDrzgTCYLdkqH1Wpu2vfLhtVLEXyZcrmXA/hnzpNvogOdRd20thm5YQR?=
 =?us-ascii?Q?PRGYVAmY/JR6SGF7WAkE1OcgHcuyIBIK1ihnWiyZVrSqbFaDbTDwjMz/kk1g?=
 =?us-ascii?Q?xCd/nxHxDLvl3WwA73goddsJ3O6ztOB/BKXy+E7lMKlftgPB67uoZHRrjvi+?=
 =?us-ascii?Q?lwpDdhMtjuOQ7ouZfOWDwtu8sMygKZMDgS5ZjM3FE+AqSLHqnP/1S3slgADS?=
 =?us-ascii?Q?d2uzjKU9sTy+KP99KhAp/l/kaaNpH6Uudk7DwNto/AK8xIZRZ2SbP51ka+dw?=
 =?us-ascii?Q?1HX51FKJJPTfZwhFIdWm7kWpF2aNFTu+rea51URhM7bSK+LWylfrng+Kwc+5?=
 =?us-ascii?Q?7uNLmnJvg11xITRsL2bdi0GZstsYEGNhoOpj1CKYp0Y4k2f02/F68ed3Ul1K?=
 =?us-ascii?Q?oaLuOpzb8zDlURIisLbGGoOL2Samz2Im4bpHbD6kqhxtl3OT4RcSmq1IrDRs?=
 =?us-ascii?Q?SE+p2rVIx4WX0u7Ks0klDDikaqhfcvyAuz6EyWZnJgW1o4YTmd8A/hSW5x1q?=
 =?us-ascii?Q?XBfQ3R2iygyVkDA1cPebroHmCEAtW4Yx9gkg8E+FjDYgXWm0jL4Wa/M6P4WO?=
 =?us-ascii?Q?G3yO/4dbCNT6lZv9p3FadUdCusaDxSaxEja+By4lQTh/Hykm0x0efyx2HuP+?=
 =?us-ascii?Q?JgaDCPruIVLp8sepxzjuv27HYNdyF8tdCP3cO7yprM4Z+GX11DLHPYk/Ww/c?=
 =?us-ascii?Q?UzDijIwVu05KikeEEf7YleL1BXEwNGQgSbmroUMmDfGjDNG8l3CQOA1A2SJr?=
 =?us-ascii?Q?eHYiR2LojaJLlAP3RDOeI4mzqT0YT+1eRctgEj9RI/qkzv+yRF7rGukflZuS?=
 =?us-ascii?Q?tp7bRvl8pDNwrSH1bBuhuBvypC16C2mWXMEz/PIalJn/edFQgafHFCbVTksP?=
 =?us-ascii?Q?y2K96VGC+eejcgWN3Be4fqKY3RCYwiYTIL/0TDtdjm2Rd78Nmj05Z2LZuITs?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363103e8-9f42-4429-db8f-08da966681ac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:43.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtzK0/ETnchjo+BW46TdSQ3QSle+bO7EGr1TPU4/C9juX2f/2G7bYUf11WLfDfOIfZjhXgXVRh6rXZO2WuG5Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 25 ++++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 10 +++++---
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index f4cf12c743fe..4d0bdfef51b7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -455,6 +455,9 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 			  data, *dma);
 }
 
+void enetc_reset_ptcmsdur(struct enetc_hw *hw);
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c4a0e836d4f0..03275846f416 100644
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
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 29be8a1ecee1..a412f27bc4a4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -68,6 +68,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
 	if (!admin_conf->enable) {
 		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_reset_ptcmsdur(hw);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -123,10 +124,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 
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
-- 
2.34.1

