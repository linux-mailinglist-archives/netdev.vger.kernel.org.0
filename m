Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E31176D0A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgCCCrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgCCCrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4A0246BB;
        Tue,  3 Mar 2020 02:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203629;
        bh=sKWT9C6S3r2RGpbAtBeNneIuanNERDEEBk/3vOnT6T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bW6yUl8cpqEVM3XNqth2M1uUzKahpFiJnO+23YsFNggOzGM6DhhndkhBS/Gx4KFPq
         FFYyKMUGoSYzGzlwSkkCgQ12jDJWZIdPbMpPKobzkg6f5arydwRfTXSnOioAg2J9Ye
         ewee2oHnM1LwVt7JGWCSn1bYpSF4bpqdhOcda5BQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 43/66] net/mlx5: DR, Fix matching on vport gvmi
Date:   Mon,  2 Mar 2020 21:45:52 -0500
Message-Id: <20200303024615.8889-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

[ Upstream commit 52d214976d4f64504c1bbb52d47b46a5a3d5ee42 ]

Set vport gvmi in the tag, only when source gvmi is set in the bit mask.

Fixes: 26d688e3 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index c6c7d1defbd78..aade62a9ee5ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2307,7 +2307,9 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
 	struct mlx5dr_cmd_caps *caps;
+	u8 *bit_mask = sb->bit_mask;
 	u8 *tag = hw_ste->tag;
+	bool source_gvmi_set;
 
 	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
 
@@ -2328,7 +2330,8 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	if (!vport_cap)
 		return -EINVAL;
 
-	if (vport_cap->vport_gvmi)
+	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
+	if (vport_cap->vport_gvmi && source_gvmi_set)
 		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
 
 	misc->source_eswitch_owner_vhca_id = 0;
-- 
2.20.1

