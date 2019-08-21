Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643DE987D4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfHUX2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:40 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpuNPE/M5jK+v/TuyxclvvX0N55/E6uy/EGaNJLE+/BkxheLcc6e2ByES6Ti3fkW89Sir8lKNdwlPpFVVOc6ei/INWgQcBx5fjq6ehSP0FwgsqhZYDdGXT5+4wzw7EZT58o+GvTPhMrCAdmxEu9ZPQrbBSkfZKLpnLhXC/rzVq9kEX3hDUXYj430f27K7DD6RzlL+T9ylzr9kTGVMROUIIYv3mc0+Td1FVyIwRrDCG62A2VrnyGJxOwML6JWmIz60a1wexJFK7gmIHkcCP0C0ij7xFNYDnTluCgQX8trMOII/8Ja78/SWnRpghYYlfMv1cYWys/fNkhZvGprs0Jexw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0buRyVhHmKrLXTGP+a+OlovYbANfyderOsO0S9wWcE=;
 b=QrnG4yYNDBj2cv/HGrwvUtgDD26VwOd61eRLgKiXBvBBjl2HMViONs3hwJy5NvB71jGL8dFTrqxoq3VuSZxnAvqny4V/gEphTCXk4mbwwHWZ/ixmfUquUCVg/rThnSKSCIrOx6/Tq4JsDJMvVN8g/hlxYuYZJAXoTcm0lz6tSC9WPgDQF/ucSbpwjlhrLbRJ9j7bRUNZaMLV+xK2WpxPtjb6xkJM17pVq2r/pvE+McwiyC+C2lhJSWGksnZORl1j1d3+dgCsv0jsEGJfzAFCwX2am/rGCmqVoQzkdl7LeGpNYXKNkBwZTDHp/hlKhaUBHhCrdPEBCNjJDifVn4t4GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0buRyVhHmKrLXTGP+a+OlovYbANfyderOsO0S9wWcE=;
 b=GLAxPqIH4TEUmYn7Vxq/MKnLI/MTKPJQoOec7Ra4u/uk7XOMIYmtK0BBIapR7HWw2BHG2oAKdbQDssHkbw99Brw45ua22FLmICdMhi0dsXnVgERCsMunFP6EB+SS3YPHua7Fdkwtoy+rhbWIOyMxcEq5NGElwaC5vkhv1kan8Uo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:34 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/11] net/mlx5e: Extract code that queues neigh update
 work into function
Thread-Topic: [net-next 01/11] net/mlx5e: Extract code that queues neigh
 update work into function
Thread-Index: AQHVWHgmePLLGQWaa0iLFFRMGzKvOw==
Date:   Wed, 21 Aug 2019 23:28:34 +0000
Message-ID: <20190821232806.21847-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 27636148-6386-4e1c-a33f-08d7268f48c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26742F584E6112E884100E13BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ap7ZVpax1qGZCvSefuVtaLQSCdRv85+rI0jBNBcKhbYKA8GV50vgYGOvKkFA1Ogd9ERuT1c6SU/2g4Gwwuu/BX2cyk8JzwMSRKXj/kjGqyIulbsmxbhBPPhzfvPt9v6pekhiya66ksc2wnGdmCULkZPHki1wVz+GlqNrl0BWnEBpgMtkPoCvH5XtPxqlu1+J2pbd+IKdmBY5gvGyiAH0I0X5yarKAG9OrMKu44CzWp7+2jHpdKfis3QJZve47r2h73gy/Ovtxni9S9MKmNwuPEUtoxn+tosJRoWZc1Yh/Ps/rpeQTMD0fgp9nWjKmBCEhMu7jRrbrVaA1OdpYePZMPpxqGDS9teZNsGdkNp5Ce6pv2PctC03wSql1K/zTESh82OuasMygCwop9RpNUgHg11i9+G7JMycQhos3lR4IK4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27636148-6386-4e1c-a33f-08d7268f48c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:34.2954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c15lAeaUMOGkUZsrAMRonqAPLgGdxOxDtDzWgglUZWOt0XIo+V3MiH5BAIPxBH8ZRT6N2mGdM09/EH8aF6RgrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

As a preparation for following refactoring that removes rtnl lock
dependency from neigh hash entry handlers, extract code that enqueues neigh
update work into standalone function. This commit doesn't change
functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 38 +++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 7ce5cb6e527e..85a503f0423b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -821,6 +821,28 @@ static int mlx5e_nic_rep_netdevice_event(struct notifi=
er_block *nb,
 	return NOTIFY_OK;
 }
=20
+static void
+mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
+				  struct mlx5e_neigh_hash_entry *nhe,
+				  struct neighbour *n)
+{
+	/* Take a reference to ensure the neighbour and mlx5 encap
+	 * entry won't be destructed until we drop the reference in
+	 * delayed work.
+	 */
+	neigh_hold(n);
+
+	/* This assignment is valid as long as the the neigh reference
+	 * is taken
+	 */
+	nhe->n =3D n;
+
+	if (!queue_work(priv->wq, &nhe->neigh_update_work)) {
+		mlx5e_rep_neigh_entry_release(nhe);
+		neigh_release(n);
+	}
+}
+
 static struct mlx5e_neigh_hash_entry *
 mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
 			     struct mlx5e_neigh *m_neigh);
@@ -864,22 +886,8 @@ static int mlx5e_rep_netevent_event(struct notifier_bl=
ock *nb,
 			return NOTIFY_DONE;
 		}
=20
-		/* This assignment is valid as long as the the neigh reference
-		 * is taken
-		 */
-		nhe->n =3D n;
-
-		/* Take a reference to ensure the neighbour and mlx5 encap
-		 * entry won't be destructed until we drop the reference in
-		 * delayed work.
-		 */
-		neigh_hold(n);
 		mlx5e_rep_neigh_entry_hold(nhe);
-
-		if (!queue_work(priv->wq, &nhe->neigh_update_work)) {
-			mlx5e_rep_neigh_entry_release(nhe);
-			neigh_release(n);
-		}
+		mlx5e_rep_queue_neigh_update_work(priv, nhe, n);
 		spin_unlock_bh(&neigh_update->encap_lock);
 		break;
=20
--=20
2.21.0

