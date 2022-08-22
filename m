Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B592C59C973
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiHVUAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiHVT7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8647052E62
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0E361237
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD42C433D6;
        Mon, 22 Aug 2022 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661198373;
        bh=u0lbqVwH/4MvSc09o17KMfSdGPa+NEztp4JGbbi4VBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiYZNPyA0YxlRFonaZuVH8AtYmC0rARdMHaXoiQGkOxrkio5MWKrF4rbstB6bsK4F
         onPI9cvqB20PcRJv1F8nPjE31/4lZTSiUM2LO09OaF7Pvw52CTs6OzoeljwRtWRxIs
         PqX7myt++C272Pbbp18mpKYfOdjxg7fAt+qpvy7Wr1us6yZClbTsx8IfNIJPtyFble
         VbxtOMFJIBdSqbmXqKCbzpC8THPP5WUO+o4MCj4QY906Xr4ofz5Emru5m4sTybPuOT
         VKDqjH4LdAVDa/v6jQVaxSSLjOxrCGfDSuwXFdRr4CEON+s1pbf8sU9MiyMH7ZBWGw
         hA22h/QOULZiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Roy Novich <royno@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 05/13] net/mlx5: Fix cmd error logging for manage pages cmd
Date:   Mon, 22 Aug 2022 12:59:09 -0700
Message-Id: <20220822195917.216025-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822195917.216025-1-saeed@kernel.org>
References: <20220822195917.216025-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Novich <royno@nvidia.com>

When the driver unloads, give/reclaim_pages may fail as PF driver in
teardown flow, current code will lead to the following kernel log print
'failed reclaiming pages: err 0'.

Fix it to get same behavior as before the cited commits,
by calling mlx5_cmd_check before handling error state.
mlx5_cmd_check will verify if the returned error is an actual error
needed to be handled by the driver or not and will return an
appropriate value.

Fixes: 8d564292a166 ("net/mlx5: Remove redundant error on reclaim pages")
Fixes: 4dac2f10ada0 ("net/mlx5: Remove redundant notify fail on give pages")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index ec76a8b1acc1..60596357bfc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -376,8 +376,8 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 			goto out_dropped;
 		}
 	}
+	err = mlx5_cmd_check(dev, err, in, out);
 	if (err) {
-		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_warn(dev, "func_id 0x%x, npages %d, err %d\n",
 			       func_id, npages, err);
 		goto out_dropped;
@@ -524,10 +524,13 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		dev->priv.reclaim_pages_discard += npages;
 	}
 	/* if triggered by FW event and failed by FW then ignore */
-	if (event && err == -EREMOTEIO)
+	if (event && err == -EREMOTEIO) {
 		err = 0;
+		goto out_free;
+	}
+
+	err = mlx5_cmd_check(dev, err, in, out);
 	if (err) {
-		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_err(dev, "failed reclaiming pages: err %d\n", err);
 		goto out_free;
 	}
-- 
2.37.1

