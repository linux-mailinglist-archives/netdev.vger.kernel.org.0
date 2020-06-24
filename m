Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9928E206B64
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388849AbgFXEsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:48:22 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728681AbgFXEsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:48:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csZp0qCKZdbp8ADX4OCe7cVFgmWyb2iphJ1wqJNr5vjGapGWLqK7a9wKi9mKZDibv/cdG4VSFlkBkDRn60KxoQdgpErx6/MaywElJ6t8K5dT6mf0hEh9eB5gxZ6Ez+FW9oQK+QUJ2djDPH+RhIwOXT6yvK6YAiNp8+7UK1tfvgfZPwu02YYHsDx0QLNvNdxZtHwBtJRT9qCH5ofYLL83QwCgx2/fcuUmSLmxbSw7UEr9+hntXTbFayPrFUGcoca5yd7pCIA0LaNgDiC55TEUjSZBMuMU+SIS2SYxcfSg3bsCtaYqNjeMJY9Wbv66it2qs/TIpO15hQ56E1L8oBFJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=fms0prQiAQ8raPiY3cyCRQxc8amycIGdYybKxgK15h2+RpnlB/0QAc/aTaA+s4HAs/cfa7Eo8Tdv3825vipE/YTy7L/WeSgyE7FO6bNIKJGtNFl8SBgvy+KgAwH0bYRTkgOpALWzdhxiPrLhuaHcTmwwApCL5U0LO6TTWB5Ify60eztB4c9F66snSXR9iuX8ZC4O5fVkuiZM93rZNbMuKwOKZqUipTl7EXITdnDRyiFLFjxwgEfeoFm63aynx5ybQ2d7sXoznFgCqTO3RDJF1QUWX3ya1cPs8qYhzaf6c5bbojgQrz3sSfdEkXPUze0o4is910mdrfCE5/pDar9APg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YoEKPAc2KN2ibUm8brhI4F3SaBGZVeebPwrbzzWzuU=;
 b=W/WL7UlbVWKqCtW27TmuFQSW6tHb6ZyRPRERi9EnQiBHEdgkxCSujyxMIPWOy4+4CX+2sfKQa1+E+dFTjmUNQXLfJFjaCdN35Bg9t3INi5ZXiIoH2PSkjcU/axid+aWMl5K8d8oJxzVR3Z376mpgFOL7GVqrtt+gCnTA9f6o0yI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next V3 7/9] net/mlx5e: vxlan: Use RCU for vxlan table lookup
Date:   Tue, 23 Jun 2020 21:46:13 -0700
Message-Id: <20200624044615.64553-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:31 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14846e5c-9d10-4954-16d5-08d817f9b505
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5135BF8F52ADD91F07CE28C9BE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lTygx16ltwWT8D6XdzKV1UucljKyjUTbucwRcPDREWMUuq/E58nCno2tdTrkfl/0r8bsdBWZuYwhV1o16XVBucUL1UZ1Xfgz+Qx6isWIkeLWgaGQuHCl7dMzEjD2d1+G8u8BnNc3ZkVGQpqlr0SagWZis29BoNPfWCzaUhP25qpj8stMBENOMUFzIuO4nNcblq4T34Zpo46r4/MqAdvxfYARH322m83fnpFdzdS6oxNj1T74zOnaIK6HUncz3x5cZWf9zt2cy0upp4vr8NseEIyKDRS033YDTh/10gbcMcI/GGmGXK+Vrz2dsgvCtM7c8tam1K5kxDGlEuFfEfazMDZGc0V5GMBevpH+fN4qigIl+ratmTer3BEZuCYQCsR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IMFcOc/d7HtkIXTIaNJqlgkRKB8qoWLEjAhXzewjtGGb/T0jwmjmeuoF1Ili9awxNqJ7WLl4AZ0/o/DV/tVO09D7QT0Y31OEl9GctbGr7EtEPokS/VFzZOgkTPsws/pnraYCfZF6qZ/unDz+1QxAOHIRS0hcfXDPAYAJ4HhQuQ1MBB3Y7DAY5ybXLX+i72Qj95oTjJMJxjPSkLeclTno2TDSipCHPdU+qpBh+X1JbSrXKJ4P/KleGPMBMejb1rEo5Kf33J96S6jPZLQ6HXhX0XRCQMipdn9mjYrAiibbkAGHKu+0+Q7vIKSdmFQyWvFJ55OMKqo4nnRRNhbrlMC7nk5QRzMp/ddcQFmm+1zkydRRjB1PCVgNvev5PpXLmZ7N5DkmU88hilhDfwaLAg3zstDCRSlNOe2EsKHeNIAnfshdiFInglvEOdkyJmWuzcSRdWZaI2SbvnOCwpbtEktgcvS0k3sUaQ1Z7Vx1Y+D91+VGE6jpFzYDR0r5SC4K33lh
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14846e5c-9d10-4954-16d5-08d817f9b505
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:32.7278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvb1iFQ6esngF/1R/q44HfP6xXTYK9CrSQD7BymIFHezONgJXnU/DT0PnGeIUUmhU8gDB5PMVRJpBIb6xjJcxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
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

