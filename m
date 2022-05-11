Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5FE523043
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiEKKHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241155AbiEKKHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:07:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F8E3527B
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7SnDkVwTxzZXmseHmv/iYKwg6C6qNzJqfFRp6XXNpyOWcXo42TjiU0t6XlDCXsERVkzshS7P1ra2v+mlvK/otHs+i1hAgz/yobgTkmP9XV9vrKII7EwjThsj2LKVgNXR3krrEtnlDXRhe3i+of+W+LIEKmF+C1oji1x4w/On9xWtYfRVMtNnK1IQVeqJeoVy6n5F7nrXkUZ6aLJQZ/sjcUkOKmdxtGdW5kidO4mRCd+LLvVa/lL84I2oykKsgElIrVVQi/gOHcAc0adGhhY4Npp7KfL5Ju/dqtNh2tjRGnIDcTXBCau2A9Rsc3058yd5tFOYDCkWZlwwOMV2Aa4kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSrTztfdX/qmdLSB2qVyXUKoufD/BuUtlcer+0DQ38k=;
 b=XYvgXZJuUSXfLmX9mbzEKudOkPEmBHWSDzHtYOsOJjRTFhLYzzrBAMr3ieSOORGmOZkAD3PBEOA7TlsGuj8iYlH0CtPoN/xl/o5LhSctx+hoyl4rIxcUwAIa9LygwsiYXZ6xjHLEw5ZczbwVzEzwWvVIwBifVv7W1UZFlpB7nFJhMCjFVDAvTPmFpgv9qwIzt0QXQ+MCw/IFsy9Ws/nKU0/Zxhttl6tJVnfKEu+KQcj61oumfEsB4JUVMY6B+llIpIHaNaPi6NH00h1OpNx55mApjUTpoL2LDs0S6SpOWcDDcA090On8hGp6pS+bFrWsaiPt56/j0HUAFXWsyB+pww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSrTztfdX/qmdLSB2qVyXUKoufD/BuUtlcer+0DQ38k=;
 b=AGEJOPDedYbfD28nHhR6YRdkjmIe4K/vzwCmMdcZu/6Gkj7zY8fdsoyFryTbA9V7dgi118SBnbS1J0bgPyQx8GPx8dvhhPeUxkKk7Cy9OHG1RgAnYzPEwINSvjjAHu52TZWeyhOaHhMqyujwX4zK3UAc4vbEl7CT4A5WQCxnDHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4501.eurprd04.prod.outlook.com (2603:10a6:20b:23::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 10:06:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:06:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/3] net: mscc: ocelot: minimize holes in struct ocelot_port
Date:   Wed, 11 May 2022 13:06:36 +0300
Message-Id: <20220511100637.568950-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511100637.568950-1-vladimir.oltean@nxp.com>
References: <20220511100637.568950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0005.eurprd08.prod.outlook.com
 (2603:10a6:803:104::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66da0423-60d9-4815-fc7f-08da3335f716
X-MS-TrafficTypeDiagnostic: AM6PR04MB4501:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4501DDF5C049F8B7FB90140EE0C89@AM6PR04MB4501.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ralAWwzehNkEtchW7q5vk0Hk5IRG5QQ5svyx34+U2G4ABRoYps2UUY39b47q0/pDrx15tzh7TipAQiEeKrmr4zlqQrKIBL78IuhHv8W0WFYHwKk/iRlMAlZEHe7ewfVpkMGPgn4f5uS/Isyf8g16zmpyCgomY+cbpaGnN8JNeKKxL5bEqwq6EWLG1HrYCMMlLQwHqv8pA3ka67UJfQ8J7F4WcfX4Aulm/Kj01qtDXForxTrcmviKKBV0Bz60kf25bEycfZHAAJBl1I/CG+9NjFQtEA/52OB+Vm5sv1MYKCEDMrJekT4IzXAYFUirqKjBiYcr8/ofU7EKdj0rjueMqMIY/9xiyn5Gsh9zDzYpVKyTCz/3zV0E4xlyT6xzbaJeWofFg+pxeqF9sT+2JqKkMaoKmw2uXFqeebib1qut3SU3KDEJlmKQJlP50xkFiwh/MzQkZbaPwhPm2qC2TxRUIa7Y3GJI/rL3CsREC/gT45ptnb2iv5S0YelGrWZOzqshHm04k/MfFOWbLQuC+ENEWcZWdVQV02vL8ImrMMBtbbceGFfPSqB9BMOj0xi2hNZ4KJt62HVWUqJtt/5heprnbXlAmynkCw74d8MH7LPxbAkgTuAMHYJHcSm0lAieWpkF9xQ5vpgv1OjelJwI6+QEyZUPDR9kZvtJsxm5ye0klM6CHGyrm/EFVuYg8Nk+OfiFDtHGcZ4BqSPWpdhXWTmQ6r1GblHiDJI0RnACRdrpBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(1076003)(508600001)(38350700002)(83380400001)(6916009)(54906003)(316002)(186003)(7416002)(36756003)(52116002)(4326008)(6666004)(6506007)(8676002)(6512007)(2906002)(66556008)(66476007)(44832011)(26005)(2616005)(66946007)(5660300002)(86362001)(8936002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K51kpp4/Q4hXLLrKaLq9na1n3KvS5HPukLekc5fsxvKSGJBC5l87EcyNcNuT?=
 =?us-ascii?Q?j9t86vI99DzWAmA9OfVTBnFt6kF4Xu2e/wdfm5SLDt8bYtr92VZJzFHUWiU8?=
 =?us-ascii?Q?briA+vc1oSq1RnStxPVVylNLfKEixII5rOo4ce+EIuxy5IFctCUVyHNa1+Ao?=
 =?us-ascii?Q?m9/2Kj4NmKwnCjMwzuOhf54X8bNaIvfbWtsCk0SY5CUQ402PSKqCwUeCAQFF?=
 =?us-ascii?Q?eYrQI/qU+/VjY0jg/6AwVDbpE4940Aq/mln6gIx8jLMe+tVzV10CPuMEdb6d?=
 =?us-ascii?Q?YfinnzMGCnwDMWXtgdGc+5eY1uW4lxI6bDo313/dcMUyJpSeFaQPYpwhnCfp?=
 =?us-ascii?Q?TUydHytT1i2y8Sm2fvxAmi2VRt8SRC2AtZVL4ZX+/FAgolG9/LLr9RJP1aFs?=
 =?us-ascii?Q?8UBEg7VachSvbvYQmN50fskv8YNYykgjgwSyZunng8GYMYawr6K7VAZigKRP?=
 =?us-ascii?Q?0KWBAc1Emb67SJil8vvfvrZDd3SNn3jeSwTy5fwajBOYgM1M4ZmdUx/opxEn?=
 =?us-ascii?Q?i3iT7TCJayP2URyqOlKnVTQM1vS1AzwNap4H99p1OdyFkctajcazMHsW1/Jq?=
 =?us-ascii?Q?iYZ69pIdcHjcy5AewvGhRRyEwcSzpJseJNpRV1QXn0RdePN4JdD9CctmFpdj?=
 =?us-ascii?Q?oepDXXbCKQSlYsleU+vL3TGFoQxEht/pd0x92F9gk7goLSAwpKfBHDKN/tj6?=
 =?us-ascii?Q?7QHYq2gk7VrpyE6o3Cnt2z+lyDWoB/cfyJsaseZPs3d+QgC7R0m6o1exptiQ?=
 =?us-ascii?Q?7tlwtChqSgPYvMZVgOFD1pJBk2sLV3CAjMqGgHEx8Bc4JIrFcdnBQR1UFVg0?=
 =?us-ascii?Q?YGIwR4AwLLA9bnuj+kCJZPtdXMvW52Ii98GKCYzts3Z6wQWecVyGBbZZpgtJ?=
 =?us-ascii?Q?YcUfw1np9aycNeSnec6wHIS0ICmCG7roAv6MrpyZjTbEC5ikPwp9yyc7fO5s?=
 =?us-ascii?Q?R6L6N72bcdLYK9PuVJW/UTauaMjFKd96wUCU7oxkFWM6SyVyCLmy3q2QRZrU?=
 =?us-ascii?Q?KRNL7S29Gf1PvQ8KxHH8vk042KY7JeLws1vIpZk1Q1MaQTWLrhk2xbgMyEjS?=
 =?us-ascii?Q?HYDRnPiyP02WMEdC1o/BnN3QkoFrB/HGd1wk5ZiCQ3KxS3GpaI9zlDRghXgC?=
 =?us-ascii?Q?6LwVxVKrSf5JwlrQgVpvzGt3GH0LxCt1d6lhyGSwMDtyMDrPsA4SjKWTpfTj?=
 =?us-ascii?Q?x2PZOcaHzGlWVEEI5XB/SQqChzs+g4o8qnkE3BM21hy7y7/w1FK/0Kr59pP/?=
 =?us-ascii?Q?eLU6In9i2JTOn8Tfj/tk3wiEuXP37P7SttOLNeRoGOI91WHH76lrjwdhfEF6?=
 =?us-ascii?Q?/xbscNW6zB0fN4tjE4WHO9sNvX6qoEGTsoiXcAZaZMigf+eKsduQJT/WDw00?=
 =?us-ascii?Q?5aEBTg9KOBNBCWH0j/Z4KOmO9Khs+X1F+7MZLiBoTm1/J5Dq7LlS2c1n3XE/?=
 =?us-ascii?Q?N2ed29L4/ORuqig0NgVBZ2b23x924KTM7S7P5r15q75eroJKb+jdnFi9XG/0?=
 =?us-ascii?Q?Fd+5g75ZR2TMqaxC+t4ynpPoSavEh4MlWVeQNv+qBpRCDhAfKFI7ZFYVm9CL?=
 =?us-ascii?Q?L2R3gIDLfRTwu8+nzhihy6exu29STJpbjLtt++HD54eNMr1lo5khDZO1r0uM?=
 =?us-ascii?Q?GVCerU2CmHdYnijSMuWreuS+IKmNlLGlOP6BHpeV/y3VlvkWbs/werC2BuYn?=
 =?us-ascii?Q?NqG5ndvOMbRUMwvHquStqJKtu+iGoBOYA5J9NSXn6WjLvRZYuvZZi4LVG8i7?=
 =?us-ascii?Q?VZJolKqPs8pFWbPpxbMNngmMBHFwNRM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66da0423-60d9-4815-fc7f-08da3335f716
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 10:06:49.9670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mm1pfbJkCWObpKWiF66EEm7V5HWFqlUyQG/3zHqnAfyNVRVutBBuDPpG6VoVn9mt5LjIZw+F7bSq7Jtb2G1BIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder members of struct ocelot_port to eliminate holes and reduce
structure size. Pahole says:

Before:

struct ocelot_port {
        struct ocelot *            ocelot;               /*     0     8 */
        struct regmap *            target;               /*     8     8 */
        bool                       vlan_aware;           /*    16     1 */

        /* XXX 7 bytes hole, try to pack */

        const struct ocelot_bridge_vlan  * pvid_vlan;    /*    24     8 */
        unsigned int               ptp_skbs_in_flight;   /*    32     4 */
        u8                         ptp_cmd;              /*    36     1 */

        /* XXX 3 bytes hole, try to pack */

        struct sk_buff_head        tx_skbs;              /*    40    96 */
        /* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
        u8                         ts_id;                /*   136     1 */

        /* XXX 3 bytes hole, try to pack */

        phy_interface_t            phy_mode;             /*   140     4 */
        bool                       is_dsa_8021q_cpu;     /*   144     1 */
        bool                       learn_ena;            /*   145     1 */

        /* XXX 6 bytes hole, try to pack */

        struct net_device *        bond;                 /*   152     8 */
        bool                       lag_tx_active;        /*   160     1 */

        /* XXX 1 byte hole, try to pack */

        u16                        mrp_ring_id;          /*   162     2 */

        /* XXX 4 bytes hole, try to pack */

        struct net_device *        bridge;               /*   168     8 */
        int                        bridge_num;           /*   176     4 */
        u8                         stp_state;            /*   180     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        speed;                /*   184     4 */

        /* size: 192, cachelines: 3, members: 18 */
        /* sum members: 161, holes: 7, sum holes: 27 */
        /* padding: 4 */
};

After:

struct ocelot_port {
        struct ocelot *            ocelot;               /*     0     8 */
        struct regmap *            target;               /*     8     8 */
        struct net_device *        bond;                 /*    16     8 */
        struct net_device *        bridge;               /*    24     8 */
        const struct ocelot_bridge_vlan  * pvid_vlan;    /*    32     8 */
        phy_interface_t            phy_mode;             /*    40     4 */
        unsigned int               ptp_skbs_in_flight;   /*    44     4 */
        struct sk_buff_head        tx_skbs;              /*    48    96 */
        /* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
        u16                        mrp_ring_id;          /*   144     2 */
        u8                         ptp_cmd;              /*   146     1 */
        u8                         ts_id;                /*   147     1 */
        u8                         stp_state;            /*   148     1 */
        bool                       vlan_aware;           /*   149     1 */
        bool                       is_dsa_8021q_cpu;     /*   150     1 */
        bool                       learn_ena;            /*   151     1 */
        bool                       lag_tx_active;        /*   152     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        bridge_num;           /*   156     4 */
        int                        speed;                /*   160     4 */

        /* size: 168, cachelines: 3, members: 18 */
        /* sum members: 161, holes: 1, sum holes: 3 */
        /* padding: 4 */
        /* last cacheline: 40 bytes */
};

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/soc/mscc/ocelot.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 919be1989c7c..904c15ca145e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -659,28 +659,30 @@ struct ocelot_port {
 
 	struct regmap			*target;
 
-	bool				vlan_aware;
+	struct net_device		*bond;
+	struct net_device		*bridge;
+
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	phy_interface_t			phy_mode;
+
 	unsigned int			ptp_skbs_in_flight;
-	u8				ptp_cmd;
 	struct sk_buff_head		tx_skbs;
-	u8				ts_id;
 
-	phy_interface_t			phy_mode;
+	u16				mrp_ring_id;
 
+	u8				ptp_cmd;
+	u8				ts_id;
+
+	u8				stp_state;
+	bool				vlan_aware;
 	bool				is_dsa_8021q_cpu;
 	bool				learn_ena;
 
-	struct net_device		*bond;
 	bool				lag_tx_active;
 
-	u16				mrp_ring_id;
-
-	struct net_device		*bridge;
 	int				bridge_num;
-	u8				stp_state;
 
 	int				speed;
 };
-- 
2.25.1

