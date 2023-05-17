Return-Path: <netdev+bounces-3156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B669C705CBB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED861281283
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075AF17E0;
	Wed, 17 May 2023 01:59:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F4117D0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD79EC433D2;
	Wed, 17 May 2023 01:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288779;
	bh=7GJCCGO8Eewilp4PvhdKleoAFNChkkX+jFNLFZiL+gw=;
	h=From:To:Cc:Subject:Date:From;
	b=Aq7k2sjOn+37XlVTHKv7E6sCUm5IUuP5nQLURcYGNaJQe5p373Lk2Z2jQ6x1OnaEC
	 H68oylVYsal+XueXjCVDCkmBvrh4auB5boBev7jshzNykQfKRpohBsxcYKVjIKccJY
	 wiY3vtL0WdGJ4IyNJdOqFsqDcJaCksfRiPgbOeesfV9ZA0D9bThuaSynu8DESf/kgL
	 /kH/hRWezWw8x1SIf20pTZzjuUxqV8zB2KXNN3rEjFKPDz2R91agp73dh88CCLMr+a
	 Fuac2Mo9L27mj6BoPKvd9GYl+d3I+ekUy6BhyFMnn+fcUyIjawj+RqQSUYtn3/JKE7
	 0HafA/BZwEBkQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	saeedm@nvidia.com,
	leon@kernel.org,
	brouer@redhat.com
Subject: [PATCH net v2] net/mlx5e: do as little as possible in napi poll when budget is 0
Date: Tue, 16 May 2023 18:59:35 -0700
Message-Id: <20230517015935.1244939-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NAPI gets called with budget of 0 from netpoll, which has interrupts
disabled. We should try to free some space on Tx rings and nothing
else.

Specifically do not try to handle XDP TX or try to refill Rx buffers -
we can't use the page pool from IRQ context. Don't check if IRQs moved,
either, that makes no sense in netpoll. Netpoll calls _all_ the rings
from whatever CPU it happens to be invoked on.

In general do as little as possible, the work quickly adds up when
there's tens of rings to poll.

The immediate stack trace I was seeing is:

    __do_softirq+0xd1/0x2c0
    __local_bh_enable_ip+0xc7/0x120
    </IRQ>
    <TASK>
    page_pool_put_defragged_page+0x267/0x320
    mlx5e_free_xdpsq_desc+0x99/0xd0
    mlx5e_poll_xdpsq_cq+0x138/0x3b0
    mlx5e_napi_poll+0xc3/0x8b0
    netpoll_poll_dev+0xce/0x150

AFAIU page pool takes a BH lock, releases it and since BH is now
enabled tries to run softirqs.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I'm pointing Fixes at where page_pool was added, although that's
probably not 100% fair.

v2:
 - don't call napi_complete_done()
v1: https://lore.kernel.org/all/20230512025740.1068965-1-kuba@kernel.org/

CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: brouer@redhat.com
---
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c    | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index a50bfda18e96..fbb2d963fb7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -161,20 +161,22 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
+	/* budget=0 means we may be in IRQ context, do as little as possible */
+	if (unlikely(!budget))
+		goto out;
+
 	busy |= mlx5e_poll_xdpsq_cq(&c->xdpsq.cq);
 
 	if (c->xdp)
 		busy |= mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
 
-	if (likely(budget)) { /* budget=0 means: don't poll rx rings */
-		if (xsk_open)
-			work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
+	if (xsk_open)
+		work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
 
-		if (likely(budget - work_done))
-			work_done += mlx5e_poll_rx_cq(&rq->cq, budget - work_done);
+	if (likely(budget - work_done))
+		work_done += mlx5e_poll_rx_cq(&rq->cq, budget - work_done);
 
-		busy |= work_done == budget;
-	}
+	busy |= work_done == budget;
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
 	if (mlx5e_poll_ico_cq(&c->async_icosq.cq))
-- 
2.40.1


