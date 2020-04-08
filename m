Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6A1A2C05
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDHWv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:51:56 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbgDHWvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:51:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX/90JvWEkeYpwbKT8QouF6UzLBYm1vuotj2BDA7O4I0BX3D9npzaRqUe1bgPSMwZZ/GXrfuTvrKh/6q6/ubV8eZgRvjX+aIyWaGNtlHb/ZWgjoof0LLe+I1ma0meCEh9HbSmIvfUe1k3/lzykBHUTHCpPvVXPlcRUUXgJvwbmH3UUL7QwtxZZJkeFhMtTddbqndYox9NKeQZPpp2Nq0HHmK1SuJ5q2j81tsZ6f+4LwbjkHYIcp8rj4QLLwAeTFRB0ycA8lPc1omG2ahoCgU7xrSviEz1vn4hIuKzNTXu0ld+EJtCLMA0PQ7KAZ1o22c0BMunDBdBtoXW3ElVOnhWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3PVvsfm9F5BJCdlXoIrPNeFR3y8s+exThwWwY4kc3U=;
 b=kCedcMITaUUKoo/BwcqhnRkT9qoWgl135ajqvY/qSpbHzqUfA0+SXTVvEaufncp19fPARfA1OQPT7EEdBXpV1vzCv9FnMx+Iy2hVE6c2BHFV/ip+w8ScRskBOut5vE0ejKfTmyv7tZ083bzaAK8Gf5vw306e0K0nXzJ2Wew00S2JQ3xBC5xuiMmWhQ9aTOGqvu3gt/3KhWcweebZsTrC0ELeOw9BA0kjbfl+FjYoj/IXsqBppvssqlVxrV72UnI+UMB+XLHSdzu+X82OeTv5cus6V60KBpdnA2Ldxh1DS39xPpy4p/ZgNpcWvCCvPgMEJuEUa3VYC93QcssKJxQTlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3PVvsfm9F5BJCdlXoIrPNeFR3y8s+exThwWwY4kc3U=;
 b=NMHrRMPKNzgDwv3gK3ikpA41s2acKV+Z48ox7KcYDiknmI5YuHvYdAlsByLH/kr7QC81VqgWL/vsu4tqYtKcZtG+UVFGrUfvsMqHY35KAqvVYXkAz3a79tyzuI5b9eVuonG+2nH/jbtXXVY5P3XRrP0pvc/zJs0A+7EWyPMSmKE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/8] net/mlx5: Fix frequent ioread PCI access during recovery
Date:   Wed,  8 Apr 2020 15:51:17 -0700
Message-Id: <20200408225124.883292-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:42 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17f37222-f2da-4cad-f5e6-08d7dc0f68ae
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6365521955AE087A9EA11134BEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNB+QsinHrcikeoKZrcm3ksL/5h1DVCaJh9bRP4/GPn1w8mGJDCNQM/q3yg9hL93H3ewfU5NF7LweGVbRrzRRUnJghTtPvWsNBPGnb73eJwZzCJxw1ZqSlqv5mDAd4CrYuq+xqSsHcMToVjz2JferrA2/l+byQAPzxy0qiS2ZgO9nUdThKfscXjdVUlbm3PghMOMGIFuA50tANjHZYEspM2yJmtfu5YkB12btX2J6lTq2FfJPMvH3555uI69HbWusbqRjk42G1YWkJnj2ptb+iSPyW2RGn8oWXC4DNuelp0X9kohCMtyrQ0wJhB/UwktI1jgNYGKTh60cXK0bfFpY8f3JtW0quuRNWv5R0ipoWqSv485DjKDFM0fKZm6IXQ9UbLoAJtkZrY618DB3op6JRkIIEgccyDDSbQFxJByUiJd491KZieQ4/+zj1uXpEfjMWLnbpzjDcaWf2v7vkmRyf0+7ytXUwWI8VVcTv32D99Q2xvtGR3DE+SuuMcXyHsv
X-MS-Exchange-AntiSpam-MessageData: TjQJAujv6ZXrBAHrDOz0HA8kHRk73OB/u+XI0IEUD+Q3+V4t3XYE/Gg61TP2NzXRwoO+1HPjioJTtckJk4G5SVnK2ecFoTpWohVL72As3jm/dY/rnQxPKOwAezycKmEjp089ouhj2UlCDVNf++ZJIw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f37222-f2da-4cad-f5e6-08d7dc0f68ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:43.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C390j8GEbrGO0uNnFKRwMKA3jaZNHPTmf8ZfE9Y9igtF29cw6NSBJtPIsoYyM66yW/p5ZaM80l3/MHfw8a3cXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

High frequency of PCI ioread calls during recovery flow may cause the
following trace on powerpc:

[ 248.670288] EEH: 2100000 reads ignored for recovering device at
location=Slot1 driver=mlx5_core pci addr=0000:01:00.1
[ 248.670331] EEH: Might be infinite loop in mlx5_core driver
[ 248.670361] CPU: 2 PID: 35247 Comm: kworker/u192:11 Kdump: loaded
Tainted: G OE ------------ 4.14.0-115.14.1.el7a.ppc64le #1
[ 248.670425] Workqueue: mlx5_health0000:01:00.1 health_recover_work
[mlx5_core]
[ 248.670471] Call Trace:
[ 248.670492] [c00020391c11b960] [c000000000c217ac] dump_stack+0xb0/0xf4
(unreliable)
[ 248.670548] [c00020391c11b9a0] [c000000000045818]
eeh_check_failure+0x5c8/0x630
[ 248.670631] [c00020391c11ba50] [c00000000068fce4]
ioread32be+0x114/0x1c0
[ 248.670692] [c00020391c11bac0] [c00800000dd8b400]
mlx5_error_sw_reset+0x160/0x510 [mlx5_core]
[ 248.670752] [c00020391c11bb60] [c00800000dd75824]
mlx5_disable_device+0x34/0x1d0 [mlx5_core]
[ 248.670822] [c00020391c11bbe0] [c00800000dd8affc]
health_recover_work+0x11c/0x3c0 [mlx5_core]
[ 248.670891] [c00020391c11bc80] [c000000000164fcc]
process_one_work+0x1bc/0x5f0
[ 248.670955] [c00020391c11bd20] [c000000000167f8c]
worker_thread+0xac/0x6b0
[ 248.671015] [c00020391c11bdc0] [c000000000171618] kthread+0x168/0x1b0
[ 248.671067] [c00020391c11be30] [c00000000000b65c]
ret_from_kernel_thread+0x5c/0x80

Reduce the PCI ioread frequency during recovery by using msleep()
instead of cond_resched()

Fixes: 3e5b72ac2f29 ("net/mlx5: Issue SW reset on FW assert")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index fa1665caac46..f99e1752d4e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -243,7 +243,7 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 		if (mlx5_get_nic_state(dev) == MLX5_NIC_IFC_DISABLED)
 			break;
 
-		cond_resched();
+		msleep(20);
 	} while (!time_after(jiffies, end));
 
 	if (mlx5_get_nic_state(dev) != MLX5_NIC_IFC_DISABLED) {
-- 
2.25.1

