Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9002FDCF5F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443322AbfJRTia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:30 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443157AbfJRTi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6HO6mRia0DmL63EZsYJSmhyVnZcvSgc3nJiCL96cb8ZJuFmycG7ZN5UNOHgRcI3O8Noxv5gHEC2azC7d+mRhtJUu2ITMzeuBqqQ8qKb7z5z1NYZjoVL3K8THK1JalSsTSvNkScARPxRuw5pIpE/i9E7meu649gh0YWNzwPz/2DHk8B/aCPJh9e1pxiz4DEmhAM9a0s//yKACfN3jbmNrqRTb2nHATvHQ+yaIxbM3LygGiYjid5hy9vaD9h30RwsPDFCahybnXuBIJIOiGTrGG6nSO520PtzifikY8IfcRzt+fiDqPR2nhieHVnkcEudKIAWZGztQVMpWjIx8psKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXuAYGRWN+TFCH9VsFUCBXzWahTmRVwjQE7IwM9/DrA=;
 b=YbI3X3oOgELREfEDGrStFS7nluvKwrp5iMjx7mRTk8ctYTfHMALZDY9P5zUKwiZdfrMyb9kAwypKO3Pikfgdpel1DC4zrmDneTrtO+3f/lKooksHfU6sjNOri6675+xrvP/jj3X9nnnCQEM/oRr/W76C0D5XfyEXnG5gjeRkHtIGh/2d6lOdlRAe7bV8zsOPdLIIUUEpUKUX6txRDaHnBi6u2rk991Bylt4BjQrgVT3v6KGoN2nkEbzIwjQOM6zwEXZEdV4oC8lDuOdpGwwdEDmhoafnXC71kYlQkH4tkkQx6JnDydouaxFcJ5bO5vgxG1Z422BlZiGoAIOiRg+SwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXuAYGRWN+TFCH9VsFUCBXzWahTmRVwjQE7IwM9/DrA=;
 b=Rc9MEpWyDUwiw/qiFLyXa5haxIk4PMRayjVwItOlN/ti8D6aEd8n2QEY/NOBevLiZZPjc5SufeHEzO/AE+epbzmkAD7cVvneqyIv8Zn7wx5y56SYodglYocyMoHcxKQXXGY8DRO4kQxqaNcZZtBFLRzzmZ21FRz7LA3ZmyUecxE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/15] net/mlx5e: kTLS, Fix page refcnt leak in TX resync error
 flow
Thread-Topic: [net 07/15] net/mlx5e: kTLS, Fix page refcnt leak in TX resync
 error flow
Thread-Index: AQHVheuVwMdwhXRqhEeTmcx9NXDSfw==
Date:   Fri, 18 Oct 2019 19:38:14 +0000
Message-ID: <20191018193737.13959-8-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 886c084f-3690-4e41-d366-08d75402b7d7
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB039222DC7751CFEB1CA2B2ACBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BNvmBqeSuEgMiqOgviKXgQD9m3oBsZQF93eEbUj4Bo1nV6EWx1Z3OiqpJIcIu5c6QMVoILrTqvrCuISeGJTOo4qiLl2PvEAbmiyk4HQ0oEPzHISkq1fJPahj2+Rwro+hfwmP2kLWaiPwmb9FwswUDtK8d4O1oAA3PAOnjiQkLgz4o+nWFvcIRpBuQqGSaJhZu8A35xR7gtATxAU1hav7H18oWcUXrWsfLiiM5Wx1D6OE6QpcppXAmV1c2rKpdhqn6iaxpHbhhQsfHBwCxWcwIdutZ0z2oTHg7zeyKYorOSTbA382XrVTqjY/0CNm6EGpqBhxz3k72770Y2SQqZtgc1kQ9X8JXSdajyEF+fBlvTokxVN+FB62Akkdfez/6UsX80/QVb5vTNdZmo2cAsEu1ISfMk2QJdx1qveLPIlG4Iu8CF6qzCcq7DIG4pjMLoc6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886c084f-3690-4e41-d366-08d75402b7d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:14.9365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Kv8i5AQb3Ui3tU8NjA++ViFYQfbYPsocb8VOUU/ugkPLnwVBEBGDn6caXWX9yKnYgmH6zh4x1UB56U0Ns5H+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

All references for frag pages that are obtained in tx_sync_info_get()
should be released.
Release usually occurs in the corresponding CQE of the WQE.
In error flows, not all fragments have a WQE posted for them, hence
no matching CQE will be generated.
For these pages, release the reference in the error flow.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 334808b1863b..5f1d18fb644e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -329,7 +329,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	struct tx_sync_info info =3D {};
 	u16 contig_wqebbs_room, pi;
 	u8 num_wqebbs;
-	int i;
+	int i =3D 0;
=20
 	if (!tx_sync_info_get(priv_tx, seq, &info)) {
 		/* We might get here if a retransmission reaches the driver
@@ -364,7 +364,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
=20
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
=20
-	for (i =3D 0; i < info.nr_frags; i++)
+	for (; i < info.nr_frags; i++)
 		if (tx_post_resync_dump(sq, &info.frags[i], priv_tx->tisn, !i))
 			goto err_out;
=20
@@ -377,6 +377,9 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	return skb;
=20
 err_out:
+	for (; i < info.nr_frags; i++)
+		put_page(skb_frag_page(&info.frags[i]));
+
 	dev_kfree_skb_any(skb);
 	return NULL;
 }
--=20
2.21.0

