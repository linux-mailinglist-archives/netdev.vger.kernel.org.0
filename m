Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA31938C2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgCZGjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:01 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbgCZGjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0i/BZnwl6mDkmD9l2eeWOtloLfWDhcT63I36IGRt13Gi+ww8TPgClq/8zsEY/sMcDSQLhw3fXgYdNQSilVAPXA6MIYfrUme/wFiWlTHywpgLMb+q9RFeZu3I5q4WdOUlGJve1ZB/XHOH+B2LH0WhEUEAmQPZgMgD2/xmRf5WP2mqC9qxSTduBzy0s3v2p6n/UaH6/TzaPdDUIYdJ99B2fX563/2TxK35YlbNdmF61LYVfUHBMb6PKmpNV9EHPZLT5vtJ1gszOWUnE4LQaGvUg9X9wi1uBVZmblNg8eXUdF+w9Meo+Vf2QrFsWRpdGxMPabe1/12ies5Jko1d5UuBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoT2+Eep8s7QsLv5tAPd0cuIlkzh6BmVOggcAhyZj6Q=;
 b=BGWWm375Vx7QwAN96enYENi0ExEdeiy9sZcBGOl54JKEvkF7vK8s85WQcoZTGvdObrny/NGxd+phiDiQpziSxuG6lJhJTpKUe+HJF4WC1yhExZj14gnqMH8ythXgWD4RCZYngoQWhtqjH4y3LbQB+NQQMU0gGfYjfHH4MSh0PdU9NXGLweYprUDaPdyzR5AXz4iMvoMWMe9IPXcV4Q0fx7ofEdcu4/laeQ4oEbI0OkWkWrYRuqlP1dZANDeUyYJHPMSh5AHXZbbspBLHZaxH6D8vePHYbQlI8qUwHKiwil5P0Phwd+/8N5t8/6IUH9bWwcLixt3DBx1VOV32HCb9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoT2+Eep8s7QsLv5tAPd0cuIlkzh6BmVOggcAhyZj6Q=;
 b=lOCQrji34ErkgVviGK6d9h8O6X8ok/4d5H5crd9Cn3Dj7RYthX30W7mmc/VbmefzkgJa3jMDlVVxNZNOoVBKqaByQ0Gg3UR3OC01NjjtjKPMsF9fG8D4+nVUDgZAn0X8sgokD/GjLkI82kvGczE9+r3/nBQKo/RS0i366rKMqII=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5: Avoid group version scan when not necessary
Date:   Wed, 25 Mar 2020 23:38:03 -0700
Message-Id: <20200326063809.139919-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:52 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff53bcbc-51ae-4019-ff59-08d7d1505a8f
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB647934206929D5377BF9A77CBECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXstA+2lA0jAPblWP1I7OGHrLhdTUz8VVbIBc79Ny3rfAHd6QUEGER9C/a3BHpo/BtRyWHe91AMI+RYNL8+Q9uqmAoazKrtM/71fTsFnwJEJLM/F/2NhOsQRULsZfnfNb7OnUV6mFT7HeXRTv4exXc1Vgnb41hQnP8DIZjJ36qWpzRyXuPQxTIT2jVW2sPx1RSV+5Tm/SFlBqI6Dl1po75A504yKMaS0IUwtxdQDiFFpSg/XQlSVAeqqUdo98bDR0jU8vYFwXYvTPklWhxj/J2VZUim4KaLpjM2kb7JsH1Xv9+QW4AaNgzT5hvOCvVhf0jWvO4mlqgjRJorrJ5dqWtOwQj0ZhGSPDiLIPvr2XM3Zm1l2Ig7lUosZ18tASRjtj2VqgT2aEtd6OWF0jigh0xqjHeKpnQYvdCFpbKb/AijOL6YsO4I7cX1HztjQnq2gL/vb6oFD0gusTQJeWQK/JotvioQpERyPHN4XPtRvQpHtVjZKkfedagl8aW8IdVGr
X-MS-Exchange-AntiSpam-MessageData: gHGi2UybrIHve4Q2CJ/9XbSvbY6ntDtArUoaKjr5W4HsWnCPQYyGzo/29c96cPRr6yPMEz7fp8H7tT/OWbL8rZ7eH/oUBBJ1BGASeBXwAgKnOgm1DWfVwx5wDFwM7GXbXBLAXXtYThHX4eKEWkUlFA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff53bcbc-51ae-4019-ff59-08d7d1505a8f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:54.5208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8X9UbEATIXsyeRA/dYLhdGcJ/yLUErrakBdpgsAveaol5kDuQP0P+0b4x41XSjQ6+ne//c30aD6nS5BM1TyVUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Group version is used when modifying a rule is allowed
(FLOW_ACT_NO_APPEND is clear) to detect a case where the rule was found
but while the groups where unlocked a new FTE was added. In this case,
the added FTE could be one with identical match value so we need to
attempt again with group lock held.

Change the code so version is retrieved only when FLOW_ACT_NO_APPEND is
cleared. As result, later compare can also be avoided if FLOW_ACT_NO_APPEND
is cleared.

Also improve comments text.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c    | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 44ed42e0e1c7..62ce2b9417ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1680,7 +1680,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	struct match_list *iter;
 	bool take_write = false;
 	struct fs_fte *fte;
-	u64  version;
+	u64  version = 0;
 	int err;
 
 	fte = alloc_fte(ft, spec, flow_act);
@@ -1688,10 +1688,12 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		return  ERR_PTR(-ENOMEM);
 
 search_again_locked:
-	version = matched_fgs_get_version(match_head);
 	if (flow_act->flags & FLOW_ACT_NO_APPEND)
 		goto skip_search;
-	/* Try to find a fg that already contains a matching fte */
+	version = matched_fgs_get_version(match_head);
+	/* Try to find an fte with identical match value and attempt update its
+	 * action.
+	 */
 	list_for_each_entry(iter, match_head, list) {
 		struct fs_fte *fte_tmp;
 
@@ -1719,10 +1721,12 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		goto out;
 	}
 
-	/* Check the fgs version, for case the new FTE with the
-	 * same values was added while the fgs weren't locked
+	/* Check the fgs version. If version have changed it could be that an
+	 * FTE with the same match value was added while the fgs weren't
+	 * locked.
 	 */
-	if (version != matched_fgs_get_version(match_head)) {
+	if (!(flow_act->flags & FLOW_ACT_NO_APPEND) &&
+	    version != matched_fgs_get_version(match_head)) {
 		take_write = true;
 		goto search_again_locked;
 	}
-- 
2.25.1

