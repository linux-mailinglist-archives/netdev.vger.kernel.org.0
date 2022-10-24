Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32D60AEFF
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJXP0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiJXP0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4FFD38F1
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 07:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4439661280
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DC0C433C1;
        Mon, 24 Oct 2022 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620011;
        bh=pUIJr3od4lzsGcng9IWY+FNxYIrvxUgzQ3l80dlLSoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V66J4VwQsHD88HlTwn3HvbskmlxdkpsFU03QdY/iVq5exjGd9H3hiql/G+54WFNkR
         4nCn0hdCzs12esOcg1GXHUmOV4O/kAIizZzaQtcfYxVhhgF/W9Cp/tnk58+iW8NK+X
         DjQ0urLmBy5ttKel29A3uT6b2wZWkKW286n+AwVXhWOErtG3BrT9qAU4nvTlQK1GJv
         Ueu8QuTKP7O5Uvw7naQ993WmTC7HjC41DRt7p2TCCyida4vpvmedFv0naxVGSoS+vr
         pszNLNJkmLgQXCSqpH1AmqbqVTbN/exogoOWS3nk251TioSihiAssPsA86Oa27B+mX
         5Z2wtWALxFeuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Alex Vesker <valex@nvidia.com>
Subject: [net-next 01/14] net/mlx5: DR, In destroy flow, free resources even if FW command failed
Date:   Mon, 24 Oct 2022 14:57:21 +0100
Message-Id: <20221024135734.69673-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Otherwise resources will never be freed and refcount will not be decreased.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 31d443dd8386..eb81759244d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -292,7 +292,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 	mlx5dr_dbg_tbl_del(tbl);
 	ret = dr_table_destroy_sw_owned_tbl(tbl);
 	if (ret)
-		return ret;
+		mlx5dr_err(tbl->dmn, "Failed to destoy sw owned table\n");
 
 	dr_table_uninit(tbl);
 
-- 
2.37.3

