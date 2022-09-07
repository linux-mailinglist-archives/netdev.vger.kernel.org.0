Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E305B1084
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiIGXhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiIGXh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9801ADCD2;
        Wed,  7 Sep 2022 16:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92910CE1E04;
        Wed,  7 Sep 2022 23:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8897FC433D7;
        Wed,  7 Sep 2022 23:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593835;
        bh=30kPdfXe1jiHy3vWD6kAZognCv2TE4+G3T8RIuFi+1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1guX238eWmgV3QM/t+iUY7UPWuICWUqBsf+Qki6GngAlHpQbML0Q1I7M3sRSJFJR
         M/f+CyKcPpoTMc51Up9ePvV7xkfCyKqXjXOF/PvFx9F+emdprBb/8U7IDpClqE2gZ0
         JRMzK/I36l7M1Am0zMrnCY0e1TeFOXFOf/txyaPNQUgfEYARlZODOFt9tUNfeFgxn9
         4ElzFNtJ3hFHIWiV6rfWm7Gj3WwoB21BtQdemGpUPmTltoZYy5ZLptl8aYAAczsGp1
         EePz0FxP/TqdOVc10zw0ZIGaFyzDC9JmEcaSBDk7mMbijRhc9VJ+uBgM3ip/EFQlpW
         +NQjr+PcPUXow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        "Liu, Changcheng" <jerrliu@nvidia.com>, Liu@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 07/14] net/mlx5: detect and enable bypass port select flow table
Date:   Wed,  7 Sep 2022 16:36:29 -0700
Message-Id: <20220907233636.388475-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Liu, Changcheng" <jerrliu@nvidia.com>

Use port selection capability port_select_flow_table_bypass
bit to detect and enable explicit port affinity even when
in lag hash mode.

Signed-off-by: Liu, Changcheng <jerrliu@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bec8d6d0b5f6..a284c97af213 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -652,6 +652,33 @@ static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 	return err;
 }
 
+static int handle_hca_cap_port_selection(struct mlx5_core_dev *dev,
+					 void *set_ctx)
+{
+	void *set_hca_cap;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, port_selection_cap))
+		return 0;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_PORT_SELECTION);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass) ||
+	    !MLX5_CAP_PORT_SELECTION_MAX(dev, port_select_flow_table_bypass))
+		return 0;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_PORT_SELECTION]->cur,
+	       MLX5_ST_SZ_BYTES(port_selection_cap));
+	MLX5_SET(port_selection_cap, set_hca_cap, port_select_flow_table_bypass, 1);
+
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION);
+
+	return err;
+}
+
 static int set_hca_cap(struct mlx5_core_dev *dev)
 {
 	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
@@ -696,6 +723,13 @@ static int set_hca_cap(struct mlx5_core_dev *dev)
 		goto out;
 	}
 
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_port_selection(dev, set_ctx);
+	if (err) {
+		mlx5_core_err(dev, "handle_hca_cap_port_selection failed\n");
+		goto out;
+	}
+
 out:
 	kfree(set_ctx);
 	return err;
-- 
2.37.2

