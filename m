Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7EF2CCE09
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLCElw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:41:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18734 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCElw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:41:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc86c430000>; Wed, 02 Dec 2020 20:40:35 -0800
Received: from sx1.vdiclient.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:40:32 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net 2/4] net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled
Date:   Wed, 2 Dec 2020 20:39:44 -0800
Message-ID: <20201203043946.235385-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203043946.235385-1-saeedm@nvidia.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606970435; bh=isnds/D69L6Y85bRnsGFPzH35h4NNZYzUdd/ygXjzMA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=c1QPPNDa2k7MBX8ApAUYrnlcyviaMMwzDa9Sdp4MGVbYBKm7piFhbcbTkpOd81dqp
         oHz94kqoUbtcDudaZoDDb2aWqS57Tr5NgZnlgS+NrvOn1p3HxXZK74dTytXGxZGIrq
         NMVO09upksROpF24GeddzaqNaUBgv+WcfEB7BEA3Zx/xdkDXjx6ve6ePS/ahbm269A
         VdXv1U2L+D9AexBbDGL52JR6VELc0tFnFrGSyne8iVc+bIMPIYb2yetOOl0P0vnNPF
         2177jr43s7x2Skd3xA/7fc2UPoKdXTFwHljWEX2MYu179bBouFpRt2atFNyA+CC3BJ
         WN4LmsUWr95GQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when CONFIG_IPV6 is not enabled by making a function
be built conditionally.

Fixes these build errors and warnings:

../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In function '=
accel_fs_tcp_set_ipv6_flow':
../include/net/sock.h:380:34: error: 'struct sock_common' has no member nam=
ed 'skc_v6_daddr'; did you mean 'skc_daddr'?
  380 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
      |                                  ^~~~~~~~~~~~
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: note: i=
n expansion of macro 'sk_v6_daddr'
   55 |         &sk->sk_v6_daddr, 16);
      |              ^~~~~~~~~~~
At top level:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13: warning=
: 'accel_fs_tcp_set_ipv6_flow' defined but not used [-Wunused-function]
   47 | static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec,=
 struct sock *sk)

Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules =
add/del")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 97f1594cee11..e51f60b55daa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -44,6 +44,7 @@ static void accel_fs_tcp_set_ipv4_flow(struct mlx5_flow_s=
pec *spec, struct sock
 			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
 }
=20
+#if IS_ENABLED(CONFIG_IPV6)
 static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct=
 sock *sk)
 {
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_=
protocol);
@@ -63,6 +64,7 @@ static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_s=
pec *spec, struct sock
 			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
 	       0xff, 16);
 }
+#endif
=20
 void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
 {
--=20
2.26.2

