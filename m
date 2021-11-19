Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82956457087
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbhKSOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234817AbhKSOZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF35A61B5E;
        Fri, 19 Nov 2021 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331721;
        bh=5ONvkVmSFKJtBQt9G1/SiPgXQyQSzXDp66/5sGiCz4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1Snd4ekpAmOJTwsj62oztb/SGtzHtg0U28lIkpGDyEVbDiBV+vCzMM2fbigM94fj
         3vksbhPrPZhwD6ptzXWR9PgataRowlJXmuymueH9u9lIIJdOGccKIuCRE3LTRwAM+s
         7N0XOlpdqs4Cm+7iDzuf2nyEVF2e04nBC9KyU4tw7k7hrjL3+ZSeZwh/4a7V09Fi5v
         Cr6El3mr5aoadTLOR5sdfiuBpfrrphYh0+j4BxHgR2My3tujF6TlslAkUw7Uq3FQB5
         vDkzsnyLQMbqfBjPwdyTDRFbmmcDyflFRC93gLDW+jKVA2x2X3g1WbWymCP8O8DjKS
         I7RufbHV1UkjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 7/7] net: kunit: add a test for dev_addr_lists
Date:   Fri, 19 Nov 2021 06:21:55 -0800
Message-Id: <20211119142155.3779933-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a KUnit test for the dev_addr API.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/Kconfig                    |   5 +
 net/core/Makefile              |   2 +
 net/core/dev_addr_lists_test.c | 236 +++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 net/core/dev_addr_lists_test.c

diff --git a/net/Kconfig b/net/Kconfig
index 074472dfa94a..8a1f9d0287de 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -455,4 +455,9 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config NETDEV_ADDR_LIST_TEST
+	tristate "Unit tests for device address list"
+	default KUNIT_ALL_TESTS
+	depends on KUNIT
+
 endif   # if NET
diff --git a/net/core/Makefile b/net/core/Makefile
index 6bdcb2cafed8..a8e4f737692b 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -13,6 +13,8 @@ obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
 			fib_notifier.o xdp.o flow_offload.o gro.o
 
+obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
+
 obj-y += net-sysfs.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o
 obj-$(CONFIG_PROC_FS) += net-procfs.o
diff --git a/net/core/dev_addr_lists_test.c b/net/core/dev_addr_lists_test.c
new file mode 100644
index 000000000000..049cfbc58aa9
--- /dev/null
+++ b/net/core/dev_addr_lists_test.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <kunit/test.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+
+static const struct net_device_ops dummy_netdev_ops = {
+};
+
+struct dev_addr_test_priv {
+	u32 addr_seen;
+};
+
+static int dev_addr_test_sync(struct net_device *netdev, const unsigned char *a)
+{
+	struct dev_addr_test_priv *datp = netdev_priv(netdev);
+
+	if (a[0] < 31 && !memchr_inv(a, a[0], ETH_ALEN))
+		datp->addr_seen |= 1 << a[0];
+	return 0;
+}
+
+static int dev_addr_test_unsync(struct net_device *netdev,
+				const unsigned char *a)
+{
+	struct dev_addr_test_priv *datp = netdev_priv(netdev);
+
+	if (a[0] < 31 && !memchr_inv(a, a[0], ETH_ALEN))
+		datp->addr_seen &= ~(1 << a[0]);
+	return 0;
+}
+
+static int dev_addr_test_init(struct kunit *test)
+{
+	struct dev_addr_test_priv *datp;
+	struct net_device *netdev;
+	int err;
+
+	netdev = alloc_etherdev(sizeof(*datp));
+	KUNIT_ASSERT_TRUE(test, !!netdev);
+
+	test->priv = netdev;
+	netdev->netdev_ops = &dummy_netdev_ops;
+
+	err = register_netdev(netdev);
+	if (err) {
+		free_netdev(netdev);
+		KUNIT_FAIL(test, "Can't register netdev %d", err);
+	}
+
+	rtnl_lock();
+	return 0;
+}
+
+static void dev_addr_test_exit(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+
+	rtnl_unlock();
+	unregister_netdev(netdev);
+	free_netdev(netdev);
+}
+
+static void dev_addr_test_basic(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	u8 addr[ETH_ALEN];
+
+	KUNIT_EXPECT_TRUE(test, !!netdev->dev_addr);
+
+	memset(addr, 2, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+	KUNIT_EXPECT_EQ(test, 0, memcmp(netdev->dev_addr, addr, sizeof(addr)));
+
+	memset(addr, 3, sizeof(addr));
+	dev_addr_set(netdev, addr);
+	KUNIT_EXPECT_EQ(test, 0, memcmp(netdev->dev_addr, addr, sizeof(addr)));
+}
+
+static void dev_addr_test_sync_one(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	struct dev_addr_test_priv *datp;
+	u8 addr[ETH_ALEN];
+
+	datp = netdev_priv(netdev);
+
+	memset(addr, 1, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	KUNIT_EXPECT_EQ(test, 2, datp->addr_seen);
+
+	memset(addr, 2, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+
+	datp->addr_seen = 0;
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	/* It's not going to sync anything because the main address is
+	 * considered synced and we overwrite in place.
+	 */
+	KUNIT_EXPECT_EQ(test, 0, datp->addr_seen);
+}
+
+static void dev_addr_test_add_del(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	struct dev_addr_test_priv *datp;
+	u8 addr[ETH_ALEN];
+	int i;
+
+	datp = netdev_priv(netdev);
+
+	for (i = 1; i < 4; i++) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, 0, dev_addr_add(netdev, addr,
+						      NETDEV_HW_ADDR_T_LAN));
+	}
+	/* Add 3 again */
+	KUNIT_EXPECT_EQ(test, 0, dev_addr_add(netdev, addr,
+					      NETDEV_HW_ADDR_T_LAN));
+
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	KUNIT_EXPECT_EQ(test, 0xf, datp->addr_seen);
+
+	KUNIT_EXPECT_EQ(test, 0, dev_addr_del(netdev, addr,
+					      NETDEV_HW_ADDR_T_LAN));
+
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	KUNIT_EXPECT_EQ(test, 0xf, datp->addr_seen);
+
+	for (i = 1; i < 4; i++) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, 0, dev_addr_del(netdev, addr,
+						      NETDEV_HW_ADDR_T_LAN));
+	}
+
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	KUNIT_EXPECT_EQ(test, 1, datp->addr_seen);
+}
+
+static void dev_addr_test_del_main(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	u8 addr[ETH_ALEN];
+
+	memset(addr, 1, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+
+	KUNIT_EXPECT_EQ(test, -ENOENT, dev_addr_del(netdev, addr,
+						    NETDEV_HW_ADDR_T_LAN));
+	KUNIT_EXPECT_EQ(test, 0, dev_addr_add(netdev, addr,
+					      NETDEV_HW_ADDR_T_LAN));
+	KUNIT_EXPECT_EQ(test, 0, dev_addr_del(netdev, addr,
+					      NETDEV_HW_ADDR_T_LAN));
+	KUNIT_EXPECT_EQ(test, -ENOENT, dev_addr_del(netdev, addr,
+						    NETDEV_HW_ADDR_T_LAN));
+}
+
+static void dev_addr_test_add_set(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	struct dev_addr_test_priv *datp;
+	u8 addr[ETH_ALEN];
+	int i;
+
+	datp = netdev_priv(netdev);
+
+	/* There is no external API like dev_addr_add_excl(),
+	 * so shuffle the tree a little bit and exploit aliasing.
+	 */
+	for (i = 1; i < 16; i++) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, 0, dev_addr_add(netdev, addr,
+						      NETDEV_HW_ADDR_T_LAN));
+	}
+
+	memset(addr, i, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+	KUNIT_EXPECT_EQ(test, 0, dev_addr_add(netdev, addr,
+					      NETDEV_HW_ADDR_T_LAN));
+	memset(addr, 0, sizeof(addr));
+	eth_hw_addr_set(netdev, addr);
+
+	__hw_addr_sync_dev(&netdev->dev_addrs, netdev, dev_addr_test_sync,
+			   dev_addr_test_unsync);
+	KUNIT_EXPECT_EQ(test, 0xffff, datp->addr_seen);
+}
+
+static void dev_addr_test_add_excl(struct kunit *test)
+{
+	struct net_device *netdev = test->priv;
+	u8 addr[ETH_ALEN];
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, 0, dev_uc_add_excl(netdev, addr));
+	}
+	KUNIT_EXPECT_EQ(test, -EEXIST, dev_uc_add_excl(netdev, addr));
+
+	for (i = 0; i < 10; i += 2) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, 0, dev_uc_del(netdev, addr));
+	}
+	for (i = 1; i < 10; i += 2) {
+		memset(addr, i, sizeof(addr));
+		KUNIT_EXPECT_EQ(test, -EEXIST, dev_uc_add_excl(netdev, addr));
+	}
+}
+
+static struct kunit_case dev_addr_test_cases[] = {
+	KUNIT_CASE(dev_addr_test_basic),
+	KUNIT_CASE(dev_addr_test_sync_one),
+	KUNIT_CASE(dev_addr_test_add_del),
+	KUNIT_CASE(dev_addr_test_del_main),
+	KUNIT_CASE(dev_addr_test_add_set),
+	KUNIT_CASE(dev_addr_test_add_excl),
+	{}
+};
+
+static struct kunit_suite dev_addr_test_suite = {
+	.name = "dev-addr-list-test",
+	.test_cases = dev_addr_test_cases,
+	.init = dev_addr_test_init,
+	.exit = dev_addr_test_exit,
+};
+kunit_test_suite(dev_addr_test_suite);
+
+MODULE_LICENSE("GPL");
-- 
2.31.1

