Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21C663920
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbjAJGM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjAJGMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EEF43A2F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548E8614E5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0C1C433EF;
        Tue, 10 Jan 2023 06:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331112;
        bh=A2FtlxvhVni3+Q/68Bwt84O/kLNzEDqvZEBfXhLWuXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAzI5ukdP2ibnjxojSWhhCY/ywQ2WsJ1537IJ416FMHJ8EGKgkuJ37Xe9+QWaF6rD
         6ttXytC+Fx0C5Doaig3Ntt9pbXVnWeyUouFaiFyqaTPtIfxh79Vmhis8NdyqYtkrfk
         3isLAwgf0H6INu5VnVa/2/qVpsSZudqiUjQZ2LupB+qH+TSq3KIEM/C0iTskuDH6+H
         fg6p6T4eF8YkK65ho6ZbLgYnvJK6rHpzgj0xYeRzPkAdlR1JDeiQMhXEN2bMdBur3/
         k5nJL0hd72R/j4iCQPXQhxLLwAulk1bIM6mAbghH+UXvndDNA+NvbGWrmNz3SmCnXE
         3Ga8kbK7vzwHA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 16/16] net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)
Date:   Mon,  9 Jan 2023 22:11:23 -0800
Message-Id: <20230110061123.338427-17-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Upon updating MAC security entity (SecY) in hw offload path, the macsec
security association (SA) initialization routine is called. In case of
extended packet number (epn) is enabled the salt and ssci attributes are
retrieved using the MACsec driver rx_sa context which is unavailable when
updating a SecY property such as encoding-sa hence the null dereference.
Fix by using the provided SA to set those attributes.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index cf7b3bb54c86..7f6b940830b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -359,7 +359,6 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_macsec_obj_attrs obj_attrs;
 	union mlx5e_macsec_rule *macsec_rule;
-	struct macsec_key *key;
 	int err;
 
 	obj_attrs.next_pn = sa->next_pn;
@@ -369,13 +368,9 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 	obj_attrs.aso_pdn = macsec->aso.pdn;
 	obj_attrs.epn_state = sa->epn_state;
 
-	key = (is_tx) ? &ctx->sa.tx_sa->key : &ctx->sa.rx_sa->key;
-
 	if (sa->epn_state.epn_enabled) {
-		obj_attrs.ssci = (is_tx) ? cpu_to_be32((__force u32)ctx->sa.tx_sa->ssci) :
-					   cpu_to_be32((__force u32)ctx->sa.rx_sa->ssci);
-
-		memcpy(&obj_attrs.salt, &key->salt, sizeof(key->salt));
+		obj_attrs.ssci = cpu_to_be32((__force u32)sa->ssci);
+		memcpy(&obj_attrs.salt, &sa->salt, sizeof(sa->salt));
 	}
 
 	obj_attrs.replay_window = ctx->secy->replay_window;
-- 
2.39.0

