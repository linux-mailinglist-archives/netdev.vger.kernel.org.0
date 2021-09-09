Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C540529A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354554AbhIIMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354819AbhIIMjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1868461BC2;
        Thu,  9 Sep 2021 11:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188492;
        bh=AzYyWIvTFUu7ICwG/e78kzaZiT+m17+3Ake8DT55j8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoS3uL/xkdFBbR/uc9QjumRk5Nv3T9CC3qUjmXVxrujaxV/oQCuG+vTH6LW4QCf3v
         YU5jravgaM7iEzvA+VZOtZao3LxC70T/yJd0WV5+VQnO6c+wkgyXQI66FX573vgY1q
         TFH84hzmjc26LZYXrS2+4sJZ4lP8xbd0Q6TKWi/Yz4RVXoNvzHqxufo5dwQ8gMD1K7
         1UVAa1bzyHmMdPeq+J5E8VHDH+YIeTqciNEFuiwE0ozhX4WxvXgtSYpHA2tSYi/3dJ
         +ib/NLD0zP6i2kbynzlsdf+lz6WTUwGKRB/8mtwFn0sWDIJ71i0HA6y0W0j+jaNsFN
         L+Ct5Bcyj4T+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 166/176] net/mlx5: DR, fix a potential use-after-free bug
Date:   Thu,  9 Sep 2021 07:51:08 -0400
Message-Id: <20210909115118.146181-166-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao_Liang <Wentao_Liang_g@163.com>

[ Upstream commit 6cc64770fb386b10a64a1fe09328396de7bb5262 ]

In line 849 (#1), "mlx5dr_htbl_put(cur_htbl);" drops the reference to
cur_htbl and may cause cur_htbl to be freed.

However, cur_htbl is subsequently used in the next line, which may result
in an use-after-free bug.

Fix this by calling mlx5dr_err() before the cur_htbl is put.

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b3c9dc032026..478de5ded7c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -824,9 +824,9 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 			new_htbl = dr_rule_rehash(rule, nic_rule, cur_htbl,
 						  ste_location, send_ste_list);
 			if (!new_htbl) {
-				mlx5dr_htbl_put(cur_htbl);
 				mlx5dr_err(dmn, "Failed creating rehash table, htbl-log_size: %d\n",
 					   cur_htbl->chunk_size);
+				mlx5dr_htbl_put(cur_htbl);
 			} else {
 				cur_htbl = new_htbl;
 			}
-- 
2.30.2

