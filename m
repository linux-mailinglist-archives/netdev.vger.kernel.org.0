Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F28262475
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgIIB2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:23 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5199 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIIB2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:18 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582f7f0001>; Tue, 08 Sep 2020 18:27:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 08 Sep 2020 18:28:18 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 01/12] net/mlx5e: Refactor inline header size calculation in the TX path
Date:   Tue, 8 Sep 2020 18:27:46 -0700
Message-ID: <20200909012757.32677-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909012757.32677-1-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599614847; bh=CkGQuBiuduhMHjGupLjKKdkGlA6MC84TX4AH4MAg4oo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=gKwUcZJX9Jw2sWhjtcARyq36V2HdqNWFUwYQGzLk5m8Ovb/2T+skDFBFz9D+/re21
         P5fI59JbQDrtIX1qP9eVI/zRsNpU1TmDlvOyIi3az7xps5eqAZ6xQYj4ZOBgQrOaxl
         q1unQsA1r1QX8OVQTg0KkYdrTIibUwYJI16iy5aruL8p1lNrrGHJciA+FPGhBvr3YP
         VnMC9yukyvwL/Fe1yLOozl8qSzBksg9BzatSoGEpfH72it7QelloYi0++djTH+4Lrv
         qkgCtHABh7u67HIrn1fjtbOe8YGUKTscee6NYfY0F1FWBAAqiq+UZhnoWySsTzDXYf
         vs9qyCeC6tYgg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the next patch, don't increase ihs to calculate
ds_cnt and then decrease it, but rather calculate the intermediate value
temporarily. This code has the same amount of arithmetic operations, but
now allows to split out ds_cnt calculation, which will be performed in
the next patch.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index da596de3abba..e15aa53ff83e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -307,9 +307,9 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_bu=
ff *skb,
 	ds_cnt +=3D skb_shinfo(skb)->nr_frags;
=20
 	if (ihs) {
-		ihs +=3D !!skb_vlan_tag_present(skb) * VLAN_HLEN;
+		u16 inl =3D ihs + !!skb_vlan_tag_present(skb) * VLAN_HLEN - INL_HDR_STAR=
T_SZ;
=20
-		ds_cnt_inl =3D DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
+		ds_cnt_inl =3D DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
 		ds_cnt +=3D ds_cnt_inl;
 	}
=20
@@ -348,12 +348,12 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 	eseg->mss =3D mss;
=20
 	if (ihs) {
-		eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
 		if (skb_vlan_tag_present(skb)) {
-			ihs -=3D VLAN_HLEN;
+			eseg->inline_hdr.sz =3D cpu_to_be16(ihs + VLAN_HLEN);
 			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, ihs);
 			stats->added_vlan_packets++;
 		} else {
+			eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
 			memcpy(eseg->inline_hdr.start, skb->data, ihs);
 		}
 		dseg +=3D ds_cnt_inl;
--=20
2.26.2

