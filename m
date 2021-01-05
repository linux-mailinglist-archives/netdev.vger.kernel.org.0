Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2764E2EB5D3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbhAEXG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbhAEXGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6489923109;
        Tue,  5 Jan 2021 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887916;
        bh=A1/OW8gGzVcjaGXkEF7ZEJO6WelDPjMvZIISQipGFzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYO7FuxLNjX3R2/1s4TsNTZPSpus7u0t/HZGPZpSfyxnH8FCyWH3zFPmh0NlsZ5Z/
         bPcN+dn+ccNyxe97DHpPIUyNL8xyDkJmXeZFfieM/jSKAfzW+yRTPKknHeApGDuLS8
         BS4Uo1bJ9EHllx+lsuZcUNQef4cvdqo3smeq6Z7KwdAuojhZDh0ICPHnITQl3d7rBe
         PuRqOTCHXeRb9WZteLV2RSqDHFTYZqmgEZ0tJSLmKXkInI57V3ybHJoHkf3XWsTIHW
         RQD8fu18VtndUHJhWOnQaSm+1+jlvBfEx4suLqvm3h4FfSp+t+QT6HuFrkEapr+SYa
         xEfPS9ThLzIHg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5: DR, Add STE modify header actions per-device API
Date:   Tue,  5 Jan 2021 15:03:32 -0800
Message-Id: <20210105230333.239456-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Extend the STE context struct with per-device modify header actions.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.h      | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 9fbe60ed11ff..1a70f4f26e40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -120,6 +120,29 @@ struct mlx5dr_ste_ctx {
 			       u8 *hw_ste_arr,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes);
+	u32 modify_field_arr_sz;
+	const struct mlx5dr_ste_action_modify_field *modify_field_arr;
+	void (*set_action_set)(u8 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data);
+	void (*set_action_add)(u8 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data);
+	void (*set_action_copy)(u8 *hw_action,
+				u8 dst_hw_field,
+				u8 dst_shifter,
+				u8 dst_len,
+				u8 src_hw_field,
+				u8 src_shifter);
+	int (*set_action_decap_l3_list)(void *data,
+					u32 data_sz,
+					u8 *hw_action,
+					u32 hw_action_sz,
+					u16 *used_hw_action_num);
 };
 
 extern struct mlx5dr_ste_ctx ste_ctx_v0;
-- 
2.26.2

