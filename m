Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026C1381B64
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhEOWQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235287AbhEOWQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08C06135C;
        Sat, 15 May 2021 22:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116894;
        bh=vni8k0ArJb89z2uVBHegw/ZmCVRJeWKkz8b0+Raazxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxVNRak5NStf2PyHZZ02HsPT7aowtsMbtlzgWQq7TYdB2KP0XFgFG9IcCtoslwUTu
         jwcuuXFFP8qjRdLAQ6Zmg3eXKVfT1p8ZInXyEl4pbzKIiBLg6nfqGKreRAbDaPQC+o
         Wdih04YdHfccLgo4JVB6W6qzOFg8dmH80SFcYLKDEA4p0YmWkBHRnozgUcuvvkCxzQ
         soeifdmUFAJzj/PBM7f/dE7Vq32w6XGAKpmTdFKfC2ExlwXiZBRHa96tv194PxQtEB
         pBugyDDyyfUHqcCvROb6N52b+oBGUewvkPlGJS4qq+LYXiK/rq1+FganGkB6KOQkr5
         t0+/ao/1IpP8Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 07/13] [net-next] move netdev_boot_setup into Space.c
Date:   Sun, 16 May 2021 00:13:14 +0200
Message-Id: <20210515221320.1255291-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is now only used by a handful of old ISA drivers,
and can be moved into the file they already all depend on.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Space.c       | 142 ++++++++++++++++++++++++++++++++++++++
 include/linux/netdevice.h |  13 ----
 net/core/dev.c            | 125 ---------------------------------
 net/ethernet/eth.c        |   2 -
 4 files changed, 142 insertions(+), 140 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index a03559f23295..f40f2e38682f 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -30,6 +30,148 @@
 #include <linux/netlink.h>
 #include <net/Space.h>
 
+/*
+ * This structure holds boot-time configured netdevice settings. They
+ * are then used in the device probing.
+ */
+struct netdev_boot_setup {
+	char name[IFNAMSIZ];
+	struct ifmap map;
+};
+#define NETDEV_BOOT_SETUP_MAX 8
+
+
+/******************************************************************************
+ *
+ *		      Device Boot-time Settings Routines
+ *
+ ******************************************************************************/
+
+/* Boot time configuration table */
+static struct netdev_boot_setup dev_boot_setup[NETDEV_BOOT_SETUP_MAX];
+
+/**
+ *	netdev_boot_setup_add	- add new setup entry
+ *	@name: name of the device
+ *	@map: configured settings for the device
+ *
+ *	Adds new setup entry to the dev_boot_setup list.  The function
+ *	returns 0 on error and 1 on success.  This is a generic routine to
+ *	all netdevices.
+ */
+static int netdev_boot_setup_add(char *name, struct ifmap *map)
+{
+	struct netdev_boot_setup *s;
+	int i;
+
+	s = dev_boot_setup;
+	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++) {
+		if (s[i].name[0] == '\0' || s[i].name[0] == ' ') {
+			memset(s[i].name, 0, sizeof(s[i].name));
+			strlcpy(s[i].name, name, IFNAMSIZ);
+			memcpy(&s[i].map, map, sizeof(s[i].map));
+			break;
+		}
+	}
+
+	return i >= NETDEV_BOOT_SETUP_MAX ? 0 : 1;
+}
+
+/**
+ * netdev_boot_setup_check	- check boot time settings
+ * @dev: the netdevice
+ *
+ * Check boot time settings for the device.
+ * The found settings are set for the device to be used
+ * later in the device probing.
+ * Returns 0 if no settings found, 1 if they are.
+ */
+int netdev_boot_setup_check(struct net_device *dev)
+{
+	struct netdev_boot_setup *s = dev_boot_setup;
+	int i;
+
+	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++) {
+		if (s[i].name[0] != '\0' && s[i].name[0] != ' ' &&
+		    !strcmp(dev->name, s[i].name)) {
+			dev->irq = s[i].map.irq;
+			dev->base_addr = s[i].map.base_addr;
+			dev->mem_start = s[i].map.mem_start;
+			dev->mem_end = s[i].map.mem_end;
+			return 1;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(netdev_boot_setup_check);
+
+/**
+ * netdev_boot_base	- get address from boot time settings
+ * @prefix: prefix for network device
+ * @unit: id for network device
+ *
+ * Check boot time settings for the base address of device.
+ * The found settings are set for the device to be used
+ * later in the device probing.
+ * Returns 0 if no settings found.
+ */
+static unsigned long netdev_boot_base(const char *prefix, int unit)
+{
+	const struct netdev_boot_setup *s = dev_boot_setup;
+	char name[IFNAMSIZ];
+	int i;
+
+	sprintf(name, "%s%d", prefix, unit);
+
+	/*
+	 * If device already registered then return base of 1
+	 * to indicate not to probe for this interface
+	 */
+	if (__dev_get_by_name(&init_net, name))
+		return 1;
+
+	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++)
+		if (!strcmp(name, s[i].name))
+			return s[i].map.base_addr;
+	return 0;
+}
+
+/*
+ * Saves at boot time configured settings for any netdevice.
+ */
+static int __init netdev_boot_setup(char *str)
+{
+	int ints[5];
+	struct ifmap map;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+	if (!str || !*str)
+		return 0;
+
+	/* Save settings */
+	memset(&map, 0, sizeof(map));
+	if (ints[0] > 0)
+		map.irq = ints[1];
+	if (ints[0] > 1)
+		map.base_addr = ints[2];
+	if (ints[0] > 2)
+		map.mem_start = ints[3];
+	if (ints[0] > 3)
+		map.mem_end = ints[4];
+
+	/* Add new entry to the list */
+	return netdev_boot_setup_add(str, &map);
+}
+
+__setup("netdev=", netdev_boot_setup);
+
+static int __init ether_boot_setup(char *str)
+{
+	return netdev_boot_setup(str);
+}
+__setup("ether=", ether_boot_setup);
+
+
 /* A unified ethernet device probe.  This is the easiest way to have every
  * ethernet adaptor have the name "eth[0123...]".
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..75e945a92235 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -295,18 +295,6 @@ enum netdev_state_t {
 };
 
 
-/*
- * This structure holds boot-time configured netdevice settings. They
- * are then used in the device probing.
- */
-struct netdev_boot_setup {
-	char name[IFNAMSIZ];
-	struct ifmap map;
-};
-#define NETDEV_BOOT_SETUP_MAX 8
-
-int __init netdev_boot_setup(char *str);
-
 struct gro_list {
 	struct list_head	list;
 	int			count;
@@ -2917,7 +2905,6 @@ static inline struct net_device *first_net_device_rcu(struct net *net)
 }
 
 int netdev_boot_setup_check(struct net_device *dev);
-unsigned long netdev_boot_base(const char *prefix, int unit);
 struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 				       const char *hwaddr);
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type);
diff --git a/net/core/dev.c b/net/core/dev.c
index 222b1d322c96..a4309a7f585e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -674,131 +674,6 @@ void dev_remove_offload(struct packet_offload *po)
 }
 EXPORT_SYMBOL(dev_remove_offload);
 
-/******************************************************************************
- *
- *		      Device Boot-time Settings Routines
- *
- ******************************************************************************/
-
-/* Boot time configuration table */
-static struct netdev_boot_setup dev_boot_setup[NETDEV_BOOT_SETUP_MAX];
-
-/**
- *	netdev_boot_setup_add	- add new setup entry
- *	@name: name of the device
- *	@map: configured settings for the device
- *
- *	Adds new setup entry to the dev_boot_setup list.  The function
- *	returns 0 on error and 1 on success.  This is a generic routine to
- *	all netdevices.
- */
-static int netdev_boot_setup_add(char *name, struct ifmap *map)
-{
-	struct netdev_boot_setup *s;
-	int i;
-
-	s = dev_boot_setup;
-	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++) {
-		if (s[i].name[0] == '\0' || s[i].name[0] == ' ') {
-			memset(s[i].name, 0, sizeof(s[i].name));
-			strlcpy(s[i].name, name, IFNAMSIZ);
-			memcpy(&s[i].map, map, sizeof(s[i].map));
-			break;
-		}
-	}
-
-	return i >= NETDEV_BOOT_SETUP_MAX ? 0 : 1;
-}
-
-/**
- * netdev_boot_setup_check	- check boot time settings
- * @dev: the netdevice
- *
- * Check boot time settings for the device.
- * The found settings are set for the device to be used
- * later in the device probing.
- * Returns 0 if no settings found, 1 if they are.
- */
-int netdev_boot_setup_check(struct net_device *dev)
-{
-	struct netdev_boot_setup *s = dev_boot_setup;
-	int i;
-
-	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++) {
-		if (s[i].name[0] != '\0' && s[i].name[0] != ' ' &&
-		    !strcmp(dev->name, s[i].name)) {
-			dev->irq = s[i].map.irq;
-			dev->base_addr = s[i].map.base_addr;
-			dev->mem_start = s[i].map.mem_start;
-			dev->mem_end = s[i].map.mem_end;
-			return 1;
-		}
-	}
-	return 0;
-}
-EXPORT_SYMBOL(netdev_boot_setup_check);
-
-
-/**
- * netdev_boot_base	- get address from boot time settings
- * @prefix: prefix for network device
- * @unit: id for network device
- *
- * Check boot time settings for the base address of device.
- * The found settings are set for the device to be used
- * later in the device probing.
- * Returns 0 if no settings found.
- */
-unsigned long netdev_boot_base(const char *prefix, int unit)
-{
-	const struct netdev_boot_setup *s = dev_boot_setup;
-	char name[IFNAMSIZ];
-	int i;
-
-	sprintf(name, "%s%d", prefix, unit);
-
-	/*
-	 * If device already registered then return base of 1
-	 * to indicate not to probe for this interface
-	 */
-	if (__dev_get_by_name(&init_net, name))
-		return 1;
-
-	for (i = 0; i < NETDEV_BOOT_SETUP_MAX; i++)
-		if (!strcmp(name, s[i].name))
-			return s[i].map.base_addr;
-	return 0;
-}
-
-/*
- * Saves at boot time configured settings for any netdevice.
- */
-int __init netdev_boot_setup(char *str)
-{
-	int ints[5];
-	struct ifmap map;
-
-	str = get_options(str, ARRAY_SIZE(ints), ints);
-	if (!str || !*str)
-		return 0;
-
-	/* Save settings */
-	memset(&map, 0, sizeof(map));
-	if (ints[0] > 0)
-		map.irq = ints[1];
-	if (ints[0] > 1)
-		map.base_addr = ints[2];
-	if (ints[0] > 2)
-		map.mem_start = ints[3];
-	if (ints[0] > 3)
-		map.mem_end = ints[4];
-
-	/* Add new entry to the list */
-	return netdev_boot_setup_add(str, &map);
-}
-
-__setup("netdev=", netdev_boot_setup);
-
 /*******************************************************************************
  *
  *			    Device Interface Subroutines
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 9cce612e8976..e2c496152dd8 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -62,8 +62,6 @@
 #include <linux/uaccess.h>
 #include <net/pkt_sched.h>
 
-__setup("ether=", netdev_boot_setup);
-
 /**
  * eth_header - create the Ethernet header
  * @skb:	buffer to alter
-- 
2.29.2

