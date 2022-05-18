Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7792852B279
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiERGfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiERGet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C92E732A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF8E0B81E97
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BDFC385A5;
        Wed, 18 May 2022 06:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855683;
        bh=6RX38PTogMqBCoxL6IVoMVc9ZZyqDGD+JmwMnqv+PU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJA/WcobQ7FWEWeojPA9tZNvbkiY4Io3+IuQh0rxseer0XndVwG+DNHMCXZtr2nqt
         7EfsCTJMeZU1LqKGhxlbRaKFqaTlrLL3GJ9U0X88enS44/bRrtf8zooJDQZ81JB+hX
         1kF8sa7rsjfc0uylLXiXsMlhb5FoXcGWoujEqUsigxk+5os6zpQhnVdcHCQ0XN+4K7
         P9/qc+bsFdPx5VOsFTUQxaZTgEFeWlQqtGFaxmocwQLqTzT57Q8ERk1lpaA45xnuya
         Aj0KUqsS0S++lBnE3tF5myoSbD6J2uJRTJDmEDW01jRLciBHn/AyO4lnybgMpYg50U
         HOwszrg3CoMjw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/11] net/mlx5e: Wrap mlx5e_trap_napi_poll into rcu_read_lock
Date:   Tue, 17 May 2022 23:34:20 -0700
Message-Id: <20220518063427.123758-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The body of mlx5e_napi_poll is wrapped into rcu_read_lock to be able to
read the XDP program pointer using rcu_dereference. However, the trap RQ
NAPI doesn't use rcu_read_lock, because the trap RQ works only in the
non-linear mode, and mlx5e_skb_from_cqe_nonlinear, until recently,
didn't support XDP and didn't call rcu_dereference.

Starting from the cited commit, mlx5e_skb_from_cqe_nonlinear supports
XDP and calls rcu_dereference, but mlx5e_trap_napi_poll doesn't wrap it
into rcu_read_lock. It leads to RCU-lockdep warnings like this:

    WARNING: suspicious RCU usage

This commit fixes the issue by adding an rcu_read_lock to
mlx5e_trap_napi_poll, similarly to mlx5e_napi_poll.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index a55b066746cb..857840ab1e91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -14,19 +14,26 @@ static int mlx5e_trap_napi_poll(struct napi_struct *napi, int budget)
 	bool busy = false;
 	int work_done = 0;
 
+	rcu_read_lock();
+
 	ch_stats->poll++;
 
 	work_done = mlx5e_poll_rx_cq(&rq->cq, budget);
 	busy |= work_done == budget;
 	busy |= rq->post_wqes(rq);
 
-	if (busy)
-		return budget;
+	if (busy) {
+		work_done = budget;
+		goto out;
+	}
 
 	if (unlikely(!napi_complete_done(napi, work_done)))
-		return work_done;
+		goto out;
 
 	mlx5e_cq_arm(&rq->cq);
+
+out:
+	rcu_read_unlock();
 	return work_done;
 }
 
-- 
2.36.1

