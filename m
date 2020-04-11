Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08231A59D9
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgDKXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgDKXHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB862173E;
        Sat, 11 Apr 2020 23:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646461;
        bh=rxTEkZE/qzuNHsnmwj0H4/iT7J3HTtkntHYrbIhjhRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gERVlpJgEcsp127ZqHGt9rL3S5LwxGsn7pM5+A+0DM5Ym6pisgXF6i6xk4SHjzhPi
         g61kzewwVP/4JctR+YGVdWHgeEhp8tG2IuWUON7Ot/a8+FdxgF+BWU/yJfnDt79Fa3
         AKtwFuqM0p6W7VAg2xUizYYP6ilKdMBL+bf5fUB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 029/121] net/mlx5e: Init ethtool steering for representors
Date:   Sat, 11 Apr 2020 19:05:34 -0400
Message-Id: <20200411230706.23855-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]

During transition to uplink representors the code responsible for
initializing ethtool steering functionality wasn't added to representor
init rx routine. This causes NULL pointer dereference during configuration
of network flow classification rule with ethtool (only possible to
reproduce with next commit in this series which registers necessary ethtool
callbacks).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb24bb671..62c3a2e884912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1630,6 +1630,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_ttc_table;
 
+	mlx5e_ethtool_init_steering(priv);
+
 	return 0;
 
 err_destroy_ttc_table:
-- 
2.20.1

