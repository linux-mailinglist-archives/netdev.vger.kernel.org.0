Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE55633350
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiKVC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKVC3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:29:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752902CDC1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D7061545
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E65C433D6;
        Tue, 22 Nov 2022 02:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084115;
        bh=PNP+9agWu9IpFwa4uMo9Q/btguOfuRqkBXWcV2FYsQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3PAuarIDuZD7a9ZGOs4DxCHVAwZcQ0kZuxsu81Kxx9u8IJPzjFUrunMVTsQBe9sC
         YcuZJTZplZcuPDP4sgTuMQxcfYFxZU+jcYGC3RzAdUKT8Xjri42VLWSG0meDYzM/7p
         /OoxZeH142x/Kw5+dSsuz/E04d+JWGA8jsP8UYliRAQxGzobssW3WN+25zee24+hgK
         kFtsSwVfNQH8Ben+Aet7hfaKOMVf6F2lI4Ugipkf6WavVdEB/Mb4uFQp5rlKztuw06
         zc4Hx7Vn5h4gP/c/jgQtkU3jORlcvEiQwDz+rdKtBdn7mOgEdghW5FtSmce4NNoO6K
         lG06lESInlg7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 12/14] net/mlx5e: Fix MACsec SA initialization routine
Date:   Mon, 21 Nov 2022 18:25:57 -0800
Message-Id: <20221122022559.89459-13-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently as part of MACsec SA initialization routine
extended packet number (EPN) object attribute is always
being set without checking if EPN is actually enabled,
the above could lead to a NULL dereference.
Fix by adding such a check.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 2ef36cb9555a..8f8a735a4501 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -368,15 +368,15 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	obj_attrs.aso_pdn = macsec->aso.pdn;
 	obj_attrs.epn_state = sa->epn_state;
 
-	if (is_tx) {
-		obj_attrs.ssci = cpu_to_be32((__force u32)ctx->sa.tx_sa->ssci);
-		key = &ctx->sa.tx_sa->key;
-	} else {
-		obj_attrs.ssci = cpu_to_be32((__force u32)ctx->sa.rx_sa->ssci);
-		key = &ctx->sa.rx_sa->key;
+	key = (is_tx) ? &ctx->sa.tx_sa->key : &ctx->sa.rx_sa->key;
+
+	if (sa->epn_state.epn_enabled) {
+		obj_attrs.ssci = (is_tx) ? cpu_to_be32((__force u32)ctx->sa.tx_sa->ssci) :
+					   cpu_to_be32((__force u32)ctx->sa.rx_sa->ssci);
+
+		memcpy(&obj_attrs.salt, &key->salt, sizeof(key->salt));
 	}
 
-	memcpy(&obj_attrs.salt, &key->salt, sizeof(key->salt));
 	obj_attrs.replay_window = ctx->secy->replay_window;
 	obj_attrs.replay_protect = ctx->secy->replay_protect;
 
-- 
2.38.1

