Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DDE4F5C52
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiDFLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiDFLic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:38:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63052577B7B;
        Wed,  6 Apr 2022 01:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3D3B8217F;
        Wed,  6 Apr 2022 08:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D79C385A3;
        Wed,  6 Apr 2022 08:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233615;
        bh=AI2q8bZ5rztCUk0gt3UBTC5UtsKFg2W3jcUEz0D2PfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kto9uXo+27JO2OMN/e4hI/4bgLRdvtRESq5gOGLMX8P2Zut5jHF8jBrRRmHS/ji1S
         r17Z/XAces07oSd6hGx1WYXpMRYMofzNhs0iaMX7iR7doj9ghgCZB76VNNN5suA3fC
         YdkHgtMx99TrRLQK/rfroQe290cqHHOo0bkf/VJV6OkqMXJR/DHVR4V1cjgXAU1YWS
         FyktMMRXdcDyQAb78iGesDpPeWGVch03j8gp0JqxNKtxI/Cg09q7Rv9AME3WclPhvl
         Mo4Zp+OpmiLYfA8D0WKGWk2c4BGs9h+YPAj1OehMr07ikhTbL2aX8VTs1Ctswp3Lpm
         MdsbFh08qoZHQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 15/17] net/mlx5: Reduce kconfig complexity while building crypto support
Date:   Wed,  6 Apr 2022 11:25:50 +0300
Message-Id: <37f02171da06886c1b403d44dd18b2a56b19219d.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

Both IPsec and kTLS need two functions declared in the lib/crypto.c
file. These functions are advertised through general mlx5.h file and
don't have any protection from attempts to call them without proper
config option.

Instead of creating stubs just for two functions, simply build that *.c
file as part of regular mlx5_eth build and rely on compiler to throw
them away if no callers exist in produced code.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig  | 5 -----
 drivers/net/ethernet/mellanox/mlx5/core/Makefile | 4 +---
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 176883cf2827..bfc0cd5ec423 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -16,9 +16,6 @@ config MLX5_CORE
 	  Core driver for low level functionality of the ConnectX-4 and
 	  Connect-IB cards by Mellanox Technologies.
 
-config MLX5_ACCEL
-	bool
-
 config MLX5_FPGA
 	bool "Mellanox Technologies Innova support"
 	depends on MLX5_CORE
@@ -147,7 +144,6 @@ config MLX5_EN_IPSEC
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
-	select MLX5_ACCEL
 	help
 	  Build support for IPsec cryptography-offload acceleration in the NIC.
 
@@ -156,7 +152,6 @@ config MLX5_EN_TLS
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
 	depends on MLX5_CORE_EN
-	select MLX5_ACCEL
 	help
 	Build support for TLS cryptography-offload acceleration in the NIC.
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f7aafbfcdb61..81620c25c77e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -28,7 +28,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en/rqt.o en/tir.o en/rss.o en/rx_res.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o en/fs_tt_redirect.o en/selq.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o en/selq.o lib/crypto.o
 
 #
 # Netdev extra
@@ -88,8 +88,6 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 # Accelerations & FPGA
 #
-mlx5_core-$(CONFIG_MLX5_ACCEL) += lib/crypto.o
-
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
-- 
2.35.1

