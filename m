Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B1269CAD8
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjBTMZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjBTMZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:25:35 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2071.outbound.protection.outlook.com [40.107.15.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DE31C592;
        Mon, 20 Feb 2023 04:25:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/EW7cZo+gn2Zrl/S4T1kRc2QnBcO9aUvpQ9Y7I9DyOwYRM3kw6/gHsj/eQAPmNNJ4fGnvyV/PR8g+AoFFbNv3R84N5GYDRQPc5jEWWyWwYtUkyUqnW8QnD3FiQB1Dvp+x3/SBcWc+ai88csFyJ5cYHtKheQi5cYKJ3yIzrh2N7cskhPQDcwjzVtoDsfpqa2wlFwdAABFxND8hOWgNFiIJPpmPZUI+VkiFmNErP8cOJw/LEVBe/SS0tBZs1HOG30Wo6WBdpWCSyX38LGohM+3bC+7iqKtT5/abUhuLRzwG4GypZbzfbiZonS4QT/1SQnLj9fVL1riKJ+OelNcXsH9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4ulBNbC+xUMiqkXZUQaW3mr3nHm+pzcba5ZADkMH18=;
 b=cIV71Js0nDeGlbSkVEQmJJCEBG33goWuP4cctaYU6eUUqNGcQSAPPBvFod41CgbzWIGarccqnbl7/oTa61QTOUU38vls30KHkgvUCoLhZ/T6zW3TgsVHCEPrroD/vbUQmYZ3a9LY1fudWDPKxB5EgTi6kIQaGgyF0Qn9YPA0XDKBm55MMFYLC2R+KxmxlrzNJfNjwWkRfoOeWg/vWN7s5qSe1Pa/xgiuN5z2NNvyIXaUyGTr+L6gojGTLav8qAuzL9yggboV4psDYB1IMdJkjNnh0kOCaZeMTgf3r0yYzieA4QvP89pthZzvIiIVgQ+3WNWWICoJFFiwfzDF7Nq8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4ulBNbC+xUMiqkXZUQaW3mr3nHm+pzcba5ZADkMH18=;
 b=QlkfB4B0XwJXMiRMMR5OGhvAFvyoAKY8Wh8N+MCaLyPopKZ4whFxhYxiBDSHl2bL5iP1F458NelKKbUeBHGU2nCOP+x1gZ2moeHZ/OmLn7K0fK6SNv8EWcEPnDoS5N/eHlUER1csMqK6k0fRGqEbU6htbMX06LjnRRBRo5Lp2wo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:17 +0000
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
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 09/13] net: enetc: rename "mqprio" to "qopt"
Date:   Mon, 20 Feb 2023 14:23:39 +0200
Message-Id: <20230220122343.1156614-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: ddea0066-5d33-404c-7627-08db133d62c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zuYMSARG4H9bcVtezGDToQRulaiZmjAUeIQt2/541/hHikMpeDWlfsBW462waR0XGL2HKj92vwg4RijRVt/SqY+MgG4nG9gziou32cWWzSOC96X6Thrcxiamzoq4uAsvrWXuKKfWt+wz4PQDuwWCFEhH90mVhvYMlJhaBZCIdwnnysLR8p0hcdmk8m2+c7/OjjsU/xNK1XfvlE2Dry5VT4raRHm6ur9M1HlVTwO1MiiuC/13BALboXqAgNnZSF/AV9w9ovD2FKE6frRp3J+kj6yfUhQE/E0hvIMWXxAvrSYodLnaW2ej1mvB9vEoUCeijQhqzFjIkrcb6QOAJWofLpPYAywR4EaWNDq5fgQ2S0IXka2UMJe7tFTNWJVWnbRYojivQlM57sHdC9/tS5htClKlFomFY5ve4xX9xiTlJEveW/QRfImc5Fc5hO1nlyDzAn9KpqJktMuEYG2dlbkEEHNj28e1fju/vmK6OFVtTAUeE1wTn2TGYEyR2EACRpGq1ij+DtZnnNHWO6c/A4M/+Ms91teNRwt8i5rdYC8eHRfwdc729tao2TNJID1HoDi6l1WJ7MK/Irvd3GPpKB8yHM8laytTv2PxfQYpg2aNnVLDhz5CIqzWdtHHTK3mxfT91VUwDUMvptVu/3xaUkIA1C1xgDw3y3hJdHqQFZajJXxDI/kGN20fKQMAH334F0hSXuEYkv9A/Id/c+9TMk1aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ib+P3AHHZCvhU+KQOmGiJWEZw4+2HeSPEkLSaR7hAJzBR6Ja4EnMpbiVJliB?=
 =?us-ascii?Q?qRhItCijMA7aqx2P1JY6XW1UawicyKx5u9unfC4W6VBM1E93kBs96W+bWJae?=
 =?us-ascii?Q?8LaXxUnvl6567uqmvTtzVyVIbJfj6eMzaU6xJOgsyOQPOgGG9EhqhLRhGJt/?=
 =?us-ascii?Q?bEpHGaCEgHG5yiogvrk7pIl1zikldRVsmukUm/kuWTUGj58Kmn6JP2m6+g6l?=
 =?us-ascii?Q?Gj86VtPp4s40j7GOXKkVnXNyLwcq1j+WZXmxJs8XzDaFroXo4WOaWZKdaiV4?=
 =?us-ascii?Q?LfR3Dxh5dgdIDJfTRpZSsyl48a1nHJDmifmqOTc1MnfG3UAugj0nTm2q8/Al?=
 =?us-ascii?Q?R3D6if1K1KfGgI+3ptjg6r9Xh7XMGUKaCIVcjrUTwm1ytevALxsG726pYW+o?=
 =?us-ascii?Q?EW0APYhaRwV/hZif8E0blLZkws7vPO125MC3TVITGTcyDthckgMSuUM96S8R?=
 =?us-ascii?Q?f0KsiWdEKqjSQsGjidyNtJzz8ifyMO8x+0PR0knSEe1j59mM0riALHrExlIj?=
 =?us-ascii?Q?/F1r2xqGNxDHOj82MTZj+goy3yM5/xff9Bs0Xre5uvsL9Pr38Th321rZFrXb?=
 =?us-ascii?Q?L2TXq+wfovfai8nFDaegD2xmGvN3fxzTVhzTVXZXrua0RZZIX9esdVOWZzCi?=
 =?us-ascii?Q?d7e+wJkvbmoQ/hF/kq+assHbtiH+7WdlJMXD5y+ZDj54oVPAHaoCuMZkWRHG?=
 =?us-ascii?Q?kNKy0BVHMNwo6a8Al8sb7CQHX5qBzRVd7K09PseVtLL1ipfcsl9djEDY2GdM?=
 =?us-ascii?Q?QEUTUBpki2j/GefCMYdxl2diVYdWqNoQlFj1IV8VuM64mcnszacyDtvPY+9z?=
 =?us-ascii?Q?EUhWT0LBJER6H0oVq3PgHuUqnL9s0HNeIZVwasYizvC7lAkNrY6KnQ2p09mX?=
 =?us-ascii?Q?xVC5fblLbFCU2qa7Kjw5CJrCwigdJn/VaPIcicZ4iavSQBNLnQVhYd+K/xIx?=
 =?us-ascii?Q?Px4HJ+Vn56Va8MlhhA3EHTg2xoSLihWGUFYBlMU2ePZyynNRc1WlaFKO350+?=
 =?us-ascii?Q?BcpkK3NuV3r6mqnRKEcaK3d8qD19fzHoRetdU2w8tIDdcLpmCUUof3iOuBff?=
 =?us-ascii?Q?cSMI0uH61P7/c/kbTtHufTdr3EcrQjUPKasKlu9brMlURuZMh+Kbf2sbpRmM?=
 =?us-ascii?Q?8eMTr/NEtpIEk46dYD7+g0ZAKKtFw9sE5dT4If/q/njmIhN8hSWOSOXrtp71?=
 =?us-ascii?Q?bapHTbVI/1AdXh7p39/+FJPZa5b0p0KZA5UlbhkLN5eMsyokzt7IPY3nVA+b?=
 =?us-ascii?Q?uPhaC1OlIcHeuoQUCfttxj97W/pzOgRqMYVswlW2cNA4sVXbXOC1xSFIdT7G?=
 =?us-ascii?Q?QK4PveqKatca+8FeGykyAlwkUWXWKUf5oL8knIenUCBNKUougi7BBOEJQO80?=
 =?us-ascii?Q?CaMzvSWgnxcsMNUDPSMJ0tCCQsKdRduKRduVzwKNQBbxbTXvzDI4SaUbLHbC?=
 =?us-ascii?Q?7crjxTYQ5BLdDGIomO1cDVcY+rxAwEKibcrs2D2r1Prt6Yomzl5vZ3pcmzEu?=
 =?us-ascii?Q?skUgf4i3vrVh0/dqs+LnVbeD9f0N3aC5XqDrKWvidKGykW2afwvmZ2hBIWmw?=
 =?us-ascii?Q?e17R5EpjpO/+a3dttyWTlJPQixDUYSRKbeJFHTu+g6ccXmjOeOQ0kcgLvqCY?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddea0066-5d33-404c-7627-08db133d62c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:17.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXCz2ivTRlIEi+4uecV9vPQ/pAvyHvkmYU5iqBUiYH4DpQNs6t6Gh2qWxPK4yeQGDS/BWcfnAM8ERZffFbUACw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To gain access to the larger encapsulating structure which has the type
tc_mqprio_qopt_offload, rename just the "qopt" field as "qopt".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v1->v3: none

 drivers/net/ethernet/freescale/enetc/enetc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 2fc712b24d12..e0207b01ddd6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2644,12 +2644,13 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
+	struct tc_mqprio_qopt_offload *mqprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
 	struct enetc_hw *hw = &priv->si->hw;
 	int num_stack_tx_queues = 0;
-	u8 num_tc = mqprio->num_tc;
 	struct enetc_bdr *tx_ring;
+	u8 num_tc = qopt->num_tc;
 	int offset, count;
 	int err, tc, q;
 
@@ -2663,8 +2664,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return err;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		offset = mqprio->offset[tc];
-		count = mqprio->count[tc];
+		offset = qopt->offset[tc];
+		count = qopt->count[tc];
 		num_stack_tx_queues += count;
 
 		err = netdev_set_tc_queue(ndev, tc, count, offset);
-- 
2.34.1

