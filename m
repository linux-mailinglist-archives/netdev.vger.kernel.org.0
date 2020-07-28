Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76315230630
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgG1JLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:07 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:60054
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbgG1JLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kad26ETQu5jmzvowCBOkg6DeXQ6GvURPA2zzCweV287RlzxfgLAnLQwcYHjfy6zUTAVQ4ezWFPkLTLgo9qEbYvuG3EOBOLrU+ZoVFLDjYuWAJnnPTYtX9adSEo6y1yuFZVMEOTNymJoFjxsK7etCFpFtGcdDTP5sk7GAIxC/E5fNjmEaJN4bbfARlswiQ3hw/17jVb+dRtE93Hdxyhji0atfcf1d/wW/9endSPalb8aGWayo0k1Gyszsg7vfffOwx9HiEOfuDzd5ZzhqFJ2Ycdv/6efQ4PJ9LnByt0bZW4mVS2jVfbEULCUOOuj5NMd+BBc0LTKzpaq5OC1B4kMWnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZuiqMnHww19AJqPSPMRbEjF3BYq5StuylbJqNPBZd4=;
 b=Ev13FrefKviC7U7egrJn0uuWlKaUM6yzIj5AgsL64wdz1lXJp/rBEjVGj5JuJnEttcqfAP/OOaOp9bGLmfpTKRzGqtIiL/+eG4kVLxMM5T2IVekn9A+XTuOtsArMmBH1TzA66AAls/lBYjbILFs2d87yVY2s/HhGjFWxk5qSiNZR3udB6Vp9aDCA/FXZKeX1wsE/Sp/lzX+MpuddYCBe3UMdh645dvZELsvnxo3JF3Z7pRLQ3E4tBQvGM7Chu3IqJH8R3Je46q8gyLjZYFGsflHPSUou5nDiV0/fLteefFbUpf8+br6eApbQ1sKMfZtwaKEsc/yeR9/TCajQRRFNxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZuiqMnHww19AJqPSPMRbEjF3BYq5StuylbJqNPBZd4=;
 b=IltUdIiO5whFNNdkSSPRhHIgPe7YoNCMLaX1rRkROiEZTlvf5xg5MbUz97/LgtLt1E8kzS3hNE6J6iUAZJW3A8QWtaO7m7hFzf+x2i/OKoY9ujCmkqLiu2PZxOWJT3BRThVaMvWsSru/syU6eKD6WaHgo7U+Cnt9rtuC3QkVj3U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4879.eurprd05.prod.outlook.com (2603:10a6:803:5c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:11:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/12] net/mlx5e: Hold reference on mirred devices while accessing them
Date:   Tue, 28 Jul 2020 02:10:24 -0700
Message-Id: <20200728091035.112067-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:10:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1064b7d-c43f-4c25-f815-08d832d6255e
X-MS-TrafficTypeDiagnostic: VI1PR05MB4879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB487974DC5970A98A408240C3BE730@VI1PR05MB4879.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8wdV45H7M4UqKQWJKv8EazfM317mBTlxXZv9eOq1AfHeRri4HAGJ7sOBFhZFBRKPJSCyMKglpAjugJ6jNEU6ZdSumR6ztbfQVmDocoJ63xkrCEarfJOKK70lv/ot6bYe7/l/tlIxxaoRa+3W4Y7lmLJ+N7D5LFwjqhvJgev5M/Y4SqwjW06RSorO6qayuOXGgLLARykC88xcSnWJnzEww4hcfmPcQpYpaWITq8JuW+mKxq+vni6Ul3BBQNtupoij3sIQEXVDjkXZ6mk95yST5my2ZBFn/ILwGx7ul7RmZXaCKPGBMpe9exXZCp6qpEOyAcGM09jBMdZ9xDHJJWTN8iBaR5lR92Wtj4xuVDFpukiizI3eMS+PC3OVmbMFAch
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(6512007)(1076003)(8676002)(86362001)(8936002)(2906002)(66946007)(66556008)(66476007)(107886003)(16526019)(2616005)(26005)(83380400001)(186003)(36756003)(6666004)(478600001)(956004)(52116002)(6506007)(54906003)(316002)(5660300002)(4326008)(110136005)(6486002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ccyppewK2ngXXZhijb1piEuQLpBH7+col3TasUB/84UdRZ3hjNDVudAVK6y9M3HS6r7t13dl1fxSEQXsZb/xGrjAKCacbauFpfuZCJw9Cne5tMJVqM1ILkiqBo376BVCvRNk1n/Mq/t2odHKOmVyiDmgXU4vyHK/1PkY0g7oOgmjYzkP3PRxhikmxFwHA6e2CDniKcH5fr6wO1yPcGtQita4miaIYpl+d7qtUUyPSCgIoljlBls6gTYSnj2BPcidU9GIHCIHFqu+gwySzWvfrtkM2HuM3LJX5p6W+VgCZiMb08nKARdcWk1W9OV5a26M8/XHwLv4zpTGYElfus3faqsUjORVZ2QupSnVY/ElnsDMisnR24fkz50vfBUMrNhJbZo6g+ixaeny7phjsOLIbFxAbtyFtcBTDDBImTBJGtKI1HmkfybN14nMZdL5LEWeIJG0I5mcyzc4PJN3KequmZCtNO4UFMV3gdTh+UI7ZmY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1064b7d-c43f-4c25-f815-08d832d6255e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:00.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWW/gDejOQu2z5vFCP6kThsSNifNShsB+D40rU+gZNWR0DNYLWqx2iRKNuv0kB/YvBamAmjLilZZk+gipEUaVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Net devices might be removed. For example, a vxlan device could be
deleted and its ifnidex would become invalid. Use dev_get_by_index()
instead of __dev_get_by_index() to hold reference on the device while
accessing it and release after done.

Fixes: 3c37745ec614 ("net/mlx5e: Properly deal with encap flows add/del under neigh update")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cc8412151ca09..518957d82b1ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1327,10 +1327,14 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = __dev_get_by_index(dev_net(priv->netdev),
-					     mirred_ifindex);
+		out_dev = dev_get_by_index(dev_net(priv->netdev),
+					   mirred_ifindex);
+		if (!out_dev)
+			return -ENODEV;
+
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
+		dev_put(out_dev);
 		if (err)
 			return err;
 
-- 
2.26.2

