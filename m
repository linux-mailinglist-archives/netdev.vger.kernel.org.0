Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAF225CBB8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgICVAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:44 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19839 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbgICVAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5158f90005>; Thu, 03 Sep 2020 13:58:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 03 Sep 2020 14:00:42 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:35 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 01/10] net/mlx5e: Refactor inline header size calculation in the TX path
Date:   Thu, 3 Sep 2020 14:00:13 -0700
Message-ID: <20200903210022.22774-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903210022.22774-1-saeedm@nvidia.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599166713; bh=uDmL2jQVJ3b0zDRMH62Otq7zYXd1niay82uovqNxgqM=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=bnxB0RMS4lB/Eom6bJXMiipbE6QiwdC8F2xSYqkxLAwRq4EW6Qy+QkDlJNROwNLQN
         FMdeeX0Cik0j7BXe7wOi5h+txTKyuQMlJ3dKtvd/HzlURUiQqdWKOgG8KDoifetGDt
         4XGenPez/sUUuSGvmhozgLpLTlEX8lsT2aUoA0yBzLU97B3dIyb1do+F1da8tNmdkM
         aUtHYCX8ej+mNC0VIASkT9cX4ooHz6/5e50XJYSm/qdWwCadT5VpROY5mlXyIhWLTt
         G0F4hGwvIvWkzUaUJNAs0HrYvgfJUUfRf/UvhPERApn/JALhYwy0cHbJRmxcUS3wxl
         73gZ6DFy3SpKA==
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

