Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA51938C1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCZGi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:58 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727755AbgCZGi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGmx2F0BAD1oGa77XEDom1BS5fJcG3nG5/hS+n6NuAxHElkKFo0ilP0SZSbj5qiz6U0iI70dTQnhvtrix5NcS3x2Cz0N6apAiPkTbz+siGhLnfbI5LATjuuY7v7ezUkKQqtFqUb6GtPS/WjZTfGCGQbxxAJkqQVXgvd3IFr/xixVRSwG9Jq0zMhOegskd1TiQh+msaUcdEQAOTC4XATRh0PZe7egm0g5dgtCr/RFPTHUlWZjeMDO1q9EZZxuDXFiUd4m14DKrCUQvDwx2ey843QYuCgt+tmuTO6hQIy9qyD5Bqb6SbpZCzDM27oFsI6t1SG6+Hid+vawoy7kGH57Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/t8zyRfn0z4fSZEbU7qenmLQtmvbmwI7HnBA93hVdE=;
 b=kcMAn6tqrQYsna7wcXaTXHewbEMbjaaSKKw120kot3oyD8FFl74CEPGfY7Hjtz8NiIUxoN3sX8B92mnH+ttRtgABmRCmHVzyazLS3DoAwtb6nRqc+BGkD/reV53ujoPqfQXKI7xZowdQKdzBFPZxPeUSjCR2MlY5YB4WVHUGvtZRt572xDSQ8GK+kN76n+nV8FDCk+86DqIGpVUlXlys3Ku4tTWmKeaykP4HmAVuoZVzcKVB0NLWupegSco4bqpT8fX3tVXN0W3mHDk7sf1ZU0kNpraoIYyCXtKNvOoukZDDQ/SWFJuMqErm7ycY96zaHphbRczrjXJ1v1YvU0TzCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/t8zyRfn0z4fSZEbU7qenmLQtmvbmwI7HnBA93hVdE=;
 b=e6IpIS7pM50hTsJK+r80NnSVho8Wc/HzJyT3jvwHVgeTl0v5o+mAzfRVvgD8AICCSSinSNsJDLGJF+T/oLDSayJcpDYNoz5NSFcgac3TSrFxQbddPBRtDpLIE+YCk4XeP0W4qRls16n2FwkDWcviC+HrIRdnApsgsdKYeduMRlM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/16] net/mlx5: Avoid incrementing FTE version
Date:   Wed, 25 Mar 2020 23:38:02 -0700
Message-Id: <20200326063809.139919-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4faf7ac8-c7f6-4090-2b09-08d7d150590e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479CAAEC2DA3D04210438D5BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(4744005)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lf36EPQv6E5BS/2GcNZpXvpiyp8HzCIEKEk58EFfDJu/u12qBb10visjSxxiLU/gS8uya5bPIfq3sZebObU3BgWt0L71wyumKjTT2UKtnve3myMKUhPX4BhbgV26xFS/ozVMKFhNqFi6gkQCEBYHE16o5tLz6uCoBtQRt3pkrollP7efZA6in3ng2jTZpJuHxRY1LAXHCeSJh7il2TOzzz6QcIk7Mdmu3ewhnZxDTOK4UW/lKinXk87/ILvru9r06BK0AVs5BSbOBEdj3EEudn5pBz+YAlANNTCa21EF+VDOI8NVlcwRoRkLinnNdHFIq8rj2farliwZAwMjz1L2I5MVX04+wwH5cH/zmZbNozVT3fFCuqoGgbzIyLV2l18Q3a9j7SCw0ZeAXskCObCLSUcjFYqEyITuufgTTzpFUtHUHUvLI7cLz6yr+1a7dTjLixofGZkZ781NRqrw0etsGl3XcWTWZ/wsTbqXWbfbRALLhnLACvos5DI+ewNbRHpk
X-MS-Exchange-AntiSpam-MessageData: OfXmm39lCurGNlGDNZCdmin/QhE/f9NoKXnhtvdTeg+7zgbAGJTIyQ16huKWVvxvnOfXBscKKgtkqYXYD0Ny3EslQ7/1k5gcPBU65tY1J4GKFFSc2dA6Tq1Xf+DQDBd2OQOsdzSwf79HdvRHoAl15w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4faf7ac8-c7f6-4090-2b09-08d7d150590e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:52.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+wuA2CubxdNgZexqInTG7H67fqC82TEeyBfWN02F9e94CZ9oPFd1KCS4QJc9NnO7pbVX1IAWVP9IMsd+7LWxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

FTE version is not used anywhere in the code so avoid incrementing it.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 751dd5869485..44ed42e0e1c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1322,7 +1322,6 @@ add_rule_fte(struct fs_fte *fte,
 
 	fte->node.active = true;
 	fte->status |= FS_FTE_STATUS_EXISTING;
-	atomic_inc(&fte->node.version);
 	atomic_inc(&fg->node.version);
 
 out:
-- 
2.25.1

