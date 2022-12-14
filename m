Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E063A64CC95
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 15:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiLNOpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 09:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238735AbiLNOpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 09:45:32 -0500
X-Greylist: delayed 583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Dec 2022 06:45:30 PST
Received: from shelob.oktetlabs.ru (shelob.oktetlabs.ru [91.220.146.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FB0E66
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 06:45:30 -0800 (PST)
Received: by shelob.oktetlabs.ru (Postfix, from userid 115)
        id 9A1AB88; Wed, 14 Dec 2022 17:35:43 +0300 (MSK)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_ADSP_DISCARD,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
Received: from gondor.oktetlabs.ru (gondor.oktetlabs.ru [192.168.38.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by shelob.oktetlabs.ru (Postfix) with ESMTPS id D8A157F;
        Wed, 14 Dec 2022 17:35:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 shelob.oktetlabs.ru D8A157F
Authentication-Results: shelob.oktetlabs.ru/D8A157F; dkim=none;
        dkim-atps=neutral
Received: from sasha by gondor.oktetlabs.ru with local (Exim 4.94.2)
        (envelope-from <sasha@gondor.oktetlabs.ru>)
        id 1p5SrG-00GqrK-Ds; Wed, 14 Dec 2022 17:35:42 +0300
Date:   Wed, 14 Dec 2022 17:35:42 +0300
From:   Alexandra Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH] net/mlx5e: parameter to disable symmetric hash
Message-ID: <Y5nfPjloqVqmWPyn@gondor.oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some AF_XDP applications assume standard Topelitz hash when spreading
traffic accross queues via RSS.  MLX5 driver always set "symmetric"
bit, which results in unexpected queues for any particular connection.

With this patch is is possible to disable that symmetric bit via
use_symmetric_hash module parameter, and use the standard Toeplitz hash
with well-known predictable result, same as for other NICs.

Signed-off-by: Alexandra N. Kossovsky <alexandra.kossovsky@oktetlabs.ru>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index d4239e3b3c88..63fb2608c0b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -5,6 +5,10 @@
 #include "params.h"
 #include <linux/mlx5/transobj.h>
 
+static bool use_symmetric_hash = true;
+module_param_named(use_symmetric_hash, use_symmetric_hash, bool, 0644);
+MODULE_PARM_DESC(use_symmetric_hash, "Use symmetric Toeplitz hash for RSS.");
+
 #define MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ (64 * 1024)
 
 /* max() doesn't work inside square brackets. */
@@ -121,7 +125,8 @@ void mlx5e_tir_builder_build_rss(struct mlx5e_tir_builder *builder,
 		const size_t len = MLX5_FLD_SZ_BYTES(tirc, rx_hash_toeplitz_key);
 		void *rss_key = MLX5_ADDR_OF(tirc, tirc, rx_hash_toeplitz_key);
 
-		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
+		if (use_symmetric_hash)
+			MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
 		memcpy(rss_key, rss_hash->toeplitz_hash_key, len);
 	}
 
-- 
2.30.2


-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
