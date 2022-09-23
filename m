Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E875E7EE8
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiIWPrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiIWPqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:53 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F246240A2;
        Fri, 23 Sep 2022 08:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL49ZgnTTgZDm+RyREqXas3YSjj5SxjjO/aHdbjO6Y5o/rgmDy/r/j06kVdRtJIhZ/Sog4wXwJxLF5xrhUJUXVIvCiV5cSJjBixCLgQWKVC8OhnkSAogtpkF3Xnzd5BXQIsqqV40JZL1i1djo8k+G46zF8X/eKmpijtNcx0QznkOVv14tTkF8TxEfYg/+0blIyZA6z0iIFXRyc09jA4aiVlEkSp/jB7bBMZQiz9T/6yzFb0RQtmSK2FWuoTFvrcscOOg0tqZfaMNt0kHc2O/kHSBL7Li2zD879ckQPJnAvM8bW4fg26HLYVnHSNoojoz651O8xvLYXkwNeP9+rrCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9y4Qo8C0vtJLh4LC40sqwMcAf3H+YGDFicH+t5pvvg=;
 b=Kyjc0yjMNubO3NNb9IZdIxLxFvwf8y6jnzy1iVNEKaBHMeu49HUGsX2XUl1EQaarENCAXoqhZNB9+IsEVRUXgxHnCArwo4FWYfJ8qheLzYkzPJZur4LEgSe58AapNNkZpCIISKqAL89Xr9RNXortl4jYf9ITp0VhPFpEG+eJ/8Dr0dHPBA4KggeeuqG9FDmVsIqKXWcy7GJRPZ90D8FFTSBUrEO0knJBnghR2XS1GhhMgA7bfPiIDnZ4EHbQ0mD9ORbF9/oukLSXreEMsg/Zu17fZEDatVkCISdNmEG6xzBYw00GKRd0YMqmFwD29/oBr4HU0uW1xfVoh8tmvmbe+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9y4Qo8C0vtJLh4LC40sqwMcAf3H+YGDFicH+t5pvvg=;
 b=QGyd87YNH2ZhI0/hK+2DemE5jgeRx3Of1WiylRRR+QA13MtKpJkBqU3YmAXVCiNkwIJrjhmVp/42H6He5O33nPGAOzMpJahfOgNAPipYJpdKlaRRUetdE8OSNULj8Z+hmxIgRq5OV05gPkAijXKxNRylQ2U7neztCzdIt4RF3ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:46 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 06/12] net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN pools
Date:   Fri, 23 Sep 2022 18:45:50 +0300
Message-Id: <20220923154556.721511-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a563e02-6265-41cd-e55e-08da9d7ad20c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AafCkKoIo5SuclbWzrp7Vb1hJdutM9KbnD280ae+05Zw8xVDdKNPd3jHkLigtpw5oeprzz4r6fqamS5LM+xLt12zftui0W26OktAYpSlBx99RDr+ArKmGg1E0TgjAAZc/Xnb77NtryQ5ooPZIGq1gHGhhV2zcFOr06zPI6SFfHENg3Y90a3hRx50XdVZsg9KQQduHifcARwovWLRkQ1OH0ixg1TanIAIkKteDsA2kf4CgZ5usHU/0nEUkl8M3/UrDeDAng5gXZZDG+4D1Y9vS/ch/ueqOqxP7N0WJ5ExLmnQZAOB2IPrnKriK0a8fcMW60SpKd8pCvXckNzabcQLMUE4wLogi07YO0UZBJb/1mEy0JHDURi9Lp2Qaxp4gChSYL5NMmeIGiNqAx98vrwXWD7WaFcnCtMzeMlLl4PEZE1usL/jVk0jMlzY9JMjCa7YsH4UsycP2XqkVOiAEx9OLGUvTpgqmeEb3FARFKGG70fIptf5OGn5mncLgs+Zr1qbSo8G0b7Jc3+SRkJPx65U5qTX9fn+SfuogUB5HQW4jANENRkySuRIvxJOXUUyOt7qDU0i3vJv1SuqXor9W46TctDYcNsihEuxADXKBBgWlekWiTUys5EMhvvd01jd8K/RemQfUuq86Ce5DnKlQH/Ebd6ek0y2TMA54AHJ4uitpMxhbVGlxrR8ZSYZSTfuT20qyvJ1/GDcDC0kaHALNKjatAZtvtCPNOnNykj3UBusz/Joa3yGf3EKJP9/urbd/PdAp9lrLrR6bQ6LSLrSuC9T+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(15650500001)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(6666004)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xdwwJy3yvt6vjfAccnzORz/2lWL4HBkEIga3gp7PDZ26yyeKYdW4AgkGWQvi?=
 =?us-ascii?Q?lxiIobSc0WbyIWIFJFiAd4lrDe2d/pxiMEZyEY4us35ziZ1wwYXA2aNVip1L?=
 =?us-ascii?Q?PQ5KfPcA9MoC0FtebOVyaBwgWGeWc3SUJ+RN5z2pGnsu15hk2YcPEDXMdRey?=
 =?us-ascii?Q?36pIa7WJFfGGwMHnCWtBEc+gkxj+5O2AJbgZZWoTCWXgHn7B/1w3THLqKUJt?=
 =?us-ascii?Q?e4i09xhw9P8wo+MTSQgG1yTFkHbUXZAVDEpBCBJaI7m9ybI1xIIH1Ssb1IC7?=
 =?us-ascii?Q?70/i/06PmEr/DV+en/Q5cmlMN5znedKA/aykHbPjnvvd93rLwccF0yo6+zF6?=
 =?us-ascii?Q?WPnGewULMED1vmjyZascvOY2pKBNeGKw6QXQslxcS1+oDQQbQe0bDimr8JOw?=
 =?us-ascii?Q?70rZ+3W7Am1KxlFvy7Bd1z00yASkXg5IHSEj/V9CdE9CGlZhSwMN7ck8qH+2?=
 =?us-ascii?Q?EYjVQQ9Ureen2YXwbYG6Q+VRDen2vdfUTA/gS9nYMqay2veRnQQgkYwb4cpi?=
 =?us-ascii?Q?cbQMdyTySXscisql7U6Zu2P2Yzgrlxf3/9gs2VQLsdz5jaeskyCVVG1pV1aC?=
 =?us-ascii?Q?/Rv7AB9jhW/Xk9KWDJ4MPxfG+eUB6pH5wTYZ0Gb/je4LoRNg3X4CAsYQqBjI?=
 =?us-ascii?Q?YkxjE42cHgjp/MSKpDRFcCfKb1eb61I9m8v1yLiX3SY3dtWF8t3NBFvATOAp?=
 =?us-ascii?Q?bRuryLqHpfGy1AUpHYyC+HKJYNb57M0DiQTOemiwccKouBPZfkGfZb6ZqNRC?=
 =?us-ascii?Q?9VLtQwN5AvkIfay6H8dB8l9SjZg31zKSKV+vc2qy6q4QvsKMjNm2TVR/Xwrv?=
 =?us-ascii?Q?iP8rUaLas+oNfLG02tgp4HRpHLu98xqDzNQ4DP6wVyFI1btQ29a4B2BvSJhX?=
 =?us-ascii?Q?pYy4nvl4FARFR41elCQT/4jjjBLDDOxQgmqNTpA3Su4M/UunmU70TqTwyS6M?=
 =?us-ascii?Q?4BMK4bFkY4StbOdmqQfg5iX2d0eidGbCzuBog5KHnXgvwvS7VkF0RygahhxR?=
 =?us-ascii?Q?dTWbJA7YLQeho2NL4t+3kL61Itz8k9OyxpE1HFsRXfTJsUeZjiTszttB5aLu?=
 =?us-ascii?Q?isjXEzF1gK3S0sLg1UvlvauzJMH3IK83pPhcJoJBJhbA96/beYj0VYaTdQKF?=
 =?us-ascii?Q?A4ZLsHt2zKbqSf6x8XcSPTQoUdG0eHzbI3WhIlXSuLGSnct+KBbh4BNsOWw2?=
 =?us-ascii?Q?zHTL8S6xtikUVv3qdI6X6NhLp22Ny7mRv/S8IFqaGBs4fW/d1jLCouiEhfrR?=
 =?us-ascii?Q?f4gVHRlYakdXNmsHOT7YjFrnbmeKphy6qThEbgiml8R6IDAGV0Rjn0tRIbdB?=
 =?us-ascii?Q?M5LtJM2jRApx4YN1HnpPTRJBAexSkNgUn4D4OwAyL5fItxTlmBCmj7b8J4IP?=
 =?us-ascii?Q?1bfkxin/sWQN6nj0na58Tyw3mmX4tn9WeLRidCrizrkt70z5gQw8DtfWRJ81?=
 =?us-ascii?Q?ZyjRxIxiWu1Ap/ypY5M1gefwUn052L6wJHdTZ4aecB8ynTt52Z2UShkOwf/V?=
 =?us-ascii?Q?7P5U+MF/2ifDHzuxLbYrbST7PQo2NoYys+QtYd/HOPmdAC/W+UA2okipzicJ?=
 =?us-ascii?Q?JhatYPKuRUY5DcR7XSv62Ii+WQp8/qiiz3FSnIl0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a563e02-6265-41cd-e55e-08da9d7ad20c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:46.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m93rlD5Alvd5BfzM2AykOoygFah8rvU/JiPFEW9qD+7RAAwxdUgaADlmbPPSXhjjXv/EmGTzasDmY+o1sOp5Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

Update the dpni_set_pool() firmware API so that in the next patches we
can configure per Rx queue (per QDBIN) buffer pools.
This is a hard requirement of the AF_XDP, thus we need the newer API
version.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - use __le16 instead of u16 for the dpbp_id field

 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   | 19 +++++++++++++------
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  9 +++++++++
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 828f538097af..be9492b8d5dc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -13,10 +13,12 @@
 #define DPNI_VER_MINOR				0
 #define DPNI_CMD_BASE_VERSION			1
 #define DPNI_CMD_2ND_VERSION			2
+#define DPNI_CMD_3RD_VERSION			3
 #define DPNI_CMD_ID_OFFSET			4
 
 #define DPNI_CMD(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_BASE_VERSION)
 #define DPNI_CMD_V2(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_2ND_VERSION)
+#define DPNI_CMD_V3(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_3RD_VERSION)
 
 #define DPNI_CMDID_OPEN					DPNI_CMD(0x801)
 #define DPNI_CMDID_CLOSE				DPNI_CMD(0x800)
@@ -39,7 +41,7 @@
 #define DPNI_CMDID_GET_IRQ_STATUS			DPNI_CMD(0x016)
 #define DPNI_CMDID_CLEAR_IRQ_STATUS			DPNI_CMD(0x017)
 
-#define DPNI_CMDID_SET_POOLS				DPNI_CMD(0x200)
+#define DPNI_CMDID_SET_POOLS				DPNI_CMD_V3(0x200)
 #define DPNI_CMDID_SET_ERRORS_BEHAVIOR			DPNI_CMD(0x20B)
 
 #define DPNI_CMDID_GET_QDID				DPNI_CMD(0x210)
@@ -115,14 +117,19 @@ struct dpni_cmd_open {
 };
 
 #define DPNI_BACKUP_POOL(val, order)	(((val) & 0x1) << (order))
+
+struct dpni_cmd_pool {
+	__le16 dpbp_id;
+	u8 priority_mask;
+	u8 pad;
+};
+
 struct dpni_cmd_set_pools {
-	/* cmd word 0 */
 	u8 num_dpbp;
 	u8 backup_pool_mask;
-	__le16 pad;
-	/* cmd word 0..4 */
-	__le32 dpbp_id[DPNI_MAX_DPBP];
-	/* cmd word 4..6 */
+	u8 pad;
+	u8 pool_options;
+	struct dpni_cmd_pool pool[DPNI_MAX_DPBP];
 	__le16 buffer_size[DPNI_MAX_DPBP];
 };
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 6c3b36f20fb8..02601a283b59 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -173,8 +173,12 @@ int dpni_set_pools(struct fsl_mc_io *mc_io,
 					  token);
 	cmd_params = (struct dpni_cmd_set_pools *)cmd.params;
 	cmd_params->num_dpbp = cfg->num_dpbp;
+	cmd_params->pool_options = cfg->pool_options;
 	for (i = 0; i < DPNI_MAX_DPBP; i++) {
-		cmd_params->dpbp_id[i] = cpu_to_le32(cfg->pools[i].dpbp_id);
+		cmd_params->pool[i].dpbp_id =
+			cpu_to_le16(cfg->pools[i].dpbp_id);
+		cmd_params->pool[i].priority_mask =
+			cfg->pools[i].priority_mask;
 		cmd_params->buffer_size[i] =
 			cpu_to_le16(cfg->pools[i].buffer_size);
 		cmd_params->backup_pool_mask |=
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 6fffd519aa00..5c0a1d5ac934 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -92,19 +92,28 @@ int dpni_close(struct fsl_mc_io	*mc_io,
 	       u32		cmd_flags,
 	       u16		token);
 
+#define DPNI_POOL_ASSOC_QPRI	0
+#define DPNI_POOL_ASSOC_QDBIN	1
+
 /**
  * struct dpni_pools_cfg - Structure representing buffer pools configuration
  * @num_dpbp: Number of DPBPs
+ * @pool_options: Buffer assignment options.
+ *	This field is a combination of DPNI_POOL_ASSOC_flags
  * @pools: Array of buffer pools parameters; The number of valid entries
  *	must match 'num_dpbp' value
  * @pools.dpbp_id: DPBP object ID
+ * @pools.priority: Priority mask that indicates TC's used with this buffer.
+ *	If set to 0x00 MC will assume value 0xff.
  * @pools.buffer_size: Buffer size
  * @pools.backup_pool: Backup pool
  */
 struct dpni_pools_cfg {
 	u8		num_dpbp;
+	u8		pool_options;
 	struct {
 		int	dpbp_id;
+		u8	priority_mask;
 		u16	buffer_size;
 		int	backup_pool;
 	} pools[DPNI_MAX_DPBP];
-- 
2.25.1

