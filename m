Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBED6E8C03
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbjDTIDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbjDTIDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984B2680
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33ADA6413B
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C444C433D2;
        Thu, 20 Apr 2023 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977785;
        bh=j2NEKxArP5vDlLGPeRhYIOj4vYMq7DHZ40wfLT8YvyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNW7YraGXD8FrobJP5agcnFW8aSzzclBupNXPH8QuQ6pFpZ9jhlgSQAMTiSAuSX/N
         KA42JhiwgkMUG4GgRim5Uq1j1xHHqho3TrXPCyvP9ZjqeajcpVLTp5WgF75j/TQUzg
         TcGrtSE8Vyo1XvcJ5OflaMax1Iv8tkScyJfM8j6BxVsYFhtNXKp6U2egCMyJja6/02
         o+wA7/PnIqsbSYCFPqDNpz7PQL/7ligc8VONERuu+/7/+56bkLU8DDyzfxd8HWaeYU
         N+ZSoJ/x6NFJTbh5CrArmmR4sac53cT3kLmkpW1qOgmDzDowQ99uVApkXuOxoWQt3J
         AN/Ph29Qgs3og==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6 address
Date:   Thu, 20 Apr 2023 11:02:49 +0300
Message-Id: <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
References: <cover.1681976818.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

Fix size argument in memcmp to compare whole IPv6 address.

Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index f7f7c09d2b32..4e9887171508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
 {
 	static const __be32 zaddr6[4] = {};
 
-	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
+	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
 }
 #else
 static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
-- 
2.40.0

