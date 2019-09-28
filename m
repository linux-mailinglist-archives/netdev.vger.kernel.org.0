Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A0FC1154
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfI1QtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:49:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41338 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:49:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so3221733pfh.8;
        Sat, 28 Sep 2019 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G1T48Bdu4NesUcWUqIEwN33UNHciFwMiebfvljZSZF4=;
        b=cSyRr7u36ql9gGS58v1TCNnHQQ0+bXgwChD6IWLF4KeqjUunaJcqrEuUvibNKZz3hO
         KrorXMLZRNy6+w0hV+STTz2cjjQB5MVwgNYDJx0FPdxCFuPfeEGwCQcxVWicYcCzPTX8
         AoUZRcT3Ak/yemQN1QOBvfbqSNKHZKw8MJIPcAGdziSKvjd3Zy7QmgOjtaZ8TInWxkDn
         ZqfJpwueQ6MeQKW9ouVR5aW2IRaVFfVSIATwPvlmoLuS2H7g/03cVA5WPdDHZO8/RA0E
         Bch24VcKdu/bUvyYb4BkudZS0kkfeydUe9TKUUqvrSS8naXCd3ZgtRXy670LhV37op2X
         FX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G1T48Bdu4NesUcWUqIEwN33UNHciFwMiebfvljZSZF4=;
        b=O+6q4RV84OBmybTB0z6pT+yhnDVao5V+aej8FgI2k/YAnBm9wrUEHodtbeAGVFFm16
         MnCGfP257zzYGt6EVWpnyw1a1PvR2qBTrFb1+TLZg7UmzbCxeG6OqhQQNZTGPhRm4Vlu
         S7SSMVjxedTkgtGj8XtKET3AwoelYO0Yfghym6FjB3skEnz/NOwBP3KvBm5D/bfLAPj6
         QRI6rtWnQvJYBJ2H7j8ddHD9OkgR1XulZGG/xPHjoKLixjaCmsNCwfjjduhXadAj8Cs7
         Fw680NTFSN5kXtMdduzYsu8M2sWTQHR1SWCF2F5jktg+DybmV8FzAg4PfdLAgOxrA+I4
         tVzA==
X-Gm-Message-State: APjAAAVGbV0ndGzJuCQyfY9sIC/nVXxmq1q1GQmqo3XawD35Q7PCGKV/
        PLz+8qtVaFRaLx+nQ2c+8Ao=
X-Google-Smtp-Source: APXvYqzXqh34H3HHWWI+EA/3Id3QOjDlpn8EG8Lwok+yHyCbBk22zPx7i5o+OIgD6M0uoxxMooJmFg==
X-Received: by 2002:a63:4913:: with SMTP id w19mr15208840pga.185.1569689353100;
        Sat, 28 Sep 2019 09:49:13 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:49:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 01/12] net: core: limit nested device depth
Date:   Sat, 28 Sep 2019 16:48:32 +0000
Message-Id: <20190928164843.31800-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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
[  923.102992] Thread overran stack, or stack corrupted
[  923.103471] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  923.104086] CPU: 0 PID: 1597 Comm: ip Not tainted 5.3.0+ #3
[  923.104771] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  923.108837] RIP: 0010:stack_depot_fetch+0x10/0x30
[  923.109470] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 79 b1 83 ff 0f 0b e8 92 96 97 ff eb e9 89 f8 c1 ef 11 25 ff 0
[  923.111775] RSP: 0018:ffff8880541ceb78 EFLAGS: 00010006
[  923.112452] RAX: 00000000001fffff RBX: ffff8880541cee88 RCX: 0000000000000000
[  923.113399] RDX: 000000000000001d RSI: ffff8880541ceb80 RDI: 0000000000003ff0
[  923.114284] RBP: ffffea0001507380 R08: ffffed100d8fdf23 R09: ffffed100d8fdf23
[  923.115183] R10: 0000000000000001 R11: ffffed100d8fdf22 R12: ffff88806c240880
[  923.115986] R13: ffff8880541cec98 R14: ffff8880541cee88 R15: ffff8880541ced20
[  923.120477] FS:  00007ff38ab4f0c0(0000) GS:ffff88806c600000(0000) knlGS:0000000000000000
[  923.121486] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  923.122451] CR2: ffffffffa5be5658 CR3: 0000000053532004 CR4: 00000000000606f0
[  923.123303] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  923.128422] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  923.129399] Call Trace:
[  923.129710] Modules linked in: 8021q dummy ip_tables x_tables
[  923.130518] CR2: ffffffffa5be5658
[  923.130909] ---[ end trace 9568b7d36ab26094 ]---
[  923.131457] RIP: 0010:stack_depot_fetch+0x10/0x30
[  923.132006] Code: 00 75 10 48 8b 73 18 48 89 ef 5b 5d e9 79 b1 83 ff 0f 0b e8 92 96 97 ff eb e9 89 f8 c1 ef 11 25 ff 0
[  923.134219] RSP: 0018:ffff8880541ceb78 EFLAGS: 00010006
[  923.134834] RAX: 00000000001fffff RBX: ffff8880541cee88 RCX: 0000000000000000
[  923.135664] RDX: 000000000000001d RSI: ffff8880541ceb80 RDI: 0000000000003ff0
[  923.136514] RBP: ffffea0001507380 R08: ffffed100d8fdf23 R09: ffffed100d8fdf23
[  923.137276] R10: 0000000000000001 R11: ffffed100d8fdf22 R12: ffff88806c240880
[  923.138025] R13: ffff8880541cec98 R14: ffff8880541cee88 R15: ffff8880541ced20
[  923.138773] FS:  00007ff38ab4f0c0(0000) GS:ffff88806c600000(0000) knlGS:0000000000000000
[  923.140099] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  923.140763] CR2: ffffffffa5be5658 CR3: 0000000053532004 CR4: 00000000000606f0
[  923.141539] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  923.144930] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  923.145942] Kernel panic - not syncing: Fatal exception

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3 -> v4 :
 - This patch is not changed
v2 -> v3 :
 - Modify nesting infra code to use iterator instead of recursive
 v1 -> v2 :
  - This patch is not changed

 include/linux/netdevice.h |   4 +
 net/core/dev.c            | 286 ++++++++++++++++++++++++++++++++------
 2 files changed, 245 insertions(+), 45 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c31d1f7..613007aa5986 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1637,6 +1637,8 @@ enum netdev_priv_flags {
  *	@type:		Interface hardware type
  *	@hard_header_len: Maximum hardware header length.
  *	@min_header_len:  Minimum hardware header length
+ *	@upper_level:	Maximum depth level of upper devices.
+ *	@lower_level:	Maximum depth level of lower devices.
  *
  *	@needed_headroom: Extra headroom the hardware may need, but not in all
  *			  cases can this be guaranteed
@@ -1867,6 +1869,8 @@ struct net_device {
 	unsigned short		type;
 	unsigned short		hard_header_len;
 	unsigned char		min_header_len;
+	unsigned char		upper_level;
+	unsigned char		lower_level;
 
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..13cb646fb98f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,6 +146,7 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
+#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -6644,6 +6645,21 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
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
@@ -6661,31 +6677,103 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
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
 
@@ -6790,23 +6878,45 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
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
@@ -6827,31 +6937,100 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
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
 
@@ -7105,6 +7284,9 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 	if (netdev_has_upper_dev(upper_dev, dev))
 		return -EBUSY;
 
+	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
+		return -EMLINK;
+
 	if (!master) {
 		if (netdev_has_upper_dev(dev, upper_dev))
 			return -EEXIST;
@@ -7131,6 +7313,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
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
@@ -7213,6 +7401,12 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 
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
 
@@ -9212,6 +9406,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
+	dev->upper_level = 1;
+	dev->lower_level = 1;
 
 	INIT_LIST_HEAD(&dev->napi_list);
 	INIT_LIST_HEAD(&dev->unreg_list);
-- 
2.17.1

