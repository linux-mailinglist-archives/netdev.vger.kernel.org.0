Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2F5454D2C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhKQS35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240041AbhKQS3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3B161BC1;
        Wed, 17 Nov 2021 18:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173608;
        bh=QPquNXgImB4Oa49ucF6VehzZ8a7je6X23RfNQvsdXzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h86nxP6ANuEv1VwkitSi4FJ0O0r3K7pI0qYMJcN1QtjSwHdPqbXB6F7YyFpuU/IHq
         5lz2E48rFEms1S3wGaYHwO9uM1zHFS9B9eJ5L+YrXSXIu0/dkYp513cVfioStJw8Hj
         pehXUzI4pt3q4CrcHmXLV+CATzbzc4vM9xkUV+Ghg/E7Qd9Qzi65cqiZNoxPL02+Rr
         xMK8VG0mh8/g12D2wugh7bIwNyVU4xvF0/Bw96a48K1d0iQr4G2Hy4XwIcbzVaZbko
         0T17NupnlXvfHHNyUOHGysABu4xDLuJ6sK+l3MtvVNmEeD9MbOdNpBYvkiD8aVNneo
         IL5lCJw4zmZ1A==
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
Subject: [PATCH net-next 6/6] devlink: Inline sb related functions
Date:   Wed, 17 Nov 2021 20:26:22 +0200
Message-Id: <be4b1f0a3452352068a81473a653f4f837197481.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove useless indirection of sb related functions, which called only
once and do nothing except accessing specific struct field.

As part of this cleanup, properly report an programming erro if already
existing sb index was supplied during SB registration.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 110 ++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 77 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1dda313d6d1b..fb5d3ba331f8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -361,12 +361,6 @@ static struct devlink_sb *devlink_sb_get_by_index(struct devlink *devlink,
 	return NULL;
 }
 
-static bool devlink_sb_index_exists(struct devlink *devlink,
-				    unsigned int sb_index)
-{
-	return devlink_sb_get_by_index(devlink, sb_index);
-}
-
 static struct devlink_sb *devlink_sb_get_from_attrs(struct devlink *devlink,
 						    struct nlattr **attrs)
 {
@@ -382,16 +376,11 @@ static struct devlink_sb *devlink_sb_get_from_attrs(struct devlink *devlink,
 	return ERR_PTR(-EINVAL);
 }
 
-static struct devlink_sb *devlink_sb_get_from_info(struct devlink *devlink,
-						   struct genl_info *info)
-{
-	return devlink_sb_get_from_attrs(devlink, info->attrs);
-}
-
-static int devlink_sb_pool_index_get_from_attrs(struct devlink_sb *devlink_sb,
-						struct nlattr **attrs,
-						u16 *p_pool_index)
+static int devlink_sb_pool_index_get_from_info(struct devlink_sb *devlink_sb,
+					       struct genl_info *info,
+					       u16 *p_pool_index)
 {
+	struct nlattr **attrs = info->attrs;
 	u16 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_INDEX])
@@ -404,18 +393,11 @@ static int devlink_sb_pool_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
-static int devlink_sb_pool_index_get_from_info(struct devlink_sb *devlink_sb,
-					       struct genl_info *info,
-					       u16 *p_pool_index)
-{
-	return devlink_sb_pool_index_get_from_attrs(devlink_sb, info->attrs,
-						    p_pool_index);
-}
-
 static int
-devlink_sb_pool_type_get_from_attrs(struct nlattr **attrs,
-				    enum devlink_sb_pool_type *p_pool_type)
+devlink_sb_pool_type_get_from_info(struct genl_info *info,
+				   enum devlink_sb_pool_type *p_pool_type)
 {
+	struct nlattr **attrs = info->attrs;
 	u8 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_TYPE])
@@ -430,16 +412,10 @@ devlink_sb_pool_type_get_from_attrs(struct nlattr **attrs,
 }
 
 static int
-devlink_sb_pool_type_get_from_info(struct genl_info *info,
-				   enum devlink_sb_pool_type *p_pool_type)
-{
-	return devlink_sb_pool_type_get_from_attrs(info->attrs, p_pool_type);
-}
-
-static int
-devlink_sb_th_type_get_from_attrs(struct nlattr **attrs,
-				  enum devlink_sb_threshold_type *p_th_type)
+devlink_sb_th_type_get_from_info(struct genl_info *info,
+				 enum devlink_sb_threshold_type *p_th_type)
 {
+	struct nlattr **attrs = info->attrs;
 	u8 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE])
@@ -454,18 +430,12 @@ devlink_sb_th_type_get_from_attrs(struct nlattr **attrs,
 }
 
 static int
-devlink_sb_th_type_get_from_info(struct genl_info *info,
-				 enum devlink_sb_threshold_type *p_th_type)
-{
-	return devlink_sb_th_type_get_from_attrs(info->attrs, p_th_type);
-}
-
-static int
-devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
-				   struct nlattr **attrs,
-				   enum devlink_sb_pool_type pool_type,
-				   u16 *p_tc_index)
+devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
+				  struct genl_info *info,
+				  enum devlink_sb_pool_type pool_type,
+				  u16 *p_tc_index)
 {
+	struct nlattr **attrs = info->attrs;
 	u16 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_TC_INDEX])
@@ -482,16 +452,6 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
-static int
-devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
-				  struct genl_info *info,
-				  enum devlink_sb_pool_type pool_type,
-				  u16 *p_tc_index)
-{
-	return devlink_sb_tc_index_get_from_attrs(devlink_sb, info->attrs,
-						  pool_type, p_tc_index);
-}
-
 struct devlink_region {
 	struct devlink *devlink;
 	struct devlink_port *port;
@@ -1972,7 +1932,7 @@ static int devlink_nl_cmd_sb_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2090,7 +2050,7 @@ static int devlink_nl_cmd_sb_pool_get_doit(struct sk_buff *skb,
 	u16 pool_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2214,7 +2174,7 @@ static int devlink_nl_cmd_sb_pool_set_doit(struct sk_buff *skb,
 	u32 size;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2305,7 +2265,7 @@ static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
 	u16 pool_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2435,7 +2395,7 @@ static int devlink_nl_cmd_sb_port_pool_set_doit(struct sk_buff *skb,
 	u32 threshold;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2528,7 +2488,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_get_doit(struct sk_buff *skb,
 	u16 tc_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2689,7 +2649,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_set_doit(struct sk_buff *skb,
 	u32 threshold;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2723,7 +2683,7 @@ static int devlink_nl_cmd_sb_occ_snapshot_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops = devlink->ops;
 	struct devlink_sb *devlink_sb;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2739,7 +2699,7 @@ static int devlink_nl_cmd_sb_occ_max_clear_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops = devlink->ops;
 	struct devlink_sb *devlink_sb;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -9636,29 +9596,24 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u16 egress_tc_count)
 {
 	struct devlink_sb *devlink_sb;
-	int err = 0;
 
-	mutex_lock(&devlink->lock);
-	if (devlink_sb_index_exists(devlink, sb_index)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	WARN_ON(devlink_sb_get_by_index(devlink, sb_index));
 
 	devlink_sb = kzalloc(sizeof(*devlink_sb), GFP_KERNEL);
-	if (!devlink_sb) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!devlink_sb)
+		return -ENOMEM;
+
 	devlink_sb->index = sb_index;
 	devlink_sb->size = size;
 	devlink_sb->ingress_pools_count = ingress_pools_count;
 	devlink_sb->egress_pools_count = egress_pools_count;
 	devlink_sb->ingress_tc_count = ingress_tc_count;
 	devlink_sb->egress_tc_count = egress_tc_count;
+
+	mutex_lock(&devlink->lock);
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
-unlock:
 	mutex_unlock(&devlink->lock);
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
 
@@ -9666,9 +9621,10 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	mutex_lock(&devlink->lock);
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
+
+	mutex_lock(&devlink->lock);
 	list_del(&devlink_sb->list);
 	mutex_unlock(&devlink->lock);
 	kfree(devlink_sb);
-- 
2.33.1

