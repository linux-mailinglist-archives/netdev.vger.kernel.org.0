Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393DD3380AF
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCKWhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhCKWhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 916FF64F26;
        Thu, 11 Mar 2021 22:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502258;
        bh=ylhIgTxDxvkxmHKvCFK4z0+i+ivTtNz4xQnZLqpnQvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxrfpHBAhUVIjfnlaTWV0mGS2AsuwFsfJ0HzpQ32C3vCj6MJV5JbV4K+e59WSbiKG
         4ANkfQKoWe8jPXqVvrKvvY06N4cwIGA4FiEnEuXlP+gEuT79aH4Qd6PJkUOiaRwa7Z
         spY8KFegMwevRJFwvGrEK8vLm6Xab+n8oYhVPpqs+YpX+IJt3N6W8ia6prNgE0F6/W
         xgL+6zgloIwTy6uL9FeYf0gUQyD8hA5l9vMq/g9FAwKy/jbt9u4XdVUrczdbwcQ9pD
         OOhiDGInrrsnRf1P5eZf+1tlvJ7yLlgWlHNxaOHzFPstpyEYJ2opPhnXSH3tb22udH
         yU11NWeAmzuRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy definition
Date:   Thu, 11 Mar 2021 14:37:16 -0800
Message-Id: <20210311223723.361301-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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

