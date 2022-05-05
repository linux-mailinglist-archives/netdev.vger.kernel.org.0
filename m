Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A38651B78A
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbiEEFru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiEEFrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:48 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2114.outbound.protection.outlook.com [40.107.101.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F09344C0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJ38AKFi2mbYWocK21OvZM7IhKMIUsduzutjHdADiz/Ipb5r3I9XgwxJaaKGMDg+tzN4+nZNduBSS08jAqG9+JVGfFJc6N6Cl6KMWu7V+PWWkcvrG53EAKOQl1osUTuayf/Cl9w6He61B+dvwYUNmxq7Zs/Rl5RPj4CCBUxe8y3H1mSFyFcP0kKQGp8B94HQEfNOm+1InAbMkGtU0RCFp4KqhV53W40KClllOZraRnzLE9RdOXZFa39+bQ9SHKdYunFTYGCIAqx98iBBWWozMNSvhFPDEtFnue3jOfrcgcQM6zTBThhdrSDBmIJVnBlQ3fX0D+o9zk57/u9I9kKTqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFMLAh++M1W3ipVkxmsG8r596EgyR+p2J1zOTQ2tcNQ=;
 b=Ne1iDbeJKNNcB8x/iESbUOoDZ5iiTOpiK8mtMZcorFGWCge2s4ogX3K9hG5gzoBUXGTqBn/5DQkD862LI2UiKztG44rB4qhFsxwGPHmoOxgo1lxzlTUN1N6VknYpweWngA2bXVQIO3dUvd/PKdDdmCQKh6s7sQLBNigGsqaKWP3shrLHhseMKE3N4zkmv9A9U4ihK245IdLlluPRyBfrb+Lg2KLOMRQ08GvAEJ7qhj5lgAjjxvvimfSFhFq6bEKMz6JAgj+bhppOwBCsfNUt4zbyoPHDFOT3B0snAsH3ziEwooqgdntSy+9Cx3/pCCnr9usJeI5faS9wjpRFU7t0gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFMLAh++M1W3ipVkxmsG8r596EgyR+p2J1zOTQ2tcNQ=;
 b=XHupzFNWdc8BgUyzyjBVHVYub9DYjAL+1yZ7OmOHsHjURe90+Byv/6+XHk1qfalzYMi4v+J8iDaleNfgNrfw6uQIUS+RVBZfYfCSrArSWpX/Q6fbxLLEdDFYXVy8N9JZhn8k21BKVHEwXg4rt4BYI7bUtm2xkhSMoUU7bt96SwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2609.namprd13.prod.outlook.com (2603:10b6:408:82::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Thu, 5 May
 2022 05:44:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:06 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 2/9] nfp: flower: add/remove predt_list entries
Date:   Thu,  5 May 2022 14:43:41 +0900
Message-Id: <20220505054348.269511-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c209024-4008-4242-dc4b-08da2e5a44f3
X-MS-TrafficTypeDiagnostic: BN8PR13MB2609:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB260981BAE503C6DB62E27F37E8C29@BN8PR13MB2609.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEV2UrNjXSrh0XmmDnSGMIdDXiNsEtGIPH8Q6PJSc8+LnWfERvmS/wSkaQ9r+q4qTAiIJpsSOp2k8Fu8o4HVmjEUXbhDmy/eQQvwa4DxAoE7iIerr0OEBlB89crsm636ypIMaU/gkPwvrzQk4IZZUPVXAmlpIMyR7wcEsU96PHY8YNY/KhPHH91eVnLEspMbiZiWRvZf4/+CEvs5pnZP4JPK0P8zjXmA4CtT0bEv4lYlAfqcID1x1NYkG+M9WmC4kGvj2pSFZuWUOcBYBmJUOibZlwW9iXAJOlgJ61lxAwANMJxaq+0+greYpnaxdbG4cq+03dhrIgCoz9UvtuTlfHlCU9L7H7mJYjeIiZX46d4QXQME5BDP8RTNOAAspN33e4yfINqdJFubMgs7kMEo2nPLoyCODySq9GnmE7SqZpvQvvXa6Tc2mWNEzOwvJXGPpnGGb9tKecQGl0a6KtzbSpat5hQxBmURviSz/n59/PXePtGSiObWuPr7OgPCAD4tqHX89vz47+o/fO3/M5m9gVEDSdgFFQqWJ8OaLJRuDmID2HW2KEMk1q5Ox17PW2TvGQaSFJO8TJl8NCwZzzV8mBuCqXpbFSzTwiKiL6uxKHiNYZQLm+tPKLrWOi/aGqpE5SJ0eBtbtqFxnKfb4ZEd9a0+tIW4yPIz2RooBo2DxZ8EPB+VQhIS6E6TmRQeco/AanfZ5EOFBVH4lTEM7s9Ouw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(346002)(136003)(39830400003)(6666004)(6486002)(38100700002)(38350700002)(44832011)(5660300002)(316002)(508600001)(2906002)(36756003)(86362001)(186003)(52116002)(2616005)(6506007)(6512007)(26005)(83380400001)(8936002)(66476007)(66556008)(66946007)(8676002)(4326008)(1076003)(107886003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v8b83+ISVN1Gp8TQcG9U3arjXz+/Q+iGmmKKX8SYmmKT/Cq2One4/Li/IzYp?=
 =?us-ascii?Q?rY9SQM49UB8puW6F3/NEtYQm4yHWt+PMrdxkXxkL5hqhMFt3NXdCkt5ztAOh?=
 =?us-ascii?Q?YZW/iQtH4lpbOzbPC1+6XQblExB8aolYK3LlFov1rGDAkNHpQXWsHI5YgTtm?=
 =?us-ascii?Q?su1UxMyi9Cos+C6/UgUKw29UYpCbAQAcXXPqqrgvOFgMGPvps4QdQqjfUghX?=
 =?us-ascii?Q?cEogDx+8NQLoqb3gtu3D+YZQSQiELMnMAg8ZdEqPSXL+ATh/3D3BA/AvuKtO?=
 =?us-ascii?Q?vPOpqHvCwF4DKIs5qYAT6eGWTbbeT/IaAQX2pcDU2KHX6jDPJwIYY3fWIXea?=
 =?us-ascii?Q?PwJ4j3tAp0U5rrJfw/YIqxO7wRClJKjLjKvE7YjaOdhwjAX2txq/QgiUBKj/?=
 =?us-ascii?Q?/LNeMTIOZTkrU7uujtBWatn9p3AQwddNQvtMkPWQGo9Rz4hkkgvLDomI2tOw?=
 =?us-ascii?Q?98FVEXhAmtkxaHsEC7zV3QEYgGLA5GtNoe7/s1GSSW3Mb8Av1hdPaSGajOB1?=
 =?us-ascii?Q?62dkDGL4LMBi1jSPOghuy2skDi1MFHteOI+6mikvYtn2PYGupJvziQDsQaaA?=
 =?us-ascii?Q?Eow4PiL78TVZWvIf9orD9vvi+HDZh5eSswr1nLbS2UclDqNAs42Lp6OQ6NUf?=
 =?us-ascii?Q?vYy7eWscCMKTLPiukx5OxBvfceDlDRbFA+JhEuqBbyEkXvhpzYejngA5wt4/?=
 =?us-ascii?Q?ySpHyhOJsvlOhC31NqmTgHQ6X3BSYLYXZ3T6GlK0sGtqYXtCLsjQ9Y87nEb5?=
 =?us-ascii?Q?epnj+mdVGCMZQP6ciz+OucVf5SBqI0VAmBAiiCaTD5D9EHL6+1eLkJ+63SKv?=
 =?us-ascii?Q?oB1V3AfZGFlAwzXL+52lSOvMNNb1LSjmpafKmXtjXi1oc/PhpxJcCuhZCx+O?=
 =?us-ascii?Q?dsKyW6hrXkyWZZVsg+ePDjbX7uQ5cq5p4vkKNDF9isKU07Is23dTxEyUij3N?=
 =?us-ascii?Q?kVXc3STZT+C/y3vtKJE4VI2yJ1vk3bvAU+jnRP8W7u5RmIFBe10oowsBCG7d?=
 =?us-ascii?Q?j00nBzd4LHPWxcz3kLuZZhNj7hpcZXIMonk8XIGXqG9p8Eqtm8OJDNBlOLLN?=
 =?us-ascii?Q?c+TMpAh9sawb/WMrLo5drN8gINTOjOkrtEbgaIjk9aAPs7xs4XpdOw3X3hvA?=
 =?us-ascii?Q?v5HPOE4Nf7FZmPJ5FjUH+wfs/2j96O6i3zYRvhluetIo18PawyhMqDvVeQJZ?=
 =?us-ascii?Q?kT2DrfM5ug9bjBp2V2Kw/p3fSqzCiCzTNdYDKnKXdAsxr5Tf9hgitK64vCVq?=
 =?us-ascii?Q?xYFzOX5EZ+f0y3J2JK1J1M6lUFZL+sIdDrsfexymDeP22Jmlj/HO5EIAMb9U?=
 =?us-ascii?Q?bASNKO0M4YwQBY0XuOJBAMGj/sjwniUNPGg5IhwTxVWRZ1cXEYEKIUYA5JZ0?=
 =?us-ascii?Q?I/7eoAlpqz+vWdAZSsR+efPivsbjEQeVHYS2sCKyAQ0bqxDSqyvGCWg4nDTm?=
 =?us-ascii?Q?2viszFZ5LViOlfiMbWx8XzYkEkPjRfdCA0T/Nl55EV/WHpG0GPBM246dDnVE?=
 =?us-ascii?Q?TOj6HBmW5fYc2fIMSkRy5B3QmWCchqSEq26rTIzp4C+t/0900dbfpDytg7Lk?=
 =?us-ascii?Q?O32FDh1bF80ShQkP+hc6HY9qi/1hadjDbh8xo/dADWMSTOlHw0hV23BvsbCg?=
 =?us-ascii?Q?NY6IXR40AtvEW2fAjIYv9OILfsi+RpEjZQC6neCTGY6LymooSfoMUStY90jq?=
 =?us-ascii?Q?1ZEnee9tH0OQveC6i3Vhw9vql/h3jqPPzbtyXkfnxXd6wvgElinWvYI5F8aS?=
 =?us-ascii?Q?rUb1eqbr/MHEF5ul8oRgTIZiUkiz0v4=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c209024-4008-4242-dc4b-08da2e5a44f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:06.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zq5KvB/0BQ6nYJQymcSwrTT+35hUbDxnaaQ5VTsUEg6HOFmDdgtyQH7D92bYyrpYxAvYUTL6oRL5TSMRcWmK3nagmTic4gSN4llG0ror1Mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add calls to add and remove flows to the predt_table. This very simply
just allocates and add a new pretun entry if detected as such, and
removes it when encountered on a delete flow.

Compatibility for older firmware is kept in place through the
DECAP_V2 feature bit.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/action.c    |  3 +-
 .../ethernet/netronome/nfp/flower/offload.c   | 43 ++++++++++++++++---
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1b9421e844a9..0147de405365 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -220,7 +220,8 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 		}
 		output->port = cpu_to_be32(NFP_FL_LAG_OUT | gid);
 	} else if (nfp_flower_internal_port_can_offload(app, out_dev)) {
-		if (!(priv->flower_ext_feats & NFP_FL_FEATS_PRE_TUN_RULES)) {
+		if (!(priv->flower_ext_feats & NFP_FL_FEATS_PRE_TUN_RULES) &&
+		    !(priv->flower_ext_feats & NFP_FL_FEATS_DECAP_V2)) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: pre-tunnel rules not supported in loaded firmware");
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 92e8ade4854e..0fe018bef410 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1362,11 +1362,29 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_release_metadata;
 	}
 
-	if (flow_pay->pre_tun_rule.dev)
-		err = nfp_flower_xmit_pre_tun_flow(app, flow_pay);
-	else
+	if (flow_pay->pre_tun_rule.dev) {
+		if (priv->flower_ext_feats & NFP_FL_FEATS_DECAP_V2) {
+			struct nfp_predt_entry *predt;
+
+			predt = kzalloc(sizeof(*predt), GFP_KERNEL);
+			if (!predt) {
+				err = -ENOMEM;
+				goto err_remove_rhash;
+			}
+			predt->flow_pay = flow_pay;
+			INIT_LIST_HEAD(&predt->nn_list);
+			spin_lock_bh(&priv->predt_lock);
+			list_add(&predt->list_head, &priv->predt_list);
+			spin_unlock_bh(&priv->predt_lock);
+			flow_pay->pre_tun_rule.predt = predt;
+		} else {
+			err = nfp_flower_xmit_pre_tun_flow(app, flow_pay);
+		}
+	} else {
 		err = nfp_flower_xmit_flow(app, flow_pay,
 					   NFP_FLOWER_CMSG_TYPE_FLOW_ADD);
+	}
+
 	if (err)
 		goto err_remove_rhash;
 
@@ -1538,11 +1556,24 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_free_merge_flow;
 	}
 
-	if (nfp_flow->pre_tun_rule.dev)
-		err = nfp_flower_xmit_pre_tun_del_flow(app, nfp_flow);
-	else
+	if (nfp_flow->pre_tun_rule.dev) {
+		if (priv->flower_ext_feats & NFP_FL_FEATS_DECAP_V2) {
+			struct nfp_predt_entry *predt;
+
+			predt = nfp_flow->pre_tun_rule.predt;
+			if (predt) {
+				spin_lock_bh(&priv->predt_lock);
+				list_del(&predt->list_head);
+				spin_unlock_bh(&priv->predt_lock);
+				kfree(predt);
+			}
+		} else {
+			err = nfp_flower_xmit_pre_tun_del_flow(app, nfp_flow);
+		}
+	} else {
 		err = nfp_flower_xmit_flow(app, nfp_flow,
 					   NFP_FLOWER_CMSG_TYPE_FLOW_DEL);
+	}
 	/* Fall through on error. */
 
 err_free_merge_flow:
-- 
2.30.2

