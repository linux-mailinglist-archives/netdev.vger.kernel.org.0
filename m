Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7638D2704C0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIRTLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:11:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgIRTLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:11:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJLn1-00FH94-Qk; Fri, 18 Sep 2020 21:11:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 2/9] net: devlink: region: Pass the region ops to the snapshot function
Date:   Fri, 18 Sep 2020 21:11:02 +0200
Message-Id: <20200918191109.3640779-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191109.3640779-1-andrew@lunn.ch>
References: <20200918191109.3640779-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the region to be snapshotted to the function performing the
snapshot. This allows one function to operate on numerous regions.

v4:
Add missing kerneldoc for ICE

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 ++++
 drivers/net/netdevsim/dev.c                  | 6 ++++--
 include/net/devlink.h                        | 4 +++-
 net/core/devlink.c                           | 2 +-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 111d6bfe4222..67d1190cb164 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -401,6 +401,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
 /**
  * ice_devlink_nvm_snapshot - Capture a snapshot of the Shadow RAM contents
  * @devlink: the devlink instance
+ * @ops: the devlink region being snapshotted
  * @extack: extended ACK response structure
  * @data: on exit points to snapshot data buffer
  *
@@ -413,6 +414,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
  * error code on failure.
  */
 static int ice_devlink_nvm_snapshot(struct devlink *devlink,
+				    const struct devlink_region_ops *ops,
 				    struct netlink_ext_ack *extack, u8 **data)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
@@ -456,6 +458,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
 /**
  * ice_devlink_devcaps_snapshot - Capture snapshot of device capabilities
  * @devlink: the devlink instance
+ * @ops: the devlink region being snapshotted
  * @extack: extended ACK response structure
  * @data: on exit points to snapshot data buffer
  *
@@ -468,6 +471,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
  */
 static int
 ice_devlink_devcaps_snapshot(struct devlink *devlink,
+			     const struct devlink_region_ops *ops,
 			     struct netlink_ext_ack *extack, u8 **data)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..cf763ec69bb7 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -40,7 +40,9 @@ static struct dentry *nsim_dev_ddir;
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
 static int
-nsim_dev_take_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
+nsim_dev_take_snapshot(struct devlink *devlink,
+		       const struct devlink_region_ops *ops,
+		       struct netlink_ext_ack *extack,
 		       u8 **data)
 {
 	void *dummy_data;
@@ -68,7 +70,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	devlink = priv_to_devlink(nsim_dev);
 
-	err = nsim_dev_take_snapshot(devlink, NULL, &dummy_data);
+	err = nsim_dev_take_snapshot(devlink, NULL, NULL, &dummy_data);
 	if (err)
 		return err;
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index c83cb6ceff78..cd01434ec7f3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -547,7 +547,9 @@ struct devlink_info_req;
 struct devlink_region_ops {
 	const char *name;
 	void (*destructor)(const void *data);
-	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
+	int (*snapshot)(struct devlink *devlink,
+			const struct devlink_region_ops *ops,
+			struct netlink_ext_ack *extack,
 			u8 **data);
 	void *priv;
 };
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5b71f3c2d4d..3c5ef237b467 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4322,7 +4322,7 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = region->ops->snapshot(devlink, info->extack, &data);
+	err = region->ops->snapshot(devlink, region->ops, info->extack, &data);
 	if (err)
 		goto err_snapshot_capture;
 
-- 
2.28.0

