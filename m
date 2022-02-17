Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78DC4B9DBE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiBQK5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiBQK5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:33 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060D4DF4C
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbpR4FPDH3c2x04hX7ph5zdqxAQLFGuTHCHiRsHlfm5HQCSy0QhNSizQs72L9zHnL8TJ4OVNh/LqkSP+uj6Oeo8zZ6rloj8u02iZeBIR7ZsaxoXmQ5AeWb3N9ehhwqNcXriUEumDvahowsr17EboApcSmWMjbnv1eQBnUMrupxaccg4YsyD/q/9KGHZiA8BO7tL52lfpuUvQugzFbNqJEpwDcKaA+7IIpZWeI72UJ2zKNvw65aXzrb/jkfVbKH7L/6ejBgldrw0MTSRJvTy7gryfeg/Z24gweArYWroqiZpClF6xO0IxBQbyx6mSN9f+nKJcVCJ0vKo8xUzosZQMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JBNQZOzLcWLwZmzkouhinJ/NCK6APcu19xCH8gqkYE=;
 b=B1elp0BjFWJs9YhZwZ2ZJgh+1XjrHLjTWxHiwM2CNBbXMXW3Wjpe+jA/v6P39GKBZwlMCRKcaX8SAeV3y15hwGP3x9eEOahpa6MZ+xVbnJqFTd0EA2Fzey+kHJxYmhak2nJu9QDDXMuEMcImExAWNND1mdU+c0zdgN6a+MZuCLjE0F8YZbSL3Bh0Xuw5JUe3GRRum9p66jSIJl2ujyD94Mja4l3BMQfnzweiyEbQRflnoUx79kme62eTrqgeVz/lLVRAMhFJcfApi4i8uQS79rJfLEE6MtBUCugxm82ESWX4kHL06C70XpuASUeYr/QI51uBQznM19f7eEqqppMthg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JBNQZOzLcWLwZmzkouhinJ/NCK6APcu19xCH8gqkYE=;
 b=abrHrcTC1kZNy/5IC3/ADKIN4fXXGwVWhAn1cAIzhHZuaD32uvhuLEkzkqfErSZS9VUx5s5FcWA7vvZyt/dqcqcxVHbBrj3HgPy1m+VJkIrkOsRS6Cf45s9WNKE5cB1fra1ZrkzL45FP4rVuHy00t7g8XD2g6ufRPUdwKX2LtGU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/6] nfp: add hash table to store meter table
Date:   Thu, 17 Feb 2022 11:56:49 +0100
Message-Id: <20220217105652.14451-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217105652.14451-1-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f554b7b-d44d-46fe-dd08-08d9f20442e2
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1397B94FB4E7D0DF8E17B6CFE8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u//iiBV7krTdcYFOiGx8ag5IpI6pxQCJ7FCQ5z59M+dXLq9vmpg5G62YNvxLuGsXrYshU2h0IHQIkoWmNm6QbwCcckqA4iKQ7PfvqlgvPnfA84K66siYZCh4rrI1HtQCFkx2bO0x97kgjgJGyz0Zu9OBoauYyaPhlgr/M1+2Z3jrPL8i4iAYiOFL0Y/bD0fWIGfklEHTe0mQnNl8GFQzNh3CV7PcOcdvWmPHEYnfcuI+aPD80qUh8apFMvEPSt8JbqMVfo1770q9PBhd3ZzRWCtjdNq+RKKu0FTSm+nN4mYXrmp+y8VurjYjsPKe/Y9clxFFYNZrSEyoGo7n+GYV+i/2ZyWw71ssy7XrQVJ71XRTDKh9ufvNb6qCt+TFBMh/NetngbytgnoVglhHKRyflKJH7U/O16K4uZh+Et2Gf3EfQLVxk3KScb2iAYdHdDiKlBjxUjLDkbf9j8M6aksv+oOHmYNfnNgxfnOOEnnxki97iOewE0aLJT/zf/dmBqRS7k1VHxS/yT1dd1yf5ERbhVWnHqCmh2Y7QCillmwkid3O2alZiqfKQPcHFwApiBSyDbSpRxNVloSPP+Rcm0sE/tpbORKhJbuTcdG578D5fXiRGkgEJGhnZS8q+oKqk283a5EpdxJ0xQtJ12jPxLWcOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jZxclcVY9HqXg7QNf86FBea5eIdZKjyie7a4sgJhmAldT7hNR2R6m4WErIwB?=
 =?us-ascii?Q?H7I5l5iZNnM94CVPhk3VbvUrKvf953t50sBNZVXG/HDtnCU7XpyJUdy/tKqM?=
 =?us-ascii?Q?hj7reaoyh/6vE2OPUNUf+idXliGUZNYDWulp+hPzteezS1p3q7/OtXoJpWRz?=
 =?us-ascii?Q?Wh2X19ZyjCJyg3EMpP0DSXz/jjFWga3t5EaIG3yDPmh8RoYW/Nvr9zUX2sa+?=
 =?us-ascii?Q?a5ipjMqXjFDks9vkgStohQP++hiCE/bq4mD6mZY6H09IQfiqfazBZ6CV9hu+?=
 =?us-ascii?Q?2OnZTRd11nqE+ywKJEf5qG0sL9ygWmaLVt21h2tmLG7wV8g3nQ03r9nHRZNc?=
 =?us-ascii?Q?H2zucbMG+gxYeu0j/Q0ziuEOH6mJ0K8TtHk/BHg62bBC2HxAvcuFN8aE8qgr?=
 =?us-ascii?Q?QYDbCehIfKB83cGXBVIrWoSgJznDEdaXYjBK3sVew2VF56LG3Rq0UyHhWERv?=
 =?us-ascii?Q?sLmtfVtrwYyTPxk3zFk3eFEkeBuIODZjgoQhSHw5aoXgvUbsS1UJ62oaS9ii?=
 =?us-ascii?Q?oZ6qy5SLBb5t4xGh0LdJ+3t2F+KdGUEdnVXwcyjC0TlUsbP9j2ncuUPJuNIQ?=
 =?us-ascii?Q?XtUP1ZSIVy5czBotnJc03joMqlpPfK0uNSGFVi/BFWfyYrf+msnGRYjFjPrM?=
 =?us-ascii?Q?JDryE2p+lr8VX7dXix2CeJ/aw/5pxpmEYOgS51aUZSAdQGwSeDE7BXgc0X0e?=
 =?us-ascii?Q?5mscYuXS+kD0lpyjltWFDpe2Ij6DeB6vedLlfsuXAoxcMuk9PyCTrQHHQgrL?=
 =?us-ascii?Q?XrgXezLGpgOiFnBInv33CZdummFJOtOQNlnyi6EcN2ir8erVRP4OSazVgVXM?=
 =?us-ascii?Q?hoIfIMZjcxC2rlR/Y5SOBUGbt9fQFG6+Vuzehw4CwZdhGuN5zRiNeU/4y055?=
 =?us-ascii?Q?YbLWKdhASt4liIvIb+qkSIKfnEu1Tk/KPe1xfpkGTg2UBTpd9OUSYEybwllw?=
 =?us-ascii?Q?Y8cZYTcSz58dxhHCKBx2mtj7FWSgY/5sQhK4yTCk43AFGocPp02bITsKgqzd?=
 =?us-ascii?Q?5GIwz84P7uOwLhwQ/vUwrdhMxrFG8Mf7hDWjK9jW+8sAAwDnc0C67RhellST?=
 =?us-ascii?Q?btEfxDmHonD7Gam2DsKqkHW26GC64ickDxMKLhWPhEhCO4RDU6o06ipXhstd?=
 =?us-ascii?Q?W6Y36W7T66pspQ4f3XTwrUqDMEW2apv9YhOaxzYOkaJQGg6UWKYVNmCO2gfX?=
 =?us-ascii?Q?NdI81BSOWAl4fOC/15pabGH5crGNpeFiakzkzdZKpGyv7S/V2PrMvAnMR549?=
 =?us-ascii?Q?IHdUlGaCV47N6xyOgUS0eU5oZkl3QP1HXAGPOlkM2lINZI0Lkc9yzrgT6OaI?=
 =?us-ascii?Q?qJmiNk90Ey5ueoKd/kJqwJdj+jrUBkiook4cmdMDLwWc3F4r+gG+YkGRCghU?=
 =?us-ascii?Q?Z5yLV/NBfdoPRgqQfgN6PzsJLmtP7BilbGa/snqqQHqEVCUayrLT6k+MWWsf?=
 =?us-ascii?Q?GI9oyF90hHKI2TAIv0Q0bPIXK9JuGtMrd8L94jtcEMsOyxwgcnwfo22Hdo3v?=
 =?us-ascii?Q?VEDGX6T9VLLSmzKLpLLz+Wlzd8oajjV4NoLq6AXfHm/8faHksDxonf0Te+CZ?=
 =?us-ascii?Q?cgidRsmVRHqPW8mtMlXj9dS2TZkslIty+vHX/OWlN7nLl7vJ/Uv0D0S1o3b6?=
 =?us-ascii?Q?emZ0N5dWNaVMs+kC1YLU2TnIMGxtA9QXqpaA4VGBdl/r39dTOVp1UxkW0nrf?=
 =?us-ascii?Q?R9L1rxb5FOGsbxpiy1XTqwGus80EgSfvwlPEq9iV50FHQAf/O2JLOYO8Dgiu?=
 =?us-ascii?Q?bcKAnBOQt2g+gDtjmhKqWRdJIMUxh78=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f554b7b-d44d-46fe-dd08-08d9f20442e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:16.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82zs47YSmLnd/OFheCHTaTI+P6SpVRoEIJJ+Dpyln1QQHhge8FuAAbTOT5Ymhwy0IZIHB2TfcAbh5QSGTDVFMnNmpAT/YFQZy4d8G2eADIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1397
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
 .../net/ethernet/netronome/nfp/flower/main.h  |  36 +++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 148 +++++++++++++++++-
 2 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index a880f7684600..0c28e3414b7f 100644
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
@@ -377,6 +381,32 @@ struct nfp_fl_stats_frame {
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
+	NFP_METER_SET,
+	NFP_METER_DEL,
+};
+
 static inline bool
 nfp_flower_internal_port_can_offload(struct nfp_app *app,
 				     struct net_device *netdev)
@@ -575,6 +605,12 @@ nfp_flower_update_merge_stats(struct nfp_app *app,
 
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
index 3ec63217fb19..f9f9e506b303 100644
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
 
@@ -478,6 +485,128 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 
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
+
+	if (meter_entry)
+		return meter_entry;
+
+	meter_entry = kzalloc(sizeof(*meter_entry), GFP_ATOMIC);
+	if (!meter_entry)
+		goto err;
+
+	meter_entry->meter_id = meter_id;
+	meter_entry->used = jiffies;
+	if (rhashtable_insert_fast(&priv->meter_table, &meter_entry->ht_node,
+				   stats_meter_table_params)) {
+		goto err_free_meter_entry;
+	}
+	priv->qos_rate_limiters++;
+	if (priv->qos_rate_limiters == 1)
+		schedule_delayed_work(&priv->qos_stats_work,
+				      NFP_FL_QOS_UPDATE);
+	return meter_entry;
+
+err_free_meter_entry:
+	kfree(meter_entry);
+err:
+	return NULL;
+}
+
+static void nfp_flower_del_meter_entry(struct nfp_app *app, u32 meter_id)
+{
+	struct nfp_meter_entry *meter_entry = NULL;
+	struct nfp_flower_priv *priv = app->priv;
+
+	meter_entry = rhashtable_lookup_fast(&priv->meter_table, &meter_id,
+					     stats_meter_table_params);
+
+	if (meter_entry) {
+		rhashtable_remove_fast(&priv->meter_table,
+				       &meter_entry->ht_node,
+				       stats_meter_table_params);
+		kfree(meter_entry);
+		priv->qos_rate_limiters--;
+		if (!priv->qos_rate_limiters)
+			cancel_delayed_work_sync(&priv->qos_stats_work);
+	}
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
+		goto ret;
+	case NFP_METER_ADD:
+		meter_entry = nfp_flower_add_meter_entry(app, meter_id);
+		break;
+	default:
+		meter_entry = nfp_flower_search_meter_entry(app, meter_id);
+		break;
+	}
+
+	if (!meter_entry) {
+		err = -ENOMEM;
+		goto ret;
+	}
+
+	if (!action) {
+		err = -EINVAL;
+		goto ret;
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
+ret:
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
 static int
 nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 			struct netlink_ext_ack *extack)
@@ -514,10 +643,13 @@ nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
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
@@ -534,9 +666,11 @@ static int
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
@@ -546,6 +680,14 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
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
@@ -555,7 +697,11 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
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
2.20.1

