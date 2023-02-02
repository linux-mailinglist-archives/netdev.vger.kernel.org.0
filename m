Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F668725C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBBAgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjBBAgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:48 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5CC728FB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGGQZYMe9Rk+8ogMmi3feLvrSSaPq6iUqvODaSvhp885JdHc5o59w7XlGrKHhnPrgytnMSbnrjx1tOakOza6t5BgNkFtv9gOagLH26gPcQjj8JF3q/Oyhq/7K+RZY2zsJbYRsGqgBdFX4l7XgDHkqTdH8l3Hs4W/239rY8Tj3l5S6RSVdNlTwOg65iEPiU9+WokeBmHMYHr8+BIaoPLgyhVVv9tag94NiIb1wTbwfDrPNPKcIjRe8LqQG+I0/S95z0Ja4BhvTDQN+cbTgDVxy4mZyJf1AbmDFrKdseF/XIydQuCL1j2Wt/RDHk4fX1iwszCHwrCrX1jcnaMLdiVsMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzvFRB36DIVC1OPSD3f2i/e/n5whkwOblsVCFdWt76I=;
 b=iBWtUSqmXPDELj9fO7/O+pr1aAm+25TeMlKNXXCLa4bpxZtjll5z2xl1SA6RoujhgH9wVBHTmtUb9nh0cOmH9Q4CLidBBhNKFK3xE1DMKZb+i97HT1SH6X4tET80LMIa6vz4cYKozMTabhoMmveCWyPW9pDZcGtSKIDlyG/EW/YgBcI77XB+9l/syB1SLVr2NTCu2GhP10ABmRGEb03LL/HQOvm0dQtht3Z5UYF7+rDwZZU+aaiNb4Wxnzg+KSaoOgDnRIY6HFxADgLYV/YS4IKlq+bbBeN3ArEWvKgOyJB2gpJTv/CN9rnWsKBbE75KaSUmnu6En67Ilirq8rA3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzvFRB36DIVC1OPSD3f2i/e/n5whkwOblsVCFdWt76I=;
 b=DAdoll1Uc8tC8ziSffbJ17a1vv+qKS8A7P6pXRgx8StGIPvN1eBtffJQOpk5JDVZHnfH1gwY/FTUzpJsCdQCMJsXFkrOokFbYXuBMpPw8NIxtQJ+oM2uaSr9RezubTPvnNLffKwXbgAiFc+fAcD6bLFpr4zbW0KtlAJRQQMRLKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:44 +0000
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
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 01/17] net: enetc: simplify enetc_num_stack_tx_queues()
Date:   Thu,  2 Feb 2023 02:36:05 +0200
Message-Id: <20230202003621.2679603-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc8a0e5-2b5d-4d06-6aef-08db04b58f0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0z0Mmk0hfcp9I3RjxBg4gB/Braoomoasf0KzbvcngQVotsBsfjFkbCL421rBzTMfjCuhmGKWTkihXsqMsj7QrCV8h2nt8Pm4CJonB91TTv4FcsLlTyxWjQp6biB2cPXDgAciHQeK1OeeQtKtkcvosoDOkWOpYoG9u5UUhRpfYnpNmoETwHJ88uqyuohiYiYJg/WYl2M2X0rQosYf28iRinHonLJvEnlfgtLKj9hmLDrT9ca7hlRL0NWdYEtQG72UXhvwseBKgRroNcW6ma5I1INiTIMjiXZGRz5031Z0HISjKDAlFvj7fDZdC72sdBK9DdQNEvJYEcsxn7krkBp2dbbCHzQbgC/51U4ffaCEkpca+Ov51tI2+WKcukKUC+wkNWnH+xUYvr4B/oRyief4EekptZSMMKqgcTTBpS/jgkYbR07porxAtVCh22pnbhZl5oFLG6UZQJUGQUmY4bmbuzTzi1BmDKoEY6h7HK8RHIFpgPjFdm9LHgMl13edBVPOP+N6NyXQtHIyIjA0E/RsHWkXjz0RqZQeyNtgG70fatwNuHb4bD8VWAJcHKG0aKWGW80ZbobiWqII48Q6NjdV6E/3N+n/fMJRHo5nsCNiaw9blYFM/hDB5eUdnr2XhQ7IuydNDgV6SfBuzv5k4sxsmY69Brd3eTgOGEMlPKbmeWrMBJgGaSvKDZie4uK+Fi6EgJCZ1QEZtp2m0U8bjrrE7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4qW2TN7prhmkF82kNMgI9h3CJoUZSIdtyY+rQUSgu9mJY3rzzCqrCF923BF?=
 =?us-ascii?Q?7ycUJgn8zQTRme9g0mGQpDCqEqqmgtACSA+nFsVB9YilGNIzkBUH8TMLNMIN?=
 =?us-ascii?Q?SzBqaL4254ulGlwrokCSBtzUPYiy2k7qCdQ7Qy6uKdp0dO5Y+BxGCBnY6YsV?=
 =?us-ascii?Q?SDMY5OXci3dTFcr+tXhwYNZ++0Gi+XJyGuICJZRU5c7w8LiUGKEgvKmzrPq+?=
 =?us-ascii?Q?vECvI+pdnq8dY2MQMZBU/QLfnmNR4F1X17de9HIEhHh1noyT+q4qvwn7e3P7?=
 =?us-ascii?Q?AycmKfy9UiEsm6UxsLwhRj/Mht2LzBYVOPfChvDrFxfQvQU21tBlHLD0HT1q?=
 =?us-ascii?Q?x6O2dzIlQVoPca+m/FPIIhmSdm9RKRI+loYDHhPvmvgkohUm/l1n69i6CMje?=
 =?us-ascii?Q?NcNr4b6JMGb1BKFh85lA6gCcplirZcwT09Bp1HtUu65TjlPBCVOtBAhUDB9w?=
 =?us-ascii?Q?pkA1vebtqiP4N4ngIKOjyXE+iCgDN1IlEStuiIIxx5zuNu/QfS1xDUkavssB?=
 =?us-ascii?Q?xG/r5Gae3plXtlO44nB3w+yQYqC4qL7feQffFYtksrkGcCIb2N/frg5o3h1R?=
 =?us-ascii?Q?kx+qBB9LNNQ0bXIHr+GWqcs41hFskpZQ4H/eQ/HLeDhotCFoS61WdfyEqcNQ?=
 =?us-ascii?Q?59dYxWMYBMYsYvao84I45QkR69Moqs2BzmDbtdlARVe3wprXZ9S0PgIX1VvG?=
 =?us-ascii?Q?MfyDgW5MaMv5YlZPE+VzD6p2XK5quSsJrKMp3wykfGME5Q0KTGMyAs7xHUuL?=
 =?us-ascii?Q?XOutCX5vxyZGYFZQhCPhL0JTRQ2V9llHoXdq7AZxubNXGdQzyelKWErcZaLJ?=
 =?us-ascii?Q?qMRC90u2xxk3DLxdOan36xzYh3un7CTHZK8z51/KbuztbRcbKh0nwI+w1xP4?=
 =?us-ascii?Q?puRz0+dKpvJvaFNW1jul0DFiJnfdEO3JgUN416Jc7LbqDFCyeqXBeyyLNWQr?=
 =?us-ascii?Q?ik1xbG5CnQxS/7PBN9u9uPAhjU5V/glSwWmT8ZFrDVMGcpQSW8DVkQoTHIBo?=
 =?us-ascii?Q?7/Zw/AUbfqvFink3pdpBrCveeXhdbXdXTjgqwb3hXDBYBrpIiLIrqqxwuWSa?=
 =?us-ascii?Q?zwsIxcGXGwlbAuUkjox1UPfV5frteQLNWjbfV67s0XGyTt/0kMpjJeZqFHST?=
 =?us-ascii?Q?kXseRiWNj0e2c7zgugv1Yv752xdssdeJM6xRF7ObM4hVq8l373vhzIQx5Ik/?=
 =?us-ascii?Q?dYmuQj9XZf4QM92keMzlAAL+dI6S2ElOFcQ5qXtJ3cARlVSq6LUGP1sfreUh?=
 =?us-ascii?Q?7GH//KqI2/lcNoUQ7kU5pbZgOPBGxcgEjE3nmJTRWYRYQXBBy6RimVcaKjLv?=
 =?us-ascii?Q?nhldQHNaPhbTx7X0xaFVpLMQTbzs7phBP214Zd9RZTA0oTk4pCnqJyBX1/zP?=
 =?us-ascii?Q?OKEb/liKfOf7a9yrtcP75eOxirjhCLeO9N5jjgOwEwu9N1nMYMsUPZnKBeHq?=
 =?us-ascii?Q?0+CN2WjKRpW/GekTNaU2FnocOue0VHKKALVpTsSbT/p2FNsjkhKgenpyOy8e?=
 =?us-ascii?Q?w3YUjFrNQb50OeNhcDSo2eRGS/+qD2J/aKNdmit5Szkv5w/UvgwQOCGBWX+Y?=
 =?us-ascii?Q?nnNlDvd/dI4tEd4qbMzSnWiBkSMyJQq/FnPHcTPJ2RbjcW2aRHoZiMSM1ROd?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc8a0e5-2b5d-4d06-6aef-08db04b58f0e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:44.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlPy7EnDMBKBw57HZx4z4F9BgkTRxand1F3lfSRNCahFq47+hB7ByUVODCHqeqbGCDFXdfpZhvfvOozxYMrctA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2->v5: none
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

