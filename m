Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9614586B59
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404699AbfHHUWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:05 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404324AbfHHUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTdG9EPaJO6G2brAGjl/ArA/CwCck/3e31bEyAnI5u6YD3A66asqDh2dlRG2mlhhyQIIOdhYtae2fh3pfcDgorLCFXGFwIrT61swDXCsb3QsgO1GhThmWQgo1GqI+juDqz+y/a/bfZx0YxOWM1R5Nj3yNLoSdzubW5nulP9jWs9C6bZjM6eheN4IWnONxVSCkIi2eqJHXia4DtQpxJd8o8v6DheAgjNT9y+aospiLyUmGa1exXpI9ieEUTynTCNt3CBiaQCToWslLPOhJMHBCQLFah7RenZVPkjSaT4BJD5YsGFzSkQI6/oL4KBNIX1oadvoKsqP3LIYxKFEzkRmIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jC94htuyb9qX9/HvsY/TuMZzZa6t2z2DsDBQDIOvUCU=;
 b=IC5CFPKSrHE0gge/6oo8EJWlmDOXyGbh5Zn37AR5b3yo4KwvK7pABMvnaVSwPseEiG3f9fZBY3XXG2eJc0b+SqjtGgfZtnbBTHqFffKkedehKFled6vIf2QDJXMeEbyuZYKwDeDMu7yLT3D8ZY9XJciRiN6yZpauQHdlDiYBfz0t4sihx9PVOnMgo/Z1kfKET45GXDFITKPk+CB9dqDp1HHcElBrA0X6b2AEPh/xqdaK6Rdc2GzsefUAecEXCtw+jCaX8HS68V/BwUvR9EL1nkT0m4ydt2OFmvWxinhHYhRbZlCcCfUIalXNR0rzIo0bpjn0wbdcqiL9/7ztpQixrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jC94htuyb9qX9/HvsY/TuMZzZa6t2z2DsDBQDIOvUCU=;
 b=FlCODM36MLe4gexCtLpg4dZ+qCW0R0UbO/9j88o38tk4UrC8KedBqLGEJqJLNwEVOmk/bH4XiJsMpCpuxdwpF0tnGaEe4yL1WBU/4tC6WTkbeFbBj4OCA3ISl8g+y7FYRLhLxUCNCps32nUCEkipzFmUWwbmaQMTygI59oXi/fw=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:00 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets for
 ARFS
Thread-Topic: [net 01/12] net/mlx5e: Use flow keys dissector to parse packets
 for ARFS
Thread-Index: AQHVTibv/OkIHzBCKU2Xiaya0wY6wg==
Date:   Thu, 8 Aug 2019 20:22:00 +0000
Message-ID: <20190808202025.11303-2-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8f33c89-5823-4949-5d11-08d71c3e1155
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB225788755084A39CA4CA9DCEBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(14444005)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sxIVGdE1eZWdcT+nOsdeTwX8L5F5pbM8y2R3UdfEzsAchq27cBL2bhQ4V0K90veL+Z1fIdUAwsazcJEzhNvljlc2OVZ1wlYi5Q8k8SbaFnKCcig3dQbkh91qAWYuc1gFeD+dgBNoKNjR279t4C48n6YvNIwhWdBhWiTlOGkKmokNwjBiZ/vtI0CqrOrJl3t07bMVQhf181yC/jEceeNRFbzbLUtvFXbBF/tU7dgTASa/vZXbvzzqFQLXuWhTssBFuj9MHs5RZMVD5AWAMjGaeGUh86gYke0rGweg0ioGi75IEh0n8Vni0KPyci+lQTZmX0DFEUHH2nAQIN0TiRw3JRC1raWiJz1YQEa+V3nznIi6GWovHkf7dt6ydigGSp/7INSLgKOC4M+8ICvTOEryryeiemCX78kNRPJsxWzO2XE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f33c89-5823-4949-5d11-08d71c3e1155
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:00.4539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZVWu9ux9uYLYTVkUChlXTaTEKgp0GEPoQ2u7ZBjrAfJQ/ZJHP46Cf9sZwSpUUUyFXw5J0/qkwRPDVGVX4Pw04A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The current ARFS code relies on certain fields to be set in the SKB
(e.g. transport_header) and extracts IP addresses and ports by custom
code that parses the packet. The necessary SKB fields, however, are not
always set at that point, which leads to an out-of-bounds access. Use
skb_flow_dissect_flow_keys() to get the necessary information reliably,
fix the out-of-bounds access and reuse the code.

Fixes: 18c908e477dc ("net/mlx5e: Add accelerated RFS support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 97 +++++++------------
 1 file changed, 34 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_arfs.c
index 8657e0f26995..2c75b2752f58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -437,12 +437,6 @@ arfs_hash_bucket(struct arfs_table *arfs_t, __be16 src=
_port,
 	return &arfs_t->rules_hash[bucket_idx];
 }
=20
-static u8 arfs_get_ip_proto(const struct sk_buff *skb)
-{
-	return (skb->protocol =3D=3D htons(ETH_P_IP)) ?
-		ip_hdr(skb)->protocol : ipv6_hdr(skb)->nexthdr;
-}
-
 static struct arfs_table *arfs_get_table(struct mlx5e_arfs_tables *arfs,
 					 u8 ip_proto, __be16 etype)
 {
@@ -602,31 +596,9 @@ static void arfs_handle_work(struct work_struct *work)
 	arfs_may_expire_flow(priv);
 }
=20
-/* return L4 destination port from ip4/6 packets */
-static __be16 arfs_get_dst_port(const struct sk_buff *skb)
-{
-	char *transport_header;
-
-	transport_header =3D skb_transport_header(skb);
-	if (arfs_get_ip_proto(skb) =3D=3D IPPROTO_TCP)
-		return ((struct tcphdr *)transport_header)->dest;
-	return ((struct udphdr *)transport_header)->dest;
-}
-
-/* return L4 source port from ip4/6 packets */
-static __be16 arfs_get_src_port(const struct sk_buff *skb)
-{
-	char *transport_header;
-
-	transport_header =3D skb_transport_header(skb);
-	if (arfs_get_ip_proto(skb) =3D=3D IPPROTO_TCP)
-		return ((struct tcphdr *)transport_header)->source;
-	return ((struct udphdr *)transport_header)->source;
-}
-
 static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 					 struct arfs_table *arfs_t,
-					 const struct sk_buff *skb,
+					 const struct flow_keys *fk,
 					 u16 rxq, u32 flow_id)
 {
 	struct arfs_rule *rule;
@@ -641,19 +613,19 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e=
_priv *priv,
 	INIT_WORK(&rule->arfs_work, arfs_handle_work);
=20
 	tuple =3D &rule->tuple;
-	tuple->etype =3D skb->protocol;
+	tuple->etype =3D fk->basic.n_proto;
+	tuple->ip_proto =3D fk->basic.ip_proto;
 	if (tuple->etype =3D=3D htons(ETH_P_IP)) {
-		tuple->src_ipv4 =3D ip_hdr(skb)->saddr;
-		tuple->dst_ipv4 =3D ip_hdr(skb)->daddr;
+		tuple->src_ipv4 =3D fk->addrs.v4addrs.src;
+		tuple->dst_ipv4 =3D fk->addrs.v4addrs.dst;
 	} else {
-		memcpy(&tuple->src_ipv6, &ipv6_hdr(skb)->saddr,
+		memcpy(&tuple->src_ipv6, &fk->addrs.v6addrs.src,
 		       sizeof(struct in6_addr));
-		memcpy(&tuple->dst_ipv6, &ipv6_hdr(skb)->daddr,
+		memcpy(&tuple->dst_ipv6, &fk->addrs.v6addrs.dst,
 		       sizeof(struct in6_addr));
 	}
-	tuple->ip_proto =3D arfs_get_ip_proto(skb);
-	tuple->src_port =3D arfs_get_src_port(skb);
-	tuple->dst_port =3D arfs_get_dst_port(skb);
+	tuple->src_port =3D fk->ports.src;
+	tuple->dst_port =3D fk->ports.dst;
=20
 	rule->flow_id =3D flow_id;
 	rule->filter_id =3D priv->fs.arfs.last_filter_id++ % RPS_NO_FILTER;
@@ -664,37 +636,33 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e=
_priv *priv,
 	return rule;
 }
=20
-static bool arfs_cmp_ips(struct arfs_tuple *tuple,
-			 const struct sk_buff *skb)
+static bool arfs_cmp(const struct arfs_tuple *tuple, const struct flow_key=
s *fk)
 {
-	if (tuple->etype =3D=3D htons(ETH_P_IP) &&
-	    tuple->src_ipv4 =3D=3D ip_hdr(skb)->saddr &&
-	    tuple->dst_ipv4 =3D=3D ip_hdr(skb)->daddr)
-		return true;
-	if (tuple->etype =3D=3D htons(ETH_P_IPV6) &&
-	    (!memcmp(&tuple->src_ipv6, &ipv6_hdr(skb)->saddr,
-		     sizeof(struct in6_addr))) &&
-	    (!memcmp(&tuple->dst_ipv6, &ipv6_hdr(skb)->daddr,
-		     sizeof(struct in6_addr))))
-		return true;
+	if (tuple->src_port !=3D fk->ports.src || tuple->dst_port !=3D fk->ports.=
dst)
+		return false;
+	if (tuple->etype !=3D fk->basic.n_proto)
+		return false;
+	if (tuple->etype =3D=3D htons(ETH_P_IP))
+		return tuple->src_ipv4 =3D=3D fk->addrs.v4addrs.src &&
+		       tuple->dst_ipv4 =3D=3D fk->addrs.v4addrs.dst;
+	if (tuple->etype =3D=3D htons(ETH_P_IPV6))
+		return !memcmp(&tuple->src_ipv6, &fk->addrs.v6addrs.src,
+			       sizeof(struct in6_addr)) &&
+		       !memcmp(&tuple->dst_ipv6, &fk->addrs.v6addrs.dst,
+			       sizeof(struct in6_addr));
 	return false;
 }
=20
 static struct arfs_rule *arfs_find_rule(struct arfs_table *arfs_t,
-					const struct sk_buff *skb)
+					const struct flow_keys *fk)
 {
 	struct arfs_rule *arfs_rule;
 	struct hlist_head *head;
-	__be16 src_port =3D arfs_get_src_port(skb);
-	__be16 dst_port =3D arfs_get_dst_port(skb);
=20
-	head =3D arfs_hash_bucket(arfs_t, src_port, dst_port);
+	head =3D arfs_hash_bucket(arfs_t, fk->ports.src, fk->ports.dst);
 	hlist_for_each_entry(arfs_rule, head, hlist) {
-		if (arfs_rule->tuple.src_port =3D=3D src_port &&
-		    arfs_rule->tuple.dst_port =3D=3D dst_port &&
-		    arfs_cmp_ips(&arfs_rule->tuple, skb)) {
+		if (arfs_cmp(&arfs_rule->tuple, fk))
 			return arfs_rule;
-		}
 	}
=20
 	return NULL;
@@ -707,20 +675,24 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const=
 struct sk_buff *skb,
 	struct mlx5e_arfs_tables *arfs =3D &priv->fs.arfs;
 	struct arfs_table *arfs_t;
 	struct arfs_rule *arfs_rule;
+	struct flow_keys fk;
+
+	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
+		return -EPROTONOSUPPORT;
=20
-	if (skb->protocol !=3D htons(ETH_P_IP) &&
-	    skb->protocol !=3D htons(ETH_P_IPV6))
+	if (fk.basic.n_proto !=3D htons(ETH_P_IP) &&
+	    fk.basic.n_proto !=3D htons(ETH_P_IPV6))
 		return -EPROTONOSUPPORT;
=20
 	if (skb->encapsulation)
 		return -EPROTONOSUPPORT;
=20
-	arfs_t =3D arfs_get_table(arfs, arfs_get_ip_proto(skb), skb->protocol);
+	arfs_t =3D arfs_get_table(arfs, fk.basic.ip_proto, fk.basic.n_proto);
 	if (!arfs_t)
 		return -EPROTONOSUPPORT;
=20
 	spin_lock_bh(&arfs->arfs_lock);
-	arfs_rule =3D arfs_find_rule(arfs_t, skb);
+	arfs_rule =3D arfs_find_rule(arfs_t, &fk);
 	if (arfs_rule) {
 		if (arfs_rule->rxq =3D=3D rxq_index) {
 			spin_unlock_bh(&arfs->arfs_lock);
@@ -728,8 +700,7 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const s=
truct sk_buff *skb,
 		}
 		arfs_rule->rxq =3D rxq_index;
 	} else {
-		arfs_rule =3D arfs_alloc_rule(priv, arfs_t, skb,
-					    rxq_index, flow_id);
+		arfs_rule =3D arfs_alloc_rule(priv, arfs_t, &fk, rxq_index, flow_id);
 		if (!arfs_rule) {
 			spin_unlock_bh(&arfs->arfs_lock);
 			return -ENOMEM;
--=20
2.21.0

