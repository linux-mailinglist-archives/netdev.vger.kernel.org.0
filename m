Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC663F1D79
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhHSQIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:47 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:64993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233775AbhHSQIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwu8hqeCtCARUZoTwow0l5ZBXQsq+VnVW7ivsSnswKzR+G//fuNpTUgY4M2OBZhGObzupqMMpkXr3ggH0a5cTmHhqMXUKM+Z/NiZL1NJPLqXzBKOFiL4nI8SH2NIl2AXJKL/N1XVbbe6ZlchDvLRxXdR/pK5h73Mhgda0WgKLy/li6J6ELLlJPhXH63LcHg9DuKrJ9y8bDUdpFI13wNGvnISW6gvJzHxfLcvXPAlVV91KcNnsYF0EuMJaexoTTAhUgzDdS9bQm6/CttGLHowYgKAuFI+/DX/JxQYthaNOif6AiSIt0loteviNRHErDBWvVZnAr1ljkAT1YxgWElivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSeQrhhCbH++pHC+OWvYkhnt60HoMDgsU19qU8cy/8=;
 b=ZgBJB8FDhpzxYRISUpy21m3sERYzmva9ytTJFVhEU+BTpUQ6vtYD7/vl3KC/10HQ5ybEVcI5ip8J00cTlQK13W2ijO6IkWxUEgDV6I1B7ajisOF0XG19u7b1VRFZ8YHq29JOzn0wdogbLceE6kW3PUmbRLTjDydq1cgCN3juAUV5hdnZoo8FRP4fqci7LjPhlQ3UjFd8Un9OFg9PNGMGOWoheOTlb4m/6KCxXQ5Vvzi6hBJy0Lh3eibTX/isc24ucf908mi3tMgTZRixc4IWwpqP0T6VIft7/l/+OBjATOi97vxXz62KMfRVUz8jIaItvdqV6d6DYamViS17O3FQJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSeQrhhCbH++pHC+OWvYkhnt60HoMDgsU19qU8cy/8=;
 b=Ai4hGXamjyM0Iniayi2BBYO8TM5MN6pzTfpxRHe/rdyIr4FgJ92MOVYFEYKMMrQ7xtgtLJaJW2j4tNR+jS84aUqjbE2F2JDFTZ6XOpIDBXe6QnS7KLonGc6v1HsgMIUzmCauhLiNHOxMn11PDIRFw1dts1LjiFOw7HCtXOSZxtA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:07:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:07:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 2/5] net: bridge: switchdev: make br_fdb_replay offer sleepable context to consumers
Date:   Thu, 19 Aug 2021 19:07:20 +0300
Message-Id: <20210819160723.2186424-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:07:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4eb84f5-0782-4553-a82d-08d9632b8198
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB626990374706820251912A71E0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Piy5jBhgJc0YB2WnyvQeSQ8ZvttYYLw6UPY1Ej6O/C8FqdubSMTyPXTLBfMtavKQqEk8P3TLgDvB6aIPrZvNgYcSZlm/WLhnKHnb5Oq8jjFSgtOc+gze3I0DilZIWuEbaUCwff1J3HpJJfUEz+31TnlHSFBjH0cKv5VRc4R75b07VAvLiOHTrbZLJkPIuX0Ft280THFJZwOTZTR3TQusK4anl3o8qQut9oiZlX7l5RHUdGJLx4FyiBz8QuJ653sV2NbhWE5OnEwB0lFU1BCJi40ODTUNAWbgrUIwQLMaROKSZqE23R+AxhtSLGX9hP+gms5dYGntB7iTlYgKya95gFqCdvsq6YguSgs2Z7YjjXmREUs3BVm+JgeRb/gTgcIcP0XsV13Zx7OqRjHw2rwOs2+wqaAjzYXxUNxrA8sx0SCft1Tm71LRqhROFy8K6h3BKUR4xQegJDfMlizWwxUIFOqvEikmXSmaFie6cvclMrsg+e0TMirEZYEk/BV2M4C2zQVVZffe0T0ywY9x3vLOB+ZO8Zs0fUhJFtR+gUA0GyfX4Q2xcTgTJj6cnInzVB1KFhQMG4ab1J8a2YsaoBN/AjjPVPjD3mxRW/D0mgBk5jnlr4c6wH4wqgDZZMPtk0Jx178+quhZltpa2pgMCpljNTD8Ld9OBpf4NP/liZZd2NNNyneKfBjKTDSEtzC/FXNVvAz1FFLdo3tvm9emDNjNGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(7406005)(2616005)(26005)(6486002)(38350700002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(316002)(54906003)(110136005)(6512007)(6506007)(6666004)(478600001)(44832011)(186003)(1076003)(8936002)(956004)(66476007)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zy/8n0BvGj9cfQ3NdLOt2MBHQ1d/qHJNPOtCx5CZZhV/6txGuq7D6vmW0v3B?=
 =?us-ascii?Q?k2vjABE7PnIkTbYtSRFEXeLcrWx1wnVxKgZQt7/pr7zpAhK2uO08AHEmCe6p?=
 =?us-ascii?Q?h3iBONmVdgg9VpEiqN4x/QXJPt8AHgv6WJzCPhwf6XgT5X0iTpwoLKKIq7BK?=
 =?us-ascii?Q?+OwDCgh4HHFcdIJSi00lFaTxs5qv4sKOusSTABgdieN7M1mS4+ovteRCoXNi?=
 =?us-ascii?Q?HhAgQiuarWIbQF4u16T0BlO+8IuOCDsEh2HvhPmZKRTPn4lAO0gAehHEQUuS?=
 =?us-ascii?Q?JCn89zoy7MMAG2L/j8MKY92Sj05KRIortNGL5EYHBmjGrHslavQQBsdjCKhi?=
 =?us-ascii?Q?GZDq+VBkDh+76KyrWqT42w6hTinzsmOn7YLV2s2iqup/dG60m4g7XD9VdFBN?=
 =?us-ascii?Q?UoV0PVOx1WML4s9aaZo4bFKZWvBsTOBsaGbmqvhMT2xEa7q7Lkq8TxQts1BC?=
 =?us-ascii?Q?3H2o9//rwU6U47sh/0usVEx+pVCjT8VNGXwE9Y0uVidCzcUlTWJKcgwio6/r?=
 =?us-ascii?Q?ut5Y4YVPTnUc2aX+fPjwwR4rqlt+lLtEMFhNCnUw+SiAVna2WBsuoSMlGijx?=
 =?us-ascii?Q?XPM6cPM2vka5XovMWjUTMTpRuySZSML+HN0Qpp8WlRbSMK5aLa0026DMfPNa?=
 =?us-ascii?Q?S7WhGoPwai5DbQTFVY+0TTKgKqfzhwEgJAEpZzdfoJ2lWQN0NTW3NGx9ydVY?=
 =?us-ascii?Q?Jg2ceFFLJXvldwvmLOYyFjfm+Jd2YlwLco1I15L9d/Kjzq/P8sS/59Ry33VP?=
 =?us-ascii?Q?v0w84bTn/pTVNU2slvc9u4HeYkKCv9bOQPYQJd/lUf4hFrYZ9vqIyFN+OIIS?=
 =?us-ascii?Q?CYw4H9TQDCsWM+t3bzIN9Zj01MZeyFsBlhUbZ6tSGB2UXqftUsdIPZy+CRZp?=
 =?us-ascii?Q?4cUkm8/UUEBbC+Rs0qXonPVkCF67QdnlX8XLwDZBdQoivFphuKxCyMthdV9E?=
 =?us-ascii?Q?pgU572ee+b5vYXmk4kvQt5GNCFpXo+SK7u7RXgTNCy/BKq8TrrvsK2Mzui8f?=
 =?us-ascii?Q?eaQ9Go5AI2wjzJ79D2yRAJEGpK6J6bgWF4D875FpowG+PiMCvCjWTNozv++H?=
 =?us-ascii?Q?bxoRWHIFrFbtbRI4IiPGgUD1j4l0DqY5fQciRXG+oWyHJ7grIjhEtHOXhESX?=
 =?us-ascii?Q?6xaIUyXRHpIIXvrbNG+yf/CAcZ6bfZ/r0WzAT36PWC6GiztLuvQ0woAhtA3z?=
 =?us-ascii?Q?zijkWwceKXTh80p7hhvPH5yph98zeSZ3KWUOJ6x0h8h6JCP+qydukCzu4f1d?=
 =?us-ascii?Q?qlTVIsxmLqR2vkKSane8SaO+KdL0rLgRFK+lZxzQKYqUO1U8uY7uEFgP/oA9?=
 =?us-ascii?Q?eOp6Y8P+5xhRMiNOtZiQMsap?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4eb84f5-0782-4553-a82d-08d9632b8198
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:07:56.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6A+uzztxdteVBf5n9Ii8fifgnYkYxbpKj5rgLmX3pXN92z9BRFILbtl187PUVs/wdIZ2HK/J0AOsvmlY5ciqmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are notified on
the blocking chain, it would be nice if we could also drop the
rcu_read_lock() atomic context from br_fdb_replay() so that drivers can
actually benefit from the blocking context and simplify their logic.

Do something similar to what is done in br_mdb_queue_one/br_mdb_replay_one,
except the fact that FDB entries are held in a hash list.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 0bdbcfc53914..36f4e3b8d21b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -752,12 +752,28 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
+static int br_fdb_queue_one(struct hlist_head *fdb_list,
+			    const struct net_bridge_fdb_entry *fdb)
+{
+	struct net_bridge_fdb_entry *fdb_new;
+
+	fdb_new = kmemdup(fdb, sizeof(*fdb), GFP_ATOMIC);
+	if (!fdb_new)
+		return -ENOMEM;
+
+	hlist_add_head_rcu(&fdb_new->fdb_node, fdb_list);
+
+	return 0;
+}
+
 int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 		  struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
+	struct hlist_node *tmp;
 	struct net_bridge *br;
 	unsigned long action;
+	HLIST_HEAD(fdb_list);
 	int err = 0;
 
 	if (!nb)
@@ -770,20 +786,34 @@ int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 
 	br = netdev_priv(br_dev);
 
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_queue_one(&fdb_list, fdb);
+		if (err) {
+			rcu_read_unlock();
+			goto out_free_fdb;
+		}
+	}
+
+	rcu_read_unlock();
+
 	if (adding)
 		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
 	else
 		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
 
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+	hlist_for_each_entry(fdb, &fdb_list, fdb_node) {
 		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
 		if (err)
 			break;
 	}
 
-	rcu_read_unlock();
+out_free_fdb:
+	hlist_for_each_entry_safe(fdb, tmp, &fdb_list, fdb_node) {
+		hlist_del_rcu(&fdb->fdb_node);
+		kfree(fdb);
+	}
 
 	return err;
 }
-- 
2.25.1

