Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36405637369
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiKXILc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiKXILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303D3DB877
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E0162025
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10548C433D7;
        Thu, 24 Nov 2022 08:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277465;
        bh=ZliI0r77uWeGcxk+3zij3KiJ+z1mMo1LasP6KOXk55E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaAzwVX0r4H6h6tW04n5G69BWmgKH8IO230/LfZNZmtzX6ZcjfJTyOeQsmYj3gCys
         VYzyErqXw2kpfmXX1ebyEJDhSeQtAGmx1m9skyUJmBns55PiaLyaqAwXOK9kd8Jogi
         FS6s0asq5iKgEcQQgA6X81bZAR5f2hH1/4IqEuE9O4mgGeJrlKLCkX1BuOvrTqdMgk
         nPolFhtIYVWgiGZ4UTOJh8a+kBKDgYA9rG/e5kzH0Npr8YcFzzLGposvQH3z1UfPpn
         JOEXETYL7DTtGdnYL+KtQC0HvWBTYHW4qtbbGKP27ADjZDlSHaYcwIdpOLuti+o6F6
         WuW4tzMF8/UVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 12/15] net/mlx5e: MACsec, fix add Rx security association (SA) rule memory leak
Date:   Thu, 24 Nov 2022 00:10:37 -0800
Message-Id: <20221124081040.171790-13-saeed@kernel.org>
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

Currently MACsec's add Rx SA flow steering (fs) rule routine
uses a spec object which is dynamically allocated and do
not free it upon leaving. The above led to a memory leak.

Fix by freeing dynamically allocated objects.

Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index f87a1c4021bc..5b658a5588c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -1209,6 +1209,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		rx_rule->rule[1] = rule;
 	}
 
+	kvfree(spec);
 	return macsec_rule;
 
 err:
-- 
2.38.1

