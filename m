Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAEB66D027
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjAPUZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbjAPUZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:18 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE63298C3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HC8w6za9dqoo4aJQDGJjmQYkOIHlRC2xngTkwTKiyQo=; b=Ugunbf9O3GIl4rK62cHCktdYII
        0lSf/GFc4gZF1/v9AvO5w+gi9VLHN8hjv+5O37Fg5SzHBS1t9GexMWMyzG0M3L0ysQQM6vPrRZYXu
        JAac2+n3zzUUMd0hs6k8csLBEg+rtpV6tawcL0VGtJuRcJ3dSFGesm8TdctoNWx8Ma8g=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2c-00018Q-NR; Mon, 16 Jan 2023 21:25:14 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 9/9] tsnep: Support XDP BPF program setup
Date:   Mon, 16 Jan 2023 21:24:58 +0100
Message-Id: <20230116202458.56677-10-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement setup of BPF programs for XDP RX path with command
XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
support.

There is no need to reinit the RX queues as they are always prepared for
XDP.

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
 drivers/net/ethernet/engleder/tsnep.h      |  3 +++
 drivers/net/ethernet/engleder/tsnep_main.c | 13 +++++++++++++
 drivers/net/ethernet/engleder/tsnep_xdp.c  | 19 +++++++++++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)
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
index 999fa47be4ba..058c2bcf31a7 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -211,6 +211,9 @@ int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
 int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
 			 struct ethtool_rxnfc *cmd);
 
+int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
+			 struct netlink_ext_ack *extack);
+
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
 void tsnep_ethtool_get_test_strings(u8 *data);
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bbf21a6a9e15..5a909c1c11bc 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1614,6 +1614,18 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
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
 static struct tsnep_tx *tsnep_xdp_get_tx(struct tsnep_adapter *adapter, u32 cpu)
 {
 	if (cpu >= TSNEP_MAX_QUEUES)
@@ -1674,6 +1686,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_bpf = tsnep_netdev_bpf,
 	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
new file mode 100644
index 000000000000..4d14cb1fd772
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
@@ -0,0 +1,19 @@
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
+	struct bpf_prog *old_prog;
+
+	old_prog = xchg(&adapter->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	return 0;
+}
-- 
2.30.2

