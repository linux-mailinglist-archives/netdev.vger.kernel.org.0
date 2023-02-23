Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A386A1315
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBWWxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjBWWxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E747515C89
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5BD2B81A93
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C4C4339E;
        Thu, 23 Feb 2023 22:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192782;
        bh=f9ZHLIeeMOuFE6mbpLGDLQEC0ReZHO5ys0oQefXP0aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDeyDV5hjSJ0xP5aDa12K/izik0uOgyw9BxZk8LuVHR1+25tL97tr7MYnRSBBRx9J
         rl+o1YM8VDhOnuoAKxj4w5s8ziHaHjtY91etPozOKtlQbz9D3RdLqYQMUsUYjABBdm
         sEy3txbQCWaxg9nTI4anQrr0AaqRR+D0VCNJsnM+IXQfcLZIhgIH3K6XbOimmz0oqO
         DEGhP6in/nUXnDt3Ga4s4QPXor0Qdod5wovS1L9jGew8vhQolEImxw1WH4OCRHKCjD
         8fPNrSpEi9UlPn0USOK4ngo6scjfYJEXrsaHf95WnJUGmSSONvsCOvHo6NCyvm9b7F
         ID4UTujU7qZ+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [net 07/10] net/mlx5e: Correct SKB room check to use all room in the fifo
Date:   Thu, 23 Feb 2023 14:52:44 -0800
Message-Id: <20230223225247.586552-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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
2.39.1

