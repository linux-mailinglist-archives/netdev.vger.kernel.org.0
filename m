Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1E2F0507
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390626AbfKES1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:27:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55332 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389724AbfKES1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:27:45 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iS3YK-00017y-Tg; Tue, 05 Nov 2019 18:27:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: fix kvfree of uninitialized pointer spec
Date:   Tue,  5 Nov 2019 18:27:40 +0000
Message-Id: <20191105182740.87146-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when a call to  esw_vport_create_legacy_ingress_acl_group
fails the error exit path to label 'out' will cause a kvfree on the
uninitialized pointer spec.  Fix this by ensuring pointer spec is
initialized to NULL to avoid this issue.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: 10652f39943e ("net/mlx5: Refactor ingress acl configuration")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7baade9e62b7..f2e400a23a59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1253,7 +1253,7 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination drop_ctr_dst = {0};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec;
+	struct mlx5_flow_spec *spec = NULL;
 	int dest_num = 0;
 	int err = 0;
 	u8 *smac_v;
-- 
2.20.1

