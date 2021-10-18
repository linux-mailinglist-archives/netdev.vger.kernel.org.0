Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857D74324F7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhJRR2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhJRR2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 13:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8D560F93;
        Mon, 18 Oct 2021 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634577971;
        bh=KP+qQf4SzEuGDN3ucbJaKc4+nf+4iRjgqHmaVwRmNUk=;
        h=From:To:Cc:Subject:Date:From;
        b=eP+YzlLaNbi4hie0DHpZylonlfmYMULkG4HgUdeRDwBi0HUGFkcZDfrUWCviYPst2
         o0gOC7zfAZl/CKYqrUwcENYvQoqeNo4yi+7GN46ElNMaMsPuPMduFnltiLOz6mcTrQ
         rfuNcnUuCw/thxOSOho9QE3AVPxzCdI9XQqwnvgQaGj7qZLIZb0O8Rd3HBXZDkvCwf
         sx47hzRcBBIwniXSe+/RG1j3DZ2L5i0bEeXRwpaHe3DxK7eQuWdWfhIKLQgJg7aK7F
         QG3NOdbIMBtI0Xanz2bQK8uZDu5LPwETCfSd4OkMKHL9lXtJXYfAC+efhSfNysSEYv
         WHEO5eDjzH0Yw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, amirtz@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] mlx5: prevent 64bit divide
Date:   Mon, 18 Oct 2021 10:26:08 -0700
Message-Id: <20211018172608.1069754-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5_tout_ms() returns a u64, we can't directly divide it.
This is not a problem here, @timeout which is the value
that actually matters here is already a ulong, so this
implies storing return value of mlx5_tout_ms() on a ulong
should be fine.

This fixes:

  ERROR: modpost: "__udivdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!

Fixes: 32def4120e48 ("net/mlx5: Read timeout values from DTOR")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index eaca79cc7b9d..0b0234f9d694 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -396,13 +396,14 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 {
-	unsigned long timeout = msecs_to_jiffies(mlx5_tout_ms(dev, PCI_SYNC_UPDATE));
+	unsigned long pci_sync_update_timeout = mlx5_tout_ms(dev, PCI_SYNC_UPDATE);
+	unsigned long timeout = msecs_to_jiffies(pci_sync_update_timeout);
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 	int err;
 
 	if (!wait_for_completion_timeout(&fw_reset->done, timeout)) {
-		mlx5_core_warn(dev, "FW sync reset timeout after %llu seconds\n",
-			       mlx5_tout_ms(dev, PCI_SYNC_UPDATE) / 1000);
+		mlx5_core_warn(dev, "FW sync reset timeout after %lu seconds\n",
+			       pci_sync_update_timeout / 1000);
 		err = -ETIMEDOUT;
 		goto out;
 	}
-- 
2.31.1

