Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D043AA6B6
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhFPWmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhFPWme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 737E6613F9;
        Wed, 16 Jun 2021 22:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883227;
        bh=LfWmKml357oCFPH0cyRm99TziQixqSbrqrHzOhPqLL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zweuh2itakbuz2yxnfU6c5HDjVtVmOuoGVWYbZCV7tIdwDon+ki6l+ITKPgYIlHhp
         WxQXni/68dMHiwNgMfyhyR5W0tH5fP7p6SkxzUrZjcp1nCuUhgpyP1kSJCtO1BMHo9
         FvRakAkPyc+0CI6EklpIf0Tgv/FbhXo98XJVvAE0XqzReemh2OvL67k9cIXu8BwqXa
         QpNIx4DPzyVODLauTJXbHIt4I696/HpUOpyT2o3P1BMypZ7H6W56PiWSidBLa6ST9F
         /pFFunDgZocxZAI1UMLG9VOv1A5AYK6smHqkPMngmyfvgtmiNVjqDIfGpngP0u+WX7
         jsR6Y3wd+SgpA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/8] net/mlx5: E-Switch, Read PF mac address
Date:   Wed, 16 Jun 2021 15:40:10 -0700
Message-Id: <20210616224015.14393-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

External controller PF's MAC address is not read from the device during
vport setup. Fail to read this results in showing all zeros to user
while the factory programmed MAC is a valid value.

$ devlink port show eth1 -jp
{
    "port": {
        "pci/0000:03:00.0/196608": {
            "type": "eth",
            "netdev": "eth1",
            "flavour": "pcipf",
            "controller": 1,
            "pfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Hence, read it when enabling a vport.

After the fix,

$ devlink port show eth1 -jp
{
    "port": {
        "pci/0000:03:00.0/196608": {
            "type": "eth",
            "netdev": "eth1",
            "flavour": "pcipf",
            "controller": 1,
            "pfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "98:03:9b:a0:60:11"
            }
        }
    }
}

Fixes: f099fde16db3 ("net/mlx5: E-switch, Support querying port function mac address")
Signed-off-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b88705a3a1a8..97e6cb6f13c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1054,6 +1054,12 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 			goto err_vhca_mapping;
 	}
 
+	/* External controller host PF has factory programmed MAC.
+	 * Read it from the device.
+	 */
+	if (mlx5_core_is_ecpf(esw->dev) && vport_num == MLX5_VPORT_PF)
+		mlx5_query_nic_vport_mac_address(esw->dev, vport_num, true, vport->info.mac);
+
 	esw_vport_change_handle_locked(vport);
 
 	esw->enabled_vports++;
-- 
2.31.1

