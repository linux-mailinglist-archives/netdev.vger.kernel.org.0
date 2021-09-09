Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C49405084
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353302AbhIIM2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350828AbhIIMWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F55F61213;
        Thu,  9 Sep 2021 11:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188264;
        bh=KQitGf8LgkA60yKy0J2jv/cD9eB25l1vJw9SYw5CHR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCC739wew+z5/J686Vn3s10FQlvZjxo0FYEo5ewiSXua0VQTsRt5zf/KaVHHtCf2r
         ZzslXIp7fzux+80U0WDvzEHUZZbF/4VrGYaMo5HbkITJis786hspbBwtUFT80tUyUO
         d04ICSC6ROGtWRec+YIx/Fs4QMV0KjEROSJuTYOBtN3OevGkaFtypf4+ROIfqd7PIc
         ZtbSH0eQeY6qAL5JciZ0IAnls3PK8YodCk/tGwv6IAD7IwuAlkTd+bi4Zd+tO/Z8YY
         oJyEy/ulommaT5NwdnciIHGsKF6u7Ul8ibj4imQXaPgdzPZbRlhiXVmqSWcxh/yAV5
         QPEFcggPFIfug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 209/219] net/mlx5: DR, fix a potential use-after-free bug
Date:   Thu,  9 Sep 2021 07:46:25 -0400
Message-Id: <20210909114635.143983-209-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 43356fad53de..ffdfb5a94b14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -846,9 +846,9 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
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

