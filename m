Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CB116F4DB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgBZBNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:45 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:6029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729982AbgBZBNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMCSUDgQ5vNNAOofhE5A9DhM/hfAC6wJIMz3uUhUnwOkKmH8VUGMXAsxR4ChpYZQc4ql9qTsttbLfThUbRtgr5P2o8SDkwUBY3Z3WETj1ceaOwTuzKFGALajxf9KiK+uq5QaWX+keqUfrbZTSdLrYttLhen1RxVTVmH11Jwg9KMkHGdlrGyn5K2/vBVYsypIREe/ZETsfXLY/BFY+fbyrOAfZKBU+BWw1XxyJDEcajpbwuseO3lMCDTjQWRZdHK81K10Q+bmeQqYxqogiOOe/LZOhtE+ee0R+1C/OML13RKQlkqhCBCuerpRcB1dQjIh71Xe1vzWIWv4SifCAo1khw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIjisQU9I/lJJkeAzc5Py1ulNcl+bCZMYc1sNe7bt6E=;
 b=HJohPYWn49XmVeY/+8WKwNX5jFCPkZPqjGwH2noyuK/ZnvyT7NkebpuqfJxXZ4qviPqJNktkhM6V1B4gZ+POGOkiHkJKh0khgM/irkB57mjBpjhnW1HzXqg/5wN4fzXP8OyppRKqVu6BQ9nagGI/DwdkRFjUjzcvhJXggGBVS3YkXKphpTchUfb5SWeN5DD6kYu/dYqFmkQiLajYem2vZMouzLGOUS+kVhWnVqqXJJAw79ON7Z3XheH0f9nwSv5gDFj9VAk3LB6V6fXuHNZYbCBeYzgb0F0gzR0+R+mvPoU/c/1Vo9Bo1Bgn7L5viQEq08D1oLv9mgmm5zAlgEXXBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIjisQU9I/lJJkeAzc5Py1ulNcl+bCZMYc1sNe7bt6E=;
 b=cjPikraEtVqwRt6VMiImfzTKOkJLtW3Zt0ec+AD7ueN6GZ29BI0Fo8IHp5jdJGFZflmAbvFpwNdtmtSbRI0C5BV/u2yl1IomnViU8xq3E/qPrfeAcreSOMt0TlzsYBpan89OLTIApqktRnpyocRgf8PQ0f+BoSNfuf5ek6tNrRM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/16] net/mlx5e: RX, Use indirect calls wrapper for handling compressed completions
Date:   Tue, 25 Feb 2020 17:12:42 -0800
Message-Id: <20200226011246.70129-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:36 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a65ca91f-5ba0-456c-7b83-08d7ba591bbe
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038E4538035C6C0EC281FA5BEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(316002)(956004)(26005)(52116002)(478600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrkl9p/0tMs+LopD0GHkfrHDvybIJ4VIlAr/lc4wt29v73XhSZIn73a42z5BvgQtBXh/CQR+5YZWHNEHHGIU60cYzkUg4Um1VTZU0OVLz7+y0gjljpVP+yYajo6sDA6io7d2TcGzeJL9pN9itc+Yy9ozd0vBp15mEVVRm5XTnTRAbL0DftMLm/oOUr32jJY1VVtGMWe0v55L2ELTR2HHTAox9v79BOXh+5KKPsdNzzpFA948LHxwra5X73gmeTu9ccKQmged84nX+s/GIRqMOAPnTHG+U0jhsIkj6yV6g6jaDX+JtAcpEDfzO2+kMbuU/aFCQJN52HgAmPbN9/uCcje86TNKcXxy1KodiP4kdSqadWPPTxFGrVV0C+lf3Rq47+E2JgsQQaTeIU7hpTBxWjUAox5cV2HC0ycfYXXotdJTYl6QOAPYZ2Ioc9F8j4nApQI+B46bvnM7GE+K4A6J++JeDThM8QuONeAfjAvcpZXWcNJ8pWQkYWgZ0O7flkHtajd/dRnFVzzEK4ok66prEPsod4trOtVSoLaXhUZ+It0=
X-MS-Exchange-AntiSpam-MessageData: Y2cHrEbTdJfvmWcrP8msvKD6m5ILcx+WmGPf3ctlH/F0k/FQxYS86Uoifcj1Gu907IzoBnD8QbDLjxu3fAMt/pIYRUYTsLQ3+3MecGhEjTzYY/O57B7yF6CnX2tEISMwdTchtRpSnn2UOrbpA7OE7Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65ca91f-5ba0-456c-7b83-08d7ba591bbe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:37.8487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcjRhwqOUqB4bRNIvl0uB7LlJyvs6Z/h2/WTkGal95sEYHxJo0l/CI1z8stJgUAbFw3rrDI4+JYKnDd5T0I4Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

We can avoid an indirect call per compressed completion wrapping the
completion handling call with the appropriate helper.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1c3ab69cbd96..065c74a2d0c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -158,7 +158,8 @@ static inline u32 mlx5e_decompress_cqes_cont(struct mlx5e_rq *rq,
 			mlx5e_read_mini_arr_slot(wq, cqd, cqcc);
 
 		mlx5e_decompress_cqe_no_hash(rq, wq, cqcc);
-		rq->handle_rx_cqe(rq, &cqd->title);
+		INDIRECT_CALL_2(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe, rq, &cqd->title);
 	}
 	mlx5e_cqes_update_owner(wq, cqcc - wq->cc);
 	wq->cc = cqcc;
@@ -178,7 +179,8 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	mlx5e_read_title_slot(rq, wq, cc);
 	mlx5e_read_mini_arr_slot(wq, cqd, cc + 1);
 	mlx5e_decompress_cqe(rq, wq, cc);
-	rq->handle_rx_cqe(rq, &cqd->title);
+	INDIRECT_CALL_2(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+			mlx5e_handle_rx_cqe, rq, &cqd->title);
 	cqd->mini_arr_idx++;
 
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
-- 
2.24.1

