Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2A1BEC38
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgD2Wza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:30 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgD2Wz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXm1DwI7Kje+vKr/YGl7shnDnCSiVqpQ74acCQCgCl3Rf0R/krKiPlIx8XKpzfN7eiPR/57uoBjqtXVjg+nZYWPyB42LFpCZX7xkcLhoXYBjz2R+QuhAF+1lcps9Jg/hTAPMCm5EY1RkMl6dPBa8wTe7gFwG6a0GG0Sb+iOnqMqnfRpeQT0Gnp7em5tJDyvwtHUs/bthIl6pPxX1e8E6utJfWwAPM2KSSOcYa7P9ibHsHJe/W6iTtSgKG/AMrA/xPZhEsQsk7Tx3aYkULHas+00E2EfCUGsKjGKjjESH6LcXCKco3FT+J0d9XxDRKmqzAPAPLIp7g7CEL2Vw/UIAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vq8h8/3OAdogrgGDTEaFalKljXpjv0MY1fxQWeDsi7Q=;
 b=aFMiRxmYFQJnwag9TGLFiogv1Gg/L5q3y6udlnK2nincgk4rXPCjsrlNFxtnFTn7koEtPivwPVoH5SykU6Lka17cdF1/27Se70Y5xOdz7G+CINdMj/xwJH2DO9a1e+w03ZahkOxz7aHqm5iWz2r2ic9Y94dqMWbjN/am70vNOKJZZp3vWefZ9l7A/l+SzyF10kvJAiwSPALxJAOibtOqTW2sRPgSln8AJIFvMyjP32XkElktFJF0w+ax+wKazCwV9prYxUA7nWMssRdK7Jn7jWye89XNirbFyzX6Mkl6J9Rd8+zS8hBp3AQLrBzTLm00OuU9xZ66PqyqMKOAcjIylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vq8h8/3OAdogrgGDTEaFalKljXpjv0MY1fxQWeDsi7Q=;
 b=gq2O/TIfEOVxJC9N3JQwcVrlm1EsYodcMkISd9qC/8pq8+F6rECLIRZGeKQcTTQlxyoY3JmAfP6WDMTrHJVXZLfeKUAgHN1ac5jTUQzby6fQNYvy3nhqficQqi47JLEBwNEgd7eo86w9O4qZ0cbPEQZaaE68Y/CCWo7TN0ENtVo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/8] net/mlx5: DR, On creation set CQ's arm_db member to right value
Date:   Wed, 29 Apr 2020 15:54:45 -0700
Message-Id: <20200429225449.60664-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:17 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7eb2b8e2-0a29-4097-4a82-08d7ec9063ca
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB524740B640D15C55ACA3F403BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /lxaO02q3i1fdyb6W3wHZblpiOAAMFgJMn1xqHIDh/baeJfLm2aGzV1gF62RR9ywX35aDqvzLj2mh4RPDr042heFnRE4AeCZUTDjwUC65huoRVgsw5TLnnuDhQQRQVtsHSaBQI34oS3jBo7rew+kc97zZ/cdHLqqLLQ3VdjGjVYBFyoiQomwJemjfcNJuvpfUgY8iQGwnbNI2BzR68v6SaXi7Odhb4+T+IhajuaWAIBmrLOTaO1OnZJPvz+oKSd1/qJMm5wt4kd77fRMyrVsLdWevfip/++1AGpkg8GDzqneBTDav1Ntbofrvx29u+AmKT8KAyGGfQWWHkuZq2sMk4W7yTSlxPnKH7PpCs5jmkEsH2l+25soTkpnlhwNn3TJCQeTZdCEtTyrDRfPIa/6Oa2CVps0KISQMmDefdYdLdOGqJkIW5iHATmnvp04VwrLrnrEo7tWKE/JlqDX8Zk3K+oOqAcH2Fk6qDvN0SFQXWj4YPMn1r7qSGifMd6ZV2fS
X-MS-Exchange-AntiSpam-MessageData: YGwBWRdovs2azqUR2S4p6H5jqJu75yK7VH1gpqEP/3q6ToLp4SOFWLnqkADPKM7MjznPGmQXAXqRzZPkxeN5MA14YDgKy7GqrIqZ7SNA5TkgppaMHy3hFkygmqVPKf9f3uBQhAtrOGzXK01MZ3PgjLdE6lFhzF2xWzoFE4BXEQ1SnfkxgB4LQu1TaK54cgvD29jXZjaQQhtw0W73rTQ3Nd2DYZwGd7K8hNOmMSFhfQQ6av0xkZwcetDcOorZuRcfb9ZDZ/tkObSeHnxSFHusk2/gyLA234jF4SGoqHWcJdEQa0hm0OPv3+IqxtWZ8jOiuv/gjIHMTLME6qhe2U5ONdzYwut/K5UyMPx2M8pjp3OGtEM/G18lgllDgLP4DLEgNWklYMQslQCxd/4jSkuYWvlCC6oZZZ09VQBXRHgkEFJ83ffAMGoAVyIIEYJ396hBhhpmZpdxvWOG05701T0aojfBHZfmM0MEqdnoCivFNGvNBmQtzSKvYVs4ycA36jBefuI/nX1kb1hGv3EXMW1F+RPYXs2j0Ek3F65/uvk76aqTNeRzUv1ZpAIWQRFGs0p0Ll0gmkVkCaR4OZIhXtQKcuPxnGyZO+8l5bib0J0OiSKM/4W+bKYsEKwsov69i7rGthl17yK7jZXGjimKx6GwWWSPXqd2zDOGmP4cacua9O4DgWVV3eMkOIEsTCwO+LcaK323p86MEobLT96VYwOFonyQ7Xc7tU1BNQ86iLbjov5zxgvGrj3769h3pWUPn1FIM7R0FRjI/prDENrX5W7YAPpY2HET7ShRbo+QPHLk4H4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb2b8e2-0a29-4097-4a82-08d7ec9063ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:19.1860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcO44r2IxTy0383FhKISxZwwOrhACUpmB+8kexXfQl9waidWuz+crucJP61MN2x4CSHWGXyZIfRM/5KZ9NL4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
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

