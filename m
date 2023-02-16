Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D9A69A235
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBPXVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPXVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:46 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B370442FB;
        Thu, 16 Feb 2023 15:21:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1OFA7WD4JnbWo7WdIRLNOJhLZEXhx2DuMRbAXjsR2RjVULykf70xuEeDHZoGg+nt0a7OVHyZ2R4qlnS8Js6tAJFWe0UtWLuYPnnP2FnyxWUnraViVHaz+XaoNM2YQw7RdmLtHBWle8TlHrW+eLOoKwtBj9IrcwzG98huDzgGCQdiID36Ulc1edf+I706SgwHXR0tHjwekcGfmqQ7qS+8CBx11QDRk/H4RbgZysUpQkglnRnSKlUg1LwI0XDw6lCrGOa1LTifD+Kujc67OzRH2vD3uap9nLkyf3nDkzBEXAcNzrfvahPdqqrl4SBaL6QQhveFgQTwN1Ima/0mvuykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4Q80mCxvBneKP5ZVv6v5WaAONSC4VppBorKYRTSPBA=;
 b=MnqIbPQE9jblTUEb79R2UF1yQgvbAe12vHJITxK3BDnUO9ikKVZ3QP3jc7M05lAgqRoFzw8sRmg9Q6kfOZPasyj0UT+U3MrFDmvboK34mAjIP36BZPYvhInEzpsZcD/bNvRQdsD1a+ayOgHhlovurskKmAfIidku7aak3bGIJJ3PR5daUziFB7GMNd4hOEhrDuSyWkOUoRQgxRiTFjmFb27cQ7QhAiu/fHokm5TXszlCx9mNAXCCYl1XI0l8Yb5Dt0tZZG6K5OANQ200BPOdoEb0v6Dceqr6Tz2y2vW5Ir8/gS0hsH0iozwluXZf5vCnYWAUBIGTtmWj9aEWvlPXTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4Q80mCxvBneKP5ZVv6v5WaAONSC4VppBorKYRTSPBA=;
 b=WCYGEqtuD9nmKlJjlBuaGktB631p7VtwWJZ1aV132u8P4N0mUfPndnf9j/Zfr5mDX5CmA6/1A6jyF9WXXbPGH8TWykJjbA2BXKUGQhRHP3AZpA7K+rgx64JMKxPsE5s/poRT4IMUfDrdegeQmBg+wTy/JOD17je8xmm7aQ7iVBM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:42 +0000
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/12] net: enetc: rename "mqprio" to "qopt"
Date:   Fri, 17 Feb 2023 01:21:15 +0200
Message-Id: <20230216232126.3402975-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fbaea5-e512-4b7a-1dc8-08db10749004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79y/p5gaP6wt7+6MJgV/tTlntjLW/Mq+4mqAzJXY+eVPUUSbm3UeetVtq2PE7HqmPPlb9tiIsse1rdbWdro+xWOJpVgYpUItZuXkZd7oAOiXfoBYew+tx6YL3TWwylfjdhx+yPfnJ1uTUKK21S7Y0o5aWAHkuKCRxDKe+C8ledwnPbZymdgYdjH4agGHmhZrPr0hbmAnTou9OxH3yAI6iKsbCuuiO70FkH2CgjG4iIQlBXZ+7q9JnoXCHVzmtRx2vELNEDubrl//69DoBI0e8vgU6+/GNHNrUETC7oystQ9lmrq0rUWmG2IEBVvCmwY/JogzA6uzq+RUAwTL5R/NVVejRvNdVupv3u+02wofLXD6td8qeiZ+ZwyYqTxW3aXCag2CFMBD6PDaTOjx6MLm8Z2EfH2WD4NAMBwCiSGuuwytqeX/HNm7cTAM4BQPBJ2ePW+v8eJ8JHDisPskYoyK/jEylDRaAfxEXBfh8q5f7B0BS8WSyRHfDl31+JMTGgqZux9gqHI07u6+TKKyLneREAU4P3rGZkWVVObxdqeWW6wluwBXRnhSCHVNT95YNozEWkr7o+bbYOOG3FsqIM4Ezty3xUE6qtb5OvcnZT3lBpCBAAmdCHw15CFau4s12itMMkAzwvmSAvOsoYXLu7A0kX2mlYkZJ2yKgu5kdubtl9YcKIaJIX765MLzCctCZAInMWd1950qDZWwktl6scRXIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zz3bo6mr1TAF7Ol3lwfiIFh+v/iJDi5p39wUG8BRQleykc4PG/Hu52suUqVz?=
 =?us-ascii?Q?koTiNYWRDUqxMUp7cVfIKTQQ5yOj02GB97nkZMcZZNmbCy3oHyrcFgrP7uEm?=
 =?us-ascii?Q?RsI08aMnsS6DFpUzRutEw7eECe4qSZ5JzjjMOjnsqkLEyjSB44QM/Fe45DmV?=
 =?us-ascii?Q?Gf//FKxnOinGQgajMJ+UNmtd95nXcb/JjGghZD+OR7XelavunhEE1T12Z159?=
 =?us-ascii?Q?UuEaF1NVshYbbmBtfnEBiewyqdRdv/0AZCVHf6EYSmfA5CJsO7JdbffjzVg1?=
 =?us-ascii?Q?bkOLlRi0g74q502tSXPSGovaf1DVIAlAAGFCFIm1wenbG4gs2E5Np1AauJu+?=
 =?us-ascii?Q?roT/cmy0fyQf9xoUePX2a73HxDw+xdbjdeAYQWqjnDi2XPnUAERoFWwFZHtM?=
 =?us-ascii?Q?Wu1Mm6EDTsu8lnuRkLBqiUA64/ApmIKUciIR53iFCtCHer22EcK2QkSAIeV+?=
 =?us-ascii?Q?A4RjSIH54C+DF2RBuqQzQAbb9O3f2sNNh6Tm6stBUra1BIvdDR+ulDWjlhGF?=
 =?us-ascii?Q?X1EIR3kpPrlveVs1NUWLU/K8l16NLICx8iG0sgR5nFGe1um2MR2OO3+bWstF?=
 =?us-ascii?Q?z7pRiFE7khdiYydAbxM8AFsXlRnO0p6PHEt/4OIY7wYFSXtnAO2Igmd8VxAm?=
 =?us-ascii?Q?PO6P4N8E44P1HT8m9DVzGkCmhGM3a8cYDJ51oxZs9Hfrxh2KDPwTU16ZngVy?=
 =?us-ascii?Q?274Eswl8oW1AtaKsRJRyvXah6DuyeELPE7bELGNVWKXOveSnTHYm0r5cAtCc?=
 =?us-ascii?Q?i0fkA3Kd6/xnF/AI/UfjEAcTC6YR/xunmkP9LW6voTiL9IhwNa/NPEgtbsPp?=
 =?us-ascii?Q?4J2Ihi2QxV9NYvkrJ4grhh3DiIPAyCqmgTwwR6ELcoL5SMb+1y/DhgU/e+zk?=
 =?us-ascii?Q?sJ3MZyNMEqfgqH8WZeUkplo/07wTa+Ov1vQCuqECRtGdxbdgWGBzlQvynXM1?=
 =?us-ascii?Q?KvEws58Zo7Uw3X64gynYhFjwPBEJntvIApZ5hn6bjADh9Xhjuz1DHs3wUa3s?=
 =?us-ascii?Q?iwH2YGxl+Cq4IbxhQXnFyWztecipMlP6/+1b1oNE4QlTH/4zwu8MB2SaCx+V?=
 =?us-ascii?Q?5i3AnZbUPVz7FN1kyetbqSOoEdZm5F0mS1VqcR7v1qHhCnXh9ye1BrHKkLOP?=
 =?us-ascii?Q?HBfFLdl8ATZkAA+LHhNMY7c4vrjfnRF8EESeeOs1XRipuQtHmlSEQasD4nfT?=
 =?us-ascii?Q?fkFymmy7EZI/P7I0aBBj6ybWobzmHsRsoqVYOIlLHjOW9wH2HfPo0tR+MTHK?=
 =?us-ascii?Q?FNS4rGANKmcoofPmrfFQ2s/zKFuC8Xo3mZyGabyQcOLTH69inpTV0FLtKQUu?=
 =?us-ascii?Q?ok5o6pIVri6DG0tc3vcRHQRfT1kbwHn9M7VG2wW+HHApWlIC6dr2uqM7wOEx?=
 =?us-ascii?Q?t1qZyFEHW9ZJp2TA3OYKsDDTKaiid/f3S1dPGx3B/tUyKcSXUlxAp/XE5uJ0?=
 =?us-ascii?Q?gvzktVAc4FBJpR7+pDE4MJxsl/eeYXFryGMKllAm+wjC4mi7zIG3tmj6g6/J?=
 =?us-ascii?Q?ZpBtkNb5vRbm5IdkIvNxZATdhhQuSUykMR0JYBw82Vd8t2dk7BnJmJdp3wQO?=
 =?us-ascii?Q?LFTLzwvk+Ip423fA/fgZOTJ0c20lNLuCvlheBfw+5JLU2BQhkoyz9/3aNWCB?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fbaea5-e512-4b7a-1dc8-08db10749004
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:42.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPZa0G2r1/tF6qeQFmFhSdG7YYFDNfp8blmzkxJZOJQdSvi/1Hn9sYz1njCyDdO8evdZybbKlfWfEm7d1q2NrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To gain access to the larger encapsulating structure which has the type
tc_mqprio_qopt_offload, rename just the "qopt" field as "qopt".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

