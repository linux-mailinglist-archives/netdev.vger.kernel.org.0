Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1830B863
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhBBHIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhBBHHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:07:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A85B64EE2;
        Tue,  2 Feb 2021 07:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249632;
        bh=dlWT559v6/SM8gkDJZjd8wFyDba9OMs/E59puJpfQnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIt0G7y0zL3brx+QwctzmxodPZeNznHzhpr5uCsn1nt3u/HuAE6YZEER8ZuY2TQEd
         DJVJ3iATESQEuqWNwJZtINQuduWByQQCD/MKL6SUQe+kLrIz9y0l+52mekfJPUmxBa
         VU9NhL2/9/VfnkovSNi2VStDdedIEMU9IBg3RxQnHGT9O6Q/p1j4GH/L+AI5XLd4cj
         g30uK+jgV8nnBEgo/BAndBA9rEoY9/pdjAW/OQ/UkvMBKaSNU1r0aWFd9r5ql+6NxX
         xrWk1K2QXtqD+C57J7TEFtxiHknNgEecwjhACTWrx98aYkmp/aHaGkiRlT0+zFjKWc
         RcwYtiON/2VeQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Jurgens <danielj@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/4] net/mlx5: Fix function calculation for page trees
Date:   Mon,  1 Feb 2021 23:07:00 -0800
Message-Id: <20210202070703.617251-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202070703.617251-1-saeed@kernel.org>
References: <20210202070703.617251-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Jurgens <danielj@nvidia.com>

The function calculation always results in a value of 0. This works
generally, but when the release all pages feature is enabled it will
result in crashes.

Fixes: 0aa128475d33 ("net/mlx5: Maintain separate page trees for ECPF and PF functions")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index eaa8958e24d7..c0656d4782e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -76,7 +76,7 @@ enum {
 
 static u32 get_function(u16 func_id, bool ec_function)
 {
-	return func_id & (ec_function << 16);
+	return (u32)func_id | (ec_function << 16);
 }
 
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
-- 
2.29.2

