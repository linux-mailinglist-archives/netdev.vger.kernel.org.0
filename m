Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507734C1888
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbiBWQYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242778AbiBWQYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:24:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B63EC621E
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5pqPdQ9TR1tLY0RG4r1CluKa0874DtHksNX99Cmp2EYY8UcEiflZt+bw4HGEk3w6fZDZ18YHIUOYRiMS0lm2yZsQwyg3gBYXa2RIRnlADMSsE7lOldkeYw5KFLf5KXHkiRl7dSLjPigPlDWA9A31tUoAJOjpp0wMzeFoUFNAqAZEE7koR1uzZBct727n3c41vLpe6yznxAPPHQ5shE3RGuFTkmQHXWmxIXkqRGJsSKSz+iD+EHvU9X5K6hbwjr9n201ZWUJASyI5NfNEHPvJEc+m8WxGQOJbASVCrI0fR6go4IPQ0zFZUeoRo1vKXmFEpZVvy/EcHemTaE6jSTabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3I14n7fC4oKZpCkuh40RhGX9g9ESKQahyccWZLSlBc=;
 b=l1FLLAY/H+5C59Jl3cSErCNvw4Oize6fSRvxN+YYM0GHuYC7Y2bZ1V1mmiTmdw/gGvlRAyzn/o2YzRhdR85jhULoHO9Ff78ZLM1/YQND+Qc5+wnMNirdX+1daIjDyfT8FqI/u8VpLMeAGpOvT2Wy4c/mh4KXHi1YnGosWNRi6vaHIVScDrEHhel0bkc/SWFT0C9xAc1pIVKIZkP/WjlUNPV06cGN93C59rfVstnQojwT5+iiXjguEsN33WL8XNX5BSoKjAVhWr4ALxp9jMJKdLlOAgT2hF0bmwhezdnAf4d0omwA1Hbjsyi23JZjEbXi1g7Fbk4z8LvJ5TYnxGNMSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3I14n7fC4oKZpCkuh40RhGX9g9ESKQahyccWZLSlBc=;
 b=CzHJyyW/Z+bV3F9o/tvaKHtmgQqDzxb/leNJhm8gFDfvLJKk69qBjJ87xMuVGB+2njweubhhpVIG5YmHnXrf5gD7eAMpNd1iHS2kfWGWh/YF/48PV4kn9CaZT2babeUPWiRqg/0Qo/DlFM6VdtgGic7G5rE7R3564lanB7VCLnc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 3/6] nfp: add hash table to store meter table
Date:   Wed, 23 Feb 2022 17:22:59 +0100
Message-Id: <20220223162302.97609-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223162302.97609-1-simon.horman@corigine.com>
References: <20220223162302.97609-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38355c0b-55c9-4f6c-c8dd-08d9f6e8d254
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1757338ED96F5F8F8C0D1F20E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5Rj3qw2vfbyBglhJCXc4JEz/EbiSrOl0tQTa3BexuTvw+YEDopNK2xlBCE3AvNLa3aldv87E2fm7uxjy+6qkhTuIafgvWAyYI0SURpTJupGCSt/GJ46NZOiNsYQ+UAs7LYmIhk9eOtgwM2XeGwjvPrpPAimzDsLuxqqeTwEqG2wekaOzUKNTG146ggChXFIGLD+rI5JhpbrclDsYSKXV3ue+3gXKM8CAy0TRRiL2O46TaLxWNzHfvGYptmPUF30Tkc4WrgE+f99IstY00wXaG4sE2l/NzxmFZuaeRd+pD/denkpmOStMddxOp9h2Re0+xPqfrkdIO//mcyE1thNKV1b2n5qf4Bk28zGeHYPmjT1UsEzRXY48s9BXqO8idFQ5XYtyBhjSCQTSvQKeuCwqPT6uSj+cl4GfYRTJAPTbbdeqCTjSHFw3556OXP9lHz2+18VZsgjq0LiG5J+F8jDSXN/aB+zvT8hCEWhWQuElLgbOgAorPAq3uR9PJz8garDwogeZTeakS1c0fNDhNCGa2SAs540k0WFJR10Xy0isbcTwUVgi2y/lW+KN5JXom7zvRzrDMZRBppVo7R1aCAZ3JHhc2X44ivZWkMeMdeDkcS+Hu3tdxZEMX576mafN2cXSxnIck3joAuQyKevzp+C9KsuaWYiFze6G6EgQsX3+Br4tZpe6FT/ukrDg52Gxcjm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gtjFcnt1PaNJkfPdLclPNGGVe7nkaIZIQQwBUMKgr7xijw7tvva0xWSNyNoB?=
 =?us-ascii?Q?grlRMvk9etAsHPlVSlKDxzkqjQIwp1qGVwF4GhVBwJXvAZs87nX+UTEJ4RwU?=
 =?us-ascii?Q?9wtZX64OZeshf0qSrYVONwU8p3ga1ZQDLOVcUFK7yB0dAEU+ybheyK3lwP9/?=
 =?us-ascii?Q?fvSHFkjRIvdcw/EgObRrqamV+9tz5+f3GZyZUydTEBnMqcSDJ9XGnXyAuuE7?=
 =?us-ascii?Q?FKzKOdJzBq8jtDnSKf+EsdAIbKaCKj9Jk+FPN9V5gI7QvXUmobPDm5jw2Rmc?=
 =?us-ascii?Q?NubGnmuVoX0PWZMnZP3Qf/iE0kwGPNPP67ADYf0suXPLEB9U7dlf1xhKMfuU?=
 =?us-ascii?Q?oc9y0pLWwcolDRn8FhFDD6dRI5pWUdQGLzuoDKia2Vdst212EEGrJ0fRGE+J?=
 =?us-ascii?Q?ic5Tk0oOJwjCMO2CU8zrl0xXFjirAQd7p32ZqNmzmwcu49BGDZrDE8em79Bw?=
 =?us-ascii?Q?ZAFSHf1bXalkzrwMRscJLFx0yc0tHNNF7T7+FmmOLvg4crHwXRi5MT0zHgw2?=
 =?us-ascii?Q?vTD5jn+3ggJIlmMf4Xkl/Toqp7sSmE2fSaz68PeSLHDOoc9A3GQQw/r3eA2j?=
 =?us-ascii?Q?/ooXkZjPvlzuymDn80HM5dUFEbEcUj/8gqelXiTKsQ0zUfhBU+ohrT4QJWSJ?=
 =?us-ascii?Q?/geoQkI+t1IUY7jRLMHziGWG82f5VatxNTfiBrFK7LdKcW1OXjGhT9nhy4Sr?=
 =?us-ascii?Q?dDxWW7PhOjlhFdbG8bTHwJ9qvfvEkbH+8Tuk7rjhU1t7Y4j569j2c6LO3mG+?=
 =?us-ascii?Q?PFNyYOxC4J0wSCHi8YdNqsW+2QAfslTFw3wk9/u2s+Zvb92sSU7r/Cudaj1f?=
 =?us-ascii?Q?aWVbbCbUKANvm3HPVnhy6IksrAQBeMO2uI2Ip3d1UD0wt/8o8VLRPCiFKcue?=
 =?us-ascii?Q?F8/GiT4REXeizO0OdEEI79oCX/BW24Ql0ph8nG6DTeucpHsAf2gPZyBqcy9C?=
 =?us-ascii?Q?NEELNTgK4vv3Rr9LFsPHyCI3rtyC/plLwsbj5Ut2o3Mym8df0VMFqTEdYmvh?=
 =?us-ascii?Q?FcSE2HtInQ8WtQm9ipQT4dd8r2aSNouBCwY5nNROfAduux809j+iaUiZ8dy6?=
 =?us-ascii?Q?gKj12y15Oi6uqJbVULJI7YizAz67JFSFBkcPUWsOzYoEeD/O3Z79OliVCQI2?=
 =?us-ascii?Q?zQzqv4f/ooegUqFDlBVNHtUwCH84ZVZlaHAaQZTxnpaa44qU1uShF995PKWW?=
 =?us-ascii?Q?+KWPy32QBJQ2EFol8xeg+elg0X0nP7m+OMcgkvtC2H5B/LFWr3WjnC4gHItK?=
 =?us-ascii?Q?feuULPDywaA0RsR7KfKIwEGGEmsmMY4VK362A9gE83eBU2bQGlnaZ1O8aC6u?=
 =?us-ascii?Q?Q7EDJWcp3pzryPIwc4krfkDXO6FyAPC4FBAXNRzjtFO17TEDcrEtbEMrTe9Z?=
 =?us-ascii?Q?bc5OUJETlnrt/iOnE6oV9KUqYrDq0l0I7DWYCISUMOm87EiRPgWEjArE+SGt?=
 =?us-ascii?Q?SaDjVrnZHBMaGvtUt+ZGCXKMKaFFFcCkz/bYNjkCYkwGHd1W7AEY4qyPEZR3?=
 =?us-ascii?Q?uByAB76FmbanW6H7jP9cyvnZYqWSJyPTQncVMxLSuFzTY82F375sHHxT9eSJ?=
 =?us-ascii?Q?W02djgfXD2QcdMSyFeZBf16DtKY+m7FIM0WMeVsefIsq4KrTyrDIItKQSUJp?=
 =?us-ascii?Q?l5rLj73gqdpnnNi+jJamwYb0ktgH+YI/9Q4qXvH/H6Jp+/+3QdR2eNt84unm?=
 =?us-ascii?Q?bsFilojPAo2+2vND9coRj/YLbYZr2xPCi5IKqmNILT11a3DsvgzZzdPCfCtX?=
 =?us-ascii?Q?vfID4uueLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38355c0b-55c9-4f6c-c8dd-08d9f6e8d254
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:27.4377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8x3MB1YUOuvHSLCENxX5gEu3daPPvHBDJ+Oi/FTFCEwH5PxBJE+XlN57YFrd3vomD43VfVrstkWjnCLLBqI2x2uUCz+sg9k2r65vfzMWpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add a hash table to store meter table.

This meter table will also be used by flower action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  35 +++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 142 +++++++++++++++++-
 2 files changed, 176 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index a880f7684600..7ecba013d2ab 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -194,6 +194,8 @@ struct nfp_fl_internal_ports {
  * @qos_stats_work:	Workqueue for qos stats processing
  * @qos_rate_limiters:	Current active qos rate limiters
  * @qos_stats_lock:	Lock on qos stats updates
+ * @meter_stats_lock:   Lock on meter stats updates
+ * @meter_table:	Hash table used to store the meter table
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  * @merge_table:	Hash table to store merged flows
  * @ct_zone_table:	Hash table used to store the different zones
@@ -231,6 +233,8 @@ struct nfp_flower_priv {
 	struct delayed_work qos_stats_work;
 	unsigned int qos_rate_limiters;
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
+	struct mutex meter_stats_lock; /* Protect the meter stats */
+	struct rhashtable meter_table;
 	int pre_tun_rule_cnt;
 	struct rhashtable merge_table;
 	struct rhashtable ct_zone_table;
@@ -377,6 +381,31 @@ struct nfp_fl_stats_frame {
 	__be64 stats_cookie;
 };
 
+struct nfp_meter_stats_entry {
+	u64 pkts;
+	u64 bytes;
+	u64 drops;
+};
+
+struct nfp_meter_entry {
+	struct rhash_head ht_node;
+	u32 meter_id;
+	bool bps;
+	u32 rate;
+	u32 burst;
+	u64 used;
+	struct nfp_meter_stats {
+		u64 update;
+		struct nfp_meter_stats_entry curr;
+		struct nfp_meter_stats_entry prev;
+	} stats;
+};
+
+enum nfp_meter_op {
+	NFP_METER_ADD,
+	NFP_METER_DEL,
+};
+
 static inline bool
 nfp_flower_internal_port_can_offload(struct nfp_app *app,
 				     struct net_device *netdev)
@@ -575,6 +604,12 @@ nfp_flower_update_merge_stats(struct nfp_app *app,
 
 int nfp_setup_tc_act_offload(struct nfp_app *app,
 			     struct flow_offload_action *fl_act);
+int nfp_init_meter_table(struct nfp_app *app);
+
 int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
 				  bool pps, u32 id, u32 rate, u32 burst);
+int nfp_flower_setup_meter_entry(struct nfp_app *app,
+				 const struct flow_action_entry *action,
+				 enum nfp_meter_op op,
+				 u32 meter_id);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 95bc71b4421c..160c3567ec99 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -1,7 +1,11 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/hash.h>
+#include <linux/hashtable.h>
+#include <linux/jhash.h>
 #include <linux/math64.h>
+#include <linux/vmalloc.h>
 #include <net/pkt_cls.h>
 #include <net/pkt_sched.h>
 
@@ -440,6 +444,9 @@ void nfp_flower_qos_init(struct nfp_app *app)
 	struct nfp_flower_priv *fl_priv = app->priv;
 
 	spin_lock_init(&fl_priv->qos_stats_lock);
+	mutex_init(&fl_priv->meter_stats_lock);
+	nfp_init_meter_table(app);
+
 	INIT_DELAYED_WORK(&fl_priv->qos_stats_work, &update_stats_cache);
 }
 
@@ -478,6 +485,122 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 
 /* offload tc action, currently only for tc police */
 
+static const struct rhashtable_params stats_meter_table_params = {
+	.key_offset	= offsetof(struct nfp_meter_entry, meter_id),
+	.head_offset	= offsetof(struct nfp_meter_entry, ht_node),
+	.key_len	= sizeof(u32),
+};
+
+static struct nfp_meter_entry *
+nfp_flower_search_meter_entry(struct nfp_app *app, u32 meter_id)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	return rhashtable_lookup_fast(&priv->meter_table, &meter_id,
+				      stats_meter_table_params);
+}
+
+static struct nfp_meter_entry *
+nfp_flower_add_meter_entry(struct nfp_app *app, u32 meter_id)
+{
+	struct nfp_meter_entry *meter_entry = NULL;
+	struct nfp_flower_priv *priv = app->priv;
+
+	meter_entry = rhashtable_lookup_fast(&priv->meter_table,
+					     &meter_id,
+					     stats_meter_table_params);
+	if (meter_entry)
+		return meter_entry;
+
+	meter_entry = kzalloc(sizeof(*meter_entry), GFP_KERNEL);
+	if (!meter_entry)
+		return NULL;
+
+	meter_entry->meter_id = meter_id;
+	meter_entry->used = jiffies;
+	if (rhashtable_insert_fast(&priv->meter_table, &meter_entry->ht_node,
+				   stats_meter_table_params)) {
+		kfree(meter_entry);
+		return NULL;
+	}
+
+	priv->qos_rate_limiters++;
+	if (priv->qos_rate_limiters == 1)
+		schedule_delayed_work(&priv->qos_stats_work,
+				      NFP_FL_QOS_UPDATE);
+
+	return meter_entry;
+}
+
+static void nfp_flower_del_meter_entry(struct nfp_app *app, u32 meter_id)
+{
+	struct nfp_meter_entry *meter_entry = NULL;
+	struct nfp_flower_priv *priv = app->priv;
+
+	meter_entry = rhashtable_lookup_fast(&priv->meter_table, &meter_id,
+					     stats_meter_table_params);
+	if (!meter_entry)
+		return;
+
+	rhashtable_remove_fast(&priv->meter_table,
+			       &meter_entry->ht_node,
+			       stats_meter_table_params);
+	kfree(meter_entry);
+	priv->qos_rate_limiters--;
+	if (!priv->qos_rate_limiters)
+		cancel_delayed_work_sync(&priv->qos_stats_work);
+}
+
+int nfp_flower_setup_meter_entry(struct nfp_app *app,
+				 const struct flow_action_entry *action,
+				 enum nfp_meter_op op,
+				 u32 meter_id)
+{
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct nfp_meter_entry *meter_entry = NULL;
+	int err = 0;
+
+	mutex_lock(&fl_priv->meter_stats_lock);
+
+	switch (op) {
+	case NFP_METER_DEL:
+		nfp_flower_del_meter_entry(app, meter_id);
+		goto exit_unlock;
+	case NFP_METER_ADD:
+		meter_entry = nfp_flower_add_meter_entry(app, meter_id);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto exit_unlock;
+	}
+
+	if (!meter_entry) {
+		err = -ENOMEM;
+		goto exit_unlock;
+	}
+
+	if (action->police.rate_bytes_ps > 0) {
+		meter_entry->bps = true;
+		meter_entry->rate = action->police.rate_bytes_ps;
+		meter_entry->burst = action->police.burst;
+	} else {
+		meter_entry->bps = false;
+		meter_entry->rate = action->police.rate_pkt_ps;
+		meter_entry->burst = action->police.burst_pkt;
+	}
+
+exit_unlock:
+	mutex_unlock(&fl_priv->meter_stats_lock);
+	return err;
+}
+
+int nfp_init_meter_table(struct nfp_app *app)
+{
+	struct nfp_flower_priv *priv = app->priv;
+
+	return rhashtable_init(&priv->meter_table, &stats_meter_table_params);
+}
+
 static int
 nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 			struct netlink_ext_ack *extack)
@@ -514,10 +637,13 @@ nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 		}
 
 		if (rate != 0) {
+			meter_id = action->hw_index;
+			if (nfp_flower_setup_meter_entry(app, action, NFP_METER_ADD, meter_id))
+				continue;
+
 			pps = false;
 			if (action->police.rate_pkt_ps > 0)
 				pps = true;
-			meter_id = action->hw_index;
 			nfp_flower_offload_one_police(app, false, pps, meter_id,
 						      rate, burst);
 			add = true;
@@ -531,9 +657,11 @@ static int
 nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 		       struct netlink_ext_ack *extack)
 {
+	struct nfp_meter_entry *meter_entry = NULL;
 	struct nfp_police_config *config;
 	struct sk_buff *skb;
 	u32 meter_id;
+	bool pps;
 
 	/*delete qos associate data for this interface */
 	if (fl_act->id != FLOW_ACTION_POLICE) {
@@ -543,6 +671,14 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	}
 
 	meter_id = fl_act->index;
+	meter_entry = nfp_flower_search_meter_entry(app, meter_id);
+	if (!meter_entry) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "no meter entry when delete the action index.\n");
+		return -ENOENT;
+	}
+	pps = !meter_entry->bps;
+
 	skb = nfp_flower_cmsg_alloc(app, sizeof(struct nfp_police_config),
 				    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
 	if (!skb)
@@ -552,7 +688,11 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	memset(config, 0, sizeof(struct nfp_police_config));
 	config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_METER);
 	config->head.meter_id = cpu_to_be32(meter_id);
+	if (pps)
+		config->head.flags_opts |= cpu_to_be32(NFP_FL_QOS_PPS);
+
 	nfp_ctrl_tx(app->ctrl, skb);
+	nfp_flower_setup_meter_entry(app, NULL, NFP_METER_DEL, meter_id);
 
 	return 0;
 }
-- 
2.30.2

