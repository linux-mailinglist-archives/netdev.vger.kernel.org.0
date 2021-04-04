Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C635366C
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhDDEUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhDDEUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A243A61387;
        Sun,  4 Apr 2021 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510008;
        bh=iLtMyRWM3XzJGyIxXs7bMSsEN0pVDEhLKwnElaphVRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMPObzJXWlO4s1L1HUqAnzRc5hJu2Q6EIKIZgLmSRJbxJ6U9FSc1K1097GIsN4Jsi
         qVQJJZk0cJOafzno5hhru4zyJIYJ6C0z1FhynCQVO1+eLABRdO7hdXL2p0TS0E8J3N
         rFyu7I5DAEFTmscRKv3W5//3kW8OL16epypxpabtpQ3Uxt+2dTEHfvdkK/BhCjRs1E
         t4Jsiqy+TM+3FqEpTS15Iy4fItajkSGJuVXswozM8aAKdqNpaF+Eexm+ZUqd7Rq7Ye
         YGAvhZolQKWzEjS4FVxXck17KX809t12DwAr3hDppdBmx8TS8mnxDzCbvCpome8kuI
         4Pd7twB8slYJA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: Pack mlx5_rl_entry structure
Date:   Sat,  3 Apr 2021 21:19:43 -0700
Message-Id: <20210404041954.146958-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

mlx5_rl_entry structure is not properly packed as shown below. Due to this
an array of size 9144 bytes allocated which is aligned to 16Kbytes.
Hence, pack the structure and avoid the wastage.

This offers 8Kbytes of saving per mlx5_core_dev struct.

pahole -C mlx5_rl_entry  drivers/net/ethernet/mellanox/mlx5/core/en_main.o

Existing layout:

struct mlx5_rl_entry {
        u8                         rl_raw[48];           /*     0    48 */
        u16                        index;                /*    48     2 */

        /* XXX 6 bytes hole, try to pack */

        u64                        refcount;             /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u16                        uid;                  /*    64     2 */
        u8                         dedicated:1;          /*    66: 0  1 */

        /* size: 72, cachelines: 2, members: 5 */
        /* sum members: 60, holes: 1, sum holes: 6 */
        /* sum bitfield members: 1 bits (0 bytes) */
        /* padding: 5 */
        /* bit_padding: 7 bits */
        /* last cacheline: 8 bytes */
};

After alignment:

struct mlx5_rl_entry {
        u8                         rl_raw[48];           /*     0    48 */
        u64                        refcount;             /*    48     8 */
        u16                        index;                /*    56     2 */
        u16                        uid;                  /*    58     2 */
        u8                         dedicated:1;          /*    60: 0  1 */

        /* size: 64, cachelines: 1, members: 5 */
        /* padding: 3 */
        /* bit_padding: 7 bits */
};

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 23bb01d7c9b9..a9bd7e3bd554 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -517,8 +517,8 @@ struct mlx5_rate_limit {
 
 struct mlx5_rl_entry {
 	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)];
-	u16 index;
 	u64 refcount;
+	u16 index;
 	u16 uid;
 	u8 dedicated : 1;
 };
-- 
2.30.2

