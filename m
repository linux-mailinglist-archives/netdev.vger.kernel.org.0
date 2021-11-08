Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5135C449A69
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhKHRId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240413AbhKHRIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B27F16120A;
        Mon,  8 Nov 2021 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391148;
        bh=WlkZY9AueflJvXDGvSrYmt6wRfNJhlvj9VhpuC0rVQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyRSOYW9zCOUNlxP8tlUPk7k02t5NoRui/jLafCvliD2TtBw/KfnWYYYi/HewdTfa
         i+EXSoHX1YScY8rk9qgGLH9WEQGTI1a58gh+7kpCvzhLN71QDtT6kaa4g7bdkS0h+R
         XDVrm/QWWLwQtwdjQZG/1SQ38wwR8z1/1TeVzz0k3hrtgkkphqpx2NzQ2mUoSK7vry
         qzS0vGSmzZDQ9sVH0YAfbzXVD0XFo8l/p+B9lq/fCShETbbfb07/3Wl6S5fdgvFxAZ
         9ZtBw1302Fw8OmMXhYcQlGeOKLazrIGVy6HIZSFtrh7lbPid8Lm3aDz/MAKlbp1mnn
         Y1cJa7Qxee7dA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 02/16] devlink: Delete useless checks of holding devlink lock
Date:   Mon,  8 Nov 2021 19:05:24 +0200
Message-Id: <942459fbd6968a8efc712e64e9261727ac7ea236.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The snapshot API is fully protected by devlink->lock and these internal
functions are not exported directly to the code outside of the devlink.c.
This makes the checks of holding devlink lock as completely redundant.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fb9e60da9a77..4df241a62a44 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5221,8 +5221,6 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
-
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
 		return -EINVAL;
@@ -5257,8 +5255,6 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
-
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
 		return;
@@ -5296,8 +5292,6 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	lockdep_assert_held(&devlink->lock);
-
 	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
 
@@ -5323,8 +5317,6 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	lockdep_assert_held(&devlink->lock);
-
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
 }
@@ -5351,8 +5343,6 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	lockdep_assert_held(&devlink->lock);
-
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
 		return -ENOSPC;
@@ -5389,8 +5379,6 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	lockdep_assert_held(&devlink->lock);
-
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
 	list_del(&snapshot->list);
-- 
2.33.1

