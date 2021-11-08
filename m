Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A879E447E81
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhKHLNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237718AbhKHLNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87BE261350;
        Mon,  8 Nov 2021 11:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636369846;
        bh=LyXHsYc9FL+e5Xxrs1C6hphzdBHA2fkjJPaRiDu3R90=;
        h=From:To:Cc:Subject:Date:From;
        b=asCpGfNBT+eZR9/V+44y/uFtmpw7+CpZBqlKIMJ/lvvrnrORqTPElwWejMDht5t8q
         H4bRQQfnJh0OduukSR8Zze50/zaFuxWkibENO09Z7xnNE6WULNspoSONUA5cs+yA4g
         VpAsu/vIolG3XJy7VrjtUSUYueoOJ3iEycss6FWvBrZMTsvxQ7I3LhOhL81p3ehA8O
         zu+R3GYdnZxXLfhWrYqwgvPYKl9kyOKqp51tMtBoTYY081QSamnvVoTZbG2nKzkAFO
         cIuyFEnZXd/UWvhDPXgS+InL+dJ9MT5Ya1+Ly4GQw6cK1NYdJ1cKXHgW1VRy1ly2Rq
         H6PWYthQh4gBw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        caihuoqing <caihuoqing@baidu.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mlx5: fix psample_sample_packet link error
Date:   Mon,  8 Nov 2021 12:10:32 +0100
Message-Id: <20211108111040.3748899-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
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
2.29.2

