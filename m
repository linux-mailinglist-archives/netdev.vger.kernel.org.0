Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E167205C37
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgFWTxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:11 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387522AbgFWTxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCDlEIUCOnpYwiUFCClhQAn6dukYMatCi/kwECmiD2QxWrM/h2vE9cWqtNStp5ReP+XT1G0X779C+LI9OX7iJ34cb/rrmzkULYslVdYADBgfiIhgzNKL1kG5yZvYBKwf5JCDQP/trSeDuMh1MmwwPwlx2NCvMl5c77LnhqW80KZbeDqupi62xXjN0AepHfIFH3g//ppJ0UWvR4lZiEdt6Pfo+UlShr9zTQX/WOaR1i9zGMQ7oxQc3+5JQeCUP69YrrTl6Pum7lwqGe2WTJSORnnRnctMxgGjrqriIDBZdWVq1IuUQai8M41VMkeF16+VnVJ99+DrVycE8GsNlBvW6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=JWO6IhLHsIxphEOIUz5xq1BP5uAScIkB5BE+jR/uugihGWuGTguJymD1NRJiNUqPVydzKZ6mw+5lV38i3G7eAOgTKL6AqwJbGP+dIH7ewQwy3l3jgEZ1x9Iiw7ypSvn4flHYODjryfF3waku/+eFasWuRgcuJAvHOLISmoSK1NvcYmKtiTgLzlLU9z5NA3JYIFKy+E6oNOXLnLfP7hn7IayyUs1+rzjHbljrVG7A5BDh+dCS+BE/qrm1KA0t7+6Ea9z0ENAxGjpf6Vm73XR2PsDaZgeQ0BMOhnFBYggoX4X4K651IbFAABrHNAEN0y/XRwtMjQjp45XIFRTg5uECKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=Sz3x5wFinjgCe1PgQFD/7mP7zWcmZlg+Hu5IgmhoJCExUWZvKX9aXD6FK08IdzRm7oNjHEeVBt7LefkrE6qT3jVAAOD/oDcalhRZu8VycsNOzUAApKqlcJHTI+VKYLI7TtJNfWvsrScS4ynGwRNtT8pMGKPPoncAc8zhl4ApR4E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:01 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/10] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date:   Tue, 23 Jun 2020 12:52:23 -0700
Message-Id: <20200623195229.26411-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:52:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 04a4e23c-1162-4260-118e-08d817af0910
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB61018DE483F9A7FE23513488BE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GwUpMk0LgFrXwNlyD6yuiLGlErGVf2s1mhMDhISf+hAPrFDnlNhIdye8/uqkzUfSIZ/92d3VtSWmafP49YL0h3Z9udUXCN+3Z1Zda5Amr7gvLv0XvD+Q3mvwwb5+qG8dBGZtXe369ky3Bc0cmjMh6EyoAD3FkBepXdfbm6sNV5JuwuPL2HnoMTODVb1wymKz22Od8xsbVPc/oARda0REGcNzj4Qjbrh9BAqADduWVdP2A+AWVlA+ltHK0mixBsoWnzDVRKl/9nFaHLjReJCslqsYGOUpMPr9OlWdeGLmDPi/lz8hckoXzyP5MGkTnZC4ofvr9Y5rd/P/6zLgv5kmwv/sj25wKhI3vsL7kFmLOk4sQs/aXewuMsDh5rj6oTJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(4744005)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OE3XGmbRwuboaAK1JX20M4+bHT1fd4yMoX1hFFwAkwOOhM3Q1ErZRaXJMRIfjDxKlXBlwHenz/LNhW1uUehXjDzUXFFJBhllnEZHoVdC/3r4nTaiFrvvPxiiWrk41OLG5V9W3LQBXKX1CEFk5fsliPPCiVLapMIzMR06WhWuSFjGedgEtcx/PnVIgAUBdy3YnUHluHO48lomMFdtyyu8PbLekUvTqCo+t1pDs9hF3wBcRBcp9RRUBUy+a2QGWEZ//QiR98fZK2MCqZG0NUkDIk2zqfrd09PRwr62bv6z1vyixVszVWQh+ytpgbAnsKOMAi6WriI9NhLLFstct+AO6oideBrIwqYkG0JB5NwrcR7+OLuAZJJJ+h3eOWUn3z5X2NvQMwbuGUHaAi2Ufd6666rWFvWawHuaTxhVdJmN+8DIokM7a+J7pog9quYYwNqrSAnpx1xm5g57qbaG3StTm64SntW41u2B/+aGiO46jQo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a4e23c-1162-4260-118e-08d817af0910
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:01.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1j6ceUNFhLDH+An2gQp4+W3h0D6CTKoqvkmQHyF/dH2G4i271ugNCuY2rKPjNeAnduScn0Mqy/gEvTDwgnIefQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
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

