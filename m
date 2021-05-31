Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0802395ADE
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhEaMtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:49:22 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:7041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231330AbhEaMs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:48:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VG+M4IoDO8U/UjGYUtwBHASO79yuxNIKfc8N/bFjkOtyEZIjrjKON6gMBGYD+/JTOZLMM4a6Un2QcYiasakTsFQJwooUzMNYN+QMDYCoPkfhOf70zaKcjmN5M/yLsKb5CFEHYQ9+xb4i5goBQe7+r8NjwOltXx2v1+dcgzhbKcHsG2wh4NbHu2SYc9ek0IuX1/awLJrUA7gEIfKnEycIokPtfvO2S7sNMc47V9F/hJA0bWooZmMnqi6+V6tm1RMB7WfHaHWzOBtduO2ySHZGE3Y3uo0hWNZ3rT4A3KqwJR1hYW4ef8COyMHWs5UPSQBfCkQbQPRE0D7JOy5y0aOf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/OWCfzrp9WqyFMaOsMALjX2xrvoFzr3Izx3R3szes8=;
 b=HI+a3B996WTqdGT1K9olv1izyJWTsp/Dc4ntrVV/zzHrx7PQKc6NZGd9gg58XIk+7mcx0/C+xOWBrIe1nJu3412GAxNBwnxixzEbtlfl/fYqtNr4ysNw+K+XFUv0kZWpvT9rPKFBQ3OsAaUNGh9XUEeH1Kb0uJgyBGOM1+AeyqksksSnJw7KdkD082Zo7Uv3gy9AHBlk0XXNQGRntZuptNL8VRbfZIpqJkOzk0NgRYoJARfGVAv9SngoTJPgdT9Zvdq6/8VyphsJbDfSwUIicLes+7xB3P5EKZROJJIJRriP2Bua/NlzkDoXKECoq/D9FDZ0J76pN1QblJq9YxESIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/OWCfzrp9WqyFMaOsMALjX2xrvoFzr3Izx3R3szes8=;
 b=uYX18+cWrny64BVA2JQdY/ffbgCVwq0LLOKKMrtAlDJybtNy1roNo8azJ6ZTME6sB1rHewVhlYYm0Mqs1fArjuFP8XD3+RRuWezoMIKIWK1ThrVs4j6aspK/bnMWeCG4CrTtD2heZRC+HY4veP/kKF4Y/0Q3yCVj7H+HC0O14vc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Mon, 31 May
 2021 12:46:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 7/8] nfp: flower-ct: add tc_merge_tb
Date:   Mon, 31 May 2021 14:46:06 +0200
Message-Id: <20210531124607.29602-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81a8454a-3e3c-4aee-9716-08d924322226
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4891604744EA4F4A3BE60342E83F9@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6y4TD1FFy9lkl904V7lFNZSQyKXLhnq9nvwH97ml6VvO6zCtBpUjZF4LPNfGO39SIuVwP5jw1BCDlM17TCCmNSXh+cLKJjQjBRqLDhD+YAyLpP2FrzlQQA2cbdzLPczhJmtn/IFK9SCJR62MIFHlyXPq3e9kSkdS01gjVFnf5ec/tWah7Z8seNu/cO6hd7rvx3Z4id97RkXdNO8oMlqpDYfJjgr69zifstw8QH8VgTBhy9WQEcu94z0qPueadANQJlemGBEsVaX4p0TfvSMe+vUZS8HxGuMZaGAejresKaSobZYBFRkbLgEJ5rMLLlpl1GPPIpOcRkmolkGA638xLKac553JD5BHLOkx100dXyO+p7pSUZlpkFuCloVZJ01k2Ecf5uYZHmvj0vghlE7ihJtVrpkucyxRCeyUn4Ia2u9GdMDj0iCqSWH0j/pTee+7rSO0+VtIHPrH74QGvPXMgPnbxqjl1Pcu2Bqk7IMzK0Hyragq9dqC/tLUsCl1OY7IK5Y2ozSiIZA3lWO8HO8fTcdVb46p2w0BPJZFU+1ZM+YAcDUbH6cWM8qYwL+QxvLJfsAYpVzw8FUy5BjMDy8Y9XlQgNkl5AutmRxkbT/+tZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39830400003)(376002)(107886003)(2906002)(66946007)(66476007)(66556008)(36756003)(38100700002)(6512007)(186003)(16526019)(4326008)(86362001)(8936002)(8676002)(6666004)(44832011)(1076003)(6506007)(54906003)(110136005)(6486002)(478600001)(2616005)(316002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+Jm4VXuGySmpWxm42b/2jW/M0peiX5mEUxvxFD2JBP53h0utJUCMO44CDx2Q?=
 =?us-ascii?Q?wkPdC9tpGiiAJgRispO/vJPV6r14oBQFhPnCC7zy1u8cJ/5TfcXYblnSZ+sy?=
 =?us-ascii?Q?xh8RRutlV8SiD1vW1UxCeCgtvjozs5Chz6yui2hGm4dc1ZWx+w3/pA79dMMK?=
 =?us-ascii?Q?dMolNir+4PFfZNpy8iqMZUUP+IwmJzinQc7m/QISGzDBx+ZBDcHwbbFtQxa+?=
 =?us-ascii?Q?77uw1Z+HvX8RU2mu/JYQLzG36oatFW5AfXJ8PcgAP0e0r72bjGGZ8DYerh89?=
 =?us-ascii?Q?+MqW5PjK8eIjlaTEc+m3miy1zBmsSm8/9g3SSZG8pdG4GLxa/MUgIphPr1AE?=
 =?us-ascii?Q?wL14Fyorfoj329FP/8gskW3xpdZGhvRksquXEeGaHvEXVWxXnvPvtQTPABAh?=
 =?us-ascii?Q?1uVHvDz7gblrT4DjKzh3BCCrnVdDiyrtBi1vHzNQ0tHjpRAbHfLJp+SHc7jY?=
 =?us-ascii?Q?vP/2wVmu1VT/VFCTtpwPe5RSrzNcbmxeJ2tlYdLCL6MGj+QjWVtmH0DEwApK?=
 =?us-ascii?Q?BFoa35hDVySl5/mCdbBNKnVX7pCIwEXXztRwZbfikFchqjvsQR07RiepsUjt?=
 =?us-ascii?Q?841fVIfZsMXH8J6esTV2Haelb6A3KQMXXxLbvJIZYZtiTMXSl50S/uoczXQb?=
 =?us-ascii?Q?BNXv5COV9vR5JZw8B1F+E7wRJx8tIZK5zdApCd/lYj+XSpSW1US+phevU8wI?=
 =?us-ascii?Q?HI8dTepGaAM4cSe9fMUuN4Rtl5VpP0MISjOWkGdNqxH5yf5Q2EV00Cu3iT3E?=
 =?us-ascii?Q?1e62oCSJBLXC/ZWx5fkrU2CJXE1xtUeyZTJwXicFERc680PX+j4Tu/9/FCMS?=
 =?us-ascii?Q?BXZB0w1V2CdNGYOAGqdMETo/DJqDfsoxG/jV0lIDDj+9o5bJf7vTXQyiUP1C?=
 =?us-ascii?Q?GHkNiGHa9PvoRNicOc6BIoYFUS1Zrv7yLrWHq5RZA0x9kYaZimVmkAn/1AKP?=
 =?us-ascii?Q?e859hciR6X0Eo0LD86mksP8qgsXTYT+Au5NGJDv8AT9yrAfqHEOB2ZmbnRYu?=
 =?us-ascii?Q?G+oxVgRb45JLF/s5/5fnOnbathXbQcXb8vSBEoFCRia1WVZC+tmR9a8mtoka?=
 =?us-ascii?Q?2fRRraExFMnjTPO53ypszxo+vwPXhGnzZ/6QQQ4XfOAnUNqdG/4PbfIFyRqt?=
 =?us-ascii?Q?4mmO6uaSf7hwT7LUv9CoyfqHRvTbqW564OZparICk8pxZWw7lDWFb2MJ0s2M?=
 =?us-ascii?Q?VJ1fwy2jd2OjR4wQ5qK86yXePpRNwKzAaZhpeWM6VIbBFS/mlLKqEf9qkFkl?=
 =?us-ascii?Q?AHJmvj685zirmDUSz8dkY92a0vaFgvxv97ASWTeusnob1/PwHyBJOQ1Ak6U8?=
 =?us-ascii?Q?GZb1CFUU3bTtw1oFJenNrE2bDnmZzG8FZYsmZK4+Pa8NiA5lZJSjRgJDMqqm?=
 =?us-ascii?Q?ht+DZSXI3GEuY44bbn+0IOFnOPIC?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a8454a-3e3c-4aee-9716-08d924322226
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:39.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvUHsU1Gz8V0iA/G5sfq8gEu5GmQ7r40gybWw4oY2A5Rgoe3+0rS6nnh2CRiAXEqvxUYiFfeWIOgnYnyFGyAYp4pd82GF8yNiodBVeUyeJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add the table required to store the merge result of pre_ct and post_ct
flows. This is just the initial setup and teardown of the table,
the implementation will be in follow-up patches.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 14 +++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 29 +++++++++++++++++++
 .../ethernet/netronome/nfp/flower/metadata.c  |  4 +++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 0ac6e92853fa..cf17c9510fbb 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -3,6 +3,14 @@
 
 #include "conntrack.h"
 
+const struct rhashtable_params nfp_tc_ct_merge_params = {
+	.head_offset		= offsetof(struct nfp_fl_ct_tc_merge,
+					   hash_node),
+	.key_len		= sizeof(unsigned long) * 2,
+	.key_offset		= offsetof(struct nfp_fl_ct_tc_merge, cookie),
+	.automatic_shrinking	= true,
+};
+
 /**
  * get_hashentry() - Wrapper around hashtable lookup.
  * @ht:		hashtable where entry could be found
@@ -86,6 +94,10 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	INIT_LIST_HEAD(&zt->pre_ct_list);
 	INIT_LIST_HEAD(&zt->post_ct_list);
 
+	err = rhashtable_init(&zt->tc_merge_tb, &nfp_tc_ct_merge_params);
+	if (err)
+		goto err_tc_merge_tb_init;
+
 	if (wildcarded) {
 		priv->ct_zone_wc = zt;
 	} else {
@@ -99,6 +111,8 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	return zt;
 
 err_zone_insert:
+	rhashtable_destroy(&zt->tc_merge_tb);
+err_tc_merge_tb_init:
 	kfree(zt);
 	return ERR_PTR(err);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index a7f0d7c76b72..3d7d260c6e5c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -10,6 +10,7 @@
 
 extern const struct rhashtable_params nfp_zone_table_params;
 extern const struct rhashtable_params nfp_ct_map_params;
+extern const struct rhashtable_params nfp_tc_ct_merge_params;
 
 /**
  * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
@@ -23,6 +24,9 @@ extern const struct rhashtable_params nfp_ct_map_params;
  *
  * @post_ct_list:	The post_ct_list of nfp_fl_ct_flow_entry entries
  * @post_ct_count:	Keep count of the number of post_ct entries
+ *
+ * @tc_merge_tb:	The table of merged tc flows
+ * @tc_merge_count:	Keep count of the number of merged tc entries
  */
 struct nfp_fl_ct_zone_entry {
 	u16 zone;
@@ -36,6 +40,9 @@ struct nfp_fl_ct_zone_entry {
 
 	struct list_head post_ct_list;
 	unsigned int post_ct_count;
+
+	struct rhashtable tc_merge_tb;
+	unsigned int tc_merge_count;
 };
 
 enum ct_entry_type {
@@ -70,6 +77,28 @@ struct nfp_fl_ct_flow_entry {
 	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
 };
 
+/**
+ * struct nfp_fl_ct_tc_merge - Merge of two flows from tc
+ * @cookie:		Flow cookie, combination of pre and post ct cookies
+ * @hash_node:		Used by the hashtable
+ * @pre_ct_list:	This entry is part of a pre_ct_list
+ * @post_ct_list:	This entry is part of a post_ct_list
+ * @zt:			Reference to the zone table this belongs to
+ * @pre_ct_parent:	The pre_ct_parent
+ * @post_ct_parent:	The post_ct_parent
+ * @children:		List of nft merged entries
+ */
+struct nfp_fl_ct_tc_merge {
+	unsigned long cookie[2];
+	struct rhash_head hash_node;
+	struct list_head pre_ct_list;
+	struct list_head post_ct_list;
+	struct nfp_fl_ct_zone_entry *zt;
+	struct nfp_fl_ct_flow_entry *pre_ct_parent;
+	struct nfp_fl_ct_flow_entry *post_ct_parent;
+	struct list_head children;
+};
+
 /**
  * struct nfp_fl_ct_map_entry - Map between flow cookie and specific ct_flow
  * @cookie:	Flow cookie, same as original TC flow, used as key
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 7654cf6a3222..8658c5cedf91 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -638,6 +638,10 @@ static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
 			kfree(map);
 		}
 	}
+
+	rhashtable_free_and_destroy(&zt->tc_merge_tb,
+				    nfp_check_rhashtable_empty, NULL);
+
 	kfree(zt);
 }
 
-- 
2.20.1

