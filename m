Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9DF231362
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgG1UAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:49 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729123AbgG1UAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lp0GJk5Hg32jhvHekgS/WVeMPgqLOjIV+J4WUFkLsPUeKKSTfWunnybp6S2edXgtTYWHMfiMcTI1FIsKdyAVtv+2v1p2zyGVGCcLqCkCH5PcJ28H1Q+doZUh/cUoOhl7ZyEZINzjSio5YZFaV2asSJ9G4Lr/QuA5V14U2uHvrZlSmckd+846+XjrawtjVOmLxRwN3KLIv+aqG5q1vEreXUBRkVVpxEcJnq2Qp8Y3OCISiK+/m/O+otLtVVwdP7sl2RhSOWzkIxgFR832H6wHi72/TrQFflxbbGLmEHugteCTFubWMMNq2tsStsNE4PoPr1ue6Z7xSvYEUvKyzJQwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eh8jFVtjX8y2ZaPHudui6VQ5uy62eUgokPfk15A2a0=;
 b=htnLFAd9x25BLiN1zV/j3OIm3MAZvMmy4y/dwY0J1Rd4zzlJeZNDReDuGOh9cE8Z0ogPB7o9pz8PE1tDXsAXXkYsn1EqX9QP7s3T4xsCgv8QB/3jp8EL6gdaSWtUAZFk/ixpdsGkvqyR4a4D/lderBcmDl6AnXI50AhFVHlZqskFpU4wrHLbcAIzwl3bd1QlHCBIVzPZt6HOAeu3wJVkAH8Z7xN95qCqdFYRoFqp2air3Id1nAslRB/I1uDAPaMLhTv8UokxQTDz5Hlia/qsv2vr9WCpnWw75OiBaCnnj33OSRqUB0FHCpTbjYPjvBYKnnGOf8iqMvFxxiCSzJun8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eh8jFVtjX8y2ZaPHudui6VQ5uy62eUgokPfk15A2a0=;
 b=GJyS1uoEsVjyZcUWqOip+M5jC2Ap5J+4EVlzQkEizUBk6nyaPO+GwA89A+7wwGeYcE4wTAZvtoIsXCRdfCR4ULMw/sf1IxBXAhEMmNsemtKHZAJq+yLXFJOmPVN+hvekYwgziNGofiEoRtIVdEASJVL1HBldprLr8kak31Y/qbg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 09/11] net/mlx5: Query PPS pin operational status before registering it
Date:   Tue, 28 Jul 2020 12:59:33 -0700
Message-Id: <20200728195935.155604-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:41 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3fd92c02-b84a-404d-10ca-08d83330e8be
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25920E3CED79E44214A19ED9BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXZgAO1lONKFhFTueS0ThB6+oYe2NL7yjfzL23XX3B1Ig47mectUfWZL15dlnwFAZeZ1vt48j+ot0Hlhl1eCAgfmzC/KJp2WpKI7lwtGKhCdsbt3D1qA+P20pRGbtx6QOu7HTjsfRvkNeatBLuTjyl/ZjlHYiTe+kP84y33CsFhni+n5UfP9vku8UW8HebtricHCvZLwLZYj2JDuupQ35O7RQC8VIRMcmkpjCEDjObK5E8pESQIJa0AvoY1hyS4bnLyI7TsPD01ul7NorqlMuVlsPqUWcN8+U1IEP4FK8PhKp240jQfRJqHF9aw+CeFK2zZ8NxH5U+JAinuUMAz/3AzSRa3aqm/OssIFlYdaDTPb+6A5fvqhYuTvcIieNZlG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CdDV/VDMUyK99fQ5FHNdupU4ZDDX0/3SqVhb2E36Loc1KTrZQukt7lSySAtOa6glsfmmaBjn7JKav0Dluoq35Ot7ciltray/y0oeN14p0GvGmO3cS2Xb0Zakz9XU0gE0AroV7nZKRLsUAmvLW2IdBTk/EkwC4Ps/x+zoszo962qEUzA++tSfkAoBCElnP2zZtyqI+f0B4Bwjn+f3xTymGx9fMAKEQiOgRrQ30/z2Fkk9H/T9jL7jg64HC36oX8Q/YyMyB0v+mMu2KyR3TzIPo+Az5sBZOGl8QR2k8vqh7HLP4tGOGCKCWtW78J/12jRMD7bEFyHUrwT807/dJ1MQjAxYpEPl3i6KGtmq3v+mQWjGlckK0eKSZsxVhBaMRBk/1PetwsH3XQwZ9kSCgpi/vDr6VJl+2tJCFZdQs/ZDKaqV4E3AzVavWYjyeXu8DMu6yrrVLfxSR3nJW/8EmzdH1M6Airp9OHOZXt6wpMpjyOo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd92c02-b84a-404d-10ca-08d83330e8be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:43.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEZ9afwlw1qNtLvuIqE/jEp+9XtnFPLi10hGlCyjIhn1M83UWXN9nIgdV4arZT3SRuVLEl1ozoderFNRANaqcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

In a special configuration, a ConnectX6-Dx pin pps-out might be activated
when driver is loaded. Fix the driver to always read the operational pin
mode when registering it, and advertise it accordingly.

Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 284806e331bd8..2d55b7c22c034 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -452,6 +452,38 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.verify		= NULL,
 };
 
+static int mlx5_query_mtpps_pin_mode(struct mlx5_core_dev *mdev, u8 pin,
+				     u32 *mtpps, u32 mtpps_size)
+{
+	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {};
+
+	MLX5_SET(mtpps_reg, in, pin, pin);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), mtpps,
+				    mtpps_size, MLX5_REG_MTPPS, 0, 0);
+}
+
+static int mlx5_get_pps_pin_mode(struct mlx5_clock *clock, u8 pin)
+{
+	struct mlx5_core_dev *mdev = clock->mdev;
+	u32 out[MLX5_ST_SZ_DW(mtpps_reg)] = {};
+	u8 mode;
+	int err;
+
+	err = mlx5_query_mtpps_pin_mode(mdev, pin, out, sizeof(out));
+	if (err || !MLX5_GET(mtpps_reg, out, enable))
+		return PTP_PF_NONE;
+
+	mode = MLX5_GET(mtpps_reg, out, pin_mode);
+
+	if (mode == MLX5_PIN_MODE_IN)
+		return PTP_PF_EXTTS;
+	else if (mode == MLX5_PIN_MODE_OUT)
+		return PTP_PF_PEROUT;
+
+	return PTP_PF_NONE;
+}
+
 static int mlx5_init_pin_config(struct mlx5_clock *clock)
 {
 	int i;
@@ -471,7 +503,7 @@ static int mlx5_init_pin_config(struct mlx5_clock *clock)
 			 sizeof(clock->ptp_info.pin_config[i].name),
 			 "mlx5_pps%d", i);
 		clock->ptp_info.pin_config[i].index = i;
-		clock->ptp_info.pin_config[i].func = PTP_PF_NONE;
+		clock->ptp_info.pin_config[i].func = mlx5_get_pps_pin_mode(clock, i);
 		clock->ptp_info.pin_config[i].chan = 0;
 	}
 
-- 
2.26.2

