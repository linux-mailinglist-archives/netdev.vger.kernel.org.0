Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA52039445E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhE1Opa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:45:30 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236278AbhE1OpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:45:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdZ8SmCrQWE/NiwsAJRtCI2qTeiDdHvgLEAnyJ7524w8sCH21sqAjwQx/4Q7RWe2SIjGqLjkst0Nf7ww+KLM8elxybKRIgoglA0ZIbNRvz5lBEu7a3oucEi2ueDkvjKd3e/ZJcjz51MEkSr26sDnovvOuRZXMfDuxa3GCCRUa7pNPqGUa0eFPL+cwl2udUpLh5Y9SaSEmPgSPXq9/LJq3tXSWp1sKx/QfobC/Y0EoIj3/HxhnJCuRPWror0z0LZiT57/9e7gRSaWbrOhJjbv7Ja6h+jA+jgYIJb0Y1CTxnQDzQmMOq0UxOkjSyylX4gRsmKtTx9G6Tfu/S+kiAzAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlg3Qzqd/yJma1ma0ubnw9hxsuVYqp9u6YY6a4zffkg=;
 b=iEUheRauid98zjqrOa8kvvt6pLj9q8eJy9DEzLTIbPG0RX/WgWr+dqgrN6kCFGti35oLPLDPAnPYCkqQEMWGT+J+S2DBhLFncyTkEmIzdcX9yRfUEHQkYP8oP30CalYZCh+0KIl5S9PgcAJB4CJLRv3Idc+NmAyVIpwyAgovnoQ4eOrMpVgU7XbouE3fqpXX0YmBEJIb7REZpBf61ZhKd8H2CcNadjeUB+EZWwvWIiBGJubiR6WtRxsqwn3HNV+wI84e05TihdXXJXn4ESV8UNjx1xSLai5eZvL3CZJlCyUfg9fsMlnGeUDs94em8e9sOk4NhxdMbISnvcI2O8rYog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlg3Qzqd/yJma1ma0ubnw9hxsuVYqp9u6YY6a4zffkg=;
 b=quaVZnWrB/iTbKClUdpLDoUrdZAHVgeUahsi8/W4OHPabno/Z1afUEQkKEIwXgLsRTN9rrKIJCQ+A65UhHN5NFEaHnt97ElOp9FPtM/Kl5+zbrxd37bGm/Ap0ojEDfhF3wdPofgUr0aDcbAEHOufcKOh/st79vf4XWyFHho1PkM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 7/8] nfp: flower-ct: add tc_merge_tb
Date:   Fri, 28 May 2021 16:42:45 +0200
Message-Id: <20210528144246.11669-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210528144246.11669-1-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c23eff-ab4f-4452-0864-08d921e6eb53
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50331B7B3E4E0AC920C066BAE8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xq4k/oY6hWhybX0QQ+swqRNWDyGLb/nJO9SFVBcFg71ozBfXSvMKTCUcNwOyzGgUqLF92UzMt4JYal29lc4JMRom61eLxNeZ6s9r7iBz80nH0IpLw5EtJZfTP4KDDl9q8bG/xs8mYOA3kaSqFKTQhf+0DVkOxysfK4vcuyUmuCtLH6LqeDM83RYHnLiJjh0/JCFHdbqkP4k6ghaMw342VDki6Bjo9+kxbwj/7c+UcnJ7NOZOp5bo7RFxALcdMtsC6XoOR9SdZIksfy64QmY2Ch3ExhShgFIU+RSrvp8DAzhiMVsxs9FGqjO/TME2G9gVq2YxbUJ5zpHDyT1HKNcxV2gd9vCx4sLAos/nsaW4kDD9H6lMgDXEZnbNR8Oiq+STHeOxyEgoLAhU2kL4BFTzi95mFr7XNl7mB7OqSeij5tV/GMhdpLcSfYaW5ALg6GPz05QmHBCIVVBU1KyNPZ3kIw2C+ccjqnjT4sDMg2W9/yiYxIiKQyEY1Sl6YSmi9Bh4mqSGQbb9MUikXM5r4k3YsDxmvvK8QvNdDu9NQXNOY3zuALaluMYKyNEpI/5KzqOqVRibFRpFQTLbhIFs/jxLS6+c86agc8kSKEoLwJmGjO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e9deWwniENp/SVGsNVB8N7bjQzeMfOo6vqKqh9FsXo8e52gFHyBOgMDczxdv?=
 =?us-ascii?Q?zSABo/QTNIeRh7bxsnYB7N1tMeso0YH0fMkI7Giobw8qegESHjE2BW0wLBPE?=
 =?us-ascii?Q?Y5X2PCMUS/AomXFKdXMyuYsMG2yJcRmOjZLp2561ZbHVR4tHPXccXwZ48Mc+?=
 =?us-ascii?Q?z45ufSRZ89kKWHKNgvTbjZUooG71H68P4mkn/qgcInl7lF01lER8Tq07/bft?=
 =?us-ascii?Q?LRpOYhNgObGc2Q4d9q/vIYzCDMUETE9POqgveAAWoedN3kM22vnv3q6cxngE?=
 =?us-ascii?Q?wt0cp2ThX8S8svBEpoooLIFNX616c2WpAHMYdfBBE+YzjYS+BMTcDsMBx5sG?=
 =?us-ascii?Q?8JBOI8KeAhULqFpiMVv+2BeVXNU+ValLVHJUHREQcq+FwhPRLwPdyXBRqyGa?=
 =?us-ascii?Q?mXxFpPjriNoipAM/usLToIg06nys2hz0ZVsbANzvMmXTTQj0dbQOVIGc5jOW?=
 =?us-ascii?Q?4nWZ7dfLWQdILxOkd3YYrrRYrq5H9/q36n8jrbPO8YBKiYE3NYGRtnlPpYA5?=
 =?us-ascii?Q?NMXeWQOhdSw+j6X8KPa3/yrCR5QEgNGMuUD2KRjz46pZqSEg8oi+qYcq1VKr?=
 =?us-ascii?Q?zmbEyEUw9WyjNDefTYRw1y2Ng90jtsoSTj85KHgx4yKlZ5qn+63tcrTDl/D7?=
 =?us-ascii?Q?YUJoFkeJhj365d8cuIl8mve4/ayKhv5VsyA1poPIWVX7+q4xtmJ7MlMqrnl6?=
 =?us-ascii?Q?of/oIU1zzXTZgfoPQ3gU9yW6iBKJhrB7e0+cQDtSU06XdxcxOL+efMAJGVUw?=
 =?us-ascii?Q?fLSHMIe7M9qVAY+RTOCyG/517+BaNc238bVedHWbd+wiN6WN3DtMqa8x+37l?=
 =?us-ascii?Q?t3gu+qTQbBO4yURXdffOrgmaflQlQ0wXAKIomhGgqfJF7SQDOgRCakCZpQou?=
 =?us-ascii?Q?ZjaOSk4Yg2KPXf1okLSl+0mI+/W0JGq1TcAwl4fV6UddjjlKy6b4clA1ILUl?=
 =?us-ascii?Q?Fn1eGDc5fKhex/zdvRY/x63FUBuu95zqQLWBVhho8XDHG2hMzpTdg39ZBNcp?=
 =?us-ascii?Q?xNl+oCF+X2H6qnUyOj3v/cy+eh7AXI0J+Gj2B1Bc/w2aRhy70YwBCdtq34AH?=
 =?us-ascii?Q?q8spk6HBBYYl91B2KS4+BXc/IZGoMly4OybOLD5T3NnoMJEgUNNn+UgI65na?=
 =?us-ascii?Q?rNihmw2pNm0gjer0xjnUqlVAnMazsI3lC8zZw35TTYynnkc+SsDhpSCqyPb8?=
 =?us-ascii?Q?MplUSZX/dvUQ4h8jeodnDwvvZMnfrhIMPdTjt4d9KPBtAbymTX+Nm0Ku+Cx0?=
 =?us-ascii?Q?R2ygUXknALDphcK2oWj8fVvPwdlqyWc9znUaVBtB0DYwPAZvXQyHd0tPlbRk?=
 =?us-ascii?Q?F/pzRXcIYZK0xuDspQwCuVKG4BzZSgvyyGCvHM4tBXIUOaXg+fXPBCQF78N5?=
 =?us-ascii?Q?xdv6ScJOdfXN04ZgX7Dtr314T4ZD?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c23eff-ab4f-4452-0864-08d921e6eb53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:12.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vM0Og2vQ4r50wx0VsTTx4uz305DPYukrDGz6OX1asISanu9ofrkTNxXDvM1hPOis14fsnY0972A7Ue5ugTmARvPxgRfLd/OitqxeCgTo6tA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
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
index faf42a967ab9..a5b36560fce1 100644
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
@@ -69,6 +76,28 @@ struct nfp_fl_ct_flow_entry {
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

