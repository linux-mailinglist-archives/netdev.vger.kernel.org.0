Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7F5F2F1E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJCKww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJCKwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAE35467D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:24 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z23so4510565ejw.12
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=WiDCHbS5LVTCBohPAoCScsHZ7FLNei9IQYIOcoDdszU=;
        b=MhPQNkRj4ZYnBk9sI0cZfkc8C4qcA6jKkcC+7wRuW8p86c4l7LEjR7cwDHsZacXqOi
         voC7jpHyDX3gQ7MJ3rFT+vLEw+Ej83DqocWN38/sHzJOoEXNr6JNztmKxAb7DCOS8hYi
         0/lP6TqGgzba1wG7jkbNxwr8jH868oEc2KhvUbDbasuzh6+EjJoiiWePN+Pyl+TPMtIh
         /oKXB8WxHL73awTH6AhlYzoNLJsZah3rkdHYq7Vli5x/hzTKDPizhUEeh60FmVhqWUc+
         MuUT4tnlE6CexK1ULpFGXokteiGfjS74FtQ2GedYcfLaIH9wq7h429j38GzM24clTLUb
         DLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WiDCHbS5LVTCBohPAoCScsHZ7FLNei9IQYIOcoDdszU=;
        b=f5BXyEhus252GYHYGrgBNdKxN0WBi3uBt4JZ9xXhsMqB7J2xJx/AEcoYjv37YE//kC
         /MS+XNGy5s/b6htmnLrLlh0hxM5w+neSde9MfLU9UHcMjZ4y+gymnrYF0aUa7R91ZmlB
         9+D+dgSrGWpTG7TtPHrdJps/8r83q3SVQ5alniTDZL0Ytox8Xtim4iJ9wh5v9b2JGpsT
         kQyq/cYw0/d0sjGMW2IdfUltsoBVPk1LFDHjZWvoWr3SBWtvkkBioqxMpJbjJWl66UHV
         hCZ0RVyVOdn+SrYT/Z9xsJ61QqmzjKU8tA5hoGAdT84SO0MB7CSLfoFXhZYDyZzLYL6v
         PCVw==
X-Gm-Message-State: ACrzQf0p8ZJEfI1Z4rZEEioNQA5LPdv/sn0vbz90GtCVJQXbLfnTjmjJ
        YdydV7tJNMKFMW4Qf5vsk1Y2yr57JTHU/6b5PxQ=
X-Google-Smtp-Source: AMsMyM6LCRRc48DiWfo8PoiHrraSPk4aY3s8/wrayUQ4WrK2hYnQd6WIcp2y7yw7I/6DPj7K93wTRQ==
X-Received: by 2002:a17:907:a410:b0:782:d172:d540 with SMTP id sg16-20020a170907a41000b00782d172d540mr14276831ejc.563.1664794343484;
        Mon, 03 Oct 2022 03:52:23 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g24-20020a056402321800b00458478a4295sm7254679eda.9.2022.10.03.03.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 13/13] net: expose devlink port over rtnetlink
Date:   Mon,  3 Oct 2022 12:52:04 +0200
Message-Id: <20221003105204.3315337-14-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 include/net/devlink.h        | 14 +++++++++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/devlink.c           | 20 ++++++++++++++++++
 net/core/rtnetlink.c         | 39 ++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

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
index 2a42e49f6a4e..d2ee33044b2e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -880,6 +880,26 @@ static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *dev
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
+EXPORT_SYMBOL_GPL(devlink_nl_port_handle_fill);
+
+size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
+{
+	struct devlink *devlink = devlink_port->devlink;
+
+	return nla_total_size(strlen(devlink->dev->bus->name) + 1) /* DEVLINK_ATTR_BUS_NAME */
+	     + nla_total_size(strlen(dev_name(devlink->dev)) + 1) /* DEVLINK_ATTR_DEV_NAME */
+	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
+}
+EXPORT_SYMBOL_GPL(devlink_nl_port_handle_size);
+
 struct devlink_reload_combination {
 	enum devlink_reload_action action;
 	enum devlink_reload_limit limit;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..e034c0c8e6cc 100644
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
2.37.1

