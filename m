Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164E837493D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhEEUVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhEEUVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 16:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8EA7613D8;
        Wed,  5 May 2021 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620246028;
        bh=z8VC0srcx82bOMsnWf+lvtroe+Ov7KDlN6HSXpf4o60=;
        h=From:To:Cc:Subject:Date:From;
        b=ejnywMT/sM6UhDzRqDSit309HLMgyZr/LnjHzerLvv8xZiZMyu81Kbt0QBBAV06Zo
         SmWH0xbCSdGqNb+gkezueg5nksTC5PPbE0DwUfT8b3T0UnXdYQe5JiEeqlT92F1TEo
         slgWlfLoauzW69eZZT6S0IMY6RfsaqlwV9Pa/ln0AxutYQpEObTJ+3kasaxX4gQnUg
         zCN4JKoMmUAkuS7haE+tChPv0PbRaD81xRCwfkheazfXyBUSqGOM7eLljmCVHa16o2
         MuZTeJaIMT2wz4hRtVyBg8lO9iKuQxnLHbkjHQJYnpo3g34NgZ5zBFk9YPI3bAFwLE
         8stCxJGzKT6ng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@nvidia.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] mlx5e: add add missing BH locking around napi_schdule()
Date:   Wed,  5 May 2021 13:20:26 -0700
Message-Id: <20210505202026.778635-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not correct to call napi_schedule() in pure process
context. Because we use __raise_softirq_irqoff() we require
callers to be in a context which will eventually lead to
softirq handling (hardirq, bh disabled, etc.).

With code as is users will see:

 NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!

Fixes: a8dd7ac12fc3 ("net/mlx5e: Generalize RQ activation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
We may want to patch net-next once it opens to switch
from __raise_softirq_irqoff() to raise_softirq_irqoff().
The irq_count() check is probably negligable and we'd need
to split the hardirq / non-hardirq paths completely to
keep the current behaviour. Plus what's hardirq is murky
with RT enabled..

Eric WDYT?

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bca832cdc4cb..11e50f5b3a1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -889,10 +889,13 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	if (rq->icosq)
+	if (rq->icosq) {
 		mlx5e_trigger_irq(rq->icosq);
-	else
+	} else {
+		local_bh_disable();
 		napi_schedule(rq->cq.napi);
+		local_bh_enable();
+	}
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
-- 
2.31.1

