Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D0823063C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgG1JLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:37 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728403AbgG1JLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0/n82hQwUWyjQGgsbGbX8p3TktH0B6vOb3Lb5Y8GKh9frw8104IucJegoPiq3rsW/JBZpC5fLYpzvpKHOioDXBAJxYCx5rXio1K3hFM8ZU0D4Sk2R2YgMVGXeqGyyWLcmAVBCuRhGq93IYx/XNpkVJdDgli5F+k4KIxIbsvLzpcdy6yL5HXTbrwnsR0rJlKkM1grxdeixxmGRtAEkwPFTTZBpKQCSCANl5FZEeAw7XAYQaqtdNUocyfWw1OALOE3LORjH4pmAR19FLbufM2WmU6+82N6FbS5CxmYeAjFixeqfLemAm9CzmUXNh+kn3JVqDg/aw4WvdnB90lS2b4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eh8jFVtjX8y2ZaPHudui6VQ5uy62eUgokPfk15A2a0=;
 b=Xbpj5rLuYkZujAGNHFqaUsXMpdG1+E8Si7E6yXVV+O3mMzz785gkrPvP2XVOmnD16qxW6iX4U1pIQP3XolyYJjP4d8887EocWoEwB9CKlvtp23WAkXMVRYKOjJJNyEq+pFl01TPMnVsAnc+hGrgVNp+sKQ/M7MbJSiL+HzteTbwFbUPNNW/ww9dHifq/oW8lXuBkEnAh7DXagrC1RTtb2nTDWqEzG8RKvaUc2uH+6iKRrhPVUwZ+jxzxw89FHRujsFmwMDQECzerjQVb82AuBD9qsOy2532DVjH2bkQF7r6C4Z37AW8fyVh5lT1ku/uutZigftDAEL107v8LtuBa7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eh8jFVtjX8y2ZaPHudui6VQ5uy62eUgokPfk15A2a0=;
 b=VEnWw/6nQxnXdplwgQr94sjByuZimA0npc7D5D6fGMDTSdZjvIGMwVFHrCwS9tGI0gwmz/FlWqkCCbjLXgST7u4ljFbbf4wHnSrI8fJ3/YRMuQpxbNwpk7QzWRM4p3U9GP0F+iAK1qXk3rajlGFC3SzmmzRXB2y6dxvjzv/4sPA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/12] net/mlx5: Query PPS pin operational status before registering it
Date:   Tue, 28 Jul 2020 02:10:33 -0700
Message-Id: <20200728091035.112067-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:29 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33205a18-358a-4372-1254-08d832d637ad
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46387529959238940298DF36BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJtCEuYaNET/UHSLqoE1mEZLK8JpYrmgRVvxaSsWA86E9iZTXleZq889Z3aMfvaOQFmkm6OqBjdYstVdq7j5Ic7sWjiY1WyQ3dlQ6vduXqOSLKvtcVeo2heBopQih3/BrzVqnACZZwUhnaqysHqsvc7E+HS20mZ4Z+58Zpf+bTc3SOp/WSVRUeynnJA7cqIFm6FhUjRQo0K40Qb5d8R74Ww84F37nOZElKVdmeEdLFLQJ9q/GQegjLZLy5LQ9Mvv0yrc+aftCUB/3hvUxNu70EAzvOEfsB33njIqr+/tVIy2st7nJCFLxENpN8dvV3BnMNMxDuALZ7lW3jvtJ4AYHpt9oDJJFB3k/sC15ci6odfbIiGTpH3OHkufxip0MalE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kRrOBHC2DApmbtrrq2BfrV9PJ3qQ7hg9uwF8ceUvMqZqinI4SC/QZC8nMm+7d6YIXWl5/FDt41ZW0MFKdnFcJgtD6vEKiA3Bggm16aVzDV6AsMIUQhfxwNyCmgpImvPG4InMx7zPRmnoVOu/LVUAOGa301flr7JUbpnNbb5l2h5GmTUPgxiQOA3PPyZt3gfSksMO1JJLgcdVOciiY5yYHojxSoacvGdwjIbQB6RpNFQMRACifLFvY7iL+I2GhLXvunSFaPfConMLyoSmEXi/FefCOyBnJQlTKr8kWgMB/pvODz2kC8SVZZjZs2HYGxZWKwxwDFzvzsngxrzkQfZN+BOTJ2FjUmqpOL0GgaWxuvssr5teu31IgvC5sUI+oLkBuRmUjsjfuPDoKWkTqHoJArYcIcyFFBmV+5PSub2J8GHau3ffcg2SSDju2Y5MjrPT6kark3aoBU78HiO9xe+nuba+/O/WUZi5UQ7ovAcYgEc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33205a18-358a-4372-1254-08d832d637ad
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:31.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nql3bLwQX7xbp9YLFBHVVxh9HN2IQvqk782ru+FwD+1NeIniacdkf5EUHFc+CDsIA11BrcNdXLFeqHPRbZfBMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
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

