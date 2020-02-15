Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CEB15FE0B
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 11:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgBOKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 05:50:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35581 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgBOKu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 05:50:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id v23so3087544pgk.2
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 02:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pY8BElEOzjb0V7JJDjJ6DSf8e2hwCLTPfSW1g7RDdvI=;
        b=csRK1QQrivtwAn+XbmIEq0e/FZ+65dI0F+5c9Mx3uNaNGTkGXaI7jhm+SQubt1WTRn
         HECG6mrbqwmFoRWjaIFQa4gWXA8GgGVuwKUrhwfeedR3XzIkOPZBqHW9nTbk9v0uGVKY
         1SPnU+Pr0cyu0qvcfsedAXA2fLI2XSrbrn3+W9/md34llmQYa1Vui89caKIkiFO6IP19
         nNhSzSLEZyD/2MEd1VY6BDEpOBit58GBU48nw7C2wdbq7ed+F5KDJeiDXWjs50TJb+cu
         bOShfnuzAfmlaFOaavB35+3ki+YWK+7MxhHkLZNRxdE9NeQJ23pjxJTRNAf0hDCfZd5B
         tRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pY8BElEOzjb0V7JJDjJ6DSf8e2hwCLTPfSW1g7RDdvI=;
        b=Udhh/pWwu97P2GYS1N5lfulrrLhk0AWfKd9rHuoS3Dj3pgBQ1cNJrTOHG1wGfdoQwW
         PZPcrnJbLi9buxna/i9DtLVQjH11SLmwE7IpmmMQe233mtySHiAnDjIK0w7+T75VzO8E
         vnB92KJQsj+cDk/8RVsSpy/1iYkhMLM9TL1Bz1DZ8GwWknQZW4KlIaO7rNN/ASJMhxIY
         F8FXzBQDW+MBAcKv8eiYVDwhycuD6mJIKtEukt3M4p8Dgy8J8Z7XGXxuC6JfVvYuZ+Bx
         cqsuGlJ9JqY79MojMQ7hjgaxQyMTM2e0Otpmy495xszwJ7deqxPc5+QYSiJ8hD6NbKpM
         uSqg==
X-Gm-Message-State: APjAAAWXq6ILuGT4ElizChOBCvkXFLCTA7IDmdt/YDlI7siNgqCHEAQE
        UUm+hVmtB/zO+gZOQIEtRl/uX2+GZ0o=
X-Google-Smtp-Source: APXvYqzAGydfhp41XujQ7FUO9PuvU77aU180s6Zn20cUEFiBenqqxzMeo6Mhz78AeiOZu39/DxwsjQ==
X-Received: by 2002:a63:9856:: with SMTP id l22mr5351875pgo.344.1581763828132;
        Sat, 15 Feb 2020 02:50:28 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id w25sm10161667pfi.106.2020.02.15.02.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 02:50:27 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 2/3] net: export netdev_next_lower_dev_rcu()
Date:   Sat, 15 Feb 2020 10:50:21 +0000
Message-Id: <20200215105021.21513-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_next_lower_dev_rcu() will be used to implement a function,
which is to walk all lower interfaces.
There are already functions that they walk their lower interface.
(netdev_walk_all_lower_dev_rcu, netdev_walk_all_lower_dev()).
But, there would be cases that couldn't be covered by given
netdev_walk_all_lower_dev_{rcu}() function.
So, some modules would want to implement own function,
which is to walk all lower interfaces.

In the next patch, netdev_next_lower_dev_rcu() will be used.
In addition, this patch removes two unused prototypes in netdevice.h.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 :
 - Initial patch

 include/linux/netdevice.h | 7 +++----
 net/core/dev.c            | 6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f1f633235f6..6c3f7032e8d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -72,6 +72,8 @@ void netdev_set_default_ethtool_ops(struct net_device *dev,
 #define NET_RX_SUCCESS		0	/* keep 'em coming, baby */
 #define NET_RX_DROP		1	/* packet dropped */
 
+#define MAX_NEST_DEV 8
+
 /*
  * Transmit return codes: transmit return codes originate from three different
  * namespaces:
@@ -4389,11 +4391,8 @@ void *netdev_lower_get_next(struct net_device *dev,
 	     ldev; \
 	     ldev = netdev_lower_get_next(dev, &(iter)))
 
-struct net_device *netdev_all_lower_get_next(struct net_device *dev,
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 					     struct list_head **iter);
-struct net_device *netdev_all_lower_get_next_rcu(struct net_device *dev,
-						 struct list_head **iter);
-
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
 					void *data),
diff --git a/net/core/dev.c b/net/core/dev.c
index a6316b336128..8965ef053409 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,7 +146,6 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
-#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -7201,8 +7200,8 @@ static int __netdev_walk_all_lower_dev(struct net_device *dev,
 	return 0;
 }
 
-static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
-						    struct list_head **iter)
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
+					     struct list_head **iter)
 {
 	struct netdev_adjacent *lower;
 
@@ -7214,6 +7213,7 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 
 	return lower->dev;
 }
+EXPORT_SYMBOL(netdev_next_lower_dev_rcu);
 
 static u8 __netdev_upper_depth(struct net_device *dev)
 {
-- 
2.17.1

