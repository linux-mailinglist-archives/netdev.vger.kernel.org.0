Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB92A91E6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbfIDSjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 14:39:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44189 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732177AbfIDSjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:39:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so11686414pgl.11
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W9x6KjNDgBE0suYD/7dK4xL35oQSe9zrDp6sZJ8t8Vs=;
        b=RPQDVK3rUiNuV+TZigl2bBgvjisUxFj+Ro0Edc99JTanbrbr8/8Ul1INr89oEJUD4r
         XMmh7FVOsk2pnf8R0+EsHPFvzePyypVPZf+UveL1EN/4PMu4yw/mOWMR+1lMidGqyzCV
         Z0g6ratKtfuvVUqjNeKmMvJW6W0ipxjS6YbN71QpuJCHUfTTKuEGiB3kECBsEEHjLC+q
         QHNEWKGx3MEygNj3iZMokfjh33k9ZyJxFN39KTAROWXBXUBPtT5OC9WIBxc94BeSJSJQ
         SL5f2h/LGqpNpFCxuXVmzZid9VPGIWg2xJSUaKJ8BX8DdGLKtw56gRvaNKgHEn88oT0F
         JDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W9x6KjNDgBE0suYD/7dK4xL35oQSe9zrDp6sZJ8t8Vs=;
        b=LxnHUreHWbn8iY3vfU/jaELX8i59Up+GOpNNhWXajJ8406W2xxK7g7kAPV+dyTkJYX
         CFdB+sgQjJO8oETq765iSq+wL/xjoLDFKDuTmJhOYKnX0MctdSdS3UCpaNIjIBCp+pMS
         XOjnpar+ojlpIvxRkwNneSvBqu9USPbI/AgUXhuOiJAZOJcgRsOlw8LS4zbktCixRwjp
         aZB9ShE3EeXy/HH/AXJJeCmFyyNI0D/EnK7AehmSMjwjYxvRFmx5/36abJGzeKWwO8NJ
         miCXig1hX1PPaat+glQI/2K8sIcGwXmGtbcfUM9y354ZQEplg4Z7gZ2AtYYF/01zH1Wq
         6KEw==
X-Gm-Message-State: APjAAAVXp90vKeA5D5JAq6rNegIPZ1BplRt7eDeDWe+7qZPzLqpxGKrn
        eTCzdYkoHVjfrQnaV1h1GWc=
X-Google-Smtp-Source: APXvYqymiGxD9VnVLiaI7sD0Hl6CAkUoICxrRcy79jn2vCobXyWIcOg+RfSDemxd6LdAYAkafLqBmw==
X-Received: by 2002:a63:9318:: with SMTP id b24mr35990456pge.31.1567622346044;
        Wed, 04 Sep 2019 11:39:06 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id c11sm25392471pfj.114.2019.09.04.11.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 11:39:04 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     ap420073@gmail.com
Subject: [PATCH net 01/11] net: core: limit nested device depth
Date:   Thu,  5 Sep 2019 03:38:56 +0900
Message-Id: <20190904183856.14465-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code doesn't limit the number of nested devices.
Nested devices would be handled recursively and this needs huge stack
memory. So, unlimited nested devices could make stack overflow.

This patch adds upper_level and lower_leve, they are common variables
and represent maximum lower/upper depth.
When upper/lower device is attached or dettached,
{lower/upper}_level are updated. and if maximum depth is bigger than 8,
attach routine fails and returns -EMLINK.

Test commands:
    ip link add dummy0 type dummy
    ip link add link dummy0 name vlan1 type vlan id 1
    ip link set vlan1 up

    for i in {2..100}
    do
	    let A=$i-1

	    ip link add name vlan$i link vlan$A type vlan id $i
    done

Splat looks like:
[  140.483124] BUG: looking up invalid subclass: 8
[  140.483505] turning off the locking correctness validator.
[  140.483505] CPU: 0 PID: 1324 Comm: ip Not tainted 5.3.0-rc7+ #322
[  140.483505] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 07/08/2015
[  140.483505] Call Trace:
[  140.483505]  dump_stack+0x7c/0xbb
[  140.483505]  register_lock_class+0x64d/0x14d0
[  140.483505]  ? is_dynamic_key+0x230/0x230
[  140.483505]  ? module_assert_mutex_or_preempt+0x41/0x70
[  140.483505]  ? __module_address+0x3f/0x3c0
[  140.483505]  lockdep_init_map+0x24e/0x630
[  140.483505]  vlan_dev_init+0x828/0xce0 [8021q]
[  140.483505]  register_netdevice+0x24f/0xd70
[  140.483505]  ? netdev_change_features+0xa0/0xa0
[  140.483505]  ? dev_get_nest_level+0xe1/0x170
[  140.483505]  register_vlan_dev+0x29b/0x710 [8021q]
[  140.483505]  __rtnl_newlink+0xb75/0x1180
[  ... ]

[  168.446539] WARNING: can't dereference registers at 00000000bef3d701 for ip apic_timer_interrupt+0xf/0x20
[  168.466843] ==================================================================
[  168.469452] BUG: KASAN: slab-out-of-bounds in __unwind_start+0x71/0x850
[  168.480707] Write of size 88 at addr ffff8880b8856d38 by task ip/1758
[  168.480707]
[  168.480707] CPU: 1 PID: 1758 Comm: ip Not tainted 5.3.0-rc7+ #322
[  ... ]
[  168.794493] Rebooting in 5 seconds..


Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netdevice.h |   4 ++
 net/core/dev.c            | 106 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..5bb5756129af 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1624,6 +1624,8 @@ enum netdev_priv_flags {
  *	@type:		Interface hardware type
  *	@hard_header_len: Maximum hardware header length.
  *	@min_header_len:  Minimum hardware header length
+ *	@upper_level:	Maximum depth level of upper devices.
+ *	@lower_level:	Maximum depth level of lower devices.
  *
  *	@needed_headroom: Extra headroom the hardware may need, but not in all
  *			  cases can this be guaranteed
@@ -1854,6 +1856,8 @@ struct net_device {
 	unsigned short		type;
 	unsigned short		hard_header_len;
 	unsigned char		min_header_len;
+	unsigned char		upper_level;
+	unsigned char		lower_level;
 
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
diff --git a/net/core/dev.c b/net/core/dev.c
index 0891f499c1bb..6a4b4ce62204 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,6 +146,7 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
+#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -6602,6 +6603,21 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
+static struct net_device *netdev_next_upper_dev(struct net_device *dev,
+						struct list_head **iter)
+{
+	struct netdev_adjacent *upper;
+
+	upper = list_entry((*iter)->next, struct netdev_adjacent, list);
+
+	if (&upper->list == &dev->adj_list.upper)
+		return NULL;
+
+	*iter = &upper->list;
+
+	return upper->dev;
+}
+
 static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 						    struct list_head **iter)
 {
@@ -6619,6 +6635,33 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
+int netdev_walk_all_upper_dev(struct net_device *dev,
+			      int (*fn)(struct net_device *dev,
+					void *data),
+			      void *data)
+{
+	struct net_device *udev;
+	struct list_head *iter;
+	int ret;
+
+	for (iter = &dev->adj_list.upper,
+	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev;
+	     udev = netdev_next_upper_dev(dev, &iter)) {
+		/* first is the upper device itself */
+		ret = fn(udev, data);
+		if (ret)
+			return ret;
+
+		/* then look at all of its upper devices */
+		ret = netdev_walk_all_upper_dev(udev, fn, data);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
 					    void *data),
@@ -6785,6 +6828,52 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 	return lower->dev;
 }
 
+static u8 __netdev_upper_depth(struct net_device *dev)
+{
+	struct net_device *udev;
+	struct list_head *iter;
+	u8 max_depth = 0;
+
+	for (iter = &dev->adj_list.upper,
+	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev;
+	     udev = netdev_next_upper_dev(dev, &iter)) {
+		if (max_depth < udev->upper_level)
+			max_depth = udev->upper_level;
+	}
+
+	return max_depth;
+}
+
+static u8 __netdev_lower_depth(struct net_device *dev)
+{
+	struct net_device *ldev;
+	struct list_head *iter;
+	u8 max_depth = 0;
+
+	for (iter = &dev->adj_list.lower,
+	     ldev = netdev_next_lower_dev(dev, &iter);
+	     ldev;
+	     ldev = netdev_next_lower_dev(dev, &iter)) {
+		if (max_depth < ldev->lower_level)
+			max_depth = ldev->lower_level;
+	}
+
+	return max_depth;
+}
+
+static int __netdev_update_upper_level(struct net_device *dev, void *data)
+{
+	dev->upper_level = __netdev_upper_depth(dev) + 1;
+	return 0;
+}
+
+static int __netdev_update_lower_level(struct net_device *dev, void *data)
+{
+	dev->lower_level = __netdev_lower_depth(dev) + 1;
+	return 0;
+}
+
 int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
 					    void *data),
@@ -7063,6 +7152,9 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (netdev_has_upper_dev(upper_dev, dev))
 		return -EBUSY;
 
+	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
+		return -EMLINK;
+
 	if (!master) {
 		if (netdev_has_upper_dev(dev, upper_dev))
 			return -EEXIST;
@@ -7089,6 +7181,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (ret)
 		goto rollback;
 
+	__netdev_update_upper_level(dev, NULL);
+	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+
+	__netdev_update_lower_level(upper_dev, NULL);
+	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+
 	return 0;
 
 rollback:
@@ -7171,6 +7269,12 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 
 	call_netdevice_notifiers_info(NETDEV_CHANGEUPPER,
 				      &changeupper_info.info);
+
+	__netdev_update_upper_level(dev, NULL);
+	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+
+	__netdev_update_lower_level(upper_dev, NULL);
+	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
@@ -9157,6 +9261,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
+	dev->upper_level = 1;
+	dev->lower_level = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
-- 
2.17.1

