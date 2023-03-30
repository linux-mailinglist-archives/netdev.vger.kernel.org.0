Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C36CFDA1
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjC3IDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjC3IC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:02:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A001711
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF92261F45
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57D8C433D2;
        Thu, 30 Mar 2023 08:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163376;
        bh=p1/SL3+bHbDdHfDAkyQ3kNq3VMdYL7swaDiuEUrcQU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXrVdOQdbp7e8qKjwwPoqEOs9qAqW5dB3ZhdLjAB5R8MD/syQHJZFovfKfPK3Oeew
         /YRgjsBAx5Cw7sf+QqE72GVM5MWuRjYM4CLtKRR+/3l9TvishGKjluy/TfRUSo/OYS
         9b4m3mlMZNYjKOc06ACm/FGLZFTV5y2UTRoCZ3xOL0QdVOWh8gYcsaJ0Cq0i8uey+n
         8M7YUf4DF7FJSTtMQl7VurutIM7USsvkulU2x5/73zoZgHXk7tGXBh3uRTrQdKxYJw
         V62IckzXqr9RmdP7vsuTmhp42VXw3Pl9aaNKU6DygDlJ6kwwgcvQ+IlXY1jtY2uT73
         MBgUy4F+xz15w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 04/10] net/mlx5e: Overcome slow response for first IPsec ASO WQE
Date:   Thu, 30 Mar 2023 11:02:25 +0300
Message-Id: <eb92a758c533ff3f058e0dcb4f8d2324355304ad.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

First ASO WQE causes to cache miss in hardware, which can't return
result immediately. It causes to the situation where such WQE is polled
earlier than it is needed. Add logic to retry ASO CQ polling operation.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c  | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 684de9739e69..6971e5e36820 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -568,6 +568,7 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct mlx5_wqe_aso_ctrl_seg *ctrl;
 	struct mlx5e_hw_objs *res;
 	struct mlx5_aso_wqe *wqe;
+	unsigned long expires;
 	u8 ds_cnt;
 	int ret;
 
@@ -589,7 +590,12 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_aso_copy(ctrl, data);
 
 	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
-	ret = mlx5_aso_poll_cq(aso->aso, false);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		ret = mlx5_aso_poll_cq(aso->aso, false);
+		if (ret)
+			usleep_range(2, 10);
+	} while (ret && time_is_after_jiffies(expires));
 	spin_unlock_bh(&aso->lock);
 	return ret;
 }
-- 
2.39.2

