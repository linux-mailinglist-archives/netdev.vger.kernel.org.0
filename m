Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02E319330
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBKTfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhBKTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:34:54 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B3FC061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:34:14 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id f26so1562639oog.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 11:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6G8t/4iZwxuvKvgLEemriAVK07s7eKC+2uNf5nfOsE=;
        b=JsnSncvfB0lhXxSP/Tgmfg2Jx0vi6JXiaMzKx8dEOT+2cF5/U2R+0bWL0WyMkGH8ep
         fV/KTaH68w5Psz0ofbYw4esHC/uKbAZA4WimA4NwP4NtWKEksJE/y9tXNxJUndzd8C68
         yzTMyCVHHAaGDltVLFZzfncYku1XmPmIDjKWTa9VUzAssb377mDT3ZbzMgCqd/3TeA1a
         Eanj5R1W8otkWuFFMP1kaESFz8O1IPiMQMPPCQvlC0WwT+tvcPbBAFm9pt8hWS4Wm/PK
         df+Sdy2yyaQ6nvKCztxb1EeeGaS/uwr1nuFVBM8eryNngKPPCE6NwefUHoyJDdCwCgRy
         7pCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6G8t/4iZwxuvKvgLEemriAVK07s7eKC+2uNf5nfOsE=;
        b=ewTzriLMJiNshQGBMu+hJ3Q2X1e/UFxpqDFzEzrK28ADvncNj2ADIoCls4B8wG03+I
         RASK/Bl8J+fDYb7IjN6Aju7KevdUz387PTEmeNw1mGtkE0LN5z4J7YPNPG07mYa9/uWB
         cOuCUG0ntbeMyww5cJ9kIoxQX+G3rv7eAyr8p+5DvYVzyBzmyfY7ppsdj8jcoK48KZvc
         E1v7zoOMleoMu7iEziVZGn8XD7cwSQArrul17WIKN3MzrOP+/wTvsl5Gj+/FbS4zkQAW
         NeHkLl30OefBY2WPkBWEsTNoRgwDQjwH25I71c9ABg02bRg6fAVmPVYgxai6L9DGVaP+
         bYTA==
X-Gm-Message-State: AOAM532P2lAUdwic/yOxoWL9lZ3UduyG6/BfQdlV329CnKa/yPLh3cIB
        6ZkQkg3Zq3lR6dV+m540bm6g2DBUNbsyjg==
X-Google-Smtp-Source: ABdhPJxNiqn9f+ebF0IpjcBWPSnSqemuh3w7h+FDNhvgnw1KFO+VyR/R+I3mKm8E9zA9TzMO2H/8qA==
X-Received: by 2002:a4a:bd9a:: with SMTP id k26mr6444386oop.62.1613072053643;
        Thu, 11 Feb 2021 11:34:13 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id i12sm1187850ots.17.2021.02.11.11.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 11:34:13 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net-next v3] net: fix dev_ifsioc_locked() race condition
Date:   Thu, 11 Feb 2021 11:34:10 -0800
Message-Id: <20210211193410.172700-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

dev_ifsioc_locked() is called with only RCU read lock, so when
there is a parallel writer changing the mac address, it could
get a partially updated mac address, as shown below:

Thread 1			Thread 2
// eth_commit_mac_addr_change()
memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
				// dev_ifsioc_locked()
				memcpy(ifr->ifr_hwaddr.sa_data,
					dev->dev_addr,...);

Close this race condition by guarding them with a RW semaphore,
like netdev_get_name(). We can not use seqlock here as it does not
allow blocking. The writers already take RTNL anyway, so this does
not affect the slow path. To avoid bothering existing
dev_set_mac_address() callers in drivers, introduce a new wrapper
just for user-facing callers on ioctl and rtnetlink paths.

Note, bonding also changes slave mac addresses but that requires
a separate patch due to the complexity of bonding code.

Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 drivers/net/tap.c         |  7 +++----
 drivers/net/tun.c         |  5 ++---
 include/linux/netdevice.h |  3 +++
 net/core/dev.c            | 42 +++++++++++++++++++++++++++++++++++++++
 net/core/dev_ioctl.c      | 20 +++++++------------
 net/core/rtnetlink.c      |  2 +-
 6 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ff4aa35979a1..8e3a28ba6b28 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1090,10 +1090,9 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 			return -ENOLINK;
 		}
 		ret = 0;
-		u = tap->dev->type;
+		dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
 		if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
-		    copy_to_user(&ifr->ifr_hwaddr.sa_data, tap->dev->dev_addr, ETH_ALEN) ||
-		    put_user(u, &ifr->ifr_hwaddr.sa_family))
+		    copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
 			ret = -EFAULT;
 		tap_put_tap_dev(tap);
 		rtnl_unlock();
@@ -1108,7 +1107,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 			rtnl_unlock();
 			return -ENOLINK;
 		}
-		ret = dev_set_mac_address(tap->dev, &sa, NULL);
+		ret = dev_set_mac_address_user(tap->dev, &sa, NULL);
 		tap_put_tap_dev(tap);
 		rtnl_unlock();
 		return ret;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 62690baa19bc..fc86da7f1628 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3107,15 +3107,14 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 
 	case SIOCGIFHWADDR:
 		/* Get hw address */
-		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
-		ifr.ifr_hwaddr.sa_family = tun->dev->type;
+		dev_get_mac_address(&ifr.ifr_hwaddr, net, tun->dev->name);
 		if (copy_to_user(argp, &ifr, ifreq_len))
 			ret = -EFAULT;
 		break;
 
 	case SIOCSIFHWADDR:
 		/* Set hw address */
-		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr, NULL);
+		ret = dev_set_mac_address_user(tun->dev, &ifr.ifr_hwaddr, NULL);
 		break;
 
 	case TUNGETSNDBUF:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a20310ff5083..bfadf3b82f9c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3902,6 +3902,9 @@ int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
 			      struct netlink_ext_ack *extack);
 int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 			struct netlink_ext_ack *extack);
+int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
+			     struct netlink_ext_ack *extack);
+int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_change_carrier(struct net_device *, bool new_carrier);
 int dev_get_phys_port_id(struct net_device *dev,
 			 struct netdev_phys_item_id *ppid);
diff --git a/net/core/dev.c b/net/core/dev.c
index 321d41a110e7..ce6291bc2e16 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8937,6 +8937,48 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 }
 EXPORT_SYMBOL(dev_set_mac_address);
 
+static DECLARE_RWSEM(dev_addr_sem);
+
+int dev_set_mac_address_user(struct net_device *dev, struct sockaddr *sa,
+			     struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	down_write(&dev_addr_sem);
+	ret = dev_set_mac_address(dev, sa, extack);
+	up_write(&dev_addr_sem);
+	return ret;
+}
+EXPORT_SYMBOL(dev_set_mac_address_user);
+
+int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
+{
+	size_t size = sizeof(sa->sa_data);
+	struct net_device *dev;
+	int ret = 0;
+
+	down_read(&dev_addr_sem);
+	rcu_read_lock();
+
+	dev = dev_get_by_name_rcu(net, dev_name);
+	if (!dev) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+	if (!dev->addr_len)
+		memset(sa->sa_data, 0, size);
+	else
+		memcpy(sa->sa_data, dev->dev_addr,
+		       min_t(size_t, size, dev->addr_len));
+	sa->sa_family = dev->type;
+
+unlock:
+	rcu_read_unlock();
+	up_read(&dev_addr_sem);
+	return ret;
+}
+EXPORT_SYMBOL(dev_get_mac_address);
+
 /**
  *	dev_change_carrier - Change device carrier
  *	@dev: device
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index db8a0ff86f36..478d032f34ac 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -123,17 +123,6 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 		ifr->ifr_mtu = dev->mtu;
 		return 0;
 
-	case SIOCGIFHWADDR:
-		if (!dev->addr_len)
-			memset(ifr->ifr_hwaddr.sa_data, 0,
-			       sizeof(ifr->ifr_hwaddr.sa_data));
-		else
-			memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
-			       min(sizeof(ifr->ifr_hwaddr.sa_data),
-				   (size_t)dev->addr_len));
-		ifr->ifr_hwaddr.sa_family = dev->type;
-		return 0;
-
 	case SIOCGIFSLAVE:
 		err = -EINVAL;
 		break;
@@ -274,7 +263,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	case SIOCSIFHWADDR:
 		if (dev->addr_len > sizeof(struct sockaddr))
 			return -EINVAL;
-		return dev_set_mac_address(dev, &ifr->ifr_hwaddr, NULL);
+		return dev_set_mac_address_user(dev, &ifr->ifr_hwaddr, NULL);
 
 	case SIOCSIFHWBROADCAST:
 		if (ifr->ifr_hwaddr.sa_family != dev->type)
@@ -418,6 +407,12 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	 */
 
 	switch (cmd) {
+	case SIOCGIFHWADDR:
+		dev_load(net, ifr->ifr_name);
+		ret = dev_get_mac_address(&ifr->ifr_hwaddr, net, ifr->ifr_name);
+		if (colon)
+			*colon = ':';
+		return ret;
 	/*
 	 *	These ioctl calls:
 	 *	- can be done by all.
@@ -427,7 +422,6 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCGIFFLAGS:
 	case SIOCGIFMETRIC:
 	case SIOCGIFMTU:
-	case SIOCGIFHWADDR:
 	case SIOCGIFSLAVE:
 	case SIOCGIFMAP:
 	case SIOCGIFINDEX:
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c313aaf2bce1..0edc0b2baaa4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2660,7 +2660,7 @@ static int do_setlink(const struct sk_buff *skb,
 		sa->sa_family = dev->type;
 		memcpy(sa->sa_data, nla_data(tb[IFLA_ADDRESS]),
 		       dev->addr_len);
-		err = dev_set_mac_address(dev, sa, extack);
+		err = dev_set_mac_address_user(dev, sa, extack);
 		kfree(sa);
 		if (err)
 			goto errout;
-- 
2.25.1

