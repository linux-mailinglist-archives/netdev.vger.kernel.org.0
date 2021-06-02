Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8D3988C7
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFBMCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:50 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:6496
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229610AbhFBMCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X06XFj8pxt8WHGrDk+bI9VAznn1afwZm1DRMrDAOMjDYKNIPYyD1oqw9NLFzMbTJLhQqYRGYkOtqvC+xkSzDJT1LG8ZXHVQ60zo2nXCh1uXHCGvPu9I1l7HSeNR/dFJ4Vvah79xjAkr5OFETG+6RgYd/D7Gs/ip/sTS/70vtSXfifqbIxYbTKrFkAUGod/ElJw7FA3CZY16paBoK1cClO122UPvgpzb3uQzyaXw0G/bTNpzoqOOapeari07w15iQqq5EeFZojaIleTJVANCa4SgJJHtx7p8V3e3yEpZoeOa/S+bnfseLQ92cU6lzbjw7WoPZ/jJQya+Iu9/0LQ701g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G49HKvd/w9FkAxnD9HWDRnCyLu6FCLtPoniswNkBSM=;
 b=DN7vCY3qE9R+rnVOG3WqyMgwzSWNXpT7m1gPfu3I5YrrFtuRLZjxsUvarjfHAAKoalXjJ5ZOPErngUFjjDcgFuybohnoCbKWw/FZpFzYpXUquG4vb2R6OG8mQJEi0vvNbfE6b58/eWC6CgBydnGB7+cBzd8AB0w714rsJxmoEX5g/P9f+eVxFF7R6I+1AXaZH19VPcZH6SyAzZzBw26c5NcNvMAuZKyV4DNh4JxCKhc6jU3SGMzGjLEt+pQnAvnZMXbabAYGjqs9n5JVUzrFsHoHftKJQ5P129ZWJR/I4AdO8WbWgiZgEpN/jKfjchiTa8JZ3CbJe2ulzQGwBKnnWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G49HKvd/w9FkAxnD9HWDRnCyLu6FCLtPoniswNkBSM=;
 b=k1zgDfyJr+1G2gAT88gp78pHcQ0/EMeL/uWkGPIUJBY9GaCANu1N1AODu3WwESeyFoSSMpWezHsm1i0L+qJLQWsMobnqe+O0L15OVcEINwZSiBTpCHcvSlTYh2iGNtyX70VJIMp9vc2ckiEkWmz1wt9L6p/ZdT9EEilepqNC5bI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:24 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 7/8] nfp: flower-ct: add tc_merge_tb
Date:   Wed,  2 Jun 2021 13:59:51 +0200
Message-Id: <20210602115952.17591-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9889a285-67ef-4aad-5e69-08d925be016a
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB498606E9BDD202FC8154BBB3E83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uE6pQfVGjsO1M2HYL5Q+owAiK3A35z58mtfkQui0Uv5X4QlAtcZxKXRiiZGWktlQYegue2eJ5swKAm47M98BFzTFszsdHQEF4gl6f7yulC7f95s3GgJu2m3t9Hfq2udDoiDNriahmJ4+cB/HqEjBBGiOzRMpTlLuXqFEsnLsFYwzr6jSV6vmrOd5oxeSIu8xrraUH2jzJ8iGRbFFq65LAcAZ2pz/4/ZCq3sWfGEIM3KvZ+tYGdLfZZe1UY+C5walCJce+wUMEsguHdTszYVOLBJxd51rAVnzuudbTnhYhurEhMxZN2oTkUiuOohJ/1GRTJL58RvDHnM6TkhWy+3RVB3ae1bsGlP0YEG/VKVdHExtXREDSh1wmX0zo2SbK95e3wRseto103+vzhjyQU9MHIzenoO/Mkdgx+ZNWX4sY4Ze+EEMRPTNECRKKakTb6qInzCzearlIaQE58NulkSYq52/xK1ITnVUmbymIm+Cegs48CuxsyOHiZ0YCT9vCrppDgo6zrbLd5E08h7egoXbB7BFrC+AzPZosnkAuwj9/ZK9VeMglQ1pNFC4e8b9CyQYeKstJ5Sf2zaY3eS0FNasX/S5gZDHWyQg7S5yMZamhoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Avk1rdynEEYaPQ+xM/xJm5Qtzbt+IWU1wol/bKztbTHqArlIzksHs8ERYlmx?=
 =?us-ascii?Q?bm5cB5YTzRXmWsa/UGo9zyLPlUbbc7jxsPpswQnulSGyr24NnXJib7c0Bu84?=
 =?us-ascii?Q?63flEbzPCQ7Nl2JcBDLzcxFa21zOOFiAj8HYjxeQQVEllNcNklyrhie/JolL?=
 =?us-ascii?Q?e1KhmlI+zQyrZT/qTggKKM+ZO9uRIqkyKgwblRo1WX+ZjmidrJwKeOpbbEUV?=
 =?us-ascii?Q?y7s0zQSedCcp2wGmZqkzxrH6nGH/wwjEsRh7MqHq5EwY3oLQ2umfThjjSn6A?=
 =?us-ascii?Q?GDwuU8myP3Dc5O4yf7PnDnDV1YwtopQ1oImy/dqo9Hyf0IKnCrf2zZ5aCZBn?=
 =?us-ascii?Q?Oc+66sbrzHi7NnK9ij6Wj9F9Kpk+OZc9IO/MTLSiJkB2l3L8LS+ERB6kxWO1?=
 =?us-ascii?Q?R2f9sC/qR1SXitlwtO4IcBJxF8T85tLKrfwwUbQ+g6ks6Y+Jqf+Yz+Sbp8po?=
 =?us-ascii?Q?7u+/dRjiIzHrFmkko4RFv48v5DdUbWGQq1wPhDb8NEnaXjoSsA/zIGJH4O/O?=
 =?us-ascii?Q?URPyQ9wfc1hIHDzVo1QSymWuZhgFSYXmfzNdlQGxrIUzctaw8RzgGnyOHfQo?=
 =?us-ascii?Q?ybKfHx3Bp7MKgXYvfQzu0H5s5d1D57wDgJQkpGd0OWv2rN3rfzCQj2oTT9DX?=
 =?us-ascii?Q?GJsbCa7cE4Ug9svyCqSHNu/vgZVr4Gtt0LAbbkrqIvjhywF7Ux2lWSBISO4t?=
 =?us-ascii?Q?ClYKwDNCc5GJsWZqIErBoStbMeGuLCnUU1LbkHradZAkSBc3QdHYnWk4c3L4?=
 =?us-ascii?Q?D0pq3WNyaXSdlMGRM6PpcLX0nEW7OoE+VA//6qx2Q4nCZ3/fjMdvyPMQFc3u?=
 =?us-ascii?Q?EuPnvpAak+7NGg4jSTo2M3VyUaV7sRFeEtItnU1IL2bfYCLhp15MPsjU/3ag?=
 =?us-ascii?Q?AKV0WoRqpFsu5TVL2Euv2G23wfCrZw2tkzyqAUQYae39VCCgthSifNuGCEp1?=
 =?us-ascii?Q?eb0rc20kGdea2DWlcoNMzbtT5V0ZIgYogDpxm7sqrfVDA2tJuN70gSUl6LGw?=
 =?us-ascii?Q?c+xf4aLC39wUjOcgTOnPsDSsbA6IgUddBsVpRSOygIkT93m2pGtY5sJsrL5C?=
 =?us-ascii?Q?oAEUD/jMKdUKa+DrL8F5olOfUysmw00yhC0xPjfgmD5vzN6sfFxGAiuFDlDL?=
 =?us-ascii?Q?OOPassjc1DKWAPJOOomwwQBECAohcVTw0a0AYHMeCL0M3KwrfBncYLEiGYRH?=
 =?us-ascii?Q?FC5b4bcnzebH4LtNqq9oMsRxRh3NdmcJ0dcRpViewFQyN7UJ/6AGSyPefCph?=
 =?us-ascii?Q?Nf4hmdJpkOHZdamtFiU7a6u8/ayeJbZ3tj50zTo0xbf2RV75pSV2T+/rqEFH?=
 =?us-ascii?Q?sZ/dF+epsp90YIhXMGrraecbBrnt+jp1/EUI/VPlDXcAUrdX7fVN4wtykile?=
 =?us-ascii?Q?a6yf97+3PT9NR/uQSLHZqgS9Vcq6?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9889a285-67ef-4aad-5e69-08d925be016a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:24.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0tZAk79m9SdKPE7L0fCXhDO0Kmnv21kWfFIsA6vxma0njo9WhBqL0dDUxj6nCPWX/OJHjpKLqnfqaJcK4e82R6plWxIgSTqPC2W0CQFOFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
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
index f6f97224e773..afa024971c08 100644
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
@@ -87,6 +95,10 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	INIT_LIST_HEAD(&zt->pre_ct_list);
 	INIT_LIST_HEAD(&zt->post_ct_list);
 
+	err = rhashtable_init(&zt->tc_merge_tb, &nfp_tc_ct_merge_params);
+	if (err)
+		goto err_tc_merge_tb_init;
+
 	if (wildcarded) {
 		priv->ct_zone_wc = zt;
 	} else {
@@ -100,6 +112,8 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
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

