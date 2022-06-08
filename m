Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE09543D50
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiFHUFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiFHUFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B050830F1FD;
        Wed,  8 Jun 2022 13:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6A2E61C7A;
        Wed,  8 Jun 2022 20:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF6DC3411C;
        Wed,  8 Jun 2022 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718730;
        bh=rfRZy5bClEZQrtsAwixBq183XD7OTaOrJsESf+FrZDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3WgKwZMMseBSsmZpKfcpL2sgAw7qg3ibOYffR2abC0MFIfyEv2l0To9SNeD8fKk5
         piUKTM1hB4CgQYsoPaYDoX3joaKjyEsAVz5AY4NW+9/B4iGj7v9s7VRWSrFMar1IdD
         aL0Cq+joN4MoISoTF4GjWtIihOm54sRhBRx5qhrH4ZYIXXy1cg2Nw0a/RuryGhSLg2
         lqbP8MxDKKOCpqJzSFCJ3wPoIY8dyFL1HvhAIcnViQknFYFvXkSKmDAZ0gFoHG/v9n
         icS/6pxFAF1cihOW1IY/blFkB2TRqPRhcPKyn5dQfnqzWKnBzNfS1INwKGfIkLbL4y
         paWoGcxdeEzmg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Ofer Levi <oferle@nvidia.com>
Subject: [PATCH mlx5-next 6/6] net/mlx5: Add bits and fields to support enhanced CQE compression
Date:   Wed,  8 Jun 2022 13:04:52 -0700
Message-Id: <20220608200452.43880-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ofer Levi <oferle@nvidia.com>

Expose ifc bits and add needed structure fields and methods to
support enhanced CQE compression feature.
The enhanced CQE compression feature improves cpu utiliziation with
better packet latency from nic to host.

Signed-off-by: Ofer Levi <oferle@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   | 16 +++++++++++++++-
 include/linux/mlx5/mlx5_ifc.h |  7 +++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 95a4fa0fd40a..b5f58fd37a0f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -822,7 +822,10 @@ struct mlx5_cqe64 {
 	__be32		timestamp_l;
 	__be32		sop_drop_qpn;
 	__be16		wqe_counter;
-	u8		signature;
+	union {
+		u8	signature;
+		u8	validity_iteration_count;
+	};
 	u8		op_own;
 };
 
@@ -854,6 +857,11 @@ enum {
 	MLX5_CQE_FORMAT_CSUM_STRIDX = 0x3,
 };
 
+enum {
+	MLX5_CQE_COMPRESS_LAYOUT_BASIC = 0,
+	MLX5_CQE_COMPRESS_LAYOUT_ENHANCED = 1,
+};
+
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
@@ -866,6 +874,12 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 	return cqe->op_own >> 4;
 }
 
+static inline u8 get_cqe_enhanced_num_mini_cqes(struct mlx5_cqe64 *cqe)
+{
+	/* num_of_mini_cqes is zero based */
+	return get_cqe_opcode(cqe) + 1;
+}
+
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 585d246cef3b..e01148781d57 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1736,7 +1736,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   log_max_dci_errored_streams[0x5];
 	u8	   reserved_at_598[0x8];
 
-	u8         reserved_at_5a0[0x13];
+	u8         reserved_at_5a0[0x10];
+	u8         enhanced_cqe_compression[0x1];
+	u8         reserved_at_5b1[0x2];
 	u8         log_max_dek[0x5];
 	u8         reserved_at_5b8[0x4];
 	u8         mini_cqe_resp_stride_index[0x1];
@@ -4136,7 +4138,8 @@ struct mlx5_ifc_cqc_bits {
 	u8         cqe_comp_en[0x1];
 	u8         mini_cqe_res_format[0x2];
 	u8         st[0x4];
-	u8         reserved_at_18[0x8];
+	u8         reserved_at_18[0x6];
+	u8         cqe_compression_layout[0x2];
 
 	u8         reserved_at_20[0x20];
 
-- 
2.36.1

