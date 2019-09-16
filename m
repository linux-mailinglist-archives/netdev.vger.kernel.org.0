Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6F6B3BC3
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbfIPNsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35029 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfIPNsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so23057308pfw.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E2iTkoNKc433ZlxkZab3V2S2Vj7M1Jee30XLKPAKn98=;
        b=ZLrLQGpxJixcQR0XhWYjb0y+Yvk1OX7vXxAxw1yh/gkkDGNpw7b6K1erCJguqRCSp+
         2CwAwOHcVZmeaaNivDLZQf39x1mxwYHKJL+njESf4pq2kIisEWbnk5MhbIkwEf9HG5m6
         AmU5gkerGMIBaHpR1faNDpfF1Af7bnRdknO5B6APSG8E3iQXgGfnAl0Ukdask/2FpxOD
         yjK4iS94/4sD3vpRTCk6GEYhjUcWneule6YG+27zQE1ayqf66Qykt72ILhnj5S7M+1yI
         +ins1CUGPeXR/3TPt1YG7B1bZdZRAriDnWXY+CvPRy8W6z1c2UlkEskvszPHu9+qYO/3
         33hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E2iTkoNKc433ZlxkZab3V2S2Vj7M1Jee30XLKPAKn98=;
        b=Qd+uIudtkXwt+bVsDa7TXXucfP3OjyKN0GqBIezlMD5i16hIr9Nn0rBVTyWjmScLH2
         oo1JJ232mR1CbcxX1gO5Xp+IYcV0F5no1LFwRmHFzsZekG476m0Cx9aLHldamKcXQKfn
         0OXgXnHaYDD/W5MSjfCxyav5EiFjuLIfwPdCmiso71+H21q94QLuSQglnGWBzAyWjO+F
         EbEbHmyls7LVW1hZ04DO52oK/HofKtuQWss17XzEfu+nZRjBcZTSwHlME+1wwKQgK0u2
         uk0Mmyz7vMQ1VaaiLEDMylqZSECedWp5xJzMS1YV9gTpZ/gwwqHOYNyhlnL/g+rbBoRe
         nd0g==
X-Gm-Message-State: APjAAAWArGQ8O4rh8Nj+dWD0+FHnHPv0QBWq5Fiap9IRUjlaIUYnMnDp
        k0tJ+TgJEpIQE5oI5J26Dq4=
X-Google-Smtp-Source: APXvYqwJkvI4Mj1HeZC37DpVyXVo42yUZDuiwa8rn2YWZt/PvvnUuLkGoBg4ISAZRVtGfov0FB7INw==
X-Received: by 2002:a63:3c08:: with SMTP id j8mr21520053pga.72.1568641701051;
        Mon, 16 Sep 2019 06:48:21 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:19 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 01/11] net: core: limit nested device depth
Date:   Mon, 16 Sep 2019 22:47:52 +0900
Message-Id: <20190916134802.8252-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code doesn't limit the number of nested devices.
Nested devices would be handled recursively and this needs huge stack
memory. So, unlimited nested devices could make stack overflow.

This patch adds upper_level and lower_level, they are common variables
and represent maximum lower/upper depth.
When upper/lower device is attached or dettached,
{lower/upper}_level are updated. and if maximum depth is bigger than 8,
attach routine fails and returns -EMLINK.

In addition, this patch converts recursive routine of
netdev_walk_all_{lower/upper} to iterator routine.

Test commands:
    ip link add dummy0 type dummy
    ip link add link dummy0 name vlan1 type vlan id 1
    ip link set vlan1 up

    for i in {2..200}
    do
	    let A=$i-1

	    ip link add vlan$i link vlan$A type vlan id $i
    done
    ip link del vlan1

Splat looks like:
[  132.396918] Thread overran stack, or stack corrupted
[  132.397763] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  132.398557] CPU: 1 PID: 1299 Comm: ip Not tainted 5.3.0-rc8+ #179
[  132.399241] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  132.400136] RIP: 0010:stack_depot_fetch+0x10/0x30
[  132.400683] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 79 8f 87 ff 0f 0b e8 c2 6d 9b ff eb e9 89 f8 c1 ef 110
[  132.402711] RSP: 0000:ffff8880b002eb78 EFLAGS: 00010006
[  132.404578] RAX: 00000000001fffff RBX: ffff8880b002eec0 RCX: 0000000000000000
[  132.405305] RDX: 000000000000001d RSI: ffff8880b002eb80 RDI: 0000000000003ff0
[  132.406022] RBP: ffffea0002c00a00 R08: ffffed101b53df23 R09: ffffed101b53df23
[  132.406776] R10: 0000000000000001 R11: ffffed101b53df22 R12: ffff8880d38dd900
[  132.407598] R13: ffff8880b002e600 R14: ffff8880b002eec0 R15: ffff8880b002ed20
[  132.408365] FS:  00007f5fca3c90c0(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
[  132.409213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  132.409788] CR2: ffffffffa598b098 CR3: 00000000ccb86004 CR4: 00000000000606e0
[  132.410659] Call Trace:
[  132.410962] Modules linked in: 8021q garp stp mrp llc dummy veth openvswitch nsh nf_conncount nf_nat nf_conntrs
[  132.412410] CR2: ffffffffa598b098
[  132.412754] ---[ end trace 7f335fb982ddb2da ]---
[  132.413293] RIP: 0010:stack_depot_fetch+0x10/0x30
[  132.413851] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 79 8f 87 ff 0f 0b e8 c2 6d 9b ff eb e9 89 f8 c1 ef 110
[  132.415973] RSP: 0000:ffff8880b002eb78 EFLAGS: 00010006
[  132.416581] RAX: 00000000001fffff RBX: ffff8880b002eec0 RCX: 0000000000000000
[  132.417380] RDX: 000000000000001d RSI: ffff8880b002eb80 RDI: 0000000000003ff0
[  132.418211] RBP: ffffea0002c00a00 R08: ffffed101b53df23 R09: ffffed101b53df23
[  132.419036] R10: 0000000000000001 R11: ffffed101b53df22 R12: ffff8880d38dd900
[  132.419815] R13: ffff8880b002e600 R14: ffff8880b002eec0 R15: ffff8880b002ed20
[  132.420616] FS:  00007f5fca3c90c0(0000) GS:ffff8880da800000(0000) knlGS:0000000000000000
[  132.421489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  132.422134] CR2: ffffffffa598b098 CR3: 00000000ccb86004 CR4: 00000000000606e0
[  132.422912] Kernel panic - not syncing: Fatal exception
[  132.423441] Kernel Offset: 0x1f000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff)
[  132.425455] Rebooting in 5 seconds..

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - Modify nesting infra code to use iterator instead of recursive
v1 -> v2 :
 - This patch is not changed

 include/linux/netdevice.h |   4 +
 net/core/dev.c            | 286 ++++++++++++++++++++++++++++++++------
 2 files changed, 245 insertions(+), 45 deletions(-)

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
index 5156c0edebe8..fa847ea957ee 100644
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
@@ -6619,31 +6635,103 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
+int netdev_walk_all_upper_dev(struct net_device *dev,
+			      int (*fn)(struct net_device *dev,
+					void *data),
+			      void *data)
+{
+	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
+
+	now = dev;
+	iter = &dev->adj_list.upper;
+
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			udev = netdev_next_upper_dev(now, &iter);
+			if (!udev)
+				break;
+
+			if (!next) {
+				next = udev;
+				niter = &udev->adj_list.upper;
+			} else {
+				dev_stack[cur] = udev;
+				iter_stack[cur++] = &udev->adj_list.upper;
+				break;
+			}
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
+	}
+
+	return 0;
+}
+
 int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
 					    void *data),
 				  void *data)
 {
-	struct net_device *udev;
-	struct list_head *iter;
-	int ret;
+	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
 
-	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev_rcu(dev, &iter);
-	     udev;
-	     udev = netdev_next_upper_dev_rcu(dev, &iter)) {
-		/* first is the upper device itself */
-		ret = fn(udev, data);
-		if (ret)
-			return ret;
+	now = dev;
+	iter = &dev->adj_list.upper;
 
-		/* then look at all of its upper devices */
-		ret = netdev_walk_all_upper_dev_rcu(udev, fn, data);
-		if (ret)
-			return ret;
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			udev = netdev_next_upper_dev_rcu(now, &iter);
+			if (!udev)
+				break;
+
+			if (!next) {
+				next = udev;
+				niter = &udev->adj_list.upper;
+			} else {
+				dev_stack[cur] = udev;
+				iter_stack[cur++] = &udev->adj_list.upper;
+				break;
+			}
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
+
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_upper_dev_rcu);
 
@@ -6748,23 +6836,45 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 					void *data),
 			      void *data)
 {
-	struct net_device *ldev;
-	struct list_head *iter;
-	int ret;
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
 
-	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev(dev, &iter);
-	     ldev;
-	     ldev = netdev_next_lower_dev(dev, &iter)) {
-		/* first is the lower device itself */
-		ret = fn(ldev, data);
-		if (ret)
-			return ret;
+	now = dev;
+	iter = &dev->adj_list.lower;
 
-		/* then look at all of its lower devices */
-		ret = netdev_walk_all_lower_dev(ldev, fn, data);
-		if (ret)
-			return ret;
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev(now, &iter);
+			if (!ldev)
+				break;
+
+			if (!next) {
+				next = ldev;
+				niter = &ldev->adj_list.lower;
+			} else {
+				dev_stack[cur] = ldev;
+				iter_stack[cur++] = &ldev->adj_list.lower;
+				break;
+			}
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
@@ -6785,31 +6895,100 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 	return lower->dev;
 }
 
-int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
-				  int (*fn)(struct net_device *dev,
-					    void *data),
-				  void *data)
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
 {
 	struct net_device *ldev;
 	struct list_head *iter;
-	int ret;
+	u8 max_depth = 0;
 
 	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev_rcu(dev, &iter);
+	     ldev = netdev_next_lower_dev(dev, &iter);
 	     ldev;
-	     ldev = netdev_next_lower_dev_rcu(dev, &iter)) {
-		/* first is the lower device itself */
-		ret = fn(ldev, data);
-		if (ret)
-			return ret;
+	     ldev = netdev_next_lower_dev(dev, &iter)) {
+		if (max_depth < ldev->lower_level)
+			max_depth = ldev->lower_level;
+	}
 
-		/* then look at all of its lower devices */
-		ret = netdev_walk_all_lower_dev_rcu(ldev, fn, data);
-		if (ret)
-			return ret;
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
+int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
+				  int (*fn)(struct net_device *dev,
+					    void *data),
+				  void *data)
+{
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
+
+	now = dev;
+	iter = &dev->adj_list.lower;
+
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev_rcu(now, &iter);
+			if (!ldev)
+				break;
+
+			if (!next) {
+				next = ldev;
+				niter = &ldev->adj_list.lower;
+			} else {
+				dev_stack[cur] = ldev;
+				iter_stack[cur++] = &ldev->adj_list.lower;
+				break;
+			}
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
 	}
 
 	return 0;
+
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev_rcu);
 
@@ -7063,6 +7242,9 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (netdev_has_upper_dev(upper_dev, dev))
 		return -EBUSY;
 
+	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
+		return -EMLINK;
+
 	if (!master) {
 		if (netdev_has_upper_dev(dev, upper_dev))
 			return -EEXIST;
@@ -7089,6 +7271,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
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
@@ -7171,6 +7359,12 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 
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
 
@@ -9159,6 +9353,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
+	dev->upper_level = 1;
+	dev->lower_level = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
-- 
2.17.1

