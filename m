Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5856DEA2E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjDLEIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjDLEIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A3B49D4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8645262DA3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6D0C433EF;
        Wed, 12 Apr 2023 04:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272492;
        bh=DX7QCqzGofF++JEIobzcrOcTiKJDOLC7MGXdfraJTrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgI7YScVZGiTeMD1ycpniGxTiiuMUkgn3gjygne9sxqruPM3895ktpF0x/at4l6Z1
         YDQ0efwulGM+C5xQ7bi7JUWwjTMjyH0wHOd0h90xgSRteqk2o4ZKthYg7LOkCxD4Gy
         3e96kp2K5V4lQpG7p+AqdEHQZ914yEo3bT4Jg5zeQuKOSdz4dBYqh8ZQAciYDOJX1N
         NN0qHGxItIiKTZLThe/jg/0Ik4Uk988ZAbCOK7jwPs9N3wjOEPME+uioQeqHj8jvAL
         uU3a1Z/Q2+Imy/htqLHLZYN02BOPg/7rU7krnyfbTZ2HmAabWvOqBvR15dODxx/5bY
         MEAYgBzeaKSXw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Add new WQE for updating flow table
Date:   Tue, 11 Apr 2023 21:07:50 -0700
Message-Id: <20230412040752.14220-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add new WQE type: FLOW_TBL_ACCESS, which will be used for
writing modify header arguments.
This type has specific control segment and special data segment.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h |  2 ++
 include/linux/mlx5/qp.h     | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index af4dd536a52c..e4aa147ab390 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -442,6 +442,8 @@ enum {
 
 	MLX5_OPCODE_UMR			= 0x25,
 
+	MLX5_OPCODE_FLOW_TBL_ACCESS	= 0x2c,
+
 	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
 };
 
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index df55fbb65717..bd53cf4be7bd 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -499,6 +499,16 @@ struct mlx5_stride_block_ctrl_seg {
 	__be16		num_entries;
 };
 
+struct mlx5_wqe_flow_update_ctrl_seg {
+	__be32		flow_idx_update;
+	__be32		dest_handle;
+	u8		reserved0[40];
+};
+
+struct mlx5_wqe_header_modify_argument_update_seg {
+	u8		argument_list[64];
+};
+
 struct mlx5_core_qp {
 	struct mlx5_core_rsc_common	common; /* must be first */
 	void (*event)		(struct mlx5_core_qp *, int);
-- 
2.39.2

