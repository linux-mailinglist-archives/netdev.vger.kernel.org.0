Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD77658681
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiL1Tn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiL1Tnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD8D63D1
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F02CB818F3
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25D1C433F0;
        Wed, 28 Dec 2022 19:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256624;
        bh=ijiazIXpVeo4KQngKeDk3HgVZzrJmnGzJW4IEzXPUWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM0img2s0iI2FaYCQal0nruX3gM2C9tJV11DPyBuMy+lPDdFyPEHB2GxnpEOVNUf3
         rNqOzBeKhv64hZWQzLFo6TrjdNWknyx0D/d4s0sZl0nZkR1sYC7lIhlAQsKUMbd9Nz
         tD43gj47GVh5ZfZr7dP4vufDs9FK36mSUbuEKqt8nB7ygxWVmhWEo20azkzHjGIc5v
         /2Ce5u1lnoZgEaD5r/VydzQVIjyi4rtzsO5FNh1etoFOapB0HAgx+hnGPMNXYK+ase
         VXFnO6sPWL8qdwINHJdhXs0ZCAXOsaK7Kee4hAXvSb2kONCqvu2Nhvt+AHk436QN0p
         lrzSzeRgO7zMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net 06/12] net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default
Date:   Wed, 28 Dec 2022 11:43:25 -0800
Message-Id: <20221228194331.70419-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

mlx5e_build_nic_params will turn CQE compression on if the hardware
capability is enabled and the slow_pci_heuristic condition is detected.
As IPoIB doesn't support CQE compression, make sure to disable the
feature in the IPoIB profile init.

Please note that the feature is not exposed to the user for IPoIB
interfaces, so it can't be subsequently turned on.

Fixes: b797a684b0dd ("net/mlx5e: Enable CQE compression when PCI is slower than link")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 7c5c500fd215..2c73c8445e63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -71,6 +71,10 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
 	params->tunneled_offload_en = false;
+
+	/* CQE compression is not supported for IPoIB */
+	params->rx_cqe_compress_def = false;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compress_def);
 }
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
-- 
2.38.1

