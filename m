Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B95B352773
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 10:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBIcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 04:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhDBIcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 04:32:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52989C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 01:32:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w11so2233094ply.6
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 01:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTCi/2o64nDNAGbYnx51dKy5djiLIUQkMrtt4BVb7CQ=;
        b=h9iDWimhaeaUXZ6h3WENuF09Wpai87avIVLcVky7HrQjwO4jmX/KLnDcgScXygtIAd
         tP1w2MkKinVz2EB8NJEzP3kdSBjGmqJK8Q9BX8wVicQ8H+nd9GCJ+QcM93Md6B6Pd7jf
         ZG2j679JPUSFDFIBBsn/4gEKUMEHW0tU69WHKZIlqZRBhTn/wHXv52Hq9xMGR0/vE6pS
         RSmIt762PV3okwD/GQ5YWCa291o7BlVOiQUnQ9m/k9CUOvUy7LU0ofItvT45g2Cqw5f2
         VqrPKgp3outf+e0HF3ZotmiWmqMiF3NYlE71xLuhnG7o1F89mnKaJjvmjYxKoD2/A04l
         bTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTCi/2o64nDNAGbYnx51dKy5djiLIUQkMrtt4BVb7CQ=;
        b=Sf0PiS9cQ7hlr9fzHDsXpeNAgTwF6TrMUkFeuyA3X90yUEtBQeqYTxYtZADm/ME1jm
         ArF9RUyYQxRtMB6wnXoqk8r00evLA0yuRpnOLNQdw67op+Sh0p0ae5MhzYXpyLUsEPGu
         rejfwXvi6aX/kZT0fNbdYqfABlxz5V7J+/f8BN95PWW0bVItxf8qNlseH7AN9GL59bFo
         i92rCx7xSSqpexbodlejDsibqL4MnJcZ/oit/KTj71C7oKNY2FEIhQ6rOnq1pjS+WDPJ
         GPpw5W5CRjAD84ZxB3nhzBB2u+0Hlz+f/UlL79laS3NRVrYYXpojRJXelWnVGjNnP01J
         t0Hg==
X-Gm-Message-State: AOAM530AUjepkDJBXVfvsDjCUcNpDLCGWw1TwdSi0MlsyH0d2X4j9N6s
        Mv2UkfAjo1Umh6RtOi4UK1Q=
X-Google-Smtp-Source: ABdhPJwgRR/ok2CP/uUeR1sC8vEdG3L6ZHy5WoKJ0c51h1UNZ5sB3zoFeRwj9zD6Y3jqjofj05a1Zg==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr12883836pjb.92.1617352327551;
        Fri, 02 Apr 2021 01:32:07 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id f6sm7930819pfk.11.2021.04.02.01.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 01:32:06 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: [PATCH net-next v2] net: Allow to specify ifindex when device is moved to another namespace
Date:   Fri,  2 Apr 2021 01:29:42 -0700
Message-Id: <20210402082942.1274013-1-avagin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210402073622.1260310-1-avagin@gmail.com>
References: <20210402073622.1260310-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we can specify ifindex on link creation. This change allows
to specify ifindex when a device is moved to another network namespace.

CRIU users want to restore containers with pre-created network devices.
A user will provide network devices and instructions where they have to
be restored, then CRIU will restore network namespaces and move devices
into them. The problem is that devices have to be restored with the same
indexes that they have before C/R.

Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---

v2: initialize new_ifindex to 0 in do_setlink.

 drivers/net/hyperv/netvsc_drv.c |  2 +-
 include/linux/netdevice.h       |  3 ++-
 net/core/dev.c                  | 24 +++++++++++++++++-------
 net/core/rtnetlink.c            | 16 ++++++++++++----
 net/ieee802154/core.c           |  4 ++--
 net/wireless/core.c             |  4 ++--
 6 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 15f262b70489..0f72748217a3 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2368,7 +2368,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	 */
 	if (!net_eq(dev_net(ndev), dev_net(vf_netdev))) {
 		ret = dev_change_net_namespace(vf_netdev,
-					       dev_net(ndev), "eth%d");
+					       dev_net(ndev), "eth%d", 0);
 		if (ret)
 			netdev_err(vf_netdev,
 				   "could not move to same namespace as %s: %d\n",
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87a5d186faff..cab59db40a52 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3923,7 +3923,8 @@ void __dev_notify_flags(struct net_device *, unsigned int old_flags,
 int dev_change_name(struct net_device *, const char *);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
-int dev_change_net_namespace(struct net_device *, struct net *, const char *);
+int dev_change_net_namespace(struct net_device *dev, struct net *net,
+			     const char *pat, int new_ifindex);
 int __dev_set_mtu(struct net_device *, int);
 int dev_validate_mtu(struct net_device *dev, int mtu,
 		     struct netlink_ext_ack *extack);
diff --git a/net/core/dev.c b/net/core/dev.c
index 0f72ff5d34ba..c296ee642e39 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11001,6 +11001,8 @@ EXPORT_SYMBOL(unregister_netdev);
  *	@net: network namespace
  *	@pat: If not NULL name pattern to try if the current device name
  *	      is already taken in the destination network namespace.
+ *	@new_ifindex: If not zero, specifies device index in the target
+ *	              namespace.
  *
  *	This function shuts down a device interface and moves it
  *	to a new network namespace. On success 0 is returned, on
@@ -11009,10 +11011,11 @@ EXPORT_SYMBOL(unregister_netdev);
  *	Callers must hold the rtnl semaphore.
  */
 
-int dev_change_net_namespace(struct net_device *dev, struct net *net, const char *pat)
+int dev_change_net_namespace(struct net_device *dev, struct net *net,
+			     const char *pat, int new_ifindex)
 {
 	struct net *net_old = dev_net(dev);
-	int err, new_nsid, new_ifindex;
+	int err, new_nsid;
 
 	ASSERT_RTNL();
 
@@ -11043,6 +11046,11 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 			goto out;
 	}
 
+	/* Check that new_ifindex isn't used yet. */
+	err = -EBUSY;
+	if (new_ifindex && __dev_get_by_index(net, new_ifindex))
+		goto out;
+
 	/*
 	 * And now a mini version of register_netdevice unregister_netdevice.
 	 */
@@ -11070,10 +11078,12 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
 	new_nsid = peernet2id_alloc(dev_net(dev), net, GFP_KERNEL);
 	/* If there is an ifindex conflict assign a new one */
-	if (__dev_get_by_index(net, dev->ifindex))
-		new_ifindex = dev_new_index(net);
-	else
-		new_ifindex = dev->ifindex;
+	if (!new_ifindex) {
+		if (__dev_get_by_index(net, dev->ifindex))
+			new_ifindex = dev_new_index(net);
+		else
+			new_ifindex = dev->ifindex;
+	}
 
 	rtmsg_ifinfo_newnet(RTM_DELLINK, dev, ~0U, GFP_KERNEL, &new_nsid,
 			    new_ifindex);
@@ -11382,7 +11392,7 @@ static void __net_exit default_device_exit(struct net *net)
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
 		if (__dev_get_by_name(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
-		err = dev_change_net_namespace(dev, &init_net, fb_name);
+		err = dev_change_net_namespace(dev, &init_net, fb_name, 0);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
 				 __func__, dev->name, err);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1bdcb33fb561..3ec257e91ffe 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2603,14 +2603,22 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
 
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
-		struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
-							    tb, CAP_NET_ADMIN);
+		struct net *net;
+		int new_ifindex;
+
+		net = rtnl_link_get_net_capable(skb, dev_net(dev),
+						tb, CAP_NET_ADMIN);
 		if (IS_ERR(net)) {
 			err = PTR_ERR(net);
 			goto errout;
 		}
 
-		err = dev_change_net_namespace(dev, net, ifname);
+		if (tb[IFLA_NEW_IFINDEX])
+			new_ifindex = nla_get_s32(tb[IFLA_NEW_IFINDEX]);
+		else
+			new_ifindex = 0;
+
+		err = dev_change_net_namespace(dev, net, ifname, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
@@ -3452,7 +3460,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto out_unregister;
 	if (link_net) {
-		err = dev_change_net_namespace(dev, dest_net, ifname);
+		err = dev_change_net_namespace(dev, dest_net, ifname, 0);
 		if (err < 0)
 			goto out_unregister;
 	}
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index de259b5170ab..ec3068937fc3 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -205,7 +205,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		if (!wpan_dev->netdev)
 			continue;
 		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
-		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
+		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d", 0);
 		if (err)
 			break;
 		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
@@ -222,7 +222,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 				continue;
 			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
-						       "wpan%d");
+						       "wpan%d", 0);
 			WARN_ON(err);
 			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a2785379df6e..fabb677b7d58 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -165,7 +165,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		if (!wdev->netdev)
 			continue;
 		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
-		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d", 0);
 		if (err)
 			break;
 		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
@@ -182,7 +182,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 				continue;
 			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d");
+							"wlan%d", 0);
 			WARN_ON(err);
 			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
-- 
2.29.2

