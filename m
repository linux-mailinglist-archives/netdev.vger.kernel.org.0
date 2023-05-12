Return-Path: <netdev+bounces-2007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7516FFF1E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05BBB2819EE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A577E9;
	Fri, 12 May 2023 02:57:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA75A32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF3C433A4;
	Fri, 12 May 2023 02:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683860264;
	bh=dr/P4ALyqIffrUps5OtJYbKlsGDmVwg40UNUtoVeBX0=;
	h=From:To:Cc:Subject:Date:From;
	b=OAEaAiGgHYth5dwfhh/WMI3qsza4RBadoAbIorXUvAGoVKts/wW6WJEipDVkUnEId
	 flIKtZNwlrMtnAaR4FMfS5EumH5huIgTa+pzLkVv36QPx33c7ohB1ZuxrLjy09mI1N
	 ubxD7aYh2Wv94bGOwZc9r7axr3NWDNM45ZWS8yETgGDsCbjPB5ZiHWct6NS4fXV9NT
	 EgWWTdP/WFE5Q8ydxx4mycJXJU08IwNxP1hVDIX4W68+qcl2giHkYtpJuvGKr/hJJt
	 4RX2xy84WIGqCLx0KnPMiRltIX+2/Qm14fW2VRS53cjImVaKDQHC4h4ht9qIQXfukg
	 2Gh//qwwRaUvQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	saeedm@nvidia.com,
	leon@kernel.org,
	brouer@redhat.com,
	tariqt@mellanox.com
Subject: [PATCH net] net/mlx5e: do as little as possible in napi poll when budget is 0
Date: Thu, 11 May 2023 19:57:40 -0700
Message-Id: <20230512025740.1068965-1-kuba@kernel.org>
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

Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I'm pointing Fixes at where page_pool was added, although that's
probably not 100% fair.

CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: brouer@redhat.com
CC: tariqt@mellanox.com
---
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index a50bfda18e96..bd4294dd72da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -161,20 +161,25 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
+	/* budget=0 means we may be in IRQ context, do as little as possible */
+	if (unlikely(!budget)) {
+		/* no work done, can't be asked to re-enable IRQs */
+		WARN_ON_ONCE(napi_complete_done(napi, work_done));
+		goto out;
+	}
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


