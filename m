Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619A966391C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjAJGM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjAJGMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A29E43A25
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA109B8110A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB85C433EF;
        Tue, 10 Jan 2023 06:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331107;
        bh=gboYU+fKVvkDhH1yhpc9k/ONtXghAuKa2+Xo+uSkZSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqiI7vNjEgIPKMzOT/xbTtVmU0rhWHtq89IIHUqSEpBlydgBBZfQpUGoCiyGTDwL4
         GE9YxJMwfCXQWIHz00H1tBop6q7G+oljpey83oFh5o7zH8kZVCftGnqUHf8qK7aFWE
         lPYMFz0K1xn0TgrH21qLFM/a29lrUf32x5hWbve8dcmOuJYYcso8bxGH0rMtSE+Q+e
         ay1W1BgSs8aiBrQ6PIrpIRtTugVlK6XJcMDe4Ujk+E2ZziwsPWMo1QpBWaShch37RJ
         Fz9EE5vLFTE5sEbHp3/Zz35fEiJbg1XyC22uPonC1SUdU1+meBvibNvsNmZ8n31jXL
         xhpvrhl1l82yA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 11/16] net/mlx5e: Fix memory leak on updating vport counters
Date:   Mon,  9 Jan 2023 22:11:18 -0800
Message-Id: <20230110061123.338427-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When updating statistics driver queries the vport's counters. On fail,
add error path releasing the allocated buffer avoiding memory leak.

Fixes: 64b68e369649 ("net/mlx5: Refactor and expand rep vport stat group")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 75b9e1528fd2..7d90e5b72854 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -191,7 +191,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 	if (err) {
 		netdev_warn(priv->netdev, "vport %d error %d reading stats\n",
 			    rep->vport, err);
-		return;
+		goto out;
 	}
 
 	#define MLX5_GET_CTR(p, x) \
@@ -241,6 +241,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 	rep_stats->tx_vport_rdma_multicast_bytes =
 		MLX5_GET_CTR(out, received_ib_multicast.octets);
 
+out:
 	kvfree(out);
 }
 
-- 
2.39.0

