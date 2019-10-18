Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9BDCF5E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443317AbfJRTi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:28 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443309AbfJRTi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKXUz7XmyHUW3NlgIELvJTQ2bCp9ig+dg467T36OGtMsQ1fOk8OzSYUY9ux0Ge64q0EKfx5A8IVmjGqdV8kw4v7Q2FMXIB8L7v0O7RxJElebdbO/G21VE76V+aAYfcsEhSefneMfGnUwlP+A2EYzeMyKHz1zmBuzxi9moxlyt+Q+LKi5w39XDncBekI2aqAcRq7vga3fG2is+qysmh7QitjSx0+yHRVMxarIW+2QDJPIs49wPK1yy0jt7h8u3Ne0WBu1lyAEV/XkxCG1zdbGVfhjnn6QLsIo8khdQ/gyBkM6KbhYpEvA48+/5RiMnn5hAxugtCmQszXWztSfjaOFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA5M91uZTGUIeAmRfqi0oJ4TH0gSSN4buaJNTD+1jEI=;
 b=LTeKk/CUPoPouZUrTttexD8afc8M2u6wg6XQ+u1O+VpUNedpqmqbPk86PobSZVQaTc/7Z5549rh5B7i0Qs4B0FuxsJbl8iSpANx/uqxQHsE8CzDypwvwdIt5QUri0jD0a8HnqY92YUni8yOJfOVsLSmPlZKrqcv+DuLnnoHaNENuw924flkt4tI0quiC3wNU+KlxTLBh8xQ24V14XKJ7rV9/UKzlHhr4pqv9cGIDmWaTlilCzUopylrBh0SJP8NQg0nI7ydLJS88Lu5xP5PMZquSJB41mkp57pYV1jhS6u9TDS0vWa1cixfmZ6iPM9BtszAt+Idwm2tJUY8bdLVdWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA5M91uZTGUIeAmRfqi0oJ4TH0gSSN4buaJNTD+1jEI=;
 b=PwHMQ7ZbV3inGNtuicqv3iKWkhtBhiNngNve6b8Vz8+8k6QtNpwskzzLDIIozMASr189jAA73DVNDkgoUj/wSh5VQ6Ea25e4yPDtailptlfOrz2ACu1iScVso3HttT/Ztu/Ektq8ddBRY68NZ0nep9sC1wzxFqA8vzb6GOwdvEw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/15] net/mlx5e: kTLS, Save by-value copy of the record frags
Thread-Topic: [net 06/15] net/mlx5e: kTLS, Save by-value copy of the record
 frags
Thread-Index: AQHVheuUduN8bxyMiUylP6zBPANp6g==
Date:   Fri, 18 Oct 2019 19:38:12 +0000
Message-ID: <20191018193737.13959-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 8ae7f5b1-c2ea-46a0-b9a6-08d75402b6b2
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392FA10E1D62C427B3837E4BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pvTpQItqrb4IYONkQcOFjMR8sSO1rMRoO0WW9La3J8qLMv3rBl46462xZJDSqXHAfh8t1QVZUQj5r7f2kp1SDVYsYqL1qpk2DxFcFgekRi6IZ8N4saIFYSDEL1hBKNgMpkPHlSBfsKQg8zJf/4bSnMq39M/l9i72fuTaKICoe9SUFN69Xujq6kpQgXvqfXT6GjaND9sKxoh1m8I1g45TEKJoj27+luYCG5v+M7hnVWTV8HQ+rrG5nndE8FoN1LrDzzHe58/7xxwK/a55QhQ9xxSx0Awu9DT0phxS/5UPGBdzc2Inb5rZ/qVQ1w2309ZbB58FY0E81rlHf+9euyW+Z/9yOhPAUgosl8aNRu9Qlkxl26ikO/U0k5yuNeIhbjjzj9e9g03Yv6qpS0TuF0WFgqavSKJcJhJJdGQsYK0HPbGrh7cF0OyR/YQCzlRIKc5t
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae7f5b1-c2ea-46a0-b9a6-08d75402b6b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:13.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WAS34Njz0BNfBHDD12BJePHzjjkTBlGrS4JQJn4sxxGgSNVw7UKDVZzCVeRa0D/wln4kx7s3120gb+bxKyXWng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Access the record fragments only under the TLS ctx lock.
In the resync flow, save a copy of them to be used when
preparing and posting the required DUMP WQEs.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6dfb22d705b2..334808b1863b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -179,7 +179,7 @@ struct tx_sync_info {
 	u64 rcd_sn;
 	s32 sync_len;
 	int nr_frags;
-	skb_frag_t *frags[MAX_SKB_FRAGS];
+	skb_frag_t frags[MAX_SKB_FRAGS];
 };
=20
 static bool tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx=
,
@@ -212,11 +212,11 @@ static bool tx_sync_info_get(struct mlx5e_ktls_offloa=
d_context_tx *priv_tx,
=20
 		get_page(skb_frag_page(frag));
 		remaining -=3D skb_frag_size(frag);
-		info->frags[i++] =3D frag;
+		info->frags[i++] =3D *frag;
 	}
 	/* reduce the part which will be sent with the original SKB */
 	if (remaining < 0)
-		skb_frag_size_add(info->frags[i - 1], remaining);
+		skb_frag_size_add(&info->frags[i - 1], remaining);
 	info->nr_frags =3D i;
 out:
 	spin_unlock_irqrestore(&tx_ctx->lock, flags);
@@ -365,7 +365,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
=20
 	for (i =3D 0; i < info.nr_frags; i++)
-		if (tx_post_resync_dump(sq, info.frags[i], priv_tx->tisn, !i))
+		if (tx_post_resync_dump(sq, &info.frags[i], priv_tx->tisn, !i))
 			goto err_out;
=20
 	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
--=20
2.21.0

