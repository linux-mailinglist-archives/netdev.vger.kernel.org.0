Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311EB1D3AD8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgENS71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgENS4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:56:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC90207FB;
        Thu, 14 May 2020 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482568;
        bh=hhquD2HHwlrIVX+Uc4pLtUsRmSPJ620hWIIrbpeJByo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZX4xnBsT3KifqeMTcjfGTO2XZjoJTA70kORI5EkiPgKlymfxzT0c1vAQWODyLyGZ
         jniB+UWnqtNt0jOd+3Wdoo6ZGkEtnkuehJ2yTWBRCEnpHg/wfSuqmx5hLB3za2egzb
         Uijcawf7tf0ybIRxSvzjlu6v8k6iqF4OKgFaYsqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/27] net/mlx5: Fix command entry leak in Internal Error State
Date:   Thu, 14 May 2020 14:55:37 -0400
Message-Id: <20200514185550.21462-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit cece6f432cca9f18900463ed01b97a152a03600a ]

Processing commands by cmd_work_handler() while already in Internal
Error State will result in entry leak, since the handler process force
completion without doorbell. Forced completion doesn't release the entry
and event completion will never arrive, so entry should be released.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a1057efa2294e..bb142a13d9f24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -847,6 +847,10 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		/* no doorbell, no need to keep the entry */
+		free_ent(cmd, ent->idx);
+		if (ent->callback)
+			free_cmd(ent);
 		return;
 	}
 
-- 
2.20.1

