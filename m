Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844F563736A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKXILd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiKXIL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F217E0B4C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C86A62021
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C045C433D7;
        Thu, 24 Nov 2022 08:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277467;
        bh=ngOciPUJe5/M2YpnHgptRooBZOkWQ9xUb2fdndN4qBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CznLA3GD5urGXM9Sj46Kr+ZyPI3KDshNUXUqysFEOO0m0Y5pSlVhRARxnPl06EFVm
         rxORDGOF02S3lFAVhU9q7l58EZzG/NH57ir3I1OQ3x5uHTKNoEkGCEz28DC15k8MhL
         LjcicV5hNrzX5qA9YmDnGZHqx7xajYSPKDpdVD4qCHfN9JE0aVqbckj19FgJxJXMF5
         wKUMDftsuUnAH0Oea6gyiUzh5kBz9nbwoujidP3c2whVKti9QPYcuDEYJmORRai5PV
         DZQWxhy2cAzdOJnwsLkaiimV5MYXfKXTbJkBJgNIP7s4uKXVkAYUvhLEHakMfFRnI8
         eC/y/QiSGNdWQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [net 14/15] net/mlx5e: MACsec, fix Tx SA active field update
Date:   Thu, 24 Nov 2022 00:10:39 -0800
Message-Id: <20221124081040.171790-15-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: Raed Salem <raeds@nvidia.com>

Currently during update Tx security association (SA) flow, the Tx SA
active state is updated only if the Tx SA in question is the same SA
that the MACsec interface is using for Tx,in consequence when the
MACsec interface chose to work with this Tx SA later, where this SA
for example should have been updated to active state and it was not,
the relevant Tx SA HW context won't be installed, hence the MACSec
flow won't be offloaded.

Fix by update Tx SA active state as part of update flow regardless
whether the SA in question is the same Tx SA used by the MACsec
interface.

Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 72f8be65fa90..137b34347de1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -602,6 +602,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 	if (tx_sa->active == ctx_tx_sa->active)
 		goto out;
 
+	tx_sa->active = ctx_tx_sa->active;
 	if (tx_sa->assoc_num != tx_sc->encoding_sa)
 		goto out;
 
@@ -617,8 +618,6 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 
 		mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
 	}
-
-	tx_sa->active = ctx_tx_sa->active;
 out:
 	mutex_unlock(&macsec->lock);
 
-- 
2.38.1

