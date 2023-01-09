Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF3663028
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbjAITPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbjAITPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:36 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BE711C2C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=swB9W0iJUZ5mVohITM5ska0qjuOouZwKiEflwaKLXMk=; b=JvVu6Omfi3JInXdOB33zO4GCLD
        VOELItKbDFJgH1x39Tuo1Un2Ab6dmXskilRLXcbm+x5HK4J33hEJVUBupXj2wb8ktDKx3uYtMR8cV
        mP3/7PQPmHhPMwf6w+P3mGhPldvAQ9M9ZK8b3HttGwrdDy9Ixsb+G7PC1lWqIYeNBpgU=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcL-0007WQ-JD; Mon, 09 Jan 2023 20:15:33 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
Date:   Mon,  9 Jan 2023 20:15:23 +0100
Message-Id: <20230109191523.12070-11-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
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
XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
support.

tsnep_netdev_close() is called directly during BPF program setup. Add
netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
network stack that device is down. Otherwise network stack would
continue transmitting pakets.

Return value of tsnep_netdev_open() is not checked during BPF program
setup like in other drivers. Forwarding the return value would result in
a bpf_prog_put() call in dev_xdp_install(), which would make removal of
BPF program necessary.

If tsnep_netdev_open() fails during BPF program setup, then the network
stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
checks now if device is already down.

Additionally remove $(tsnep-y) from $(tsnep-objs) because it is added
automatically.

Test results with A53 1.2GHz:

XDP_DROP (samples/bpf/xdp1)
proto 17:     883878 pkt/s

XDP_TX (samples/bpf/xdp2)
proto 17:     255693 pkt/s

XDP_REDIRECT (samples/bpf/xdpsock)
 sock0@eth2:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 855,582        5,404,523
tx                 0              0

XDP_REDIRECT (samples/bpf/xdp_redirect)
eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/Makefile     |  2 +-
 drivers/net/ethernet/engleder/tsnep.h      |  6 +++++
 drivers/net/ethernet/engleder/tsnep_main.c | 25 ++++++++++++++++---
 drivers/net/ethernet/engleder/tsnep_xdp.c  | 29 ++++++++++++++++++++++
 4 files changed, 58 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c

diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
index b6e3b16623de..b98135f65eb7 100644
--- a/drivers/net/ethernet/engleder/Makefile
+++ b/drivers/net/ethernet/engleder/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_TSNEP) += tsnep.o
 
 tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
-	      tsnep_rxnfc.o $(tsnep-y)
+	      tsnep_rxnfc.o tsnep_xdp.o
 tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 2268ff793edf..550aae24c8b9 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -197,6 +197,9 @@ struct tsnep_adapter {
 	struct tsnep_queue queue[TSNEP_MAX_QUEUES];
 };
 
+int tsnep_netdev_open(struct net_device *netdev);
+int tsnep_netdev_close(struct net_device *netdev);
+
 extern const struct ethtool_ops tsnep_ethtool_ops;
 
 int tsnep_ptp_init(struct tsnep_adapter *adapter);
@@ -220,6 +223,9 @@ int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
 int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
 			 struct ethtool_rxnfc *cmd);
 
+int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
+			 struct netlink_ext_ack *extack);
+
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
 void tsnep_ethtool_get_test_strings(u8 *data);
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 002c879639db..57c35c74dc08 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1373,7 +1373,7 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
 	memset(queue->name, 0, sizeof(queue->name));
 }
 
-static int tsnep_netdev_open(struct net_device *netdev)
+int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int tx_queue_index = 0;
@@ -1436,6 +1436,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
 	}
 
+	netif_tx_start_all_queues(adapter->netdev);
+
 	clear_bit(__TSNEP_DOWN, &adapter->state);
 
 	return 0;
@@ -1457,12 +1459,16 @@ static int tsnep_netdev_open(struct net_device *netdev)
 	return retval;
 }
 
-static int tsnep_netdev_close(struct net_device *netdev)
+int tsnep_netdev_close(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	set_bit(__TSNEP_DOWN, &adapter->state);
+	if (test_and_set_bit(__TSNEP_DOWN, &adapter->state))
+		return 0;
+
+	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
 
 	tsnep_disable_irq(adapter, ECM_INT_LINK);
 	tsnep_phy_close(adapter);
@@ -1627,6 +1633,18 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
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
@@ -1677,6 +1695,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_bpf = tsnep_netdev_bpf,
 	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
new file mode 100644
index 000000000000..5ced32cd9bb7
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
@@ -0,0 +1,29 @@
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
+	struct bpf_prog *old_prog;
+	bool need_reset, running;
+
+	running = netif_running(dev);
+	need_reset = !!adapter->xdp_prog != !!prog;
+	if (running && need_reset)
+		tsnep_netdev_close(dev);
+
+	old_prog = xchg(&adapter->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (running && need_reset)
+		tsnep_netdev_open(dev);
+
+	return 0;
+}
-- 
2.30.2

