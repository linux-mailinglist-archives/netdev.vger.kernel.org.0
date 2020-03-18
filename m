Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C71189424
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgCRCsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:33 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727133AbgCRCsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOBWebK5j2pJd7q07NJRC6jr1/5YC0g/MWHVg4epI5lIMbQDmY16stKcZb07tJPQndSN2k03oTHgsfrf/fTAoTNfyDTU7OXLFZF2/8rpMsZd49sww0dJtOuHV3Xni3I2jpdlPtwmxjLR5M3MINORB6c5864ln6YKf1rlceIUY57xW7IEbh7ml36rI7u1MaeNHGtvKNjJCo0z4OV9VD1pGr2BDoLChh9xErq8hUdjfoeXJD+rZpoOqT3SegIdAV/mXZQm+ayHf5WyLwhYKHDvhikgkmfyqWEPkp2KPsxXEdAV0SK1Nt61hZDLLFouGuMWdkBQfWWwZogdgukHC/IHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mumTuuuk29pMzBqAlkK2QZv/86iqgwEtbJX0STViwRs=;
 b=Ar343Vfq03OdGme/yhpHdaXT6vpgP4+HMiM8YJqG+VZsPEwmweNcTSsJzgY+cW7/AgYybKZwsnBcRUSBRJOfsFmccGS9jd4XvkNRvt0/laLXAmZpbZKLwTPJe+y+sF77Ozr/TNHjBX+jJR3evRW+v43wuwqs9vZkd79p0GrDkIwIUy++qW79/ruvZT5Xewp9sL5OkzL/80oNX4nWfFJdLubgbFz7QoVKld1ar2E2Q/ae4al4488FpOCttZt3z026X5O2BKYZxrL0raMeiiKTgOqA4pEX/QVO8KmzPhK0gQqSmJw8fn3DfZQYrz9WAkfq/2AMLsyorEA86ELLs8uUDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mumTuuuk29pMzBqAlkK2QZv/86iqgwEtbJX0STViwRs=;
 b=QfwdNpbU0YG/6HVZwDYw5nB8N4U/h54aFJpMqXIznn8ewXJfdlvKYkBxpwDs5py/Ua9yaJQ81FEzDTQo5WUVIc3tFlOssAZKBcQgl+Ob5NtuF2IegdOWGhLF9XuX8LRsIsAxSBIdHU8rHPXCKJgVZYcLITennxfy9dDJ/+k88Ks=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/14] net/mlx5: Avoid configuring eswitch QoS if not supported
Date:   Tue, 17 Mar 2020 19:47:18 -0700
Message-Id: <20200318024722.26580-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:18 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed34c933-09de-41ed-b23d-08d7cae6d197
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109C91B981A4797EAF581F1BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 835D2PaN/Qv59UfxzVTY08ccHKoL8cY2jMsLCpV1ByW2jQvDvT3mjF6eCOgK8az96eqbLhtRJqJGnOrvJ5qNTgLSfFr67F85wR/0sNgKtie994kXUd8vneUiwIJS1EL3vKxil2vySI2YLl/osIAhxEFPV3bWi2rc4uCLsU3DSU7ACiA9cc8mE6cjRk2KE8cO85RENwfkd0KCuTl36kaCL51lTCAAHmhqOBSZUDSNVhOgvPsvILAlnBAzkqgdPbuu53SaUTje7fGpCltE4NVsmbRRs5DjymYhxtjkj8mE4kI2kuvClLuOOet+BdwFXxnYGJc7VqK6YeDxrgIiPoXibaCWxgdRxhWKozs9Yi41TqrRgtH95K2kH91NFEnCLRCf9+XRoVkum7sNHB/UFYJotvgEVfD12MBvHoJ209Gye6DpusbsDVtWxmgr4wII1uWnY1dyNzdPi3joBqH14dKFwSitks5eKnsyBuDk2VWk50RznPi+i73YixdpNGeDAAt8xh1OlOqqQHvJDZWQi4MaQLil6GbAG9Q5ecSNz4x5ZtA=
X-MS-Exchange-AntiSpam-MessageData: HlnzDl9ZyeOojFdR2vdshG0g4xv5YAzjewW9+IGwIXRGrrFm6zrxTHWiHwXyZEBT4AM7bqdNS7dpws5Ad3X01YDNxfWWdZdZuoDahYs+l3gKuDupTL6l26zOgZ0zs8fJpQ1fD07yKNPjfSpg9bF9kw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed34c933-09de-41ed-b23d-08d7cae6d197
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:20.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkk97BO5xLx89cOElbGaCn1LxJ1ybtzZ2N2nXGk7OyfR+lqzgK9WRibhK8GcQvRwgvbwTOAR+l+iKoYCX25OTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Check if QoS is enabled for the eswitch before attempting to configure
QoS parameters and emit a netlink error if not supported.

Introduce an API to check if QoS is supported for the eswitch.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index db1aee1d48e3..ddb933aa8d59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4521,8 +4521,14 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
 				struct tc_cls_matchall_offload *ma)
 {
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = ma->common.extack;
 
+	if (!mlx5_esw_qos_enabled(esw)) {
+		NL_SET_ERR_MSG_MOD(extack, "QoS is not supported on this device");
+		return -EOPNOTSUPP;
+	}
+
 	if (ma->common.prio != 1) {
 		NL_SET_ERR_MSG_MOD(extack, "only priority 1 is supported");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2318c1cfc434..c18de018c675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -453,6 +453,11 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5_eswitch *esw,
 					  struct mlx5_vport *vport,
 					  u16 vlan_id, u32 flow_action);
 
+static inline bool mlx5_esw_qos_enabled(struct mlx5_eswitch *esw)
+{
+	return esw->qos.enabled;
+}
+
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
 						       u8 vlan_depth)
 {
-- 
2.24.1

