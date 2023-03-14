Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C319F6B8ABD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCNFnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCNFnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE421F5C4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E975EB81892
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C933C433EF;
        Tue, 14 Mar 2023 05:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772568;
        bh=oB6mzBG5425wZSu3pWsfj7IEjIo8Ni2Rj2hYamSdBns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+0qKum5qovUtjCgFVWBF+C0zshomMBA69VUOs0Hm0tf2M6Rhv9HR/9RQ/vTxz4FJ
         eDV2kTuWhbDWCVHB4ZeWgPJQjR9DaNelhbsHZrqoWQf+iVbHHMybp2dmm6cMCxl6ld
         rIK1LXoLgdyrvxWNOJt/vCgTuyNR2oYL8wBhrijtn5Ta0lICeEMGpsBA6nbbJLa+jy
         rb4qnI5wwLmOtc8qs3kqKgQWuhinjsfVKYaeCbPTBgL421rG337GznXjfEYOeVbGBG
         YlVS58RxzlJDXJob4wG5GzYDvFlLY7XSGO+EzTqPCT7dKWmtQ3ejUkunuKSYkWwaIz
         +ERjOWAIeWtow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Correct SKB room check to use all room in the fifo
Date:   Mon, 13 Mar 2023 22:42:24 -0700
Message-Id: <20230314054234.267365-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Previous check was comparing against the fifo mask. The mask is size of the
fifo (power of two) minus one, so a less than or equal comparator should be
used for checking if the fifo has room for the SKB.

Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index b9c2f67d3794..816ea83e6413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -86,7 +86,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) <= fifo->mask;
 }
 
 static inline bool
-- 
2.39.2

