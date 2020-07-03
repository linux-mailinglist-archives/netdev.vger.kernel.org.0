Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55A521329B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgGCEJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:54 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbgGCEJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+/r+zdlQsdmTWD+KPg/yoF0vrlHljBEhJ+CRdOW4fQkmTKuWpH8onW8FZ6o3uba+CX+2WJErijJgNkpNl+Nz8Wh9/rp7tvrH2gOLNJUbc9GOkBrEZ+kVsRoucS818D3iFjMQxpjlYBqTXIF2isAmeNoWm6zWK7rM1AV015rGkQ907IAfCRuZxy6T0gndsYk5YuiDGdcCGN+LFTgUjNG7kSE3U2DUrkANyrN0ZBia5M6Oezlt0ClY1NnVldPGSDKQ4Dawu0oFNNX/McDl7DMDLjxZJ0I2lnQ6ZDtzC2kdpLN6ZHPrFsrkyFbodI/p/VyJqE3GBmJMhLzd62OGGN0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q8I8pWpXFOR4il7scDzxjx3d6+vo47b85vhmjV2nnY=;
 b=avmIA6C0wS3m8dXD40J7Y2opEO0y3Qzs6F5ZYplNaOTnGSAHNAtBTP4WOyc558w6v3s9TgCkjdatpw8+PkRYkKHGM2kD+sS/7Ds3Eh5IOejT/EPffLiFWzqNXNacS79mlfZWYWBE2FU+p+0b/CNa9bY0NzWf/eVSFqKJKHNEoiB3JQT9RtDq8MZ3kUHXaH9PEUIN8CQTMB7ZpZRLnju6cvIDJqYSX9mW+iNlH/4oT/skYzogwk8ijT0OlSlRcMwLAfrPVIzGFZbGVUCHOy83IFxFGvfnKsXcXb2gzEZCb0TD4psEgYj6QvUY+ucZQ6RE+RckxXYH/QO18+ZWWPAkxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q8I8pWpXFOR4il7scDzxjx3d6+vo47b85vhmjV2nnY=;
 b=aPYMvQqiLgStJdVUgcC5wVlY5VWM39up1yz5+ih53o3i94Z2b0fXD9BYDtDBOHG+kLgj5hWzUWtgcdPfI4T2PygEm9hT6orEc/tSsJ1Kxi1j+8iGiab5SeDToHnhMiqtcj276nh2J+sz9Gzm2esc8J1ADDT4n/FNooFpcb1n1YY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/12] net/mlx5e: Enhance CQ data on diagnose output
Date:   Thu,  2 Jul 2020 21:08:29 -0700
Message-Id: <20200703040832.670860-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:20 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ab50e68-dc4b-4899-ba78-08d81f06dd4a
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB553419D7454A79627BD28A83BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FDDMszC6WWSwEPL0L85ruFbc8g+XtM344gjiXpxgTeQPf+OV5xnInZkSTYZCSlry2SsM20ieQnFi5PfdZ9D57GWwPoPbmHG8pcZYHs+mEr4OKgf9gmyO8W3ssPxkRi4PQybrpCcyyqMcZtrNOQaA2UdlDHMIT195S5R5RockJq24Nv1F16Qn2IXyklkhArbo/xWPi72gHkvcqTxGC+HjaBJqwXy1Ws1BzaYiknicge4LjozhLo9nita/JTxxY/00Mz/B8N16jN7Lydx9OtBAkgusmsxoZqaoqNnpc227K8LCqvFwRFNI48mAab3zE5Vk9+8WbIzxxqNeKlwrgs1erECnKgtTng1dawSDY1mA40476lkwb9j7ucDAISSxF82
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DLgrkdHOycja4ddMkzzqR47mqvhpBw2lL09RMHuTGVsGAv0h9cuo8+gpE9rSUqrOBeEOjj9audwoJYlb+Rh+ubb4psxegJYk9n0InSzGgg+vJbwp03T4JyAue/LPc/Q9eqP/ClBElCsQXfJEPUDlPMIT6uesWZSsD7Q5yQIvVX+PRuRsWaS6t+PAyD9IXyh7IleUvKEMZXvLf9emsCVPYqzlmJagGcJ5Oi6fvwoqF5KzllaqGgjYI0WcDyd4U69E5doZLiAEGUtks1Rgg96CJzAlRR0V5xb11xewBm3pSZUw1+aGZJO5Hub5BGdka+zcMWGiypDc9Vqy0GPiaPz4mDxhXz3fTnMRzbkQ4HUmTvCDSREmJSgIQKr8efl85Mttj3an1fSbTC/t3ixu8bfqEzbJdOD6Rs8eEjggc9ghQp7VYJIDSLl/zdLa1Gxn4sxfRWj3vXAu+q1KqRDElR3sPYnhAtoSY1cdRDx5WALXSMc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab50e68-dc4b-4899-ba78-08d81f06dd4a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:21.7591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGupKWL81SvttuPzDTmIQAtb1wRo8XNrNjvBntL7Lg2d8viE0QiScFOm8zq2auf/tV8lo3Yk5rzG3lzUprMJsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add CQ's consumer index and size to the CQ's diagnose output retruved on
RX/TX reporter diadgnose.

$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
    RQ:
      type: 2 stride size: 2048 size: 8
      CQ:
        stride size: 64 size: 1024
RQs:
    channel ix: 0 rqn: 2413 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
    CQ:
      cqn: 1032 HW status: 0 ci: 0 size: 1024
    channel ix: 1 rqn: 2418 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
    CQ:
      cqn: 1036 HW status: 0 ci: 0 size: 1024

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
Common Config:
    SQ:
      stride size: 64 size: 1024
      CQ:
        stride size: 64 size: 1024
SQs:
    channel ix: 0 tc: 0 txq ix: 0 sqn: 2412 HW state: 1 stopped: false cc: 0 pc: 0
    CQ:
      cqn: 1030 HW status: 0 ci: 0 size: 1024
    channel ix: 1 tc: 0 txq ix: 1 sqn: 2417 HW state: 1 stopped: false cc: 5 pc: 5
    CQ:
      cqn: 1034 HW status: 0 ci: 5 size: 1024

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 1b735b54b3ab..4bd46e109dbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -62,6 +62,14 @@ int mlx5e_health_cq_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg)
 	if (err)
 		return err;
 
+	err = devlink_fmsg_u32_pair_put(fmsg, "ci", mlx5_cqwq_get_ci(&cq->wq));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", mlx5_cqwq_get_size(&cq->wq));
+	if (err)
+		return err;
+
 	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 	if (err)
 		return err;
-- 
2.26.2

