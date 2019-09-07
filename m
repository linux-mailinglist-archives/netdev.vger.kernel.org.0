Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5494CAC6D5
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbfIGNrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:47:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33137 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733278AbfIGNrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 09:47:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so6417321pfl.0
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 06:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n/E8kVLcgaLVDmvB6aVHwxVJQ6pq71Ob2wO+rFoaOWI=;
        b=CVkEyats1HA4Bf65u2sinwrRPYuzSkG4jhjmoIBUYatzkul4qGMB/Em4CM64OAMknz
         gTwiNEp/TbSzzqTO6xduKdmAJr5mR/1nGONuugK5Ixv32P4H5EYegnnq/MsJpAQGVh1y
         v55oMjUMOJcaMornPpv+G7STSwj1I4Jcr5UDV9jp5qHE/0KDtJnditCWWNWy/WSiMSdQ
         +jAm3NPfs5kk5SavBrB+SAQRPC8jyDAGdwNWA0KZ8HeDKCXzqjCD/+wGnA5lrPMgu8xZ
         R8f2aJ8BDRFcBdz5OPj/LTQQ0MjV6t3BYKsAVxyubrw2dEzrQf0igDwlXY/ukzpGEOZU
         kZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n/E8kVLcgaLVDmvB6aVHwxVJQ6pq71Ob2wO+rFoaOWI=;
        b=HJ3G5nZFfgofSBuZesSxBNe6DHn6KWAhlfNogn9QClUeZRG/UndUK6ZK4tn28PKv9u
         uyG2sIgIskdQ8OpmFSGgbpjgsbFvkQ/iXv3YJtp+YarmsvOrq5LC6dYSAClTPOZXhCpA
         /wCoxL5kMo0zn/9wALd7xBEsFQKKWwOsoLhbushyRz4FqSjPGZeEfcz6BdMy7dU730yk
         8Bo3hH04dQXuHGphfx01FopdJBRuipdjlMjzQDEPsLdTMxQRPxxD1I0gysilXdl427mo
         yxipr5VmlCjHReONvoqGuah0il79GXQ2z3a4YlBwKFG4JkqTE+ZyzixHc86ALwtrD53z
         y5ew==
X-Gm-Message-State: APjAAAVNbR2jiGqj3YsAAvUmhoekxcWYYN/5NVH2nX4pcnXmbzOa6TXs
        xYGVSjZyrAlA2Hn2Yt3Ac1Y=
X-Google-Smtp-Source: APXvYqx1mRCSO3rwBnHK5YeZHiDf4WMFHaI0f9b4EmLQieJmfDOcsOdBChwn0My+mAGncV2FU4CBPQ==
X-Received: by 2002:a63:58c:: with SMTP id 134mr13244988pgf.106.1567864066582;
        Sat, 07 Sep 2019 06:47:46 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id r23sm9184294pjo.22.2019.09.07.06.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 06:47:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 09/11] net: core: add ignore flag to netdev_adjacent structure
Date:   Sat,  7 Sep 2019 22:47:37 +0900
Message-Id: <20190907134737.444-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to link an adjacent node, netdev_upper_dev_link() is used
and in order to unlink an adjacent node, netdev_upper_dev_unlink() is used.
unlink operation does not fail, but link operation can fail.

In order to exchange adjacent nodes, we should unlink an old adjacent
node first. then, link a new adjacent node.
If link operation is failed, we should link an old adjacent node again.
But this link operation can fail too.
It eventually breaks the adjacent link relationship.

This patch adds an ignore flag into the netdev_adjacent structure.
If this flag is set, netdev_upper_dev_link() ignores an old adjacent
node for a moment.
So we can skip unlink operation before link operation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : this patch isn't changed

 include/linux/netdevice.h |   4 +
 net/core/dev.c            | 160 +++++++++++++++++++++++++++++++++-----
 2 files changed, 144 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5bb5756129af..309ae000bae7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4319,6 +4319,10 @@ int netdev_master_upper_dev_link(struct net_device *dev,
 				 struct netlink_ext_ack *extack);
 void netdev_upper_dev_unlink(struct net_device *dev,
 			     struct net_device *upper_dev);
+void netdev_adjacent_dev_disable(struct net_device *upper_dev,
+				struct net_device *lower_dev);
+void netdev_adjacent_dev_enable(struct net_device *upper_dev,
+				struct net_device *lower_dev);
 void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
 void *netdev_lower_dev_get_private(struct net_device *dev,
 				   struct net_device *lower_dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6a4b4ce62204..ac055b531c96 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6448,6 +6448,9 @@ struct netdev_adjacent {
 	/* upper master flag, there can only be one master device per list */
 	bool master;
 
+	/* lookup ignore flag */
+	bool ignore;
+
 	/* counter for the number of times this device was added to us */
 	u16 ref_nr;
 
@@ -6553,6 +6556,22 @@ struct net_device *netdev_master_upper_dev_get(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_get);
 
+struct net_device *netdev_master_upper_dev_get_ignore(struct net_device *dev)
+{
+	struct netdev_adjacent *upper;
+
+	ASSERT_RTNL();
+
+	if (list_empty(&dev->adj_list.upper))
+		return NULL;
+
+	upper = list_first_entry(&dev->adj_list.upper,
+				 struct netdev_adjacent, list);
+	if (likely(upper->master) && !upper->ignore)
+		return upper->dev;
+	return NULL;
+}
+
 /**
  * netdev_has_any_lower_dev - Check if device is linked to some device
  * @dev: device
@@ -6603,8 +6622,9 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
-static struct net_device *netdev_next_upper_dev(struct net_device *dev,
-						struct list_head **iter)
+static struct net_device *netdev_next_upper_dev_ignore(struct net_device *dev,
+						       struct list_head **iter,
+						       bool *ignore)
 {
 	struct netdev_adjacent *upper;
 
@@ -6614,6 +6634,7 @@ static struct net_device *netdev_next_upper_dev(struct net_device *dev,
 		return NULL;
 
 	*iter = &upper->list;
+	*ignore = upper->ignore;
 
 	return upper->dev;
 }
@@ -6635,26 +6656,29 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
-int netdev_walk_all_upper_dev(struct net_device *dev,
-			      int (*fn)(struct net_device *dev,
-					void *data),
-			      void *data)
+int netdev_walk_all_upper_dev_ignore(struct net_device *dev,
+				     int (*fn)(struct net_device *dev,
+					       void *data),
+				     void *data)
 {
 	struct net_device *udev;
 	struct list_head *iter;
 	int ret;
+	bool ignore;
 
 	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore);
 	     udev;
-	     udev = netdev_next_upper_dev(dev, &iter)) {
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		/* first is the upper device itself */
 		ret = fn(udev, data);
 		if (ret)
 			return ret;
 
 		/* then look at all of its upper devices */
-		ret = netdev_walk_all_upper_dev(udev, fn, data);
+		ret = netdev_walk_all_upper_dev_ignore(udev, fn, data);
 		if (ret)
 			return ret;
 	}
@@ -6690,6 +6714,15 @@ int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_upper_dev_rcu);
 
+bool netdev_has_upper_dev_ignore(struct net_device *dev,
+				 struct net_device *upper_dev)
+{
+	ASSERT_RTNL();
+
+	return netdev_walk_all_upper_dev_ignore(dev, __netdev_has_upper_dev,
+						upper_dev);
+}
+
 /**
  * netdev_lower_get_next_private - Get the next ->private from the
  *				   lower neighbour list
@@ -6786,6 +6819,23 @@ static struct net_device *netdev_next_lower_dev(struct net_device *dev,
 	return lower->dev;
 }
 
+static struct net_device *netdev_next_lower_dev_ignore(struct net_device *dev,
+						       struct list_head **iter,
+						       bool *ignore)
+{
+	struct netdev_adjacent *lower;
+
+	lower = list_entry((*iter)->next, struct netdev_adjacent, list);
+
+	if (&lower->list == &dev->adj_list.lower)
+		return NULL;
+
+	*iter = &lower->list;
+	*ignore = lower->ignore;
+
+	return lower->dev;
+}
+
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *dev,
 					void *data),
@@ -6814,6 +6864,36 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev);
 
+int netdev_walk_all_lower_dev_ignore(struct net_device *dev,
+				     int (*fn)(struct net_device *dev,
+					       void *data),
+				     void *data)
+{
+	struct net_device *ldev;
+	struct list_head *iter;
+	int ret;
+	bool ignore;
+
+	for (iter = &dev->adj_list.lower,
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore);
+	     ldev;
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
+		/* first is the lower device itself */
+		ret = fn(ldev, data);
+		if (ret)
+			return ret;
+
+		/* then look at all of its lower devices */
+		ret = netdev_walk_all_lower_dev_ignore(ldev, fn, data);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 						    struct list_head **iter)
 {
@@ -6833,11 +6913,14 @@ static u8 __netdev_upper_depth(struct net_device *dev)
 	struct net_device *udev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore);
 	     udev;
-	     udev = netdev_next_upper_dev(dev, &iter)) {
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < udev->upper_level)
 			max_depth = udev->upper_level;
 	}
@@ -6850,11 +6933,14 @@ static u8 __netdev_lower_depth(struct net_device *dev)
 	struct net_device *ldev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev(dev, &iter);
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore);
 	     ldev;
-	     ldev = netdev_next_lower_dev(dev, &iter)) {
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < ldev->lower_level)
 			max_depth = ldev->lower_level;
 	}
@@ -6999,6 +7085,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->master = master;
 	adj->ref_nr = 1;
 	adj->private = private;
+	adj->ignore = false;
 	dev_hold(adj_dev);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
@@ -7149,17 +7236,17 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		return -EBUSY;
 
 	/* To prevent loops, check if dev is not upper device to upper_dev. */
-	if (netdev_has_upper_dev(upper_dev, dev))
+	if (netdev_has_upper_dev_ignore(upper_dev, dev))
 		return -EBUSY;
 
 	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
 		return -EMLINK;
 
 	if (!master) {
-		if (netdev_has_upper_dev(dev, upper_dev))
+		if (netdev_has_upper_dev_ignore(dev, upper_dev))
 			return -EEXIST;
 	} else {
-		master_dev = netdev_master_upper_dev_get(dev);
+		master_dev = netdev_master_upper_dev_get_ignore(dev);
 		if (master_dev)
 			return master_dev == upper_dev ? -EEXIST : -EBUSY;
 	}
@@ -7182,10 +7269,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		goto rollback;
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	netdev_walk_all_lower_dev_ignore(dev, __netdev_update_upper_level,
+					 NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	netdev_walk_all_upper_dev_ignore(upper_dev,
+					 __netdev_update_lower_level, NULL);
 
 	return 0;
 
@@ -7271,13 +7360,44 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 				      &changeupper_info.info);
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	netdev_walk_all_lower_dev_ignore(dev, __netdev_update_upper_level,
+					 NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	netdev_walk_all_upper_dev_ignore(upper_dev,
+					 __netdev_update_lower_level, NULL);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
+void __netdev_adjacent_dev_set(struct net_device *upper_dev,
+			       struct net_device *lower_dev,
+			       bool val)
+{
+	struct netdev_adjacent *adj;
+
+	adj = __netdev_find_adj(lower_dev, &upper_dev->adj_list.lower);
+	if (adj)
+		adj->ignore = val;
+
+	adj = __netdev_find_adj(upper_dev, &lower_dev->adj_list.upper);
+	if (adj)
+		adj->ignore = val;
+}
+
+void netdev_adjacent_dev_disable(struct net_device *upper_dev,
+				 struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, true);
+}
+EXPORT_SYMBOL(netdev_adjacent_dev_disable);
+
+void netdev_adjacent_dev_enable(struct net_device *upper_dev,
+				struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, false);
+}
+EXPORT_SYMBOL(netdev_adjacent_dev_enable);
+
 /**
  * netdev_bonding_info_change - Dispatch event about slave change
  * @dev: device
-- 
2.17.1

