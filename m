Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146F21F2C99
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbgFIAZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbgFHXQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55AF320775;
        Mon,  8 Jun 2020 23:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658215;
        bh=gLF5uCXPjoIpUHk9Bdl4KupUF7xVSv7T6/M91PSrJpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOPqZIaFkzgvnLFnv5oSKnxFsRqVYQSw8y5rXmcybfbf//IRhQ1UGoKCH0iVBKgaA
         ejEKKZVW0la5YKNPwPCJHJShy9LVD9BGHDarBSS7HNOH2ZsonzAtLRkqkyaCRvOsHl
         GoCnNppVtSO9W0MfgKQG9/gXgG4vUjBUtJM8IeiI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 231/606] net/mlx5: Fix memory leak in mlx5_events_init
Date:   Mon,  8 Jun 2020 19:05:56 -0400
Message-Id: <20200608231211.3363633-231-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit df14ad1eccb04a4a28c90389214dbacab085b244 ]

Fix memory leak in mlx5_events_init(), in case
create_single_thread_workqueue() fails, events
struct should be freed.

Fixes: 5d3c537f9070 ("net/mlx5: Handle event of power detection in the PCIE slot")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 8bcf3426b9c6..3ce17c3d7a00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -346,8 +346,10 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 	events->dev = dev;
 	dev->priv.events = events;
 	events->wq = create_singlethread_workqueue("mlx5_events");
-	if (!events->wq)
+	if (!events->wq) {
+		kfree(events);
 		return -ENOMEM;
+	}
 	INIT_WORK(&events->pcie_core_work, mlx5_pcie_event);
 
 	return 0;
-- 
2.25.1

