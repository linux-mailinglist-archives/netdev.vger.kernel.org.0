Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8E93935B0
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhE0S6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236061AbhE0S6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5F3611C9;
        Thu, 27 May 2021 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141797;
        bh=47XmjZ9lIAGJGFHkUS4jO8otskT8KMwjqhqghWzDZSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfMY6iPcUVKUdyO5B2pfbWZ47uwXIrfym8b0C9XKET591t228aNULlZkq6YP1obkc
         2tqj3maR8UjCl1JGRV/VYv0qSjxeFOo7TJssyzQ/wrVhkr/u7eiq5oYAPQM2wMPbS8
         ZSAIUGEOBsK5gV4cSWS1rZ8oVJXQ0jwC0GiVzt+Fs8N2WZCRlJiCqdDAluHkjYHyKe
         PSGHGv4HDpK8NsSFzaritcSOXqZ/G96iUEtu7I7XAALrLAdhH5s2MwaMbmmW0mL0bm
         S642VPki5+RziVCCCce6fqH2YKlqzs2cmqsYyJwZ5oyEfi/IfobwxcWfTDP97H4/qF
         f2FWnQH4trTzg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 06/15] net/mlx5e: RX, Remove unnecessary check in RX CQE compression handling
Date:   Thu, 27 May 2021 11:56:15 -0700
Message-Id: <20210527185624.694304-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

There are two reasons for exiting mlx5e_decompress_cqes_cont():
1. The compression session is completed (cqd.left == 0).
2. The budget is exhausted (work_done == budget).

If after calling mlx5e_decompress_cqes_cont() we have cqd.left > 0,
it necessarily implies that budget is exhausted.

The first part of the complex condition is covered by the second,
hence we remove it here.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5346271974f5..e88429356018 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1560,7 +1560,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 	if (rq->cqd.left) {
 		work_done += mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
-		if (rq->cqd.left || work_done >= budget)
+		if (work_done >= budget)
 			goto out;
 	}
 
-- 
2.31.1

