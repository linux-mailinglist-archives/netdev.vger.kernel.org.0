Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD1D8857D
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfHIWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:41 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfHIWEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oA+61s7+8IqSFSQ7e+X8onPI8hfxSE01PNtdrxwp/q8D39qosIVnxa278nnfNd2Fv2snr6rDoUC76+rtGuQpylNUzDP2aJ3SjNDfC7egpxvP7c8+vd9gHofQgwc0NImz7Y51RAewxuDdft4z4rxjja1/HyTzZdkevIjN04PU4ovs5aqh+KHjDB8v+XeM9f9FBin1U6ZGs3+Aj9fcTRM8mAwpSq8H329RDjJ1oxxw7kWszlw5O9HwmlGRXPLG2FUtgFPvcxyVOKDUlEvusPqZGUCaRbJtoEkVfGWgI3dq4GKNRp0LPowWgto9tEygTeL0MS0qSm7Knn6uhGJ1inQlYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkKiJHkQkfcZD+2ZlIr4amKi1oKoz+WNi0IaBBjxKII=;
 b=ECRCP1R/lEOK4qVrpF0PT937DyQeV+uoxxe1qghzH9NFRVjvNYPBXvQ9YGcsJOMQ4jv92V8PiUELqQhHr7kFDHIPE87pkLzjCCOpaUmKCLncRjKTLvZKFCOx85VmYsMx9wUo+UPCgvol5YoJDQObPMbOC3IN742ldiqHzxMjrmOO/ECC6eTi193onMOy6OKPdArN3DxUa599v5iaBQjKUKjOLZ8N0VqclPGRbMrSO6uYVphJA9PTDh9ms0kAQ6H9WfpLMuSNQIRGCTrnlTr8FkoN0DNi5Rn++qJuVtEIurSXIExuoPBAXjE3bhpCZPZ0wR3sBqqIFuhlbLxGhNbIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkKiJHkQkfcZD+2ZlIr4amKi1oKoz+WNi0IaBBjxKII=;
 b=jTRU2MnOQs4+RD+yKG6UbpK4uA874XHWrL01SwvFSDjNl4AiCfmYqHlU8OQ445P4rKFi5NRrnyKSjRLW7ckWJwPEn3Y9iKKzHaiuhhEXafuYPnVOQFGMV9YFdSieIIE3ak1+1hfJR8Uif3g1WXnEpHOBnb9+kmTi/pt/pLDIC00=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:25 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5e: Allow concurrent creation of hairpin
 entries
Thread-Topic: [net-next 04/15] net/mlx5e: Allow concurrent creation of hairpin
 entries
Thread-Index: AQHVTv5nzZunluMCv0eBpy0EpEnAVw==
Date:   Fri, 9 Aug 2019 22:04:24 +0000
Message-ID: <20190809220359.11516-5-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23fb095e-b3a7-4a2d-a3c5-08d71d158a4c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2856B46660E752CB8B39116FBED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EdJ5b8M51ggDmnin1bH697LYtP8GvCedk54Rpi2TMwZo+36OindHWpLubjPzGu3Q+MBrAXwhwlwD5mzJM7ph5B96L3j84TMpaaysLb+CYsQ4yyIc/8C+IvsU6AIMOWBzrsGAhQCxwk9VYbGnIQ91Xn8qOjk5ycBd3FzREdeD+sSquxGCMY/NFk1uzmwaQuZER8sqoycOjmaFAj7y8l3Ch5vQsVp0WBq39I58zmrfJaooD+5zd4Oy2ECmMQUJIQFn4HczlAE5bBuD3ka8clkC2Xjk+SsyuegVe7SuyL8gtLjWhRwlxAhY4LmfKEvx0Gnu2xavjkc7h9nFTqriXqQ8p1bnEsw/a8GtzOcRGqgchobhFB7SqYlrik1ni67z7LJJnowdE/I1IlOoO/is7faU6F73qvVx1YacqgFANTLKBPY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fb095e-b3a7-4a2d-a3c5-08d71d158a4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:24.9441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i0Y9KCB25ebKMlV8a/DB3s+2f0CYiNBgPrv5ihjsawlh69jx03JfChnBYiVweEhl2M2DV9K9gifesxPkP2XpKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Hairpin entries creation is fully synchronized by hairpin_tbl_lock. In
order to allow concurrent initialization of mlx5e_hairpin structure
instances and provisioning of hairpin entries to hardware, extend
mlx5e_hairpin_entry with 'res_ready' completion. Move call to
mlx5e_hairpin_create() out of hairpin_tbl_lock critical section. Modify
code that attaches new flows to existing hpe to wait for 'res_ready'
completion before using the hpe. Insert hpe to hairpin table before
provisioning it to hardware and modify all users of hairpin table to verify
that hpe was fully initialized by checking hpe->hp pointer (and to wait for
'res_ready' completion, if necessary).

Modify dead peer update event handling function to save hpe's to temporary
list with their reference counter incremented. Wait for completion of hpe's
in temporary list and update their 'peer_gone' flag outside of
hairpin_tbl_lock critical section.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 +++++++++++++------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index a7acb7fcbf5a..b6a91e3054c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -39,6 +39,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
+#include <linux/completion.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
 #include <net/tc_act/tc_tunnel_key.h>
@@ -166,11 +167,16 @@ struct mlx5e_hairpin_entry {
 	spinlock_t flows_lock;
 	/* flows sharing the same hairpin */
 	struct list_head flows;
+	/* hpe's that were not fully initialized when dead peer update event
+	 * function traversed them.
+	 */
+	struct list_head dead_peer_wait_list;
=20
 	u16 peer_vhca_id;
 	u8 prio;
 	struct mlx5e_hairpin *hp;
 	refcount_t refcnt;
+	struct completion res_ready;
 };
=20
 struct mod_hdr_key {
@@ -657,11 +663,14 @@ static void mlx5e_hairpin_put(struct mlx5e_priv *priv=
,
 	hash_del(&hpe->hairpin_hlist);
 	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
=20
-	netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
-		   dev_name(hpe->hp->pair->peer_mdev->device));
+	if (!IS_ERR_OR_NULL(hpe->hp)) {
+		netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
+			   dev_name(hpe->hp->pair->peer_mdev->device));
+
+		mlx5e_hairpin_destroy(hpe->hp);
+	}
=20
 	WARN_ON(!list_empty(&hpe->flows));
-	mlx5e_hairpin_destroy(hpe->hp);
 	kfree(hpe);
 }
=20
@@ -733,20 +742,34 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *=
priv,
=20
 	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
 	hpe =3D mlx5e_hairpin_get(priv, peer_id, match_prio);
-	if (hpe)
+	if (hpe) {
+		mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+		wait_for_completion(&hpe->res_ready);
+
+		if (IS_ERR(hpe->hp)) {
+			err =3D -EREMOTEIO;
+			goto out_err;
+		}
 		goto attach_flow;
+	}
=20
 	hpe =3D kzalloc(sizeof(*hpe), GFP_KERNEL);
 	if (!hpe) {
-		err =3D -ENOMEM;
-		goto create_hairpin_err;
+		mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+		return -ENOMEM;
 	}
=20
 	spin_lock_init(&hpe->flows_lock);
 	INIT_LIST_HEAD(&hpe->flows);
+	INIT_LIST_HEAD(&hpe->dead_peer_wait_list);
 	hpe->peer_vhca_id =3D peer_id;
 	hpe->prio =3D match_prio;
 	refcount_set(&hpe->refcnt, 1);
+	init_completion(&hpe->res_ready);
+
+	hash_add(priv->fs.tc.hairpin_tbl, &hpe->hairpin_hlist,
+		 hash_hairpin_info(peer_id, match_prio));
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
=20
 	params.log_data_size =3D 15;
 	params.log_data_size =3D min_t(u8, params.log_data_size,
@@ -768,9 +791,11 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *p=
riv,
 	params.num_channels =3D link_speed64;
=20
 	hp =3D mlx5e_hairpin_create(priv, &params, peer_ifindex);
+	hpe->hp =3D hp;
+	complete_all(&hpe->res_ready);
 	if (IS_ERR(hp)) {
 		err =3D PTR_ERR(hp);
-		goto create_hairpin_err;
+		goto out_err;
 	}
=20
 	netdev_dbg(priv->netdev, "add hairpin: tirn %x rqn %x peer %s sqn %x prio=
 %d (log) data %d packets %d\n",
@@ -778,10 +803,6 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *p=
riv,
 		   dev_name(hp->pair->peer_mdev->device),
 		   hp->pair->sqn[0], match_prio, params.log_data_size, params.log_num_pa=
ckets);
=20
-	hpe->hp =3D hp;
-	hash_add(priv->fs.tc.hairpin_tbl, &hpe->hairpin_hlist,
-		 hash_hairpin_info(peer_id, match_prio));
-
 attach_flow:
 	if (hpe->hp->num_channels > 1) {
 		flow_flag_set(flow, HAIRPIN_RSS);
@@ -789,7 +810,6 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	} else {
 		flow->nic_attr->hairpin_tirn =3D hpe->hp->tirn;
 	}
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
=20
 	flow->hpe =3D hpe;
 	spin_lock(&hpe->flows_lock);
@@ -798,9 +818,8 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
=20
 	return 0;
=20
-create_hairpin_err:
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
-	kfree(hpe);
+out_err:
+	mlx5e_hairpin_put(priv, hpe);
 	return err;
 }
=20
@@ -3767,7 +3786,8 @@ static void mlx5e_tc_hairpin_update_dead_peer(struct =
mlx5e_priv *priv,
 					      struct mlx5e_priv *peer_priv)
 {
 	struct mlx5_core_dev *peer_mdev =3D peer_priv->mdev;
-	struct mlx5e_hairpin_entry *hpe;
+	struct mlx5e_hairpin_entry *hpe, *tmp;
+	LIST_HEAD(init_wait_list);
 	u16 peer_vhca_id;
 	int bkt;
=20
@@ -3777,11 +3797,18 @@ static void mlx5e_tc_hairpin_update_dead_peer(struc=
t mlx5e_priv *priv,
 	peer_vhca_id =3D MLX5_CAP_GEN(peer_mdev, vhca_id);
=20
 	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
-	hash_for_each(priv->fs.tc.hairpin_tbl, bkt, hpe, hairpin_hlist) {
-		if (hpe->peer_vhca_id =3D=3D peer_vhca_id)
+	hash_for_each(priv->fs.tc.hairpin_tbl, bkt, hpe, hairpin_hlist)
+		if (refcount_inc_not_zero(&hpe->refcnt))
+			list_add(&hpe->dead_peer_wait_list, &init_wait_list);
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+
+	list_for_each_entry_safe(hpe, tmp, &init_wait_list, dead_peer_wait_list) =
{
+		wait_for_completion(&hpe->res_ready);
+		if (!IS_ERR_OR_NULL(hpe->hp) && hpe->peer_vhca_id =3D=3D peer_vhca_id)
 			hpe->hp->pair->peer_gone =3D true;
+
+		mlx5e_hairpin_put(priv, hpe);
 	}
-	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
 }
=20
 static int mlx5e_tc_netdev_event(struct notifier_block *this,
--=20
2.21.0

