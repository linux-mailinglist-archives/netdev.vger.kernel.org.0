Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B296BB40E
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439552AbfIWMmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:42:43 -0400
Received: from mail-eopbgr30075.outbound.protection.outlook.com ([40.107.3.75]:11880
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404312AbfIWMmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:42:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4wc3bHnKDuhlmMZrbpZLXeUb5Ac1pdHvIw3Yvka676yUgNeF3lfa4mZAqViDhMbkcD2De/zyhGpyJlE2cqclCj4uOFOAqyp17cdJvClFb9q3sor3PMFb/uJ0Xhv26SPBsDt++8BxOKy+nbIYMPA1MFDVO9Tf/OZv2rz6gdToB6C0mzlZURfCCkLC6h7NjidkVU0IM/VYp5B+RPLkaGlm8STg3jwiK+nZ6n42+iul+aKgvWHfYlYYfnpJJHfgdhyD9RJ7biboBmFeV4uJjpKr99jm6tSVVj4nqHF9/inrXqA2ZigzGfHv24Z+791i931zUJ1mwUMulYwpM5bROlLWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U16rMmVaezA3FLawqzz2UiuPxq2I9WPZT5KcYbJZ3qo=;
 b=IKZ0SQNguP2QyUkpqu16h2oobMIvCgoFdWq2k+jObXY9iHpPsjcsAdiIOd9hoZxojr9/5uIgyN/aOuKsrHSIQm4gdgo1haAuf5ujH5hc8WraqjsLSDCCUgxEZ7vsDWjXluTFXnJuC4BeyZ52VzRsplqEImCwQP49BR7NzdGbD6iuEqkaHxuOfDUQE0xHrj1keBESv4onWZMuTTSrUgyvbZ4s8u70OdGl0N56LSPE/9IqlsLMvY742UiWYrP7RqGXiuv+ECVsbZQ9R5pTNCdpQtViBphnS3y3CwbZR38xgGa9cTVlkSXgDttcGcwJLPL+Tw5EESiljCplSAB0+1bg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U16rMmVaezA3FLawqzz2UiuPxq2I9WPZT5KcYbJZ3qo=;
 b=BSgjnthI1oSHK0UTZM1DCLGkc1UIlV3dmxcFwXcg2qGSbCIuszPuNImFmraLvR2EU3f4xgzIP/unhGTpmgK39q+xVX/SGlIiWklndrJOr+T40IPkk++DCBvBff7QDzJsenkswMjujFWolFJqT6zBFgJCoVBwzCeeBokQcLwaQPg=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:25 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 4.19-stable 6/7] net/mlx5e: Rx, Fixup skb checksum for packets
 with tail padding
Thread-Topic: [PATCH 4.19-stable 6/7] net/mlx5e: Rx, Fixup skb checksum for
 packets with tail padding
Thread-Index: AQHVcgwSVMVxwohbPEyT8GEYBTT+bA==
Date:   Mon, 23 Sep 2019 12:40:25 +0000
Message-ID: <20190923123917.16817-7-saeedm@mellanox.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
In-Reply-To: <20190923123917.16817-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [89.138.141.98]
x-clientproxiedby: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f994c029-9a2b-485b-7fa3-08d7402334b2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB233936AAEE6241959DAA3102BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(14444005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RXg/i4WnWEmcy+sBQzzdYkiJRsVqhvvkSma2aO+GW6eGhKua88uey/ETtMxJzSe+oUReJDYuVsanLBpAK7AIMkJqOGlaS0XsKb93RK3cSoe4MwZau7xsmA8ljrldXvMs+3hhYyt/DmxRHg67KVs7kvio5xHEyvNAjb0u5hPUSYJu4W6UdQ1+xUd+7NUv1S6dcTs3AaSuGQqbMnoKo5xLCDZtC4omng/12RYF1zl5j5LXCxAPCx3Nxb0dobAgABLq55BGX+a6RYYVW1bzHaXuCpANwqDEQ2j7bV2hR+Xi4gtqJfUN0TU12YkexEN9u0+Pd9yzL4/oAO+ALUsVG+yWOmQT1LgHiXdUE51S9CZE5g+dmz5iHH5HP2ksBSswOQE+MCg65L3ycbaEruCpJQPFDfeIXoumijHM4uVoFFETFz0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f994c029-9a2b-485b-7fa3-08d7402334b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:25.2049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R674P71xZcIW4B3KatJonna3aHTvltXbgAqUKe85LokJ4yHvJ6xtcgZLPiXKBR4DiiMnWWGyq+A3+i++KLl3mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 0aa1d18615c163f92935b806dcaff9157645233a ]

When an ethernet frame with ip payload is padded, the padding octets are
not covered by the hardware checksum.

Prior to the cited commit, skb checksum was forced to be CHECKSUM_NONE
when padding is detected. After it, the kernel will try to trim the
padding bytes and subtract their checksum from skb->csum.

In this patch we fixup skb->csum for any ip packet with tail padding of
any size, if any padding found.
FCS case is just one special case of this general purpose patch, hence,
it is removed.

Fixes: 88078d98d1bb ("net: pskb_trim_rcsum() and CHECKSUM_COMPLETE are frie=
nds"),
Cc: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 79 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  6 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  4 +
 3 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 98509e228ac3..318fee09f049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -714,17 +714,6 @@ static inline void mlx5e_enable_ecn(struct mlx5e_rq *r=
q, struct sk_buff *skb)
 	rq->stats->ecn_mark +=3D !!rc;
 }
=20
-static u32 mlx5e_get_fcs(const struct sk_buff *skb)
-{
-	const void *fcs_bytes;
-	u32 _fcs_bytes;
-
-	fcs_bytes =3D skb_header_pointer(skb, skb->len - ETH_FCS_LEN,
-				       ETH_FCS_LEN, &_fcs_bytes);
-
-	return __get_unaligned_cpu32(fcs_bytes);
-}
-
 static u8 get_ip_proto(struct sk_buff *skb, int network_depth, __be16 prot=
o)
 {
 	void *ip_p =3D skb->data + network_depth;
@@ -735,6 +724,68 @@ static u8 get_ip_proto(struct sk_buff *skb, int networ=
k_depth, __be16 proto)
=20
 #define short_frame(size) ((size) <=3D ETH_ZLEN + ETH_FCS_LEN)
=20
+#define MAX_PADDING 8
+
+static void
+tail_padding_csum_slow(struct sk_buff *skb, int offset, int len,
+		       struct mlx5e_rq_stats *stats)
+{
+	stats->csum_complete_tail_slow++;
+	skb->csum =3D csum_block_add(skb->csum,
+				   skb_checksum(skb, offset, len, 0),
+				   offset);
+}
+
+static void
+tail_padding_csum(struct sk_buff *skb, int offset,
+		  struct mlx5e_rq_stats *stats)
+{
+	u8 tail_padding[MAX_PADDING];
+	int len =3D skb->len - offset;
+	void *tail;
+
+	if (unlikely(len > MAX_PADDING)) {
+		tail_padding_csum_slow(skb, offset, len, stats);
+		return;
+	}
+
+	tail =3D skb_header_pointer(skb, offset, len, tail_padding);
+	if (unlikely(!tail)) {
+		tail_padding_csum_slow(skb, offset, len, stats);
+		return;
+	}
+
+	stats->csum_complete_tail++;
+	skb->csum =3D csum_block_add(skb->csum, csum_partial(tail, len, 0), offse=
t);
+}
+
+static void
+mlx5e_skb_padding_csum(struct sk_buff *skb, int network_depth, __be16 prot=
o,
+		       struct mlx5e_rq_stats *stats)
+{
+	struct ipv6hdr *ip6;
+	struct iphdr   *ip4;
+	int pkt_len;
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		ip4 =3D (struct iphdr *)(skb->data + network_depth);
+		pkt_len =3D network_depth + ntohs(ip4->tot_len);
+		break;
+	case htons(ETH_P_IPV6):
+		ip6 =3D (struct ipv6hdr *)(skb->data + network_depth);
+		pkt_len =3D network_depth + sizeof(*ip6) + ntohs(ip6->payload_len);
+		break;
+	default:
+		return;
+	}
+
+	if (likely(pkt_len >=3D skb->len))
+		return;
+
+	tail_padding_csum(skb, pkt_len, stats);
+}
+
 static inline void mlx5e_handle_csum(struct net_device *netdev,
 				     struct mlx5_cqe64 *cqe,
 				     struct mlx5e_rq *rq,
@@ -783,10 +834,8 @@ static inline void mlx5e_handle_csum(struct net_device=
 *netdev,
 			skb->csum =3D csum_partial(skb->data + ETH_HLEN,
 						 network_depth - ETH_HLEN,
 						 skb->csum);
-		if (unlikely(netdev->features & NETIF_F_RXFCS))
-			skb->csum =3D csum_block_add(skb->csum,
-						   (__force __wsum)mlx5e_get_fcs(skb),
-						   skb->len - ETH_FCS_LEN);
+
+		mlx5e_skb_padding_csum(skb, network_depth, proto, stats);
 		stats->csum_complete++;
 		return;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 493bd2752037..8255d797ea94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -58,6 +58,8 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_none) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail_slow) }=
,
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_drop) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_redirect) },
@@ -149,6 +151,8 @@ void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->rx_removed_vlan_packets +=3D rq_stats->removed_vlan_packets;
 		s->rx_csum_none	+=3D rq_stats->csum_none;
 		s->rx_csum_complete +=3D rq_stats->csum_complete;
+		s->rx_csum_complete_tail +=3D rq_stats->csum_complete_tail;
+		s->rx_csum_complete_tail_slow +=3D rq_stats->csum_complete_tail_slow;
 		s->rx_csum_unnecessary +=3D rq_stats->csum_unnecessary;
 		s->rx_csum_unnecessary_inner +=3D rq_stats->csum_unnecessary_inner;
 		s->rx_xdp_drop     +=3D rq_stats->xdp_drop;
@@ -1139,6 +1143,8 @@ static const struct counter_desc rq_stats_desc[] =3D =
{
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, bytes) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete_tail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete_tail_slow) }=
,
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_none) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 13f9028c638d..3ea8033ed6bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -71,6 +71,8 @@ struct mlx5e_sw_stats {
 	u64 rx_csum_unnecessary;
 	u64 rx_csum_none;
 	u64 rx_csum_complete;
+	u64 rx_csum_complete_tail;
+	u64 rx_csum_complete_tail_slow;
 	u64 rx_csum_unnecessary_inner;
 	u64 rx_xdp_drop;
 	u64 rx_xdp_redirect;
@@ -180,6 +182,8 @@ struct mlx5e_rq_stats {
 	u64 packets;
 	u64 bytes;
 	u64 csum_complete;
+	u64 csum_complete_tail;
+	u64 csum_complete_tail_slow;
 	u64 csum_unnecessary;
 	u64 csum_unnecessary_inner;
 	u64 csum_none;
--=20
2.21.0

