Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA637481052
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhL2GZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60676 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbhL2GZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA0F6144A
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD886C36AEE;
        Wed, 29 Dec 2021 06:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759110;
        bh=KOPBRr2fQWcuXaRQKoH9vDLaqOz6woGxaLtk5N6IFEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqSUF2bpi/+qneR0mqtqD17iKlmKUTI7vD78Vk/9qj0a4qzm+D8tTqBvrEj0D8y2a
         1qjwFFnXl8SsBLdsTfpjGoKD01qllu74cO8IthpJFyzC9hPnFIHxzA9tooB6XMtAGC
         HgaRNdvjJsYekpu2mSpSJV1CzjQu1+XxgWeUpXWNHU2XfNeFpkcpLbH6pe5KQdVjov
         Yvv6usilCBC+xqXkrqje/mrX2yThbCeCPUYGHoNQDUrgx/OIrYcsC6p1T65CxTNjuE
         FoxOyd0DFdben0nOKeEyN9YhY4J2yG5DD04kYOCN1syeA6bjMW3dA7ocwy65r7wRoO
         kWNVwUAkTEtEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  09/16] net/mlx5: DR, Warn on failure to destroy objects due to refcount
Date:   Tue, 28 Dec 2021 22:24:55 -0800
Message-Id: <20211229062502.24111-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add WARN_ON_ONCE on refcount checks in SW steering object destructors

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 07936841ce99..f0faf04536d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1792,7 +1792,7 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 
 int mlx5dr_action_destroy(struct mlx5dr_action *action)
 {
-	if (refcount_read(&action->refcount) > 1)
+	if (WARN_ON_ONCE(refcount_read(&action->refcount) > 1))
 		return -EBUSY;
 
 	switch (action->action_type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index b12b47394890..e93708dfb739 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -432,7 +432,7 @@ int mlx5dr_domain_sync(struct mlx5dr_domain *dmn, u32 flags)
 
 int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 {
-	if (refcount_read(&dmn->refcount) > 1)
+	if (WARN_ON_ONCE(refcount_read(&dmn->refcount) > 1))
 		return -EBUSY;
 
 	/* make sure resources are not used by the hardware */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 88288c02d6ea..12ebb7adea4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -1069,7 +1069,7 @@ int mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher)
 {
 	struct mlx5dr_table *tbl = matcher->tbl;
 
-	if (refcount_read(&matcher->refcount) > 1)
+	if (WARN_ON_ONCE(refcount_read(&matcher->refcount) > 1))
 		return -EBUSY;
 
 	mlx5dr_domain_lock(tbl->dmn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 241ee49a24ba..1d6b43a52c58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -283,7 +283,7 @@ int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
 {
 	int ret;
 
-	if (refcount_read(&tbl->refcount) > 1)
+	if (WARN_ON_ONCE(refcount_read(&tbl->refcount) > 1))
 		return -EBUSY;
 
 	mlx5dr_dbg_tbl_del(tbl);
-- 
2.33.1

