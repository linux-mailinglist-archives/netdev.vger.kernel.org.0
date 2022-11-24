Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD5637370
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKXILv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKXIL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF65E0DDE
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2720962025
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70285C433D6;
        Thu, 24 Nov 2022 08:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277468;
        bh=R4JiAPI28E1hOhytrSwHXDipciCy71PfznjxVB5Ts1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ0Zy9w1ccF0z29HhmIG585qcAqfArTw2yQ4v4HGlMtCt+MvxzuZ2miSdgNMVkdw1
         LNflhyTeetCifzLTgICN/wbXZL9qjMGRjRQmn1xr2zdYe6OFTMHrTzmanmNU6ncfTT
         puQz34V7tW71HHygDZhePRadZ1zuL2B1vcNebpuBU58rHSznTpn2mLdGLrGOCjyFWt
         MRbN/ev64AksGHbHPPgUlym2+kLSg+v+pR3GfKfx5fpLQ2aSLPV2SCFNskamVWcyEV
         FA/yCqw2L7yAxp50SIwUKQwJTRRdoq8PAUhXf8vrMxzdcVc5idGGg49D76R9Xv2dXP
         u121ztqJv00ig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 15/15] net/mlx5e: MACsec, block offload requests with encrypt off
Date:   Thu, 24 Nov 2022 00:10:40 -0800
Message-Id: <20221124081040.171790-16-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently offloading MACsec with authentication only (encrypt
property set to off) is not supported, block such requests
when adding/updating a macsec device.

Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 137b34347de1..0d6dc394a12a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -458,6 +458,11 @@ static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
 		return false;
 	}
 
+	if (!ctx->secy->tx_sc.encrypt) {
+		netdev_err(netdev, "MACsec offload: encrypt off isn't supported\n");
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.38.1

