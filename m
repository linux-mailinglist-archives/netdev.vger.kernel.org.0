Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2909A1D5C86
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEOWtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:35 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRis67d8eRBjNJwR75fOabO2gohy5FNXmdEmNjXnvmw8TMQQccAgj571XyDGWYrylkBYHrE3b8JJoxeg6h04UZF29VeO9uAITY3YxDfXSgoLOVF3V5CHopuXWgjrZUVNOrEThftQLO+djkP1/ZllkBwFx9gADOL77qEjF0PhYWSE836vXyGLMq4izyxLcO41OVylw/bo+LJ90HrN2cDqMQ65+vPmyTEzJkUjDfsrGRrX+KZJrq7dtvrhsdH023pUwKgZWFrjmBuH1KDYO86KGkWHPITzgIze/dM8bD9bvPx4QduntGhi5IHBmCgIpFWQR8KbP/nyhHwnVp959kTNCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNIKfR1WRsOIuufoOQZG/7Ccjz8qooy0/uMja9iefvk=;
 b=kkgBSw/qo1m6+EJDkwNRgYK+dMprdRWdAntNvw1CroASwxtSs1ov8O3LGtopaEGU9nKSHkyOKUdlZXfyhlsR2RL9KMrHEnDGdPsGi4tyERi/c7BItGG/euhyRl0w3+I+xlvedEXks2CtfzQaKbHbr4iZuvIzAFg2GqYc6hLmAU4s2MyTRlCzAu8lrLTpkhMjkG4ozRgKLVmL5OgCTYxPzpWIpAtMQx6zLXld0fS3NoJ2QZLBdmwcwV6mVQ2HttfZ5XNFZKBuVazOzRBizznpMbPD7+bGbJ3FNpTet2QOtXIjIe9VGOIxCLUzYeIO90llPVbNeSMxsn+oRhiWyKoHZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNIKfR1WRsOIuufoOQZG/7Ccjz8qooy0/uMja9iefvk=;
 b=QCuWhDDe1cDNMB1F11kxT5XFPiNjmw3teUd9VVN8/kuQtGpUaDPsKEMI9rHo4MQkeIM7IIo6pWuZyFMnnnErW8WTNDtCGdtxwjwjBuwJRm0gXM7ZTuKqK1tBQmgoLipomPQufvoJn97k6tgdbk68Ozb2CaR6oRX+Ec8ctrzHhg0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/11] net/mlx5: Wait for inactive autogroups
Date:   Fri, 15 May 2020 15:48:48 -0700
Message-Id: <20200515224854.20390-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cb30718-5304-4fa5-b99c-08d7f9223929
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200B459DF86BBAC1BFD46F1BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bP5ynwAWHx0S4RG2PYI6NpeEPirQDkPmVmVqfbjogqEa45IVsVIew3mR6oNOaSyXoMSVyHQHGLLhIDQRWCyKFq56ALrlLnHZ9pkdeAbGi3snY7Yj8sNT4BdRZsZsrjNdXCh/a+QFARsubRS5ECeu2Ak38OrA80Vnx25lBtwbOTZFfagH7rIIz0hHqqcWTf6QDHJf2pLtREpsuWLFaCbS0Hs6/7S6kTxOCvB3aXzKCsYxCziMNlECn/ybUEyiWSapcpSAByq6PoiTL5aS4il0ZouTY/Jj/bdYI9sMwWJSNgd+y9kJ430kP+wp0/liAnmzJmoF2IHgH8a1KfLkA6dWp9PI6YR/1L4ZZ2nvMr/dh24dwFE4M5kMvM0UXjQESQOF0KepqQ2HMbci0yn9mfeLe8G/vdn1MBJwTIVgPyr9fYQRuYDMvfDXDtztnXumVtptUKGe6xdavtZiyE/XiDBy2HhGaquN0uxmXNL24xSIni9RM9UVR6nqNLbHwDWeRkJf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6BO2E4P5AdwAoh4sQH7wLNPogC5r5+9cJm27lmkjmxZhKtWwqOq/OxjjQfNidkC5c/LTMys7dHe2scp+bWXmQcJ5F0HM2PUDnlQ//iVzen+g9JjPDNSTLW/9y1cVJNJOLk03NxSXh/nysM2maWC9MlIn7ojsXxqyHb/oMdg12EZBLb3//uTcDvkthmQUEEzG0zyo1mK+ZiykobBuANi+tIVEDCFC2LoULU9aLdKDiqwLvo6eed3Z5/krxauTjcuC60EMo6y4JyHBLLahvjMD+DUF+cYYZXlQcWEkUyf9BgJE4rjyIMcOnRx9FcrudWU/rLBZ4xJngLoTwJ1JKHDZsITz1HesdDEsZldL+lsjgPcPtXrRJtQFiKdfWNz+CdBvP4Sl1gma5pZzWgSr1FC6JSwM+n8ROUu8z9IQwNka84hRbQdxE+0RnU9NDOQ1RbAeTYiUWJk3Gp+/EipkN+dVqZo1l8w4T0cyfHivR1dJNDE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb30718-5304-4fa5-b99c-08d7f9223929
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:28.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/+9EoXwKz5ZRhA1r2cV5C9OxOwooDYn3e3HEqbwRQZGWhrUbQq94x2z8xWNRIwhrqpl73q3+DuLDZgAgab39w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Currently, if one thread tries to add an entry to an autogrouped table
with no free matching group, while another thread is in the process of
creating a new matching autogroup, it doesn't wait for the new group
creation, and creates an unnecessary new autogroup.

Instead of skipping inactive, wait on the write lock of those groups.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2da45e9b9b6d..52af6023a4b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1755,11 +1755,13 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 	list_for_each_entry(iter, match_head, list) {
 		g = iter->g;
 
-		if (!g->node.active)
-			continue;
-
 		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 
+		if (!g->node.active) {
+			up_write_ref_node(&g->node, false);
+			continue;
+		}
+
 		err = insert_fte(g, fte);
 		if (err) {
 			up_write_ref_node(&g->node, false);
-- 
2.25.4

