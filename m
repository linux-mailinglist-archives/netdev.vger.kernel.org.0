Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080B965FCA
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfGKSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:19 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:8419
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728469AbfGKSyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hz+CduK3PfrhUMbdNKp01NOjEWwi9XsUxaV+8mRwpwHHvwC7eymh9jvWiC8fbbhU8hiGa5J/ulNUx24wHxOZlrBhIzujzU929pgJmFRYyKKRHPRDsr5wh0kOGdGV0YwxnGkKYWN6gsKUbNCTApAVym0CRi5WJVHurJzlAhbkZuo/h1V/DJIxmNTqSOwG3t+J5Lf2cwKhHq1S7qp/gt2D3hMspF1+gyTjX5Qwn3bXSwo0f+bwJnQReyv6Kglbphx3iH41Du1dDkB6JncAO1xKCposwUgE9wTbGehEosavtJyz2MoeWBKVOEdF9vyNTFtCOIxkNhaL+FhnVGid5/ZCUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10vU2YEMEo0DZSOIcfRcONczaOd53v5v8ETyfje5jE0=;
 b=L2nS6bbDsclrQgn9rtRTOQHrIBH1mTFkmGMQttF7cFEQ4Ed/yZ+G6BZzLxBq1bE7LWG9AaL/OdV6eGZhJkEfCQvKsC7vRdwchqH8eDu5jybaU9BfOLd4h2QqQmn+tVpWbbaGjlp1RtLaPYT8Jqdz5fjzqPFtpY9U8NjDxHahhrO0HKT9Unfwc/CF2ySDl6STXJ/LLm8gx2nPN2z9pTrUMmV/U8G3Qjmp05XheRJITAcXyezC9sUbAvy3EQ6fNDBu/2TVr2KbkLJHo0PLZlLYzzVctS63XBAEehsU/MlpuOR+QMEwI2REoIq+ioXcch1RQe+oeGht0F/rKGgLbrDqFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10vU2YEMEo0DZSOIcfRcONczaOd53v5v8ETyfje5jE0=;
 b=pHHy7h+VmA6pyyKf0mzpuAGcWOonBIFP4v1Ez/KOBAVpXYuZC3xxkK6V+RBHsVGn+OZmwtgoBvcJwhCAcoX1SGXxInDHwWt6X5rtZN9cgae4RwmUR3afG61PWzyssEKnsOt+Nlsd3KC3W2zAh4PBmHPGfvquJJXMKxs5riCTEYc=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:14 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/6] net/mlx5e: Rx, Fix checksum calculation for new hardware
Thread-Topic: [net 3/6] net/mlx5e: Rx, Fix checksum calculation for new
 hardware
Thread-Index: AQHVOBoI9eUQj9crUEaliE4ZBjQfHg==
Date:   Thu, 11 Jul 2019 18:54:14 +0000
Message-ID: <20190711185353.5715-4-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 240ace0f-1b98-4023-bbe1-08d706312b33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB2770AA87FA11539B9A75E84BBEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(14444005)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qy9eA9jWu5onMktdAmedE4NiZ3UVhHdnfF+8/ulZ72DtDISI3FHC2x9gr/WXKbYwRUC3v7x66R6KTuNTBBjAxTakldSKr6Bx3U81khKaLU3tPNijpBEhQCkjEQuziUXNsbPEit1UXilXnOV1UWqoSUOeYkysgYr7XxyEX4cFzsdU0PIygbDD+gHi4CF2r/VfdUbGH8J8ZVe0EnCyYRM/ZKAZkxSYxJbtiQIWappGX6C2GpIdj9tGwLN3skVkV4QdSED58KxztGBlVvzlr5/TBTXw3YlznyuhvzFWh0h7+Mvy23ZLZ80Vy37E3NEvUN9ix8NyuAh6P4tT8TEc9c41ePVYA5aZrNXIsKl/T3Mfw31DeJ9Bwwg4QNMNUhcEh53KcZ+02bGmIJytN4vMApdEqaDhEv3JqD6D3kK0o32IKD4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240ace0f-1b98-4023-bbe1-08d706312b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:14.7637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CQE checksum full mode in new HW, provides a full checksum of rx frame.
Covering bytes starting from eth protocol up to last byte in the received
frame (frame_size - ETH_HLEN), as expected by the stack.

Fixing up skb->csum by the driver is not required in such case. This fix
is to avoid wrong checksum calculation in drivers which already support
the new hardware with the new checksum mode.

Fixes: 85327a9c4150 ("net/mlx5: Update the list of the PCI supported device=
s")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 7 ++++++-
 include/linux/mlx5/mlx5_ifc.h                     | 3 ++-
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index cc6797e24571..cc227a7aa79f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -294,6 +294,7 @@ enum {
 	MLX5E_RQ_STATE_ENABLED,
 	MLX5E_RQ_STATE_AM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
+	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
 };
=20
 struct mlx5e_cq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index a8e8350b38aa..98d75271fc73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -855,6 +855,9 @@ static int mlx5e_open_rq(struct mlx5e_channel *c,
 	if (err)
 		goto err_destroy_rq;
=20
+	if (MLX5_CAP_ETH(c->mdev, cqe_checksum_full))
+		__set_bit(MLX5E_RQ_STATE_CSUM_FULL, &c->rq.state);
+
 	if (params->rx_dim_enabled)
 		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 13133e7f088e..8a5f9411cac6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -873,8 +873,14 @@ static inline void mlx5e_handle_csum(struct net_device=
 *netdev,
 		if (unlikely(get_ip_proto(skb, network_depth, proto) =3D=3D IPPROTO_SCTP=
))
 			goto csum_unnecessary;
=20
+		stats->csum_complete++;
 		skb->ip_summed =3D CHECKSUM_COMPLETE;
 		skb->csum =3D csum_unfold((__force __sum16)cqe->check_sum);
+
+		if (test_bit(MLX5E_RQ_STATE_CSUM_FULL, &rq->state))
+			return; /* CQE csum covers all received bytes */
+
+		/* csum might need some fixups ...*/
 		if (network_depth > ETH_HLEN)
 			/* CQE csum is calculated from the IP header and does
 			 * not cover VLAN headers (if present). This will add
@@ -885,7 +891,6 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 						 skb->csum);
=20
 		mlx5e_skb_padding_csum(skb, network_depth, proto, stats);
-		stats->csum_complete++;
 		return;
 	}
=20
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5e74305e2e57..7e42efa143a0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -749,7 +749,8 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bi=
ts {
 	u8         swp[0x1];
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
-	u8         reserved_at_23[0xd];
+	u8         cqe_checksum_full[0x1];
+	u8         reserved_at_24[0xc];
 	u8         max_vxlan_udp_ports[0x8];
 	u8         reserved_at_38[0x6];
 	u8         max_geneve_opt_len[0x1];
--=20
2.21.0

