Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94B40303F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbhIGVZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347247AbhIGVZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D738D61130;
        Tue,  7 Sep 2021 21:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049870;
        bh=pFCQ+FRkZbr1qRhGa4oabcBHLAxXb/EWSj9Ty+3xSg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1em3rVXXvAmVv+9zJShdVSa9ET++4Y+G2xE0S45keVxcMpB8NN37Nl2tciNqt2RB
         fZMutUD+/bRWogsoJmMLbK4GtzvVV/DUpeS6HuuEMktKmO+A5cxPmiH9YMZwGKwrxN
         E3ng9Ks4JIbPCFsGfjx632gxltrYvZ6FR7tKtCR9Uy86LDwnIHaLktBFfVNDurUwZJ
         mPul//079ntf9zwxSgVJl1CjmLVqqaO2S6eHLnoCzSRYZo2D90sssD7yBySJlzx3Qj
         CIo6WMjoFxHUHJMMfVqzYy0iA6YMY6VmvnuILb8FAIr33Q2qndNgc1Nqe4I1eHq84n
         0rFqbMNmpFYig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Pavel Machek <pavel@denx.de>, Aya Levin <ayal@nvidia.com>
Subject: [net 4/7] net/mlx5: FWTrace, cancel work on alloc pd error flow
Date:   Tue,  7 Sep 2021 14:24:17 -0700
Message-Id: <20210907212420.28529-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Handle error flow on mlx5_core_alloc_pd() failure,
read_fw_strings_work must be canceled.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Reported-by: Pavel Machek (CIP) <pavel@denx.de>
Suggested-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 3f8a98093f8c..f9cf9fb31547 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1007,7 +1007,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	err = mlx5_core_alloc_pd(dev, &tracer->buff.pdn);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Failed to allocate PD %d\n", err);
-		return err;
+		goto err_cancel_work;
 	}
 
 	err = mlx5_fw_tracer_create_mkey(tracer);
@@ -1031,6 +1031,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+err_cancel_work:
 	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }
-- 
2.31.1

