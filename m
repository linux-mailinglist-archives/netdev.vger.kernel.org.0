Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1A349FF6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhCZCyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhCZCxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8064661A38;
        Fri, 26 Mar 2021 02:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727228;
        bh=Xq1Dra7hnQa5npJtZegCaoKR2PfFAzHmk8TxOd4oFWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhxkCVN8i9VokU3k9ZlFxxpqL0xuL3lUNfJpyNVkXn+uXDdQBOtbfrzJCuJWgrshd
         RVmPRXLq89E3gAHvlX4U5zVMZg0WhkdUqRzdwmvIVgfvSKksQ4k02+opOyDlP7ISa5
         821D6QT46poyRQ8gQYGE3ARLBvZCvyBkqN6h6TXBRrcd/opKwfLRUAb8rc/IG/TdsZ
         +ZCRffjT5y2Nih7iLv+hHIJU6ZfmWdTRVKa6nZsrmpUTM4gi6Ipu28jp2WUbMqnvMZ
         thoRSuI2ExEAByg6bOjTghKusRRef8w0NEFX1YDAW6cQmLezKEmDMkTDTewtpQrKnE
         rv0Cp8+pvTB6Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [net-next V2 01/13] net/mlx5e: alloc the correct size for indirection_rqt
Date:   Thu, 25 Mar 2021 19:53:33 -0700
Message-Id: <20210326025345.456475-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The cited patch allocated the wrong size for the indirection_rqt table,
fix that.

Fixes: 2119bda642c4 ("net/mlx5e: allocate 'indirection_rqt' buffer dynamically")
CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4bd882a1018c..dbc06c71c170 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -447,11 +447,11 @@ static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
 
 static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
 {
-	u32 *indirection_rqt, rqn;
 	struct mlx5e_priv *priv = hp->func_priv;
 	int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
+	u32 *indirection_rqt, rqn;
 
-	indirection_rqt = kzalloc(sz, GFP_KERNEL);
+	indirection_rqt = kcalloc(sz, sizeof(*indirection_rqt), GFP_KERNEL);
 	if (!indirection_rqt)
 		return -ENOMEM;
 
-- 
2.30.2

