Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835C81F2C65
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgFHXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbgFHXRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B9520814;
        Mon,  8 Jun 2020 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658229;
        bh=qvjhPUaOb17erKSTZsgaGvHyxeBQAmA1wh8ItEi5JFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbgc+cCgObyR6DolAbH4hB7buOuBhfVNEZLtjR1eiJUq2pajlbhlhSgjl7zfwznpz
         c1BrvZrJ8GXZCNJpJKj0kXtAm49vN9o5XP9OeBrZ8ZtlfhYFgwCZ9WYk+aGClndbH5
         nWcbDHWnsNodKtuwsIpzFsoPhVOtAkXTeV/mj+3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 242/606] net/mlx5: Annotate mutex destroy for root ns
Date:   Mon,  8 Jun 2020 19:06:07 -0400
Message-Id: <20200608231211.3363633-242-sashal@kernel.org>
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

From: Roi Dayan <roid@mellanox.com>

commit 9ca415399dae133b00273a4283ef31d003a6818d upstream.

Invoke mutex_destroy() to catch any errors.

Fixes: 2cc43b494a6c ("net/mlx5_core: Managing root flow table")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index cdc566768a07..cf09cfc33234 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -416,6 +416,12 @@ static void del_sw_ns(struct fs_node *node)
 
 static void del_sw_prio(struct fs_node *node)
 {
+	struct mlx5_flow_root_namespace *root_ns;
+	struct mlx5_flow_namespace *ns;
+
+	fs_get_obj(ns, node);
+	root_ns = container_of(ns, struct mlx5_flow_root_namespace, ns);
+	mutex_destroy(&root_ns->chain_lock);
 	kfree(node);
 }
 
-- 
2.25.1

