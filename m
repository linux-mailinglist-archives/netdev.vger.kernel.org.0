Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE02BB3F5
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439454AbfIWMkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:40:06 -0400
Received: from mail-eopbgr30087.outbound.protection.outlook.com ([40.107.3.87]:29861
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438917AbfIWMkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:40:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7WJFPFBKvcsGtQhryYVAiUNRhKv2+GO9lLTeK7jkxRXEE0Tlm4/LHJaku3163JPuVRGhoq9MGlAsYUYxK5W4/j48rqpacoKG411iYlf3MfA0fY6bUGwDBQS79GnPdcXVg/B3qRI4bg63NR9l2c0pCiUEDeyX6F4+EcypiVXBnx4ozsJ1ukiGwCZGx4O/ZH3DBXpob2wzkczVs8bH+5QcnOSYUsNIzy4li2pn3oj24dKOJng9wJ90AXwUTmblkzJ9RjFT6pnrHzhAqUHhGMFjFl7RHn8Qs1myII7A8Km5LX2SH/fMpBXD8PKK+yv/G1tJeIq2FGyWbnaA3cGfBH6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvhOIzN6R2icRgzjUypDeKQbc1388SEhnIfb/gDs3G0=;
 b=aq98rUJTQcSY+MYW9lHNbMn1gcqx78nNt1qo6kutucQhfqSA/gAETcdVULddBty9khbWix/tlcAdIiejqBpbNeXtIBzF8/KWUT/Iwi3aCWu4GHPvJVSgPkcVN7kkr5rwh/B7HVUUUH9ESbhN2+LhIDG8XsO62VIhIEGdSD19FxOFeFDOdPkhQVYEav6sQR5bxUR/guwyVF34SXsNLPogUu2eXFsg4mKwatV4Pbdil8wkHbf/JUaUDVivEL2YApkOQNHOJn/BmAT4zp7HlopkOEBPifbV5/vbA31IaU4nlOhdlyHsMYCx9M12iFv3XnwgP1Nm67lG3WUUAHSDolrbeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvhOIzN6R2icRgzjUypDeKQbc1388SEhnIfb/gDs3G0=;
 b=GL6b34XJmiqCsXhmdRvasoXC9SaeQh7MGCYLekEoqs4qOqnS2fxk4YvbXiBvesvX5pk4cgtypCGD0DXTULV8wk9jbVOgDbjMmRh4GHPIGHzWLE1v22WB9o8+FZdSQL3bv1EOyoFMurQwxwN6vd2GKX6LI+8XPZoQcNfGxLcPjRA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:02 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Natali Shechtman <natali@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19-stable 1/7] net/mlx5e: Set ECN for received packets using
 CQE indication
Thread-Topic: [PATCH 4.19-stable 1/7] net/mlx5e: Set ECN for received packets
 using CQE indication
Thread-Index: AQHVcgwE7gpUDPPOy0SaQXM0luRaBQ==
Date:   Mon, 23 Sep 2019 12:40:01 +0000
Message-ID: <20190923123917.16817-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b41eb544-bb8d-4eb6-7814-08d7402326b9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2339818465DB6841EEF60B68BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:155;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(14444005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003)(309714004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BJyhUzgRxADsvUHKj5fgvDmSA+oRUrhgKiebPWFXmdFxk3lcpMnZqCxbb/VqFIeo4cS7XVuo/7wghngfhmJSDTf07niH6UgXfxJFa50AG36IGPMuwkfVJoLskMAYKxLYFWNn4ZIMRa/4TgmRSAizmzhOTqy1MvOsJ0mFsxe9DTVUScHrDrnMazD2L1xG4L25Q5RtaiZxu6XPkucy6IynLv/QRGX2Rkq5JDkpwtWBC7VayA8aPXcd/ykQtjawUS5S3J/Y3LeVaF5TtE/ha0xAJMJVr4F02pUqJQ+hmB+dokjCAUvLRsEIkdb2ljYPfxhGxe7kYazmxqrMDcScOLDDxiZvUUaTKA8iJ61G16FMUkPeBxmqOT7pT90M47ZBJGXK/06dSVUWVarLcJDgvPQKNud+KThXg9FbIc99ox/mTok=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41eb544-bb8d-4eb6-7814-08d7402326b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:01.8594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4zREy3LXvm9NseoWKW7B2uJYpOpX3ng3nV6drw0/HTVZ6ksC5ygAM+TrXW9z11XKnF+5wwjO3t4aYHWxP9JvRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Natali Shechtman <natali@mellanox.com>

[ Upstream commit f007c13d4ad62f494c83897eda96437005df4a91 ]

In multi-host (MH) NIC scheme, a single HW port serves multiple hosts
or sockets on the same host.
The HW uses a mechanism in the PCIe buffer which monitors
the amount of consumed PCIe buffers per host.
On a certain configuration, under congestion,
the HW emulates a switch doing ECN marking on packets using ECN
indication on the completion descriptor (CQE).

The driver needs to set the ECN bits on the packet SKB,
such that the network stack can react on that, this commit does that.

Needed by downstream patch which fixes a mlx5 checksum issue.

Fixes: bbceefce9adf ("net/mlx5e: Support RX CHECKSUM_COMPLETE")
Signed-off-by: Natali Shechtman <natali@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 35 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  3 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index d3f794d4fb96..2a37f5f8a290 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -37,6 +37,7 @@
 #include <net/busy_poll.h>
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
+#include <net/inet_ecn.h>
 #include "en.h"
 #include "en_tc.h"
 #include "eswitch.h"
@@ -688,12 +689,29 @@ static inline void mlx5e_skb_set_hash(struct mlx5_cqe=
64 *cqe,
 	skb_set_hash(skb, be32_to_cpu(cqe->rss_hash_result), ht);
 }
=20
-static inline bool is_last_ethertype_ip(struct sk_buff *skb, int *network_=
depth)
+static inline bool is_last_ethertype_ip(struct sk_buff *skb, int *network_=
depth,
+					__be16 *proto)
 {
-	__be16 ethertype =3D ((struct ethhdr *)skb->data)->h_proto;
+	*proto =3D ((struct ethhdr *)skb->data)->h_proto;
+	*proto =3D __vlan_get_protocol(skb, *proto, network_depth);
+	return (*proto =3D=3D htons(ETH_P_IP) || *proto =3D=3D htons(ETH_P_IPV6))=
;
+}
+
+static inline void mlx5e_enable_ecn(struct mlx5e_rq *rq, struct sk_buff *s=
kb)
+{
+	int network_depth =3D 0;
+	__be16 proto;
+	void *ip;
+	int rc;
=20
-	ethertype =3D __vlan_get_protocol(skb, ethertype, network_depth);
-	return (ethertype =3D=3D htons(ETH_P_IP) || ethertype =3D=3D htons(ETH_P_=
IPV6));
+	if (unlikely(!is_last_ethertype_ip(skb, &network_depth, &proto)))
+		return;
+
+	ip =3D skb->data + network_depth;
+	rc =3D ((proto =3D=3D htons(ETH_P_IP)) ? IP_ECN_set_ce((struct iphdr *)ip=
) :
+					 IP6_ECN_set_ce(skb, (struct ipv6hdr *)ip));
+
+	rq->stats->ecn_mark +=3D !!rc;
 }
=20
 static u32 mlx5e_get_fcs(const struct sk_buff *skb)
@@ -717,6 +735,7 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 {
 	struct mlx5e_rq_stats *stats =3D rq->stats;
 	int network_depth =3D 0;
+	__be16 proto;
=20
 	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
 		goto csum_none;
@@ -738,7 +757,7 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 	if (short_frame(skb->len))
 		goto csum_unnecessary;
=20
-	if (likely(is_last_ethertype_ip(skb, &network_depth))) {
+	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
 		skb->ip_summed =3D CHECKSUM_COMPLETE;
 		skb->csum =3D csum_unfold((__force __sum16)cqe->check_sum);
 		if (network_depth > ETH_HLEN)
@@ -775,6 +794,8 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 	stats->csum_none++;
 }
=20
+#define MLX5E_CE_BIT_MASK 0x80
+
 static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 				      u32 cqe_bcnt,
 				      struct mlx5e_rq *rq,
@@ -819,6 +840,10 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe6=
4 *cqe,
 	skb->mark =3D be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK;
=20
 	mlx5e_handle_csum(netdev, cqe, rq, skb, !!lro_num_seg);
+	/* checking CE bit in cqe - MSB in ml_path field */
+	if (unlikely(cqe->ml_path & MLX5E_CE_BIT_MASK))
+		mlx5e_enable_ecn(rq, skb);
+
 	skb->protocol =3D eth_type_trans(skb, netdev);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 7047cc293545..493bd2752037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -53,6 +53,7 @@ static const struct counter_desc sw_stats_desc[] =3D {
=20
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_ecn_mark) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_removed_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_none) },
@@ -144,6 +145,7 @@ void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->rx_bytes	+=3D rq_stats->bytes;
 		s->rx_lro_packets +=3D rq_stats->lro_packets;
 		s->rx_lro_bytes	+=3D rq_stats->lro_bytes;
+		s->rx_ecn_mark	+=3D rq_stats->ecn_mark;
 		s->rx_removed_vlan_packets +=3D rq_stats->removed_vlan_packets;
 		s->rx_csum_none	+=3D rq_stats->csum_none;
 		s->rx_csum_complete +=3D rq_stats->csum_complete;
@@ -1144,6 +1146,7 @@ static const struct counter_desc rq_stats_desc[] =3D =
{
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, ecn_mark) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, wqe_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, mpwqe_filler_cqes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 0ad7a165443a..13f9028c638d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -66,6 +66,7 @@ struct mlx5e_sw_stats {
 	u64 tx_nop;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
+	u64 rx_ecn_mark;
 	u64 rx_removed_vlan_packets;
 	u64 rx_csum_unnecessary;
 	u64 rx_csum_none;
@@ -184,6 +185,7 @@ struct mlx5e_rq_stats {
 	u64 csum_none;
 	u64 lro_packets;
 	u64 lro_bytes;
+	u64 ecn_mark;
 	u64 removed_vlan_packets;
 	u64 xdp_drop;
 	u64 xdp_redirect;
--=20
2.21.0

