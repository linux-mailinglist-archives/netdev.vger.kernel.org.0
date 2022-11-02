Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B656166F3
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiKBQDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiKBQCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375842CC80
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a14so25229542wru.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHfiIHkF1damC/ETrZiD0CXy4Le3EZcrtffVIGJrFfI=;
        b=iyYBzkcwVNnoG8w+PYW4gaIuQ8sJhZcleFcc4fA0sgABwQsG4ckDGDlUkw7Uy3Eh3G
         mlMy+CPL4nGNgjrVHWuDfFzOKUq2Xv9+pE0ZsEmwLIS/H0ifG4VfcwH/1VGUxhiPkq10
         4/pxj6DSjq/I5YvChU5HnGF5aLxz6qWqMq5Uj6VzdXOsCMQHqXe7p3Nw0OQERQthWGUp
         8IMOeVk8kyg7AOP6EmE3i1IP5DSsRSU9LasL4lrfsk2KLU5hLETinIhNtDcVwJ5xdNdF
         1+tpJ2OL3f5rJAvi6r9Q5naqq1e834DWSPWbbgNCzcMFviKhiCxLjdqvvcDBWq+t+Lyg
         WGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHfiIHkF1damC/ETrZiD0CXy4Le3EZcrtffVIGJrFfI=;
        b=c9nIA81UHGaxnxKjs4s3gT2W5fhbg07PLlLTzYFVqLQjnnTxTcJF68oulhkgex8Oyh
         rGgI9PKF5OJf9z5pfWjjjuDu3BJtKpaD+0fa7g3t1qng2gtoCVXc/L1/thT/6TV2P/3g
         /dn6u6qku2T8FyMxbSd8KEgFs/6qILs+4hIBSy/kzwQ0A5eIkRFtTRiwa0AK+UPKkpKf
         bsMeXdGUhbWCRkqQJJdt08s/bwlmcxKPSmqEyEKp+8Eeg68/08c/dU4b7D1Ry1ncnTrh
         WgVI5X6pWBDZ6m+YqWXUnA6QBzVYrbJcEUQsfL2LNZTrFQZEN580V/U43O5l62ISg7W/
         +TUQ==
X-Gm-Message-State: ACrzQf1faqJDK8JlETZgFtHdU2BdPTw8SRkwdmEOcnkpA7xQbXecL3zm
        PdwARSeUUNceAKKIJhE+MqHVUj/lVUmwBulLN4s=
X-Google-Smtp-Source: AMsMyM7DG7A0PcNW5Hj5q5cHUNe9eFgwE1zuI8kncbtogqQQQoYX042Lcy7MOx371ePVZINTbT9JzQ==
X-Received: by 2002:adf:e283:0:b0:236:b557:39e6 with SMTP id v3-20020adfe283000000b00236b55739e6mr14501756wri.642.1667404953519;
        Wed, 02 Nov 2022 09:02:33 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h3-20020adffa83000000b0022ae401e9e0sm13140144wrr.78.2022.11.02.09.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 13/13] net: expose devlink port over rtnetlink
Date:   Wed,  2 Nov 2022 17:02:11 +0100
Message-Id: <20221102160211.662752-14-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Expose devlink port handle related to netdev over rtnetlink. Introduce a
new nested IFLA attribute to carry the info. Call into devlink code to
fill-up the nest with existing devlink attributes that are used over
devlink netlink.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v3->v4:
- removed unnecessary symbol exports
---
 include/net/devlink.h        | 14 +++++++++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/devlink.c           | 18 +++++++++++++++++
 net/core/rtnetlink.c         | 39 ++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7befad57afd4..fa6e936af1a5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1873,6 +1873,9 @@ int devlink_compat_phys_port_name_get(struct net_device *dev,
 int devlink_compat_switch_id_get(struct net_device *dev,
 				 struct netdev_phys_item_id *ppid);
 
+int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port);
+size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port);
+
 #else
 
 static inline struct devlink *devlink_try_get(struct devlink *devlink)
@@ -1909,6 +1912,17 @@ devlink_compat_switch_id_get(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
+{
+	return 0;
+}
+
+static inline size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _NET_DEVLINK_H_ */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5e7a1041df3a..9af9da1db4e8 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -372,6 +372,8 @@ enum {
 	IFLA_TSO_MAX_SEGS,
 	IFLA_ALLMULTI,		/* Allmulti count: > 0 means acts ALLMULTI */
 
+	IFLA_DEVLINK_PORT,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3a454d0045e5..2dcf2bcc3527 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -880,6 +880,24 @@ static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *dev
 	return -EMSGSIZE;
 }
 
+int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
+{
+	if (devlink_nl_put_handle(msg, devlink_port->devlink))
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
+		return -EMSGSIZE;
+	return 0;
+}
+
+size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
+{
+	struct devlink *devlink = devlink_port->devlink;
+
+	return nla_total_size(strlen(devlink->dev->bus->name) + 1) /* DEVLINK_ATTR_BUS_NAME */
+	     + nla_total_size(strlen(dev_name(devlink->dev)) + 1) /* DEVLINK_ATTR_DEV_NAME */
+	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
+}
+
 struct devlink_reload_combination {
 	enum devlink_reload_action action;
 	enum devlink_reload_limit limit;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d2f27548fc0b..ac8730078d48 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -53,6 +53,7 @@
 #include <net/fib_rules.h>
 #include <net/rtnetlink.h>
 #include <net/net_namespace.h>
+#include <net/devlink.h>
 
 #include "dev.h"
 
@@ -1038,6 +1039,16 @@ static size_t rtnl_proto_down_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_devlink_port_size(const struct net_device *dev)
+{
+	size_t size = nla_total_size(0); /* nest IFLA_DEVLINK_PORT */
+
+	if (dev->devlink_port)
+		size += devlink_nl_port_handle_size(dev->devlink_port);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1091,6 +1102,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
+	       + rtnl_devlink_port_size(dev)
 	       + 0;
 }
 
@@ -1728,6 +1740,30 @@ static int rtnl_fill_proto_down(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int rtnl_fill_devlink_port(struct sk_buff *skb,
+				  const struct net_device *dev)
+{
+	struct nlattr *devlink_port_nest;
+	int ret;
+
+	devlink_port_nest = nla_nest_start(skb, IFLA_DEVLINK_PORT);
+	if (!devlink_port_nest)
+		return -EMSGSIZE;
+
+	if (dev->devlink_port) {
+		ret = devlink_nl_port_handle_fill(skb, dev->devlink_port);
+		if (ret < 0)
+			goto nest_cancel;
+	}
+
+	nla_nest_end(skb, devlink_port_nest);
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(skb, devlink_port_nest);
+	return ret;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1865,6 +1901,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			   dev->dev.parent->bus->name))
 		goto nla_put_failure;
 
+	if (rtnl_fill_devlink_port(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.37.3

