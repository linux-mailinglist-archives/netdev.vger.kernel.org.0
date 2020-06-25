Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6088F20A676
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407025AbgFYUOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:16 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6196
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406458AbgFYUOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:14:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6I/kDvGj7iX26rM5N2mTGbMTrx21WixLcN5SpqJiTAtITmP2JV7Svqq3rpBGs16L2Yxp/R0leDjXxsr3iPSmpH+hqYZgAC9cN+ylVZf2PyfaUxZsQnuQ4LxD5qUtX5GLF5w7zVY8scGrfvtTdL0jgJCHXcrOK5WhTCCf4SVteSv9sLe92zUHBv0dh3IGCZI5jLrkUdQG7JafgWA4TUX54KstkAcOPvDNO5vPGVr+Da9Lt46YKPrv41h2zq11S+FLRO8crsjRDRrpLdleApR+najR5t3J8iVTj144q3n0o7C+Fk6lQVFa28CKtb+tyb9aw2+z5cW0QGBiIGi200w0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=RUKM1Wy/DG+h5GFi/Ih2o+df43OooPYC/Dr/mhRevwjuIor+jTKXYhdJuiBhYmwxFA1JtmtLI+fiFuuuBwEkayexUXe2KhMFp+fScYqFTm4ph8PX4iqwhNXovj8Xg4IrPt4hxYV74lmLKjtaSmC098JzaMxTvjqfhy76bUJGudqJQLcFcY0bRtR+sLnF0XgSElFveO3skb0Py70vDBL1ry/TDSUcEDE0/IDAwo0EyXLSlwt6zdA0vPSSlskp0FrnK68mD5uu6jHBlOxLjqx0YM2r2kHrZsf9zqmiyKt4jq8ge7FHoEIlN0EQ3q4DLsJPAESCaYUmAafXHTyVdmkGhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=oK0/7SPs/ftFjiEPtnm3KVqDai3z6bEM8LI8jnvKZjkCzKxJgUfmG0bjA6R7PNMTOPNm2mHklahDtPhtmXi3xuKCMqPV5wfHtUPSsQsCD2m5/A+pmpLNBzNvhoHa7d4nHOK6oLwPzIgMfPL61wdryDOkrvGvDVJlF6g4TDRwKUQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:14:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:14:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next V4 7/8] net/mlx5e: vxlan: Use RCU for vxlan table lookup
Date:   Thu, 25 Jun 2020 13:13:28 -0700
Message-Id: <20200625201329.45679-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:14:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 445bc722-c550-40a9-f7ae-08d819444e31
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448DC5DCBD25F0F544F8B40BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KyFlNIUNTlpYxURgc3HjMO0vP/2j2IoyDXMph2d7dh9xcGC6qhGZje1iyH5Y1/ZFpU9fzxSENHiHcOzxWKmU5aIxzLs4iZdheqW5Xeg4v4xBDCkzxkiLL7AUXu8yyS43CXsCHvc5//9Oq5bUIhnvLTUKK6vKGC3YtncF44rl16iPCoBhSz0A8Hyl/Ca3SW4Eh7TuZcEGGmYNnYiZZQ0wSqeZ9Z7Zm//k6z7m7opSQ0J58MAs9wlpKwU866jpL5NqTkvnZd/U4jo/lrwyTxWkfy8qgGQDuWgWGdtaGajgq6SRREFhmJLtHdVTMDjRBHpwR3GJUFhp3G9TTf+a33gJISJbrWmigOJmJsTYsuRPiaFLNg54VaQ1ISWdZbi+Yjj0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fBrqCyDswWcEdshFL9qUbvPy+9FXJtOIu8oiN3Pyvg42Icwvniij8VZTLrb5d4eG0pAYEnP6ivYYNa/p/UySZ+FpyqTd0fgtCHI/er1Zt/ypz6ENIUgDP0lHjxf0tAH0CpbQtk3YIUaxhI3t9mQaWFUNzI46HLw3CQGWTBFpEyhW2g30TFyfdbuLrHPLCXMnTjVdNp183vCZcabA2BSGPiQsQw99BZmzZotWn8SaOdQfR+Kta/1y0snnYZz9D6jVxJl6n4sS96KcBxhX5u64R3QVjHyDdr/4HEIPR6BE+og/BP5SCUCC4lNCUrNhargjyOaJ4pmQpi9V3O+7Is59p8NYICaEXRxoNvTbwpbgM97eLXfcjbLt9FrPbVP2O5rv9dX7oitphJtl8ZhWO6Vm/OxY6ZTGS0X01fXOjWpStHqS5H9/jwlnGCYeAajXXl9KekD7wr/QM5wvCx+gYX51CYEu2ZB2wyOUEwN1rUNxcL4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445bc722-c550-40a9-f7ae-08d819444e31
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:14:03.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nip0SLXEdwWTcNs3tXTD33s5UTviar+jm4wrHpVzKMyMdCU+Kv9Zkmh+p26Whm6FrhBXnHe3kpMF6/bI3YpAxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

