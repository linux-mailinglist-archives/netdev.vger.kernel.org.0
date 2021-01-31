Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51637309A03
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 03:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhAaC3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 21:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhAaC3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 21:29:04 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB4C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 18:28:24 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id v1so12739060ott.10
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 18:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+DIOYVRS5vbyf8QfDfu1yayVniKwHQJxt8jFFZuxzYQ=;
        b=HL4CxUA89J4DMohYbaiR1117JvchZucjo8nL47jQir6MgrPYkRgz7g10CUOXZ/37kO
         q3viP6H9gTKjzqgmnzNBSIrQIQ3j+IStF5XLwTou8vIrqUk9LpoJ4SNcnoE8bbCl1RpL
         6wT1IfEHchqIg0L8ShifuRV+ufNq21BpXg0MDYL8VSTvJ8kvGUq5X7wzvi84D5qsRLJi
         X6Tc9kfxFpyB9eCovIOjLOzJ5FnyjNwjrXKGfJX+gfCtis2NCZyyYK38C2OKp6Me0BWt
         Fe5BF2ArvJgSx/mPoJ+UIwYpvhLmW6Ok3BUw9uaOFksyJriHVHcx9Tk8do9EPmFAf3nY
         zcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+DIOYVRS5vbyf8QfDfu1yayVniKwHQJxt8jFFZuxzYQ=;
        b=eR63y75mg54drdfkfOZvRveRfqyeyisAYFp+A9K83E/ZHvLDWf/yD+OvCYWIIm7YQ9
         F5DkC6lUovM2Pb4R6cklUjr4+feFtkojibaNzLQ78Hnsbp00hxje8uOJ8aHY9wrp29kM
         H2MRvLZTdNhUOIS+sg7/EaXy2y5iEjykFXUMd1PBEYJebzhyIZFqkGsSrriTo2uN+rZm
         XZpqzTk+OGJzxM7gT4BfTBc1tren8nKoWP6svNqiHK8cXlV2AwsSFtY48fDK1mF4zLX2
         KpDtNcybSRZvJOES46xqGV69+wXxX0FTINDpoAO9HMxpV6YVUNcAxXCD6St2NjjSS1Zd
         IBhg==
X-Gm-Message-State: AOAM531GkbfoEFks5xWQiK5nYqFY+TADuSOBi+gaUkE5OjHIA0Tn9yX+
        TsGixol7fZLuAN7dxzFeq6dhhFfCrYFGvw==
X-Google-Smtp-Source: ABdhPJw7rtO4XLFT3FqQs4S7keCozjZZnNGsPPkTI7A1WvjhOen5rRU17cNddThtezKeD81jgLloWw==
X-Received: by 2002:a05:6830:2012:: with SMTP id e18mr7533101otp.32.1612060103374;
        Sat, 30 Jan 2021 18:28:23 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:b17d:dead:8ea2:9775])
        by smtp.gmail.com with ESMTPSA id h11sm3412771ooj.36.2021.01.30.18.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 18:28:22 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net-next v2] net: fix dev_ifsioc_locked() race condition
Date:   Sat, 30 Jan 2021 18:27:55 -0800
Message-Id: <20210131022755.106005-1-xiyou.wangcong@gmail.com>
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
like netdev_get_name(). The writers take RTNL anyway, so this
will not affect the slow path. To avoid bothering existing
dev_set_mac_address() callers in drivers, introduce a new wrapper
just for user-facing callers in ioctl and rtnetlink.

Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/netdevice.h |  3 +++
 net/core/dev.c            | 40 +++++++++++++++++++++++++++++++++++++++
 net/core/dev_ioctl.c      | 20 +++++++-------------
 net/core/rtnetlink.c      |  2 +-
 4 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9e7ada07ea1..8f13d3177130 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3907,6 +3907,9 @@ int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
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
index aae116d059da..ecc7914784d2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8773,6 +8773,46 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
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

