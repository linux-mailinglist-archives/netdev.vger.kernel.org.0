Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACF325003
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhBYMzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBYMzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 07:55:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6003364EB7;
        Thu, 25 Feb 2021 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614257707;
        bh=u5eRUZXSfVrVHiNGu0vpYTNA/pISHvCVfDY7NxwSxHk=;
        h=From:To:Cc:Subject:Date:From;
        b=V8Cc7Gni8ewcfye1sgAqtDO1AoRyS2fHVsthPDK73YIrkQJKkLX7ZmbVpSLssrYKe
         qoPGRrPrTtd8bu1+pCZLO0vvNauoT3w6BVekXxB0fP9QysqO7/cXlTmdERb6KrEGJQ
         YNwH+uXy/Uu6C/5tAFQ+OAfAq/jhO7PMWk426CBo5RETi0XDIVpN7IUCtwn2zD6ZGc
         LmxWykaKRteQUNwIuYGK1q0crhOkYzMMsiEzfjuKRJcN2PW3rlZylE1FYdi41ZjElG
         U5JkPmHHLFRWF8DBA3SCEaQ5Q14p278z7x7g5J0d41oR3Slq503S6wpc2GcR5HmK+I
         Wr3HbrnoA+/CA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eli Britstein <elibr@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy definition
Date:   Thu, 25 Feb 2021 13:54:54 +0100
Message-Id: <20210225125501.1792072-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The alternative implementation of this function in a header file
is declared as a global symbol, and gets added to every .c file
that includes it, which leads to a link error:

arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlx5/core/en_rx.o: in function `mlx5e_tc_tun_update_header_ipv6':
en_rx.c:(.text+0x0): multiple definition of `mlx5e_tc_tun_update_header_ipv6'; drivers/net/ethernet/mellanox/mlx5/core/en_main.o:en_main.c:(.text+0x0): first defined here

Mark it 'static inline' like the other functions here.

Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 67de2bf36861..89d5ca91566e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -76,10 +76,12 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 static inline int
 mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				struct net_device *mirred_dev,
-				struct mlx5e_encap_entry *e) { return -EOPNOTSUPP; }
-int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
-				    struct net_device *mirred_dev,
-				    struct mlx5e_encap_entry *e)
+				struct mlx5e_encap_entry *e)
+{ return -EOPNOTSUPP; }
+static inline int
+mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
+				struct net_device *mirred_dev,
+				struct mlx5e_encap_entry *e)
 { return -EOPNOTSUPP; }
 #endif
 int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
-- 
2.29.2

