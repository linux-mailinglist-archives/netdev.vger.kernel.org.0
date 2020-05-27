Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD03C1E49CF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390960AbgE0QWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:51 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:46308
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390952AbgE0QWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW0kajCL0ETrvi01RCvN2g1o3J2xln+EOhut3OgiCHN2AvQb7aZitDrZyw6Nmb+3T02k4JOvB+Xe4AjMf9HP7E5L93K1EZef0xnaSFZWQg0xqSy5TVDK1tC48vakI2fUliQ5rvHCzbg+aFIXZKfXKPU7bEcomTRstaKztdwBf7h4XbK5e3/5Xv77ASuNA7GEnHJk6Q5+uQXqEcSXVT0Zk8EnsU+JP6g+6pO8YvYmxiFTyD8VNoFJbLIXBDZkWgXHSbwKqhTlJ5H1I/rYusMxQvYBKAJhOGSkIdAv5LwoSxcGkbxwx5bZaAXm7CGIn/wjkce/yGNgqy4zsDH+LStQHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SljShiqwp63r44SQv0GaHhbh9F+hvuHXLxmoNojU9GE=;
 b=oDOVzfwBLiA+B85jihItKmgL2EHMIpazU0F7haLGYZR8kUSvQQB4Xj6CjrB9OaAFmWHx0fxH6cMRzSrjobktUBznUFiFIS4evf1LNeykmMPgh2CIcAMhtln7/alVgveXH9Ckr0MsaVbS7yxgBibhoA2KEeG06q+mFxmyuppdC2VBuv1GepxhHFVmvZtIYznCzcQUQQe+couUb1s514tVoLPzMLL9zVTLMHa+BqjgxTp+klZUbZCm1wPNoJ5pV0umTmyLQ3O/wvniVfrL5lEyjZOLGAXWcK+7lBvV6KnTer678lsWPzJm7y/fgmJHE6c/CtF5qfSWrySBPatBlqhi/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SljShiqwp63r44SQv0GaHhbh9F+hvuHXLxmoNojU9GE=;
 b=nJLRP/6K5fNrWBwj5JiqeUnQ4GRmWjck6onjxFkKyocyruEdC6XKgieAUF9kj1bOc3TMn6sGH2RCiRwX4/kt4c746QYDi7lXSkI1BmD6xcr51fdvqxzHQ6GiKPKU9KxZbuhDA9KXzJrO4NH3gVZD/yAvt30op60uABevDVM/tI8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 27 May
 2020 16:22:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 09/15] net/mlx5e: Slave representors sharing unique metadata for match
Date:   Wed, 27 May 2020 09:21:33 -0700
Message-Id: <20200527162139.333643-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 134a9009-7db9-4401-1bc0-08d8025a1ff2
X-MS-TrafficTypeDiagnostic: VI1PR05MB5054:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB505420C19A09DF9A1EF2F94CBEB10@VI1PR05MB5054.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +y136F6m6ScPmw8kE4TfCX0a1DlfH/hUtRVVmck/TsEZHtIVOaZhDgS6JSU6qrG/aSsPLhvD7lrk9FAIpNfdet2iWfP885WoMqJZkbyUKT0QXMZcFvyG1RLc6tR4j6UpjK70hRxRzKyB15houwDZ/iFpBRMEPemBLdHmQZtgb4vxoEw+lDipFfVu3WATXlZzXlS0yB176JxQJjKJl/ISclF8yWqdNybZiwpA+Ci/PS0ysMCWGx2zimi+dNbEObGiV8SgM/h5ilbBpJ18JGADoOjXG3yMR1EsN7mb4/wqA2UhXbecQQ9l+8+cbUtNxn3Um8nE+1+if4UnStXl3CWZM4nC89sUL13SeAXxUaPmP9qOQzL3tME8aTvPtmGtrMgC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(6512007)(107886003)(66476007)(66946007)(66556008)(52116002)(956004)(2616005)(6506007)(5660300002)(6666004)(8676002)(26005)(1076003)(86362001)(8936002)(478600001)(2906002)(4326008)(186003)(6486002)(16526019)(316002)(54906003)(36756003)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rk4nsK9S5PucTzVjbCo9Zgl/13r8AQXqmpYCYUKEDOH0ypiHG6AP25ZSXyTGFUg/2TANcMCbDvd0iUv203rHYakPTx8sjPj44xDinSPpvlE97Vuau10Qf8VsBbsTi1yE3xepKqdzy8An5Agu+D7Jk94GKvlIPCAVL0vebBT2PlyI6b/zGEEHHwA7E0htRF+4D0K3DrtEQ83xjc0pvEhioPkzwjMyeQzCyAuIA9vrAenTJ1kLlL5wwZCf85tnUs3t0/DOBjZYgFMBsy3WoSn1txfvFiDtAlxkpGL14/2ab6tp4d5J260/rC4VNZ65ijVYcNJciPFNLpI3q1G2TuO0uLf9Iplz3n/xu4W0bJoQ3nhOkoPcOlNJt8Ib1UIquEWeTmSgIqEtO/dG8RzmHDJ8vkquj/TILuJyg3R6lK12dz8Ny6pkOI+SigK+cUaOiPRp3r/K+WIoagMeCs8lf3+aDki9UwHBzLE/UVI7PsrGSAk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134a9009-7db9-4401-1bc0-08d8025a1ff2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:18.1196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WKLcik5NRInaOfnaZFXTpNldVEUPBRZl8cnzZM6SjlVXHea3d39QIb9Zh1Cvpe1YMBiJBbl2iFCY5020shy2ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Bonded slave representors' vports must share a unique metadata
for match.

On enslaving event of slave representor to lag device, allocate
new unique "bond_metadata" for match if this is the first slave.
The subsequent enslaved representors will share the same unique
"bond_metadata".

On unslaving event of slave representor, reset the slave
representor's vport to use its own default metadata.

Replace ingress acl and rx rules of the slave representors' vports
using new vport->bond_metadata.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 65 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 22 ++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 +
 3 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 932e94362ceb..13500f60bef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -71,6 +71,7 @@ static void mlx5e_rep_bond_metadata_release(struct mlx5e_rep_bond_metadata *mdat
 	netdev_dbg(mdata->lag_dev, "destroy rep_bond_metadata(%d)\n",
 		   mdata->metadata_reg_c_0);
 	list_del(&mdata->list);
+	mlx5_esw_match_metadata_free(mdata->esw, mdata->metadata_reg_c_0);
 	WARN_ON(!list_empty(&mdata->slaves_list));
 	kfree(mdata);
 }
@@ -82,6 +83,8 @@ int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
 	struct mlx5e_rep_bond_slave_entry *s_entry;
 	struct mlx5e_rep_bond_metadata *mdata;
 	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *priv;
+	int err;
 
 	ASSERT_RTNL();
 
@@ -96,6 +99,11 @@ int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
 		mdata->lag_dev = lag_dev;
 		mdata->esw = esw;
 		INIT_LIST_HEAD(&mdata->slaves_list);
+		mdata->metadata_reg_c_0 = mlx5_esw_match_metadata_alloc(esw);
+		if (!mdata->metadata_reg_c_0) {
+			kfree(mdata);
+			return -ENOSPC;
+		}
 		list_add(&mdata->list, &rpriv->uplink_priv.bond->metadata_list);
 
 		netdev_dbg(lag_dev, "create rep_bond_metadata(%d)\n",
@@ -103,14 +111,33 @@ int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
 	}
 
 	s_entry = kzalloc(sizeof(*s_entry), GFP_KERNEL);
-	if (!s_entry)
-		return -ENOMEM;
+	if (!s_entry) {
+		err = -ENOMEM;
+		goto entry_alloc_err;
+	}
 
 	s_entry->netdev = netdev;
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+
+	err = mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport,
+						     mdata->metadata_reg_c_0);
+	if (err)
+		goto ingress_err;
+
 	mdata->slaves++;
 	list_add_tail(&s_entry->list, &mdata->slaves_list);
+	netdev_dbg(netdev, "enslave rep vport(%d) lag_dev(%s) metadata(0x%x)\n",
+		   rpriv->rep->vport, lag_dev->name, mdata->metadata_reg_c_0);
 
 	return 0;
+
+ingress_err:
+	kfree(s_entry);
+entry_alloc_err:
+	if (!mdata->slaves)
+		mlx5e_rep_bond_metadata_release(mdata);
+	return err;
 }
 
 /* This must be called under rtnl_lock */
@@ -121,6 +148,7 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 	struct mlx5e_rep_bond_slave_entry *s_entry;
 	struct mlx5e_rep_bond_metadata *mdata;
 	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *priv;
 
 	ASSERT_RTNL();
 
@@ -133,7 +161,16 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 	if (!s_entry)
 		return;
 
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+
+	mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport, 0);
+	mlx5e_rep_bond_update(priv, false);
 	list_del(&s_entry->list);
+
+	netdev_dbg(netdev, "unslave rep vport(%d) lag_dev(%s) metadata(0x%x)\n",
+		   rpriv->rep->vport, lag_dev->name, mdata->metadata_reg_c_0);
+
 	if (--mdata->slaves == 0)
 		mlx5e_rep_bond_metadata_release(mdata);
 	kfree(s_entry);
@@ -163,6 +200,7 @@ static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *pt
 	struct net_device *dev;
 	u16 acl_vport_num;
 	u16 fwd_vport_num;
+	int err;
 
 	if (!mlx5e_rep_is_lag_netdev(netdev))
 		return;
@@ -187,11 +225,28 @@ static void mlx5e_rep_changelowerstate_event(struct net_device *netdev, void *pt
 		rpriv = priv->ppriv;
 		acl_vport_num = rpriv->rep->vport;
 		if (acl_vport_num != fwd_vport_num) {
-			mlx5_esw_acl_egress_vport_bond(priv->mdev->priv.eswitch,
-						       fwd_vport_num,
-						       acl_vport_num);
+			/* Only single rx_rule for unique bond_metadata should be
+			 * present, delete it if it's saved as passive vport's
+			 * rx_rule with destination as passive vport's root_ft
+			 */
+			mlx5e_rep_bond_update(priv, true);
+			err = mlx5_esw_acl_egress_vport_bond(priv->mdev->priv.eswitch,
+							     fwd_vport_num,
+							     acl_vport_num);
+			if (err)
+				netdev_warn(dev,
+					    "configure slave vport(%d) egress fwd, err(%d)",
+					    acl_vport_num, err);
 		}
 	}
+
+	/* Insert new rx_rule for unique bond_metadata, save it as active vport's
+	 * rx_rule with new destination as active vport's root_ft
+	 */
+	err = mlx5e_rep_bond_update(netdev_priv(netdev), false);
+	if (err)
+		netdev_warn(netdev, "configure active slave vport(%d) rx_rule, err(%d)",
+			    fwd_vport_num, err);
 }
 
 static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 12593d75e885..af89a4803c7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -854,6 +854,24 @@ static int mlx5e_create_rep_vport_rx_rule(struct mlx5e_priv *priv)
 	return 0;
 }
 
+static void rep_vport_rx_rule_destroy(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	if (!rpriv->vport_rx_rule)
+		return;
+
+	mlx5_del_flow_rules(rpriv->vport_rx_rule);
+	rpriv->vport_rx_rule = NULL;
+}
+
+int mlx5e_rep_bond_update(struct mlx5e_priv *priv, bool cleanup)
+{
+	rep_vport_rx_rule_destroy(priv);
+
+	return cleanup ? 0 : mlx5e_create_rep_vport_rx_rule(priv);
+}
+
 static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -918,9 +936,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-
-	mlx5_del_flow_rules(rpriv->vport_rx_rule);
+	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index ed741b6e6af2..da9f1686d525 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -222,6 +222,7 @@ int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
 void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 			    const struct net_device *netdev,
 			    const struct net_device *lag_dev);
+int mlx5e_rep_bond_update(struct mlx5e_priv *priv, bool cleanup);
 
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
-- 
2.26.2

