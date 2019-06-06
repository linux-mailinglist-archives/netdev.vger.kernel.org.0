Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2338012
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfFFV5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFFV5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:57:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BD85128B5;
        Thu,  6 Jun 2019 21:57:20 +0000 (UTC)
Received: from dhcppc1.redhat.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ADB47C45F;
        Thu,  6 Jun 2019 21:57:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 1/3] net/mlx5e: use indirect calls wrapper for skb allocation
Date:   Thu,  6 Jun 2019 23:56:48 +0200
Message-Id: <bea5d7ef445ebbe740f0a62517eeb04e38ef7c90.1559857734.git.pabeni@redhat.com>
In-Reply-To: <cover.1559857734.git.pabeni@redhat.com>
References: <cover.1559857734.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 06 Jun 2019 21:57:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can avoid an indirect call per packet wrapping the skb creation
with the appropriate helper.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 13133e7f088e..0fe5f13d07cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -34,6 +34,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
+#include <linux/indirect_call_wrapper.h>
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
 #include <net/inet_ecn.h>
@@ -1092,7 +1093,10 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
-	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
+	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+			      mlx5e_skb_from_cqe_linear,
+			      mlx5e_skb_from_cqe_nonlinear,
+			      rq, cqe, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1279,8 +1283,10 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	cqe_bcnt = mpwrq_get_cqe_byte_cnt(cqe);
 
-	skb = rq->mpwqe.skb_from_cqe_mpwrq(rq, wi, cqe_bcnt, head_offset,
-					   page_idx);
+	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
+			      mlx5e_skb_from_cqe_mpwrq_linear,
+			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
+			      rq, wi, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
@@ -1437,7 +1443,10 @@ void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
-	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
+	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+			      mlx5e_skb_from_cqe_linear,
+			      mlx5e_skb_from_cqe_nonlinear,
+			      rq, cqe, wi, cqe_bcnt);
 	if (!skb)
 		goto wq_free_wqe;
 
@@ -1469,7 +1478,10 @@ void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
-	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
+	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+			      mlx5e_skb_from_cqe_linear,
+			      mlx5e_skb_from_cqe_nonlinear,
+			      rq, cqe, wi, cqe_bcnt);
 	if (unlikely(!skb)) {
 		/* a DROP, save the page-reuse checks */
 		mlx5e_free_rx_wqe(rq, wi, true);
-- 
2.20.1

