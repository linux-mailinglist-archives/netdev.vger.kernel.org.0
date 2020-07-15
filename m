Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860E02203FD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 06:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGOE3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 00:29:04 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:25072
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbgGOE3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 00:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5YmtTa51vwdz19Da7inZylZIDiCuMZw56+Ts6cbJFk17982ouB7vUJQYFD62bKYMmyo2eIV6EISxTu0cFI7leHBRB4FWM+MezD4rBvm91udPi6837kXcosbquWdvsJUGjoIS96eCEJhkjlTbj0XlwJXnNCfqAnMrO4cGV6idVaX4Vh1iFPojDfOV9AhTCTuxK3eDF9Ja1Pcg333dWykgWGv4vHdhjJYIHGkIpJMEfAqMZ7lwXXpCV+MybmfH7BwA90eQ2OejAe+19vBg/5QJ23zxGtsa1bjF3GgcDoY7S6/klbPjF7dbXWmsS2lISAd3iTudkV9gHqtfp/62MH+gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVEJTANcdFyb/r7JTXi1Bs2/sFOD8GHzSsntX1SDf+U=;
 b=Q0i5agj/G2xWxirGlqt5/Y2hEuXLpeFK0u+ViabteHKT6Km5FKgDCJkKsm3+5vG+1KY6A4j3I3p1+WsA5+cp4GaBocS5kbrLTCul7YsLQrZm8rnCvPA71ODNbV9gMLfYhXeUZ+n71MYl6KZI2cp31bVIySWZEMZvHo1CMG1heKdjemaZ9DaLpRjldZ25678sinG7WZWOCq8QaxKN7vHiVsLmIJ1dRI5y1iAjXq/HyV2fVYe7Ma8vnunhuW8AtSAMQ6cvZRmfBnOmiN+9Zceena/7C6AVlT/W2T9jadxMju3Ss91eFb9g9TsIrW1Ie9rc0G6ZE0a59nUzAJZsl3O2tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVEJTANcdFyb/r7JTXi1Bs2/sFOD8GHzSsntX1SDf+U=;
 b=eHmoqJU8TncUjr0O1I6awYmAXFjXOcFN+pwGCxrs7jgprmbe/UeAx/F/CbC+LbArfUOFBLGNPov+yu60ihHIhrrpkpKWH9VnZHTXqPOkJjW0aqaQcQf98rXQc4SijYLIrkRpRv6uB9PmfkQHcqre6nJ/iVQPYIE0buYt0M7Y/zU=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 04:28:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 04:28:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Support setting access rights of dma addresses
Date:   Tue, 14 Jul 2020 21:28:32 -0700
Message-Id: <20200715042835.32851-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715042835.32851-1-saeedm@mellanox.com>
References: <20200715042835.32851-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0096.namprd07.prod.outlook.com (2603:10b6:a03:12b::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 04:28:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: acb1345f-e639-433b-2e8f-08d8287797ed
X-MS-TrafficTypeDiagnostic: VI1PR05MB6655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB66551F76000E3938AF052F56BE7E0@VI1PR05MB6655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4S+4VSNBDRywG749vLR8vzhfcn/nIjzcabhGLprmBCJa1uAr86XkSULoAGAIy3Vp9gubhFv3uM8KrtYR9KENxFU9fJ1VEblGhYitrKQm8AFIzaGWvJ5HU0qUmiCLYUrQ6aYBYhrFn3QQjNFqou0p/f97e75GI38v+aWgabKQrTs1yNqOFXaSTdrOM7MZzxXmb2lfRXckPQnkTMWNxR3lHeS7g575Ut/qGeYiqfOPgeMbCQL2YQ7Z5Ei0wcq78rp8cxPKqOMhtvZQEgP44c8y1o7i6F/mGnvdBqL6DrwuDMuRD3oUEieJXTUkCUXga36YrKbPd1uuBPlAyTAgKwKmkrzo8AnBkD7o8JSoFAblLqOf0YMSr7AQUSYjMFARLoPN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(83380400001)(6636002)(6512007)(2906002)(107886003)(1076003)(6506007)(8936002)(6486002)(478600001)(52116002)(86362001)(110136005)(8676002)(5660300002)(6666004)(16526019)(956004)(66946007)(66476007)(316002)(36756003)(26005)(66556008)(450100002)(4326008)(54906003)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VPnvOml3OPrxqnE18x44CAwzbepUgh4uXeFiG5MthFfXTxbrH3OqMPP/IHwZpqOdDVe/lM8qzWbSw/ffduO9jPGNKZNx3Ijt99aec4gY1Y+TjXtV3oP2Z1AS1/iteRk3GYHRLKX7MCv93AusIIoGG/FaEDnux1hciLetkFOkP9XPn0wFNMN0yU208kA0Zm8k0jEk+c95bT/WAvQ9+TvJ9OSV3RWR3RWvZlfZuZFwYAdQePb2YnuU2bubnXwGEJo1dzZZISuBocJtfY0PB77CTyBIzcPJie/6aBR5IX3CivGc+UD/ZoAnK3EvpvtZTqwe/3U3iyLjfdejgdledc8GRONjcwnf4qP1mSdyoGzsh/o40V8oVaq0oKEIJXb5m2l2fQzAqeF9hLunPVagy9/znkQqdBlpR5DjVjRfcleDiluQO46J34S69CPpTnUltseFeFEyYjnevZB27cy79OmIFASWuWo0lNq3d1T25Iz5uKc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb1345f-e639-433b-2e8f-08d8287797ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 04:28:58.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEDQQVjV8IjQUsrCg4cPPMqMbXmrSx61a0qk8+BZcA2RsSHGXeyg+loMi8v3lqa9uQ2iZEDJZSstwrtsLER5zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

mlx5_fill_page_frag_array() is used to populate dma addresses to
resources that require it, such as QPs, RQs etc. When the resource is
used, PA list permissions are ignored. For resources that use MTT list,
the user is required to provide the access rights. Subsequent patches
use resources that require MTT lists, so modify API and implementation
to support that.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 11 +++++++++--
 include/linux/mlx5/driver.h                     |  1 +
 include/linux/mlx5/mlx5_ifc.h                   |  6 ++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 42198e64a7f49..8db4b5f0f963b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -299,11 +299,18 @@ void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas)
 }
 EXPORT_SYMBOL_GPL(mlx5_fill_page_array);
 
-void mlx5_fill_page_frag_array(struct mlx5_frag_buf *buf, __be64 *pas)
+void mlx5_fill_page_frag_array_perm(struct mlx5_frag_buf *buf, __be64 *pas, u8 perm)
 {
 	int i;
 
+	WARN_ON(perm & 0xfc);
 	for (i = 0; i < buf->npages; i++)
-		pas[i] = cpu_to_be64(buf->frags[i].map);
+		pas[i] = cpu_to_be64(buf->frags[i].map | perm);
+}
+EXPORT_SYMBOL_GPL(mlx5_fill_page_frag_array_perm);
+
+void mlx5_fill_page_frag_array(struct mlx5_frag_buf *buf, __be64 *pas)
+{
+	mlx5_fill_page_frag_array_perm(buf, pas, 0);
 }
 EXPORT_SYMBOL_GPL(mlx5_fill_page_frag_array);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 13c0e4556eda9..f2557d7e1355c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -971,6 +971,7 @@ void mlx5_register_debugfs(void);
 void mlx5_unregister_debugfs(void);
 
 void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas);
+void mlx5_fill_page_frag_array_perm(struct mlx5_frag_buf *buf, __be64 *pas, u8 perm);
 void mlx5_fill_page_frag_array(struct mlx5_frag_buf *frag_buf, __be64 *pas);
 int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 		    unsigned int *irqn);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3786888cb1bac..5890e5c9da779 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10653,4 +10653,10 @@ struct mlx5_ifc_tls_progress_params_bits {
 	u8         hw_offset_record_number[0x18];
 };
 
+enum {
+	MLX5_MTT_PERM_READ	= 1 << 0,
+	MLX5_MTT_PERM_WRITE	= 1 << 1,
+	MLX5_MTT_PERM_RW	= MLX5_MTT_PERM_READ | MLX5_MTT_PERM_WRITE,
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.26.2

