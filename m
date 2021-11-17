Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AADA454D25
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbhKQS3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240040AbhKQS3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42EC261BD3;
        Wed, 17 Nov 2021 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173604;
        bh=9GifBOLGSt92YGCLXeltZ5sxLbD7rh+yoqUpg2uHSto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kally2Xxf6HW0dc9sixj9XBFUhD0ZYcEmZeZ6/yG7ptkLtALMd+zjbI/E1Mlpd8lN
         +XRvcYyQQSfQ+AVZr3g7XnTwVlRGUV6tRfEe0I2ui/WxTxhpFt9xkdXT7uq7SerEjo
         9mLXZWyacsRbuZdMoEIkS4M/3r5Zi1ltJBimLdxs4kYYGLFnecIoj9yXd1WkEjcrzT
         BLqEET89BTEGoHzsq2vvOEVCVBZixhAjr5tyWOmG5xkOIW3aSCGRsw15Enfh0TJatt
         daiP2YoPM9jVpqPhQ6eBhAe0XAH98x6RlBV9ltBgbjtROttUs3+t8XKxQEGkTSJ6F7
         /NPaG/PI+N9aw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 5/6] devlink: Reshuffle resource registration logic
Date:   Wed, 17 Nov 2021 20:26:21 +0200
Message-Id: <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
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
index 356057ea2e52..1dda313d6d1b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9833,17 +9833,9 @@ int devlink_resource_register(struct devlink *devlink,
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
@@ -9851,7 +9843,17 @@ int devlink_resource_register(struct devlink *devlink,
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
@@ -9868,14 +9870,6 @@ int devlink_resource_register(struct devlink *devlink,
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

