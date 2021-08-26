Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035003F909D
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhHZWTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243748AbhHZWTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D74A26101C;
        Thu, 26 Aug 2021 22:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016295;
        bh=A5c3HPy2lnfYNAviZNqT4kCykr0LSoaNK8LhST4oHqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwYR4A4dddR14FmDCSHz7uJ5uGMhEo5UWdTwzcux7Qmg/SuR+gvGGmoygIcGB8c3g
         gxEwPBRIGMp+nrNoRed+rLssFABGKizET1xzSjvEyTdBQ40hPO21l8PYBwepAtGEiy
         DG5pEUBZr1kU86UjeI/0HW37lvb4aUTOOk/cN7mLr3+6k9+qioKMCIoV0pZJF5iJ+K
         YH6xYxBLATmLzMQrtox2kDG2JTbzP3SxIU3kK0dWfIdwQTLK/NSPc00MEzVHkikYh4
         TQOBMY9RqKwEk6fuXhcKIklmr36mTsdYRBZDk6xSju6s2VUkYUuu+rP6fUtmN7TBR8
         vwljSPCjjV+GA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Wentao_Liang <Wentao_Liang_g@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/6] net/mlx5: DR, fix a potential use-after-free bug
Date:   Thu, 26 Aug 2021 15:18:10 -0700
Message-Id: <20210826221810.215968-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao_Liang <Wentao_Liang_g@163.com>

In line 849 (#1), "mlx5dr_htbl_put(cur_htbl);" drops the reference to
cur_htbl and may cause cur_htbl to be freed.

However, cur_htbl is subsequently used in the next line, which may result
in an use-after-free bug.

Fix this by calling mlx5dr_err() before the cur_htbl is put.

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.31.1

