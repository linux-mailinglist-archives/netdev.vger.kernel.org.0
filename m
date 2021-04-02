Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E2E3526FD
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 09:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhDBHiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 03:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhDBHis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 03:38:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63147C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 00:38:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t18so2347618pjs.3
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 00:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQyosvpYzgaNLnK4CTFKYypMlXR24eWULckLtBc2ljQ=;
        b=FVJtWp3DjCS0fEXtGjZKAJFHr4T+8hDTBgLciJlvDhnvOJV9aOkdUbhh1Q/Flu8Nxv
         1ccGLcSWmPmNY+1nlEefN7UhDvnns9vJ9z8rezUS7Ks3px2ZsvRUoLnRvNXwjHeK4/yq
         RSDP0RV7WnFmB0fBJl6z41nGqpeAIyihFX2NHawhqvHWCNwLii7atqBW93qKagzKwulC
         wq+vegCMNLP+O1jisk4oDyyJKIZLZUfNL8gVl+kWz3u3ioPQ63aXbt5wZ3TvZjrBMKkq
         BWhtyciLvL2VhtITZyB3ZykwLdmHPBa3BGcuCy5uSshSmQL62w5jsIYuaV12eaFJDGEy
         MFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQyosvpYzgaNLnK4CTFKYypMlXR24eWULckLtBc2ljQ=;
        b=jNjFeE1+ihbYeoR54s84hM/7a7hiAAQs4hqS3VZfGgnVtTX4ufcqvxSGBL+Admzb2r
         nchCTmo1RwqHZaSBkc6fShgXkaJ+3Jkcf/Uf31Ev1UCrEUNRTBiHTZcDyp0+nV4Yo9Xy
         uykjsb5pVaB/F1oQpdmJA5o2pE5YCpHn/Ie8OJ54YcLk9yRBHamb4Xo/19XLzQ8kOnTB
         OeTqMntFCj5HkluCRPWeuDM5dELfKs38LcRcoJFvlDfRvOl+jGumgH3tKdu+nH3ZO7za
         wuucsgN/0m2FuWjk4t6Bjdk2Mc/2IPucLcZkMpSBJ897NUIgxfjrB7XMegDN5qZ01TEp
         wfkg==
X-Gm-Message-State: AOAM532bY9AZg0Z1OhhPyDU1q0NwHhPQrszoeyX3ZOxp5YBTT6dBPv2y
        ks2ZpgBLAFPUERVcNGSSOPTjV0mpiWg92w==
X-Google-Smtp-Source: ABdhPJxvw1UYyAIWpI1rGN07eSTZG/QJSLo8i4LaMdX9pqBZlDbpLcoH8Dn/CZz/bX0VK1uLKh+CSw==
X-Received: by 2002:a17:903:18a:b029:e6:7fc1:1c2a with SMTP id z10-20020a170903018ab02900e67fc11c2amr11479191plg.5.1617349127800;
        Fri, 02 Apr 2021 00:38:47 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id d11sm7273251pjz.47.2021.04.02.00.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 00:38:47 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: [PATCH net-next] net: Allow to specify ifindex when device is moved to another namespace
Date:   Fri,  2 Apr 2021 00:36:22 -0700
Message-Id: <20210402073622.1260310-1-avagin@gmail.com>
X-Mailer: git-send-email 2.29.2
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
 drivers/net/hyperv/netvsc_drv.c |  2 +-
 include/linux/netdevice.h       |  3 ++-
 net/core/dev.c                  | 24 +++++++++++++++++-------
 net/core/rtnetlink.c            | 14 ++++++++++----
 net/ieee802154/core.c           |  4 ++--
 net/wireless/core.c             |  4 ++--
 6 files changed, 34 insertions(+), 17 deletions(-)

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
index 1bdcb33fb561..9508d3a0a28f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2603,14 +2603,20 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
 
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
-		struct net *net = rtnl_link_get_net_capable(skb, dev_net(dev),
-							    tb, CAP_NET_ADMIN);
+		int new_ifindex = -1;
+		struct net *net;
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
+
+		err = dev_change_net_namespace(dev, net, ifname, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
@@ -3452,7 +3458,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
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

