Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC566BEC1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjAPNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjAPNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0FAD;
        Mon, 16 Jan 2023 05:06:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4272B80D20;
        Mon, 16 Jan 2023 13:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A16C433D2;
        Mon, 16 Jan 2023 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874382;
        bh=vAkRimTAOToGcO2FbKESWn7KypzSRbBcz5r9JH5CQXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADlWSkwHACNAO2DLud+o3x07DseJaWthyhMStPks9JKa3AMvFD7TCTSQ8TZM0fQ3R
         TXWvlPdUnDpnYl24ITlNcRdLUTeTLOuuVf9xcSA9ISNpqlNKsN/d5rGkznbmjvxyE9
         qZiBv/tQlQfwjsPz960Yrq13RsUph72exN6wRTnzpQyRbuVxqrZA+czP5JviwZapIH
         8BWLxK82/4kZPDyD8SyFfgxbcdcubFqUEE97PWhIiPLmUqRmsm2JDukeuGGnDcrUma
         aPQAEvN4YMtPALZapqy/W/8UppovupAUSNeAIgEwmJ4niNNuj8tJ9dq2bl4kwefxCs
         3BkpzLZuxGDVw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next 02/13] net/mlx5: Introduce crypto capabilities macro
Date:   Mon, 16 Jan 2023 15:05:49 +0200
Message-Id: <561d70fff0ab0ebc5594e371d9faec2a2c934972.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
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

From: Israel Rukshin <israelr@nvidia.com>

Add MLX5_CAP_CRYPTO() macro to the list of capabilities.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 include/linux/mlx5/device.h                    | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index f34e758a2f1f..4603f7ffd8d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -147,6 +147,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_GEN(dev, crypto)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_CRYPTO);
+		if (err)
+			return err;
+	}
+
 	if (MLX5_CAP_GEN(dev, port_selection_cap)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_PORT_SELECTION);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df134f6d32dc..81348a009666 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1555,6 +1555,7 @@ static const int types[] = {
 	MLX5_CAP_DEV_SHAMPO,
 	MLX5_CAP_MACSEC,
 	MLX5_CAP_ADV_VIRTUALIZATION,
+	MLX5_CAP_CRYPTO,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 29d4b201c7b2..fd095f0ed3ec 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1204,6 +1204,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_CRYPTO = 0x1a,
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_MACSEC = 0x1f,
 	MLX5_CAP_GENERAL_2 = 0x20,
@@ -1466,6 +1467,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_MACSEC(mdev, cap)\
 	MLX5_GET(macsec_cap, (mdev)->caps.hca[MLX5_CAP_MACSEC]->cur, cap)
 
+#define MLX5_CAP_CRYPTO(mdev, cap)\
+	MLX5_GET(crypto_cap, (mdev)->caps.hca[MLX5_CAP_CRYPTO]->cur, cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
-- 
2.39.0

