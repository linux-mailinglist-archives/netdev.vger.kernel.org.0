Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219F315999
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfEGFiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbfEGFiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC89121655;
        Tue,  7 May 2019 05:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207491;
        bh=kOLUyk1rW/joIcGgjq1GyO15f9JdqdFBELSxyRbWFYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuutzQ0/usfyHll5rxhU7d25LGYNUR0XQzLboJZMMtZ4Mz84dygy3Bb6NGdzuyove
         Eapyfll5ICGxuhdQ3W+G7TjnXEzY+e8uUJ5Q59LN2z/HydS7/BIYaB3OvuxNWhXhPp
         k9DTc1amvQKMYnctlYW78sZ+qaMA7jusq0GHstgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 74/81] mlxsw: core: Do not use WQ_MEM_RECLAIM for EMAD workqueue
Date:   Tue,  7 May 2019 01:35:45 -0400
Message-Id: <20190507053554.30848-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit a8c133b06183c529c51cd0d54eb57d6b7078370c ]

The EMAD workqueue is used to handle retransmission of EMAD packets that
contain configuration data for the device's firmware.

Given the workers need to allocate these packets and that the code is
not called as part of memory reclaim path, remove the WQ_MEM_RECLAIM
flag.

Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f7154f358f27..426aea8ad72c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -568,7 +568,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
 		return 0;
 
-	emad_wq = alloc_workqueue("mlxsw_core_emad", WQ_MEM_RECLAIM, 0);
+	emad_wq = alloc_workqueue("mlxsw_core_emad", 0, 0);
 	if (!emad_wq)
 		return -ENOMEM;
 	mlxsw_core->emad_wq = emad_wq;
-- 
2.20.1

