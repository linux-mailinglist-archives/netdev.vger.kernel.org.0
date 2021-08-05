Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838323E1056
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhHEIcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhHEIcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:32:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77AFC0613C1
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 01:31:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d6so7190429edt.7
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 01:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lVLHJ/rUmIwH9d0tsdHnyim0dUDtw7h/R/oKAOMcOow=;
        b=HGgzHK/h8rwIMMCGNhJLnbHrTLp+DPUIPwB2Se2+Id4KuCpvSM91lRJFhQgqId8dVx
         wuyELm8tj3UoJCkzsmorfzwOSgjQcU7JWvz3Ulk9ThzrO1nK61BLkmnRGiDB02bjIQTx
         pY+nSbI+YXnM/2KGZhKsD5iufQ/Y61EBrLNXqXIl19W1o5h8fzI5PAddkvYNuQKLVr0W
         jBcFAbOf5cTDlxBwvC4cawXxDg3/j/xGwoYzHz5lKzmG3+s9t3n6skdnI8ozAg0MRu4K
         76KeSv+9YqDgcq/GF3B4TxeTVYujaqyzhZmZo6+ttBa0Z1/atIJsFisRd3uNwYtq024T
         w0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lVLHJ/rUmIwH9d0tsdHnyim0dUDtw7h/R/oKAOMcOow=;
        b=tRjDVlau3wjtiqZ32jKBIQu/X7dov+C2e24XPUMwsfQRjpGsE+V2xx0fpe+13hylLq
         CEkmarfuribfYxuX1Z/h8Tp+C5uAv5EUrWRCqGf7ORRFkZ7tdjC7S1yqDBdLcX5/mpCJ
         12+NzLIWDelHsEu3zZA62b2DzZkgvAXqaCq6aOFSu/T0gwiaFWW1GuiUseLmDEjNqTb7
         tGo93Bn2iP+t5fI302MZB8UBPmJ8weRrd6I0RCecjvFEl7rs1+Mu2906JzEbEKL2Fv9Q
         /iBYab6GosR4lmF8N6pkXO9S87SOQ0MFwjcRgC9Eor7l4gZLrvbKv6bgfpm8ava34yXe
         A+5w==
X-Gm-Message-State: AOAM531qBW6IedqjIl8Vu7QZudWUZuFoNhHDO5Bex2Tw16aNBofVe7dP
        mmwJXW6VWsRRb9U2mJsyMAZfpCPdB7C3L852
X-Google-Smtp-Source: ABdhPJxpQ3i9QP52/FVVh+sijD2Vj4NoGMg7taH8QPbhPq6Ynz137BAsZZwhd6DJd8jinwueXW0/Mw==
X-Received: by 2002:a05:6402:1202:: with SMTP id c2mr4981398edw.216.1628152316233;
        Thu, 05 Aug 2021 01:31:56 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bm1sm1471611ejb.38.2021.08.05.01.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 01:31:55 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, arnd@arndb.de, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com
Subject: [PATCH net-next 1/3] net: bridge: fix ioctl locking
Date:   Thu,  5 Aug 2021 11:29:01 +0300
Message-Id: <20210805082903.711396-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805082903.711396-1-razor@blackwall.org>
References: <20210805082903.711396-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Before commit ad2f99aedf8f ("net: bridge: move bridge ioctls out of
.ndo_do_ioctl") the bridge ioctl calls were divided in two parts:
one was deviceless called by sock_ioctl and didn't expect rtnl to be held,
the other was with a device called by dev_ifsioc() and expected rtnl to be
held. After the commit above they were united in a single ioctl stub, but
it didn't take care of the locking expectations.
For sock_ioctl now we acquire  (1) br_ioctl_mutex, (2) rtnl
and for dev_ifsioc we acquire  (1) rtnl,           (2) br_ioctl_mutex

The fix is to get a refcnt on the netdev for dev_ifsioc calls and drop rtnl
then to reacquire it in the bridge ioctl stub after br_ioctl_mutex has
been acquired. That will avoid playing locking games and make the rules
straight-forward: we always take br_ioctl_mutex first, and then rtnl.

Reported-by: syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com
Fixes: ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_if.c    |  4 +---
 net/bridge/br_ioctl.c | 37 ++++++++++++++++++++++++-------------
 net/core/dev_ioctl.c  |  7 ++++++-
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 86f6d7e93ea8..67c60240b713 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -456,7 +456,7 @@ int br_add_bridge(struct net *net, const char *name)
 	dev_net_set(dev, net);
 	dev->rtnl_link_ops = &br_link_ops;
 
-	res = register_netdev(dev);
+	res = register_netdevice(dev);
 	if (res)
 		free_netdev(dev);
 	return res;
@@ -467,7 +467,6 @@ int br_del_bridge(struct net *net, const char *name)
 	struct net_device *dev;
 	int ret = 0;
 
-	rtnl_lock();
 	dev = __dev_get_by_name(net, name);
 	if (dev == NULL)
 		ret =  -ENXIO; 	/* Could not find device */
@@ -485,7 +484,6 @@ int br_del_bridge(struct net *net, const char *name)
 	else
 		br_dev_delete(dev, NULL);
 
-	rtnl_unlock();
 	return ret;
 }
 
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 46a24c20e405..2f848de3e755 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -369,33 +369,44 @@ static int old_deviceless(struct net *net, void __user *uarg)
 int br_ioctl_stub(struct net *net, struct net_bridge *br, unsigned int cmd,
 		  struct ifreq *ifr, void __user *uarg)
 {
+	int ret = -EOPNOTSUPP;
+
+	rtnl_lock();
+
 	switch (cmd) {
 	case SIOCGIFBR:
 	case SIOCSIFBR:
-		return old_deviceless(net, uarg);
-
+		ret = old_deviceless(net, uarg);
+		break;
 	case SIOCBRADDBR:
 	case SIOCBRDELBR:
 	{
 		char buf[IFNAMSIZ];
 
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			return -EPERM;
+		if (!ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
 
-		if (copy_from_user(buf, uarg, IFNAMSIZ))
-			return -EFAULT;
+		if (copy_from_user(buf, uarg, IFNAMSIZ)) {
+			ret = -EFAULT;
+			break;
+		}
 
 		buf[IFNAMSIZ-1] = 0;
 		if (cmd == SIOCBRADDBR)
-			return br_add_bridge(net, buf);
-
-		return br_del_bridge(net, buf);
+			ret = br_add_bridge(net, buf);
+		else
+			ret = br_del_bridge(net, buf);
 	}
-
+		break;
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
-		return add_del_if(br, ifr->ifr_ifindex, cmd == SIOCBRADDIF);
-
+		ret = add_del_if(br, ifr->ifr_ifindex, cmd == SIOCBRADDIF);
+		break;
 	}
-	return -EOPNOTSUPP;
+
+	rtnl_unlock();
+
+	return ret;
 }
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 4035bce06bf8..ff16326f5903 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -379,7 +379,12 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 	case SIOCBRDELIF:
 		if (!netif_device_present(dev))
 			return -ENODEV;
-		return br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
+		dev_hold(dev);
+		rtnl_unlock();
+		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
+		dev_put(dev);
+		rtnl_lock();
+		return err;
 
 	case SIOCSHWTSTAMP:
 		err = net_hwtstamp_validate(ifr);
-- 
2.31.1

