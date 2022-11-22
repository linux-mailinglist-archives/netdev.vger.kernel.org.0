Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456CD633351
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiKVC3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKVC3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:29:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDAF2E69E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B458A61534
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D2AC433C1;
        Tue, 22 Nov 2022 02:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084116;
        bh=IV99aF/LKZzKTFhC7P+bY9zyaQuPIcwTwHYGZfpAtnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaLoN8JaWRY7s4tBGrOtaKSPscRx9gG7dP3rgyoIE3RketrgIv3PkseqJA7SZgqPW
         yucGZIVygtw3OwZW1MTjd7FibapyWeueaNc0iA7y/zEQLcRT7/C942dmNJiuT198ex
         doAeyhO9u85hnkl+Iq1SrDwm3FTxiHAzjZbhr/NoYc1/6G27mJ4/OB4J7KFktl9p1u
         clUF0YSpAlc3iuvhU5LEN4ugXRekJZHRlzThXQuk4h4zvUCwISVOXyNQfikbbwjt7A
         5xhAXryRg3I6IxALhjxPTFD2nLO/etuDBJZ+k44zAvFuDNH7ug4RakF6q3iplhTu/L
         EHD1z9zuJ4Ong==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 13/14] net/mlx5e: Fix MACsec update SecY
Date:   Mon, 21 Nov 2022 18:25:58 -0800
Message-Id: <20221122022559.89459-14-saeed@kernel.org>
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

Currently updating SecY destroys and re-creates RX SA objects,
the re-created RX SA objects are not identical to the destroyed
objects and it disagree on the encryption enabled property which
holds the value false after recreation, this value is not
supported with offload which leads to no traffic after an update.
Fix by recreating an identical objects.

Fixes: 5a39816a75e5 ("net/mlx5e: Add MACsec offload SecY support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 8f8a735a4501..4f96c69c6cc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1155,7 +1155,7 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
 				continue;
 
 			if (rx_sa->active) {
-				err = mlx5e_macsec_init_sa(ctx, rx_sa, false, false);
+				err = mlx5e_macsec_init_sa(ctx, rx_sa, true, false);
 				if (err)
 					goto out;
 			}
-- 
2.38.1

