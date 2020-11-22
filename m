Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93D02BC980
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 22:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgKVVMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 16:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgKVVMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 16:12:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39780C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 13:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wdE0SkompNbOqgCxdlW3s1eRIC0gVYQ494kzU4dNh2g=; b=NXGdhTwpAwUtJ4GGLOuJ2Sk8ud
        FsUWNUWFs+WrjI7swnlcPCLdeoOxPQhVXQjOBsaJ1s6K5qc3qOhhSeqo9vtvirx2loK+Xzljz7mp4
        AhwkJz7ApX/zhyM/t4mz2RNjRpQHlk2Tw0BDrkp5+RlMiDpxJ7i4F6lzYSThYezxg4zoFuPbnfKFN
        uQKRJWBQdNzkb1QAJi1alLOiVbJgr5TAzBGfXhJi64W5lyLw2OuWh5YzslvMcHB+R2QXP7KtD5uFX
        twmc03cQoM/N+9J+5Cq2JkMLKmZtkDKMhMywy5JdkyRFRc6IuD1vlpokpRSfBkipMZDlF45ZGChKH
        1BJ/ilEg==;
Received: from [2601:1c0:6280:3f0::953c] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kgwey-0005jP-Qd; Sun, 22 Nov 2020 21:12:37 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled
Date:   Sun, 22 Nov 2020 13:12:31 -0800
Message-Id: <20201122211231.5682-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build when CONFIG_IPV6 is not enabled by making a function
be built conditionally.

Fixes these build errors and warnings:

../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In function 'accel_fs_tcp_set_ipv6_flow':
../include/net/sock.h:380:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
  380 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
      |                                  ^~~~~~~~~~~~
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: note: in expansion of macro 'sk_v6_daddr'
   55 |         &sk->sk_v6_daddr, 16);
      |              ^~~~~~~~~~~
At top level:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13: warning: 'accel_fs_tcp_set_ipv6_flow' defined but not used [-Wunused-function]
   47 | static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)

Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules add/del")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20201120.orig/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ linux-next-20201120/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -44,6 +44,7 @@ static void accel_fs_tcp_set_ipv4_flow(s
 			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
 {
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
@@ -63,6 +64,7 @@ static void accel_fs_tcp_set_ipv6_flow(s
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 	       0xff, 16);
 }
+#endif
 
 void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
 {
