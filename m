Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F56230635
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgG1JLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:22 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728451AbgG1JLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnTvAWYdlONkWO714hjhxH+DljlxsIXL/A1lMw6JRsrswIkkrJyYs1LFxCDSwGSA9BN0q7AZ+En0zfqKMhyB/Yq+q0zZGma1NQs/OJ6kl5BpEjJA5wYScR3ikpW2iJX2uJ5khSo0P9mmlYVEdXiggq1LKYW+Vt293q9s1+Xk8opd1KFcaCGGsTgIkwK3epDWVKMimp8L6qIlyWw4nt6UriY0V87/qnEBC144viCRUGi0lueIHKCqC2PIx1XdLd1iElbZ9jX74a++O54jF6L0LMAfLHIYJGbqYVJiniMb0sDsKnFJc2YgSnQGAkvnyMOzjuNmIVoJRcO4NkpzeEV1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACZeNjH8ov6MHwGPLpRS4RHYgUTvmLXBdaweiNEDfX4=;
 b=IeYuNKwwCyfwyzNqAMVtDSegDGoF9T0TKDZpNCGHn/jNgaE0relXoieknW4YPitVHXqmsmEUAYB2PyZq3SuLxdGwCChAd7wxyYSXQgR1giyE+9tIkIlQCnErXMni8vTtahb5zyBesSk8QmWN6WR89UCd4TaBHG3tu30kYMP7yBkyJEEZnvO8MSIdzfe5tmbBmOnQLrS/j5ArSFy7+uuZNvoO/Nde0sXUi3Ly6t+y7a4TmA3QsLFyRcBByto+D4yos0nTwtFtMlpwrN9MjQ7KYGvHx4ToRHXsuVdkQ5vWp/LlQrgM0foJrvp5w/opBGTHTHMODxeu//FARZwr5eK+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACZeNjH8ov6MHwGPLpRS4RHYgUTvmLXBdaweiNEDfX4=;
 b=Vb6iBFC8lu9KFDtJWfXOXIoqy9hMPLjcFmybD6h8HeZR62sISULa8nlu4R23Ez3oAQnW4mTO4h4cGFO7umb/Y6A7L/Je8KBgLwhvYlMy8kpnAIpMXLvsT+WKU4cbY3nBQewvFvQsnLihYfrrNAfZfRBiRoFAcWx4xidI2tl0Uso=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/12] net/mlx5e: Fix missing cleanup of ethtool steering during rep rx cleanup
Date:   Tue, 28 Jul 2020 02:10:29 -0700
Message-Id: <20200728091035.112067-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1708ec0-9131-42d1-d609-08d832d62dbb
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46389EFB70204D1FB914F4F5BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCO0S8fmlTbJ5RPFkl3a0vKUK7PBBtZab1PSL1Sg8oXWybhF/UcvA8YQixAeDxu/22ByoiT387e5/7zjjZCj2Io4kA1T9nT+7ySgFCbWg+rjFEKoX1VDnOdj/gF2inTpnBjmNoaOjJcL6rwQpLWjqDZgTLcgqct8U+M6L+hYxwb7n/0wlZTyRu5B78TFgcKfZQtlq3pI+Az8ekLMWJVAroEr4dxVInIoWHrqa8foSutybco9CP6Ua70Vrx2MTN6wijdlKd901b6XT7tKFqn/HbGtszpfVsdzZjEHN951A+mGdvVU/VWoshNbgFsdFcfqkR7KUcqEHF9SM/caqdR2/7AaYky/sgz4UaDBBMXq9CV4EoYEePfbApgZzcpOrsQB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iGSU7uCxyV7fs9bq9eIh5UjLrx80wtNYoDtULkCZ71iTkLkEDSXNcEYrtbx5M5YSm99GEFpo2jXuksOS5slvXeSVO4VnkMKu8rX7eGqKwWCKhRotiw6eQ9sqeIl1L12BF2sC+sYISPHrjGYLsQNwMgQTn4V8uLnwgkv+9qoIqtq+uzenA5AmqW0p3fhJU+WaJC/NqGnKrVvEk8InQZ9kxHo7w7/0Whm+/t+gPdpBUhN5FTdu7E037KsRQ0/UjrXIRtxmcUaKwDxo3bt9Ug+/wJA/NM6kC8Ey5Gz1KdV9NKFhvMN/QkkssdXq4SJWUgVYPHGsbP50f2WUghfhy9qf7LUtEAYn1ss3iSE6eOQS8xYAOnNa8umYt2Kzg9SUwKbRwQ0061CDLaiuTdqVaCft8CM8TaCSjbXm9mh1BVGVC1MgZ8T3NDQu4dpBtXNQHDq9jA3gzRL4K1baEApDzyuq2onsHxDU7JOgTZZIeTHDgHQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1708ec0-9131-42d1-d609-08d832d62dbb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:14.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /F9rhVHBeewYaKzSXpPv6yxo6gYDoeO9Ebt7HVnlOcbuJKAl4xJtaen517YFUvaZe1+0sknrAHGBDb0wN+KUuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

The cited commit add initialization of ethtool steering during
representor rx initializations without cleaning it up in representor
rx cleanup, this may cause for stale ethtool flows to remain after
moving back from switchdev mode to legacy mode.

Fixed by calling ethtool steering cleanup during rep rx cleanup.

Fixes: 6783e8b29f63 ("net/mlx5e: Init ethtool steering for representors")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 006807e04eda3..8c294ab43f908 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -936,6 +936,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-- 
2.26.2

