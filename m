Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605A18858E
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfHIWF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:05:27 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:18565
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbfHIWF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:05:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUhs+BhGv3UDINHJFqk7IHJ1y1OOHT4qmq497wCM5nx5Ud0s7k2vFO968nG+GYPigvsoNbk5B4iMJ7Ey02xeU5X55SoTlspRcp9Q7Qbuvuh1YaCB436s+vqTGCRfwr1RDKJlAermKBJiOZGneuHgBHtQhrj3BFqsQjiUglTlORXZlnAiNWiqkTLokSZCBg+YqxmoEZ0tT88h+5ZJ/lyQq8+9XIm9DW853pmRG2+9aSITl4j4bhV5GFUqFiM5yXaULK1npkl0YJSWI/0B6oXO3uqC41AsG4hYmhO25Ye6rHrPPqUaPPquAk5bm73p+oaiLv+Q9rCvNWIQPw+D2zjugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5rMqL4XWAVg0qbV91D7eB4KdDg5qbohzt5ekvoJO3s=;
 b=eGrdrXXtblY+xGCX+PxSMag2HX9e1vMwKatcorhASpbrf6RKgaZu0VHA5gmLttV28Ono2wq0fWFtHG9kNAeoBamqPVds8hM9+YzHtW6m2jFFD7z5tsnw54S0Ik/i9PRI8a+9sgagHZoOV3/SE5w2vXxWdQ15xZS4gupnmuDfhWGmKuln3Smma5Nm1Tch26S9vLESRWOH0AKT3h79gENTnCiQuhrAChWNyH2Klkw+kttjO+ZYIAsU5GE8bmKsfVUHJpiqyuPcraSlyRlQCpceEBKY+e+QWp9EozAZO/U5kIXfjjP5+K4l7HxotC1OudoxTDrsDzXoGysj6I1vgwTc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5rMqL4XWAVg0qbV91D7eB4KdDg5qbohzt5ekvoJO3s=;
 b=VG4VP/2FxPlUEU4SMrkl3V1RpWTZ/CFXYo+ONOh5ONuw+NqqBrkn3t8vyu1QqkVa1u5BLlGsgYC66BPCk+SNmR7BPaANkcUPBEVVzRFRmuUFq0PMpaoilU662b1Cg/hK95FA3OA76psz8I1GL/zviBLzQ7EGif4ZTueCQJwlyR8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: Allow concurrent creation of encap
 entries
Thread-Topic: [net-next 11/15] net/mlx5e: Allow concurrent creation of encap
 entries
Thread-Index: AQHVTv5v/y3P2ZgzbE28ueNTIINctg==
Date:   Fri, 9 Aug 2019 22:04:37 +0000
Message-ID: <20190809220359.11516-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 34abc179-2219-460b-5a10-08d71d1591cb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB28564BC5B386899196DB4D52BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sKmgoY82jKWfMI2agFOMCOlYIXBCtrMTjP+x+Fc/DB2tiu6w0YtJBuNj1O8+hK1olTiLjuwQEWGAsUABBQgPsQGt+gj2IZVjKfwOCD3g66n8miEQXTIWyNOAPBgKG7qkNuoxh+aQhZRjw+7MSDICP2MNBnADERdjMzyFLWal2Y4Mx5oZcKMz+kuUF7TAxPgLVoyXcMW+cCRTbgaaTzdD2YNLCgAP9pCoOwJfKYea+3qt79UXtXnM8cB3jX2NcLR8buCHKAVpfGk70CFhrCZGaavYxe7Ct0bU4ZuUZsfwCXy5Bv5U2fRF8lUglOtUWSJEnWXoJT6ajsvFW/yS0Nh8MeTI5x7qCCUTeXhhdhZ3p4YHRg3IId83l+wgmKUrgVj1SHX5YUYJq7eSH7Ayhv1vBAvBjnM6ygS6SXfjHukDr94=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34abc179-2219-460b-5a10-08d71d1591cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:37.7284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3haW39x7FiwSd5vj9r7oTCe2LH0NIi7q2ggyvFftVRB/wr6dwl3ucIzqjWChKtBOq+ObkG36R4MeZXM79kLbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Encap entries creation is fully synchronized by encap_tbl_lock. In order to
allow concurrent allocation of hardware resources used to offload
encapsulation, extend mlx5e_encap_entry with 'res_ready' completion. Move
call to mlx5e_tc_tun_create_header_ipv{4|6}() out of encap_tbl_lock
critical section. Modify code that attaches new flows to existing encap to
wait for 'res_ready' completion before using the entry. Insert encap entry
to table before provisioning it to hardware and modify all users of the
encap table to verify that encap was fully initialized by checking
completion result for non-zero value (and to wait for 'res_ready'
completion, if necessary).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 33 +++++++++++++++----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 2e970d0729be..8ac96727cad8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -165,6 +165,8 @@ struct mlx5e_encap_entry {
 	char *encap_header;
 	int encap_size;
 	refcount_t refcnt;
+	struct completion res_ready;
+	int compl_result;
 };
=20
 struct mlx5e_rep_sq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index c13db9bc1f9b..5be3da621499 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2904,8 +2904,18 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pri=
v,
 	e =3D mlx5e_encap_get(priv, &key, hash_key);
=20
 	/* must verify if encap is valid or not */
-	if (e)
+	if (e) {
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		wait_for_completion(&e->res_ready);
+
+		/* Protect against concurrent neigh update. */
+		mutex_lock(&esw->offloads.encap_tbl_lock);
+		if (e->compl_result) {
+			err =3D -EREMOTEIO;
+			goto out_err;
+		}
 		goto attach_flow;
+	}
=20
 	e =3D kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e) {
@@ -2914,22 +2924,32 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pr=
iv,
 	}
=20
 	refcount_set(&e->refcnt, 1);
+	init_completion(&e->res_ready);
+
 	e->tun_info =3D tun_info;
 	err =3D mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
-	if (err)
+	if (err) {
+		kfree(e);
+		e =3D NULL;
 		goto out_err;
+	}
=20
 	INIT_LIST_HEAD(&e->flows);
+	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
=20
 	if (family =3D=3D AF_INET)
 		err =3D mlx5e_tc_tun_create_header_ipv4(priv, mirred_dev, e);
 	else if (family =3D=3D AF_INET6)
 		err =3D mlx5e_tc_tun_create_header_ipv6(priv, mirred_dev, e);
=20
-	if (err)
+	/* Protect against concurrent neigh update. */
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	complete_all(&e->res_ready);
+	if (err) {
+		e->compl_result =3D err;
 		goto out_err;
-
-	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
+	}
=20
 attach_flow:
 	flow->encaps[out_index].e =3D e;
@@ -2949,7 +2969,8 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
=20
 out_err:
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
-	kfree(e);
+	if (e)
+		mlx5e_encap_put(priv, e);
 	return err;
 }
=20
--=20
2.21.0

