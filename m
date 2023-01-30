Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0176817A2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbjA3Rcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbjA3Rcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:31 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842EE360BE
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzJbzbsSQ/VcySzrAlYUhTGtsDKtdn31ddPAqttU4VpI6habNAxdfqolXHrg2uTyFRuj51nyoCjf/ktFPK3fEjo2/ZsBnAJridpRsF4v+UYCkfKpcEnI5/01BjDN+P2rGQQaoD/RUmaEYMPns/jYmkW25jkPd6+Xu99p+p6X3MgjtArsGXAghi4dr3nnuGeMuDhCb9UmJGyT9wIgK1ZAI8LAcevvvwDJ/lGn9gAyRxNugL1PN0VdyLrF8FcAgootI4Vso1gMfJBmEiI0rBndAgyYgeFKX2q0zRqvX6o+o5DLyMPbg7p4NlRlXhKrMiIbNUwwScepciCNXltjUJr+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iErz2KrN/i+FCnnm9dYaiS57lG0jlqdGKlvRX2/9Egc=;
 b=kGYmTjwZKFzmo3qmmQPQWRQyCabCDExXBILbt1xMlR6kvBxFfjchGO94w6yL2wUhOv3RGgP16MvjOcS8mvyN3MjVjMp9wWhKVL02PCwipVjEDx+zHTNKunciVNYP90fAecKf8SxYMo4WLSSzsj2vGOWess60fqgV1EpXEgJ272dHxEjBXyhIdZH1eHE6CS8wjcNt/nZPgTs9VPRQAJe5p5UZ8UmReXdAUEWwgvKrJLJNFO67Mxj7jEONrjENYejDIIb4oRE/NInDaEkUgMhEccwDtqW/RCqd7HN9X6asEbLb9gyfq61oNIBKEU98MEhSBrTmooIIgojl7BhSn6briA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iErz2KrN/i+FCnnm9dYaiS57lG0jlqdGKlvRX2/9Egc=;
 b=okYE4aEW6D+OutuUcShAL6NcDKDGLOzDcX3dRRnEeXDnGmwyB8zKiA+xezej2xGlcLS/QRbFq6g3IIU/pqJkBoqyCWiMhg+1CvS3IQdLvAsIgP1fEC5//z9jCRihe2FP17VXAJPoygBrBzB764KgiwBOaEN+bBMAOOJso5pFVno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:09 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:09 +0000
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
Subject: [PATCH v4 net-next 02/15] net: enetc: allow the enetc_reconfigure() callback to fail
Date:   Mon, 30 Jan 2023 19:31:32 +0200
Message-Id: <20230130173145.475943-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f975e1-3fa2-494d-4afc-08db02e7e94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: em6qA8UywVs6kTKxIBXLfg9FVbb6xUjusvU2ZjjP2PWkF0sl0oDIw9FKXtbENHORvWJE7lPywq5obSknWWA+7ScWRvkgRdlHRF2hxzlxjf3w+Rc7bY2GFTPUMIzCCJtbXUGS6OtXnfDom4FAQzqubhsHAFOEKxXkf7NbAfV34Iaw4XcaJH4seu0toJUv0Nzi6sRSMu92C3k6uzsfO3GsOHJ6pMRLWVA3109KfByjmEWtG9E1X7oaYhFssMkDk46xJgHXYVUcLORgWUr5d7IHyr5aS12oDdKYOemnPektYu4qwkmJ9qGtM+rA3/Xq5dLMVLnIsRn/gV5loKb1KBbQlPtu2aZ70azcK/9jv7ntTWGbsqFDXubJAFgrE9P4AaU+5MikcNr5aoADU6vVREQl5rnBY1YMP0X6b+ekGP6Rmigu4KPX49UmzCnq5nDtAOpyUHXPUKzVUhDixAjzYaDUfLmd5O9JIc5snLBuLw+1TAxUvsLXvVu887CAl40U14QIzk7DWBK6MOwZqvoRkQxeHoQDgtPBgsckH26CeFCKNA0O0mbdVgi5b7Xb/zC7qmpW04godH5RBFLbsd3Mxo45VKgR51sSq9m51H88eQygZURk1Q/pjaiYeoHqwWIn8B0g5S4dMc54OeW7aagNObdrNJir2ii7vtOXRh2xG50rEmUG7+hfpxO0nvqBphFqieSeFSRY1p9H1PBjYBNj54W6tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rGKUAqKQsdFD5xGiYkLhmRWrKCo5dFyjo9B9/fxAlH7VY2E3BMGBnPhdRtEX?=
 =?us-ascii?Q?TcegnYMfhTBsreGZ7QBzw+Gghq5+LNZpBPcYckyl645KYo/YSHIzqNn4blpd?=
 =?us-ascii?Q?ATDlRHbgrTt8p1poZ5O15adJOJ9+iWt7kjOZ3sa9i0POe96ioGoI+qGmnZIu?=
 =?us-ascii?Q?n1Jh57e61jVow0sBLEtzkwIJ5nKeJeF/9/9DyKPWTay3F7IDDPyTPHXNQ5HX?=
 =?us-ascii?Q?jcUW0XY39VeS/eYg6zN9rt5uxT//Qd3EwIoiGIiSmvSjPtNopQpaMA8WXzvX?=
 =?us-ascii?Q?KCLThhyaY/bnQbdDYSSLREECSbncVidas1lx25Z2C1cP77dF5X8HQrCklMaO?=
 =?us-ascii?Q?tma64wafPPswJk/3z1m+JfhG5PFqY+bGJv+Id4niylA6KdeVJsE62EoscQFJ?=
 =?us-ascii?Q?OUgD0AlEqE/Iw7soRCBDnYf0OmBArp+nx2p9jhxXaZUu/fCILKqiWYrbUYBu?=
 =?us-ascii?Q?LtD85rMyIe1JY9vZYN1Gjdym86JnAVyt51sbqpvr4EtxguAVhzD8jwibLXTZ?=
 =?us-ascii?Q?GiHrJUNW69pSDcJ1xYOWP5d2PBqQoxoIaA2dPtCoZU0BWlY4mKzujKLfY9wv?=
 =?us-ascii?Q?OWYelYwFq4d2hsfY9UlJI3HEgUycNZZADIJhzLnOKoVk6FipjXlX1AjiHncR?=
 =?us-ascii?Q?V0JEp27fFfwidxHDBe07xbd0Nj2piVaapxq/0nKmbUIMam68+Zw+R30Lj3Pw?=
 =?us-ascii?Q?S6ROFMu7eqemQ1bAt4esm+HjiMPxSoRFP+5p5LiErqjVvffFJPxmjC88trok?=
 =?us-ascii?Q?IC2O2GlG9fpBebgMnmA/9s/ycnwV5BblJbTztjGeBGLpyKvQXgeHnVxtFIBC?=
 =?us-ascii?Q?2rc2aXlLIxRDu0o94XnbInNSe8jVlC2zKRDrfsG9193G2ufJyG5vUYxTOVf+?=
 =?us-ascii?Q?xW181y6WCtFYMqElJItSmeCv66eVAGRxg7wx8S7dOVVmJQd1JJyuzeQyl03P?=
 =?us-ascii?Q?Wld80iopbbKsmEJ3p22HImCu/jF5/PKLOW1ltc7AdgFYQMbptbsb/c0xNVQC?=
 =?us-ascii?Q?lSQK6O/VgUQwGLincgQYScuDqzSiDPZiOoi/4ouup7XaMkNkphGrgmMJ2Ur7?=
 =?us-ascii?Q?Oi+ixSxN6BLIcgxedwBQOIsjWkmWtsq+gFnXPgYAir8Qnuj70+B5TmYZJFW6?=
 =?us-ascii?Q?tenerdh4AQn68JjPe4lCcjJDQ+LZ4S9IcBbRO+6rBGNEzfz7TzH7/ycekUCK?=
 =?us-ascii?Q?miSgyVC18Xwc02KSL4b4yNPg0JkhlytTFODMWssvBAVAJhYpvv1YTSIkOlOq?=
 =?us-ascii?Q?lRZ2BOh509DiYKJHQMXRRYFz8KCKsdFhMpwGf8la8PMirc0AuO5BcXc31s0n?=
 =?us-ascii?Q?MgxCIwEtaSTWGnVHvr5J2lIAygnQMWEAXgBB/u0T4kzZXMJ2Jy3X5BJmxhZm?=
 =?us-ascii?Q?1VZmFSIcZCZ6OiomsiduBQI0UdbwMUEolmnGOtpR5Hb0HxvOfh5xutoIhC4w?=
 =?us-ascii?Q?c9aRsiZHuoYKu+xUgleeZ0J/q+3azGML3hHSHxMnJqKHL6GMNvcCSozx0hib?=
 =?us-ascii?Q?w+v3lAaHSLwMxxe2eaiHlQKbtUiDrPNbUlTDsGaX9fjEIq6kF/1A+WTEj+9C?=
 =?us-ascii?Q?rxytle4uxiCYVhJ2V0rwc3ug+abbVDaFIV63kD/szJFvpmkBDx+II3FjFxea?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f975e1-3fa2-494d-4afc-08db02e7e94f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:09.0857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/CfUihnyC0hFoDRKUKYck2gBrw9bpTpqUyhbNqvFZaPWlp03f9vdwklfGpbx80wB0KMCPwLLZ5UO5rM6ZJBhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_reconfigure() was modified in commit c33bfaf91c4c ("net: enetc:
set up XDP program under enetc_reconfigure()") to take an optional
callback that runs while the netdev is down, but this callback currently
cannot fail.

Code up the error handling so that the interface is restarted with the
old resources if the callback fails.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a80f259b17e..5d7eeb1b5a23 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2574,8 +2574,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	 * without reconfiguration.
 	 */
 	if (!netif_running(priv->ndev)) {
-		if (cb)
-			cb(priv, ctx);
+		if (cb) {
+			err = cb(priv, ctx);
+			if (err)
+				return err;
+		}
 
 		return 0;
 	}
@@ -2596,8 +2599,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	enetc_free_rxtx_rings(priv);
 
 	/* Interface is down, run optional callback now */
-	if (cb)
-		cb(priv, ctx);
+	if (cb) {
+		err = cb(priv, ctx);
+		if (err)
+			goto out_restart;
+	}
 
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2606,6 +2612,10 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 
 	return 0;
 
+out_restart:
+	enetc_setup_bdrs(priv, extended);
+	enetc_start(priv->ndev);
+	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 out_free_tx_res:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 out:
-- 
2.34.1

