Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2CC79D10
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfG2Xuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:50 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbfG2Xur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjKgkL/L6pHYXCb/cbg//9QW/tTZZblqmSdHv1suo05lLQJGrO61wSEM/oHGoxNRSzvKEfD8pVQv8CGn39QJh9rJiQdPYSysZhHg6kY1WWclVca962UZZEUl6K5LTw6iJWNYRjQ68cqx9fK/1/XyHc4zKkNq/zRxHSfMwdX3Pqj2BULTRxQ7PKuwc4BT2/m4CNTpGI8tU4YTZGt42wD9bMRNcmA1hSBvTQXreaiLdfXKfvBm6p6MjuVEPdpU+0XBy7MQOXmnYG5lZf7hmLNlzFlALRrBENBiyXI5YCTDE6SCXSv7O1uEKWXpstU4jXM6c9EApzqfndyZb9X5/LTQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQCggV43mVqGpUNekoMIDFJEYGChaHuco0nJIbnyoY8=;
 b=Egkz7b+4pAp8LiCJB9rnCcNit9LzzBYkJMnC8KafY5/mkGbiSO93NH3rCWSKRvGFoJpew5dNoRu8rbj996LRi5zbKTsyFDP0cn5PaN0rk9GZQgOVE6id0Es+/FXg0Mp45dl3uNJrq8DMwJTI+wsRUbt8m1pevsGqa7/l2CMqaS8ybZjtbp+R8c8+J0Q53Vp+rkU+Ugxl0Jm4BNoeJsEggRddhYc72PwGV6oedosUmie0Av8RKS2Vjz2QoQEIJ4kTDLC6D6BfNGJiHsV28j18n/ybep8kyVOQhIhFqGf7yRwVbJf4dnYKe2eRLj0tPb4pNQ3cWKqEUImU5Q3EnAfYvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQCggV43mVqGpUNekoMIDFJEYGChaHuco0nJIbnyoY8=;
 b=lf/5lnUHZNNBnWVuBdx19JHO+ncmy6WqEh/SciXdeSYMIb5YFgUq4C5NofywY0l4H9xbVBbKEdyDGCUjCwZyHFi/OGcZR+y7ICZYOmQsuUj+nrCClI+B/1HT+vfDhhV+dRoN4Bp1eG3aCqD+tMqNCkQPmTeR5eCzNddNAZQ2rgY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/13] net/mlx5e: Protect unready flows with dedicated lock
Thread-Topic: [net-next 09/13] net/mlx5e: Protect unready flows with dedicated
 lock
Thread-Index: AQHVRmhnXG0CS2JHOEGxyx88Gl8Y6w==
Date:   Mon, 29 Jul 2019 23:50:29 +0000
Message-ID: <20190729234934.23595-10-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4eac8a9-5f73-4f6e-da92-08d7147f895c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB23439B82ED519C7901555AC0BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RtVN86dEXPzEWNBE4e2yzlNBTsOvLBy+AxbXHdCGkPN9eb9wpNWn2bNQ6Auzi85TqbMFouRqaPW8tC++s42iMYvkaXQJnjKZA1UDp/XuJ82+xtInWywa9DJFLkTRpwXJVyZNNdjQbrETiyE+3JqcSwWXLbhHkRaCCTUqseqzC4EhB74+xIauxBd9RxixffB3Is9F/QWAA1bxvKZh5q0u/2MH3vFhGDwf2PBPduzYG8oRFuQFlgL6+Akse50IarWPRyCXWIpMx7m4VISb9LSFeBdOqqN8Ts1G//44QNbdJmUn4bo0sNhRvcLnluqHs1Tc9Ki5PI/ago4OfJH6JLzsXhgNY34DBtFx5N1Jxww05SU9uvtRs1zZ42DJmfVK8TMDYdIF1hmQjkrnsyykR8b0SoTaeASehBS8xjZtG3OCRjs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4eac8a9-5f73-4f6e-da92-08d7147f895c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:29.7698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to remove dependency on rtnl lock for protecting unready_flows
list when reoffloading unready flows on workqueue, extend representor
uplink private structure with dedicated 'unready_flows_lock' mutex. Take
the lock in all users of unready_flows list before accessing it. Implement
helper functions to add and delete unready flow.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 ++++++++++++++++---
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 69f7ac8fc9be..6edf0aeb1e26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1560,6 +1560,7 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 	if (rpriv->rep->vport =3D=3D MLX5_VPORT_UPLINK) {
 		uplink_priv =3D &rpriv->uplink_priv;
=20
+		mutex_init(&uplink_priv->unready_flows_lock);
 		INIT_LIST_HEAD(&uplink_priv->unready_flows);
=20
 		/* init shared tc flow table */
@@ -1604,6 +1605,7 @@ static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *p=
riv)
=20
 		/* delete shared tc flow table */
 		mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
+		mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
 	}
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index c56e6ee4350c..10fafd5fa17b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -75,6 +75,8 @@ struct mlx5_rep_uplink_priv {
=20
 	struct mlx5_tun_entropy tun_entropy;
=20
+	/* protects unready_flows */
+	struct mutex                unready_flows_lock;
 	struct list_head            unready_flows;
 	struct work_struct          reoffload_flows_work;
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index a39f8a07de0a..714aa9d7180b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -996,6 +996,25 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch =
*esw,
 	flow_flag_clear(flow, SLOW);
 }
=20
+/* Caller must obtain uplink_priv->unready_flows_lock mutex before calling=
 this
+ * function.
+ */
+static void unready_flow_add(struct mlx5e_tc_flow *flow,
+			     struct list_head *unready_flows)
+{
+	flow_flag_set(flow, NOT_READY);
+	list_add_tail(&flow->unready, unready_flows);
+}
+
+/* Caller must obtain uplink_priv->unready_flows_lock mutex before calling=
 this
+ * function.
+ */
+static void unready_flow_del(struct mlx5e_tc_flow *flow)
+{
+	list_del(&flow->unready);
+	flow_flag_clear(flow, NOT_READY);
+}
+
 static void add_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
@@ -1006,14 +1025,24 @@ static void add_unready_flow(struct mlx5e_tc_flow *=
flow)
 	rpriv =3D mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 	uplink_priv =3D &rpriv->uplink_priv;
=20
-	flow_flag_set(flow, NOT_READY);
-	list_add_tail(&flow->unready, &uplink_priv->unready_flows);
+	mutex_lock(&uplink_priv->unready_flows_lock);
+	unready_flow_add(flow, &uplink_priv->unready_flows);
+	mutex_unlock(&uplink_priv->unready_flows_lock);
 }
=20
 static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 {
-	list_del(&flow->unready);
-	flow_flag_clear(flow, NOT_READY);
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+
+	esw =3D flow->priv->mdev->priv.eswitch;
+	rpriv =3D mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv =3D &rpriv->uplink_priv;
+
+	mutex_lock(&uplink_priv->unready_flows_lock);
+	unready_flow_del(flow);
+	mutex_unlock(&uplink_priv->unready_flows_lock);
 }
=20
 static int
@@ -3723,10 +3752,10 @@ void mlx5e_tc_reoffload_flows_work(struct work_stru=
ct *work)
 			     reoffload_flows_work);
 	struct mlx5e_tc_flow *flow, *tmp;
=20
-	rtnl_lock();
+	mutex_lock(&rpriv->unready_flows_lock);
 	list_for_each_entry_safe(flow, tmp, &rpriv->unready_flows, unready) {
 		if (!mlx5e_tc_add_fdb_flow(flow->priv, flow, NULL))
-			remove_unready_flow(flow);
+			unready_flow_del(flow);
 	}
-	rtnl_unlock();
+	mutex_unlock(&rpriv->unready_flows_lock);
 }
--=20
2.21.0

