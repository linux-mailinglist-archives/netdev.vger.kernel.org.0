Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAC1E3507
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgE0Bun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:43 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:61537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727041AbgE0Bui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FseC8mcwR/lErhVj+eXtxnnxhusb53Kj0XCNnEKGR2NQhpNZh3hQmqdR/ag+jLWarxPTu9tnMmDhTkHJnjJatO7rDSOvrUHLHJdqNpslSn00Tckye42mNrCZy0dw7bWpS0kd8qE6T/DlshdhTowZ94PuEGORPolwoVyrOlKAHO7md8U5llw46Y5fT5DqFjlB0GSVFhIfXT6miRtTXvdGhF1tVMF1zB+kAjZe6DQGzH57JvREQ4538kgnaB9RmjJZPh2qWhQoV0NHweE8+5A4X/4ZmInL6CH8MeRqm55/qS9JrQV1heHSQNTGmhI14wKk2WTXR51CM95cZwxRvJzPOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=nVHhc+0CfAvouPUWySCvTDfqBbhQNmE4gQnpsY7XK63Y/zs2ES779+0GQVsXJLSraezHJ3bHgHGQomKhNlQukGlL0BvwZKGL/YfYeXXwDfrZ1diO721u3V94orEcO8Sd3bNvwdkKJX6nC6vkviuoaK2NKkzSFyNpmKfCxZiWszoDsf/HWcUrbbSCCco3Y22tAroAjFZc5i20WNTzyp4hgGnqPH8YaWsn/tOWAeXzxYB+Zh5BQaA4lkKGP/nbxs/hpX+fRGjdc20/cD3rs3kvk72N06rA3GR783GmLGDMNCZQE3BEharZZDPw9SVvp13spf7YHEGxxB+UW4ZAddPLlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=E7QnsBTatNqFCed3FeG6ud6a6Su+mE4Pp+8Lx/ETP9Eu3XpIzbT9aYFT+b4E33oK5TSy0Af+MxkwuFJt3vjgBbH2G8jYthjxVuffL/dToHOO2WC2n1sJfAy7qv2Ay9iqrFZdam4JD+1YAG//aQkQUqchWZ2l2wOtFdDFaAIQBRg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5e: Use change upper event to setup representors' bond_metadata
Date:   Tue, 26 May 2020 18:49:18 -0700
Message-Id: <20200527014924.278327-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:15 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7fef7b79-d845-4422-977f-08d801e04e1e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB663726A3F0BBD1DBD0B87143BEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFrwyOkBRfGvrJT1J9SEhFVFN2+uonhadWtRtrnNdp7lyRiy5DwGe1eYU/rADat3YjvIP759iIy+bdCQFwXuwm4KsAx+abofpQl6VgNLXhpoDsAMnmlztrmVe4NzUR9ggqcfo06BseOH5yqkS3bzCXDpj/Mbmy6VcoHgdYgfvlnI68HNSZh0G8gKIuOz37IXiJnZhJ6ZYGrJlZfArSDAanU11j67nTmBySlj5tGfz1h3nqKBsTyLfBv9qxmsYeptlY9eKUlLU0At+FdEjpuqNE9SDlVMNXYzw+dAERFP3Uz8PklYKUGdSLaPkNbVeVpcxVCPIbRvt7/tip95aSkyTmeCW/o7XeSOneWCjhkPEVnM+kTHdCqL8aCUoifntO4t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k/5hPTVYjffYvRLWQGlCkZZYDuUBlOz8Ol7vpfOrwbP0xNHRr+Qrje1T8v7wQnz2rKajtKVyTT297Ry0XQZS+dMOsL//KfauiJhwbOT/MBG9uX/xqaLMVhXBf+2LwtllFuwRoCwn7/GmRJZD4oi7kCYtdk5f3YyBzk+xHKdZ4Uoa6We7fL0DtasdYH4/vz349XWgNAgVWq50k1S32qIvpJAj+uTWpE192ohdNRlae4B3/B3mZRSJbsWRK1FeICQW8Sc8Ste0oYC1IYhz+Ync+p4GIyVjaWo6fRylu77yOA71FkOH/+0hIRqNgamfG+HUP8OI8TzbyV+vFdgzttvPttzcBfQ1V+Pj4E7HfXy0D3QpFQjfFgEOWgH/r6Ll1QJ7u9GRhK8XumR3DRIRy8wZLvq2zVVFG8Q2TO86DugKMgMBcLT5/4KROYqsDCZ1gws9yX/NmcSBegLYDjUQ45Ud0fEQBXjRoTmi0f1JiFywVMc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fef7b79-d845-4422-977f-08d801e04e1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:17.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OP0Ws+Sbag7CaLQ5ihRKhiT/kSPkR/6abxuupyBvU34WIayyYue2cVh8pJcWrwJx18bMMDDXYi42FcqAtdlAig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Use change upper event to detect slave representor from
enslaving/unslaving to/from lag device.

On enslaving event, call mlx5_enslave_rep() API to create, add
this slave representor shadow entry to the slaves list of
bond_metadata structure representing master lag device and use
its metadata to setup ingress acl metadata header.

On unslaving event, resetting the vport of unslaved representor
to use its default ingress/egress acls and rx rules with its
default_metadata.

The last slave will free the shared bond_metadata and its
unique metadata.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 13500f60bef6..bdb71332cbf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -164,8 +164,13 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 
+	/* Reset bond_metadata to zero first then reset all ingress/egress
+	 * acls and rx rules of unslave representor's vport
+	 */
 	mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport, 0);
+	mlx5_esw_acl_egress_vport_unbond(esw, rpriv->rep->vport);
 	mlx5e_rep_bond_update(priv, false);
+
 	list_del(&s_entry->list);
 
 	netdev_dbg(netdev, "unslave rep vport(%d) lag_dev(%s) metadata(0x%x)\n",
@@ -253,22 +258,23 @@ static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
 	struct mlx5e_rep_priv *rpriv;
+	struct net_device *lag_dev;
 	struct mlx5e_priv *priv;
 
 	if (!mlx5e_rep_is_lag_netdev(netdev))
 		return;
 
-	/* Nothing to setup for new enslaved representor */
-	if (info->linking)
-		return;
-
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
-	netdev_dbg(netdev, "Unslave, reset vport(%d) egress acl\n", rpriv->rep->vport);
+	lag_dev = info->upper_dev;
 
-	/* Reset all egress acl rules of unslave representor's vport */
-	mlx5_esw_acl_egress_vport_unbond(priv->mdev->priv.eswitch,
-					 rpriv->rep->vport);
+	netdev_dbg(netdev, "%sslave vport(%d) lag(%s)\n",
+		   info->linking ? "en" : "un", rpriv->rep->vport, lag_dev->name);
+
+	if (info->linking)
+		mlx5e_rep_bond_enslave(priv->mdev->priv.eswitch, netdev, lag_dev);
+	else
+		mlx5e_rep_bond_unslave(priv->mdev->priv.eswitch, netdev, lag_dev);
 }
 
 /* Bond device of representors and netdev events are used here in specific way
-- 
2.26.2

