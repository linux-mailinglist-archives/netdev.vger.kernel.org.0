Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8856E67DA8F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjA0ARO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjA0ARK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:10 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6174489
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:16:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETubSIDAAAnZPFoEwq+cpwT4DQuTbbWFf5X8OU+xz+U0nfmR2FjJu8RmXYeH8IqdNJmZYjPOHZ/q+UY1rjY3u8A1FjooCkWZ8mVSxqNpM/mhVaQhkvm0L6dkKfdAgO7b8tJvL7u+//JcANROvJ+xOkcgdp0XXf6Mou9sCAVpXIKTAA3AHm8Q0dc5BZqa2NTlYOu1y9k4o0tYTiHEVrkm9EMqB0/yM38BGqB9/FgFYRQxWO6/76qhe4shXeGNkr0lRmx8dCpCtOqaq974RHe439+d+Zxtw52zVv/om6GWSfPGlAeqAD5+iBcy+BB2dbswBAQ/Yz5tuNiGYp/A5LLWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obnMq2uxD0v24CW8wDuB4BxLTJsQMzmD4R2gpz2+0Ig=;
 b=D3Y66HuPlu8+xZTtvvMBj1Z1pJngbManXf03b5zYDOMzOSAhtciYTYvnyJfmmHKfwVRwxLgyo2WtybGK4PiFuaBY8Fsbeto0kiusWLxL1hrHY4V9n6R/I7gppcbw3C7osxorgyh4LVO5gNHFV1ZLHR2dDmhmKqup14Kyk+yL4FzZUFEEiWo6eGJ2DK5Aa4420n8MsWsbS6+B5XfyBKy3OuJyxRoZt2HsPuQYsrT7CSIsMHpP+S6m+PKpNW7mKatkYUgCqig1bm8y9Prrjr7jSPMXEUvitt+FayrXmoPLcXdOsfNw4O7/G2FaKT+YNRSWGMUlOonNxj0CQEQf72N3Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obnMq2uxD0v24CW8wDuB4BxLTJsQMzmD4R2gpz2+0Ig=;
 b=GsCPv7bRT3stT0t7ZvJgv0kU0olFh+cOAWcHsOvbvDYleCvSMZEgj21IDispd4V4ssEaCJ7QM5BToE1SW8hyFhhQrSOD9KffXfohImmBGuXjYelTyAQj74DOq8QZGzJ/W4bWcPHMrAegCBRzeWIU+aoAGVWghqr9tinnbmfKsr0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:15:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:15:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 01/15] net: enetc: simplify enetc_num_stack_tx_queues()
Date:   Fri, 27 Jan 2023 02:15:02 +0200
Message-Id: <20230127001516.592984-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 676d1fe6-01a9-4241-4de3-08dafffba9d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2H17+qztM5iNSSiMvEE0wbgl7QKIi5vsBaevkADWTZ+MNz5INwXDYljgbOXTl7G1FgPn+LDlBTuqk81n+VfjDlfB3a6yw1IVPwM3GX87rTWDWoXAzV6sL3zZWzpWl1Fldx8LSZRWis3aeHp0836wghJwIFccsDokydwmwZ9IrJATZLrG+EAUSBQxGEfRh7gDT49aZjr5Gpf/L64UlupcLENMfpfCi9MbqlqyfbWA1Ft4K4WbV54MFwEWZoqCF43VSNbF0MMAKvqCKycow7y6SMJmyuQHazzcYea2th5hSeBp34TYKYmdqLFQ7AgCZCf/sg/H9O5vjUhfhcIHRrK6Ih7TQQ/dO3sZiB/j3H0K+7+112GlVmLgzYdSvjum4VpvU3PqSo1EKOA/IBXBfTpopvixAjE+6cYpBd+KrcjnHKUlvFx0wkm2ugjXKMVAwBful6zpaCV7OWr6Z2ou1ars6VlGBBcWnn0k1QC967w18qsYmSLmKmNpwdEQm+p3h/bevdCdDpLbaSAnSrGsVq6vu0f07DzUNahjfTNjX0Ar4+vcCbaNma5onZDWHv5dsX1PRAPOexrgX3vDHWRmbB6ZE/GJunkG9jbK5rpcmU2Ls+jJ9LwM3fd1TldMuRjnbUBWi9YDK6lk2RaIGkbfmRUMqWL/Kj1fKyW+n8WPaY6T8+Uz/dE05zcAuGsYyvmnaDuQvWuUJqUjZ9Hs1q35nWi1HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vnd909Xqcd05LY1y+lpZhpR3gwUDrLcL/kmFb3UHmk+FSB7ZE9xhLb/vaCBm?=
 =?us-ascii?Q?sV1/JdI6qNTNO+fiIeOBKSFfQHFB8NcRh+Mg7h9AHKFyf0ZA1sJAX/gRk65G?=
 =?us-ascii?Q?rDr5DRavZ7b2kgqq8Bm92dpOMPNklykRDWMImaORKyb8E8SlcxUZiRWpaM5g?=
 =?us-ascii?Q?1VP7aXYKpAbfhX0BzUV7U8J8KOFhasoqFm/e/7AGQsth7gpkk+kLDDe3wc+w?=
 =?us-ascii?Q?QTaDQ+dDA5N+Wx4Qx11W1u/PfXve5sckJC62qiyUbJ8E2LTale6uNmz8incf?=
 =?us-ascii?Q?gxZPkvRwXFrmitBW9ixa1DNWCJk1Es/YtL0DtM1SE3N3Dk2teDbsiWHIsQaf?=
 =?us-ascii?Q?FLFFclKqRVayOVxjjZ9DiH5GgW9YqOdEQqc4rOXhWwb/CrLD+GJZOy8lZtVx?=
 =?us-ascii?Q?2Ei6QUvyrZwcTyDgz7m65vm1ghAV9GgjkEIELLY8VINtI0haPFnqlac2zMIb?=
 =?us-ascii?Q?mlz4joQ5ZmCj1oPVII+9CwX7xGOsAmjXNgw/x1O7FSo6Nk5n9m/fu6hkuF2Z?=
 =?us-ascii?Q?BMMrSM4ix6JaIduFlHQpGlfTRxPJ/5NYrOJb7NHE5TbIePj5I6SqAo9yelMJ?=
 =?us-ascii?Q?KGpoKO57Cc2kR0C75OjdxmCfh5HmxASG2FygEdw3MkHv2F2Vtn7qivC3FfAi?=
 =?us-ascii?Q?2ywOsTbMKd3mvWexmAFLwQI+MWdYy3V4bOhpTeFogsTOxdzGZrRuGsb7I2B0?=
 =?us-ascii?Q?cSKq6zoMJdgyKZ5+uiyFmQgDoMhOnZjBBXQ3HkOGDF2pJ4yA92OAI+mlC0sZ?=
 =?us-ascii?Q?HC0YjLiuuS2JFX6SVp1CyjXZjB2TeSXfru5L3TVCjiCoqI7qkTWobMIRUGiX?=
 =?us-ascii?Q?NMANLg9ypcPfMx/30ES0kVnFNISeD5h4qjsEde7WwMhanhZsHz5onKfFVG+L?=
 =?us-ascii?Q?70ybXN84ZlX4MllnKPAMY4J+2awGzO5zIl4arjgvH9o2oSkYck+T5bBBoGQu?=
 =?us-ascii?Q?jBMunRn2ZFfEcUc+KswSs+RKdQCMSbmgr/llAW+sUKUvc/FI/n9Gz2jcWjQW?=
 =?us-ascii?Q?ORqMzjTfYFGD4XKFL+TTbSF59P5xhwQowhMYm4i6gYMv1e8ylM6Za89DHZXm?=
 =?us-ascii?Q?IS8+t2WDXY/GnA4D00xXrxTKQl34Ef6NZ74lRi8Q25u1FadYcsUYLqMDKyqP?=
 =?us-ascii?Q?LX481Y8GhHJKqw/lSRDBNks0lXXzilv+kFuYotc5FFI8Z34yDJqtXU6QWZgG?=
 =?us-ascii?Q?lf5PExQRFQs/v/i5r/NMqYpRsJYYEe4Kg38AzL2ohogA2+0LqxAYvhXFxIc+?=
 =?us-ascii?Q?yuKZcHqLiCHtzZO+NozX7XJzZ8nm0wDEpAnxH8Nb3tumvAaX/MWzkUrVhHtT?=
 =?us-ascii?Q?Js8x51syrZU36yt6UESaD+KhF9+6XLlYO/A2wrCe5Kotj6uXcVXrOinJUei9?=
 =?us-ascii?Q?9XdS7GFqBkLIQfXj75U/AtBJdoNrRmh4pVG3QtKsnlv4HDbW0ZWeYMA8mMwo?=
 =?us-ascii?Q?dIIQKiaxkvkPaQW6lJkxzSOUlV0+1X1oJjyJAgAj0fhAJwQkH+czbmsAl39N?=
 =?us-ascii?Q?CUv3LShAxIOGvWPZO7vDeVU39AzL24nafB3CzWzw8bkLtlndX0MXzg5OdPEM?=
 =?us-ascii?Q?JgxcPhpnxrSk5TSR/Wa5NCmpmTDqzc+Hctax+ck2urSF6ve/9G9B1mQQZZW7?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676d1fe6-01a9-4241-4de3-08dafffba9d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:15:57.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rh3MNjvZwcH1DB8/8if3uUu9SAnS/JXa4PSV3hjMd7JU1ysyjMMdbMN+l6GjE44NK/s1Xv3tzEoWYnSQSBdHfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We keep a pointer to the xdp_prog in the private netdev structure as
well; what's replicated per RX ring is done so just for more convenient
access from the NAPI poll procedure.

Simplify enetc_num_stack_tx_queues() by looking at priv->xdp_prog rather
than iterating through the information replicated per RX ring.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 159ae740ba3c..3a80f259b17e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -28,11 +28,9 @@ EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
-	int i;
 
-	for (i = 0; i < priv->num_rx_rings; i++)
-		if (priv->rx_ring[i]->xdp.prog)
-			return num_tx_rings - num_possible_cpus();
+	if (priv->xdp_prog)
+		return num_tx_rings - num_possible_cpus();
 
 	return num_tx_rings;
 }
-- 
2.34.1

