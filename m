Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0907A7707D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 19:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbfGZRoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 13:44:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbfGZRod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 13:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pQMTuCA1DcUbhLtUu7OOFw8xgQCrDzHXm3VPC9EMAXs=; b=Lj/AYUED1aeejv04mOHfeL9KdX
        70UR4oFLukiukXszV23qat1aP02+qzpBa2EePCur2e7/sPBhxsJrWpJBw9j7kE6ODk/e+NRKUA//w
        LqWM+XpG3tqa87ZWNm5NSDq1P1sjAuiBKSAU1O2f0VPLFZvGnatjpDtFT9ax6nUplVUuu5coH87O/
        RHAaLMlcnPE9qkIYs8oxxzSsAqGRww/1afQnFYZG6bGeg3LNw3gf1YW05LzHxz2OO04TKan/uM269
        FfcL6Vm+qyhVJpRVY+yvn74C2KXeXs/iWgs7lpfZkaX7qgxmrwLdwRAxbQnYoEETQv67+L/cnfDLt
        gh0E708Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hr4GY-0001nH-PF; Fri, 26 Jul 2019 17:44:26 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, aaro.koskinen@iki.fi, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: [PATCH 2/2] staging/octeon: Allow test build on !MIPS
Date:   Fri, 26 Jul 2019 10:44:25 -0700
Message-Id: <20190726174425.6845-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190726174425.6845-1-willy@infradead.org>
References: <20190726174425.6845-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Add compile test support by moving all includes of files under
asm/octeon into octeon-ethernet.h, and if we're not on MIPS,
stub out all the calls into the octeon support code in octeon-stubs.h

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/staging/octeon/Kconfig            |    2 +-
 drivers/staging/octeon/ethernet-defines.h |    2 -
 drivers/staging/octeon/ethernet-mdio.c    |    6 +-
 drivers/staging/octeon/ethernet-mem.c     |    5 +-
 drivers/staging/octeon/ethernet-rgmii.c   |   10 +-
 drivers/staging/octeon/ethernet-rx.c      |   13 +-
 drivers/staging/octeon/ethernet-rx.h      |    2 -
 drivers/staging/octeon/ethernet-sgmii.c   |    8 +-
 drivers/staging/octeon/ethernet-spi.c     |   10 +-
 drivers/staging/octeon/ethernet-tx.c      |   12 +-
 drivers/staging/octeon/ethernet-util.h    |    4 -
 drivers/staging/octeon/ethernet.c         |   12 +-
 drivers/staging/octeon/octeon-ethernet.h  |   29 +-
 drivers/staging/octeon/octeon-stubs.h     | 1429 +++++++++++++++++++++
 14 files changed, 1466 insertions(+), 78 deletions(-)
 create mode 100644 drivers/staging/octeon/octeon-stubs.h

diff --git a/drivers/staging/octeon/Kconfig b/drivers/staging/octeon/Kconfig
index 1e3012b9991c..5b3994649d99 100644
--- a/drivers/staging/octeon/Kconfig
+++ b/drivers/staging/octeon/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config OCTEON_ETHERNET
 	tristate "Cavium Networks Octeon Ethernet support"
-	depends on CAVIUM_OCTEON_SOC && NETDEVICES
+	depends on CAVIUM_OCTEON_SOC && NETDEVICES || COMPILE_TEST
 	select PHYLIB
 	select MDIO_OCTEON
 	help
diff --git a/drivers/staging/octeon/ethernet-defines.h b/drivers/staging/octeon/ethernet-defines.h
index 1e114422993a..ef9e767b0e2e 100644
--- a/drivers/staging/octeon/ethernet-defines.h
+++ b/drivers/staging/octeon/ethernet-defines.h
@@ -21,8 +21,6 @@
 #ifndef __ETHERNET_DEFINES_H__
 #define __ETHERNET_DEFINES_H__
 
-#include <asm/octeon/cvmx-config.h>
-
 #ifdef CONFIG_NETFILTER
 #define REUSE_SKBUFFS_WITHOUT_FREE  0
 #else
diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
index 2aee64fdaec5..ffac0c4b3f5c 100644
--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -13,15 +13,11 @@
 #include <generated/utsrelease.h>
 #include <net/dst.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-mdio.h"
 #include "ethernet-util.h"
 
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 static void cvm_oct_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
diff --git a/drivers/staging/octeon/ethernet-mem.c b/drivers/staging/octeon/ethernet-mem.c
index 0d26c4a93ec1..532594957ebc 100644
--- a/drivers/staging/octeon/ethernet-mem.c
+++ b/drivers/staging/octeon/ethernet-mem.c
@@ -9,13 +9,10 @@
 #include <linux/netdevice.h>
 #include <linux/slab.h>
 
-#include <asm/octeon/octeon.h>
-
+#include "octeon-ethernet.h"
 #include "ethernet-mem.h"
 #include "ethernet-defines.h"
 
-#include <asm/octeon/cvmx-fpa.h>
-
 /**
  * cvm_oct_fill_hw_skbuff - fill the supplied hardware pool with skbuffs
  * @pool:     Pool to allocate an skbuff for
diff --git a/drivers/staging/octeon/ethernet-rgmii.c b/drivers/staging/octeon/ethernet-rgmii.c
index c15376d33891..d91fd5ce9e68 100644
--- a/drivers/staging/octeon/ethernet-rgmii.c
+++ b/drivers/staging/octeon/ethernet-rgmii.c
@@ -12,19 +12,11 @@
 #include <linux/ratelimit.h>
 #include <net/dst.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-util.h"
 #include "ethernet-mdio.h"
 
-#include <asm/octeon/cvmx-helper.h>
-
-#include <asm/octeon/cvmx-ipd-defs.h>
-#include <asm/octeon/cvmx-npi-defs.h>
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 static DEFINE_SPINLOCK(global_register_lock);
 
 static void cvm_oct_set_hw_preamble(struct octeon_ethernet *priv, bool enable)
diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 5e271245273c..0e65955c746b 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -23,23 +23,12 @@
 #include <net/xfrm.h>
 #endif /* CONFIG_XFRM */
 
-#include <asm/octeon/octeon.h>
-
+#include "octeon-ethernet.h"
 #include "ethernet-defines.h"
 #include "ethernet-mem.h"
 #include "ethernet-rx.h"
-#include "octeon-ethernet.h"
 #include "ethernet-util.h"
 
-#include <asm/octeon/cvmx-helper.h>
-#include <asm/octeon/cvmx-wqe.h>
-#include <asm/octeon/cvmx-fau.h>
-#include <asm/octeon/cvmx-pow.h>
-#include <asm/octeon/cvmx-pip.h>
-#include <asm/octeon/cvmx-scratch.h>
-
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 static atomic_t oct_rx_ready = ATOMIC_INIT(0);
 
 static struct oct_rx_group {
diff --git a/drivers/staging/octeon/ethernet-rx.h b/drivers/staging/octeon/ethernet-rx.h
index 096553d8fc99..ff6482fa20d6 100644
--- a/drivers/staging/octeon/ethernet-rx.h
+++ b/drivers/staging/octeon/ethernet-rx.h
@@ -5,8 +5,6 @@
  * Copyright (c) 2003-2007 Cavium Networks
  */
 
-#include <asm/octeon/cvmx-fau.h>
-
 void cvm_oct_poll_controller(struct net_device *dev);
 void cvm_oct_rx_initialize(void);
 void cvm_oct_rx_shutdown(void);
diff --git a/drivers/staging/octeon/ethernet-sgmii.c b/drivers/staging/octeon/ethernet-sgmii.c
index a4a8f094e2b4..d7fbd9159302 100644
--- a/drivers/staging/octeon/ethernet-sgmii.c
+++ b/drivers/staging/octeon/ethernet-sgmii.c
@@ -11,17 +11,11 @@
 #include <linux/ratelimit.h>
 #include <net/dst.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-util.h"
 #include "ethernet-mdio.h"
 
-#include <asm/octeon/cvmx-helper.h>
-
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 int cvm_oct_sgmii_open(struct net_device *dev)
 {
 	return cvm_oct_common_open(dev, cvm_oct_link_poll);
diff --git a/drivers/staging/octeon/ethernet-spi.c b/drivers/staging/octeon/ethernet-spi.c
index 01efdf2a2c20..c582403e6a1f 100644
--- a/drivers/staging/octeon/ethernet-spi.c
+++ b/drivers/staging/octeon/ethernet-spi.c
@@ -10,18 +10,10 @@
 #include <linux/interrupt.h>
 #include <net/dst.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-util.h"
 
-#include <asm/octeon/cvmx-spi.h>
-
-#include <asm/octeon/cvmx-npi-defs.h>
-#include <asm/octeon/cvmx-spxx-defs.h>
-#include <asm/octeon/cvmx-stxx-defs.h>
-
 static int number_spi_ports;
 static int need_retrain[2] = { 0, 0 };
 
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 44f79cd32750..c64728fc21f2 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -22,21 +22,11 @@
 #include <linux/atomic.h>
 #include <net/sch_generic.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-tx.h"
 #include "ethernet-util.h"
 
-#include <asm/octeon/cvmx-wqe.h>
-#include <asm/octeon/cvmx-fau.h>
-#include <asm/octeon/cvmx-pip.h>
-#include <asm/octeon/cvmx-pko.h>
-#include <asm/octeon/cvmx-helper.h>
-
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 #define CVM_OCT_SKB_CB(skb)	((u64 *)((skb)->cb))
 
 /*
diff --git a/drivers/staging/octeon/ethernet-util.h b/drivers/staging/octeon/ethernet-util.h
index 31a82873e15c..2af83a12ca78 100644
--- a/drivers/staging/octeon/ethernet-util.h
+++ b/drivers/staging/octeon/ethernet-util.h
@@ -5,10 +5,6 @@
  * Copyright (c) 2003-2007 Cavium Networks
  */
 
-#include <asm/octeon/cvmx-pip.h>
-#include <asm/octeon/cvmx-helper.h>
-#include <asm/octeon/cvmx-helper-util.h>
-
 /**
  * cvm_oct_get_buffer_ptr - convert packet data address to pointer
  * @packet_ptr: Packet data hardware address
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 8847a11c212f..8889494adf1f 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -19,24 +19,14 @@
 
 #include <net/dst.h>
 
-#include <asm/octeon/octeon.h>
-
-#include "ethernet-defines.h"
 #include "octeon-ethernet.h"
+#include "ethernet-defines.h"
 #include "ethernet-mem.h"
 #include "ethernet-rx.h"
 #include "ethernet-tx.h"
 #include "ethernet-mdio.h"
 #include "ethernet-util.h"
 
-#include <asm/octeon/cvmx-pip.h>
-#include <asm/octeon/cvmx-pko.h>
-#include <asm/octeon/cvmx-fau.h>
-#include <asm/octeon/cvmx-ipd.h>
-#include <asm/octeon/cvmx-helper.h>
-#include <asm/octeon/cvmx-asxx-defs.h>
-#include <asm/octeon/cvmx-gmxx-defs.h>
-
 #define OCTEON_MAX_MTU 65392
 
 static int num_packet_buffers = 1024;
diff --git a/drivers/staging/octeon/octeon-ethernet.h b/drivers/staging/octeon/octeon-ethernet.h
index be570d33685a..a8a864b40913 100644
--- a/drivers/staging/octeon/octeon-ethernet.h
+++ b/drivers/staging/octeon/octeon-ethernet.h
@@ -13,7 +13,34 @@
 
 #include <linux/of.h>
 #include <linux/phy.h>
-#include <asm/octeon/cvmx-helper-board.h>
+
+#ifdef CONFIG_MIPS
+
+#include <asm/octeon/octeon.h>
+
+#include <asm/octeon/cvmx-asxx-defs.h>
+#include <asm/octeon/cvmx-config.h>
+#include <asm/octeon/cvmx-fau.h>
+#include <asm/octeon/cvmx-gmxx-defs.h>
+#include <asm/octeon/cvmx-helper.h>
+#include <asm/octeon/cvmx-helper-util.h>
+#include <asm/octeon/cvmx-ipd.h>
+#include <asm/octeon/cvmx-ipd-defs.h>
+#include <asm/octeon/cvmx-npi-defs.h>
+#include <asm/octeon/cvmx-pip.h>
+#include <asm/octeon/cvmx-pko.h>
+#include <asm/octeon/cvmx-pow.h>
+#include <asm/octeon/cvmx-scratch.h>
+#include <asm/octeon/cvmx-spi.h>
+#include <asm/octeon/cvmx-spxx-defs.h>
+#include <asm/octeon/cvmx-stxx-defs.h>
+#include <asm/octeon/cvmx-wqe.h>
+
+#else
+
+#include "octeon-stubs.h"
+
+#endif
 
 /**
  * This is the definition of the Ethernet driver's private
diff --git a/drivers/staging/octeon/octeon-stubs.h b/drivers/staging/octeon/octeon-stubs.h
new file mode 100644
index 000000000000..a4ac3bfb62a8
--- /dev/null
+++ b/drivers/staging/octeon/octeon-stubs.h
@@ -0,0 +1,1429 @@
+#define CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE	512
+#define XKPHYS_TO_PHYS(p)			(p)
+
+#define OCTEON_IRQ_WORKQ0 0
+#define OCTEON_IRQ_RML 0
+#define OCTEON_IRQ_TIMER1 0
+#define OCTEON_IS_MODEL(x) 0
+#define octeon_has_feature(x)	0
+#define octeon_get_clock_rate()	0
+
+#define CVMX_SYNCIOBDMA		do { } while(0)
+
+#define CVMX_HELPER_INPUT_TAG_TYPE	0
+#define CVMX_HELPER_FIRST_MBUFF_SKIP	7
+#define CVMX_FAU_REG_END		(2048)
+#define CVMX_FPA_OUTPUT_BUFFER_POOL	    (2)
+#define CVMX_FPA_OUTPUT_BUFFER_POOL_SIZE    16
+#define CVMX_FPA_PACKET_POOL		    (0)
+#define CVMX_FPA_PACKET_POOL_SIZE	    16
+#define CVMX_FPA_WQE_POOL		    (1)
+#define CVMX_FPA_WQE_POOL_SIZE		    16
+#define CVMX_GMXX_RXX_ADR_CAM_EN(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CTL(a, b)	((a)+(b))
+#define CVMX_GMXX_PRTX_CFG(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_FRM_MAX(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_JABBER(a, b)	((a)+(b))
+#define CVMX_IPD_CTL_STATUS		0
+#define CVMX_PIP_FRM_LEN_CHKX(a)	(a)
+#define CVMX_PIP_NUM_INPUT_PORTS	1
+#define CVMX_SCR_SCRATCH		0
+#define CVMX_PKO_QUEUES_PER_PORT_INTERFACE0	2
+#define CVMX_PKO_QUEUES_PER_PORT_INTERFACE1	2
+#define CVMX_IPD_SUB_PORT_FCS		0
+#define CVMX_SSO_WQ_IQ_DIS		0
+#define CVMX_SSO_WQ_INT			0
+#define CVMX_POW_WQ_INT			0
+#define CVMX_SSO_WQ_INT_PC		0
+#define CVMX_NPI_RSL_INT_BLOCKS		0
+#define CVMX_POW_WQ_INT_PC		0
+
+typedef union {
+	uint64_t u64;
+	struct {
+		uint64_t bufs:8;
+		uint64_t ip_offset:8;
+		uint64_t vlan_valid:1;
+		uint64_t vlan_stacked:1;
+		uint64_t unassigned:1;
+		uint64_t vlan_cfi:1;
+		uint64_t vlan_id:12;
+		uint64_t pr:4;
+		uint64_t unassigned2:8;
+		uint64_t dec_ipcomp:1;
+		uint64_t tcp_or_udp:1;
+		uint64_t dec_ipsec:1;
+		uint64_t is_v6:1;
+		uint64_t software:1;
+		uint64_t L4_error:1;
+		uint64_t is_frag:1;
+		uint64_t IP_exc:1;
+		uint64_t is_bcast:1;
+		uint64_t is_mcast:1;
+		uint64_t not_IP:1;
+		uint64_t rcv_error:1;
+		uint64_t err_code:8;
+	} s;
+	struct {
+		uint64_t bufs:8;
+		uint64_t ip_offset:8;
+		uint64_t vlan_valid:1;
+		uint64_t vlan_stacked:1;
+		uint64_t unassigned:1;
+		uint64_t vlan_cfi:1;
+		uint64_t vlan_id:12;
+		uint64_t port:12;
+		uint64_t dec_ipcomp:1;
+		uint64_t tcp_or_udp:1;
+		uint64_t dec_ipsec:1;
+		uint64_t is_v6:1;
+		uint64_t software:1;
+		uint64_t L4_error:1;
+		uint64_t is_frag:1;
+		uint64_t IP_exc:1;
+		uint64_t is_bcast:1;
+		uint64_t is_mcast:1;
+		uint64_t not_IP:1;
+		uint64_t rcv_error:1;
+		uint64_t err_code:8;
+	} s_cn68xx;
+
+	struct {
+		uint64_t unused1:16;
+		uint64_t vlan:16;
+		uint64_t unused2:32;
+	} svlan;
+	struct {
+		uint64_t bufs:8;
+		uint64_t unused:8;
+		uint64_t vlan_valid:1;
+		uint64_t vlan_stacked:1;
+		uint64_t unassigned:1;
+		uint64_t vlan_cfi:1;
+		uint64_t vlan_id:12;
+		uint64_t pr:4;
+		uint64_t unassigned2:12;
+		uint64_t software:1;
+		uint64_t unassigned3:1;
+		uint64_t is_rarp:1;
+		uint64_t is_arp:1;
+		uint64_t is_bcast:1;
+		uint64_t is_mcast:1;
+		uint64_t not_IP:1;
+		uint64_t rcv_error:1;
+		uint64_t err_code:8;
+	} snoip;
+
+} cvmx_pip_wqe_word2;
+
+union cvmx_pip_wqe_word0 {
+	struct {
+		uint64_t next_ptr:40;
+		uint8_t unused;
+		uint16_t hw_chksum;
+	} cn38xx;
+	struct {
+		uint64_t pknd:6;        /* 0..5 */
+		uint64_t unused2:2;     /* 6..7 */
+		uint64_t bpid:6;        /* 8..13 */
+		uint64_t unused1:18;    /* 14..31 */
+		uint64_t l2ptr:8;       /* 32..39 */
+		uint64_t l3ptr:8;       /* 40..47 */
+		uint64_t unused0:8;     /* 48..55 */
+		uint64_t l4ptr:8;       /* 56..63 */
+	} cn68xx;
+};
+
+union cvmx_wqe_word0 {
+	uint64_t u64;
+	union cvmx_pip_wqe_word0 pip;
+};
+
+union cvmx_wqe_word1 {
+	uint64_t u64;
+	struct {
+		uint64_t tag:32;
+		uint64_t tag_type:2;
+		uint64_t varies:14;
+		uint64_t len:16;
+	};
+	struct {
+		uint64_t tag:32;
+		uint64_t tag_type:2;
+		uint64_t zero_2:3;
+		uint64_t grp:6;
+		uint64_t zero_1:1;
+		uint64_t qos:3;
+		uint64_t zero_0:1;
+		uint64_t len:16;
+	} cn68xx;
+	struct {
+		uint64_t tag:32;
+		uint64_t tag_type:2;
+		uint64_t zero_2:1;
+		uint64_t grp:4;
+		uint64_t qos:3;
+		uint64_t ipprt:6;
+		uint64_t len:16;
+	} cn38xx;
+};
+
+union cvmx_buf_ptr {
+	void *ptr;
+	uint64_t u64;
+	struct {
+		uint64_t i:1;
+		uint64_t back:4;
+		uint64_t pool:3;
+		uint64_t size:16;
+		uint64_t addr:40;
+	} s;
+};
+
+typedef struct {
+	union cvmx_wqe_word0 word0;
+	union cvmx_wqe_word1 word1;
+	cvmx_pip_wqe_word2 word2;
+	union cvmx_buf_ptr packet_ptr;
+	uint8_t packet_data[96];
+} cvmx_wqe_t;
+
+typedef union {
+	uint64_t u64;
+	struct {
+		uint64_t reserved_20_63:44;
+		uint64_t link_up:1;	    /**< Is the physical link up? */
+		uint64_t full_duplex:1;	    /**< 1 if the link is full duplex */
+		uint64_t speed:18;	    /**< Speed of the link in Mbps */
+	} s;
+} cvmx_helper_link_info_t;
+
+typedef enum {
+	CVMX_FAU_REG_32_START	= 0,
+} cvmx_fau_reg_32_t;
+
+typedef enum {
+	CVMX_FAU_OP_SIZE_8 = 0,
+	CVMX_FAU_OP_SIZE_16 = 1,
+	CVMX_FAU_OP_SIZE_32 = 2,
+	CVMX_FAU_OP_SIZE_64 = 3
+} cvmx_fau_op_size_t;
+
+typedef enum {
+	CVMX_SPI_MODE_UNKNOWN = 0,
+	CVMX_SPI_MODE_TX_HALFPLEX = 1,
+	CVMX_SPI_MODE_RX_HALFPLEX = 2,
+	CVMX_SPI_MODE_DUPLEX = 3
+} cvmx_spi_mode_t;
+
+typedef enum {
+	CVMX_HELPER_INTERFACE_MODE_DISABLED,
+	CVMX_HELPER_INTERFACE_MODE_RGMII,
+	CVMX_HELPER_INTERFACE_MODE_GMII,
+	CVMX_HELPER_INTERFACE_MODE_SPI,
+	CVMX_HELPER_INTERFACE_MODE_PCIE,
+	CVMX_HELPER_INTERFACE_MODE_XAUI,
+	CVMX_HELPER_INTERFACE_MODE_SGMII,
+	CVMX_HELPER_INTERFACE_MODE_PICMG,
+	CVMX_HELPER_INTERFACE_MODE_NPI,
+	CVMX_HELPER_INTERFACE_MODE_LOOP,
+} cvmx_helper_interface_mode_t;
+
+typedef enum {
+	CVMX_POW_WAIT = 1,
+	CVMX_POW_NO_WAIT = 0,
+} cvmx_pow_wait_t;
+
+typedef enum {
+	CVMX_PKO_LOCK_NONE = 0,
+	CVMX_PKO_LOCK_ATOMIC_TAG = 1,
+	CVMX_PKO_LOCK_CMD_QUEUE = 2,
+} cvmx_pko_lock_t;
+
+typedef enum {
+	CVMX_PKO_SUCCESS,
+	CVMX_PKO_INVALID_PORT,
+	CVMX_PKO_INVALID_QUEUE,
+	CVMX_PKO_INVALID_PRIORITY,
+	CVMX_PKO_NO_MEMORY,
+	CVMX_PKO_PORT_ALREADY_SETUP,
+	CVMX_PKO_CMD_QUEUE_INIT_ERROR
+} cvmx_pko_status_t;
+
+enum cvmx_pow_tag_type {
+	CVMX_POW_TAG_TYPE_ORDERED   = 0L,
+	CVMX_POW_TAG_TYPE_ATOMIC    = 1L,
+	CVMX_POW_TAG_TYPE_NULL	    = 2L,
+	CVMX_POW_TAG_TYPE_NULL_NULL = 3L
+};
+
+union cvmx_ipd_ctl_status {
+	uint64_t u64;
+	struct cvmx_ipd_ctl_status_s {
+		uint64_t reserved_18_63:46;
+		uint64_t use_sop:1;
+		uint64_t rst_done:1;
+		uint64_t clken:1;
+		uint64_t no_wptr:1;
+		uint64_t pq_apkt:1;
+		uint64_t pq_nabuf:1;
+		uint64_t ipd_full:1;
+		uint64_t pkt_off:1;
+		uint64_t len_m8:1;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} s;
+	struct cvmx_ipd_ctl_status_cn30xx {
+		uint64_t reserved_10_63:54;
+		uint64_t len_m8:1;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} cn30xx;
+	struct cvmx_ipd_ctl_status_cn38xxp2 {
+		uint64_t reserved_9_63:55;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} cn38xxp2;
+	struct cvmx_ipd_ctl_status_cn50xx {
+		uint64_t reserved_15_63:49;
+		uint64_t no_wptr:1;
+		uint64_t pq_apkt:1;
+		uint64_t pq_nabuf:1;
+		uint64_t ipd_full:1;
+		uint64_t pkt_off:1;
+		uint64_t len_m8:1;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} cn50xx;
+	struct cvmx_ipd_ctl_status_cn58xx {
+		uint64_t reserved_12_63:52;
+		uint64_t ipd_full:1;
+		uint64_t pkt_off:1;
+		uint64_t len_m8:1;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} cn58xx;
+	struct cvmx_ipd_ctl_status_cn63xxp1 {
+		uint64_t reserved_16_63:48;
+		uint64_t clken:1;
+		uint64_t no_wptr:1;
+		uint64_t pq_apkt:1;
+		uint64_t pq_nabuf:1;
+		uint64_t ipd_full:1;
+		uint64_t pkt_off:1;
+		uint64_t len_m8:1;
+		uint64_t reset:1;
+		uint64_t addpkt:1;
+		uint64_t naddbuf:1;
+		uint64_t pkt_lend:1;
+		uint64_t wqe_lend:1;
+		uint64_t pbp_en:1;
+		uint64_t opc_mode:2;
+		uint64_t ipd_en:1;
+	} cn63xxp1;
+};
+
+union cvmx_ipd_sub_port_fcs {
+	uint64_t u64;
+	struct cvmx_ipd_sub_port_fcs_s {
+		uint64_t port_bit:32;
+		uint64_t reserved_32_35:4;
+		uint64_t port_bit2:4;
+		uint64_t reserved_40_63:24;
+	} s;
+	struct cvmx_ipd_sub_port_fcs_cn30xx {
+		uint64_t port_bit:3;
+		uint64_t reserved_3_63:61;
+	} cn30xx;
+	struct cvmx_ipd_sub_port_fcs_cn38xx {
+		uint64_t port_bit:32;
+		uint64_t reserved_32_63:32;
+	} cn38xx;
+};
+
+union cvmx_ipd_sub_port_qos_cnt {
+	uint64_t u64;
+	struct cvmx_ipd_sub_port_qos_cnt_s {
+		uint64_t cnt:32;
+		uint64_t port_qos:9;
+		uint64_t reserved_41_63:23;
+	} s;
+};
+typedef struct {
+	uint32_t dropped_octets;
+	uint32_t dropped_packets;
+	uint32_t pci_raw_packets;
+	uint32_t octets;
+	uint32_t packets;
+	uint32_t multicast_packets;
+	uint32_t broadcast_packets;
+	uint32_t len_64_packets;
+	uint32_t len_65_127_packets;
+	uint32_t len_128_255_packets;
+	uint32_t len_256_511_packets;
+	uint32_t len_512_1023_packets;
+	uint32_t len_1024_1518_packets;
+	uint32_t len_1519_max_packets;
+	uint32_t fcs_align_err_packets;
+	uint32_t runt_packets;
+	uint32_t runt_crc_packets;
+	uint32_t oversize_packets;
+	uint32_t oversize_crc_packets;
+	uint32_t inb_packets;
+	uint64_t inb_octets;
+	uint16_t inb_errors;
+} cvmx_pip_port_status_t;
+
+typedef struct {
+	uint32_t packets;
+	uint64_t octets;
+	uint64_t doorbell;
+} cvmx_pko_port_status_t;
+
+union cvmx_pip_frm_len_chkx {
+	uint64_t u64;
+	struct cvmx_pip_frm_len_chkx_s {
+		uint64_t reserved_32_63:32;
+		uint64_t maxlen:16;
+		uint64_t minlen:16;
+	} s;
+};
+
+union cvmx_gmxx_rxx_frm_ctl {
+	uint64_t u64;
+	struct cvmx_gmxx_rxx_frm_ctl_s {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t vlan_len:1;
+		uint64_t pad_len:1;
+		uint64_t pre_align:1;
+		uint64_t null_dis:1;
+		uint64_t reserved_11_11:1;
+		uint64_t ptp_mode:1;
+		uint64_t reserved_13_63:51;
+	} s;
+	struct cvmx_gmxx_rxx_frm_ctl_cn30xx {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t vlan_len:1;
+		uint64_t pad_len:1;
+		uint64_t reserved_9_63:55;
+	} cn30xx;
+	struct cvmx_gmxx_rxx_frm_ctl_cn31xx {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t vlan_len:1;
+		uint64_t reserved_8_63:56;
+	} cn31xx;
+	struct cvmx_gmxx_rxx_frm_ctl_cn50xx {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t reserved_7_8:2;
+		uint64_t pre_align:1;
+		uint64_t null_dis:1;
+		uint64_t reserved_11_63:53;
+	} cn50xx;
+	struct cvmx_gmxx_rxx_frm_ctl_cn56xxp1 {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t reserved_7_8:2;
+		uint64_t pre_align:1;
+		uint64_t reserved_10_63:54;
+	} cn56xxp1;
+	struct cvmx_gmxx_rxx_frm_ctl_cn58xx {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t vlan_len:1;
+		uint64_t pad_len:1;
+		uint64_t pre_align:1;
+		uint64_t null_dis:1;
+		uint64_t reserved_11_63:53;
+	} cn58xx;
+	struct cvmx_gmxx_rxx_frm_ctl_cn61xx {
+		uint64_t pre_chk:1;
+		uint64_t pre_strp:1;
+		uint64_t ctl_drp:1;
+		uint64_t ctl_bck:1;
+		uint64_t ctl_mcst:1;
+		uint64_t ctl_smac:1;
+		uint64_t pre_free:1;
+		uint64_t reserved_7_8:2;
+		uint64_t pre_align:1;
+		uint64_t null_dis:1;
+		uint64_t reserved_11_11:1;
+		uint64_t ptp_mode:1;
+		uint64_t reserved_13_63:51;
+	} cn61xx;
+};
+
+union cvmx_gmxx_rxx_int_reg {
+	uint64_t u64;
+	struct cvmx_gmxx_rxx_int_reg_s {
+		uint64_t minerr:1;
+		uint64_t carext:1;
+		uint64_t maxerr:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t alnerr:1;
+		uint64_t lenerr:1;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t niberr:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t phy_link:1;
+		uint64_t phy_spd:1;
+		uint64_t phy_dupx:1;
+		uint64_t pause_drp:1;
+		uint64_t loc_fault:1;
+		uint64_t rem_fault:1;
+		uint64_t bad_seq:1;
+		uint64_t bad_term:1;
+		uint64_t unsop:1;
+		uint64_t uneop:1;
+		uint64_t undat:1;
+		uint64_t hg2fld:1;
+		uint64_t hg2cc:1;
+		uint64_t reserved_29_63:35;
+	} s;
+	struct cvmx_gmxx_rxx_int_reg_cn30xx {
+		uint64_t minerr:1;
+		uint64_t carext:1;
+		uint64_t maxerr:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t alnerr:1;
+		uint64_t lenerr:1;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t niberr:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t phy_link:1;
+		uint64_t phy_spd:1;
+		uint64_t phy_dupx:1;
+		uint64_t reserved_19_63:45;
+	} cn30xx;
+	struct cvmx_gmxx_rxx_int_reg_cn50xx {
+		uint64_t reserved_0_0:1;
+		uint64_t carext:1;
+		uint64_t reserved_2_2:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t alnerr:1;
+		uint64_t reserved_6_6:1;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t niberr:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t phy_link:1;
+		uint64_t phy_spd:1;
+		uint64_t phy_dupx:1;
+		uint64_t pause_drp:1;
+		uint64_t reserved_20_63:44;
+	} cn50xx;
+	struct cvmx_gmxx_rxx_int_reg_cn52xx {
+		uint64_t reserved_0_0:1;
+		uint64_t carext:1;
+		uint64_t reserved_2_2:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t reserved_5_6:2;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t reserved_9_9:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t reserved_16_18:3;
+		uint64_t pause_drp:1;
+		uint64_t loc_fault:1;
+		uint64_t rem_fault:1;
+		uint64_t bad_seq:1;
+		uint64_t bad_term:1;
+		uint64_t unsop:1;
+		uint64_t uneop:1;
+		uint64_t undat:1;
+		uint64_t hg2fld:1;
+		uint64_t hg2cc:1;
+		uint64_t reserved_29_63:35;
+	} cn52xx;
+	struct cvmx_gmxx_rxx_int_reg_cn56xxp1 {
+		uint64_t reserved_0_0:1;
+		uint64_t carext:1;
+		uint64_t reserved_2_2:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t reserved_5_6:2;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t reserved_9_9:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t reserved_16_18:3;
+		uint64_t pause_drp:1;
+		uint64_t loc_fault:1;
+		uint64_t rem_fault:1;
+		uint64_t bad_seq:1;
+		uint64_t bad_term:1;
+		uint64_t unsop:1;
+		uint64_t uneop:1;
+		uint64_t undat:1;
+		uint64_t reserved_27_63:37;
+	} cn56xxp1;
+	struct cvmx_gmxx_rxx_int_reg_cn58xx {
+		uint64_t minerr:1;
+		uint64_t carext:1;
+		uint64_t maxerr:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t alnerr:1;
+		uint64_t lenerr:1;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t niberr:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t phy_link:1;
+		uint64_t phy_spd:1;
+		uint64_t phy_dupx:1;
+		uint64_t pause_drp:1;
+		uint64_t reserved_20_63:44;
+	} cn58xx;
+	struct cvmx_gmxx_rxx_int_reg_cn61xx {
+		uint64_t minerr:1;
+		uint64_t carext:1;
+		uint64_t reserved_2_2:1;
+		uint64_t jabber:1;
+		uint64_t fcserr:1;
+		uint64_t reserved_5_6:2;
+		uint64_t rcverr:1;
+		uint64_t skperr:1;
+		uint64_t reserved_9_9:1;
+		uint64_t ovrerr:1;
+		uint64_t pcterr:1;
+		uint64_t rsverr:1;
+		uint64_t falerr:1;
+		uint64_t coldet:1;
+		uint64_t ifgerr:1;
+		uint64_t reserved_16_18:3;
+		uint64_t pause_drp:1;
+		uint64_t loc_fault:1;
+		uint64_t rem_fault:1;
+		uint64_t bad_seq:1;
+		uint64_t bad_term:1;
+		uint64_t unsop:1;
+		uint64_t uneop:1;
+		uint64_t undat:1;
+		uint64_t hg2fld:1;
+		uint64_t hg2cc:1;
+		uint64_t reserved_29_63:35;
+	} cn61xx;
+};
+
+union cvmx_gmxx_prtx_cfg {
+	uint64_t u64;
+	struct cvmx_gmxx_prtx_cfg_s {
+		uint64_t reserved_22_63:42;
+		uint64_t pknd:6;
+		uint64_t reserved_14_15:2;
+		uint64_t tx_idle:1;
+		uint64_t rx_idle:1;
+		uint64_t reserved_9_11:3;
+		uint64_t speed_msb:1;
+		uint64_t reserved_4_7:4;
+		uint64_t slottime:1;
+		uint64_t duplex:1;
+		uint64_t speed:1;
+		uint64_t en:1;
+	} s;
+	struct cvmx_gmxx_prtx_cfg_cn30xx {
+		uint64_t reserved_4_63:60;
+		uint64_t slottime:1;
+		uint64_t duplex:1;
+		uint64_t speed:1;
+		uint64_t en:1;
+	} cn30xx;
+	struct cvmx_gmxx_prtx_cfg_cn52xx {
+		uint64_t reserved_14_63:50;
+		uint64_t tx_idle:1;
+		uint64_t rx_idle:1;
+		uint64_t reserved_9_11:3;
+		uint64_t speed_msb:1;
+		uint64_t reserved_4_7:4;
+		uint64_t slottime:1;
+		uint64_t duplex:1;
+		uint64_t speed:1;
+		uint64_t en:1;
+	} cn52xx;
+};
+
+union cvmx_gmxx_rxx_adr_ctl {
+	uint64_t u64;
+	struct cvmx_gmxx_rxx_adr_ctl_s {
+		uint64_t reserved_4_63:60;
+		uint64_t cam_mode:1;
+		uint64_t mcst:2;
+		uint64_t bcst:1;
+	} s;
+};
+
+union cvmx_pip_prt_tagx {
+	uint64_t u64;
+	struct cvmx_pip_prt_tagx_s {
+		uint64_t reserved_54_63:10;
+		uint64_t portadd_en:1;
+		uint64_t inc_hwchk:1;
+		uint64_t reserved_50_51:2;
+		uint64_t grptagbase_msb:2;
+		uint64_t reserved_46_47:2;
+		uint64_t grptagmask_msb:2;
+		uint64_t reserved_42_43:2;
+		uint64_t grp_msb:2;
+		uint64_t grptagbase:4;
+		uint64_t grptagmask:4;
+		uint64_t grptag:1;
+		uint64_t grptag_mskip:1;
+		uint64_t tag_mode:2;
+		uint64_t inc_vs:2;
+		uint64_t inc_vlan:1;
+		uint64_t inc_prt_flag:1;
+		uint64_t ip6_dprt_flag:1;
+		uint64_t ip4_dprt_flag:1;
+		uint64_t ip6_sprt_flag:1;
+		uint64_t ip4_sprt_flag:1;
+		uint64_t ip6_nxth_flag:1;
+		uint64_t ip4_pctl_flag:1;
+		uint64_t ip6_dst_flag:1;
+		uint64_t ip4_dst_flag:1;
+		uint64_t ip6_src_flag:1;
+		uint64_t ip4_src_flag:1;
+		uint64_t tcp6_tag_type:2;
+		uint64_t tcp4_tag_type:2;
+		uint64_t ip6_tag_type:2;
+		uint64_t ip4_tag_type:2;
+		uint64_t non_tag_type:2;
+		uint64_t grp:4;
+	} s;
+	struct cvmx_pip_prt_tagx_cn30xx {
+		uint64_t reserved_40_63:24;
+		uint64_t grptagbase:4;
+		uint64_t grptagmask:4;
+		uint64_t grptag:1;
+		uint64_t reserved_30_30:1;
+		uint64_t tag_mode:2;
+		uint64_t inc_vs:2;
+		uint64_t inc_vlan:1;
+		uint64_t inc_prt_flag:1;
+		uint64_t ip6_dprt_flag:1;
+		uint64_t ip4_dprt_flag:1;
+		uint64_t ip6_sprt_flag:1;
+		uint64_t ip4_sprt_flag:1;
+		uint64_t ip6_nxth_flag:1;
+		uint64_t ip4_pctl_flag:1;
+		uint64_t ip6_dst_flag:1;
+		uint64_t ip4_dst_flag:1;
+		uint64_t ip6_src_flag:1;
+		uint64_t ip4_src_flag:1;
+		uint64_t tcp6_tag_type:2;
+		uint64_t tcp4_tag_type:2;
+		uint64_t ip6_tag_type:2;
+		uint64_t ip4_tag_type:2;
+		uint64_t non_tag_type:2;
+		uint64_t grp:4;
+	} cn30xx;
+	struct cvmx_pip_prt_tagx_cn50xx {
+		uint64_t reserved_40_63:24;
+		uint64_t grptagbase:4;
+		uint64_t grptagmask:4;
+		uint64_t grptag:1;
+		uint64_t grptag_mskip:1;
+		uint64_t tag_mode:2;
+		uint64_t inc_vs:2;
+		uint64_t inc_vlan:1;
+		uint64_t inc_prt_flag:1;
+		uint64_t ip6_dprt_flag:1;
+		uint64_t ip4_dprt_flag:1;
+		uint64_t ip6_sprt_flag:1;
+		uint64_t ip4_sprt_flag:1;
+		uint64_t ip6_nxth_flag:1;
+		uint64_t ip4_pctl_flag:1;
+		uint64_t ip6_dst_flag:1;
+		uint64_t ip4_dst_flag:1;
+		uint64_t ip6_src_flag:1;
+		uint64_t ip4_src_flag:1;
+		uint64_t tcp6_tag_type:2;
+		uint64_t tcp4_tag_type:2;
+		uint64_t ip6_tag_type:2;
+		uint64_t ip4_tag_type:2;
+		uint64_t non_tag_type:2;
+		uint64_t grp:4;
+	} cn50xx;
+};
+
+union cvmx_spxx_int_reg {
+	uint64_t u64;
+	struct cvmx_spxx_int_reg_s {
+		uint64_t reserved_32_63:32;
+		uint64_t spf:1;
+		uint64_t reserved_12_30:19;
+		uint64_t calerr:1;
+		uint64_t syncerr:1;
+		uint64_t diperr:1;
+		uint64_t tpaovr:1;
+		uint64_t rsverr:1;
+		uint64_t drwnng:1;
+		uint64_t clserr:1;
+		uint64_t spiovr:1;
+		uint64_t reserved_2_3:2;
+		uint64_t abnorm:1;
+		uint64_t prtnxa:1;
+	} s;
+};
+
+union cvmx_spxx_int_msk {
+	uint64_t u64;
+	struct cvmx_spxx_int_msk_s {
+		uint64_t reserved_12_63:52;
+		uint64_t calerr:1;
+		uint64_t syncerr:1;
+		uint64_t diperr:1;
+		uint64_t tpaovr:1;
+		uint64_t rsverr:1;
+		uint64_t drwnng:1;
+		uint64_t clserr:1;
+		uint64_t spiovr:1;
+		uint64_t reserved_2_3:2;
+		uint64_t abnorm:1;
+		uint64_t prtnxa:1;
+	} s;
+};
+
+union cvmx_pow_wq_int {
+	uint64_t u64;
+	struct cvmx_pow_wq_int_s {
+		uint64_t wq_int:16;
+		uint64_t iq_dis:16;
+		uint64_t reserved_32_63:32;
+	} s;
+};
+
+union cvmx_sso_wq_int_thrx {
+	uint64_t u64;
+	struct {
+		uint64_t iq_thr:12;
+		uint64_t reserved_12_13:2;
+		uint64_t ds_thr:12;
+		uint64_t reserved_26_27:2;
+		uint64_t tc_thr:4;
+		uint64_t tc_en:1;
+		uint64_t reserved_33_63:31;
+	} s;
+};
+
+union cvmx_stxx_int_reg {
+	uint64_t u64;
+	struct cvmx_stxx_int_reg_s {
+		uint64_t reserved_9_63:55;
+		uint64_t syncerr:1;
+		uint64_t frmerr:1;
+		uint64_t unxfrm:1;
+		uint64_t nosync:1;
+		uint64_t diperr:1;
+		uint64_t datovr:1;
+		uint64_t ovrbst:1;
+		uint64_t calpar1:1;
+		uint64_t calpar0:1;
+	} s;
+};
+
+union cvmx_stxx_int_msk {
+	uint64_t u64;
+	struct cvmx_stxx_int_msk_s {
+		uint64_t reserved_8_63:56;
+		uint64_t frmerr:1;
+		uint64_t unxfrm:1;
+		uint64_t nosync:1;
+		uint64_t diperr:1;
+		uint64_t datovr:1;
+		uint64_t ovrbst:1;
+		uint64_t calpar1:1;
+		uint64_t calpar0:1;
+	} s;
+};
+
+union cvmx_pow_wq_int_pc {
+	uint64_t u64;
+	struct cvmx_pow_wq_int_pc_s {
+		uint64_t reserved_0_7:8;
+		uint64_t pc_thr:20;
+		uint64_t reserved_28_31:4;
+		uint64_t pc:28;
+		uint64_t reserved_60_63:4;
+	} s;
+};
+
+union cvmx_pow_wq_int_thrx {
+	uint64_t u64;
+	struct cvmx_pow_wq_int_thrx_s {
+		uint64_t reserved_29_63:35;
+		uint64_t tc_en:1;
+		uint64_t tc_thr:4;
+		uint64_t reserved_23_23:1;
+		uint64_t ds_thr:11;
+		uint64_t reserved_11_11:1;
+		uint64_t iq_thr:11;
+	} s;
+	struct cvmx_pow_wq_int_thrx_cn30xx {
+		uint64_t reserved_29_63:35;
+		uint64_t tc_en:1;
+		uint64_t tc_thr:4;
+		uint64_t reserved_18_23:6;
+		uint64_t ds_thr:6;
+		uint64_t reserved_6_11:6;
+		uint64_t iq_thr:6;
+	} cn30xx;
+	struct cvmx_pow_wq_int_thrx_cn31xx {
+		uint64_t reserved_29_63:35;
+		uint64_t tc_en:1;
+		uint64_t tc_thr:4;
+		uint64_t reserved_20_23:4;
+		uint64_t ds_thr:8;
+		uint64_t reserved_8_11:4;
+		uint64_t iq_thr:8;
+	} cn31xx;
+	struct cvmx_pow_wq_int_thrx_cn52xx {
+		uint64_t reserved_29_63:35;
+		uint64_t tc_en:1;
+		uint64_t tc_thr:4;
+		uint64_t reserved_21_23:3;
+		uint64_t ds_thr:9;
+		uint64_t reserved_9_11:3;
+		uint64_t iq_thr:9;
+	} cn52xx;
+	struct cvmx_pow_wq_int_thrx_cn63xx {
+		uint64_t reserved_29_63:35;
+		uint64_t tc_en:1;
+		uint64_t tc_thr:4;
+		uint64_t reserved_22_23:2;
+		uint64_t ds_thr:10;
+		uint64_t reserved_10_11:2;
+		uint64_t iq_thr:10;
+	} cn63xx;
+};
+
+union cvmx_npi_rsl_int_blocks {
+	uint64_t u64;
+	struct cvmx_npi_rsl_int_blocks_s {
+		uint64_t reserved_32_63:32;
+		uint64_t rint_31:1;
+		uint64_t iob:1;
+		uint64_t reserved_28_29:2;
+		uint64_t rint_27:1;
+		uint64_t rint_26:1;
+		uint64_t rint_25:1;
+		uint64_t rint_24:1;
+		uint64_t asx1:1;
+		uint64_t asx0:1;
+		uint64_t rint_21:1;
+		uint64_t pip:1;
+		uint64_t spx1:1;
+		uint64_t spx0:1;
+		uint64_t lmc:1;
+		uint64_t l2c:1;
+		uint64_t rint_15:1;
+		uint64_t reserved_13_14:2;
+		uint64_t pow:1;
+		uint64_t tim:1;
+		uint64_t pko:1;
+		uint64_t ipd:1;
+		uint64_t rint_8:1;
+		uint64_t zip:1;
+		uint64_t dfa:1;
+		uint64_t fpa:1;
+		uint64_t key:1;
+		uint64_t npi:1;
+		uint64_t gmx1:1;
+		uint64_t gmx0:1;
+		uint64_t mio:1;
+	} s;
+	struct cvmx_npi_rsl_int_blocks_cn30xx {
+		uint64_t reserved_32_63:32;
+		uint64_t rint_31:1;
+		uint64_t iob:1;
+		uint64_t rint_29:1;
+		uint64_t rint_28:1;
+		uint64_t rint_27:1;
+		uint64_t rint_26:1;
+		uint64_t rint_25:1;
+		uint64_t rint_24:1;
+		uint64_t asx1:1;
+		uint64_t asx0:1;
+		uint64_t rint_21:1;
+		uint64_t pip:1;
+		uint64_t spx1:1;
+		uint64_t spx0:1;
+		uint64_t lmc:1;
+		uint64_t l2c:1;
+		uint64_t rint_15:1;
+		uint64_t rint_14:1;
+		uint64_t usb:1;
+		uint64_t pow:1;
+		uint64_t tim:1;
+		uint64_t pko:1;
+		uint64_t ipd:1;
+		uint64_t rint_8:1;
+		uint64_t zip:1;
+		uint64_t dfa:1;
+		uint64_t fpa:1;
+		uint64_t key:1;
+		uint64_t npi:1;
+		uint64_t gmx1:1;
+		uint64_t gmx0:1;
+		uint64_t mio:1;
+	} cn30xx;
+	struct cvmx_npi_rsl_int_blocks_cn38xx {
+		uint64_t reserved_32_63:32;
+		uint64_t rint_31:1;
+		uint64_t iob:1;
+		uint64_t rint_29:1;
+		uint64_t rint_28:1;
+		uint64_t rint_27:1;
+		uint64_t rint_26:1;
+		uint64_t rint_25:1;
+		uint64_t rint_24:1;
+		uint64_t asx1:1;
+		uint64_t asx0:1;
+		uint64_t rint_21:1;
+		uint64_t pip:1;
+		uint64_t spx1:1;
+		uint64_t spx0:1;
+		uint64_t lmc:1;
+		uint64_t l2c:1;
+		uint64_t rint_15:1;
+		uint64_t rint_14:1;
+		uint64_t rint_13:1;
+		uint64_t pow:1;
+		uint64_t tim:1;
+		uint64_t pko:1;
+		uint64_t ipd:1;
+		uint64_t rint_8:1;
+		uint64_t zip:1;
+		uint64_t dfa:1;
+		uint64_t fpa:1;
+		uint64_t key:1;
+		uint64_t npi:1;
+		uint64_t gmx1:1;
+		uint64_t gmx0:1;
+		uint64_t mio:1;
+	} cn38xx;
+	struct cvmx_npi_rsl_int_blocks_cn50xx {
+		uint64_t reserved_31_63:33;
+		uint64_t iob:1;
+		uint64_t lmc1:1;
+		uint64_t agl:1;
+		uint64_t reserved_24_27:4;
+		uint64_t asx1:1;
+		uint64_t asx0:1;
+		uint64_t reserved_21_21:1;
+		uint64_t pip:1;
+		uint64_t spx1:1;
+		uint64_t spx0:1;
+		uint64_t lmc:1;
+		uint64_t l2c:1;
+		uint64_t reserved_15_15:1;
+		uint64_t rad:1;
+		uint64_t usb:1;
+		uint64_t pow:1;
+		uint64_t tim:1;
+		uint64_t pko:1;
+		uint64_t ipd:1;
+		uint64_t reserved_8_8:1;
+		uint64_t zip:1;
+		uint64_t dfa:1;
+		uint64_t fpa:1;
+		uint64_t key:1;
+		uint64_t npi:1;
+		uint64_t gmx1:1;
+		uint64_t gmx0:1;
+		uint64_t mio:1;
+	} cn50xx;
+};
+
+typedef union {
+	uint64_t u64;
+	struct {
+	        uint64_t total_bytes:16;
+	        uint64_t segs:6;
+	        uint64_t dontfree:1;
+	        uint64_t ignore_i:1;
+	        uint64_t ipoffp1:7;
+	        uint64_t gather:1;
+	        uint64_t rsp:1;
+	        uint64_t wqp:1;
+	        uint64_t n2:1;
+	        uint64_t le:1;
+	        uint64_t reg0:11;
+	        uint64_t subone0:1;
+	        uint64_t reg1:11;
+	        uint64_t subone1:1;
+	        uint64_t size0:2;
+	        uint64_t size1:2;
+	} s;
+} cvmx_pko_command_word0_t;
+
+union cvmx_ciu_timx {
+	uint64_t u64;
+	struct cvmx_ciu_timx_s {
+		uint64_t reserved_37_63:27;
+		uint64_t one_shot:1;
+		uint64_t len:36;
+	} s;
+};
+
+union cvmx_gmxx_rxx_rx_inbnd {
+	uint64_t u64;
+	struct cvmx_gmxx_rxx_rx_inbnd_s {
+		uint64_t status:1;
+		uint64_t speed:2;
+		uint64_t duplex:1;
+		uint64_t reserved_4_63:60;
+	} s;
+};
+
+static inline int32_t cvmx_fau_fetch_and_add32(cvmx_fau_reg_32_t reg,
+					       int32_t value)
+{
+	return value;
+}
+
+static inline void cvmx_fau_atomic_add32(cvmx_fau_reg_32_t reg, int32_t value)
+{ }
+
+static inline void cvmx_fau_atomic_write32(cvmx_fau_reg_32_t reg, int32_t value)
+{ }
+
+static inline uint64_t cvmx_scratch_read64(uint64_t address)
+{
+	return 0;
+}
+
+static inline void cvmx_scratch_write64(uint64_t address, uint64_t value)
+{ }
+
+static inline int cvmx_wqe_get_grp(cvmx_wqe_t *work)
+{
+	return 0;
+}
+
+static inline void *cvmx_phys_to_ptr(uint64_t physical_address)
+{
+	return (void *)(physical_address);
+}
+
+static inline uint64_t cvmx_ptr_to_phys(void *ptr)
+{
+	return (unsigned long)ptr;
+}
+
+static inline int cvmx_helper_get_interface_num(int ipd_port)
+{
+	return ipd_port;
+}
+
+static inline int cvmx_helper_get_interface_index_num(int ipd_port)
+{
+	return ipd_port;
+}
+
+static inline void cvmx_fpa_enable(void)
+{ }
+
+static inline uint64_t cvmx_read_csr(uint64_t csr_addr)
+{
+	return 0;
+}
+
+static inline void cvmx_write_csr(uint64_t csr_addr, uint64_t val)
+{ }
+
+static inline int cvmx_helper_setup_red(int pass_thresh, int drop_thresh)
+{
+	return 0;
+}
+
+static inline void *cvmx_fpa_alloc(uint64_t pool)
+{
+	return NULL;
+}
+
+static inline void cvmx_fpa_free(void *ptr, uint64_t pool,
+				 uint64_t num_cache_lines)
+{ }
+
+static inline int octeon_is_simulation(void)
+{
+	return 1;
+}
+
+static inline void cvmx_pip_get_port_status(uint64_t port_num, uint64_t clear,
+					    cvmx_pip_port_status_t *status)
+{ }
+
+static inline void cvmx_pko_get_port_status(uint64_t port_num, uint64_t clear,
+					    cvmx_pko_port_status_t *status)
+{ }
+
+static inline cvmx_helper_interface_mode_t cvmx_helper_interface_get_mode(int
+								   interface)
+{
+	return 0;
+}
+
+static inline cvmx_helper_link_info_t cvmx_helper_link_get(int ipd_port)
+{
+	cvmx_helper_link_info_t ret = { .u64 = 0 };
+
+	return ret;
+}
+
+static inline int cvmx_helper_link_set(int ipd_port,
+				cvmx_helper_link_info_t link_info)
+{
+	return 0;
+}
+
+static inline int cvmx_helper_initialize_packet_io_global(void)
+{
+	return 0;
+}
+
+static inline int cvmx_helper_get_number_of_interfaces(void)
+{
+	return 2;
+}
+
+static inline int cvmx_helper_ports_on_interface(int interface)
+{
+	return 1;
+}
+
+static inline int cvmx_helper_get_ipd_port(int interface, int port)
+{
+	return 0;
+}
+
+static inline int cvmx_helper_ipd_and_packet_input_enable(void)
+{
+	return 0;
+}
+
+static inline void cvmx_ipd_disable(void)
+{ }
+
+static inline void cvmx_ipd_free_ptr(void)
+{ }
+
+static inline void cvmx_pko_disable(void)
+{ }
+
+static inline void cvmx_pko_shutdown(void)
+{ }
+
+static inline int cvmx_pko_get_base_queue_per_core(int port, int core)
+{
+	return port;
+}
+
+static inline int cvmx_pko_get_base_queue(int port)
+{
+	return port;
+}
+
+static inline int cvmx_pko_get_num_queues(int port)
+{
+	return port;
+}
+
+static inline unsigned int cvmx_get_core_num(void)
+{
+	return 0;
+}
+
+static inline void cvmx_pow_work_request_async_nocheck(int scr_addr,
+						       cvmx_pow_wait_t wait)
+{ }
+
+static inline void cvmx_pow_work_request_async(int scr_addr,
+						       cvmx_pow_wait_t wait)
+{ }
+
+static inline cvmx_wqe_t *cvmx_pow_work_response_async(int scr_addr)
+{
+	cvmx_wqe_t *wqe = (void *)(unsigned long)scr_addr;
+
+	return wqe;
+}
+
+static inline cvmx_wqe_t *cvmx_pow_work_request_sync(cvmx_pow_wait_t wait)
+{
+	return (void *)(unsigned long)wait;
+}
+
+static inline int cvmx_spi_restart_interface(int interface,
+					cvmx_spi_mode_t mode, int timeout)
+{
+	return 0;
+}
+
+static inline void cvmx_fau_async_fetch_and_add32(uint64_t scraddr,
+						  cvmx_fau_reg_32_t reg,
+						  int32_t value)
+{ }
+
+static inline union cvmx_gmxx_rxx_rx_inbnd cvmx_spi4000_check_speed(
+	int interface,
+	int port)
+{
+	union cvmx_gmxx_rxx_rx_inbnd r;
+	r.u64 = 0;
+	return r;
+}
+
+static inline void cvmx_pko_send_packet_prepare(uint64_t port, uint64_t queue,
+						cvmx_pko_lock_t use_locking)
+{ }
+
+static inline cvmx_pko_status_t cvmx_pko_send_packet_finish(uint64_t port,
+		uint64_t queue, cvmx_pko_command_word0_t pko_command,
+		union cvmx_buf_ptr packet, cvmx_pko_lock_t use_locking)
+{
+	cvmx_pko_status_t ret = 0;
+
+	return ret;
+}
+
+static inline void cvmx_wqe_set_port(cvmx_wqe_t *work, int port)
+{ }
+
+static inline void cvmx_wqe_set_qos(cvmx_wqe_t *work, int qos)
+{ }
+
+static inline int cvmx_wqe_get_qos(cvmx_wqe_t *work)
+{
+	return 0;
+}
+
+static inline void cvmx_wqe_set_grp(cvmx_wqe_t *work, int grp)
+{ }
+
+static inline void cvmx_pow_work_submit(cvmx_wqe_t *wqp, uint32_t tag,
+					enum cvmx_pow_tag_type tag_type,
+					uint64_t qos, uint64_t grp)
+{ }
+
+#define CVMX_ASXX_RX_CLK_SETX(a, b)	((a)+(b))
+#define CVMX_ASXX_TX_CLK_SETX(a, b)	((a)+(b))
+#define CVMX_CIU_TIMX(a)		(a)
+#define CVMX_GMXX_RXX_ADR_CAM0(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CAM1(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CAM2(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CAM3(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CAM4(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_ADR_CAM5(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_FRM_CTL(a, b)	((a)+(b))
+#define CVMX_GMXX_RXX_INT_REG(a, b)	((a)+(b))
+#define CVMX_GMXX_SMACX(a, b)		((a)+(b))
+#define CVMX_PIP_PRT_TAGX(a)		(a)
+#define CVMX_POW_PP_GRP_MSKX(a)		(a)
+#define CVMX_POW_WQ_INT_THRX(a)		(a)
+#define CVMX_SPXX_INT_MSK(a)		(a)
+#define CVMX_SPXX_INT_REG(a)		(a)
+#define CVMX_SSO_PPX_GRP_MSK(a)		(a)
+#define CVMX_SSO_WQ_INT_THRX(a)		(a)
+#define CVMX_STXX_INT_MSK(a)		(a)
+#define CVMX_STXX_INT_REG(a)		(a)
-- 
2.20.1

