Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A2354E2E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbhDFH5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhDFH5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:57:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756DC06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 00:57:22 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k8so9785192pgf.4
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 00:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxHR8ud80mzTgL5XgPhpFAUDg/TS1DRdCpAzsEiVWA4=;
        b=NvSMOx9EnBKWDaG7Bqzxmx2PWt2wg6DSp07lUOU3Dfec57169cBopWizHXlk591DKB
         W0lXAvOFpv/Xc6GIzea1SxFcCB27+CJxKT/FmFd2mVO2kA3wMEvxkljAG/6bfe1trbMd
         COgL1Cxx3aHick0sylCpLSZ6Kcu9G0gPcdbNtYKzNwT4N5LDl4vTjGZZGggMdrfF/RPw
         UVX+t9PQI2GNTkkGiyfdEoCNtOao+IsdZ6heKQyEGKx6h/XU5AXkdcBk6Dk7lw2xq9/M
         QDjFWPu6RONN9LdQLZmi4zl+Hju/e9BcqNGQR1sQWj9/2gbxOEtt55muwIARJ1K6OQOw
         K3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxHR8ud80mzTgL5XgPhpFAUDg/TS1DRdCpAzsEiVWA4=;
        b=ttrXfuTAzM8fcHYdeH2AuVkO7X0Xn7e46h79UmwOzLkMFxFzyhj7drQQDODd6l8EbK
         T0J4+t7yaiAACvs5+ELpyBmJK+M6IRVvK4tMKONqFkxEyRc7BZQJOjm1aDZvK4PTOXzP
         8G6aQWSTmsockX+GdpAwoLcszSFE26S76RiPZWIqr1g9xC12AEd2EKMgRXds5/nFMCMy
         dhEYRqAb1sr1Dxoaf94a4tt0a+Bn76y/p/iPiqIZIX9TT+lAOa05pWvTeuj5ORK00vNz
         s3ylbfKPUB3JWuJvKGwSOjn3qhoqY9GcXOnrEpjnOGTPr118JJgzo4G+xiQ+bwuKVQuY
         3g8g==
X-Gm-Message-State: AOAM530N+UlYpRPHeZ5/pzKrtYB4fjCHxfw5xNazA6fHf7kUiRnBqmon
        A6eghtCckjXuKK/wa+mIARk=
X-Google-Smtp-Source: ABdhPJyxX5SMmjG2LPjHS/KtiHs2sRBpwDgDHUQ3ThbY4cWOoI1dXBKSre329glSBKhaCZxfXJzZ7A==
X-Received: by 2002:a63:dd14:: with SMTP id t20mr26148094pgg.258.1617695841760;
        Tue, 06 Apr 2021 00:57:21 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id i1sm18425419pfu.96.2021.04.06.00.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 00:57:21 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: [PATCH net-next v4] net: Allow to specify ifindex when device is moved to another namespace
Date:   Tue,  6 Apr 2021 00:54:48 -0700
Message-Id: <20210406075448.203816-1-avagin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we can specify ifindex on link creation. This change allows
to specify ifindex when a device is moved to another network namespace.

Even now, a device ifindex can be changed if there is another device
with the same ifindex in the target namespace. So this change doesn't
introduce completely new behavior, it adds more control to the process.

CRIU users want to restore containers with pre-created network devices.
A user will provide network devices and instructions where they have to
be restored, then CRIU will restore network namespaces and move devices
into them. The problem is that devices have to be restored with the same
indexes that they have before C/R.

Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---

v2: initialize new_ifindex to 0 in do_setlink.
v3: check that new_ifindex is positive.
v4: - use ifla_policy to validate IFLA_NEW_IFINDEX.
    - don't change the prototype of dev_change_net_namespace that is
      used in many places.

 include/linux/netdevice.h |  9 ++++++++-
 net/core/dev.c            | 26 ++++++++++++++++++--------
 net/core/rtnetlink.c      | 15 ++++++++++++---
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f57b70fc251f..5cbc950b34df 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4026,7 +4026,14 @@ void __dev_notify_flags(struct net_device *, unsigned int old_flags,
 int dev_change_name(struct net_device *, const char *);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
-int dev_change_net_namespace(struct net_device *, struct net *, const char *);
+int __dev_change_net_namespace(struct net_device *dev, struct net *net,
+			       const char *pat, int new_ifindex);
+static inline
+int dev_change_net_namespace(struct net_device *dev, struct net *net,
+			     const char *pat)
+{
+	return __dev_change_net_namespace(dev, net, pat, 0);
+}
 int __dev_set_mtu(struct net_device *, int);
 int dev_validate_mtu(struct net_device *dev, int mtu,
 		     struct netlink_ext_ack *extack);
diff --git a/net/core/dev.c b/net/core/dev.c
index b4c67a5be606..33ff4a944109 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11062,11 +11062,13 @@ void unregister_netdev(struct net_device *dev)
 EXPORT_SYMBOL(unregister_netdev);
 
 /**
- *	dev_change_net_namespace - move device to different nethost namespace
+ *	__dev_change_net_namespace - move device to different nethost namespace
  *	@dev: device
  *	@net: network namespace
  *	@pat: If not NULL name pattern to try if the current device name
  *	      is already taken in the destination network namespace.
+ *	@new_ifindex: If not zero, specifies device index in the target
+ *	              namespace.
  *
  *	This function shuts down a device interface and moves it
  *	to a new network namespace. On success 0 is returned, on
@@ -11075,10 +11077,11 @@ EXPORT_SYMBOL(unregister_netdev);
  *	Callers must hold the rtnl semaphore.
  */
 
-int dev_change_net_namespace(struct net_device *dev, struct net *net, const char *pat)
+int __dev_change_net_namespace(struct net_device *dev, struct net *net,
+			       const char *pat, int new_ifindex)
 {
 	struct net *net_old = dev_net(dev);
-	int err, new_nsid, new_ifindex;
+	int err, new_nsid;
 
 	ASSERT_RTNL();
 
@@ -11109,6 +11112,11 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
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
@@ -11136,10 +11144,12 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
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
@@ -11192,7 +11202,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(dev_change_net_namespace);
+EXPORT_SYMBOL_GPL(__dev_change_net_namespace);
 
 static int dev_cpu_dead(unsigned int oldcpu)
 {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1bdcb33fb561..9f1f55785a6f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1877,6 +1877,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
+	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2603,14 +2604,22 @@ static int do_setlink(const struct sk_buff *skb,
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
+		err = __dev_change_net_namespace(dev, net, ifname, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
-- 
2.29.2

