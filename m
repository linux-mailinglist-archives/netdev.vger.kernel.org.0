Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF036466ED4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbhLCA7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbhLCA7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13D74628ED
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3360BC53FD0;
        Fri,  3 Dec 2021 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492985;
        bh=ZaW+R49aCcAKRSjbwp/82v+aj5mstVIAQ1kKvl3rDVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuKng/lcltRqLcRPLrbWca+dcs1Mv3QBvYG9ID2J5rCB9cu54r75nCtwhzPNge1+0
         2wkFVaJBDqk3kwAr7rPuEc6K4EhTsC8XtBiLt8BysQzs2YlOsSKt0d0l9fV/Z1hq8x
         7Ji09plWBauDkHcjK4kNtDfZzFImsdc4J6kBvbrKN//6iHBfPG2i1No/Ft46mK9/YN
         q17fliYf1KxUULCdEl5Yo3QCEQvTpoiOeQ9zTcEzS+UIGerjduU0sIbYaBbCRcbm/m
         cA1H/ftkm9sQvzMjUGk+8Ey3rEI4Q8eF1n3ccZuKQ5bU9ZUThMhHSGDL+ncCI1Nndz
         6uGi9gu+jlb0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 01/14] mlx5: fix psample_sample_packet link error
Date:   Thu,  2 Dec 2021 16:56:09 -0800
Message-Id: <20211203005622.183325-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When PSAMPLE is a loadable module, built-in drivers cannot use it:

aarch64-linux-ld: drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.o: in function `mlx5e_tc_sample_skb':
sample.c:(.text+0xd68): undefined reference to `psample_sample_packet'

Add the same dependency here that is used for MLXSW

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 92056452a9e3..4ba1a78c6515 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -115,6 +115,7 @@ config MLX5_TC_CT
 config MLX5_TC_SAMPLE
 	bool "MLX5 TC sample offload support"
 	depends on MLX5_CLS_ACT
+	depends on PSAMPLE=y || PSAMPLE=n || MLX5_CORE=m
 	default y
 	help
 	  Say Y here if you want to support offloading sample rules via tc
-- 
2.31.1

