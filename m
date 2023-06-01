Return-Path: <netdev+bounces-6971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3A671911B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46A852816CA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E2379C4;
	Thu,  1 Jun 2023 03:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D26FCC
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4659FC433A4;
	Thu,  1 Jun 2023 03:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685589056;
	bh=prQKdV3U/uXxC36Tjk4+0VAi+GBD0LCQmGAjLbnKUSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bO9dHbxQCBHYBSYNNxAVIHBavGyub4Tj/z5oIYtU8P8UppeYFU5sR+l9ycJA9AUdb
	 6oHsegrD2cLwUsSSTKrRqXBnRWB2/jGPTEGHwjre8AGQQhtrToY1BQu6C0gKmjt/NE
	 Rt/Ffa3B3ApDXlB5EOOSL885SMMB4A381qByoEoxAhPOEAqbr2TO7dzeN7Ejnwgqo6
	 NhZxYBdXjgNCxHXvdLBZUjFO1uRcISEDpweFwsptYtSMh3BrxMTrna3lf0TAqsCWLf
	 +c5a2qj2old7F4J4HkQlLWsi37mPAwgVSdl9aLz1zdN49W0Dr5Y5bTzUU1gDhHguTY
	 yDQwRiuTGAciQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	Eli Cohen <elic@nvidia.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
Subject: [net 2/5] net/mlx5: Fix setting of irq->map.index for static IRQ case
Date: Wed, 31 May 2023 20:10:48 -0700
Message-Id: <20230601031051.131529-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601031051.131529-1-saeed@kernel.org>
References: <20230601031051.131529-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niklas Schnelle <schnelle@linux.ibm.com>

When dynamic IRQ allocation is not supported all IRQs are allocated up
front in mlx5_irq_table_create() instead of dynamically as part of
mlx5_irq_alloc(). In the latter dynamic case irq->map.index is set
via the mapping returned by pci_msix_alloc_irq_at(). In the static case
and prior to commit 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
irq->map.index was set in mlx5_irq_alloc() twice once initially to 0 and
then to the requested index before storing in the xarray. After this
commit it is only set to 0 which breaks all other IRQ mappings.

Fix this by setting irq->map.index to the requested index together with
irq->map.virq and improve the related comment to make it clearer which
cases it deals with.

Cc: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Fixes: 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 86ac4a85fd87..38edd485ba6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -232,12 +232,13 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 	if (!i || !pci_msix_can_alloc_dyn(dev->pdev)) {
-		/* The vector at index 0 was already allocated.
-		 * Just get the irq number. If dynamic irq is not supported
-		 * vectors have also been allocated.
+		/* The vector at index 0 is always statically allocated. If
+		 * dynamic irq is not supported all vectors are statically
+		 * allocated. In both cases just get the irq number and set
+		 * the index.
 		 */
 		irq->map.virq = pci_irq_vector(dev->pdev, i);
-		irq->map.index = 0;
+		irq->map.index = i;
 	} else {
 		irq->map = pci_msix_alloc_irq_at(dev->pdev, MSI_ANY_INDEX, af_desc);
 		if (!irq->map.virq) {
-- 
2.40.1


