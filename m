Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21F420A673
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403991AbgFYUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:01 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6061
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404632AbgFYUN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2OcaE7et0+6UqtVl4TK0SYTtWbjY3CPt/1FFU3MGqtLL9RR2MR2cxb5Fy/LfENokGXyF2UQ+VQnn44Touy8Q8Llq+toW2uOYRlMHn2i8+v4mTj9g4dAMt6S5acRDmrWAq9ArfeuSr5zLdvyS0PjtGg38uRe2IYns/nE5O7YJx6PJaq62yUmGL6Y8LJ10n4D0bTO/684N91Z2lZeWSVRf6tpldd7oxYXXADRxu11K1Phs1XYyLq6i/ZYljN6WAHzvsiVQP501m287ZbFUUjR9Ui1A/o5RhIBHYtkX0wpU1QNEOC2d4LqVSKoAwhKcIhZWSZQtAYUrL7UX6l2saL6LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=folVJ8qixIV8maxJ0uz5/lGfR8GjfGnhW8qapgdD+7U1JD6OabUqMd17E2GvyYP4wHEIVmivuhwZ6fEgkIKeXpjMC7GhdwWYy1ntFaFUvbt11m+8dS/LX9++y/0Mm+Y2J0QftNAXAsiJqK9NSZiR2Cvlq89YNHOvOIO8tPYFtw9YMyd+HrF9470/NIpZqwK4rwI2juqCT8NhIdjuhDUhjc+TS4GUi3bm+81V9ojyweJdMor0QCUvRtOG43thy6Nd9ZDqiH1b6EdTd3KsTMRAkqUSlIZ6oIhxHvUUVvLq/qX7+YdWbczPmTrZcJSFg9pPiTJEffdRLmQrQk37PbNYew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=tAhhj1LWxmZy7OtSLDMI1z1olHABKLC9LdKaY/Czu40vHFv1cJyTxlx+TvAjg2pn0nMIUfU0Lo3F2dvMwoF7Ckj/noCNpJHvYVYapvl7XRmTVpa6eFv9Ml1gXYA7OmYfl9vrnIwagmRSTxvNlZRHoH2OE8kjzuCOe9hXatzG71w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 3/8] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date:   Thu, 25 Jun 2020 13:13:24 -0700
Message-Id: <20200625201329.45679-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4950d7c-8170-494e-6fa4-08d819444881
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24488FAAB31E3E60E8F4361CBE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZJXu+xhKSfBbWfcFBrCrqkSv/CmVFcv+pg6+KNU7zM3KOgPLagGh5A3jre6EgwXMTL9KQctmkexu+hLBp0usHs+1K/sb7Reu6drhhe04mru+ihTQnaQZLScETrqOE06jJgZ7nqI59PhQtD9QC9CSiryrmcW8pTTHroV8vtv52eWxVAfp+Kj5y433fcpWBMxVhWHcHAxEmmO2Ik22BI/kGTb574PnNHiNOPxXufaGLonor2IIkxjhaa84GXgCRZoafOMWPY64ZixrdxXJbh4Ti0xFs7la7irPAce2pEX5XYVWW7aJP/LU3UEWUYFKzEBgscrWTk+RHNLCU9Esj7EC1y1rmB7zUQiBIFshMiMP51iAZhZvQXvbXt2lPt2m1oY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(4744005)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FTM1bk7GEzKRtgMTnK9Tbt35JTPAsD0XvUPN5SRDiQivQQDQ1EgiDIV37jPMPS4L3A+ZYE3zQ49Btn9x0jaDHRIznOHHZKq87UGsbcZkNS6/yU8Qg1bXRywzQeSI4STkJSNvBlCZ+C6Ggdy9inbYugPiO7jldf2syChg2UGgf/oUh6D9+fRnWptlOjpkiwaTbGbGkfxd6+aL2gOvEWZs4bSVkpbWBOqGAY7Nm+1Tbb1GJWGB/LpIJXu8j6KKy7gIcR1RL8r/oKG50WLBLk3poBFRHJ9SbnbS/uxIQVtQ2U8v4xktcFc4v7717hOO9DTOkoHl9m1V/L5lkqi0R21YMxbWXCJsYTphrNOzfI8ajd3p1uTAriP8wUjWQgVnc5PZios0hZ7xoQhGYebtNygG25vfzctZHrwdustmx+efGE7HP4OWva+W5+rk+Cqb3ylFizQ4YnBw2bL6nlKC6IhttaPzCBxZqISPq0dcgtf15oc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4950d7c-8170-494e-6fa4-08d819444881
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:54.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6xDhEIIuYrOMkKNvAPzadfGG9HIcw62lrb+UNNg6TxfF4u4bZn6wndxTRFFi7C/3TBCQ5Mdae8pK4ZDeYz+xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 014639ea06e34..c4c9d6cda7e62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -220,7 +220,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

