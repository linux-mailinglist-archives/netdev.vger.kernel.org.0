Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637914F1474
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiDDMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbiDDMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2471403D;
        Mon,  4 Apr 2022 05:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B16D61021;
        Mon,  4 Apr 2022 12:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7900FC340EE;
        Mon,  4 Apr 2022 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649074121;
        bh=nPe/HQ//FKscyeabci6+QLSF2pg4qr1Hh7sEKZFl5bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwh2TTC3WEBl72sWcAcoULahp+zU7+K/IWcOnzrxlgOR5YdVaSrvIzJDk+eIW8ZzO
         5kH/fJYI0oL12iywwUV8N21LHJBoQp8VtyDN3EnFxmqjIuMGSSdlsqHEZv1K4UTCD2
         3yLC0dUctx+DhkCnyxzVhkTW7KjIHhK6vuuAGlX9WzzIys50Uz/1d65s0oIVT7SqsJ
         uZIDbX6Mvp2UF/JJ77iHGes52+OALUpk9TxFFn3TATFF0Z60j4qRgs1H48mKZ/dEJT
         iwSH7l3mJlvkwNkePAyc6K+3/5H3H9DEqY8l8oQwVNeXTiTEu48HPgbeV3RK7LvZZg
         B9byBa0RUYHBg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Reliably return TLS device capabilities
Date:   Mon,  4 Apr 2022 15:08:16 +0300
Message-Id: <a333ce541fb9497d04126b11c4a0052f9807d141.1649073691.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
References: <cover.1649073691.git.leonro@nvidia.com>
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

The capabilities returned from the FW are independent to the compiled
kernel and traditionally rely on the relevant CAPs bit only.

The mlx5_accel_is_ktls_*() functions are compiled out if CONFIG_MLX5_TLS
is not set, which "hides" from the user the information that TLS can be
enabled on this device.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 614687e0e3d9..cfb8bedba512 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -35,7 +35,6 @@
 #include "mlx5_core.h"
 #include "../../mlxfw/mlxfw.h"
 #include "lib/tout.h"
-#include "accel/tls.h"
 
 enum {
 	MCQS_IDENTIFIER_BOOT_IMG	= 0x1,
@@ -249,7 +248,7 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
-	if (mlx5_accel_is_ktls_tx(dev) || mlx5_accel_is_ktls_rx(dev)) {
+	if (MLX5_CAP_GEN(dev, tls_tx) || MLX5_CAP_GEN(dev, tls_rx)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_TLS);
 		if (err)
 			return err;
-- 
2.35.1

