Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FED369C06E
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBSNxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBSNxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:43 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2052.outbound.protection.outlook.com [40.107.104.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BF74C0A;
        Sun, 19 Feb 2023 05:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+gAmSEHOHxvgVNu24JaSocWEFFc4iPPBmrPM21/Gw1T1mThG3kD4/j1f2j1jrQ9ZRJlVyG4jofC0khv75idq0RFhdlYe4VXDogub3Z0Xlm3FkS9db6Fk4xnRB4BOklbm7ZXV82FOkcjVo/OqDskzbuHwbBff5r/kDj8r3S9EFNMNSFykKThSpbSjRsaNoyv7LMSrkR5dEZEaZViip6+sdd7ji/0PE7v2yFCJ0wv4uQbPmQl1zstzQvgikgO/wT0WQdTJMcoBpfP20WZ/QEyHlH82owo/AK5MjNFXVyhRS6Jg5Q/new4hFTXqVFwAHPJa4RuUE3Fi3b5P71tWLoSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+40kMAraM7hDvsFJEK7pFjXpHKWGz2oct9yJ4VaKdBM=;
 b=cOfre2bIjfvqmdujD4wjBycpyHy4uNPXRENdKIecYnP+l6JgKTbRLFzdBZNhhGGLqkam3WX2L6G/c9FH6+UT01/41trFVgG10i9S565zUjBc6b05xo9FA9TDULR9S2oh864NL456kr9NYy11iCbOWIJLsq/14l7NORoptHaswWxvExzfwnhMe+tPb/f5nDWtuTtjtYZfFf5lY8hw5nCUEPgq8+QlzSq0xY65OpbitSRXdKLXT5xmaPl0U6a/g8Pr0pECUD4uBm7oDfy7+p+6Rl8u4icPQ5/goCmAdGZBYl974VCw7bTLJhCk3fd0cnxfNBx4uQMv9iW3chX4QDv81w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+40kMAraM7hDvsFJEK7pFjXpHKWGz2oct9yJ4VaKdBM=;
 b=AzwdEe4dFN7YWC1qGDnhGsXUvnv/i2M+zwgR6AZfXPKamMDw6LZVu0iXepDaVmRx+ZrxQzOlZic88jNYZrfyoakCy1A22tnS/AIQuGkN1hCNs/d1S3nViPcMI+XS/RO91wNMKS+DVBxptWprGdZKM2k1TwrHKgBGqDAgnuGJSa4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:39 +0000
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 01/12] net: enetc: rename "mqprio" to "qopt"
Date:   Sun, 19 Feb 2023 15:52:57 +0200
Message-Id: <20230219135309.594188-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b81aa0f-6e52-40a6-6cb0-08db1280b3ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlLF5w7BM2npg5gI4/ue+SieZsA+rablIAIFzNXEwtxeJYkP7VxS/mLs9wBLI3cw/YKsQ5C7y11qZMGp3ZqDaAAsb3//Ymet2oFcSoSg7+poXEv1GVBqmUhRB1NFJkSQ5UZVBxpgTv0BlUN5tUK6LyCHMQw6383XIknMH/1qJhq/7saOShLhwVOzPT3ws6rGnQBoucVFvEYb+/2SNCSPFQV+G0KL4a0MOK4smvF1qRl/Wd8/8ezLbvmI6CvEcPnUDJOvDedGsixAkCuzWLwsiRDP1U6NND9UzNTz5pipMupQ4TYzmbVj7snBI5sCcm9Bvh0p16UXIiQh+6iTnChUF++bW0v6aDNFL2NDaASXVaJm9RbeSu/UuB/2caQw+daoGFytraEHiZrzpgKjkis4SZXabbN6byDgOfep8MBMLUVdNTlS8qivqNYTODwgeFfK9zhtQkmyrAwVohGcNqGaEBq55TenQnHay02aW9HgYd1y/+NgK0vSPwZbO5IHA/Ti54+/YGp6bbGLptGExc+XW8TEjQ8vb1l0sbQD1hsX0aBZy7s8eZy5U989cPAJD6Xo2moAH08iYb02I7+DZ/o5cF4c5+QAAcFy+ruzLHKlNOjqOvTPCoEBcTyT9L6WcXKLEYPqaqOzNyqW9+YdnitMg6OY6S1Hnk5TNdzWA0yI57aC34D5TZTFYhdqTdhrQQKKkoKIX4Awzp1RCAzwBv/Pqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pp9KUcRMx8+wlPYBIF0jp3b6aXoSe+lTCZmE1n7CGxlXlZftig6ZLACTsGPJ?=
 =?us-ascii?Q?DGeiwgNN5d4LET2xMmxaKFzlGKNnBSncFo13SJTEfQ5IkKRvo6FyRCJ8ct5E?=
 =?us-ascii?Q?OyeLwE22WAIAwJ4PmZLmLa9I/dvXyk1HKs6M4eNS7ajl7akFiIZCmvFtYPgq?=
 =?us-ascii?Q?SvIW2vtF4RYIdMDhBUcpf7Db5TrNm1MSc4yldp4DLRLw3zciPp5tGkU0IbNa?=
 =?us-ascii?Q?TEKTc+vIIYz9sDMOvy7DbQw/G4f4Pb7qz370RFv0H2Nd2HC3Es55OqgHq9bf?=
 =?us-ascii?Q?QAp04MZinO6jFBpiMogR4riB418ieVrr/YwS2EEvUDPtmajyn4ElIIRr105C?=
 =?us-ascii?Q?9uzInS7TF/ejp1ahzjZnct6HSoFxa4R2IDWkjkSzotga9QysVyo8Vj454UIu?=
 =?us-ascii?Q?7DM5eiWxdug4n0oYj+6IK/eH+3rsjHlUqb7EtV86W7WB+vua5pXBSNrxUHj0?=
 =?us-ascii?Q?bVWWOMSXWhSJZrIvsM9ZYHK4Syg3DKfkBVSiGTvFV1UJvw32hjKm4S7TYulc?=
 =?us-ascii?Q?3eY8ciS5Yxzs35DQB1+Su/JdoONbyzVN4UiOOQqIoxnmaYNNbLMTOZSXNIVW?=
 =?us-ascii?Q?uQVJIm65i99vRRCf/XQYxr8bQkEVZbngo/Yomob5VT8r0ncSPLncLQWj7rh0?=
 =?us-ascii?Q?9C1bHrV6GO2M9VItTU3gS9XtxJ4p/8Klhtxf44PhfC/p18ODL2O7tPErzjIv?=
 =?us-ascii?Q?OtA/bovztkuynwRheyNKDBgIWSwowOXMbbJBzw8Jk6zkQGG1HQWqvuIr25ZY?=
 =?us-ascii?Q?+0aBhCRRQjAFOH3T3qZ5jyCFdOk0I+5cxdNiyeq9GS4RU94Imz4J+57rK0Tu?=
 =?us-ascii?Q?OFyd3vkByk/YxQ7fdNeMDvZRQA/6eyj8b0HuJPpJ1CHmcKBswHd4t+B+tbgH?=
 =?us-ascii?Q?2iv7TT3SkJtLv5osJz/K91qnvmR4KaF5NbCgNilFbZWqlL4x3MKIaq1nsXZV?=
 =?us-ascii?Q?pWstVY/teHohDTc77ZQU0uf2LMvarMB3P/opkBe45AZfoaBurkNKZCKA1bta?=
 =?us-ascii?Q?3JRGXJZCp8RBCvag8uynvOBjbByJGCLkomHE+/ruMNFp+DL3zK3VlnnZ19qT?=
 =?us-ascii?Q?v5gAgkJelKPrfupBcdKBEM9bjRozPoEqoacvXThhTlbh6QTq5aSFuTwXguo8?=
 =?us-ascii?Q?xSojYRcyhJgo2I2uCBKY9AiVTBQP37DatsMTtzjt8GnrGQt2R7UrKyHbg/09?=
 =?us-ascii?Q?PfORPumyzjKkQPlBMN2RDXluGEPLXMgMIuLYTRFh8P7vtGcXAdv0XKIKPYKJ?=
 =?us-ascii?Q?+2I6o9isUtFCWRxGQj6H2nOKB4fATNtxDNYpVwLbg4qKko+CEyig6qxJL1uZ?=
 =?us-ascii?Q?rE44BVmmAWcKRxmsyhBW0JYVZvi+raeUEHv/y4buS9W4SNfWzxuaL65cs8vO?=
 =?us-ascii?Q?rftCnEMUjsZK0ZLga7+Gs8nhq0YU6VkzDb9i5J4Yh+BE1MtMApn4IMQ3x622?=
 =?us-ascii?Q?qfGf3vZOa4Q2+G9I9u/V1D6KzGfL+iemVLRCdfa0QnpZEOU8Iq79sF1ssaNH?=
 =?us-ascii?Q?CDMxqh7Hih6xnrAAU7R8El1A5SR01qIgdGDfF9dkd5T+zk2lfIUXLudY0vy7?=
 =?us-ascii?Q?laKzpBdqmA2RlcrjiRMsiWpdhaUlEAjuiXBDJcLPSvhdXPYovCF4HQ839rf/?=
 =?us-ascii?Q?ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b81aa0f-6e52-40a6-6cb0-08db1280b3ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:39.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTf5k4tIzu5m+DNbvVXLDfF/Gj/xeNHS+BtZBwHcIo9U80wK75YAYhVUTK7NmC6u+eJ8D96zDoJWCQCjPwyfvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
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
v1->v2: none

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

