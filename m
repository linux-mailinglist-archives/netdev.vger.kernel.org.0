Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14D8857F
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfHIWEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:45 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfHIWEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBLYzKzdXiUp51YO7pxpOOf3itfxFaN6/Iim878QV/puKrwmIkriFD9wRS8dD50NfznCS6FREH0SEDV4vTv3geOagtAMXTOXdiQmfbEOLFgiiFaeyA9yaaWlgkrgJlGuYBSp5pfnoB1STT9ygYNf6KiXLcJsMJg0tY/sbboeLZNd/zNROXIGc04INUzjbE/cg7WnydnwaNIs4l68PmiqARmxp2nSX5xbz/SjQGZturIinbSQWopzL8HovE3e8oiEigPOgXKGcUXqyWjH0VObioNvLJ3+W3SKPxF+EvcJ5duqIHAPnn1c8JOL37iJE/RlhwGB2ibe8biHFV1pKvOIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8CWHJsYbSKDETUvKypMtsSBD5VBxna60cerSf+8vfU=;
 b=GkhHlf9lb+wLnEKYJyru6L4QUIrpOMkAZDRRuM9tnUiBWzhOgvEB/9fl1u9gGb0HBbELhO0GxNnBV3C9rfBLVcfF3fRTnvL2GM1KlkSUeyEgKazeFpHIqEUsMt+MfNzj5VXYtAuzFgDl3IX3VVO7XTgziUtAvAYbovou4iCXJsBg1bXQJbMgF/1GDd0fZOTdMNSMtpYLuigWH5Y5cWuSU33w8ihdJA5XDFEpUUXM5w5dsrgG7Pi6osIdWc9pSQMYfInKdgAhw9zgXktsxsfU4jsYPNLeiOIeNieBjhtKab1DUeNruIK7ZhuQLhnSAEsreu+HIh8zTut2ySzyqUVOng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8CWHJsYbSKDETUvKypMtsSBD5VBxna60cerSf+8vfU=;
 b=MQ0dIqfg/9gDaUQpB685GPe48czg3RqlAjpFGnhJSls4PCTH83L5mwv6h+/0LVj6MMKWHto96cQnuwUNLn1JqvtSRDujdIfGNVd5su5jvx99x/O1EUGOFzccBTe6EbFgPiMwW1opRs2yOMCR6bWCCcbpZm55UDOyLo1SYd/9ADg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] net/mlx5e: Protect mod header entry flows list with
 spinlock
Thread-Topic: [net-next 06/15] net/mlx5e: Protect mod header entry flows list
 with spinlock
Thread-Index: AQHVTv5qVLZJOC3idEmAJZ/E2ElQOQ==
Date:   Fri, 9 Aug 2019 22:04:29 +0000
Message-ID: <20190809220359.11516-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 9fc44346-ece9-43ad-8021-08d71d158cbf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB285639AA0DD02F0CE18A478FBED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IBZ9rzM6c6Oc7E3zzkKYL3Hf4x3/dd7REJp3+m2EPMaBSaocY91IQxJ8IP7Z5rKGgBH2k5lGXdA7RqUoHSNussUXDduNmBt5ZtuO8mT4j962aM9jDXFLj6j50FJEyEKeWi6hkBd65ncr+hzMBV2jE3J6nQ6HjtHo59wQMfPcxTLmceM8MFdGsq2ayTwjZjDGasfrzZJUDd183+kDOauVzdydUChF4p8ifwYazX3vZoPg4/OO40i48m8m8tuMlDPfduG9r/DmGCkS6Hf+Orw0Ri0LgEaU0/5LYqq4QfW2Qm86KNpdEP4+fnmrgV4Ou7HgqyPY5+Zwy1w0JihUhpCWikxfXuxrAT16wNJRv9VIgEiO5T8jqpB8mRTf9wMGwpHvVyB3iSzAwPmV39pKoCmhpkFYZVfOzPV9VpsJ/VgCFxM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc44346-ece9-43ad-8021-08d71d158cbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:29.1672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KJlOYCD0acDtKDyIMLEzp/gjP1p/Vmk1OA+218Lo6Y+cVpmLzB8jHt2OshwB1pdAnr18ZRHep8ZIk6uTq3/ouw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, extend mod header entry with spinlock
and use it to protect list of flows attached to mod header entry from
concurrent modifications.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index fe1b04aa910a..09d5cc700297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -189,6 +189,8 @@ struct mlx5e_mod_hdr_entry {
 	/* a node of a hash table which keeps all the mod_hdr entries */
 	struct hlist_node mod_hdr_hlist;
=20
+	/* protects flows list */
+	spinlock_t flows_lock;
 	/* flows sharing the same mod_hdr entry */
 	struct list_head flows;
=20
@@ -358,6 +360,7 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
 	mh->key.actions =3D (void *)mh + sizeof(*mh);
 	memcpy(mh->key.actions, key.actions, actions_size);
 	mh->key.num_actions =3D num_actions;
+	spin_lock_init(&mh->flows_lock);
 	INIT_LIST_HEAD(&mh->flows);
 	refcount_set(&mh->refcnt, 1);
=20
@@ -372,7 +375,9 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
=20
 attach_flow:
 	flow->mh =3D mh;
+	spin_lock(&mh->flows_lock);
 	list_add(&flow->mod_hdr, &mh->flows);
+	spin_unlock(&mh->flows_lock);
 	if (is_eswitch_flow)
 		flow->esw_attr->mod_hdr_id =3D mh->mod_hdr_id;
 	else
@@ -392,7 +397,9 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *pri=
v,
 	if (!flow->mh)
 		return;
=20
+	spin_lock(&flow->mh->flows_lock);
 	list_del(&flow->mod_hdr);
+	spin_unlock(&flow->mh->flows_lock);
=20
 	mlx5e_mod_hdr_put(priv, flow->mh);
 	flow->mh =3D NULL;
--=20
2.21.0

