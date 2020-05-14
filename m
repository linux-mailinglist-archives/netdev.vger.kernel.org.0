Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89931D3A8B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgENS5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbgENS4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:56:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86DDB20727;
        Thu, 14 May 2020 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482598;
        bh=dIwDnWBI3zdZPm70c3zyZlmhRIygOKZQKTDT8e1PHPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw2O1rYUD24KUj85XKvkTE4U/vl16Qsv2thPjlhteLL5sCfeXofGzjv66Teot5JB5
         wAZgIGUjFBgYC/HW6wB3SfQTQIjJMK7vIfNViC/eeINHX5y5vmMnF7Uom6lJueludn
         kNP2qX0HKYs+VnOz6tyWMTak/NSe3gIBvYfywpaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/14] net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()
Date:   Thu, 14 May 2020 14:56:21 -0400
Message-Id: <20200514185625.21753-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185625.21753-1-sashal@kernel.org>
References: <20200514185625.21753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 40e473071dbad04316ddc3613c3a3d1c75458299 ]

When ENOSPC is set the idx is still valid and gets set to the global
MLX4_SINK_COUNTER_INDEX.  However gcc's static analysis cannot tell that
ENOSPC is impossible from mlx4_cmd_imm() and gives this warning:

drivers/net/ethernet/mellanox/mlx4/main.c:2552:28: warning: 'idx' may be
used uninitialized in this function [-Wmaybe-uninitialized]
 2552 |    priv->def_counter[port] = idx;

Also, when ENOSPC is returned mlx4_allocate_default_counters should not
fail.

Fixes: 6de5f7f6a1fa ("net/mlx4_core: Allocate default counter per port")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index f8ac0e69d14b7..b774ba64bd4b5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2295,6 +2295,7 @@ static int mlx4_allocate_default_counters(struct mlx4_dev *dev)
 
 		if (!err || err == -ENOSPC) {
 			priv->def_counter[port] = idx;
+			err = 0;
 		} else if (err == -ENOENT) {
 			err = 0;
 			continue;
@@ -2344,7 +2345,8 @@ int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (!err)
 			*idx = get_param_l(&out_param);
-
+		if (WARN_ON(err == -ENOSPC))
+			err = -EINVAL;
 		return err;
 	}
 	return __mlx4_counter_alloc(dev, idx);
-- 
2.20.1

