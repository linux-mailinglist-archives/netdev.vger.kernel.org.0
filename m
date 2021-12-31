Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425274822BE
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhLaIU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbhLaIUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391F9C06173E
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05118B81D55
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B93C36AF1;
        Fri, 31 Dec 2021 08:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938847;
        bh=Qdz1VJY+TwYDX4UKgodSpwOjlDZHzF8btOPJj2UvQAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiGc3WPtmqxk1CdqhFi0/xJ7rRpusHCc+WBujyYe1VnVqlnc77LywlE8sX1yXJSDe
         SGa0ka8km9tdcfmXbqnIEq163sv22KYRmGOQeazbTKrO0uDpfR6uzKj+uulsgK/14O
         v1kNGKLX7amjFIpurHMdhXmoIy1JxL6QmbGFZeqg5Pj/dzVY8FwirRh7nNc+75ryuF
         amfB/8aGUgHB83JIqeafImhvcbPhznGZvgq5HKJQND8pm3k6YyQTOM/bxqfzfo9cIM
         BBefx6JRDvTcd4eoY4tD3D7mQtrNAgWoBis3n1vp441xMqALSoxA71a65zfOsEkHDt
         R0515r7S1JjbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 09/16] net/mlx5: DR, Warn on failure to destroy objects due to refcount
Date:   Fri, 31 Dec 2021 00:20:31 -0800
Message-Id: <20211231082038.106490-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add WARN_ON_ONCE on refcount checks in SW steering object destructors

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
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
index 97a41b2b36e5..5fa7f9d6d8b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -431,7 +431,7 @@ int mlx5dr_domain_sync(struct mlx5dr_domain *dmn, u32 flags)
 
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

