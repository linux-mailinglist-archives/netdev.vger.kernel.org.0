Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4E30E69
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfEaMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaMyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:54:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD4AC317465D;
        Fri, 31 May 2019 12:54:19 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCAA15DD91;
        Fri, 31 May 2019 12:54:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 3/3] net/mlx5e: use indirect calls wrapper for the rx packet handler
Date:   Fri, 31 May 2019 14:53:35 +0200
Message-Id: <74fb497974fe8267c2c5f0a1422a418363f0c50f.1559304330.git.pabeni@redhat.com>
In-Reply-To: <cover.1559304330.git.pabeni@redhat.com>
References: <cover.1559304330.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 31 May 2019 12:54:19 +0000 (UTC)
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

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0fe5f13d07cc..c3752dbe00c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1333,7 +1333,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 		mlx5_cqwq_pop(cqwq);
 
-		rq->handle_rx_cqe(rq, cqe);
+		INDIRECT_CALL_4(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_rep,
+				mlx5e_ipsec_handle_rx_cqe, rq, cqe);
 	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
 
 out:
-- 
2.20.1

