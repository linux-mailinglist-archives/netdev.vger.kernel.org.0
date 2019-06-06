Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4968038014
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfFFV5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFFV5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:57:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD1EB356EA;
        Thu,  6 Jun 2019 21:57:23 +0000 (UTC)
Received: from dhcppc1.redhat.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 951887C45F;
        Thu,  6 Jun 2019 21:57:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper for the rx packet handler
Date:   Thu,  6 Jun 2019 23:56:50 +0200
Message-Id: <fe1dffe13521e0b89969301f7b34fdb19964dbdb.1559857734.git.pabeni@redhat.com>
In-Reply-To: <cover.1559857734.git.pabeni@redhat.com>
References: <cover.1559857734.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 06 Jun 2019 21:57:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can avoid another indirect call per packet wrapping the rx
handler call with the proper helper.

To ensure that even the last listed direct call experience
measurable gain, despite the additional conditionals we must
traverse before reaching it, I tested reversing the order of the
listed options, with performance differences below noise level.

Together with the previous indirect call patch, this gives
~6% performance improvement in raw UDP tput.

v1 -> v2:
 - update the direct call list and use a macro to define it,
   as per Saeed suggestion. An intermediated additional
   macro is needed to allow arg list expansion

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3a183d690e23..52bcdc87cbe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -148,6 +148,10 @@ struct page_pool;
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
+#define MLX5_RX_INDIRECT_CALL_LIST \
+	mlx5e_handle_rx_cqe_mpwrq, mlx5e_handle_rx_cqe, mlx5i_handle_rx_cqe, \
+	mlx5e_ipsec_handle_rx_cqe
+
 #define mlx5e_dbg(mlevel, priv, format, ...)                    \
 do {                                                            \
 	if (NETIF_MSG_##mlevel & (priv)->msglevel)              \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0fe5f13d07cc..7faf643eb1b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1303,6 +1303,8 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
 
+#define INDIRECT_CALL_LIST(f, list, ...) INDIRECT_CALL_4(f, list, __VA_ARGS__)
+
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 {
 	struct mlx5e_rq *rq = container_of(cq, struct mlx5e_rq, cq);
@@ -1333,7 +1335,8 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 		mlx5_cqwq_pop(cqwq);
 
-		rq->handle_rx_cqe(rq, cqe);
+		INDIRECT_CALL_LIST(rq->handle_rx_cqe,
+				   MLX5_RX_INDIRECT_CALL_LIST, rq, cqe);
 	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
 
 out:
-- 
2.20.1

