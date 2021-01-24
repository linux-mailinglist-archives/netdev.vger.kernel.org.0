Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7D301925
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 02:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbhAXBbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 20:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAXBbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 20:31:37 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D09C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 17:30:57 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id f6so9205661ots.9
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 17:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rWuD7/UdEKkAvZyN/HCh00L9JsThjMbZZFDH8HahTCc=;
        b=I0O+e+7ZfRFdUBckO4zswEUZPJoI7bu3azpx6E9eYgXoqRN+bXkLmi64Wwz5y3rZvy
         kCqR/vj+k/hb55vGOBSF4AvJ3vFwpr5yAYKR90OLiUKH5/MWQf5RVdFLHUyD2FWX5A+S
         DZPTDyAYjiZHy25eNFeoxQT7tXpQPz68MeAZ+Eim+l6qWRnwYArS4J3obMwvVm8ojtHT
         BM4ug5kzaXAtlbh8MWhysHjp5hqBY6H/AY7REyIxWvOOVD0hN3MkqPR342sV9MD4eXlJ
         JsjHy4nzZjljrJcqkhnvn5b6oe38qhomRwp7AAou9KArQYOg3qhNXR7AoCWwNZgQzk5D
         DFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rWuD7/UdEKkAvZyN/HCh00L9JsThjMbZZFDH8HahTCc=;
        b=E798xe9gh+XoPp8C1PmGYDQ5AocUsIUtqUUiyI+04Jfg4F6tjwGrzCexjJTM+O8HEB
         OwI+tNlw7lPGD5QFNVFc8aotq3DloXFSlDXbcfB5w2Cncx6r3doM9BpZoxGeS4E5VLee
         kdhDow6S0Xpv0nj8Pl3Fisc96UQYdlt+TteDb02C0TG/wQh6oAtWZ5/XjKI6+Ae03Roa
         AZn4Bf2Bv2RnSZY7J9mw44tPg5U7uwATgbqaL1B9eZEkLjPVeKQwe2f0BFLeKEyJAoMN
         EyfKYisZmF5Dbp83Mj0UbKyB9Yy0DiuMM8y2HdC9kRSMdBSokZ9pN1vfDCkf7zorU366
         /4EQ==
X-Gm-Message-State: AOAM531etnKOeDEYv5lDg7v6GEOZGDTKaIhlXqzCgyvv+WjdVluRK7cs
        BBTBNaYZdyZGZjVzwmQkUAOMchTSldCWLA==
X-Google-Smtp-Source: ABdhPJwVyq/lY234cO4Qebdc6EbtwfuaBwHPmwmrBvtRd9uv4ZBt69hZI50Yc8mpIMN4ZApLoqKW5Q==
X-Received: by 2002:a9d:6393:: with SMTP id w19mr7923888otk.204.1611451856169;
        Sat, 23 Jan 2021 17:30:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id q26sm1173158otg.28.2021.01.23.17.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 17:30:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [Patch net] net: fix dev_ifsioc_locked() race condition
Date:   Sat, 23 Jan 2021 17:30:49 -0800
Message-Id: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
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
will not affect the slow path.

Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 39 ++++++++++++++++++++++++++++++++++++---
 net/core/dev_ioctl.c      | 18 ++++++------------
 3 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 259be67644e3..7a871f2dcc03 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3918,6 +3918,7 @@ int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
 			      struct netlink_ext_ack *extack);
 int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 			struct netlink_ext_ack *extack);
+int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_change_carrier(struct net_device *, bool new_carrier);
 int dev_get_phys_port_id(struct net_device *dev,
 			 struct netdev_phys_item_id *ppid);
diff --git a/net/core/dev.c b/net/core/dev.c
index a979b86dbacd..55c0db7704c7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8709,6 +8709,8 @@ int dev_pre_changeaddr_notify(struct net_device *dev, const char *addr,
 }
 EXPORT_SYMBOL(dev_pre_changeaddr_notify);
 
+static DECLARE_RWSEM(dev_addr_sem);
+
 /**
  *	dev_set_mac_address - Change Media Access Control Address
  *	@dev: device
@@ -8729,19 +8731,50 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 		return -EINVAL;
 	if (!netif_device_present(dev))
 		return -ENODEV;
+
+	down_write(&dev_addr_sem);
 	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
 	if (err)
-		return err;
+		goto out;
 	err = ops->ndo_set_mac_address(dev, sa);
 	if (err)
-		return err;
+		goto out;
 	dev->addr_assign_type = NET_ADDR_SET;
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	add_device_randomness(dev->dev_addr, dev->addr_len);
-	return 0;
+out:
+	up_write(&dev_addr_sem);
+	return err;
 }
 EXPORT_SYMBOL(dev_set_mac_address);
 
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
index db8a0ff86f36..bfa0dbd3d36f 100644
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
-- 
2.25.1

