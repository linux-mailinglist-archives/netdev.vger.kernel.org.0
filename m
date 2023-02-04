Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680B168A959
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjBDKJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjBDKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F73A6A720
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E9A2B80AB7
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A86C433EF;
        Sat,  4 Feb 2023 10:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505367;
        bh=9iG3W8xbCR+zHg/F45QyrcVd2PRxJi6Vc8KqAnrZuho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfn/hOT1aR/4qPSWwb/BLSaJrk+L5s2B1BfftADgp1dd0oxRPd1RwkXEkzpk/0skP
         aNuhnRLet7GlUwldR+/Kp8zGYAXeHW1qttgQAryjq2VqS8u7Y+NCmc9fx5rvWhYicg
         MgeyYGiikdsEKbhF2djyX4Xq/T+zPThDBI1uLRvY2+UdDClT3WQ/7MQh1uan95RDW7
         9EDxrlkjSu3LBOqVYkAae7SMoJ0qNGMpDqCCZEOKOG7sEs5wE0o9edgWh+dTyRjYLK
         VqM2c2fVudC8283NhUbDt7hA/GZQm+hzJv6Rpn7Poo3Pn7urTMGp7UrgLM0lBeuquZ
         YXG+onhkDiTcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jack Morgenstein <jackm@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Majd Dibbiny <majd@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Enhance debug print in page allocation failure
Date:   Sat,  4 Feb 2023 02:08:51 -0800
Message-Id: <20230204100854.388126-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Jack Morgenstein <jackm@nvidia.com>

Provide more details to aid debugging.

Fixes: bf0bf77f6519 ("mlx5: Support communicating arbitrary host page size to firmware")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Majd Dibbiny <majd@nvidia.com>
Signed-off-by: Jack Morgenstein <jackm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 60596357bfc7..96e57f1812a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -211,7 +211,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u32 function)
 
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
-- 
2.39.1

