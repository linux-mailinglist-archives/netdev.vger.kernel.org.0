Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82C0206A10
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388356AbgFXCVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:39 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388207AbgFXCVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCU9XtibhOriLVQqz/5yWWA7a2g4Vb/6SE8qk2qPEJMSM6XDPm7nqaIVaV/yLHJyzJ4ASzf2/MxFQKVNATV5kAISbm7grSnS3GG7gpTcLEj3RNGkcpwDQeycIPcG/0z/gYI0fJ6pEA6TxrPFZh4kERaNuau33E7N48y6eVgkL9rdUr2s5gwDYwmbL0eRBJITM3r3WsiIM+WB8nqY05VXXCHZh5pK2roLY8Z51zvg68E+fHrtcJpI3BRW8KK0LHahN5iTLFNNJwgNV4pugPpO3lO8yufX/uXGQ954Q1sUtRu2WddX765mkOjKx+l9Yzn0bD8XM3bSLrOpnA71lBuScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=QwTxWMrVPMC8btZ6aE664pIQaR6m+FrLgJUeIpFi58T+f5iwkcnyRn/dZ8yoLNY39ryckcA/+CofpBcQ5bzbnkI5So3m7tNz/aH0XVx+WwhJr+w+LsnyAfh5NIKSuEsjd5NfuAs11UOVofKDsTRmHlwqReLT0UP0EDNFwoSGCOA7FumPrzuCIZoLaVNSjiVrqCshajUx0HPlMrGmSxvGPys4MvLCsOGu/hEYN7KcA4W9SSiUyuhxBe1y8d5mYtkAj2iPsR29GpEvAXfA6pO1ZJX9oJaQFKcsf0eD5ooRVc0RGr1wuLOleoGurR+lM/TENMe8EXcD5+cb4Ko5fvxb8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=hYwIN3QG2X8k1AQJQRaNfcIwJ056nAQC6lkxEecEnI6rMavAp/kEaSfljax+sCbQYSQuJRMAuccXsVwhSykGj/xR3a5HCQZHUSocgGjbd/ZX4cLS0h2IMQlkF6guzV1zyEOTjw2lZYO8mURzzjlP7+g9IfqHxuU2az5d+NnZgCM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next V2 08/10] net/mlx5e: vxlan: Use RCU for vxlan table lookup
Date:   Tue, 23 Jun 2020 19:18:23 -0700
Message-Id: <20200624021825.53707-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dcf074f1-6779-4061-012b-08d817e54a31
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70225E23370F5537D549E474BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90Pbk8pgLUTfBox2MZebJenZA2h2dYKaSAhSlrHjCQlIDj7WVeg8bRjSY2Vpq9VPHYIduP1CsfqiPw9ZAv8CagJaDM6va+20gKz7HukOIvjSLQv+VCDdeyxtI9QYvGTKv+3TQC6xJ0flQ9LjFacxXsAPXtOPATKMyuSgp58AM6wc2xJnoEfhQZfQhQpcz34XVO+W+monrM2csTarR5bOSSz2+Efnc0SblqbcADs5rjCpMlkRWggS/UnkGVkW0GGBXXugWAOSdbBTEPau1f1vRGbypU+JD0ezHnjS2HxPgbLNb5EDDRDA3n07RZdIysmuqDHW2qJiP+9deEyIvitqmILU9z2hwi5VODvfrg2PjR+EhLHGpKt0mpLZFaIszrds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ePXIH4cpla87vG41JsSCqMzCnjKqYsEF4lJjqrGgLum4FNLfbHmDLumbCxzpNQAAM2jtyE7VlIec7DiGI6vs40ZhA+C985BSArHv61q/pkwniXxYmZ7nY5YKpQFLWdsIAr3IjcOiPojhqaX8+Ketg699jZF1zRHEdxyk4j9pThn2y2NQ9+wTccucmBi6ZjliAsr93Lz3jDbVNTCRot4NHaA+2d4xQrhwtYVv6tI37q7CRbgLPfEquvQgFtOKTeyhKbCmCrXuvhPicVEaAtqf5KnylKxODMm6O9GH3gxDfCH5xm4wNciyt0p8DLR6tHIDB/QgO+TAD9nWypaLLvqC9C9GSxL3uF6b2x2ClwFpREIUVhl08VkxUJpYCfeq5gmliOkzvyEeKBGoD/vMFuTQVip+y1djTBFzexs6mjqXXsO/bxyNOrnAIDVycdGsq/A9T+3XDfqf9HaJYxHRxHxTNRWw6USHx6rJGwuv32gVoFw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf074f1-6779-4061-012b-08d817e54a31
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:23.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2ZuIH/f/iVeABb/EJheJ945OvzxFWzUO0lgSn1Ku20/IisLqViMeMwso/Wxw2jgAfwb78xKy8h730RCi8setw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

