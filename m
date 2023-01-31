Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD0682875
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjAaJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjAaJOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:14:04 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13D04A23A
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9Vf01jxT+owYXRJQMv79KZVUDNkRTWC9PfHwIOCJhxnm1PpR0bdgdXLkEQQJEe6pu+UiCIQBKXKOXhMR9O6FndaJC6raZTpXxcvKzY0BdVReBxZsVeiU4RbdpgmAcOXL3Zv/+CCw1yHYabm2f3azUTKyjJ7e7EOowtD+HIZ0xEruqJUPIwf2i9Qlf5bK/W5MqWPBtkoqL7nrM9AK3k3t4WwrrN+YXJe/JU1poL68zI8K4toDBc4X1yTlibwdaQsePOHdczZz1VlWmBrHcWm0sH8Hndybyec5nbQ6guJvSaG+usSUmXYXEpUhXtdX9SsehGGVhSu9PSsagXyeDeAGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=dc4OS6w9H7MWJ8lNUXX6rMjtoDHyP/TALI8zAes3eyH60Aa+wjL8dzxWQQr8PkOFV6uTcW9EgWfKVjPXaTDNvPJtKUVEoj86YKPKAaxQi2Z4WoM6eMenrkUEhSbDFpghr5lJ4T+E5cNHn/9nSlmoEvtMGuznkHrfeLY9q8GKxh7ZoOHQGE/hB2iDjxRotd5OX31xONAC0RyW9Buy8TB7zFKdD5OquRnz12LoxapGZcX8Jnc0a6Qk4dvVU7cz6awv06q5z56zTRWSDzfI4fof1SQJC7DBopVXnECMTMsqdbJwotXLZvPi+I7i+AdfPRhNpZ+JUt5QE21gDlgklQg3xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvXyO1FAoUKbeW4VhM1H2RCETNXJqwNztp/2tQfyuq8=;
 b=j328DL7/wfrBOjAGCyEdnFQibpSUy1HiNxH+UUGceNFwjWj30XRdlmfM50hufi5mOER+V3iexSjDK0V0u/0y0cEdDAWXn4IeipzIIwLVLC24+auF3dwDwfRxyAhI4QUZWbeQ3VBTJks4zTuw86HDE71paKo+yfd8wHRawyYupCmAjEO4BLU1+z1urYtqdjWsTSVkdnyFEVN4qzwvKbAvWUiGiWt5h2ktzRQlomk3UJq56NFvlqO3W1USP60qr/eRigCWNQc2Vnm5pHCuonpX0f+tzNRehViFrGFaU4yc/hGJ8bIvFJj62z6BLNo2qIbRSS7OWc5AvJvb52np7+IRMw==
Received: from BN1PR14CA0029.namprd14.prod.outlook.com (2603:10b6:408:e3::34)
 by DM4PR12MB6423.namprd12.prod.outlook.com (2603:10b6:8:bd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36; Tue, 31 Jan 2023 09:11:07 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:408:e3:cafe::ef) by BN1PR14CA0029.outlook.office365.com
 (2603:10b6:408:e3::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 09:11:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Tue, 31 Jan 2023 09:11:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:50 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:49 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Tue, 31 Jan 2023 01:10:46 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v7 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Tue, 31 Jan 2023 11:10:23 +0200
Message-ID: <20230131091027.8093-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230131091027.8093-1-paulb@nvidia.com>
References: <20230131091027.8093-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|DM4PR12MB6423:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c71adb3-65ad-407b-2945-08db036b1628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzsbLU4gNvHgWlDMxYsczYVpBApk1YxxRaaLgVjl2hyH4pPtzX8u5YCtmbF13e3kHINVxd6PygErFpu5xbvqaZOj6MC/QOGRC8u1ebhpwQ+oJxZv7UP/4YcSqBJdT6G4Jjle912uEuvaltvcjiNgFw/EWEaD/DaxKYksVB1paIoWKSP0gm4vPTN9d2aBP60ld1Bs/+VUaDPTFdhAdCANG2scAifgh3vKoUxRgHeq4X+cAATmKKbMXgnOKQGTuXabkvCHRCeN246loZaov2mSlLmH285OLLDZ0pE6HaScUo8SF9i9jtjePVEM7+W+gypBGr/0zIwsSfoDwMsDvT4Rx4xuMvglq+PjyivkAg7Dc2BbO9NHWvPyLO9+ICRYll7CFbo5ywihAhA+diPNCmeENKrflSXVTQxwIwjN1+QrBkkHxzzxj1iW3UQT8oI75V1is76aP8lmRWdvMHfma8p1DHhCYp3hkdqKeD9esilF4bE83in05nHfmctk49omDi0y52gbBzSDN9jPRwVQHkUEVUJTxzhNh2/EfvAvjPLUZPDcUSpVryjjB3kdXSQA5nzpO4Vcu4Cs48rC0XFqpJyZEAfVS7kwH0RGDryBYDMNzW45gmy1lwrquHvH5Fkh2jISQRpxpCEgR9dIYPDgYwwmR+PT7RuKn2FFpPSIkPdKhrfnA3JGNV7/72uF5kjENBol4DqG3DtLiEKn66tHgiANVQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(356005)(86362001)(70206006)(7636003)(82740400003)(36756003)(110136005)(5660300002)(316002)(4326008)(8676002)(54906003)(36860700001)(8936002)(70586007)(40460700003)(82310400005)(40480700001)(2906002)(336012)(41300700001)(83380400001)(426003)(2616005)(47076005)(478600001)(26005)(6666004)(186003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:11:06.9296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c71adb3-65ad-407b-2945-08db036b1628
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support miss to action during hardware offload the filter's
handle is needed when setting up the actions (tcf_exts_init()),
and before offloading.

Move filter handle initialization earlier.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_flower.c | 62 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531..564b862870c7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2192,10 +2192,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	INIT_LIST_HEAD(&fnew->hw_list);
 	refcount_set(&fnew->refcnt, 1);
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
-	if (err < 0)
-		goto errout;
-
 	if (tb[TCA_FLOWER_FLAGS]) {
 		fnew->flags = nla_get_u32(tb[TCA_FLOWER_FLAGS]);
 
@@ -2205,15 +2201,45 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
+	if (!fold) {
+		spin_lock(&tp->lock);
+		if (!handle) {
+			handle = 1;
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    INT_MAX, GFP_ATOMIC);
+		} else {
+			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+					    handle, GFP_ATOMIC);
+
+			/* Filter with specified handle was concurrently
+			 * inserted after initial check in cls_api. This is not
+			 * necessarily an error if NLM_F_EXCL is not set in
+			 * message flags. Returning EAGAIN will cause cls_api to
+			 * try to update concurrently inserted rule.
+			 */
+			if (err == -ENOSPC)
+				err = -EAGAIN;
+		}
+		spin_unlock(&tp->lock);
+
+		if (err)
+			goto errout;
+	}
+	fnew->handle = handle;
+
+	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	if (err < 0)
+		goto errout_idr;
+
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
 			   tp->chain->tmplt_priv, flags, fnew->flags,
 			   extack);
 	if (err)
-		goto errout;
+		goto errout_idr;
 
 	err = fl_check_assign_mask(head, fnew, fold, mask);
 	if (err)
-		goto errout;
+		goto errout_idr;
 
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
 	if (err)
@@ -2279,29 +2305,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		refcount_dec(&fold->refcnt);
 		__fl_put(fold);
 	} else {
-		if (handle) {
-			/* user specifies a handle and it doesn't exist */
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    handle, GFP_ATOMIC);
-
-			/* Filter with specified handle was concurrently
-			 * inserted after initial check in cls_api. This is not
-			 * necessarily an error if NLM_F_EXCL is not set in
-			 * message flags. Returning EAGAIN will cause cls_api to
-			 * try to update concurrently inserted rule.
-			 */
-			if (err == -ENOSPC)
-				err = -EAGAIN;
-		} else {
-			handle = 1;
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    INT_MAX, GFP_ATOMIC);
-		}
-		if (err)
-			goto errout_hw;
+		idr_replace(&head->handle_idr, fnew, fnew->handle);
 
 		refcount_inc(&fnew->refcnt);
-		fnew->handle = handle;
 		list_add_tail_rcu(&fnew->list, &fnew->mask->filters);
 		spin_unlock(&tp->lock);
 	}
@@ -2324,6 +2330,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 				       fnew->mask->filter_ht_params);
 errout_mask:
 	fl_mask_put(head, fnew->mask);
+errout_idr:
+	idr_remove(&head->handle_idr, fnew->handle);
 errout:
 	__fl_put(fnew);
 errout_tb:
-- 
2.30.1

