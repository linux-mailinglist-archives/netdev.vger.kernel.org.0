Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058BC9AF8F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 14:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbfHWMe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 08:34:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51376 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727894AbfHWMe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 08:34:56 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Aug 2019 15:34:53 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7NCYrqe005872;
        Fri, 23 Aug 2019 15:34:53 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next] net/mlx5: Fix return code in case of hyperv wrong size read
Date:   Fri, 23 Aug 2019 15:34:47 +0300
Message-Id: <1566563687-29760-1-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return code value could be non deterministic in case of wrong size read.
With this patch, if such error occurs, set rc to be -EIO.

In addition, mlx5_hv_config_common() supports reading of
HV_CONFIG_BLOCK_SIZE_MAX bytes only, fix to early return error with
bad input.

Fixes: 913d14e86657 ("net/mlx5: Add wrappers for HyperV PCIe operations")
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
index cf08d02703fb..583dc7e2aca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv.c
@@ -12,7 +12,7 @@ static int mlx5_hv_config_common(struct mlx5_core_dev *dev, void *buf, int len,
 	int bytes_returned;
 	int block_id;
 
-	if (offset % HV_CONFIG_BLOCK_SIZE_MAX || len % HV_CONFIG_BLOCK_SIZE_MAX)
+	if (offset % HV_CONFIG_BLOCK_SIZE_MAX || len != HV_CONFIG_BLOCK_SIZE_MAX)
 		return -EINVAL;
 
 	block_id = offset / HV_CONFIG_BLOCK_SIZE_MAX;
@@ -25,8 +25,8 @@ static int mlx5_hv_config_common(struct mlx5_core_dev *dev, void *buf, int len,
 				  HV_CONFIG_BLOCK_SIZE_MAX, block_id);
 
 	/* Make sure len bytes were read successfully  */
-	if (read)
-		rc |= !(len == bytes_returned);
+	if (read && !rc && len != bytes_returned)
+		rc = -EIO;
 
 	if (rc) {
 		mlx5_core_err(dev, "Failed to %s hv config, err = %d, len = %d, offset = %d\n",
-- 
2.17.1

