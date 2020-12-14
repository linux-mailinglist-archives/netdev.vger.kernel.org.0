Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2F2DA2D3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441142AbgLNVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439971AbgLNVop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 16:44:45 -0500
From:   Saeed Mahameed <saeed@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [net-next v4 01/15] net/mlx5: Fix compilation warning for 32-bit platform
Date:   Mon, 14 Dec 2020 13:43:38 -0800
Message-Id: <20201214214352.198172-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214214352.198172-1-saeed@kernel.org>
References: <20201214214352.198172-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

MLX5_GENERAL_OBJECT_TYPES types bitfield is 64-bit field.

Defining an enum for such bit fields on 32-bit platform results in below
warning.

./include/vdso/bits.h:7:26: warning: left shift count >= width of type [-Wshift-count-overflow]
                         ^
./include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro ‘BIT’
 MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
                                             ^~~
Use 32-bit friendly left shift.

Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits and structures")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeed@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0d6e287d614f..b9f15935dfe5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10711,9 +10711,9 @@ struct mlx5_ifc_affiliated_event_header_bits {
 };
 
 enum {
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 1ULL << 0xc,
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = 1ULL << 0x13,
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = 1ULL << 0x20,
 };
 
 enum {
-- 
2.26.2

