Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B032639DD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgIJCIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:08:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbgIJCBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:01:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00DzpN-Nm; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 2/9] net: devlink: region: Pass the region ops to the snapshot function
Date:   Thu, 10 Sep 2020 01:58:20 +0200
Message-Id: <20200909235827.3335881-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the region to be snapshotted to the function performing the
snapshot. This allows one function to operate on numerous regions.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 2 ++
 drivers/net/netdevsim/dev.c                  | 6 ++++--
 include/net/devlink.h                        | 4 +++-
 net/core/devlink.c                           | 2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 111d6bfe4222..eb189d2070ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -413,6 +413,7 @@ void ice_devlink_destroy_port(struct ice_pf *pf)
  * error code on failure.
  */
 static int ice_devlink_nvm_snapshot(struct devlink *devlink,
+				    const struct devlink_region_ops *ops,
 				    struct netlink_ext_ack *extack, u8 **data)
 {
 	struct ice_pf *pf = devlink_priv(devlink);
@@ -468,6 +469,7 @@ static int ice_devlink_nvm_snapshot(struct devlink *devlink,
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
index 86ce644260b3..e7de55223cd1 100644
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
index 91c12612f2b7..5e383a8c44d3 100644
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

