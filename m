Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D415315A99
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfEGFrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbfEGFlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:41:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4545E2087F;
        Tue,  7 May 2019 05:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207676;
        bh=8+YtWPnbUFWPN/iXi/LHn7xtcTeGo8pWKdfVgK4GiBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrPYhCXnPtGPNM96J5T9s9AAgsES+9Pmyspum+0+olVfdJBtvytor2xRh8NmD8f5/
         xmLVhCgPoal7vy63ZB+SQlLwzB6ltvKgls0pVjL+hFdE48qyFRzZ3AepMJSLULIjs9
         2j4i13wH9IIcUW4xcIe+g+q3mrC7Mru9WO5zUPC4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 92/95] mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw workqueue
Date:   Tue,  7 May 2019 01:38:21 -0400
Message-Id: <20190507053826.31622-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit b442fed1b724af0de087912a5718ddde1b87acbb ]

The workqueue is used to periodically update the networking stack about
activity / statistics of various objects such as neighbours and TC
actions.

It should not be called as part of memory reclaim path, so remove the
WQ_MEM_RECLAIM flag.

Fixes: 3d5479e92087 ("mlxsw: core: Remove deprecated create_workqueue")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 33262c09c703..fad26046e159 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1812,7 +1812,7 @@ static int __init mlxsw_core_module_init(void)
 {
 	int err;
 
-	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, WQ_MEM_RECLAIM, 0);
+	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, 0, 0);
 	if (!mlxsw_wq)
 		return -ENOMEM;
 	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
-- 
2.20.1

