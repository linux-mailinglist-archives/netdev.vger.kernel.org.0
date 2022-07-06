Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DA15695CF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiGFXY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiGFXYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72DC2C120
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BA6061E9E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A488DC3411C;
        Wed,  6 Jul 2022 23:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149877;
        bh=KIWUBJoZz8uQ6PoD81n2yyN3rfekEBPJlhdqE6jHEIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL3mzGF5wU24sXLSwt3urekGJc0K6UTrWXtOCtrHwSwrVrrmYLH8Fl9RjXbErVqOW
         UxOWg/z/2D/PoTCIRpI87kJINQHjikWdhWUemE25PCU8xCR6HunFtad7RrhqsalVCH
         jCNzpuWbHKsNUoz+mKvMGvBBdmkrwv2Cgvy1FZWj6aYxMIGBJu772Q0JRaHBMydT4y
         F3BG/WIt0VMCs1CToVKxgsj+84iiEpSHUEftd7LKy4nk4y9B4SjQWyHp6G+jshDC/F
         dsz//CLczzT6n7DdPBK8c/x/L35xLO//ThDYPDCZ49ZpJcjoklkgm9Lu0DcPDB0KJ4
         WHOrLsiw5QCVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: kTLS, Take stats out of OOO handler
Date:   Wed,  6 Jul 2022 16:24:19 -0700
Message-Id: <20220706232421.41269-14-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Let the caller of mlx5e_ktls_tx_handle_ooo() take care of updating the
stats, according to the returned value.  As the switch/case blocks are
already there, this change saves unnecessary branches in the handler.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 2cd0437666d2..99e1cd015083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -382,26 +382,17 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 int datalen,
 			 u32 seq)
 {
-	struct mlx5e_sq_stats *stats = sq->stats;
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
-	int i = 0;
+	int i;
 
 	ret = tx_sync_info_get(priv_tx, seq, datalen, &info);
-	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE)) {
-		if (ret == MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
-			stats->tls_skip_no_sync_data++;
-			return MLX5E_KTLS_SYNC_SKIP_NO_DATA;
-		}
-		/* We might get here if a retransmission reaches the driver
-		 * after the relevant record is acked.
+	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE))
+		/* We might get here with ret == FAIL if a retransmission
+		 * reaches the driver after the relevant record is acked.
 		 * It should be safe to drop the packet in this case
 		 */
-		stats->tls_drop_no_sync_data++;
-		goto err_out;
-	}
-
-	stats->tls_ooo++;
+		return ret;
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
 
@@ -413,7 +404,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		return MLX5E_KTLS_SYNC_DONE;
 	}
 
-	for (; i < info.nr_frags; i++) {
+	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
 
@@ -483,15 +474,19 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		enum mlx5e_ktls_sync_retval ret =
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
 
+		stats->tls_ooo++;
+
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
+			stats->tls_skip_no_sync_data++;
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
-			fallthrough;
+			goto err_out;
 		case MLX5E_KTLS_SYNC_FAIL:
+			stats->tls_drop_no_sync_data++;
 			goto err_out;
 		}
 	}
-- 
2.36.1

