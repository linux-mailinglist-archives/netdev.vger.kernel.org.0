Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7CD1C026E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD3Q0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:31 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726839AbgD3Q0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYNFlUrsbh764rCgeu+by+HWtYONs5l6Q/UBaAlStaDYjLVxVCb3mUKEbrd4NTyGs57a/1NIbjsan1YmbbF9PxPmL+HRFPhVmfQBQFNQMvuqqNGizaTbVs59LwViKvTWwf4Kk/lmderHchJziU0pYMCT6TZHBVc40H8OlDlxk0pI9WdzEU8QHhs+UK3QtjBYpcKL/AIaczdjOSW7maYi0ATQNS5TxcZCBdytPGimCDyw55k96JBQlDMwW2y9nvf8Bxj8sZFEh0CPDpq2jaO44U3RpiotZ/KT0GZYncnRdSPEMiycadAr6KPOZpEzPObk06gmnBnh4yd+LcINQWvhvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vq8h8/3OAdogrgGDTEaFalKljXpjv0MY1fxQWeDsi7Q=;
 b=Dd4r536OzwKN0MG81bYG1Xp9UxzGpcM/FwY6Mo6D8M1vj2wTmYlFsYFMZB4tWYM1n8MERItgxziNmdF6pnSw6cWoI4EkfQFHNFlfO0+UhX9E9C9C97exLfRYICQ3yDmtXdIviYjO09rTM+MkqMcQkRUCYq/gtwPlPybnFiy6W/O8E4P5soPqZJEWS1eOKGQGuGPNDStBuKJ1wjsxAkx1ZDC4wf0S31B/LAxZMNcrjvM6cdocBrwrBmacAFoaWUSjTGMUJLZ/nyotSFga8xXiEAPaVNhUzLHlVkcgE31F7MjiXw88u+47BsgaTuU1S5hjW7WzO0gj1xhJcn4HYiLhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vq8h8/3OAdogrgGDTEaFalKljXpjv0MY1fxQWeDsi7Q=;
 b=Mkz2tbQNjJu7Guo3dVt+Qy+gElAllPr0giNdcBVaooCLScrO1WShoystsji4qOdbW7q9mbCT5YPUzNSUbb6TxKzYuwasojtFTYEjrEi4yiEuMHyClnhIjGwrwTjBGjbkd0dvtqXcv8fFRU0xuQmus/xryEmfhneEBtmGwAuK6zE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 4/7] net/mlx5: DR, On creation set CQ's arm_db member to right value
Date:   Thu, 30 Apr 2020 09:25:48 -0700
Message-Id: <20200430162551.14997-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:22 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 119a9944-eb69-4af6-07b1-08d7ed2339f2
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53769700A7974AF2E5C6D9B8BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaH0b0SsNJBuyyM3HyaHMgtxtcAljiGh4fVZuj/fqx1yXtZuc73JoWV50SwFJLm1lbkj2vNHZjveQtLEz6mJ97Gzg1zxDp1xj2ud/HrUWcihW3smpakQmtk07gx1IDPDNR/CMuaJqHc+o2J316xIsEPjrjMerhz3fByZ7u3EzDE97Bv62eeEw3EC1SVMKgzPJkAYIFxvYsW3KWhN/uRYLD4PbPaVP5D5Frm3wZptdtpOLOMVH6Beln2aRHFAtNIADfv+irGzjBLCnysAhV7M0jkOGfyGAsYVKqE5TwAM7OIKhnxAhJ6suRQCrP8LGLPOx7BQr6zolBbfPDIF5Q+1djsUPykfTCmkS+F6GtfG/pn1HH/iOsRpfEwxPhOvZQLo2aFwXMbjC7iY7KhMzQv2yUIsJZ0u1NvxlZ50HXWratdzPq6JtAXWdvFs1SLylkW1finHaZrhUWhuuYVCc/0o2aSFcInVkUjN5mz+IZ8j+YP+ssr0mLHUgm9GADciVzIX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G1L6dgLMifXrTEk5pNuCmt8O3sxZlFao2KDyy5UE4aZqxH/dvxrazHIIf3Z0Y0pQXVImtiPKnXrAULPy5/j14jaiv+8U58rDVwh21ttTrPQ9EVQ4XMwmEMVwIDpcoy9U2hbbZe1G9e4zvmzIQseDK9srRGn9n6YCy1UD5w7IT9yzAWfvHYXba37Jl4nd5VEsbNfLnaUceMmvYB3i2WdpC7Z7jtOl3N+GTXIvVlENVolWcAkYrwtQcDQoRYYstGAtNIpfFTUvZCpKa3/x4a4422JfYfaEJxXKOPqnRVLrCTPJCRnEMi2LdUMnh9tHtJIOl5s5NuAXXp8pwYgwQ7tsOnUfFOcywGWBt/7DeLQnz/FroPNuGOfIVgca5iX2CPQt0PC4DNgMdBge17zwVCQCQW0JIwQ5clRzZn3L82nj0XIVRyAaDUIPJgckF95Ww1lTXyszTVOxwlcAHIPyUbjVk/dnKcKQkHZGlr3IKE/20R4Lf+mG/epKdElpa+jp8VHR4ZTAeeZSVYinC3dXECxwgqcQGIqHPXE+zBb/1qIh8pEi34JLyhKKh+h+ovX63lmNFQoSD3ec2hxv6T01MbebGCt+GBqU+CvPhfzDTeXRFokYcJQW8LJLnsjozIZsnI0v/XhC/vntJrk7ympxuB3bniHcbr01JxcDBHq1a2spJr+ICjk8HBTjXGJjWuvAQ+JGM7WKm8N3GbIm/Ns+xOTp42eQt/db4Skhqz3PogmDjOEsDLdX3oNx2kF+3gAFNz44BaD8joNunYhoE81gfd/8BvnoLYJ0Ezx6wAlkmMioR9Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 119a9944-eb69-4af6-07b1-08d7ed2339f2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:25.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0gxgnO1PO43Juj186tzeiih0NCt+EDVXVLKz+5l62CxKtmyJDpx46wsQPglpzkPLkqFeSBHU8vGARVCnaOKUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

In polling mode, set arm_db member to a value that will avoid CQ
event recovery by the HW.
Otherwise we might get event without completion function.
In addition,empty completion function to was added to protect from
unexpected events.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index c0ab9cf74929..18719acb7e54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -695,6 +695,12 @@ static void dr_cq_event(struct mlx5_core_cq *mcq,
 	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
 }
 
+static void dr_cq_complete(struct mlx5_core_cq *mcq,
+			   struct mlx5_eqe *eqe)
+{
+	pr_err("CQ completion CQ: #%u\n", mcq->cqn);
+}
+
 static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 				      struct mlx5_uars_page *uar,
 				      size_t ncqe)
@@ -756,6 +762,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 
 	cq->mcq.event = dr_cq_event;
+	cq->mcq.comp  = dr_cq_complete;
 
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	kvfree(in);
@@ -767,7 +774,12 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	cq->mcq.set_ci_db = cq->wq_ctrl.db.db;
 	cq->mcq.arm_db = cq->wq_ctrl.db.db + 1;
 	*cq->mcq.set_ci_db = 0;
-	*cq->mcq.arm_db = 0;
+
+	/* set no-zero value, in order to avoid the HW to run db-recovery on
+	 * CQ that used in polling mode.
+	 */
+	*cq->mcq.arm_db = cpu_to_be32(2 << 28);
+
 	cq->mcq.vector = 0;
 	cq->mcq.irqn = irqn;
 	cq->mcq.uar = uar;
-- 
2.25.4

