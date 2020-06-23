Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABA7205C3B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387585AbgFWTxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:23 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387522AbgFWTxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHBV+WmgM1TJb7m0179DMJdOafgep3sjWG6aT+rhK+palXF5oe8Jhcu2n1SWwBsQ+ic+qpQAM8bOZ6X6I5aKC6zXZYvwwsQksMJ68up7cKz7/ErClTn/LbBSPvdNPW6PU1iXmjkKeCRWCZdRnqs4GQy4Zk7YxwFKHad4jdm450NyX3J0c/7igDJQcgZJW+Tk3500gE/x8zTFSuM1s7XWdT8agdVY615HXDQ18zDeBLCT/pFIrTGdDAJeq616xl7QmpByhuAwMkfVyar7I+ypdxS/QKgsbLN3Lp1YkNj6GruhtQB6IYUOuTpCFWQ5H3SY4bfmKEglcwFOt/d9IPUdyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=O+qqSV+MaUcDR50vIZjOkmTadpfe1ehg2Xwd/M+NhmMqkvoOCKA8lBYIVnBg3K4og0Ow7h5Pi0596NBFaGpT66c2qvk51pLipaqmi70cxbhby4wwbhrJb+ec98MzEdgfSw2/GcU4n0PnWJM9j+ktEa+b2Ec5uy+RF0HX7+GNOi3OkNHjzIZab9jmKcJRpWkOMLWreHGu2/pk8Zccah0Xxvmjyj9YzndmtT0npoWhPN4lPOL3x1/HZp2cwlTeN1N6RwRTtMaRHpbPvf/3fyJworlkhPdEAwk3wBP5gDyMTkH9Ra9XbP8Bicurm506FNnzGnflvoNnsWgmaSTUl18Glw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=FkLkwh9zMnkAz8JA0CX9ZcIvNnuZ02dV9fCGhFrpo2M46IfTUOvrBkSP4z5YbasOZr9JGHlH6xRMHOxHXrNkB++QinA8oGwHxJeV/08yosHQwPInbRR401X8SSdzveQ6SnqHATZn8yBEkj7nJ+ao2K0yxfof7jGq2Q2QrDJyOB8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:09 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next 08/10] net/mlx5e: vxlan: Use RCU for vxlan table lookup
Date:   Tue, 23 Jun 2020 12:52:27 -0700
Message-Id: <20200623195229.26411-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:53:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c339f84e-9c5f-4208-c3e2-08d817af0dfe
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6101C63D18B4B7927ACD3FD4BE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFr3Ubn8yP5sPd33isxgWh+bhVWLi7wz8CwnW4chQI2O9GOuVZRmcLMe14IUHISYfReGyfTAr0a68/ImKjspo5/PfltLLwWZXatx5KfJ8c/nRTumC9tStG6Tk4aEM27DV3pyW6usx8OZrFLIVs6JuWRanmjCEQssFkRl9MJ8C2Xom/Z4Hq324Hpu6Uja9WrL/Go6ROP4UJRVEQhOfPjWr70lf7NrUr/lAZKnyOusurRTxZqVhv+b3lcplOeGZfiMZ4YcDuMOURA22NRHijmdNfWTcNn2ktW7pnSCPYI0DEmBmud0vLc6P076hbplTT4FpTl0WyB+nBrqEJlkf8QJ/gQbK2ehJsc+fHZw4P8q7kLNkFjOv4F1up3E6kPo9RzZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G3gfEx+ME2r/iulXfMX+VFeEhEI0VZ7k2Q7F5wQDrDCK2GCS+xQtRRWRiBDpxnwxSLLdntXlk3wiKa1mLlnwk+kVzMcM0cOz/763oXByLYM7d5Kl2xJqc2K2XF56i0BHxLA7sf5IvRZA/MREbjqNrcWTRHQDzOdEKYbjyKXnhm0VcvjuyDEQtgrDdBDwNZRU1d78hNuttUPmu6obgfFgacsiB0pFFQWlRFLSic0Jz5x1NFFqER9j1R0FVc7vTIegWRVAxIse6Wc/oRMscOcmwFrYBepiu49SU4+KqrdbjsVh8+rqUssH6RlEOAdLN0xlMTxoRuIUuU5Rd0wM4dQrtRD0jnUkJRWAAVgLYaC3l7lm7gcuT7QwEGT9LJHRqoBsfa0sx1SwfW5d6HoehZrdgJr9kOGkZHRS6ZHdZ70gqIRyhK6JlbIoxAvkAd+tVqTcQYDBIQBKmJaHNFViSb4ggxLMvB0rd81ao3nADL6ZEMA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c339f84e-9c5f-4208-c3e2-08d817af0dfe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:09.5760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QMWitOOghQmae9R6PpPQiDqmmsa6hztEdrKJHQKT8ApHD03s0bPz6HerME8JCFYTisvvnEu7txKANyaGtRGMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the spinlock protecting the vxlan table and use RCU instead.
This will improve performance as it will eliminate contention on data
path cores.

Fixes: b3f63c3d5e2c ("net/mlx5e: Add netdev support for VXLAN tunneling")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 65 ++++++++-----------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 82c766a951656..85cbc42955859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -40,7 +40,6 @@
 
 struct mlx5_vxlan {
 	struct mlx5_core_dev		*mdev;
-	spinlock_t			lock; /* protect vxlan table */
 	/* max_num_ports is usuallly 4, 16 buckets is more than enough */
 	DECLARE_HASHTABLE(htable, 4);
 	int				num_ports;
@@ -78,45 +77,46 @@ static int mlx5_vxlan_core_del_port_cmd(struct mlx5_core_dev *mdev, u16 port)
 	return mlx5_cmd_exec_in(mdev, delete_vxlan_udp_dport, in);
 }
 
-static struct mlx5_vxlan_port*
-mlx5_vxlan_lookup_port_locked(struct mlx5_vxlan *vxlan, u16 port)
+struct mlx5_vxlan_port *mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
 {
-	struct mlx5_vxlan_port *vxlanp;
+	struct mlx5_vxlan_port *retptr = NULL, *vxlanp;
 
-	hash_for_each_possible(vxlan->htable, vxlanp, hlist, port) {
-		if (vxlanp->udp_port == port)
-			return vxlanp;
-	}
+	if (!mlx5_vxlan_allowed(vxlan))
+		return NULL;
 
-	return NULL;
+	rcu_read_lock();
+	hash_for_each_possible_rcu(vxlan->htable, vxlanp, hlist, port)
+		if (vxlanp->udp_port == port) {
+			retptr = vxlanp;
+			break;
+		}
+	rcu_read_unlock();
+
+	return retptr;
 }
 
-struct mlx5_vxlan_port *mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
+static struct mlx5_vxlan_port *vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
 
-	if (!mlx5_vxlan_allowed(vxlan))
-		return NULL;
-
-	spin_lock_bh(&vxlan->lock);
-	vxlanp = mlx5_vxlan_lookup_port_locked(vxlan, port);
-	spin_unlock_bh(&vxlan->lock);
-
-	return vxlanp;
+	hash_for_each_possible(vxlan->htable, vxlanp, hlist, port)
+		if (vxlanp->udp_port == port)
+			return vxlanp;
+	return NULL;
 }
 
 int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
-	int ret = -ENOSPC;
+	int ret = 0;
 
-	vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
+	mutex_lock(&vxlan->sync_lock);
+	vxlanp = vxlan_lookup_port(vxlan, port);
 	if (vxlanp) {
 		refcount_inc(&vxlanp->refcount);
-		return 0;
+		goto unlock;
 	}
 
-	mutex_lock(&vxlan->sync_lock);
 	if (vxlan->num_ports >= mlx5_vxlan_max_udp_ports(vxlan->mdev)) {
 		mlx5_core_info(vxlan->mdev,
 			       "UDP port (%d) not offloaded, max number of UDP ports (%d) are already offloaded\n",
@@ -138,9 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 	vxlanp->udp_port = port;
 	refcount_set(&vxlanp->refcount, 1);
 
-	spin_lock_bh(&vxlan->lock);
-	hash_add(vxlan->htable, &vxlanp->hlist, port);
-	spin_unlock_bh(&vxlan->lock);
+	hash_add_rcu(vxlan->htable, &vxlanp->hlist, port);
 
 	vxlan->num_ports++;
 	mutex_unlock(&vxlan->sync_lock);
@@ -157,34 +155,26 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
-	bool remove = false;
 	int ret = 0;
 
 	mutex_lock(&vxlan->sync_lock);
 
-	spin_lock_bh(&vxlan->lock);
-	vxlanp = mlx5_vxlan_lookup_port_locked(vxlan, port);
+	vxlanp = vxlan_lookup_port(vxlan, port);
 	if (!vxlanp) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
 
 	if (refcount_dec_and_test(&vxlanp->refcount)) {
-		hash_del(&vxlanp->hlist);
-		remove = true;
-	}
-
-out_unlock:
-	spin_unlock_bh(&vxlan->lock);
-
-	if (remove) {
+		hash_del_rcu(&vxlanp->hlist);
+		synchronize_rcu();
 		mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
 		kfree(vxlanp);
 		vxlan->num_ports--;
 	}
 
+out_unlock:
 	mutex_unlock(&vxlan->sync_lock);
-
 	return ret;
 }
 
@@ -201,7 +191,6 @@ struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_dev *mdev)
 
 	vxlan->mdev = mdev;
 	mutex_init(&vxlan->sync_lock);
-	spin_lock_init(&vxlan->lock);
 	hash_init(vxlan->htable);
 
 	/* Hardware adds 4789 (IANA_VXLAN_UDP_PORT) by default */
-- 
2.26.2

