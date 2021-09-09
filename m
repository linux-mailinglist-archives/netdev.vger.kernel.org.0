Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E967404DD2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240296AbhIIMHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241531AbhIIMA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC1FC61506;
        Thu,  9 Sep 2021 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187974;
        bh=KQitGf8LgkA60yKy0J2jv/cD9eB25l1vJw9SYw5CHR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZQXLkaLhtOxGax+FxMHnIsDCN6gzeEksZ0BFJlgT6Vaz78gPHvtVsN1krW+4o0O8
         3gXNNuDcPn71+s1Y3Z6Xj6Px9ETHmNwwJgUsS1kcukE+/SpYOpKyxRDyAJ4gd5Y5Ka
         ZoeFHNLtSRdV9Hlfp4gifaX+x5cPgg0XZdsrrmS59v+NyAAyl1JCShGysFnGGK0F0W
         jNn7cTEfz/qobBEBDEyXu7JYMICTJ0x1P0/PxfJ/pAT5rLRRNSlCh8CeDCrebfj0jh
         NNk/YLXhfK8kjgKq2LrD1TUB7xUtZDA/Ie/8wc4Znf4+4Jcy8Ss3nIM7Zka/kzNXnr
         QKDqKg+3PWh/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 237/252] net/mlx5: DR, fix a potential use-after-free bug
Date:   Thu,  9 Sep 2021 07:40:51 -0400
Message-Id: <20210909114106.141462-237-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

