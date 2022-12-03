Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6B64195E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLCWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLCWNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:46 -0500
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E66D2627;
        Sat,  3 Dec 2022 14:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/r+oOVIZQnkaCRHbWI5K8HiijEggRuJnHdYtIsQRsbI=; b=FKq3s0eKWcu/4KKG7AROJihSMU
        xt2s9ZdYLM4hbtrbDn7K5du1jDIRqkVNkePwS0WXbmvmRBIlOZAoZPhn9sJL7GXXFkBUtccsx1o0Z
        oP7tlYS1gMTuqAJaQNlDGLqlHehMAG0sBePQSNwl6LdY3bzjDROd355kY3oOV81+N5VI=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSt-0003Ir-Lj; Sat, 03 Dec 2022 22:54:31 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 3/6] tsnep: Support XDP BPF program setup
Date:   Sat,  3 Dec 2022 22:54:13 +0100
Message-Id: <20221203215416.13465-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203215416.13465-1-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement setup of BPF programs for XDP RX path with command
XDP_SETUP_PROG of ndo_bpf(). This is prework for XDP RX path support.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/Makefile     |  2 +-
 drivers/net/ethernet/engleder/tsnep.h      | 13 +++++++++++
 drivers/net/ethernet/engleder/tsnep_main.c | 17 ++++++++++++--
 drivers/net/ethernet/engleder/tsnep_xdp.c  | 27 ++++++++++++++++++++++
 4 files changed, 56 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
index b6e3b16623de..0901801cfcc9 100644
--- a/drivers/net/ethernet/engleder/Makefile
+++ b/drivers/net/ethernet/engleder/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_TSNEP) += tsnep.o
 
 tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
-	      tsnep_rxnfc.o $(tsnep-y)
+	      tsnep_rxnfc.o tsnep_xdp.o $(tsnep-y)
 tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 29b04127f529..0e7fc36a64e1 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -183,6 +183,8 @@ struct tsnep_adapter {
 	int rxnfc_count;
 	int rxnfc_max;
 
+	struct bpf_prog *xdp_prog;
+
 	int num_tx_queues;
 	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
 	int num_rx_queues;
@@ -192,6 +194,9 @@ struct tsnep_adapter {
 	struct tsnep_queue queue[TSNEP_MAX_QUEUES];
 };
 
+int tsnep_netdev_open(struct net_device *netdev);
+int tsnep_netdev_close(struct net_device *netdev);
+
 extern const struct ethtool_ops tsnep_ethtool_ops;
 
 int tsnep_ptp_init(struct tsnep_adapter *adapter);
@@ -215,6 +220,14 @@ int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
 int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
 			 struct ethtool_rxnfc *cmd);
 
+int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
+			 struct netlink_ext_ack *extack);
+
+static inline bool tsnep_xdp_is_enabled(struct tsnep_adapter *adapter)
+{
+	return !!adapter->xdp_prog;
+}
+
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
 void tsnep_ethtool_get_test_strings(u8 *data);
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 5b52c8005c20..d9ba4a8deec5 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1260,7 +1260,7 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
 	memset(queue->name, 0, sizeof(queue->name));
 }
 
-static int tsnep_netdev_open(struct net_device *netdev)
+int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
@@ -1339,7 +1339,7 @@ static int tsnep_netdev_open(struct net_device *netdev)
 	return retval;
 }
 
-static int tsnep_netdev_close(struct net_device *netdev)
+int tsnep_netdev_close(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
@@ -1508,6 +1508,18 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
 	return ns_to_ktime(timestamp);
 }
 
+static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *bpf)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
 				 struct xdp_frame **xdp, u32 flags)
 {
@@ -1560,6 +1572,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_bpf = tsnep_netdev_bpf,
 	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
new file mode 100644
index 000000000000..02d84dfbdde4
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include <linux/if_vlan.h>
+#include <net/xdp_sock_drv.h>
+
+#include "tsnep.h"
+
+int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
+			 struct netlink_ext_ack *extack)
+{
+	struct net_device *dev = adapter->netdev;
+	bool if_running = netif_running(dev);
+	struct bpf_prog *old_prog;
+
+	if (if_running)
+		tsnep_netdev_close(dev);
+
+	old_prog = xchg(&adapter->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (if_running)
+		tsnep_netdev_open(dev);
+
+	return 0;
+}
-- 
2.30.2

