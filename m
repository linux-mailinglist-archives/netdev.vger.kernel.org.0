Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2A2CE275
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgLCXOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLCXOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 18:14:00 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Boris Pismenny <borisp@nvidia.com>,
        Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: fix non-IPV6 build
Date:   Fri,  4 Dec 2020 00:12:59 +0100
Message-Id: <20201203231314.1483198-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When IPv6 is disabled, the flow steering code causes a build failure:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: error: no member named 'skc_v6_daddr' in 'struct sock_common'; did you mean 'skc_daddr'?
               &sk->sk_v6_daddr, 16);
                    ^
include/net/sock.h:380:34: note: expanded from macro 'sk_v6_daddr'
 #define sk_v6_daddr             __sk_common.skc_v6_daddr

Hide the newly added function in an #ifdef that matches its callers
and the struct member definition.

Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules add/del")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 97f1594cee11..e51f60b55daa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -44,6 +44,7 @@ static void accel_fs_tcp_set_ipv4_flow(struct mlx5_flow_spec *spec, struct sock
 			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
 {
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
@@ -63,6 +64,7 @@ static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 	       0xff, 16);
 }
+#endif
 
 void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
 {
-- 
2.27.0

