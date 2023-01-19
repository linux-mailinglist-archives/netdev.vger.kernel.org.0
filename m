Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB0673399
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 09:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjASIY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 03:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjASIY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 03:24:26 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACA85EFAC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 00:24:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9Ho1jlPH55L02az5d2+U6ccTXDzEHx2uhj/OpkRfkJ/qk5riReLlYtbIFiqpFbFmVFWrkr0qLLSv9yHk7I+vZbNepMbuk7tHS24qoysAcHVEHJxO+D3QsplF1FfA7QrGYRnJ2SeLiQecPW70u9ogrDFXJiQz25W3j6uninYDRSaVU5NTMsrEn6ZLSvvwMQ8qeuVFU5ZAHhbACLk7NxY1S0zjS1KHXfbxtTQ4Upa+KnnW/zZvxN2iqJnLIgwptWDGNEhMOrmt8fIeoh3MRn543RzVdtQtcbvRhjRHrUtZDO/gif7x51SD6vYZNGSrxFSlQwmoOHHHlmaSq0GgUcGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dekDPZk9FxgXf3YJSkVjUhM6H/42++P+Sk+buldWDpQ=;
 b=HTT1K5QjcGPJmKLgRXKosvTHdARq5uR2JV4UH1eIOMDkg7EhLFTQWrngDeQneNCxrATBht6v9w8tVThfLpWv1Ae+Z3K4pH6vQGCuICf5LiwJPUb5W4EhkPLuoRLz7zL/CfmcbJQo8hz3293DFmwbfAtW2dUK7IN0gTVCz82/GdkHSb5m66KbgrKpxJPbhadZ4Lg93veeKyDdmFFH0tayrNOxePEF3HEtO2wqCISkTHS9822guM4NPRrErPQKGL1iaKJiF+CgfOFy8e/qMbZ9i7moCQqMXa7pfswOgi10ITBAeN4dG6eF7BwqblsDhRKa9WfC59mPh6ziDbkMSAdkvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dekDPZk9FxgXf3YJSkVjUhM6H/42++P+Sk+buldWDpQ=;
 b=q/XKzsqo+9cfYQ6OdRXUTOALNN5XuvukrFM2OGHeiTD6LSWQ5LZWSIrDek7pAVlzTzNB9eSbDKa/Qycg8WsW3D/ZLDe9GAU+SBjGnQQVlHvZDrAZYSfjXKeECvRiK834Z1QO3K4qx0JCN5hBu7z+3sO7x1c37JlNtqVQ/EpR1OKQ0sN+Do2fl0mG8Ar+a2xZBbepdVJgMIlrxqEFuhTlMQtzzFhum5xpBkl1rRL0bYnLcoi0FvTagAt29dvjvllGe4BZ5tcG5TtG0jHiNOO9luc7uAJwf/JpGVFCDiepBSTEG+RyBGHR35GMTpQTxZF7Hv/B8CgZAU1kwsQ/wIYPrg==
Received: from DS7PR03CA0102.namprd03.prod.outlook.com (2603:10b6:5:3b7::17)
 by CH3PR12MB8401.namprd12.prod.outlook.com (2603:10b6:610:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 08:24:22 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:3b7:cafe::c2) by DS7PR03CA0102.outlook.office365.com
 (2603:10b6:5:3b7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Thu, 19 Jan 2023 08:24:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 08:24:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 00:24:14 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 00:24:14 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 19 Jan 2023 00:24:11 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 2/6] net/sched: flower: Move filter handle initialization earlier
Date:   Thu, 19 Jan 2023 10:23:53 +0200
Message-ID: <20230119082357.21744-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230119082357.21744-1-paulb@nvidia.com>
References: <20230119082357.21744-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|CH3PR12MB8401:EE_
X-MS-Office365-Filtering-Correlation-Id: ad17e3ef-2b5c-4ace-2999-08daf9f691ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FfhSfmllEyyR9EA/uJ+VtvxyTJ/xYRU2Hfg6gsCy9etLEgOSPeiwhUta7wWX+e2asTGRvILgQQsFzobt5cX5kdKA7J10Ayoq9PwatHNS0HiMYwtft6/a8b+23hdRupgT7FK336oWdzNlT+ojmbsaMOEhcTcJ2+dlLr/G4S2mlF6auGM/vKhJziDWrFelu/GbsnoxYlmShxIxW2nexpcXycDktVP31JMxj624hHW4v4IvUnyPbYfvn2L197LC4eGJdT2PHUFPAjC2A+HdzmEkE/xnJvFH017r9y+wy5G5KSXPGEbH6LNCvZmzazwLZxhFnqFKJPDeV42eFCpKKn3yNAcP6wO2jbbz8cDch6bihLq2S+Bkq5L8AHUZNG3jMyurp3148A+IBTLYmX55FD0w2eJ9c+y+HBLf/bt9G6z+Uhjxv4X1BBkLZRG3eO4V8HCT3Id20dsGmrZOHv4hzbEQdtySPTeD5oGIc21NN3aGXPnb1Dm+PAqKMS5hY7RiRyUQxZLbLewhgiPqaNRSEPimF3T1yQQO3m7rnEXMPoL0e+iAz+dwj3oYkFp3WeBaJgJl/K2eEMQKk9OsiHILCXFfM+RJGLtbufaPtE7Om5+R1RfaKcC2tdDVRsgBAnXKzKevu2uO720721e0rRIVY4udE6UOs6HPJKqSxu72/PXxT4E36TKdRwfgDhExu20qe1IYRy8jh7JVUPCT7HVVrsXqg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(40480700001)(478600001)(186003)(336012)(40460700003)(110136005)(54906003)(6666004)(70206006)(2906002)(4326008)(26005)(107886003)(8936002)(316002)(41300700001)(5660300002)(8676002)(2616005)(47076005)(36860700001)(7636003)(356005)(426003)(1076003)(82740400003)(70586007)(86362001)(83380400001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 08:24:22.6255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad17e3ef-2b5c-4ace-2999-08daf9f691ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8401
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
---
 net/sched/cls_flower.c | 62 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0b15698b3531d..564b862870c71 100644
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

