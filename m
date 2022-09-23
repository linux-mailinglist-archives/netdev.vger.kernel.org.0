Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63755E7FE8
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiIWQeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiIWQd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:58 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E7613EEA1;
        Fri, 23 Sep 2022 09:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIScERnkdRU/Lx7MS4Dhpv56N/84hHiqcRF9/TFLVRugix/9b+SOdNwDZOfErY+WNH5WkPJ9UMs8acoBca7wOaXZKJtcRdaERSD8RouYABs86aeViTYOweCPERahHnAlJa8VDcXPXinFYnvGzFI5fvUg1wSBFXRdm6umPuqRj9Kb74OBbGSvvTY2UBQBDbttlWeDnG/66yvWOUv+Dqgw/DD7JDLuS8DKoVG0z+LT1ttbKcPclJHR1V3hVsktcNNcbUCwV3NjPAOiyrGk4d9wcYaBiGb/Mt6I56jaPWQc800gmqq8wDXIH+hoQ4ZR3W8C+vq0wLJsJ6AvOOKMvKQLbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjrRv+/2Z5PEvV78C1tgl9XWbataohtmabNPuk+XUnA=;
 b=W8mqhC7ElEJwuFQ0G9nUYux+Q3+o71Z07eOPHZr8EwbxZjXQC2FRts8r4oa1QtSehcE7r81/UaTCEqJXoho9tDbQDwrPixNWzp8oTa6oGbSmWJPDB65DNtRJWprFH9btJO/lDh5KfB472c4ATo8W3r4tYK5S742y/bUwfH/CuLxaZVE9ls5RM3EPqpc7gecih4yXSsBHf/qZLa2mPAzk7gcSWXVK4KuhVMsmwq6fpyhZOTzEkemCTmmx16PaI7ixwC2a8QltLXSxjjD/CPeXCe1KnaIIuYGNKjI4fZ4bgIUSlwp3+4WDQKT+uaBq0b2tE/55Nj0RpXYxFmW6RYdDkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjrRv+/2Z5PEvV78C1tgl9XWbataohtmabNPuk+XUnA=;
 b=j4DLP2LvybvzIsr3WDJXHtwuPM2nAQlf9Q19B6OoaOAymO7DZ+jHLac6+qcvcq8PGUnF4voaI7juGTMqSxQdrg0Itlo0wcIXyv+7OE9rNpjZNK2Syli6bbveeyQJxoSIz0PIwjLtgxh+0gbH+Ftb4R1isnb/LSaVd8Kv/f0qjI8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:56 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 12/12] net: enetc: offload per-tc max SDU from tc-taprio
Date:   Fri, 23 Sep 2022 19:33:10 +0300
Message-Id: <20220923163310.3192733-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: aa189bbe-fbbe-47ec-d6f9-08da9d8168c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ll5WYzOjUwHgL70dJLRg7+jgYkAKNKPX1NRI2DvSFUh/fCbCr0ZpAafG6hyn4Mfm4HjJxENtvXEX8PfKjzHnOYofOGZyqQwy3Sg5kBnjb8cp0UMgPWUq61tjK/AXYEMcAIep6hKkqp18VxozvV8fuC6BcQDb6XEnzGwVvsVQ2E2mJfvouTROud5ufjdozlvlMSYCcUVq7sNUzJ3JHs5R7POpAx0MAshP4hCBvoLeflhowNs3KU347IEb/E73rTUHYIp65s1yaL2iUhbwnOYkccUHU+rCnHo2bYiRWnO5YIaJclXZ+wmHqU3oT8sSDCpbklByS8U1uP5kDYxPkhEEdPdJwwmIbt0HjZiXaaZKA/4zpN2o2xaZPiworOTHEXjivoRRm2Au3sM6fppeuu/sTYHw+Qg/eE/cTRyuslb4onNFMPHxhfS+0lEDtCRw8nBgcu14kgVNAsXNCM0pYSc3Q/IkMJq3nmsvu/MrS+qYWmLjCUkKnp3q35E94wej0S6bsCuZSKUseySsCx4B5xN9Ua9PrvD5mukBmEVqBGbATvHTwAOfN8mUHVlNuTNMZC9Vn0I+O9AfgDdv6DQAyt0dt3DdDAl+TDjEUqvepChee4xgrqXUWs+a3nU3vJS/gW2EyeUZUMQZVM5kT/bNCwWa7FrlhDhoW5stwAAhZBtuswMcFkpWiLPxN+udVtlKxxdam2dgDsVuqIih4FGP0EUarcBhPsVxuGvh4u4w3XCxyh/8LabxbltK4cZjpDYxDwVOtIUWzJ/fPJEXh8fXB2EmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?biK1ccJf3aW+UHkhPMaVKCS0tloyblEYFiPOhYuF1lIEliIC3PUxrY4btMGh?=
 =?us-ascii?Q?nyan17wUWT3GAcyXOeHfTy92/fITlNZbdenVuowXF269/yvQzN4Ldmp12Igh?=
 =?us-ascii?Q?y4g+/P3rw9a6YJaw1ZeSKTTXbUcqJ0kwY2dGO+hqY6ersBN9MooKSuv7YQDg?=
 =?us-ascii?Q?XAMA+TvTa5ViXPI4D+IvZCXZz6qLsGACbQWOX5+1gaQDkY0ACB0BLSmxICvI?=
 =?us-ascii?Q?wSTEl+MAgrBTEgNpRzhHQAJODhhYEo60uno2PPD5tLm58h3qhfZjB6bxsXTh?=
 =?us-ascii?Q?rNL/oHf5hzjqPpedhYjztJSGTPvYgF2bNiA0P92tbtNjW7ZoXEbCsSn2EFBZ?=
 =?us-ascii?Q?SJf/tWzy3lGJnsh0BI1fEubEq9ijgsrC/2uDQSYKQhY/PXcUyJuoT0RTvD5s?=
 =?us-ascii?Q?CMkyfir2hWXZYIpfgFHRVflx4tN8VEbJHkQQnn8COvtndCcJhasmZeKw7TI5?=
 =?us-ascii?Q?wBNjUeUbV46QvCIvnj5qkl0Wz+d+Pdb+7wmjvR+CXdD1VXxcd+9RsNDLHyn4?=
 =?us-ascii?Q?9zI/A9UGbJO9uckc4KXLuY0Ket3ix1v+FDFpjifw2yXE3Wp1Aj+sbIREEHEM?=
 =?us-ascii?Q?7t69pTxIoUjSCrpBG0g7W90XYvKXt/we8wWGG7H7Uo/AZReXCB/XAUFSQLu5?=
 =?us-ascii?Q?Jx2Hi7ff8gNnTrR1qG/NEypDRXH4o1jm5stfWPUtJE6/3N7hLkZagcOZk5DI?=
 =?us-ascii?Q?lhZE0IUsE3gnv0SEh/CxnL5Luk63swJf8EW8c/J0995nZd3v0jfpslQUGFee?=
 =?us-ascii?Q?bmavZ4Ac8wV8EKpp32Z4xvPh8bnDmgQruTCtROEi+DvUUE9PzSKjejsYHk+M?=
 =?us-ascii?Q?VfF+e62YiGCmDs8r3wc73F5bozJ7tjwYse+bhYvoBfGSQYdYojhVfyGAWJ+B?=
 =?us-ascii?Q?AlohLmXTlDq/DPQF4Er6k2OITg8prZUNzyiYuTxo1ekK8btGE+t1xLqITytf?=
 =?us-ascii?Q?P1lsqdYTyPtm61s9IzQHF/WdJl9qso6zJY0AP+wguTIl6Zt9RAbDd9pj70ZK?=
 =?us-ascii?Q?ETP7MYNA7yzDcol2nHsPkFzK+OUXPiWYQZzQAyhoLREuTJxuJdGzQztHpCy2?=
 =?us-ascii?Q?pqOZGvkDsyyeVBizqcTGdmR5DxJI2j0uYCSmORfU8XmQiskXWMGf1eC5szT2?=
 =?us-ascii?Q?5ixQZzbGwbDWIiWqsuCK+TWXALWMyhox0lVDbwW1zZaJoCT8B2yMmvWzzkAY?=
 =?us-ascii?Q?VieWbfTxrGw698WssMSIEypuP6utIFviBU2/p5xEgkGIKqQwRQ7vYYjpjEI9?=
 =?us-ascii?Q?Kxf87AeWh85ABn4Ksx39bw47FOmzjXrC3q252ClmrXcO/k0UJdjPitO1CJXD?=
 =?us-ascii?Q?7b3svgMVJ5pVVlbKrMb2X/jtcuMzlPDj7HttQgOS3c9RoOGYFPvVgAVIyetH?=
 =?us-ascii?Q?vewDj1RessZEDH5Pd2h+nJCRR2RdlypGm5YxdJ0xkj7b4DDBaQgof88BQDYL?=
 =?us-ascii?Q?Gg6OKD+Rd900U/wj2Z+Wr971FbrqOsXaDpx1GkGMqU2aZj3sQ2fCwIbOPadY?=
 =?us-ascii?Q?9RtnGnVjVjPsoDnfAStoev8/LEu1dLeJbs35FXpIHgi20C+1G6Qqg+uKQhuv?=
 =?us-ascii?Q?YTqbtr+DZo6nZblh58eJRD/DTAW7WPgYbZeOml8Yne63iaz0araaoWai5I6S?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa189bbe-fbbe-47ec-d6f9-08da9d8168c5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:56.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZplryeaEA6jeQhh7LJNuuse8KPOVu8h5EzUJpDrGPPDWmirS/QckNPY8McYoL/YkDn91JVcpcp5B6exwAIf7Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
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

 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 25 ++++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 10 +++++---
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 748677b2ce1f..d7edc04f4bfc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -453,6 +453,9 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 			  data, *dma);
 }
 
+void enetc_reset_ptcmsdur(struct enetc_hw *hw);
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bb7750222691..de39d9ba7534 100644
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
index ee28cb62afe8..f89623792916 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -67,6 +67,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
 		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
+		enetc_reset_ptcmsdur(hw);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -122,10 +123,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 
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

