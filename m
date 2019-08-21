Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BBE987DB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbfHUX26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:58 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730432AbfHUX25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXBxsjYfgcO1hK1h5g5cn4woO5Sj2MH8O7Enfy27xY0ORq9seRh0ERYVOO/ehXpzsRFYOiE4FR+BNKWsVzLsGCOJwZAytB6hUtR/CG478Ud7MMl46DkDkC9Ma9ecCupsC4MJe4jlm4TRENWoudpFLU+Ct3mDXr3E5ePMW9wyRGyKvDq5i7wnQ2NiZ5gPS7sDi/VeABCKLa8mqLavEB6jlk4/dMqb3sUa9Tai99ouNPq5wE7LwmPz2c/FqoK1maukjtL+5/KR6T+ABXfTWM6f5cGkEH+j5bGuQzWXskfwsaq/YgmTtAAr7Lb6RRMnRnibi8oaaDZaprvnASViaSNrgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BT//zNJmpefljLUXIM+zKsFb8Y98/ZZb8IML9sTAPEM=;
 b=K36sPjntB3lrx3LXNdBv6jWlA3BeKcWQHZePJJirDuMiG65tR5Bz97i0FW0d62xA4BDP9e79r/I+EiZXynkg3uw8iqKr6nSMrmPIbrWuBcdDgTHeDRNmXTsmCdhFQfPoCfKj3ESEfyYdJcGkxtYktA7e2VfZU5Ql1R9W7RPaI6a8ZOhOj/gpEn1B5DhmLWcVSTvFsMjC7t574DS6h7J/ID1tKJXMUGhezp3RswhFEU/UFket96gV1vbk0puKe04uRAq2h36farXGoPgAEX8ctluNUwE1opJCoY1RL58lrGUvcPLAZM9W4pIkxUwNZCHh6k6YOm7Mx+uOsgu/R5zL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BT//zNJmpefljLUXIM+zKsFb8Y98/ZZb8IML9sTAPEM=;
 b=MZE/RpNYsXvuxHtCyUfzCdQhaJjlK5Uck4IoyB8KSEJD5n6OLp4PaJQzIzxlJLPnvR9ILjpYLb/bKtyysfRb9bYbgsxt/lUsodzS6DjcfTdE4HVg3XLSr0kGrt+YZnfPZhOjSMVKmFgAdxGMrJTFC65jnTL3eWPUURkLWCFQWm0=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:48 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/11] net/mlx5e: Only access fully initialized flows in
 neigh update
Thread-Topic: [net-next 08/11] net/mlx5e: Only access fully initialized flows
 in neigh update
Thread-Index: AQHVWHguFpqVs+HqRE+pLYNXu+RmtA==
Date:   Wed, 21 Aug 2019 23:28:48 +0000
Message-ID: <20190821232806.21847-9-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b189fa28-ffeb-42bb-0804-08d7268f5111
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB267408E6C421C93F4DA269C0BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 10TGPSRGECo0gxrBgC6JaAq8VsgX4Vb9DLKZrjPTWLboOneWk7k8vgeabUuMmZ9ojOttMl6MQFihSBd7SBqL3kkU4nDSM9MMlKi1d5nb6uG3QQQ/Cax0goWiY03AX3c/qE70IkQxbMZbusK02F5WqAM/WACAZqjTgTK5GBEpb7AdA//btJzZ4vxlCIzOjb9F2cgM3xVy9zVOAdNXFnYX37MbMPImpJPGan5qo94ngiavzyIjdAmdJsX5w7SzER/1BsxB0sqtFq0Vdsbsg67QuYh/HNRdPb9RGfjiLBRsA8c+GOfovt9GEinROSiasYff8UCVV5hpkxAsjrGx2/GqtJ2ovQqg0QyXEytymeqTIOHljOtLKWkqlE2Pyq1QwJh95xJp14p079YUbAi3Cnm7Q0maYVKI62VYEOgpZFBToow=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b189fa28-ffeb-42bb-0804-08d7268f5111
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:48.1612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Imy/XwhaAndiuxjrmO5ZLBsRaptJaGu3mkPwHHN2j9zQxut2t4z0OJWmwyzBPMXE6QfwBjV99FUf5Umfktnqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock and prevent neigh update code from
accessing uninitialized flows when executing concurrently with tc, extend
mlx5e_tc_flow with 'init_done' completion. Modify helper
mlx5e_take_all_encap_flows() to wait for flow completion after obtaining
reference to it. Modify mlx5e_tc_encap_flows_del() and
mlx5e_tc_encap_flows_add() to skip flows that don't have OFFLOADED flag
set, which can happen if concurrent flow initialization failed.

This commit finishes neigh update refactoring for concurrent execution
started in previous change in this series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index b63bae05955b..5d4ce3d58832 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -130,6 +130,7 @@ struct mlx5e_tc_flow {
 	struct list_head	tmp_list; /* temporary flow list used by neigh update */
 	refcount_t		refcnt;
 	struct rcu_head		rcu_head;
+	struct completion	init_done;
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
@@ -1319,6 +1320,8 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv=
,
 		bool all_flow_encaps_valid =3D true;
 		int i;
=20
+		if (!mlx5e_is_offloaded_flow(flow))
+			continue;
 		esw_attr =3D flow->esw_attr;
 		spec =3D &esw_attr->parse_attr->spec;
=20
@@ -1367,6 +1370,8 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv=
,
 	int err;
=20
 	list_for_each_entry(flow, flow_list, tmp_list) {
+		if (!mlx5e_is_offloaded_flow(flow))
+			continue;
 		spec =3D &flow->esw_attr->parse_attr->spec;
=20
 		/* update from encap rule to slow path rule */
@@ -1412,6 +1417,7 @@ void mlx5e_take_all_encap_flows(struct mlx5e_encap_en=
try *e, struct list_head *f
 		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
 		if (IS_ERR(mlx5e_flow_get(flow)))
 			continue;
+		wait_for_completion(&flow->init_done);
=20
 		flow->tmp_efi_index =3D efi->index;
 		list_add(&flow->tmp_list, flow_list);
@@ -3492,6 +3498,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_si=
ze,
 	INIT_LIST_HEAD(&flow->mod_hdr);
 	INIT_LIST_HEAD(&flow->hairpin);
 	refcount_set(&flow->refcnt, 1);
+	init_completion(&flow->init_done);
=20
 	*__flow =3D flow;
 	*__parse_attr =3D parse_attr;
@@ -3564,6 +3571,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto err_free;
=20
 	err =3D mlx5e_tc_add_fdb_flow(priv, flow, extack);
+	complete_all(&flow->init_done);
 	if (err) {
 		if (!(err =3D=3D -ENETUNREACH && mlx5_lag_is_multipath(in_mdev)))
 			goto err_free;
--=20
2.21.0

