Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D402DC3DA9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbfJARBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbfJAQkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5FCE21855;
        Tue,  1 Oct 2019 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948017;
        bh=6Bnatj/5Ub1pWlIo0rzxCNeZp/xLiby1b8UPWU8/Gvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjAMadA0znV+DjNJevRy+h/Jp/wlKY5htH7a/lE9TzX8rwRyo5Ws1sdjAADvkKwOl
         uLKA4oj7X0Yld8DMDUfh5yWb5C9mdG5SzexRBrPb6KQsEoAMQQi3RMc3qo0rxBpqBM
         N2z+7bRWEX5MbEIzCSGZ9jFRuVsGF2SxgZOWbUcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 38/71] net/mlx5e: Fix traffic duplication in ethtool steering
Date:   Tue,  1 Oct 2019 12:38:48 -0400
Message-Id: <20191001163922.14735-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit d22fcc806b84b9818de08b32e494f3c05dd236c7 ]

Before this patch, when adding multiple ethtool steering rules with
identical classification, the driver used to append the new destination
to the already existing hw rule, which caused the hw to forward the
traffic to all destinations (rx queues).

Here we avoid this by setting the "no append" mlx5 fs core flag when
adding a new ethtool rule.

Fixes: 6dc6071cfcde ("net/mlx5e: Add ethtool flow steering support")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 94304abc49e98..39e90b8733192 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -399,10 +399,10 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 		      struct mlx5_flow_table *ft,
 		      struct ethtool_rx_flow_spec *fs)
 {
+	struct mlx5_flow_act flow_act = { .flags = FLOW_ACT_NO_APPEND };
 	struct mlx5_flow_destination *dst = NULL;
-	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
 	int err = 0;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-- 
2.20.1

