Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF63063BCF8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiK2JaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiK2JaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDC5B874
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EED615E9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A207C433C1;
        Tue, 29 Nov 2022 09:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669714209;
        bh=HctrvSVZVwt3fOyUZllpNtmczVxztv1RSc80yQCX+kc=;
        h=From:To:Cc:Subject:Date:From;
        b=twyYnqGrvUM9XXCVO9jlFOd5Fr4inBHt0e53zeodXGd+Wug7BOgRT5IRiV8DpVCb0
         WRHF+cOAHgUfJ8vP1ykUOzUcMrPyKv83opvWBrYzUyFXM1LFuiBuZGek+bgnhbdL4b
         zEuvcyHAwOH11DBWgDnP7UwKG97BKxpWB0Blpj54Hbj54rNmAFA9zebgfqHDZMuSHN
         3siYx6ne6luFBvv9DPMPqxs1hxxrlqLexzzIdaO5EIA0LBA4O3+AVN1Lo8xXymgEgb
         HPmcyv4IgeVUXygiMhGHpkwZjJQWaK1uF1oTsYv4f2Z4/wfU7yjuRP6Ux3i8GRnjjn
         iCR9RZUouaxsw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net 1/2] Revert "net/mlx5e: MACsec, remove replay window size limitation in offload path"
Date:   Tue, 29 Nov 2022 01:30:05 -0800
Message-Id: <20221129093006.378840-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
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

From: Saeed Mahameed <saeedm@nvidia.com>

This reverts commit c0071be0e16c461680d87b763ba1ee5e46548fde.

The cited commit removed the validity checks which initialized the
window_sz and never removed the use of the now uninitialized variable,
so now we are left with wrong value in the window size and the following
clang warning: [-Wuninitialized]
drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:232:45:
       warning: variable 'window_sz' is uninitialized when used here
       MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);

Revet at this time to address the clang issue due to lack of time to
test the proper solution.

Fixes: c0071be0e16c ("net/mlx5e: MACsec, remove replay window size limitation in offload path")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c         | 16 ++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                    |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 0d6dc394a12a..f900709639f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -229,6 +229,22 @@ static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, voi
 	if (!attrs->replay_protect)
 		return 0;
 
+	switch (attrs->replay_window) {
+	case 256:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
+		break;
+	case 128:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
+		break;
+	case 64:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
+		break;
+	case 32:
+		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
 	MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);
 	MLX5_SET(macsec_aso, aso_ctx, mode, MLX5_MACSEC_ASO_REPLAY_PROTECTION);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 981fc7dfa408..5a4e914e2a6f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11611,6 +11611,13 @@ enum {
 	MLX5_MACSEC_ASO_REPLAY_PROTECTION = 0x1,
 };
 
+enum {
+	MLX5_MACSEC_ASO_REPLAY_WIN_32BIT  = 0x0,
+	MLX5_MACSEC_ASO_REPLAY_WIN_64BIT  = 0x1,
+	MLX5_MACSEC_ASO_REPLAY_WIN_128BIT = 0x2,
+	MLX5_MACSEC_ASO_REPLAY_WIN_256BIT = 0x3,
+};
+
 #define MLX5_MACSEC_ASO_INC_SN  0x2
 #define MLX5_MACSEC_ASO_REG_C_4_5 0x2
 
-- 
2.38.1

