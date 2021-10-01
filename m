Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C941E8F6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352553AbhJAIVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:21:09 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33718 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352290AbhJAIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:21:05 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 27DDD20274; Fri,  1 Oct 2021 16:19:15 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 2/5] mctp: Add test utils
Date:   Fri,  1 Oct 2021 16:18:41 +0800
Message-Id: <20211001081844.3408786-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001081844.3408786-1-jk@codeconstruct.com.au>
References: <20211001081844.3408786-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new object for shared test utilities

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/Makefile     |  3 ++
 net/mctp/test/utils.c | 67 +++++++++++++++++++++++++++++++++++++++++++
 net/mctp/test/utils.h | 20 +++++++++++++
 3 files changed, 90 insertions(+)
 create mode 100644 net/mctp/test/utils.c
 create mode 100644 net/mctp/test/utils.h

diff --git a/net/mctp/Makefile b/net/mctp/Makefile
index 0171333384d7..6cd55233e685 100644
--- a/net/mctp/Makefile
+++ b/net/mctp/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MCTP) += mctp.o
 mctp-objs := af_mctp.o device.o route.o neigh.o
+
+# tests
+obj-$(CONFIG_MCTP_TEST) += test/utils.o
diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
new file mode 100644
index 000000000000..e2ab1f3da357
--- /dev/null
+++ b/net/mctp/test/utils.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/netdevice.h>
+#include <linux/mctp.h>
+#include <linux/if_arp.h>
+
+#include <net/mctpdevice.h>
+#include <net/pkt_sched.h>
+
+#include "utils.h"
+
+static netdev_tx_t mctp_test_dev_tx(struct sk_buff *skb,
+				    struct net_device *ndev)
+{
+	kfree(skb);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops mctp_test_netdev_ops = {
+	.ndo_start_xmit = mctp_test_dev_tx,
+};
+
+static void mctp_test_dev_setup(struct net_device *ndev)
+{
+	ndev->type = ARPHRD_MCTP;
+	ndev->mtu = MCTP_DEV_TEST_MTU;
+	ndev->hard_header_len = 0;
+	ndev->addr_len = 0;
+	ndev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
+	ndev->flags = IFF_NOARP;
+	ndev->netdev_ops = &mctp_test_netdev_ops;
+	ndev->needs_free_netdev = true;
+}
+
+struct mctp_test_dev *mctp_test_create_dev(void)
+{
+	struct mctp_test_dev *dev;
+	struct net_device *ndev;
+	int rc;
+
+	ndev = alloc_netdev(sizeof(*dev), "mctptest%d", NET_NAME_ENUM,
+			    mctp_test_dev_setup);
+	if (!ndev)
+		return NULL;
+
+	dev = netdev_priv(ndev);
+	dev->ndev = ndev;
+
+	rcu_read_lock();
+	dev->mdev = __mctp_dev_get(ndev);
+	mctp_dev_hold(dev->mdev);
+	rcu_read_unlock();
+
+	rc = register_netdev(ndev);
+	if (rc) {
+		free_netdev(ndev);
+		return NULL;
+	}
+
+	return dev;
+}
+
+void mctp_test_destroy_dev(struct mctp_test_dev *dev)
+{
+	mctp_dev_put(dev->mdev);
+	unregister_netdev(dev->ndev);
+}
diff --git a/net/mctp/test/utils.h b/net/mctp/test/utils.h
new file mode 100644
index 000000000000..df6aa1c03440
--- /dev/null
+++ b/net/mctp/test/utils.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __NET_MCTP_TEST_UTILS_H
+#define __NET_MCTP_TEST_UTILS_H
+
+#include <kunit/test.h>
+
+#define MCTP_DEV_TEST_MTU	68
+
+struct mctp_test_dev {
+	struct net_device *ndev;
+	struct mctp_dev *mdev;
+};
+
+struct mctp_test_dev;
+
+struct mctp_test_dev *mctp_test_create_dev(void);
+void mctp_test_destroy_dev(struct mctp_test_dev *dev);
+
+#endif /* __NET_MCTP_TEST_UTILS_H */
-- 
2.33.0

