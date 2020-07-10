Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7821AD17
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGJCbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:01 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgGJCa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:30:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZMInYMF9jC7yQ8nYUd0ZqyHCCp8RZntXFpXcf3rdGJehRu+KZrMQ8MNIalLLZGLqsdGuHnRIup3RhDDeIn43aJ6tvwSPzN+J3f+uvvggtVaiyHY3F3kGgoLpNWY2N5tJQEe2neYT0wMfTuIGmrNNWJkJh58D/wnSQpgpLotAGjFznadwdQLo4qHPTdj8BrW0/BJYk4Ogg0EXUJpmHQhqLtymr5lWE24WBUm6QvPPkJPUIYhbKxISJs3TQbXs52/XQ1yeCIwGQnN0r5cjxnV5eDsVGqvz6SaUMX5ytLX9B7TevlUV5aTAOy+r659IaWAk6q8mRbRzVQiy6MchC27Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUvt5r8/Ucy+C4McIMX8izt/KJotuT+0YMHgI39ykOU=;
 b=Se4KabpwOdAYHjw4Ij/VCGRihVn1D3fzKaOqZK2RdsFyd6iPb1j81/Q8P8tHV6BJ0SFXieTJ6o/DS8kELUtEeKhpQPnZFxeHc6ItCcgizX2WqglPEn5qFeyg95xvOstpLJyLbZ3wOkGUpZdjhWWfQ6OUm6CsmznflDUIIOskXTys/qdXEIb8O4Ww7J0hl3aHjMexYrf/NgCEfl1RfVLvtXWe/lcXj5Evr3ALStYe4Bv1Mrruhp3Butg6WEAqKLI9/Zvz+Sx+HNYLAS3mkpQNT8/P/YbmFS0dL4l5FQn81+QDx9cIrzEGUPjCkXD/pHHwKvToRbq13rSJ8KfTJmlfLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUvt5r8/Ucy+C4McIMX8izt/KJotuT+0YMHgI39ykOU=;
 b=pvaqakqcivtPgLmd5NkI6oYx70XaAKyTXh+gBt7E3mhHiXELcuV2OvGxJMiuj2PyhCga8ohORHmjvI8lOh/3/nW2+cSTQ0V3sIOzVecIYk2yslPwCddcAQzKdWpOyIfN33zVwnIg5a6c+ncmyrjP8pmhBQFSIU5NFx0eNkvz+SA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 2/9] net/mlx5: E-Switch, Fix vlan or qos setting in legacy mode
Date:   Thu,  9 Jul 2020 19:30:11 -0700
Message-Id: <20200710023018.31905-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:50 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5abe4541-f86e-43d1-12e0-08d8247943e5
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71208B0A67D631C6B3AB96D4BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Y9nLGWvazFvCTy4xbgym05viL8aPkdEArKzdoZ3ujCVfZl/P74Ogs2x9PPpw6g7bpFM95FhdR7UPQ43dUOOLFvvoq9q4hF4SdLPkF4LF2YSlwfdrB3NFhSupHOIxRko7RQwkY1pn8DsfArEszyjwTcqz6wPeAMFHhA7j6nBLybv6RrMWzs+K7qVvLqlskbnBbAixeAr1bpOUNfnRar8TtqEEOitSnKNO+rFgVAx5yixlzMOdqGmcTzXLamhhyMDWMtbq4VZ7Anktn3GEe1J2E/s+I6NPNZ+zoXq+2MLG59uoCTVgX8Tq7ne1ApgaPThfCiAv5YvEP1+P3B6TfgAWnrybUFtIFpadDD5VTCfy5XoC7KSyyol4kaNG0zBTuH2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HElJIsqJonOIneHx4VVTGbweTtqycI/tbpkx4qCkyBpQkf08QK3OPdBaqpMU/tI4KLafavXGBFP4c2Hl59gmylSh2KCgMqY3Qg2/kYaN9ykTbg6CB56+4+rY+CwFzyTCqWjZso+trbhmUFTddePjNEL2sJtYx6Zo/FJuoQU1GY8TmFq7XqpP9v/qrBXvpQU0tQZiKjTxVNlyiUv8K6WmQlSiMGmZjU4Ydex6Yr6xPBWuabtEYKHPxaC7EJhzxLBwX0NNpFcYA5c0IoMCmSjRODvTcH4iIjwCZRVYaJ0qvSp+4Ol1tUSFh9D8HJhWIdegaE9HW/xoxlI/bVVoobrvJtsTKWiuJ3YRZjiDUrwOOTGykLWnImNRVQFd+Pvd0SedxibVMmvP2qxxS06mKD8fQJUpZgzl5L+JzNHPCNwT1PfI+wxWHYnjoookX3vS3yGJLlt51SksAfHZ3w5yc71f2gRfZ4Q4NlKvD5ne7UfZWK0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abe4541-f86e-43d1-12e0-08d8247943e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:52.5521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDtfmeIzjJFGi/neHrD07OUC4SHwBMhINix2V6FyMzMqsxzWG4wzbarsw1d7cSiJRYGp7Lppf+1Wo73PLFRaEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Refactoring eswitch ingress acl codes accidentally inserts extra
memset zero that removes vlan and/or qos setting in legacy mode.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 5dc335e621c5..b68976b378b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -217,7 +217,6 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	}
 
 	/* Create ingress allow rule */
-	memset(spec, 0, sizeof(*spec));
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
-- 
2.26.2

