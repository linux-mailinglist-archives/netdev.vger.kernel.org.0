Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621995FCC9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfGDSQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:16 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727252AbfGDSQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7Q9wA0697pXxgrEr4uW+u1ln/fHcxKEZx11/Qo6zRY=;
 b=aJnqcX0MLQEjC/gBAEa0YlhoR9bOTW35n+TUKg1aYx32Zzqj48DINr3Bk808VtgMzs/AiZH9z6zITe1htKI5sgeL4m1aEy7j49fpKKgxWtVoMtZEX/70Ut/EJ85kz6O+Zmc3zF+/NIr/trcplwCHq89LzMbnvdLwq8ii+VPZg7c=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:01 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/14] net/mlx5e: Tx, Enforce L4 inline copy when needed
Thread-Topic: [net-next 08/14] net/mlx5e: Tx, Enforce L4 inline copy when
 needed
Thread-Index: AQHVMpSJ+rX19IfTc0yubA4VyMZL+Q==
Date:   Thu, 4 Jul 2019 18:16:01 +0000
Message-ID: <20190704181235.8966-9-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15c6b8c5-60ca-4958-23f5-08d700abab6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25847E90913B363F6BFC5C7EBEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002)(309714004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MC0AR32Py86tTH8O8qpzrAlNsFU8HOQ+AOzm599cytES0TYhsiP68Ks3+tXY40pKl7Gr9ON8CSlFPY1wLF6buW/mTFTL2MQAJzBMIduRu6snCoLgmOJxY95WGSYFMRFBvFEuw17E41qNseA2kA7F3ErcIyEeDOsYK6h3DVH0RfTRbCXvJxQx0oKgTmeuTl3tXP0fQPPY25gfEkgoM8rwDHAPdWQWsG7C4Sxjp7fNWgxATbK0nFXnUaoFEsbxb+hWsBZjXngaC6Y4e1RzzCeYJPvgihrS/OMwhMX51SGUcrUqnCNNwKuLCdcpLpk+h3MfDT9VEvRHDbr3EA3jFzd5lztadh84RbGk56sxRquOsXYpIbP3ey+cxgLpONNbf3Cax+bDfBFWYQU7ln+d7RhCZcFT+YP10M6vFvTyPJ9ZEkw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c6b8c5-60ca-4958-23f5-08d700abab6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:01.6631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

When ctrl->tisn field exists, this indicates an operation (HW offload)
on the TCP payload.
For such WQEs, inline the headers up to L4.

This is in preparation for kTLS HW offload support, added in
a downstream patch.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 7fdf69e08d58..bd41f89afef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -77,6 +77,11 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __i=
omem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
=20
+static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5e_tx_wqe *wqe)
+{
+	return !!wqe->ctrl.tisn;
+}
+
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index dc77fe9ae367..b1a163e66053 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -304,9 +304,12 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, stru=
ct sk_buff *skb,
 		num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
 		stats->packets +=3D skb_shinfo(skb)->gso_segs;
 	} else {
+		u8 mode =3D mlx5e_transport_inline_tx_wqe(wqe) ?
+			MLX5_INLINE_MODE_TCP_UDP : sq->min_inline_mode;
+
 		opcode    =3D MLX5_OPCODE_SEND;
 		mss       =3D 0;
-		ihs       =3D mlx5e_calc_min_inline(sq->min_inline_mode, skb);
+		ihs       =3D mlx5e_calc_min_inline(mode, skb);
 		num_bytes =3D max_t(unsigned int, skb->len, ETH_ZLEN);
 		stats->packets++;
 	}
--=20
2.21.0

