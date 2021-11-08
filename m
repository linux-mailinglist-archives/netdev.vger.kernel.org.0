Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E034449A6E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbhKHRIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240435AbhKHRIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE9546120A;
        Mon,  8 Nov 2021 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391162;
        bh=21dZcZWvadWM6+SxR0oX231jQ5mVH6rTshF3/Bs6aZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+XqWVeecET/KKFz5d3r8go1A5DYKxEVbsU3ZOyp74mFh0eR4BoswHNU+fV0sP2Ob
         sZp8Zfr4nqKm/t1F2xqK6AFfCSVBplViEV2gZqpEUm0XeynaYg5/0BoN8wb2wk0Rmm
         dH1zZs2VOdjbSURgj90978HPYEz135cP5bzYuerSLAriTEu8K/J5T9HInfQ7NbMpzz
         Pzp2Cpj6iYNrw8Pj42aw6JIU2xujWTb0wFcYnwhwetT/mvEma9aadVrc4MyKHJqLqh
         YtzbykZG4aw2Nq/Dg/uOvjETDSMa9MO96CUAtVXBwicqKEFfBre/ACxiP3BxAKuOgm
         aSkNLpqsV7D1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 06/16] devlink: Reshuffle resource registration logic
Date:   Mon,  8 Nov 2021 19:05:28 +0200
Message-Id: <f197bf339088377abad6063ce3efd63faa415a5f.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink->lock doesn't need to be held during whole execution of
function, but only when recursive path walk and list addition are
performed. So reshuffle the resource registration logic to allocate
resource and configure it without lock.

As part of this change, complain more louder if driver authors used
already existed resource_id. It is performed outside of the locks as
drivers were supposed to provide unique IDs and such error can't happen.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d88e882616bc..a2cd27fd767e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9850,17 +9850,9 @@ int devlink_resource_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 	struct list_head *resource_list;
-	bool top_hierarchy;
 	int err = 0;
 
-	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
-
-	mutex_lock(&devlink->lock);
-	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (resource) {
-		err = -EINVAL;
-		goto out;
-	}
+	WARN_ON(devlink_resource_find(devlink, NULL, resource_id));
 
 	resource = kzalloc(sizeof(*resource), GFP_KERNEL);
 	if (!resource) {
@@ -9868,7 +9860,17 @@ int devlink_resource_register(struct devlink *devlink,
 		goto out;
 	}
 
-	if (top_hierarchy) {
+	resource->name = resource_name;
+	resource->size = resource_size;
+	resource->size_new = resource_size;
+	resource->id = resource_id;
+	resource->size_valid = true;
+	memcpy(&resource->size_params, size_params,
+	       sizeof(resource->size_params));
+	INIT_LIST_HEAD(&resource->resource_list);
+
+	mutex_lock(&devlink->lock);
+	if (parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP) {
 		resource_list = &devlink->resource_list;
 	} else {
 		struct devlink_resource *parent_resource;
@@ -9885,14 +9887,6 @@ int devlink_resource_register(struct devlink *devlink,
 		}
 	}
 
-	resource->name = resource_name;
-	resource->size = resource_size;
-	resource->size_new = resource_size;
-	resource->id = resource_id;
-	resource->size_valid = true;
-	memcpy(&resource->size_params, size_params,
-	       sizeof(resource->size_params));
-	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 out:
 	mutex_unlock(&devlink->lock);
-- 
2.33.1

