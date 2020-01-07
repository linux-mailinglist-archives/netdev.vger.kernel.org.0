Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12B61322BD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgAGJme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:42:34 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:42473 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgAGJme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:42:34 -0500
Received: by mail-pl1-f202.google.com with SMTP id b5so20500807pls.9
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xqy0iH8ZPmPaaheZw7wHrktKJsAwLVkMrIJokUvF7Lc=;
        b=hu47gXXL9CCYLKmrq9vOmqYay4vRwoZx6ySqEB7J6VAtFrs4J9CvYt/wGJr32QinFu
         EXQ3Q8WksEbBw6lSn2dXVYX8FKyd4YHW1cb2/TYM4hd7HbNof/7KbswNusQF4pdWKHMG
         BZ49Q2isUpMjeGnLQk1PHzYWr/O0ugv7MZfLRnJwvvWWaIJ/ff8bq7qB85SP3pp3BXNP
         YNar/pOv+2d0Xi9BFYU7HNjFImOWrzVFEIoRJ044Dq/rY7Zm+owRSHe/rcFcKPChjH2t
         E/4uZmf7vTzsxDoyFh7yDOXG2AsMO9PW/CicvTz28zMraRKNZcEJLevJjNCN6teaa4iA
         GpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xqy0iH8ZPmPaaheZw7wHrktKJsAwLVkMrIJokUvF7Lc=;
        b=lX0BQM9s6gHKOXqYLcViqLDY+F91t6pINgZH9DC/vbMiC+MgM9yAFCqDwdgPWvWMBb
         xM186ocwKv40DiKmeOh45BRroiACosEoJYb/dy/CeF8AgQ8fKHp+zPvLUL4sYbq5hXDO
         +y/IMCIhM6QAZr+SHKrMcWKJFwP9HFruGcJtXqVLCfkgkRtOBbMzS7UadClc4NycjupT
         WjNWu2Pnonm62ngDPBj10Hcdf2UhywAkq+V3JDLQn8letlP9ZVNxaRwQWv4l3/rRBS6S
         0Q6O+z8RyrK8BSRBwcgv/7yb2YzFFgp+4YFbeibBAkWuOdbygI/XDWygPumrhuoPjHO+
         RuJQ==
X-Gm-Message-State: APjAAAXlCzbhp0F8Qz11vdopZ0+GZdbxWMRl71pKw+VYEllsi8Jfkz30
        uwu9L0nPDHyv92zJRKiKXzbRwNVsjB89Kw==
X-Google-Smtp-Source: APXvYqxSLBHISegILJkc8qxTv7nGleJ6OqM2zlqoQRbULHQQdi00QCJcnO15vnC0O54O40AMdJ4nv8ynTdsOmA==
X-Received: by 2002:a63:de4a:: with SMTP id y10mr116479827pgi.367.1578390152959;
 Tue, 07 Jan 2020 01:42:32 -0800 (PST)
Date:   Tue,  7 Jan 2020 01:42:24 -0800
In-Reply-To: <20200107094225.21243-1-edumazet@google.com>
Message-Id: <20200107094225.21243-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200107094225.21243-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 1/2] vlan: fix memory leak in vlan_dev_set_egress_priority
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are few cases where the ndo_uninit() handler might be not
called if an error happens while device is initialized.

Since vlan_newlink() calls vlan_changelink() before
trying to register the netdevice, we need to make sure
vlan_dev_uninit() has been called at least once,
or we might leak allocated memory.

BUG: memory leak
unreferenced object 0xffff888122a206c0 (size 32):
  comm "syz-executor511", pid 7124, jiffies 4294950399 (age 32.240s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 61 73 00 00 00 00 00 00 00 00  ......as........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000000eb3bb85>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<000000000eb3bb85>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<000000000eb3bb85>] slab_alloc mm/slab.c:3320 [inline]
    [<000000000eb3bb85>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
    [<000000007b99f620>] kmalloc include/linux/slab.h:556 [inline]
    [<000000007b99f620>] vlan_dev_set_egress_priority+0xcc/0x150 net/8021q/vlan_dev.c:194
    [<000000007b0cb745>] vlan_changelink+0xd6/0x140 net/8021q/vlan_netlink.c:126
    [<0000000065aba83a>] vlan_newlink+0x135/0x200 net/8021q/vlan_netlink.c:181
    [<00000000fb5dd7a2>] __rtnl_newlink+0x89a/0xb80 net/core/rtnetlink.c:3305
    [<00000000ae4273a1>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3363
    [<00000000decab39f>] rtnetlink_rcv_msg+0x178/0x4b0 net/core/rtnetlink.c:5424
    [<00000000accba4ee>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000319fe20f>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d51938dc>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d51938dc>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<00000000e539ac79>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<000000006250c27e>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<000000006250c27e>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000e2a156d1>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<000000008c87466e>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<00000000110e3054>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<00000000d71077c8>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<00000000d71077c8>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<00000000d71077c8>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

Fixe: 07b5b17e157b ("[VLAN]: Use rtnl_link API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/8021q/vlan.h         | 1 +
 net/8021q/vlan_dev.c     | 3 ++-
 net/8021q/vlan_netlink.c | 9 +++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index c46daf09a5011fe317d0a950ec2ea6735619a148..bb7ec1a3915ddbda397e920d9d281eddbd62527f 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -126,6 +126,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 void vlan_setup(struct net_device *dev);
 int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack);
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head);
+void vlan_dev_uninit(struct net_device *dev);
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5bff5cc6f97562a9887195ced5c572c1951915e..2a78da4072de9824ef1074b7596697366b68c21c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -586,7 +586,8 @@ static int vlan_dev_init(struct net_device *dev)
 	return 0;
 }
 
-static void vlan_dev_uninit(struct net_device *dev)
+/* Note: this function might be called multiple times for the same device. */
+void vlan_dev_uninit(struct net_device *dev)
 {
 	struct vlan_priority_tci_mapping *pm;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index c482a6fe939398a82a6d112aa5f306e0765ab387..b2a4b8b5a0cdffd41e785948f4d092dedd07a5b0 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -179,10 +179,11 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 		return -EINVAL;
 
 	err = vlan_changelink(dev, tb, data, extack);
-	if (err < 0)
-		return err;
-
-	return register_vlan_dev(dev, extack);
+	if (!err)
+		err = register_vlan_dev(dev, extack);
+	if (err)
+		vlan_dev_uninit(dev);
+	return err;
 }
 
 static inline size_t vlan_qos_map_size(unsigned int n)
-- 
2.24.1.735.g03f4e72817-goog

