Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF9637367
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKXILa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKXILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E60ADEAC0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29976B82702
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF1DC433D6;
        Thu, 24 Nov 2022 08:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277462;
        bh=xqr5DxSoiFwakgPHkQoo/BMGLoVgiYTyG32XcS+nrNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUO7Qk+lvyMHaBWCs1Z+Hz6mK1C4P5FIhEbGJabJ2YFcz+fRlQCuTyNEqrRY23q5z
         GRut9tBpWxE/m+vNOKgIkNYBhU5eyCsiMoIFz/I4TJjkUEL7Xtd+oTx2pKIVJXRvEg
         oK5NEq8qgyc2j12gGoZ8LOWxucH2gOP+OLE3DcAo3ST7IDSivk7z1Q6TJPjQIZckQg
         LC6bRLaSko6lcdmrObUAgKVXcWP4qTiJfYS/KJSdOpDXt014//ywtkGmTreD31EiNp
         YkkvpsXz8zLMmNWgZlOqMXWTILcwcwQeH9PlHmFkToyQoI6OAqUqNu/T+2DgKWYdgq
         nvvEDRAoDSTpw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [net 10/15] net/mlx5e: MACsec, fix update Rx secure channel active field
Date:   Thu, 24 Nov 2022 00:10:35 -0800
Message-Id: <20221124081040.171790-11-saeed@kernel.org>
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

The main functionality for this operation is to update the
active state of the Rx security channel (SC) if the new
active setting is different from the current active state
of this Rx SC, however the relevant active state check is
done post updating the current active state to match the
new active state, effectively blocks any offload state
update for the Rx SC in question.

Fix by delay the assignment to be post the relevant check.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index b51de07d5bad..9c891a877998 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -803,10 +803,10 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 		goto out;
 	}
 
-	rx_sc->active = ctx_rx_sc->active;
 	if (rx_sc->active == ctx_rx_sc->active)
 		goto out;
 
+	rx_sc->active = ctx_rx_sc->active;
 	for (i = 0; i < MACSEC_NUM_AN; ++i) {
 		rx_sa = rx_sc->rx_sa[i];
 		if (!rx_sa)
-- 
2.38.1

