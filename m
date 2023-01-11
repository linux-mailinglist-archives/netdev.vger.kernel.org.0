Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7B06653C9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbjAKFiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbjAKFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:37:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F313A3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 323AD61A1E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C81C433EF;
        Wed, 11 Jan 2023 05:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415049;
        bh=vbY0R2f3hkI6mzqOcE0363b3RRWDurMZ9fKsz0Am61Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDlCvDMk99pTtsmAi/1v5B2FkFW36704VafnEFerXrQDZY/gbrBdH+ySNsMmw2vx3
         O54Z6jDxmbhyV33WzegKqKvMYyc6Dxlp02FlN6saAKMg/m0hC712dci68t914oqXY1
         y+wbnTORwiXabiq6YHpQYXo0A/RebVKaw02LmfnmKVyo+Dh6qPTj+/sX7AxF0ru639
         9V7ermn4Mox00EtyhNRstWcQWfT+nG3DoiVzKvwFZSk154FlP0bFoHyItp442mCw6E
         gU4rNYsFbV/+FCmq6VH19sFSGPLIASvDOJQRm/ybeCKCD/RERNBsCbTrA2CgRrpdlh
         antk9RRcKvNeg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Expose shared buffer registers bits and structs
Date:   Tue, 10 Jan 2023 21:30:31 -0800
Message-Id: <20230111053045.413133-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

Add the shared receive buffer management and configuration registers:
1. SBPR - Shared Buffer Pools Register
2. SBCM - Shared Buffer Class Management Register

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h   |  2 ++
 include/linux/mlx5/mlx5_ifc.h | 61 +++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..0c4f6acf59ca 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -100,6 +100,8 @@ enum {
 };
 
 enum {
+	MLX5_REG_SBPR            = 0xb001,
+	MLX5_REG_SBCM            = 0xb002,
 	MLX5_REG_QPTS            = 0x4002,
 	MLX5_REG_QETCR		 = 0x4005,
 	MLX5_REG_QTCT		 = 0x400a,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a9ee7bc59c90..a84bdeeed2c6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11000,6 +11000,67 @@ struct mlx5_ifc_pbmc_reg_bits {
 	u8         reserved_at_2e0[0x80];
 };
 
+struct mlx5_ifc_sbpr_reg_bits {
+	u8         desc[0x1];
+	u8         snap[0x1];
+	u8         reserved_at_2[0x4];
+	u8         dir[0x2];
+	u8         reserved_at_8[0x14];
+	u8         pool[0x4];
+
+	u8         infi_size[0x1];
+	u8         reserved_at_21[0x7];
+	u8         size[0x18];
+
+	u8         reserved_at_40[0x1c];
+	u8         mode[0x4];
+
+	u8         reserved_at_60[0x8];
+	u8         buff_occupancy[0x18];
+
+	u8         clr[0x1];
+	u8         reserved_at_81[0x7];
+	u8         max_buff_occupancy[0x18];
+
+	u8         reserved_at_a0[0x8];
+	u8         ext_buff_occupancy[0x18];
+};
+
+struct mlx5_ifc_sbcm_reg_bits {
+	u8         desc[0x1];
+	u8         snap[0x1];
+	u8         reserved_at_2[0x6];
+	u8         local_port[0x8];
+	u8         pnat[0x2];
+	u8         pg_buff[0x6];
+	u8         reserved_at_18[0x6];
+	u8         dir[0x2];
+
+	u8         reserved_at_20[0x1f];
+	u8         exc[0x1];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x8];
+	u8         buff_occupancy[0x18];
+
+	u8         clr[0x1];
+	u8         reserved_at_a1[0x7];
+	u8         max_buff_occupancy[0x18];
+
+	u8         reserved_at_c0[0x8];
+	u8         min_buff[0x18];
+
+	u8         infi_max[0x1];
+	u8         reserved_at_e1[0x7];
+	u8         max_buff[0x18];
+
+	u8         reserved_at_100[0x20];
+
+	u8         reserved_at_120[0x1c];
+	u8         pool[0x4];
+};
+
 struct mlx5_ifc_qtct_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         port_number[0x8];
-- 
2.39.0

