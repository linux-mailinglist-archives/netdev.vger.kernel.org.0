Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16476F0F83
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 02:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbjD1AVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 20:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344468AbjD1AVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 20:21:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF074213;
        Thu, 27 Apr 2023 17:20:55 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 33RIPnkG007961;
        Thu, 27 Apr 2023 17:20:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=unCD3Aymvo17/Xi/Iyan24IV8URDNQJI1oP/HJ/5XEg=;
 b=RDxTbRYQ35Sy5b878d3gdIYK+k205uZU9+2MemW74L96VOIooalObC4m3Xv4kcY8SECF
 4xmZW/VQeXvsB3KdTf4EA0VlbL+1ShU32fyxtpplJ4PrGi3SQAhJooNtZF7xayI0lH6L
 ngc0j1pxA0YS85kVDewG+YgxGNongahoa5QqQAFze/jClL2N6LUBzLmr5Y0mg4uAMLVU
 5+lJk2lk+xdcKKjhwOgoJw55iNEgOi2JhjHkTofN/z8/ocGgRdtR54O/NvyR9+5CAqsT
 OeosF+5yaL/jWiZEWDeMR5/E6bFFO42NUlkOyE1f8yE45Og2l3mBfV2whCs++uPxe1zf qw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3q7utb3r2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Apr 2023 17:20:44 -0700
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server id
 15.1.2507.23; Thu, 27 Apr 2023 17:20:40 -0700
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Jiri Pirko <jiri@nvidia.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-clk@vger.kernel.org>
Subject: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Date:   Thu, 27 Apr 2023 17:20:08 -0700
Message-ID: <20230428002009.2948020-8-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: VDJJDd5ZO2sXFjByxWPI-dz_PUjYA3YG
X-Proofpoint-ORIG-GUID: VDJJDd5ZO2sXFjByxWPI-dz_PUjYA3YG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_09,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
how it is implemented for devlink port. Add a struct dpll_pin pointer
to netdev and protect access to it by RTNL. Expose netdev_dpll_pin_set()
and netdev_dpll_pin_clear() helpers to the drivers so they can set/clear
the DPLL pin relationship to netdev.

Note that during the lifetime of struct dpll_pin the handle fields do not
change. Therefore it is save to access them lockless. It is drivers
responsibility to call netdev_dpll_pin_clear() before dpll_pin_put().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/dpll/dpll_netlink.c  | 23 ++++++++++++++++++++--
 include/linux/dpll.h         | 20 +++++++++++++++++++
 include/linux/netdevice.h    |  7 +++++++
 include/uapi/linux/if_link.h |  2 ++
 net/core/dev.c               | 20 +++++++++++++++++++
 net/core/rtnetlink.c         | 38 ++++++++++++++++++++++++++++++++++++
 6 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 1eb0b4a2fce4..734b6776b07c 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -269,8 +269,9 @@ dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
 {
 	int ret;
 
-	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
-		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_handle(msg, pin);
+	if (ret)
+		return ret;
 	if (nla_put_string(msg, DPLL_A_PIN_LABEL, pin->prop.label))
 		return -EMSGSIZE;
 	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
@@ -290,6 +291,24 @@ dpll_cmd_pin_fill_details(struct sk_buff *msg, struct dpll_pin *pin,
 	return 0;
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
+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->pin_idx))
+		return -EMSGSIZE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_msg_add_pin_handle);
+
 static int
 __dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
 			struct netlink_ext_ack *extack)
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 5194efaf55a8..5945bb456794 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -104,6 +104,26 @@ struct dpll_pin_properties {
 	struct dpll_pin_frequency *freq_supported;
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
index 08fbd4622ccf..be162d8db611 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -34,6 +34,7 @@
 #include <linux/rculist.h>
 #include <linux/workqueue.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/dpll.h>
 
 #include <net/net_namespace.h>
 #ifdef CONFIG_DCB
@@ -2411,6 +2412,10 @@ struct net_device {
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 
 	struct devlink_port	*devlink_port;
+
+#if IS_ENABLED(CONFIG_DPLL)
+	struct dpll_pin		*dpll_pin;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -3954,6 +3959,8 @@ int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name);
 int dev_get_port_parent_id(struct net_device *dev,
 			   struct netdev_phys_item_id *ppid, bool recurse);
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
+void netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin);
+void netdev_dpll_pin_clear(struct net_device *dev);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac1000b0ef2..9244d6ff23fc 100644
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
index 735096d42c1d..fe594e23c1cb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8990,6 +8990,26 @@ bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
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
index 653901a1bf75..2d1f5d2024ac 100644
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
2.34.1

