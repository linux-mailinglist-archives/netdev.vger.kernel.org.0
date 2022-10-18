Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E7602E37
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiJROUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiJROUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:04 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00079.outbound.protection.outlook.com [40.107.0.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8804D17D;
        Tue, 18 Oct 2022 07:19:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4xziIUBuBaGktzomrzJda0hucjb86b5mP5kqlSeVPklEZcoJPcEh1QS6pMwqBIKlVwPxG/wpQpEVYma9m40Aw9/n3f3OIaLLwdBmo0CUz8mJgvR37hxDOGDbfNJtKgShrTu9B2NJI2OjiL1RqECd4Oo5k4IfnfIKogIUau8t1wPMQ0pH/g2kkC6lUIh3++0dM9D5MyD/tPF0lNiHRXds9tUnpasJ7Bm7lqcagbZ1UsO6lJn+W3c86VS8WMYMkwAooI1DQG7VGmq1NHThwZjRYb2K4TkdJSMCTtND0QbTRIH7w++ozsBM14furT7gW994mhk1jdhOeALG4zDLqhvHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC0C739Qi88v+Z19lx7Ru9rwWXQ3k8zsB0B3ffB/ZnM=;
 b=ed5x07MVGYB4oUcbKfoFrhh4IecSFBoDfRb5oDVJeeWH9T2zBnLTa7QHxc+gvXPnaI6MoemLSZyXrI66x71Qd5K9mTmWUDRlJVL35s95abMe+VARV7bduiS2/j7ZVd/iAOctYXQNgCvglkKI8KTZwQgp1ezfJ9nNd6grUaa5s3goPaUazatDDTfucqLooyI2uYtKgXD9Xanoo4RY0ikJ27bsLzjzcwmQ3GEL6uATE0J7xFRh/AwJE8ZdbHCz0cqaCHwNE+MZAdW09NEMLsAURz3Gk9yrAMammJgLydKO32s9mq8/HIlJDFsYcu6jS+G6cKwOKHGqZNa64WyG1cX+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC0C739Qi88v+Z19lx7Ru9rwWXQ3k8zsB0B3ffB/ZnM=;
 b=UC/VsJOoCEQ6BLBeGCZU6o4QQhXEsPxSkXM2ZHPp5f7ZL38OUrB6Z7GaJRHGIqyJ8LoR5sCYejiNzkXEKWP0qs8C4oie2s6HIzQN//9hk8Dt0nefzuI9JS16q+3tf/MCdwAfzSg3/kQI/yK9FTC54u+a11gM/bFU4oyZUJhzezM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DU2PR04MB9145.eurprd04.prod.outlook.com (2603:10a6:10:2f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:37 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 06/12] net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN pools
Date:   Tue, 18 Oct 2022 17:18:55 +0300
Message-Id: <20221018141901.147965-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DU2PR04MB9145:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3dc672-e785-4ce5-802c-08dab113c94c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWYCf35kG8Bm1V2qsqgU3kjm8Biya1wADyXnyY9GE0D6SgR/g51oCGK3SMQ6abcGTZUrvZnwMciNZ+o/3g+7HIKZCykZDFLYp73AvRZDx+oErnNp5gfVCFGeaExEGPd3op6xQWvJ6Hf85Wcir/CqN0mSsKttOyDLMuiPyePOjGEOryO0IehCY719S/P4LSse9HND7CS01IkzSWGSJwQLBWelwCvQH6A3A6N2R+rK1d7m8HXPBQaJXOHLcoyHwtvWITcszzPJxddoUk+R2XJmrG7k+pdDEJSi9bpCzThxlUZ3gsIsUhGz7pYGVQQXOjkZXM51PmhgIhSIvYp4qEWSuHl/8wLGc9Y0u8WWutjtpqzfzWaINbBPSQXTB9W2vCnstf5cD9dZsXel2jcFSXIsoTkuHCowV8HGfG45aOwhQMFt1UBQjOWTWl1VPNJs5W6HxOhucCXiAv5DhSWQ90Diyq/U9XZAAC3bcNVQaOHdhS49X8Ha+YvdAzznlapuDjnQUezTaihBV9Ns34LSHsJZOb6e7rwwZS3V+OPNero7M4zl2UVBqOmudUThJaLCXYJ88cvQzmx7jOfNSKHxiGwS6N1t86wtN7BAQYiDjnCsKYwyExioSm8OzrAKz2bBiq/EP5Myd5QNyXUGcSCSFsPGF2cvnR/mKHrRZxoa3WkhvUYTDqCzXRf7Aa8ycpB3eOarF00AJFNlvGTK22jiHkCcwUQ8wcHl3tV2HaWJKfWhs80fzbE4PX+XTgJu+e5sgey8r3GIXqqp57/lA3tLg8hh+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(83380400001)(110136005)(6486002)(54906003)(6506007)(478600001)(26005)(36756003)(2906002)(44832011)(6512007)(38350700002)(38100700002)(316002)(4326008)(6666004)(8676002)(186003)(66556008)(15650500001)(52116002)(7416002)(41300700001)(8936002)(5660300002)(2616005)(66476007)(86362001)(66946007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lvgnn5wUcAm4/HVBQz6KOwePv6lpJ/6XaS5CCwUFO/YWVgTczyQdcHd4Py7L?=
 =?us-ascii?Q?YzPZb7QFumBLgk4bEFGpo79EIViOzGEhl00FReYc7jUi1Nv7S7kUictuf1JS?=
 =?us-ascii?Q?G+yKs7RK2MxIjIvUwLUWxi1HRGQbkKW6eP3zXmw9OPOppsTp38oguOsFa3TO?=
 =?us-ascii?Q?RxwojpaA3ggLtlifeYfzfauLP6YmGhDoguBLSIwiJRVe76AYyIQXUQlvLxez?=
 =?us-ascii?Q?ZvJ3fpBhfjJRO2LaZWAR6MxiQYeW0qCoZh07v/1icylwoo0mb//RDgFAthOo?=
 =?us-ascii?Q?O+4WSjw8jMjZ42UAMZlW6TeLf/aw6csuWCSbusPH0fShVzKC6Rd8L6IDoU0L?=
 =?us-ascii?Q?45NkvIv2Jfssow7kFXrnc9qZTt6wvItvdhtnGM/Mj2ISdbS7b7VyXBwAPENp?=
 =?us-ascii?Q?PeIBYengXmoCZe/QUDZWCgkY+ZIm2HeHNcB1eGSQ7t3N/jmK3vR2zMxAfsLS?=
 =?us-ascii?Q?IyqQM5NlxVWWaGmeHULsm3ctt0qL1dDlntZQpcsgxuusaSAlMgH39hkwpQeC?=
 =?us-ascii?Q?ZyLnteiThOsCQawA56bG3r8RlKx/C7ZAePI5Jh30H33eTFSz49lS0heOHfUl?=
 =?us-ascii?Q?Fcs+ozc24nyQ/1hsX9j/qXnwbN36DHjIAxyQceCpdDu+1zXM/eVZGAJ96C6j?=
 =?us-ascii?Q?30Irq6qDw0oUfqDTJWBAr7tVRQTspF2AkMGg8OCUmObNidFN7bQwLW+7doBY?=
 =?us-ascii?Q?rZbAXLmRORtbPy95mLT/mQRRrNr3YP+57//8IACucFpTpAwg5CMywnaeA+Li?=
 =?us-ascii?Q?6e5qfZKcl93QwHnyXPxbYRZFy6EOBnvVMEloseoZ+8RYFfy7MIjx6v+tVFm7?=
 =?us-ascii?Q?FO0VwrqgfvGug1QZhsmJ3HQzzKgmILTSMDJ2LTjRHeUSCIX43sK8yTZjiNmO?=
 =?us-ascii?Q?TuMPLzAlThB0C8ELwZWB6FBAzRuhGTMq/gTxpHxYxgJLEblbupIfIy7KrqWe?=
 =?us-ascii?Q?KxqRqA2iCA/jpR/u7/MtaPyCnftfDauXPUMHSEMy+pAPK2uI1ldPzq05lmUd?=
 =?us-ascii?Q?FCjA1eC6FQ8s1aBWXsnUV9W95y4PA6ubzKNWufHS5YvExOyN/D/AOUx8cWnU?=
 =?us-ascii?Q?mpSO511JnonBwNCzpkzweFeMyz2dz1uK/bFG7UyDXr9GXt+qXXauXV59H9aS?=
 =?us-ascii?Q?IzHhzyiOSHXP8AhT6OIU6ane6D1nD4mmnP3u5mQevgGQRKXVPTYm8c/GbVnc?=
 =?us-ascii?Q?ZWVq2gnGz+YIl3p72Qtx5oVJNScLxqCfbrhuz8Qsy1MpqgCZzwTYz7ZPA3Ya?=
 =?us-ascii?Q?wUIBCBPRsW7FlEcpPhx1CTKlBiXSEBgEbp4FN9bsQGDVxD515eFzl81z9Kvn?=
 =?us-ascii?Q?y7oEJvwRWd83zGREG1EKz/kAf/CalBoBn2K8STgUFXZm3mieMkOAUlgY+eN4?=
 =?us-ascii?Q?/XwC8iQmLVobtDdcCcXB75WfBN4qN3jny7ff6xl9GFBNi8mh/Ji7SVmhBS/0?=
 =?us-ascii?Q?CpPr3n9jRzpbHGN/hLw3zMWHNropdj5+0wSg0JDKryhhh4KqFkJcBuuRygOB?=
 =?us-ascii?Q?a6Jt3vJ/MLg8l85lOiacNQW1pmArwFaDcT3eykHZad1OzkjSIrVIw0pGc0Ju?=
 =?us-ascii?Q?cPweruqYz74v50BGKwh45wkonXWn4CIHFD4D7ZK6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3dc672-e785-4ce5-802c-08dab113c94c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:36.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZIbBl6/wGmOKr6ktl8xPJYWgtAM7LA6AoaKZMjnH1uGPdnoIiO07CUk5jWiVXSUa0niQPR54uv4yVWD5rdsmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9145
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
Changes in v3:
 - none

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

