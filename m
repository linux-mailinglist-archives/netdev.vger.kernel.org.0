Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B672D8D00
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406575AbgLMMHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406526AbgLMMHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 07:07:37 -0500
From:   Leon Romanovsky <leon@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit platform
Date:   Sun, 13 Dec 2020 14:06:41 +0200
Message-Id: <20201213120641.216032-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
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

Use 32-bit friendly BIT_ULL macro.

Fixes: 2a2970891647 ("net/mlx5: Add sample offload hardware bits and structures")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2006795fd522..8a359b8bee52 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10709,9 +10709,9 @@ struct mlx5_ifc_affiliated_event_header_bits {
 };

 enum {
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
-	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
 };

 enum {
--
2.29.2

