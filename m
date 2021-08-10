Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C143E51AD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhHJEAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhHJEAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA72260FC4;
        Tue, 10 Aug 2021 03:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567981;
        bh=vhxHO3WPgB5Ndk1MM87EutrORmfgaeC3y6wTcaPdHjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgdkEp3DG5lQXlWZ+PZa+fmDyCkH6pi3a05104WlrmQxmrMPOOiauWKZIu6f4++Iq
         A/WbrMXnBTj90uxvsm0CN8/HkdhZw3AewqMgwX2eK4Ep9SwwYuraphXUzDKJmpUl3x
         ciPhAZMUvpT3j1Q5lpqWkdcO2FpjkT6gEqygc/6OdVPlC2lg9o7Be8IbyUJrdWLjFA
         fWL2XzJUBNsknbuZ8/caPuNqIm2ue1hFtiQjrrWPd6wamRKM3KrUreMRLceQNi61BE
         5tzi6tXi3m05b3EaPJ4+E+tsVKUKkBFknQCigGgZipjnpwb2Tox3a+cqKNAw0gGjCG
         T88HiXFTuKfrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/12] net/mlx5: Fix order of functions in mlx5_irq_detach_nb()
Date:   Mon,  9 Aug 2021 20:59:18 -0700
Message-Id: <20210810035923.345745-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Change order of functions in mlx5_irq_detach_nb() so it will be
a mirror of mlx5_irq_attach_nb.

Fixes: 71e084e26414 ("net/mlx5: Allocating a pool of MSI-X vectors for SFs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index b25f764daa08..95e60da33f03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -251,8 +251,11 @@ int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 {
+	int err = 0;
+
+	err = atomic_notifier_chain_unregister(&irq->nh, nb);
 	irq_put(irq);
-	return atomic_notifier_chain_unregister(&irq->nh, nb);
+	return err;
 }
 
 struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq)
-- 
2.31.1

