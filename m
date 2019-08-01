Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8185D7E3A5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbfHAT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:25 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388866AbfHAT5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+xfOToOi4VSn0WMowR9Yb63Ql6KqXX6xrWTidAgCVOxt5FeHjKGnDC57HjCEJ2GHx1a7qm/oEwWSM5LM1TYBkq3Dry94HQtzSNmaRKsDA9dGuKc9vcp4/XB5OevG6390uigmPmmqEfdyU0vsvPR4Hm2fyYUmW4fW12zmSUxUYBLVVI2Y8QmK1ogo4fFQEFFSII9cmLlY8wodCOWgNIv5hU1b08eoqUKBAQ/XaM/8lKBZ6dOqrNKdg9YOUo8cKXjgX7e2ujj7vqCRPxywOpiMCR31QNeBXH+n0kjzZ+FGvx45FZwBEteCWotUlQSFmT/heCDnTbB8O1IJlnrTMmghQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdJbXH6x7Uv+2N/IoQBme6BzNQOuIn3xmmSMFvLXYu4=;
 b=beI0QV2Dzo2ieLudfKWH6ZuXwaeZPQ0wJ+Y1GPQi2dWoHg0Qqzk3flCsQ1HCOH6PQn/T72R5WKb7qwKjtK58UHDLF4AtungCt9L9c0S69KVExgZqDKzLSSuwN6YoLpdp7WZbkFUFGw8nFpeI42OGrnMBmXmVDIbmN1udjjSDl1chFK0wvDsi4Wgrqw9AJwaWyctxUMN3KvyZiyvoRT7bXWaTn/9bmbpAfo6mlu2AwlKqJJeNvHTy3w0FaKp0shiz6ordNz5dLKD+QdL/tnXtbhvWdzOcArQHw+pPlu25oC9//0OBonAOHpEWcZZ9LX88ZC8qt+FgIKfKi7Ye77GOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdJbXH6x7Uv+2N/IoQBme6BzNQOuIn3xmmSMFvLXYu4=;
 b=DiPNetvxPxlbuSygXNMJgFD/ypv6MPE0yeL2h5ST3X90BHXpx13a7BCAQ5VZ4bAWYWNncZvt1uxj1hF5xX17lK3tmQK5zEx9cjAaWuVUvQZYmWQS3vOM3L6gIl5dW0vW2HImzM2A3zpVrkQZ+6RoQeOOk74dDN21+8EFLXuW9Nk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/12] net/mlx5e: Rx, checksum handling refactoring
Thread-Topic: [net-next 08/12] net/mlx5e: Rx, checksum handling refactoring
Thread-Index: AQHVSKNKS6X6bWz4YEGEbjRMz8qKBQ==
Date:   Thu, 1 Aug 2019 19:57:04 +0000
Message-ID: <20190801195620.26180-9-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31458006-c39f-4ce8-c5d5-08d716ba6cfe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759B785E31CF888324CA573BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lPLj23OukUiD1hEDcxfaQk/O2q9coV6jIEZX8ZqGbuShZiERgeP25R34thUSW9OUNYDZAq0hy6Jk7TDYoE2uH2aa9777VxzDfY1TxENlER+7CN8etCYFO5F1JEdItB9Pdy+Vbhirns6Hv5XZQ/42HMFwf4Rr+X0vEqafa4mnjnuhlPH7d0iQZL8YA+W6/RyNlc6WfVgAplRYhek0KyIxxM01oepVDLoBRx5Ke/SiWUF3KzJNWeSvWWjjygmCbQVPmAU/0dKQX23uFljrH6B5H52O8GLw1XZlIHkIIMpxRPsHPZGuQWmhY3olQst8gu2ikfKFX1e1CG+y3CCgTmBq6PwzOgC/fhrXgF+MhvJ0AuSGdnG8fCnmPCZfyTlc5fd4HF180eUIMQNzEZDm4o/Z761NDGJch+KsYzK9QHFyg0s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31458006-c39f-4ce8-c5d5-08d716ba6cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:04.6148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move vlan checksum fixup flow into mlx5e_skb_padding_csum(), which is
supposed to fixup SKB checksum if needed. And rename
mlx5e_skb_padding_csum() to mlx5e_skb_csum_fixup().

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index ac6e586d403d..60570b442fff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -859,13 +859,24 @@ tail_padding_csum(struct sk_buff *skb, int offset,
 }
=20
 static void
-mlx5e_skb_padding_csum(struct sk_buff *skb, int network_depth, __be16 prot=
o,
-		       struct mlx5e_rq_stats *stats)
+mlx5e_skb_csum_fixup(struct sk_buff *skb, int network_depth, __be16 proto,
+		     struct mlx5e_rq_stats *stats)
 {
 	struct ipv6hdr *ip6;
 	struct iphdr   *ip4;
 	int pkt_len;
=20
+	/* Fixup vlan headers, if any */
+	if (network_depth > ETH_HLEN)
+		/* CQE csum is calculated from the IP header and does
+		 * not cover VLAN headers (if present). This will add
+		 * the checksum manually.
+		 */
+		skb->csum =3D csum_partial(skb->data + ETH_HLEN,
+					 network_depth - ETH_HLEN,
+					 skb->csum);
+
+	/* Fixup tail padding, if any */
 	switch (proto) {
 	case htons(ETH_P_IP):
 		ip4 =3D (struct iphdr *)(skb->data + network_depth);
@@ -931,16 +942,7 @@ static inline void mlx5e_handle_csum(struct net_device=
 *netdev,
 			return; /* CQE csum covers all received bytes */
=20
 		/* csum might need some fixups ...*/
-		if (network_depth > ETH_HLEN)
-			/* CQE csum is calculated from the IP header and does
-			 * not cover VLAN headers (if present). This will add
-			 * the checksum manually.
-			 */
-			skb->csum =3D csum_partial(skb->data + ETH_HLEN,
-						 network_depth - ETH_HLEN,
-						 skb->csum);
-
-		mlx5e_skb_padding_csum(skb, network_depth, proto, stats);
+		mlx5e_skb_csum_fixup(skb, network_depth, proto, stats);
 		return;
 	}
=20
--=20
2.21.0

