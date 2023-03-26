Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3F6C9713
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjCZRBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjCZRBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:01:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B586A53
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id er18so15368924edb.9
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679850063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVw8mNIYgBevA5WAbZRzEVceVuQ8FZJe/xIyNmE1HIg=;
        b=dtMeZISBFJD4Y1iX25nk1jG3zfNA4pZZRckmOUNi23elyCG5DI+bQgTtsvKVznEEt8
         2YFMS1wYiK0bU9qQSUxvKODsdkfNjKXS12+MK9y+boBWd7iqfUvzApiPSYzcTxxgBkop
         TijJzXRK7I4WsE0YZwUTnpOdFkXv/Mx4Dtrs6Faj2s7igQ3O1WhzwKLE2Bu33WIo5SqW
         7sy4xS2Gdb94ns/y9Mnt2ApBtzDR9qOutkzcJ6m1h4R6PZ35zOOlXA0aDnXGsKb+5DYD
         hpweIiHvFaIrs43D+y6A3cH4/AY62XkpX/oROBJmdtrbnVlbc0N4R0QNpBozsG0i59b+
         Dq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVw8mNIYgBevA5WAbZRzEVceVuQ8FZJe/xIyNmE1HIg=;
        b=qtBryKx97I8Y1FH8jsJUNtwGgXZVqS0VMdfzgdVCkgSIvxfqnaDClZMf4pi9vYqdHv
         E0JvAXxpaFu+BeV7BoXV3hJg4UGUXs6U6v7AFLXyzvSHMF3U/xunzFmMPZJ5OOKuYaEE
         dfgY+gXGklJLbUHbFu73jb5tQEBdGMwouUL+r4aXEhI1lIiPhISqH28LEbD9/JeUIwqE
         KW1DBmyTXthXH0ypK0hiLID++mWuWibhG4P8O7RfYkfGhpyyNUTbQJUhQQYYiY+PjVEB
         YzBsc/A4DyJZDfniIy/zwWJX4gYxb/cES+793qmdjnHzNfi92Yln2MsbevmO6Sr5QLmF
         7N4w==
X-Gm-Message-State: AAQBX9dowAxMHn+E1Vu+z9cJq3Ufkgqw/lHcrDA8RWrvhsbHp5Bby0At
        ZkIbiLGNKQ7O74ZsbGWHBg7MsrknqwcTIxDq9CI=
X-Google-Smtp-Source: AKy350bjFaVpgOcNLLdrsugeYmhEfzcs6Xab2vP4Fh1lmBuaxXVpDg02V36R1QWwVKeawousjXcGJQ==
X-Received: by 2002:a17:907:d22:b0:932:5b67:6dee with SMTP id gn34-20020a1709070d2200b009325b676deemr10652498ejc.27.1679850062898;
        Sun, 26 Mar 2023 10:01:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c16-20020a170906925000b009327f9a397csm12566473ejx.145.2023.03.26.10.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:01:02 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadim.fedorenko@linux.dev, vadfed@meta.com
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, pabeni@redhat.com,
        poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [patch dpll-rfc 6/7] netdev: expose DPLL pin handle for netdevice
Date:   Sun, 26 Mar 2023 19:00:51 +0200
Message-Id: <20230326170052.2065791-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230326170052.2065791-1-jiri@resnulli.us>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case netdevice represents a SyncE port, the user needs to understand
the connection between netdevice and associated DPLL pin. There might me
multiple netdevices pointing to the same pin, in case of VF/SF
implementation.

Add a IFLA Netlink attribute to nest the DPLL pin handle, similar to
how is is implemented for devlink port. Add a struct dpll_pin pointer
to netdev and protect access to it by RTNL. Expose netdev_dpll_pin_set()
and netdev_dpll_pin_clear() helpers to the drivers so they can set/clear
the DPLL pin relationship to netdev.

Note that during the lifetime of struct dpll_pin the handle fields do not
change. Therefore it is save to access them lockless. It is drivers
responsibility to call netdev_dpll_pin_clear() before dpll_pin_put().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_netlink.c  | 28 ++++++++++++++++++++++----
 include/linux/dpll.h         | 20 +++++++++++++++++++
 include/linux/netdevice.h    |  7 +++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/dev.c               | 20 +++++++++++++++++++
 net/core/rtnetlink.c         | 38 ++++++++++++++++++++++++++++++++++++
 6 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index cd77881ee1ec..ac5cbf5a2e19 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -302,6 +302,24 @@ dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
 	return ret;
 }
 
+size_t dpll_msg_pin_handle_size(struct dpll_pin *pin)
+{
+	// TMP- THE HANDLE IS GOING TO CHANGE TO DRIVERNAME/CLOCKID/PIN_INDEX
+	// LEAVING ORIG HANDLE NOW AS PUT IN THE LAST RFC VERSION
+	return nla_total_size(4); /* DPLL_A_PIN_IDX */
+}
+EXPORT_SYMBOL_GPL(dpll_msg_pin_handle_size);
+
+int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin)
+{
+	// TMP- THE HANDLE IS GOING TO CHANGE TO DRIVERNAME/CLOCKID/PIN_INDEX
+	// LEAVING ORIG HANDLE NOW AS PUT IN THE LAST RFC VERSION
+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
+		return -EMSGSIZE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_msg_add_pin_handle);
+
 static int
 dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
 			 struct dpll_device *dpll,
@@ -310,8 +328,9 @@ dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
 	struct dpll_pin_ref *ref;
 	int ret;
 
-	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
-		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_handle(msg, pin);
+	if (ret)
+		return ret;
 	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
 		return -EMSGSIZE;
 	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
@@ -352,8 +371,9 @@ __dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
 	struct dpll_pin_ref *ref;
 	int ret;
 
-	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
-		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_handle(msg, pin);
+	if (ret)
+		return ret;
 	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
 		return -EMSGSIZE;
 	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 562b9b7bd001..f9081e5fc522 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -92,6 +92,26 @@ enum dpll_pin_freq_supp {
 	DPLL_PIN_FREQ_SUPP_MAX = (__DPLL_PIN_FREQ_SUPP_MAX - 1)
 };
 
+#if IS_ENABLED(CONFIG_DPLL)
+
+size_t dpll_msg_pin_handle_size(struct dpll_pin *pin);
+
+int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin);
+
+#else
+
+static inline size_t dpll_msg_pin_handle_size(struct dpll_pin *pin)
+{
+	return 0;
+}
+
+static inline int dpll_msg_add_pin_handle(struct sk_buff *msg, struct dpll_pin *pin)
+{
+	return 0;
+}
+
+#endif
+
 /**
  * dpll_device_get - find or create dpll_device object
  * @clock_id: a system unique number for a device
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7621c512765f..79a90b52ee77 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -34,6 +34,7 @@
 #include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/dpll.h>
 
 #include <net/net_namespace.h>
 #ifdef CONFIG_DCB
@@ -2403,6 +2404,10 @@ struct net_device {
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 
 	struct devlink_port	*devlink_port;
+
+#if IS_ENABLED(CONFIG_DPLL)
+	struct dpll_pin		*dpll_pin;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -3939,6 +3944,8 @@ int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
+void netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin);
+void netdev_dpll_pin_clear(struct net_device *dev);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 57ceb788250f..280573f723da 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -377,6 +377,8 @@ enum {
 	IFLA_GSO_IPV4_MAX_SIZE,
 	IFLA_GRO_IPV4_MAX_SIZE,
 
+	IFLA_DPLL_PIN,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index c7853192563d..cf9f61cf33e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8949,6 +8949,26 @@ bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
 }
 EXPORT_SYMBOL(netdev_port_same_parent_id);
 
+static void netdev_dpll_pin_assign(struct net_device *dev, struct dpll_pin *dpll_pin)
+{
+	rtnl_lock();
+	dev->dpll_pin = dpll_pin;
+	rtnl_unlock();
+}
+
+void netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin)
+{
+	WARN_ON(!dpll_pin);
+	netdev_dpll_pin_assign(dev, dpll_pin);
+}
+EXPORT_SYMBOL(netdev_dpll_pin_set);
+
+void netdev_dpll_pin_clear(struct net_device *dev)
+{
+	netdev_dpll_pin_assign(dev, NULL);
+}
+EXPORT_SYMBOL(netdev_dpll_pin_clear);
+
 /**
  *	dev_change_proto_down - set carrier according to proto_down.
  *
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index b7b1661d0d56..e29aed39625d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1052,6 +1052,16 @@ static size_t rtnl_devlink_port_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_dpll_pin_size(const struct net_device *dev)
+{
+	size_t size = nla_total_size(0); /* nest IFLA_DPLL_PIN */
+
+	if (dev->dpll_pin)
+		size += dpll_msg_pin_handle_size(dev->dpll_pin);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1108,6 +1118,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
 	       + rtnl_devlink_port_size(dev)
+	       + rtnl_dpll_pin_size(dev)
 	       + 0;
 }
 
@@ -1769,6 +1780,30 @@ static int rtnl_fill_devlink_port(struct sk_buff *skb,
 	return ret;
 }
 
+static int rtnl_fill_dpll_pin(struct sk_buff *skb,
+			      const struct net_device *dev)
+{
+	struct nlattr *dpll_pin_nest;
+	int ret;
+
+	dpll_pin_nest = nla_nest_start(skb, IFLA_DPLL_PIN);
+	if (!dpll_pin_nest)
+		return -EMSGSIZE;
+
+	if (dev->dpll_pin) {
+		ret = dpll_msg_add_pin_handle(skb, dev->dpll_pin);
+		if (ret < 0)
+			goto nest_cancel;
+	}
+
+	nla_nest_end(skb, dpll_pin_nest);
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(skb, dpll_pin_nest);
+	return ret;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1911,6 +1946,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_devlink_port(skb, dev))
 		goto nla_put_failure;
 
+	if (rtnl_fill_dpll_pin(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.39.0

