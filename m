Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C384B3D0D
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237931AbiBMTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:13:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbiBMTNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:13:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2133.outbound.protection.outlook.com [40.107.236.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE534593BE;
        Sun, 13 Feb 2022 11:13:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVdue1aOaOyYYSfdN3Ht7mrAAOf9EOlJVrZMTXZhibzmsTX1FYyjNq4NvkfLYvom1p6mFhLvGIa4+d7/+RCtJ4qllrepTzBi/4uNKfFSIip8vITwUCBP0o/8y7AsjSe/zDbLO4cM6ePz1ArKoYWuGlAT1lpXIvy8ELlt4JhhYNYt7iC/I7A4uqKj8n98RaJuPPgsXKVNOZond7zPU/NsE4v0FHSnMDsMOogl29piOWqh/9cXB8PJU3cC/19SDNqnUY+kM5MFRSTdRybSi3P2H3f/6r6EnWFdSe6fm4xJrBndMFNYjgWwuOun8a9MQcuYrgy4i4dSMfzecMr6xA7yCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juxvqwuCGZcRXNpT/zJB3Glo7mhiiIRS8v7h6zqDnzE=;
 b=RA3zE52U2DRMepUD86zRGvhPQDyElsZHYu2bPVfVqnSUDLCsVYzfR4MCY8k8RzKQpaDuzyScOrN4ksspQMM/+qNarVdMWBGw/lh5qfMQdbXo4wmRtIj15qM8ELdrtdrSrovG5NrMxjUsU2toKCfd+84k0Ipb/5WVZO4agfh1MJDFHKGAFoL/VOS8IoDvdhWQN1QAG81BWWnJZNJGHZjgFoP/XelIbyiAZFp9/NXs4n5jHGRj3twK6tDnr+P32ejZm1TlnaxpgdM6r76pwtTGqYdS0zOCUI+6yV2gCYRryWbW52ycwBKvCnwlOKwcCg/k2fjxW3tU8rmI8vS3H6NGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juxvqwuCGZcRXNpT/zJB3Glo7mhiiIRS8v7h6zqDnzE=;
 b=tVfHNIua7xRSu5p23NBM1QnYMMgs3kQA1KJaoGLWPr0N3hMYV1fiS+pGHrnO1kg+sp3q9g2VKagZEhqCD3KCcUQSPEJ/gC0+5UwXP6dO7bmUQb7A2tFCk2YgXcfvG9HaQjj7HHcP1kgo2sSTtStqDmCfb1RgUsx5ZujKkREK6IA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3315.namprd10.prod.outlook.com
 (2603:10b6:408:c8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 19:13:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 19:13:05 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v7 net-next 1/4] net: mscc: ocelot: remove unnecessary stat reading from ethtool
Date:   Sun, 13 Feb 2022 11:12:51 -0800
Message-Id: <20220213191254.1480765-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220213191254.1480765-1-colin.foster@in-advantage.com>
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb5127ca-4ebf-48e4-af5b-08d9ef24dc58
X-MS-TrafficTypeDiagnostic: BN8PR10MB3315:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3315557D464A1AD66DA55F67A4329@BN8PR10MB3315.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxCUv6DCw5tBSz+eYIzG7FXyzgetgmiqRA5jiPCC7PeQruI4WCI12+ctv3fE5Kc6/si2tf+bhgUnCjPnJoONJg76cfX7ZX2s1iKd37qWmS3TRa2jWkvPOVKTFXw5hVg2a+YimB8nwn3Dgm2q+1WyiQce3lfquKj8gKvHD9MeDNwcRBMVRcj1x5pVxKiQMxpKCrc1PcSQqB7Iw48dlSMRgyBA54gIavehtk7N4JTipDpOjoAyehgbwTYgCmzP+vvrJ9nUX+Z2A990Rkpuqbi/GQu/ZnQYxDOdVvgjj/RheZ16+tQaGTAzFjS3HrXJsmXuUEHzkv6NN7liO5xfo//eHrCLtxRc2bB85hWJu8xMu8zlBUOQotu1X2DHVmdPhxDPdBHaVJTYfuX+hyY4yEPxU1E36/kZ6zAvzDPAP3tVdLROX66klByxsTgjcWi8XJFMi5Nxyx51a+Z/pjBlqPNmRzY35fJdke0wW+uwmFo6U7+5SzKNuGObAhUHOKYXHk35qLiVBvVVfISbSBA0JWkzuY5U9ZJBK22Ud1DQfd4rWd7OTIwli2dzgaN0GYFJ0XmzwuL30biGXmurYEtjCqEFmZCyrkJ210D+iXFIx8EWphlF2zcXwO2lVL9lTQDvjix1ylK/2Q2xke4kpJH/motd8cm+28byCf2/k8m2VrrVEDtq9MMqvkaaha5S0m3fLMdEYru3kIWI/rsIW2jvfXVnyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(376002)(39830400003)(346002)(396003)(26005)(186003)(2616005)(508600001)(6486002)(6512007)(66556008)(66476007)(38100700002)(4326008)(66946007)(44832011)(1076003)(38350700002)(5660300002)(8676002)(36756003)(83380400001)(52116002)(6506007)(86362001)(6666004)(8936002)(2906002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9zF280pDCvGPdRfLeHKnww2kKRpSlM83GcaOYritICodLSe0Pv91W+hrjGKE?=
 =?us-ascii?Q?93sT/WWh6/TsBOUYbcU+vSLC1CqgBOdnYns4vD5qpfZD1YSJF7IdiStfbh0X?=
 =?us-ascii?Q?w/MXV8dyYJXIqG1T+VwHjpwrhCw2y6EQQ803rvZuAGvWGgVwZatBhPunleQJ?=
 =?us-ascii?Q?pPBFX6rxjGYcbmaKUjIQTWbrWKv2jK1h3TYWivFFKNouSbC1cmKQJpqgp4gF?=
 =?us-ascii?Q?3ERUMsI6zydtD3nZE1+I22U52XdQRNHQEwAA/G1bvpWwAVAadSK6tIfHYDY3?=
 =?us-ascii?Q?TsaeiIwprf5qdEVoJ+1pVWeaAH1Av0l/PMVM0gprGdjHmvKxcWPy12RyMiEd?=
 =?us-ascii?Q?4aMoLlGFtBQpJaBpWKkRbByMtUTFNednWXf6Sj6VQ/hKsm0a3pc44UPW96Fc?=
 =?us-ascii?Q?/vvTCuA/dUVcfVeSinq5HBR8THpFwZEnK/SRsjE408C4mBOrOsobHL2y+9Gm?=
 =?us-ascii?Q?oIgBDwjqEl1NfhXDi/X1Jj4r6FFmBi23AtIXj5oXnCvrKgvDoK8aG/Q4PMof?=
 =?us-ascii?Q?I2zZOnfqQXXXwtVXkJtDOUBGEssNazhE9t+VvEkJbP4jdc63Jw0eCEkGkFiw?=
 =?us-ascii?Q?MOp49rTf8HzveSsz0P+9frqmSacWTWtcn2NucM7GpoN6WzeLrLn9LNdwNc/J?=
 =?us-ascii?Q?cMGwfMVtO10SMFnwxo91GLSWUd4hpwComPU058mKZESRT5scL2Y2JfmsWFLx?=
 =?us-ascii?Q?SEOpYlL/hOHQgqThDDCN6bOv9U2UPHSGubdN5gopBF01s+A4uhor3PDA4XHY?=
 =?us-ascii?Q?JqkWjEHRWVwQ5oWQdXZW1Ip5QQirmlArVd0Zhr2w+8iatKqytO/F3HLgwoZU?=
 =?us-ascii?Q?Dm24ey8HFXcfZvEcnQ4hqci+FBviSieeBvbDUPUfBzxqD4viKjUs0COJebCD?=
 =?us-ascii?Q?urHcy7nFBI5g7Uf0e+B+lMtMIzKoNmV9j7QoLystj9HEbWxUCNZLhTfjpuQY?=
 =?us-ascii?Q?dpd9rriYI2m+qXUhfsgSE2QLTjcQS/HglyteUNytdXVCm8LXakXtkXXRnX/V?=
 =?us-ascii?Q?yGmEc99/dVBWn78iRhaQvAUA3oBK5OsAIyQWrf4T9oxD2XYx1GZ8lIJ2+Va7?=
 =?us-ascii?Q?G9+NIjxSS2gE+La5uWS+sYLnL2oj59AzpJBEVVXEvQv5igMq/LPsV5r7isxY?=
 =?us-ascii?Q?S+VP+jVCpxtFw9VaSaS10pw+bLiBB+SH3NLbiqC/hH8KKuaZeosipV3uoHsf?=
 =?us-ascii?Q?xilUva8Rg6IrXGxb1/vRIjexnZIcHd7iugmj1ddohHMWpkdygdmaWIApyoIN?=
 =?us-ascii?Q?aMX24X9cHHC03JRhfoZ5AgpoIHYO2jotkeBSPTnoAobCHYdY94YVDA3FGnmh?=
 =?us-ascii?Q?3bcgi+F2DtR7LjRnpa4oo0b2ejlHaQ/UkfuVx/O1NGK66k1EawsyPmHQ4Wen?=
 =?us-ascii?Q?/IawxZvpUPtCZEa4At/atFkhjalSXw+QEUHwfAqniVSbqBjfTJAd/bX6l/Ju?=
 =?us-ascii?Q?yrV8F0EkbMXflzsxn3NGoLBeMh3FQhtNJiRmbTUZXIESTWGuxX2NNeTLbsc8?=
 =?us-ascii?Q?7h9GGbgs61gZYj13HP8GXPHhyJ50gswrkrujE6toBPoJcWG/gdLZhH8VU7Tu?=
 =?us-ascii?Q?G8sNYt3jDBpsv7UUobNXszX5SXJ5Kv/T9NrQGZ3IAYk7cwicCG6Peb9BwUYz?=
 =?us-ascii?Q?M34JdXXOsSUuXqGW0euj4qx6T7wHsvu0G29YJp/BABrIuMc3Mdk+eMqfrEEG?=
 =?us-ascii?Q?atAB3w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5127ca-4ebf-48e4-af5b-08d9ef24dc58
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 19:13:04.6171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpCfT+PvZYsq4jjAugcveqwVSO+smg6arxBuBcNI7eOQN9z4ttHIXM9ZrpM4MJcGcUiOmimLzgNo96VbWXnu4QZ+6jH0FhxLgVKmYqibkZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3315
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_update_stats function only needs to read from one port, yet it
was updating the stats for all ports. Update to only read the stats that
are necessary.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 33 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6de86552df0..885288eb389c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1746,27 +1746,24 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 EXPORT_SYMBOL(ocelot_get_strings);
 
 /* Caller must hold &ocelot->stats_lock */
-static void ocelot_update_stats(struct ocelot *ocelot)
+static void ocelot_port_update_stats(struct ocelot *ocelot, int port)
 {
-	int i, j;
+	int j;
 
-	for (i = 0; i < ocelot->num_phys_ports; i++) {
-		/* Configure the port to read the stats from */
-		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
+	/* Configure the port to read the stats from */
+	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
 
-		for (j = 0; j < ocelot->num_stats; j++) {
-			u32 val;
-			unsigned int idx = i * ocelot->num_stats + j;
+	for (j = 0; j < ocelot->num_stats; j++) {
+		u32 val;
+		unsigned int idx = port * ocelot->num_stats + j;
 
-			val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
-					      ocelot->stats_layout[j].offset);
+		val = ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
+				      ocelot->stats_layout[j].offset);
 
-			if (val < (ocelot->stats[idx] & U32_MAX))
-				ocelot->stats[idx] += (u64)1 << 32;
+		if (val < (ocelot->stats[idx] & U32_MAX))
+			ocelot->stats[idx] += (u64)1 << 32;
 
-			ocelot->stats[idx] = (ocelot->stats[idx] &
-					      ~(u64)U32_MAX) + val;
-		}
+		ocelot->stats[idx] = (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
 	}
 }
 
@@ -1775,9 +1772,11 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct delayed_work *del_work = to_delayed_work(work);
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
+	int i;
 
 	mutex_lock(&ocelot->stats_lock);
-	ocelot_update_stats(ocelot);
+	for (i = 0; i < ocelot->num_phys_ports; i++)
+		ocelot_port_update_stats(ocelot, i);
 	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
@@ -1791,7 +1790,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	mutex_lock(&ocelot->stats_lock);
 
 	/* check and update now */
-	ocelot_update_stats(ocelot);
+	ocelot_port_update_stats(ocelot, port);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
-- 
2.25.1

