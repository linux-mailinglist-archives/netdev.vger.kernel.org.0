Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8E454D17
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbhKQS3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239997AbhKQS3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0897A61BD3;
        Wed, 17 Nov 2021 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173593;
        bh=egTOWZok2LDjlwNFZaUiL4p9ekcH/5KxuwhLpRQVX54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qM01AiRFituJX5zzSS2GSL824fLNVYiatRUoewCIYAB3QvufLFANfD47AvKp4k6J+
         ZC3KzlYBKZVJIdRgvJ+9VOWwZ1/YaKFbih6WQG6R5ehJFjUnXkTWZyV+9WYRT1swja
         PeDdCRerL/TO9HKwe1HWNdf73cwnN0LbyKBoSnhEuE7lXKw/DfccPOQPX8dHBzaaFc
         80wYBuMTFlnwwHTjEzkjgULzLLa03ZxP7coBq9Ye3BSwmT6KgO/EPwDzX9w7CHkMB+
         07mTZYULQRTWns+UpJ4Bp0ktaw6UFrv3HTnclLYtLonPqU9p8lf8XIpw2KeQNm2KX/
         XEnzzMu7Rb7sw==
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
Subject: [PATCH net-next 2/6] devlink: Delete useless checks of holding devlink lock
Date:   Wed, 17 Nov 2021 20:26:18 +0200
Message-Id: <de107b4b9e547f0adc5946b0cc720de7ee3e8c14.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
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
index 1cb2e0ae9173..dcc09c62f3e5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5223,8 +5223,6 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
-
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
 		return -EINVAL;
@@ -5259,8 +5257,6 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	lockdep_assert_held(&devlink->lock);
-
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
 		return;
@@ -5298,8 +5294,6 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	lockdep_assert_held(&devlink->lock);
-
 	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
 
@@ -5325,8 +5319,6 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	lockdep_assert_held(&devlink->lock);
-
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
 }
@@ -5353,8 +5345,6 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink_snapshot *snapshot;
 	int err;
 
-	lockdep_assert_held(&devlink->lock);
-
 	/* check if region can hold one more snapshot */
 	if (region->cur_snapshots == region->max_snapshots)
 		return -ENOSPC;
@@ -5391,8 +5381,6 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 
-	lockdep_assert_held(&devlink->lock);
-
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
 	list_del(&snapshot->list);
-- 
2.33.1

