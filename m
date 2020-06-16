Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B92B1FA643
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 04:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgFPCFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 22:05:43 -0400
Received: from m12-16.163.com ([220.181.12.16]:33390 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgFPCFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 22:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=YMUhu
        63e9pG6IJUwXtaIbBjPPSnxaWDr22aF9kaPBTQ=; b=ULwjOxcC4JRMdvnukgsEd
        YK7CoT6jsidcx3iZkvvqOUlMvqI0EJqLdVBN4/nynQGTbFUKQrmLEHbV8rmVtE5x
        BAlBWXNmyXOAbQ0K8m6Vs4XOQ4bCic48poCR/XExG0opCkTw8NSNUh08p39RNf2Y
        dlotmZvJc9U/0iyeDcFPb4=
Received: from SZA191027643-PM.china.huawei.com (unknown [139.159.170.21])
        by smtp12 (Coremail) with SMTP id EMCowAD38x_QKOhe14iwIQ--.45812S2;
        Tue, 16 Jun 2020 10:05:07 +0800 (CST)
From:   yunaixin03610@163.com
To:     netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
Subject: [PATCH 3/5] Huawei BMA: Adding Huawei BMA driver: host_veth_drv
Date:   Tue, 16 Jun 2020 10:05:02 +0800
Message-Id: <20200616020502.1335-1-yunaixin03610@163.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAD38x_QKOhe14iwIQ--.45812S2
X-Coremail-Antispam: 1Uf129KBjvAXoWkJr1xCF43KF4UWw13Cr1rZwb_yoW3tr43Ao
        ZIqrsakrn3Gw17ArZ8Gan3Kr17Z34DGayDZr4YkrZ5X3Z5Zw4jqrWDGry3Jr1Fgw4Iqa48
        WFsFqr4SqayUZw1rn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU29mRDUUUU
X-Originating-IP: [139.159.170.21]
X-CM-SenderInfo: 51xqtxx0lqijqwrqqiywtou0bp/xtbBZxVF5letzQlO9gAAsX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yunaixin <yunaixin@huawei.com>

The BMA software is a system management software offered by Huawei. It supports the status monitoring, performance monitoring, and event monitoring of various components, including server CPUs, memory, hard disks, NICs, IB cards, PCIe cards, RAID controller cards, and optical modules.

This host_veth_drv driver is one of the communication drivers used by BMA software. It depends on the host_edma_drv driver. The host_veth_drv driver will create a virtual net device "veth" once loaded. BMA software will use it to send/receive RESTful messages to/from BMC software.

Signed-off-by: yunaixin <yunaixin@huawei.com>
---
 drivers/net/ethernet/huawei/bma/Kconfig       |    3 +-
 drivers/net/ethernet/huawei/bma/Makefile      |    3 +-
 .../net/ethernet/huawei/bma/veth_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/veth_drv/Makefile |    2 +
 .../ethernet/huawei/bma/veth_drv/veth_hb.c    | 2508 +++++++++++++++++
 .../ethernet/huawei/bma/veth_drv/veth_hb.h    |  442 +++
 6 files changed, 2967 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h

diff --git a/drivers/net/ethernet/huawei/bma/Kconfig b/drivers/net/ethernet/huawei/bma/Kconfig
index 12979128fa9d..21e9f7ee5be6 100644
--- a/drivers/net/ethernet/huawei/bma/Kconfig
+++ b/drivers/net/ethernet/huawei/bma/Kconfig
@@ -1,2 +1,3 @@
 source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
-source "drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig"
\ No newline at end of file
+source "drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig"
+source "drivers/net/ethernet/huawei/bma/veth_drv/Kconfig"
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
index c9bbcbf2a388..6ff24d31c650 100644
--- a/drivers/net/ethernet/huawei/bma/Makefile
+++ b/drivers/net/ethernet/huawei/bma/Makefile
@@ -3,4 +3,5 @@
 # 
 
 obj-$(CONFIG_BMA) += edma_drv/
-obj-$(CONFIG_BMA) += cdev_drv/
\ No newline at end of file
+obj-$(CONFIG_BMA) += cdev_drv/
+obj-$(CONFIG_BMA) += veth_drv/
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/veth_drv/Kconfig b/drivers/net/ethernet/huawei/bma/veth_drv/Kconfig
new file mode 100644
index 000000000000..97829c5487c2
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/veth_drv/Kconfig
@@ -0,0 +1,11 @@
+#
+# Huawei BMA software driver configuration
+#
+
+config BMA
+	tristate "Huawei BMA Software Communication Driver"
+
+	---help---
+	  This driver supports Huawei BMA Software. It is used 
+	  to communication between Huawei BMA and BMC software.
+
diff --git a/drivers/net/ethernet/huawei/bma/veth_drv/Makefile b/drivers/net/ethernet/huawei/bma/veth_drv/Makefile
new file mode 100644
index 000000000000..c9ab07371ef4
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/veth_drv/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BMA) += host_veth_drv.o
+host_veth_drv-y := veth_hb.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
new file mode 100644
index 000000000000..9471b285ecff
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
@@ -0,0 +1,2508 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/kthread.h>
+
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+
+#include <linux/vmalloc.h>
+#include <linux/atomic.h>
+#include <linux/proc_fs.h>
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <asm/page.h>
+
+#include <linux/ip.h>
+
+#include "veth_hb.h"
+
+#define GET_QUEUE_STAT(node, stat) \
+	((node) ? ((char *)(node) + (stat)->stat_offset) : NULL)
+
+#define GET_SHM_QUEUE_STAT(node, stat) \
+	(((node) && (node)->pshmqhd_v) ? \
+	 ((char *)(node)->pshmqhd_v + (stat)->stat_offset) : NULL)
+
+#define GET_STATS_VALUE(ptr, pstat) \
+	((ptr) ? (((pstat)->sizeof_stat == sizeof(u64)) ? \
+			(*(u64 *)(ptr)) : (*(u32 *)(ptr))) : 0)
+
+#define GET_DMA_DIRECTION(type) \
+	(((type) == BSPVETH_RX) ? BMC_TO_HOST : HOST_TO_BMC)
+
+#define CHECK_DMA_QUEUE_EMPTY(type, queue) \
+	(((type) == BSPVETH_RX && \
+	  (queue)->pshmqhd_v->head == (queue)->pshmqhd_v->tail) || \
+	 ((type) != BSPVETH_RX && (queue)->head == (queue)->tail))
+
+#define CHECK_DMA_RXQ_FAULT(queue, type, cnt) \
+	((queue)->dmal_cnt > 1 && (cnt) < ((queue)->work_limit / 2) && \
+	 (type) == BSPVETH_RX)
+
+static u32 veth_ethtool_get_link(struct net_device *dev);
+
+int debug;			/* debug switch*/
+module_param_call(debug, &edma_param_set_debug, &param_get_int, &debug, 0644);
+
+MODULE_PARM_DESC(debug, "Debug switch (0=close debug, 1=open debug)");
+
+#define VETH_LOG(lv, fmt, args...)    \
+do {	\
+	if (debug < (lv))	\
+		continue;	\
+	if (lv == DLOG_DEBUG)	\
+		netdev_dbg(g_bspveth_dev.pnetdev, "%s(), %d, " \
+		fmt, __func__, __LINE__, ## args);	\
+	else if (lv == DLOG_ERROR)	\
+		netdev_err(g_bspveth_dev.pnetdev, "%s(), %d, " \
+		fmt, __func__, __LINE__, ## args);	\
+} while (0)
+
+#ifdef __UT_TEST
+u32 g_testdma;
+
+u32 g_testlbk;
+
+#endif
+
+struct bspveth_device g_bspveth_dev = {};
+
+static int veth_int_handler(struct notifier_block *pthis, unsigned long ev,
+			    void *unuse);
+
+static struct notifier_block g_veth_int_nb = {
+	.notifier_call = veth_int_handler,
+};
+
+static const struct veth_stats veth_gstrings_stats[] = {
+	{"rx_packets", NET_STATS, VETH_STAT_SIZE(stats.rx_packets),
+	 VETH_STAT_OFFSET(stats.rx_packets)},
+	{"rx_bytes", NET_STATS, VETH_STAT_SIZE(stats.rx_bytes),
+	 VETH_STAT_OFFSET(stats.rx_bytes)},
+	{"rx_dropped", NET_STATS, VETH_STAT_SIZE(stats.rx_dropped),
+	 VETH_STAT_OFFSET(stats.rx_dropped)},
+	{"rx_head", QUEUE_RX_STATS, QUEUE_TXRX_STAT_SIZE(head),
+	 QUEUE_TXRX_STAT_OFFSET(head)},
+	{"rx_tail", QUEUE_RX_STATS, QUEUE_TXRX_STAT_SIZE(tail),
+	 QUEUE_TXRX_STAT_OFFSET(tail)},
+	{"rx_next_to_fill", QUEUE_RX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(next_to_fill),
+	 QUEUE_TXRX_STAT_OFFSET(next_to_fill)},
+	{"rx_shmq_head", SHMQ_RX_STATS, SHMQ_TXRX_STAT_SIZE(head),
+	 SHMQ_TXRX_STAT_OFFSET(head)},
+	{"rx_shmq_tail", SHMQ_RX_STATS, SHMQ_TXRX_STAT_SIZE(tail),
+	 SHMQ_TXRX_STAT_OFFSET(tail)},
+	{"rx_shmq_next_to_free", SHMQ_RX_STATS,
+	 SHMQ_TXRX_STAT_SIZE(next_to_free),
+	 SHMQ_TXRX_STAT_OFFSET(next_to_free)},
+	{"rx_queue_full", QUEUE_RX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.q_full),
+	 QUEUE_TXRX_STAT_OFFSET(s.q_full)},
+	{"rx_dma_busy", QUEUE_RX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.dma_busy),
+	 QUEUE_TXRX_STAT_OFFSET(s.dma_busy)},
+	{"rx_dma_failed", QUEUE_RX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.dma_failed),
+	 QUEUE_TXRX_STAT_OFFSET(s.dma_failed)},
+
+	{"tx_packets", NET_STATS, VETH_STAT_SIZE(stats.tx_packets),
+	 VETH_STAT_OFFSET(stats.tx_packets)},
+	{"tx_bytes", NET_STATS, VETH_STAT_SIZE(stats.tx_bytes),
+	 VETH_STAT_OFFSET(stats.tx_bytes)},
+	{"tx_dropped", NET_STATS, VETH_STAT_SIZE(stats.tx_dropped),
+	 VETH_STAT_OFFSET(stats.tx_dropped)},
+
+	{"tx_head", QUEUE_TX_STATS, QUEUE_TXRX_STAT_SIZE(head),
+	 QUEUE_TXRX_STAT_OFFSET(head)},
+	{"tx_tail", QUEUE_TX_STATS, QUEUE_TXRX_STAT_SIZE(tail),
+	 QUEUE_TXRX_STAT_OFFSET(tail)},
+	{"tx_next_to_free", QUEUE_TX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(next_to_free),
+	 QUEUE_TXRX_STAT_OFFSET(next_to_free)},
+	{"tx_shmq_head", SHMQ_TX_STATS, SHMQ_TXRX_STAT_SIZE(head),
+	 SHMQ_TXRX_STAT_OFFSET(head)},
+	{"tx_shmq_tail", SHMQ_TX_STATS, SHMQ_TXRX_STAT_SIZE(tail),
+	 SHMQ_TXRX_STAT_OFFSET(tail)},
+	{"tx_shmq_next_to_free", SHMQ_TX_STATS,
+	 SHMQ_TXRX_STAT_SIZE(next_to_free),
+	 SHMQ_TXRX_STAT_OFFSET(next_to_free)},
+
+	{"tx_queue_full", QUEUE_TX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.q_full),
+	 QUEUE_TXRX_STAT_OFFSET(s.q_full)},
+	{"tx_dma_busy", QUEUE_TX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.dma_busy),
+	 QUEUE_TXRX_STAT_OFFSET(s.dma_busy)},
+	{"tx_dma_failed", QUEUE_TX_STATS,
+	 QUEUE_TXRX_STAT_SIZE(s.dma_failed),
+	 QUEUE_TXRX_STAT_OFFSET(s.dma_failed)},
+
+	{"recv_int", VETH_STATS, VETH_STAT_SIZE(recv_int),
+	 VETH_STAT_OFFSET(recv_int)},
+	{"tobmc_int", VETH_STATS, VETH_STAT_SIZE(tobmc_int),
+	 VETH_STAT_OFFSET(tobmc_int)},
+};
+
+#define VETH_GLOBAL_STATS_LEN	\
+		(sizeof(veth_gstrings_stats) / sizeof(struct veth_stats))
+
+static int veth_param_get_statics(char *buf, const struct kernel_param *kp)
+{
+	int len = 0;
+	int i = 0, j = 0, type = 0;
+	struct bspveth_rxtx_q *pqueue = NULL;
+	__kernel_time_t running_time = 0;
+
+	if (!buf)
+		return 0;
+
+	GET_SYS_SECONDS(running_time);
+
+	running_time -= g_bspveth_dev.init_time;
+
+	len += sprintf(buf + len,
+			"================VETH INFO=============\r\n");
+	len += sprintf(buf + len, "[version     ]:" VETH_VERSION "\n");
+	len += sprintf(buf + len, "[link state  ]:%d\n",
+			veth_ethtool_get_link(g_bspveth_dev.pnetdev));
+	len += sprintf(buf + len, "[running_time]:%luD %02lu:%02lu:%02lu\n",
+			running_time / (SECONDS_PER_DAY),
+			running_time % (SECONDS_PER_DAY) / SECONDS_PER_HOUR,
+			running_time % SECONDS_PER_HOUR / SECONDS_PER_MINUTE,
+			running_time % SECONDS_PER_MINUTE);
+	len += sprintf(buf + len,
+			"[bspveth_dev ]:MAX_QUEUE_NUM :0x%-16x	",
+			MAX_QUEUE_NUM);
+	len += sprintf(buf + len,
+			"MAX_QUEUE_BDNUM :0x%-16x\r\n", MAX_QUEUE_BDNUM);
+	len += sprintf(buf + len,
+			"[bspveth_dev ]:pnetdev	  :0x%-16p	",
+			g_bspveth_dev.pnetdev);
+	len += sprintf(buf + len,
+			"ppcidev		 :0x%-16p\r\n",
+			g_bspveth_dev.ppcidev);
+	len += sprintf(buf + len,
+			"[bspveth_dev ]:pshmpool_p:0x%-16p	",
+			g_bspveth_dev.pshmpool_p);
+	len += sprintf(buf + len,
+			"pshmpool_v	  :0x%-16p\r\n",
+			g_bspveth_dev.pshmpool_v);
+	len += sprintf(buf + len,
+			"[bspveth_dev ]:shmpoolsize:0x%-16x	",
+			g_bspveth_dev.shmpoolsize);
+	len += sprintf(buf + len,
+			"g_veth_dbg_lv		:0x%-16x\r\n", debug);
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		for (j = 0, type = BSPVETH_RX; j < 2; j++, type++) {
+			if (type == BSPVETH_RX) {
+				pqueue = g_bspveth_dev.prx_queue[i];
+				len += sprintf(buf + len,
+				"=============RXQUEUE STATIS============\r\n");
+			} else {
+				pqueue = g_bspveth_dev.ptx_queue[i];
+				len += sprintf(buf + len,
+				"=============TXQUEUE STATIS============\r\n");
+			}
+
+			if (!pqueue) {
+				len += sprintf(buf + len, "NULL\r\n");
+				continue;
+			}
+
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[pkt	] :%lld\r\n", i,
+					pqueue->s.pkt);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[pktbyte	] :%lld\r\n", i,
+					pqueue->s.pktbyte);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[refill	] :%lld\r\n", i,
+					pqueue->s.refill);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[freetx	] :%lld\r\n", i,
+					pqueue->s.freetx);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dmapkt	] :%lld\r\n", i,
+					pqueue->s.dmapkt);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dmapktbyte	] :%lld\r\n", i,
+					pqueue->s.dmapktbyte);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[next_to_fill ] :%d\r\n", i,
+					pqueue->next_to_fill);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[next_to_free ] :%d\r\n", i,
+					pqueue->next_to_free);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[head	] :%d\r\n", i,
+					pqueue->head);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[tail	] :%d\r\n", i,
+					pqueue->tail);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[work_limit	] :%d\r\n", i,
+					pqueue->work_limit);
+			len += sprintf(buf + len,
+			"=================SHARE=================\r\n");
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[next_to_fill] :%d\r\n", i,
+					pqueue->pshmqhd_v->next_to_fill);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[next_to_free] :%d\r\n", i,
+					pqueue->pshmqhd_v->next_to_free);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[head	] :%d\r\n", i,
+					pqueue->pshmqhd_v->head);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[tail	] :%d\r\n", i,
+					pqueue->pshmqhd_v->tail);
+			len += sprintf(buf + len,
+			"=======================================\r\n");
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dropped_pkt] :%d\r\n", i,
+					pqueue->s.dropped_pkt);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[netifrx_err] :%d\r\n", i,
+					pqueue->s.netifrx_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[null_point	] :%d\r\n", i,
+					pqueue->s.null_point);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[retry_err	] :%d\r\n", i,
+					pqueue->s.retry_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[allocskb_err  ] :%d\r\n",
+					i, pqueue->s.allocskb_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[q_full	] :%d\r\n", i,
+					pqueue->s.q_full);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[q_emp	] :%d\r\n", i,
+					pqueue->s.q_emp);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[need_fill	] :%d\r\n", i,
+					pqueue->s.need_fill);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[need_free	] :%d\r\n", i,
+					pqueue->s.need_free);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[type_err	] :%d\r\n", i,
+					pqueue->s.type_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[shm_full	] :%d\r\n", i,
+					pqueue->s.shm_full);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[shm_emp	] :%d\r\n", i,
+					pqueue->s.shm_emp);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[shmretry_err ] :%d\r\n", i,
+					pqueue->s.shmretry_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[shmqueue_noinit] :%d\r\n",
+					i, pqueue->s.shmqueue_noinit);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dma_busy	] :%d\r\n", i,
+					pqueue->s.dma_busy);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dma_mapping_err] :%d\r\n",
+					i, pqueue->s.dma_mapping_err);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dma_failed	] :%d\r\n", i,
+					pqueue->s.dma_failed);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dma_burst	] :%d\r\n", i,
+					pqueue->s.dma_burst);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[lbk_cnt	] :%d\r\n", i,
+					pqueue->s.lbk_cnt);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[dma_need_offset] :%d\r\n",
+					i, pqueue->s.dma_need_offset);
+			len += sprintf(buf + len,
+					"QUEUE[%d]--[lbk_txerr	] :%d\r\n", i,
+					pqueue->s.lbk_txerr);
+		}
+	}
+
+	len += sprintf(buf + len, "=============BSPVETH STATIS===========\r\n");
+	len += sprintf(buf + len,
+				"[bspveth_dev]:run_dma_rx_task:0x%-8x(%d)\r\n",
+				g_bspveth_dev.run_dma_rx_task,
+				g_bspveth_dev.run_dma_rx_task);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:run_dma_tx_task:0x%-8x(%d)\r\n",
+				g_bspveth_dev.run_dma_tx_task,
+				g_bspveth_dev.run_dma_tx_task);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:run_skb_rx_task:0x%-8x(%d)\r\n",
+				g_bspveth_dev.run_skb_rx_task,
+				g_bspveth_dev.run_skb_rx_task);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:run_skb_fr_task:0x%-8x(%d)\r\n",
+				g_bspveth_dev.run_skb_fr_task,
+				g_bspveth_dev.run_skb_fr_task);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:recv_int	     :0x%-8x(%d)\r\n",
+				g_bspveth_dev.recv_int, g_bspveth_dev.recv_int);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:tobmc_int      :0x%-8x(%d)\r\n",
+				g_bspveth_dev.tobmc_int,
+				g_bspveth_dev.tobmc_int);
+	len += sprintf(buf + len,
+				"[bspveth_dev]:shutdown_cnt   :0x%-8x(%d)\r\n",
+				g_bspveth_dev.shutdown_cnt,
+				g_bspveth_dev.shutdown_cnt);
+
+	return len;
+}
+
+module_param_call(statistics, NULL, veth_param_get_statics, &debug, 0444);
+
+MODULE_PARM_DESC(statistics, "Statistics info of veth driver,readonly");
+
+static void veth_reset_dma(int type)
+{
+	if (type == BSPVETH_RX)
+		bma_intf_reset_dma(BMC_TO_HOST);
+	else if (type == BSPVETH_TX)
+		bma_intf_reset_dma(HOST_TO_BMC);
+	else
+		return;
+}
+
+s32 bspveth_setup_tx_resources(struct bspveth_device *pvethdev,
+			       struct bspveth_rxtx_q *ptx_queue)
+{
+	unsigned int size;
+
+	if (!pvethdev || !ptx_queue)
+		return BSP_ERR_NULL_POINTER;
+
+	ptx_queue->count = MAX_QUEUE_BDNUM;
+
+	size = sizeof(struct bspveth_bd_info) * ptx_queue->count;
+	ptx_queue->pbdinfobase_v = vmalloc(size);
+	if (!ptx_queue->pbdinfobase_v)
+		goto alloc_failed;
+
+	memset(ptx_queue->pbdinfobase_v, 0, size);
+
+	/* round up to nearest 4K */
+	ptx_queue->size = ptx_queue->count * sizeof(struct bspveth_bd_info);
+	ptx_queue->size = ALIGN(ptx_queue->size, 4096);
+
+	/* prepare  4096 send buffer */
+	ptx_queue->pbdbase_v = kmalloc(ptx_queue->size, GFP_KERNEL);
+	if (!ptx_queue->pbdbase_v) {
+		VETH_LOG(DLOG_ERROR,
+			 "Unable to kmalloc for the receive descriptor ring\n");
+
+		vfree(ptx_queue->pbdinfobase_v);
+		ptx_queue->pbdinfobase_v = NULL;
+
+		goto alloc_failed;
+	}
+
+	ptx_queue->pbdbase_p = (u8 *)(__pa((BSP_VETH_T)(ptx_queue->pbdbase_v)));
+
+	ptx_queue->next_to_fill = 0;
+	ptx_queue->next_to_free = 0;
+	ptx_queue->head = 0;
+	ptx_queue->tail = 0;
+	ptx_queue->work_limit = BSPVETH_WORK_LIMIT;
+
+	memset(&ptx_queue->s, 0, sizeof(struct bspveth_rxtx_statis));
+
+	return 0;
+
+alloc_failed:
+	return -ENOMEM;
+}
+
+void bspveth_free_tx_resources(struct bspveth_device *pvethdev,
+			       struct bspveth_rxtx_q *ptx_queue)
+{
+	unsigned int i;
+	unsigned long size;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+	struct sk_buff *skb = NULL;
+
+	if (!ptx_queue || !pvethdev)
+		return;
+
+	pbdinfobase_v = ptx_queue->pbdinfobase_v;
+	if (!pbdinfobase_v)
+		return;
+
+	for (i = 0; i < ptx_queue->count; i++) {
+		skb = pbdinfobase_v[i].pdma_v;
+		if (skb)
+			dev_kfree_skb_any(skb);
+
+		pbdinfobase_v[i].pdma_v = NULL;
+	}
+
+	size = sizeof(struct bspveth_bd_info) * ptx_queue->count;
+	memset(ptx_queue->pbdinfobase_v, 0, size);
+	memset(ptx_queue->pbdbase_v, 0, ptx_queue->size);
+
+	ptx_queue->next_to_fill = 0;
+	ptx_queue->next_to_free = 0;
+	ptx_queue->head = 0;
+	ptx_queue->tail = 0;
+
+	vfree(ptx_queue->pbdinfobase_v);
+	ptx_queue->pbdinfobase_v = NULL;
+
+	kfree(ptx_queue->pbdbase_v);
+	ptx_queue->pbdbase_v = NULL;
+
+	VETH_LOG(DLOG_DEBUG, "bspveth free tx resources ok, count=%d\n",
+		 ptx_queue->count);
+}
+
+s32 bspveth_setup_all_tx_resources(struct bspveth_device *pvethdev)
+{
+	int qid = 0;
+	int i = 0;
+	int err = 0;
+	u8 *shmq_head_p = NULL;
+	struct bspveth_shmq_hd *shmq_head = NULL;
+
+	if (!pvethdev)
+		return BSP_ERR_NULL_POINTER;
+	for (qid = 0; qid < MAX_QUEUE_NUM; qid++) {
+		pvethdev->ptx_queue[qid] =
+			kmalloc(sizeof(*pvethdev->ptx_queue[qid]),
+				GFP_KERNEL);
+		if (!pvethdev->ptx_queue[qid]) {
+			VETH_LOG(DLOG_ERROR,
+				 "kmalloc failed for ptx_queue[%d]\n", qid);
+			err = -1;
+			goto failed;
+		}
+		memset(pvethdev->ptx_queue[qid],
+		       0, sizeof(struct bspveth_rxtx_q));
+		shmq_head = (struct bspveth_shmq_hd *)(pvethdev->pshmpool_v +
+					 MAX_SHAREQUEUE_SIZE * (qid));
+		pvethdev->ptx_queue[qid]->pshmqhd_v = shmq_head;
+		shmq_head_p = pvethdev->pshmpool_p + MAX_SHAREQUEUE_SIZE * qid;
+		pvethdev->ptx_queue[qid]->pshmqhd_p = shmq_head_p;
+
+		pvethdev->ptx_queue[qid]->pshmbdbase_v =
+			(struct bspveth_dma_shmbd *)((BSP_VETH_T)(shmq_head)
+			+ BSPVETH_SHMBDBASE_OFFSET);
+		pvethdev->ptx_queue[qid]->pshmbdbase_p =
+			(u8 *)((BSP_VETH_T)(shmq_head_p)
+			+ BSPVETH_SHMBDBASE_OFFSET);
+		pvethdev->ptx_queue[qid]->pdmalbase_v =
+			(struct bspveth_dmal *)((BSP_VETH_T)(shmq_head)
+			+ SHMDMAL_OFFSET);
+		pvethdev->ptx_queue[qid]->pdmalbase_p =
+			(u8 *)(u64)(VETH_SHAREPOOL_BASE_INBMC +
+			MAX_SHAREQUEUE_SIZE * qid +
+			SHMDMAL_OFFSET);
+
+		memset(pvethdev->ptx_queue[qid]->pdmalbase_v,
+		       0, MAX_SHMDMAL_SIZE);
+
+		err = bspveth_setup_tx_resources(pvethdev,
+						 pvethdev->ptx_queue[qid]);
+		if (err) {
+			pvethdev->ptx_queue[qid]->pshmqhd_v = NULL;
+			kfree(pvethdev->ptx_queue[qid]);
+			pvethdev->ptx_queue[i] = NULL;
+			VETH_LOG(DLOG_ERROR,
+				 "Allocation for Tx Queue %u failed\n", qid);
+
+			goto failed;
+		}
+	}
+
+	return 0;
+failed:
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		bspveth_free_tx_resources(pvethdev, pvethdev->ptx_queue[i]);
+		kfree(pvethdev->ptx_queue[i]);
+		pvethdev->ptx_queue[i] = NULL;
+	}
+
+	return err;
+}
+
+void bspveth_free_all_tx_resources(struct bspveth_device *pvethdev)
+{
+	int i;
+
+	if (!pvethdev)
+		return;
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		if (pvethdev->ptx_queue[i])
+			bspveth_free_tx_resources(pvethdev,
+						  pvethdev->ptx_queue[i]);
+
+		kfree(pvethdev->ptx_queue[i]);
+		pvethdev->ptx_queue[i] = NULL;
+	}
+}
+
+s32 veth_alloc_one_rx_skb(struct bspveth_rxtx_q *prx_queue, int idx)
+{
+	dma_addr_t dma = 0;
+	struct sk_buff *skb;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+	struct bspveth_dma_bd *pbdbase_v = NULL;
+
+	pbdinfobase_v = prx_queue->pbdinfobase_v;
+	pbdbase_v = prx_queue->pbdbase_v;
+
+	skb = netdev_alloc_skb(g_bspveth_dev.pnetdev,
+			       BSPVETH_SKB_SIZE + BSPVETH_CACHELINE_SIZE);
+	if (!skb) {
+		VETH_LOG(DLOG_ERROR, "netdev_alloc_skb failed\n");
+		return -ENOMEM;
+	}
+
+	/* advance the data pointer to the next cache line */
+	skb_reserve(skb, PTR_ALIGN(skb->data,
+				   BSPVETH_CACHELINE_SIZE) - skb->data);
+
+	dma = dma_map_single(&g_bspveth_dev.ppcidev->dev,
+			     skb->data, BSPVETH_SKB_SIZE, DMA_FROM_DEVICE);
+	if (DMA_MAPPING_ERROR(&g_bspveth_dev.ppcidev->dev, dma)) {
+		VETH_LOG(DLOG_ERROR, "dma_mapping_error failed\n");
+		dev_kfree_skb_any(skb);
+		return -EFAULT;
+	}
+
+#ifdef __UT_TEST
+	if (g_testdma)
+		VETH_LOG(DLOG_ERROR,
+			 "[refill]:dma=0x%llx,skb=%p,skb->len=%d\r\n",
+			 dma, skb, skb->len);
+#endif
+
+	pbdinfobase_v[idx].pdma_v = skb;
+	pbdinfobase_v[idx].len = BSPVETH_SKB_SIZE;
+
+	pbdbase_v[idx].dma_p = dma;
+	pbdbase_v[idx].len = BSPVETH_SKB_SIZE;
+
+	return 0;
+}
+
+s32 veth_refill_rxskb(struct bspveth_rxtx_q *prx_queue, int queue)
+{
+	int i, work_limit;
+	unsigned int next_to_fill, tail;
+	int ret = BSP_OK;
+
+	if (!prx_queue)
+		return BSP_ERR_AGAIN;
+
+	work_limit = prx_queue->work_limit;
+	next_to_fill = prx_queue->next_to_fill;
+	tail = prx_queue->tail;
+
+	for (i = 0; i < work_limit; i++) {
+		if (!JUDGE_RX_QUEUE_SPACE(next_to_fill, tail, 1))
+			break;
+
+		ret = veth_alloc_one_rx_skb(prx_queue, next_to_fill);
+		if (ret)
+			break;
+
+		g_bspveth_dev.prx_queue[queue]->s.refill++;
+		next_to_fill = (next_to_fill + 1) & BSPVETH_POINT_MASK;
+	}
+
+	prx_queue->next_to_fill = next_to_fill;
+
+	tail = prx_queue->tail;
+	if (JUDGE_RX_QUEUE_SPACE(next_to_fill, tail, 1)) {
+		VETH_LOG(DLOG_DEBUG, "next_to_fill(%d) != tail(%d)\n",
+			 next_to_fill, tail);
+
+		return BSP_ERR_AGAIN;
+	}
+
+	return 0;
+}
+
+s32 bspveth_setup_rx_skb(struct bspveth_device *pvethdev,
+			 struct bspveth_rxtx_q *prx_queue)
+{
+	u32 idx;
+	int ret = 0;
+
+	if (!pvethdev || !prx_queue)
+		return BSP_ERR_NULL_POINTER;
+
+	VETH_LOG(DLOG_DEBUG, "waite setup rx skb ,count=%d\n",
+		 prx_queue->count);
+
+	for (idx = 0; idx < prx_queue->count - 1; idx++) {
+		ret = veth_alloc_one_rx_skb(prx_queue, idx);
+		if (ret)
+			break;
+	}
+
+	if (!idx)	/* Can't alloc even one packets */
+		return -EFAULT;
+
+	prx_queue->next_to_fill = idx;
+
+	VETH_LOG(DLOG_DEBUG, "prx_queue->next_to_fill=%d\n",
+		 prx_queue->next_to_fill);
+
+	VETH_LOG(DLOG_DEBUG, "setup rx skb ok, count=%d\n", prx_queue->count);
+
+	return BSP_OK;
+}
+
+void bspveth_free_rx_skb(struct bspveth_device *pvethdev,
+			 struct bspveth_rxtx_q *prx_queue)
+{
+	u32 i = 0;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+	struct bspveth_dma_bd *pbdbase_v = NULL;
+	struct sk_buff *skb = NULL;
+
+	if (!pvethdev || !prx_queue)
+		return;
+
+	pbdinfobase_v = prx_queue->pbdinfobase_v;
+	pbdbase_v = prx_queue->pbdbase_v;
+	if (!pbdinfobase_v || !pbdbase_v)
+		return;
+
+	/* Free all the Rx ring pages */
+	for (i = 0; i < prx_queue->count; i++) {
+		skb = pbdinfobase_v[i].pdma_v;
+		if (!skb)
+			continue;
+
+		dma_unmap_single(&g_bspveth_dev.ppcidev->dev,
+				 pbdbase_v[i].dma_p, BSPVETH_SKB_SIZE,
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
+
+		pbdinfobase_v[i].pdma_v = NULL;
+	}
+
+	prx_queue->next_to_fill = 0;
+}
+
+s32 bspveth_setup_all_rx_skb(struct bspveth_device *pvethdev)
+{
+	int qid, i, err = BSP_OK;
+
+	if (!pvethdev)
+		return BSP_ERR_NULL_POINTER;
+
+	for (qid = 0; qid < MAX_QUEUE_NUM; qid++) {
+		err = bspveth_setup_rx_skb(pvethdev, pvethdev->prx_queue[qid]);
+		if (err) {
+			VETH_LOG(DLOG_ERROR, "queue[%d]setup RX skb failed\n",
+				 qid);
+			goto failed;
+		}
+
+		VETH_LOG(DLOG_DEBUG, "queue[%d] bspveth_setup_rx_skb ok\n",
+			 qid);
+	}
+
+	return 0;
+
+failed:
+	for (i = 0; i < MAX_QUEUE_NUM; i++)
+		bspveth_free_rx_skb(pvethdev, pvethdev->prx_queue[i]);
+
+	return err;
+}
+
+void bspveth_free_all_rx_skb(struct bspveth_device *pvethdev)
+{
+	int qid;
+
+	if (!pvethdev)
+		return;
+
+	/* Free all the Rx ring pages */
+	for (qid = 0; qid < MAX_QUEUE_NUM; qid++)
+		bspveth_free_rx_skb(pvethdev, pvethdev->prx_queue[qid]);
+}
+
+s32 bspveth_setup_rx_resources(struct bspveth_device *pvethdev,
+			       struct bspveth_rxtx_q *prx_queue)
+{
+	int size;
+
+	if (!pvethdev || !prx_queue)
+		return BSP_ERR_NULL_POINTER;
+
+	prx_queue->count = MAX_QUEUE_BDNUM;
+	size = sizeof(*prx_queue->pbdinfobase_v) * prx_queue->count;
+	prx_queue->pbdinfobase_v = vmalloc(size);
+	if (!prx_queue->pbdinfobase_v) {
+		VETH_LOG(DLOG_ERROR,
+			 "Unable to vmalloc for the receive descriptor ring\n");
+
+		goto alloc_failed;
+	}
+
+	memset(prx_queue->pbdinfobase_v, 0, size);
+
+	/* Round up to nearest 4K */
+	prx_queue->size = prx_queue->count * sizeof(*prx_queue->pbdbase_v);
+	prx_queue->size = ALIGN(prx_queue->size, 4096);
+	prx_queue->pbdbase_v = kmalloc(prx_queue->size, GFP_ATOMIC);
+	if (!prx_queue->pbdbase_v) {
+		VETH_LOG(DLOG_ERROR,
+			 "Unable to kmalloc for the receive descriptor ring\n");
+
+		vfree(prx_queue->pbdinfobase_v);
+		prx_queue->pbdinfobase_v = NULL;
+
+		goto alloc_failed;
+	}
+
+	prx_queue->pbdbase_p = (u8 *)__pa((BSP_VETH_T) (prx_queue->pbdbase_v));
+
+	prx_queue->next_to_fill = 0;
+	prx_queue->next_to_free = 0;
+	prx_queue->head = 0;
+	prx_queue->tail = 0;
+
+	prx_queue->work_limit = BSPVETH_WORK_LIMIT;
+
+	memset(&prx_queue->s, 0, sizeof(struct bspveth_rxtx_statis));
+
+	return 0;
+
+alloc_failed:
+	return -ENOMEM;
+}
+
+void bspveth_free_rx_resources(struct bspveth_device *pvethdev,
+			       struct bspveth_rxtx_q *prx_queue)
+{
+	unsigned long size;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+
+	if (!pvethdev || !prx_queue)
+		return;
+
+	pbdinfobase_v = prx_queue->pbdinfobase_v;
+	if (!pbdinfobase_v)
+		return;
+
+	if (!prx_queue->pbdbase_v)
+		return;
+
+	size = sizeof(struct bspveth_bd_info) * prx_queue->count;
+	memset(prx_queue->pbdinfobase_v, 0, size);
+
+	/* Zero out the descriptor ring */
+	memset(prx_queue->pbdbase_v, 0, prx_queue->size);
+
+	vfree(prx_queue->pbdinfobase_v);
+	prx_queue->pbdinfobase_v = NULL;
+
+	kfree(prx_queue->pbdbase_v);
+	prx_queue->pbdbase_v = NULL;
+
+	VETH_LOG(DLOG_DEBUG, "bspveth free rx resources ok!!count=%d\n",
+		 prx_queue->count);
+}
+
+s32 bspveth_setup_all_rx_resources(struct bspveth_device *pvethdev)
+{
+	int qid, i, err = 0;
+	struct bspveth_shmq_hd *shmq_head = NULL;
+	u8 *shmq_head_p = NULL;
+
+	if (!pvethdev)
+		return BSP_ERR_NULL_POINTER;
+
+	for (qid = 0; qid < MAX_QUEUE_NUM; qid++) {
+		pvethdev->prx_queue[qid] =
+			kmalloc(sizeof(*pvethdev->prx_queue[qid]), GFP_KERNEL);
+		if (!pvethdev->prx_queue[qid]) {
+			VETH_LOG(DLOG_ERROR,
+				 "kmalloc failed for prx_queue[%d]\n", qid);
+
+			goto failed;
+		}
+
+		memset(pvethdev->prx_queue[qid], 0,
+		       sizeof(struct bspveth_rxtx_q));
+
+		shmq_head = (struct bspveth_shmq_hd *)(pvethdev->pshmpool_v +
+			     MAX_SHAREQUEUE_SIZE * (qid + 1));
+
+		pvethdev->prx_queue[qid]->pshmqhd_v = shmq_head;
+		shmq_head_p =
+			pvethdev->pshmpool_p + MAX_SHAREQUEUE_SIZE * (qid + 1);
+		pvethdev->prx_queue[qid]->pshmqhd_p = shmq_head_p;
+		pvethdev->prx_queue[qid]->pshmbdbase_v =
+			(struct bspveth_dma_shmbd *)((BSP_VETH_T)(shmq_head)
+			+ BSPVETH_SHMBDBASE_OFFSET);
+		pvethdev->prx_queue[qid]->pshmbdbase_p =
+			(u8 *)((BSP_VETH_T)(shmq_head_p)
+			+ BSPVETH_SHMBDBASE_OFFSET);
+		pvethdev->prx_queue[qid]->pdmalbase_v =
+			(struct bspveth_dmal *)((BSP_VETH_T)(shmq_head)
+			+ SHMDMAL_OFFSET);
+		pvethdev->prx_queue[qid]->pdmalbase_p =
+			(u8 *)(u64)(VETH_SHAREPOOL_BASE_INBMC
+			+ MAX_SHAREQUEUE_SIZE * (qid + 1)
+			+ SHMDMAL_OFFSET);
+		memset(pvethdev->prx_queue[qid]->pdmalbase_v, 0,
+		       MAX_SHMDMAL_SIZE);
+
+		err = bspveth_setup_rx_resources(pvethdev,
+						 pvethdev->prx_queue[qid]);
+		if (err) {
+			kfree(pvethdev->prx_queue[qid]);
+			pvethdev->prx_queue[qid] = NULL;
+			VETH_LOG(DLOG_ERROR,
+				 "Allocation for Rx Queue %u failed\n", qid);
+
+			goto failed;
+		}
+	}
+
+	return 0;
+failed:
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		bspveth_free_rx_resources(pvethdev, pvethdev->prx_queue[i]);
+		kfree(pvethdev->prx_queue[i]);
+		pvethdev->prx_queue[i] = NULL;
+	}
+	return err;
+}
+
+void bspveth_free_all_rx_resources(struct bspveth_device *pvethdev)
+{
+	int i;
+
+	if (!pvethdev)
+		return;
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		if (pvethdev->prx_queue[i]) {
+			bspveth_free_rx_resources(pvethdev,
+						  pvethdev->prx_queue[i]);
+		}
+
+		kfree(pvethdev->prx_queue[i]);
+		pvethdev->prx_queue[i] = NULL;
+	}
+}
+
+s32 bspveth_dev_install(void)
+{
+	int err;
+
+	err = bspveth_setup_all_rx_resources(&g_bspveth_dev);
+	if (err != BSP_OK) {
+		err = -1;
+		goto err_setup_rx;
+	}
+
+	err = bspveth_setup_all_tx_resources(&g_bspveth_dev);
+	if (err != BSP_OK) {
+		err = -1;
+		goto err_setup_tx;
+	}
+
+	err = bspveth_setup_all_rx_skb(&g_bspveth_dev);
+	if (err != BSP_OK) {
+		err = -1;
+		goto err_setup_rx_skb;
+	}
+
+	return BSP_OK;
+
+err_setup_rx_skb:
+	bspveth_free_all_tx_resources(&g_bspveth_dev);
+
+err_setup_tx:
+	bspveth_free_all_rx_resources(&g_bspveth_dev);
+
+err_setup_rx:
+
+	return err;
+}
+
+s32 bspveth_dev_uninstall(void)
+{
+	int err = BSP_OK;
+
+	/* Free all the Rx ring pages */
+	bspveth_free_all_rx_skb(&g_bspveth_dev);
+
+	bspveth_free_all_tx_resources(&g_bspveth_dev);
+
+	VETH_LOG(DLOG_DEBUG, "bspveth_free_all_tx_resources ok\n");
+
+	bspveth_free_all_rx_resources(&g_bspveth_dev);
+
+	VETH_LOG(DLOG_DEBUG, "bspveth_free_all_rx_resources ok\n");
+
+	return err;
+}
+
+s32 veth_open(struct net_device *pstr_dev)
+{
+	s32 ret = BSP_OK;
+
+	if (!pstr_dev)
+		return -1;
+
+	if (!g_bspveth_dev.pnetdev)
+		g_bspveth_dev.pnetdev = pstr_dev;
+
+	ret = bspveth_dev_install();
+	if (ret != BSP_OK) {
+		ret = -1;
+		goto failed1;
+	}
+
+	veth_skbtimer_init();
+
+	veth_dmatimer_init_H();
+
+	ret = bma_intf_register_int_notifier(&g_veth_int_nb);
+	if (ret != BSP_OK) {
+		ret = -1;
+		goto failed2;
+	}
+
+	bma_intf_set_open_status(g_bspveth_dev.bma_priv, DEV_OPEN);
+
+	g_bspveth_dev.prx_queue[0]->pshmqhd_v->tail =
+				g_bspveth_dev.prx_queue[0]->pshmqhd_v->head;
+
+	bma_intf_int_to_bmc(g_bspveth_dev.bma_priv);
+
+	netif_start_queue(g_bspveth_dev.pnetdev);
+	netif_carrier_on(pstr_dev);
+
+	return BSP_OK;
+
+failed2:
+	veth_dmatimer_close_H();
+
+	veth_skbtimer_close();
+
+	(void)bspveth_dev_uninstall();
+
+failed1:
+	return ret;
+}
+
+s32 veth_close(struct net_device *pstr_dev)
+{
+	(void)bma_intf_unregister_int_notifier(&g_veth_int_nb);
+
+	netif_carrier_off(pstr_dev);
+
+	bma_intf_set_open_status(g_bspveth_dev.bma_priv, DEV_CLOSE);
+
+	netif_stop_queue(g_bspveth_dev.pnetdev);
+
+	(void)veth_dmatimer_close_H();
+	(void)veth_skbtimer_close();
+
+	(void)bspveth_dev_uninstall();
+
+	return BSP_OK;
+}
+
+s32 veth_config(struct net_device *pstr_dev, struct ifmap *pstr_map)
+{
+	if (!pstr_dev || !pstr_map)
+		return BSP_ERR_NULL_POINTER;
+
+	/* can't act on a running interface */
+	if (pstr_dev->flags & IFF_UP)
+		return -EBUSY;
+
+	/* Don't allow changing the I/O address */
+	if (pstr_map->base_addr != pstr_dev->base_addr)
+		return -EOPNOTSUPP;
+
+	/* ignore other fields */
+	return BSP_OK;
+}
+
+void bspveth_initstatis(void)
+{
+	int i;
+	struct bspveth_rxtx_q *prx_queue = NULL;
+	struct bspveth_rxtx_q *ptx_queue = NULL;
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		prx_queue = g_bspveth_dev.prx_queue[i];
+		ptx_queue = g_bspveth_dev.ptx_queue[i];
+
+		if (prx_queue && ptx_queue) {
+			memset(&prx_queue->s,
+			       0, sizeof(struct bspveth_rxtx_statis));
+
+			memset(&ptx_queue->s,
+			       0, sizeof(struct bspveth_rxtx_statis));
+		} else {
+			VETH_LOG(DLOG_ERROR,
+				 "prx_queue OR ptx_queue is NULL\n");
+		}
+	}
+
+	VETH_LOG(DLOG_DEBUG, "bspveth initstatis ok\n");
+}
+
+s32 veth_ioctl(struct net_device *pstr_dev, struct ifreq *pifr, s32 l_cmd)
+{
+	return -EFAULT;
+}
+
+struct net_device_stats *veth_stats(struct net_device *pstr_dev)
+{
+	return &g_bspveth_dev.stats;
+}
+
+s32 veth_mac_set(struct net_device *pstr_dev, void *p_mac)
+{
+	struct sockaddr *str_addr = NULL;
+	u8 *puc_mac = NULL;
+
+	if (!pstr_dev || !p_mac)
+		return BSP_ERR_NULL_POINTER;
+
+	str_addr = (struct sockaddr *)p_mac;
+	puc_mac = (u8 *)str_addr->sa_data;
+
+	pstr_dev->dev_addr[0] = puc_mac[0];
+	pstr_dev->dev_addr[1] = puc_mac[1];
+	pstr_dev->dev_addr[2] = puc_mac[2];
+	pstr_dev->dev_addr[3] = puc_mac[3];
+	pstr_dev->dev_addr[4] = puc_mac[4];
+	pstr_dev->dev_addr[5] = puc_mac[5];
+
+	return BSP_OK;
+}
+
+void veth_tx_timeout(struct net_device *pstr_dev)
+{
+	VETH_LOG(DLOG_ERROR, "enter.\n");
+}
+
+static u32 veth_ethtool_get_link(struct net_device *dev)
+{
+	if (!bma_intf_is_link_ok() || !netif_running(g_bspveth_dev.pnetdev))
+		return 0;
+
+	if (g_bspveth_dev.ptx_queue[0] &&
+	    g_bspveth_dev.ptx_queue[0]->pshmqhd_v)
+		return (u32)((BSPVETH_SHMQUEUE_INITOK ==
+			     g_bspveth_dev.ptx_queue[0]->pshmqhd_v->init) &&
+			     netif_carrier_ok(dev));
+
+	return 0;
+}
+
+static void veth_ethtool_get_drvinfo(struct net_device *dev,
+				     struct ethtool_drvinfo *info)
+{
+	strlcpy(info->driver, MODULE_NAME, sizeof(info->driver));
+	strlcpy(info->version, VETH_VERSION, sizeof(info->version));
+
+	info->n_stats = VETH_GLOBAL_STATS_LEN;
+}
+
+static void veth_ethtool_get_stats(struct net_device *netdev,
+				   struct ethtool_stats *tool_stats, u64 *data)
+{
+	unsigned int i = 0;
+	char *p = NULL;
+	const struct veth_stats *p_stat = veth_gstrings_stats;
+	struct bspveth_rxtx_q *ptx_node = g_bspveth_dev.ptx_queue[0];
+	struct bspveth_rxtx_q *prx_node = g_bspveth_dev.prx_queue[0];
+	char * const pstat_map[] = {
+		/* QUEUE TX STATS*/
+		GET_QUEUE_STAT(ptx_node, p_stat),
+		/* QUEUE RX STATS*/
+		GET_QUEUE_STAT(prx_node, p_stat),
+		/* VETH STATS */
+		(char *)&g_bspveth_dev + p_stat->stat_offset,
+		/* SHMQ TX STATS */
+		GET_SHM_QUEUE_STAT(ptx_node, p_stat),
+		/* SHMQ RX STATS */
+		GET_SHM_QUEUE_STAT(prx_node, p_stat),
+		/* NET STATS */
+		(char *)&g_bspveth_dev + p_stat->stat_offset
+	};
+
+	if (!data || !netdev || !tool_stats)
+		return;
+
+	for (i = 0; i < VETH_GLOBAL_STATS_LEN; i++) {
+		p = NULL;
+
+		if (p_stat->type > NET_STATS)
+			break;
+
+		p = pstat_map[p_stat->type];
+
+		data[i] = GET_STATS_VALUE(p, p_stat);
+
+		p_stat++;
+	}
+}
+
+static void veth_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+{
+	u8 *p = data;
+	unsigned int i;
+
+	if (!p)
+		return;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < VETH_GLOBAL_STATS_LEN; i++) {
+			memcpy(p, veth_gstrings_stats[i].stat_string,
+			       ETH_GSTRING_LEN);
+
+			p += ETH_GSTRING_LEN;
+		}
+
+		break;
+	}
+}
+
+static int veth_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return VETH_GLOBAL_STATS_LEN;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+const struct ethtool_ops veth_ethtool_ops = {
+	.get_drvinfo = veth_ethtool_get_drvinfo,
+	.get_link = veth_ethtool_get_link,
+
+	.get_ethtool_stats = veth_ethtool_get_stats,
+	.get_strings = veth_get_strings,
+	.get_sset_count = veth_get_sset_count,
+
+};
+
+static const struct net_device_ops veth_ops = {
+	.ndo_open = veth_open,
+	.ndo_stop = veth_close,
+	.ndo_set_config = veth_config,
+	.ndo_start_xmit = veth_tx,
+	.ndo_do_ioctl = veth_ioctl,
+	.ndo_get_stats = veth_stats,
+	.ndo_set_mac_address = veth_mac_set,
+	.ndo_tx_timeout = veth_tx_timeout,
+};
+
+void veth_netdev_func_init(struct net_device *dev)
+{
+	struct tag_pcie_comm_priv *priv =
+				(struct tag_pcie_comm_priv *)netdev_priv(dev);
+
+	VETH_LOG(DLOG_DEBUG, "eth init start\n");
+
+	ether_setup(dev);
+
+	dev->netdev_ops = &veth_ops;
+
+	dev->watchdog_timeo = BSPVETH_NET_TIMEOUT;
+	dev->mtu = BSPVETH_MTU_MAX;
+	dev->flags = IFF_BROADCAST;
+	dev->tx_queue_len = BSPVETH_MAX_QUE_DEEP;
+	dev->ethtool_ops = &veth_ethtool_ops;
+
+	/* Then, initialize the priv field. This encloses the statistics
+	 * and a few private fields.
+	 */
+	memset(priv, 0, sizeof(struct tag_pcie_comm_priv));
+	strncpy(priv->net_type, MODULE_NAME, NET_TYPE_LEN);
+
+	/*9C:7D:A3:28:6F:F9*/
+	dev->dev_addr[0] = 0x9c;
+	dev->dev_addr[1] = 0x7d;
+	dev->dev_addr[2] = 0xa3;
+	dev->dev_addr[3] = 0x28;
+	dev->dev_addr[4] = 0x6f;
+	dev->dev_addr[5] = 0xf9;
+
+	VETH_LOG(DLOG_DEBUG, "set veth MAC addr OK\n");
+}
+
+s32 veth_send_one_pkt(struct sk_buff *skb, int queue)
+{
+	u32 head, next_to_free;
+	dma_addr_t dma = 0;
+	u32 off = 0;
+	int ret = 0;
+	int type = BSPVETH_TX;
+	struct bspveth_bd_info *pbdinfo_v = NULL;
+	struct bspveth_dma_bd *pbd_v = NULL;
+	struct bspveth_rxtx_q *ptx_queue = g_bspveth_dev.ptx_queue[queue];
+
+	if (!skb || !ptx_queue || !ptx_queue->pbdinfobase_v ||
+	    !ptx_queue->pbdbase_v) {
+		INC_STATIS_RXTX(queue, null_point, 1, type);
+		return BSP_ERR_NULL_POINTER;
+	}
+
+	if (!bma_intf_is_link_ok() ||
+	    ptx_queue->pshmqhd_v->init != BSPVETH_SHMQUEUE_INITOK)
+		return -1;
+
+	head = ptx_queue->head;
+	next_to_free = ptx_queue->next_to_free;
+
+	/* stop to send pkt when queue is going to full */
+	if (!JUDGE_TX_QUEUE_SPACE(head, next_to_free, 3)) {
+		netif_stop_subqueue(g_bspveth_dev.pnetdev, queue);
+		VETH_LOG(DLOG_DEBUG,
+			 "going to full, head: %d, nex to free: %d\n",
+				head, next_to_free);
+	}
+
+	if (!JUDGE_TX_QUEUE_SPACE(head, next_to_free, 1))
+		return BSP_NETDEV_TX_BUSY;
+
+	if (skb_shinfo(skb)->nr_frags) {
+		/* We don't support frags */
+		ret = skb_linearize(skb);
+		if (ret)
+			return -ENOMEM;
+	}
+
+	dma = dma_map_single(&g_bspveth_dev.ppcidev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
+
+	ret = DMA_MAPPING_ERROR(&g_bspveth_dev.ppcidev->dev, dma);
+	if (ret != BSP_OK) {
+		ret = BSP_ERR_DMA_ERR;
+		g_bspveth_dev.ptx_queue[queue]->s.dma_mapping_err++;
+		goto failed;
+	}
+
+	off = dma & 0x3;
+	if (off)
+		g_bspveth_dev.ptx_queue[queue]->s.dma_need_offset++;
+
+	pbdinfo_v = &ptx_queue->pbdinfobase_v[head];
+	pbdinfo_v->pdma_v = skb;
+	pbd_v = &ptx_queue->pbdbase_v[head];
+	pbd_v->dma_p = dma & (~((u64)0x3));
+	pbd_v->off = off;
+	pbd_v->len = skb->len;
+
+	head = (head + 1) & BSPVETH_POINT_MASK;
+	ptx_queue->head = head;
+
+	VETH_LOG(DLOG_DEBUG,
+		 "[send]:oridma=0x%llx,skb=%p,skb->data=%p,skb->len=%d,",
+		 (u64)dma, skb, skb->data, skb->len);
+	VETH_LOG(DLOG_DEBUG, "head=%d,off=%d, alidma0x%llx\n", head, off,
+		 (u64)(dma & (~((u64)0x3))));
+
+	return BSP_OK;
+
+failed:
+	return ret;
+}
+
+int veth_tx(struct sk_buff *skb, struct net_device *pstr_dev)
+{
+	u32 ul_ret = 0;
+	int queue = 0;
+
+	VETH_LOG(DLOG_DEBUG, "===============enter==================\n");
+
+	if (!skb || !pstr_dev) {
+		g_bspveth_dev.ptx_queue[queue]->s.null_point++;
+		return NETDEV_TX_OK;
+	}
+
+	VETH_LOG(DLOG_DEBUG, "skb->data=%p\n", skb->data);
+	VETH_LOG(DLOG_DEBUG, "skb->len=%d\n", skb->len);
+
+	ul_ret = veth_send_one_pkt(skb, queue);
+
+	if (ul_ret == BSP_OK) {
+		g_bspveth_dev.ptx_queue[queue]->s.pkt++;
+		g_bspveth_dev.stats.tx_packets++;
+		g_bspveth_dev.ptx_queue[queue]->s.pktbyte += skb->len;
+		g_bspveth_dev.stats.tx_bytes += skb->len;
+
+#ifndef USE_TASKLET
+		(void)mod_timer(&g_bspveth_dev.dmatimer, jiffies_64);
+#else
+		tasklet_hi_schedule(&g_bspveth_dev.dma_task);
+#endif
+
+	} else {
+		VETH_LOG(DLOG_DEBUG, "=======exit ret = %d=======\n", ul_ret);
+		g_bspveth_dev.ptx_queue[queue]->s.dropped_pkt++;
+		g_bspveth_dev.stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+
+	return NETDEV_TX_OK;
+}
+
+s32 veth_free_txskb(struct bspveth_rxtx_q *ptx_queue, int queue)
+{
+	int i, work_limit;
+	unsigned int tail, next_to_free;
+	struct bspveth_bd_info *ptx_bdinfo_v = NULL;
+	struct sk_buff *skb = NULL;
+	struct bspveth_dma_bd *pbd_v = NULL;
+
+	if (!ptx_queue)
+		return BSP_ERR_AGAIN;
+
+	work_limit = ptx_queue->work_limit;
+	tail = ptx_queue->tail;
+	next_to_free = ptx_queue->next_to_free;
+
+	for (i = 0; i < work_limit; i++) {
+		if (next_to_free == tail)
+			break;
+
+		ptx_bdinfo_v = &ptx_queue->pbdinfobase_v[next_to_free];
+
+		pbd_v = &ptx_queue->pbdbase_v[next_to_free];
+
+		skb = ptx_bdinfo_v->pdma_v;
+
+		dma_unmap_single(&g_bspveth_dev.ppcidev->dev,
+				 pbd_v->dma_p | pbd_v->off,
+				 pbd_v->len, DMA_TO_DEVICE);
+
+		if (skb)
+			dev_kfree_skb_any(skb);
+		else
+			VETH_LOG(DLOG_ERROR,
+				 "skb is NULL,tail=%d next_to_free=%d\n",
+				 tail, next_to_free);
+
+		ptx_bdinfo_v->pdma_v = NULL;
+		g_bspveth_dev.ptx_queue[queue]->s.freetx++;
+
+		next_to_free = (next_to_free + 1) & BSPVETH_POINT_MASK;
+	}
+
+	ptx_queue->next_to_free = next_to_free;
+	tail = ptx_queue->tail;
+
+	if (next_to_free != tail) {
+		VETH_LOG(DLOG_DEBUG, "next_to_free(%d) != tail(%d)\n",
+			 next_to_free, tail);
+
+		return BSP_ERR_AGAIN;
+	}
+
+	return BSP_OK;
+}
+
+s32 veth_recv_pkt(struct bspveth_rxtx_q *prx_queue, int queue)
+{
+	int ret = BSP_OK, i, work_limit;
+	u32 tail, head;
+	struct bspveth_bd_info *prx_bdinfo_v = NULL;
+	struct bspveth_dma_bd *pbd_v = NULL;
+	struct sk_buff *skb = NULL;
+	dma_addr_t dma_map = 0;
+	u32 off = 0;
+
+	if (!prx_queue)
+		return BSP_ERR_AGAIN;
+
+	work_limit = prx_queue->work_limit;
+	tail = prx_queue->tail;
+
+	for (i = 0; i < work_limit; i++) {
+		head = prx_queue->head;
+		if (tail == head)
+			break;
+
+		prx_bdinfo_v = &prx_queue->pbdinfobase_v[tail];
+
+		skb = prx_bdinfo_v->pdma_v;
+		if (!skb) {
+			tail = (tail + 1) & BSPVETH_POINT_MASK;
+			continue;
+		}
+
+		prx_bdinfo_v->pdma_v = NULL;
+		pbd_v = &prx_queue->pbdbase_v[tail];
+
+		off = pbd_v->off;
+		if (off)
+			skb_reserve(skb, off);
+
+		dma_unmap_single(&g_bspveth_dev.ppcidev->dev, pbd_v->dma_p,
+				 BSPVETH_SKB_SIZE, DMA_FROM_DEVICE);
+
+		tail = (tail + 1) & BSPVETH_POINT_MASK;
+
+		skb_put(skb, pbd_v->len);
+
+		skb->protocol = eth_type_trans(skb, g_bspveth_dev.pnetdev);
+		skb->ip_summed = CHECKSUM_NONE;
+
+		VETH_LOG(DLOG_DEBUG,
+			 "skb->len=%d,skb->protocol=%d\n",
+			 skb->len, skb->protocol);
+
+		VETH_LOG(DLOG_DEBUG,
+			 "dma_p=0x%llx,dma_map=0x%llx,",
+			 pbd_v->dma_p, dma_map);
+
+		VETH_LOG(DLOG_DEBUG,
+			 "skb=%p,skb->data=%p,skb->len=%d,tail=%d,shm_off=%d\n",
+			 skb, skb->data, skb->len, tail, off);
+
+		VETH_LOG(DLOG_DEBUG,
+			 "skb_transport_header=%p skb_mac_header=%p ",
+			 skb_transport_header(skb), skb_mac_header(skb));
+
+		VETH_LOG(DLOG_DEBUG,
+			 "skb_network_header=%p\n", skb_network_header(skb));
+
+		VETH_LOG(DLOG_DEBUG,
+			 "skb->data=0x%p skb->tail=%08x skb->len=%08x\n",
+			  skb->data,
+			  (unsigned int)skb->tail,
+			  (unsigned int)skb->len);
+
+		g_bspveth_dev.prx_queue[queue]->s.pkt++;
+		g_bspveth_dev.stats.rx_packets++;
+		g_bspveth_dev.prx_queue[queue]->s.pktbyte += skb->len;
+		g_bspveth_dev.stats.rx_bytes += skb->len;
+
+		ret = netif_rx(skb);
+		if (ret == NET_RX_DROP) {
+			g_bspveth_dev.prx_queue[queue]->s.netifrx_err++;
+			g_bspveth_dev.stats.rx_errors++;
+
+			VETH_LOG(DLOG_DEBUG, "netif_rx failed\n");
+		}
+	}
+
+	prx_queue->tail = tail;
+	head = prx_queue->head;
+
+	ret = veth_refill_rxskb(prx_queue, queue);
+	if (ret != BSP_OK)
+		VETH_LOG(DLOG_DEBUG, "veth_refill_rxskb failed\n");
+
+	if (tail != head) {
+		VETH_LOG(DLOG_DEBUG, "tail(%d) != head(%d)\n", tail, head);
+
+		return BSP_ERR_AGAIN;
+	}
+
+	return BSP_OK;
+}
+
+#if !defined(USE_TASKLET) && defined(HAVE_TIMER_SETUP)
+void veth_skbtrtimer_do(struct timer_list *t)
+#else
+void veth_skbtrtimer_do(unsigned long data)
+#endif
+{
+	int ret = 0;
+
+	ret = veth_skb_tr_task();
+	if (ret == BSP_ERR_AGAIN) {
+#ifndef USE_TASKLET
+		(void)mod_timer(&g_bspveth_dev.skbtrtimer, jiffies_64);
+#else
+		tasklet_hi_schedule(&g_bspveth_dev.skb_task);
+#endif
+	}
+}
+
+s32 veth_skbtimer_close(void)
+{
+#ifndef USE_TASKLET
+	(void)del_timer_sync(&g_bspveth_dev.skbtrtimer);
+#else
+	tasklet_kill(&g_bspveth_dev.skb_task);
+#endif
+
+	VETH_LOG(DLOG_DEBUG, "veth skbtimer close ok\n");
+
+	return 0;
+}
+
+void veth_skbtimer_init(void)
+{
+#ifndef USE_TASKLET
+#ifdef HAVE_TIMER_SETUP
+	timer_setup(&g_bspveth_dev.skbtrtimer, veth_skbtrtimer_do, 0);
+#else
+	setup_timer(&g_bspveth_dev.skbtrtimer, veth_skbtrtimer_do,
+		    (unsigned long)&g_bspveth_dev);
+#endif
+	(void)mod_timer(&g_bspveth_dev.skbtrtimer,
+			jiffies_64 + BSPVETH_SKBTIMER_INTERVAL);
+#else
+	tasklet_init(&g_bspveth_dev.skb_task, veth_skbtrtimer_do,
+		     (unsigned long)&g_bspveth_dev);
+#endif
+
+	VETH_LOG(DLOG_DEBUG, "veth skbtimer init OK\n");
+}
+
+void veth_netdev_exit(void)
+{
+	if (g_bspveth_dev.pnetdev) {
+		netif_stop_queue(g_bspveth_dev.pnetdev);
+		unregister_netdev(g_bspveth_dev.pnetdev);
+		free_netdev(g_bspveth_dev.pnetdev);
+
+		VETH_LOG(DLOG_DEBUG, "veth netdev exit OK.\n");
+	} else {
+		VETH_LOG(DLOG_DEBUG, "veth_dev.pnetdev NULL.\n");
+	}
+}
+
+static void veth_shutdown_task(struct work_struct *work)
+{
+	struct net_device *netdev = g_bspveth_dev.pnetdev;
+
+	VETH_LOG(DLOG_ERROR, "veth is going down, please restart it manual\n");
+
+	g_bspveth_dev.shutdown_cnt++;
+
+	if (netif_carrier_ok(netdev)) {
+		(void)bma_intf_unregister_int_notifier(&g_veth_int_nb);
+
+		netif_carrier_off(netdev);
+
+		bma_intf_set_open_status(g_bspveth_dev.bma_priv, DEV_CLOSE);
+
+		/* can't transmit any more */
+		netif_stop_queue(g_bspveth_dev.pnetdev);
+
+		(void)veth_skbtimer_close();
+
+		(void)veth_dmatimer_close_H();
+	}
+}
+
+s32 veth_netdev_init(void)
+{
+	s32 l_ret = 0;
+	struct net_device *netdev = NULL;
+
+	netdev = alloc_netdev_mq(sizeof(struct tag_pcie_comm_priv),
+				 BSPVETH_DEV_NAME, NET_NAME_UNKNOWN,
+				 veth_netdev_func_init, 1);
+
+	/* register netdev */
+	l_ret = register_netdev(netdev);
+	if (l_ret < 0) {
+		VETH_LOG(DLOG_ERROR, "register_netdev failed!ret=%d\n", l_ret);
+
+		return -ENODEV;
+	}
+
+	g_bspveth_dev.pnetdev = netdev;
+
+	VETH_LOG(DLOG_DEBUG, "veth netdev init OK\n");
+
+	INIT_WORK(&g_bspveth_dev.shutdown_task, veth_shutdown_task);
+
+	netif_carrier_off(netdev);
+
+	return BSP_OK;
+}
+
+int veth_skb_tr_task(void)
+{
+	int rett = BSP_OK;
+	int retr = BSP_OK;
+	int i = 0;
+	int task_state = BSP_OK;
+	struct bspveth_rxtx_q *ptx_queue = NULL;
+	struct bspveth_rxtx_q *prx_queue = NULL;
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		prx_queue = g_bspveth_dev.prx_queue[i];
+		if (prx_queue) {
+			g_bspveth_dev.run_skb_rx_task++;
+			retr = veth_recv_pkt(prx_queue, i);
+		}
+
+		ptx_queue = g_bspveth_dev.ptx_queue[i];
+		if (ptx_queue) {
+			g_bspveth_dev.run_skb_fr_task++;
+			rett = veth_free_txskb(ptx_queue, i);
+			if (__netif_subqueue_stopped
+				(g_bspveth_dev.pnetdev, i) &&
+				JUDGE_TX_QUEUE_SPACE
+					(ptx_queue->head,
+					 ptx_queue->next_to_free, 5)) {
+				netif_wake_subqueue(g_bspveth_dev.pnetdev, i);
+				VETH_LOG(DLOG_DEBUG, "queue is free, ");
+				VETH_LOG(DLOG_DEBUG,
+					 "head: %d, next to free: %d\n",
+					 ptx_queue->head,
+					 ptx_queue->next_to_free);
+			}
+		}
+
+		if (rett == BSP_ERR_AGAIN || retr == BSP_ERR_AGAIN)
+			task_state = BSP_ERR_AGAIN;
+	}
+
+	return task_state;
+}
+
+static int veth_int_handler(struct notifier_block *pthis, unsigned long ev,
+			    void *unuse)
+{
+	g_bspveth_dev.recv_int++;
+
+	if (netif_running(g_bspveth_dev.pnetdev)) {
+#ifndef USE_TASKLET
+		(void)mod_timer(&g_bspveth_dev.dmatimer, jiffies_64);
+#else
+		tasklet_schedule(&g_bspveth_dev.dma_task);
+
+#endif
+	} else {
+		VETH_LOG(DLOG_DEBUG, "netif is not running\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+#if !defined(USE_TASKLET) && defined(HAVE_TIMER_SETUP)
+void veth_dma_tx_timer_do_H(struct timer_list *t)
+#else
+void veth_dma_tx_timer_do_H(unsigned long data)
+#endif
+{
+	int txret, rxret;
+
+	txret = veth_dma_task_H(BSPVETH_TX);
+
+	rxret = veth_dma_task_H(BSPVETH_RX);
+
+	if (txret == BSP_ERR_AGAIN || rxret == BSP_ERR_AGAIN) {
+#ifndef USE_TASKLET
+		(void)mod_timer(&g_bspveth_dev.dmatimer, jiffies_64);
+#else
+		tasklet_hi_schedule(&g_bspveth_dev.dma_task);
+#endif
+	}
+}
+
+s32 veth_dmatimer_close_H(void)
+{
+#ifndef USE_TASKLET
+	(void)del_timer_sync(&g_bspveth_dev.dmatimer);
+#else
+	tasklet_kill(&g_bspveth_dev.dma_task);
+#endif
+
+	VETH_LOG(DLOG_DEBUG, "bspveth_dmatimer_close RXTX TIMER ok\n");
+
+	return 0;
+}
+
+void veth_dmatimer_init_H(void)
+{
+#ifndef USE_TASKLET
+#ifdef HAVE_TIMER_SETUP
+	timer_setup(&g_bspveth_dev.dmatimer, veth_dma_tx_timer_do_H, 0);
+#else
+	setup_timer(&g_bspveth_dev.dmatimer, veth_dma_tx_timer_do_H,
+		    (unsigned long)&g_bspveth_dev);
+#endif
+	(void)mod_timer(&g_bspveth_dev.dmatimer,
+			jiffies_64 + BSPVETH_DMATIMER_INTERVAL);
+#else
+	tasklet_init(&g_bspveth_dev.dma_task, veth_dma_tx_timer_do_H,
+		     (unsigned long)&g_bspveth_dev);
+#endif
+
+	VETH_LOG(DLOG_DEBUG, "bspveth_dmatimer_init RXTX TIMER OK\n");
+}
+
+s32 dmacmp_err_deal(struct bspveth_rxtx_q *prxtx_queue, u32 queue,
+		    u32 type)
+{
+	prxtx_queue->dmacmperr = 0;
+	prxtx_queue->start_dma = 0;
+
+	(void)veth_reset_dma(type);
+
+	if (type == BSPVETH_RX) {
+		VETH_LOG(DLOG_DEBUG,
+			 "bmc->host dma time out,dma count:%d,work_limit:%d\n",
+			 prxtx_queue->dmal_cnt,
+			 prxtx_queue->work_limit);
+
+		g_bspveth_dev.prx_queue[queue]->s.dma_failed++;
+	} else {
+		VETH_LOG(DLOG_DEBUG,
+			 "host->bmc dma time out,dma count:%d,work_limit:%d\n",
+			 prxtx_queue->dmal_cnt,
+			 prxtx_queue->work_limit);
+
+		g_bspveth_dev.ptx_queue[queue]->s.dma_failed++;
+	}
+
+	if (prxtx_queue->dmal_cnt > 1)
+		prxtx_queue->work_limit = (prxtx_queue->dmal_cnt >> 1);
+
+	prxtx_queue->dma_overtime++;
+	if (prxtx_queue->dma_overtime > BSPVETH_MAX_QUE_DEEP) {
+		schedule_work(&g_bspveth_dev.shutdown_task);
+
+		return -EFAULT;
+	}
+
+	return BSP_OK;
+}
+
+s32 veth_check_dma_status(struct bspveth_rxtx_q *prxtx_queue,
+			  u32 queue, u32 type)
+{
+	int i = 0;
+	enum dma_direction_e dir;
+
+	dir = GET_DMA_DIRECTION(type);
+
+	for (i = 0; i < BSPVETH_CHECK_DMA_STATUS_TIMES; i++) {
+		if (bma_intf_check_dma_status(dir) == BSPVETH_DMA_OK)
+			break;
+
+		cpu_relax();
+
+		if (i > 20)
+			udelay(5);
+	}
+
+	if (i >= BSPVETH_CHECK_DMA_STATUS_TIMES) {
+		INC_STATIS_RXTX(queue, dma_busy, 1, type);
+		prxtx_queue->dmacmperr++;
+
+		return -EFAULT;
+	}
+
+	return BSP_OK;
+}
+
+s32 __check_dmacmp_H(struct bspveth_rxtx_q *prxtx_queue, u32 queue,
+		     u32 type)
+{
+	u16 start_dma = 0;
+	u16 dmacmperr = 0;
+	u32 cnt = 0;
+	u32 len = 0;
+	u32 host_head = 0;
+	u32 host_tail = 0;
+	u32 shm_head = 0;
+	u32 shm_tail = 0;
+	s32 ret = 0;
+	struct bspveth_shmq_hd *pshmq_head = NULL;
+
+	if (!prxtx_queue || !prxtx_queue->pshmqhd_v)
+		return BSP_ERR_NULL_POINTER;
+
+	pshmq_head = prxtx_queue->pshmqhd_v;
+	dmacmperr = prxtx_queue->dmacmperr;
+	start_dma = prxtx_queue->start_dma;
+	if (!start_dma)
+		return BSP_OK;
+
+	if (dmacmperr > BSPVETH_WORK_LIMIT / 4)
+		return dmacmp_err_deal(prxtx_queue, queue, type);
+
+	ret = veth_check_dma_status(prxtx_queue, queue, type);
+	if (ret != BSP_OK)
+		return ret;
+
+	prxtx_queue->start_dma = 0;
+	prxtx_queue->dma_overtime = 0;
+
+	if (type == BSPVETH_RX) {
+		cnt = prxtx_queue->dmal_cnt;
+		len = prxtx_queue->dmal_byte;
+
+		host_head = prxtx_queue->head;
+		shm_tail = pshmq_head->tail;
+
+		pshmq_head->tail = (shm_tail + cnt) & BSPVETH_POINT_MASK;
+		prxtx_queue->head = (host_head + cnt) & BSPVETH_POINT_MASK;
+
+		g_bspveth_dev.prx_queue[queue]->s.dmapkt += cnt;
+		g_bspveth_dev.prx_queue[queue]->s.dmapktbyte += len;
+	} else {
+		cnt = prxtx_queue->dmal_cnt;
+		len = prxtx_queue->dmal_byte;
+
+		host_tail = prxtx_queue->tail;
+		shm_head = pshmq_head->head;
+
+		prxtx_queue->tail = (host_tail + cnt) & BSPVETH_POINT_MASK;
+		pshmq_head->head = (shm_head + cnt) & BSPVETH_POINT_MASK;
+
+		g_bspveth_dev.ptx_queue[queue]->s.dmapkt += cnt;
+		g_bspveth_dev.ptx_queue[queue]->s.dmapktbyte += len;
+	}
+
+#ifndef USE_TASKLET
+	(void)mod_timer(&g_bspveth_dev.skbtrtimer, jiffies_64);
+#else
+	tasklet_hi_schedule(&g_bspveth_dev.skb_task);
+#endif
+
+	(void)bma_intf_int_to_bmc(g_bspveth_dev.bma_priv);
+
+	g_bspveth_dev.tobmc_int++;
+
+	return BSP_OK;
+}
+
+s32 __checkspace_H(struct bspveth_rxtx_q *prxtx_queue, u32 queue,
+		   u32 type, u32 *pcnt)
+{
+	int ret = BSP_OK;
+	u32 host_head, host_tail, host_nextfill;
+	u32 shm_head, shm_tail, shm_nextfill;
+	u32 shm_cnt, host_cnt, cnt_tmp, cnt;
+	struct bspveth_shmq_hd *pshmq_head = NULL;
+
+	if (!prxtx_queue || !prxtx_queue->pshmqhd_v)
+		return BSP_ERR_NULL_POINTER;
+
+	pshmq_head = prxtx_queue->pshmqhd_v;
+	host_head = prxtx_queue->head;
+	host_tail = prxtx_queue->tail;
+	host_nextfill = prxtx_queue->next_to_fill;
+	shm_head = pshmq_head->head;
+	shm_tail = pshmq_head->tail;
+	shm_nextfill = pshmq_head->next_to_fill;
+
+	switch (type) {
+	case BSPVETH_RX:
+		if (shm_tail == shm_head) {
+			INC_STATIS_RXTX(queue, shm_emp, 1, type);
+			ret = BSP_ERR_NOT_TO_HANDLE;
+			goto failed;
+		}
+
+		if (!JUDGE_RX_QUEUE_SPACE(host_head, host_nextfill, 1))
+			return -EFAULT;
+
+		shm_cnt = (shm_head - shm_tail) & BSPVETH_POINT_MASK;
+		cnt_tmp = min(shm_cnt, prxtx_queue->work_limit);
+
+		host_cnt = (host_nextfill - host_head) & BSPVETH_POINT_MASK;
+		cnt = min(cnt_tmp, host_cnt);
+
+		break;
+
+	case BSPVETH_TX:
+		if (host_tail == host_head) {
+			INC_STATIS_RXTX(queue, q_emp, 1, type);
+			ret = BSP_ERR_NOT_TO_HANDLE;
+			goto failed;
+		}
+
+		if (!JUDGE_TX_QUEUE_SPACE(shm_head, shm_nextfill, 1))
+			return -EFAULT;
+
+		host_cnt = (host_head - host_tail) & BSPVETH_POINT_MASK;
+		cnt_tmp = min(host_cnt, prxtx_queue->work_limit);
+		shm_cnt = (shm_nextfill - (shm_head + 1)) & BSPVETH_POINT_MASK;
+		cnt = min(cnt_tmp, shm_cnt);
+
+		break;
+
+	default:
+		INC_STATIS_RXTX(queue, type_err, 1, type);
+		ret = -EFAULT;
+		goto failed;
+	}
+
+	if (cnt > (BSPVETH_DMABURST_MAX * 7 / 8))
+		INC_STATIS_RXTX(queue, dma_burst, 1, type);
+
+#ifdef __UT_TEST
+	if (g_testdma) {
+		VETH_LOG(DLOG_ERROR,
+			 "[type %d],host_cnt=%d cnt_tmp=%d shm_cnt=%d cnt=%d\n",
+			 type, host_cnt, cnt_tmp, shm_cnt, cnt);
+	}
+#endif
+
+	*pcnt = cnt;
+
+	return BSP_OK;
+
+failed:
+	return ret;
+}
+
+int __make_dmalistbd_h2b_H(struct bspveth_rxtx_q *prxtx_queue,
+			   u32 cnt, u32 type)
+{
+	u32 i = 0;
+	u32 len = 0;
+	u32 host_tail = 0;
+	u32 shm_head = 0;
+	u32 off = 0;
+	struct bspveth_dmal *pdmalbase_v = NULL;
+	struct bspveth_shmq_hd *pshmq_head = NULL;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+	struct bspveth_dma_bd *pbdbase_v = NULL;
+	struct bspveth_dma_shmbd *pshmbdbase_v = NULL;
+
+	if (!prxtx_queue)
+		return BSP_ERR_NULL_POINTER;
+
+	pdmalbase_v = prxtx_queue->pdmalbase_v;
+	pshmq_head = prxtx_queue->pshmqhd_v;
+	pbdinfobase_v = prxtx_queue->pbdinfobase_v;
+	pbdbase_v = prxtx_queue->pbdbase_v;
+	pshmbdbase_v = prxtx_queue->pshmbdbase_v;
+	if (!pdmalbase_v || !pshmq_head || !pbdinfobase_v ||
+	    !pbdbase_v || !pshmbdbase_v)
+		return BSP_ERR_NULL_POINTER;
+
+	host_tail = prxtx_queue->tail;
+	shm_head = pshmq_head->head;
+
+	for (i = 0; i < cnt; i++) {
+		off = pbdbase_v[QUEUE_MASK(host_tail + i)].off;
+
+		if (i == (cnt - 1))
+			pdmalbase_v[i].chl = 0x9;
+		else
+			pdmalbase_v[i].chl = 0x0000001;
+		pdmalbase_v[i].len =
+		    (pbdinfobase_v[QUEUE_MASK(host_tail + i)].pdma_v)->len;
+		pdmalbase_v[i].slow =
+		    lower_32_bits(pbdbase_v[QUEUE_MASK(host_tail + i)].dma_p);
+		pdmalbase_v[i].shi =
+		    upper_32_bits(pbdbase_v[QUEUE_MASK(host_tail + i)].dma_p);
+		pdmalbase_v[i].dlow =
+		    lower_32_bits(pshmbdbase_v[QUEUE_MASK(shm_head + i)].dma_p);
+		pdmalbase_v[i].dhi = 0;
+
+		pshmbdbase_v[QUEUE_MASK(shm_head + i)].len = pdmalbase_v[i].len;
+
+		pdmalbase_v[i].len += off;
+
+		pshmbdbase_v[QUEUE_MASK(shm_head + i)].off = off;
+
+		len += pdmalbase_v[i].len;
+
+#ifdef __UT_TEST
+		if (g_testdma) {
+			struct sk_buff *skb =
+				pbdinfobase_v[QUEUE_MASK(host_tail + i)].pdma_v;
+
+			VETH_LOG(DLOG_ERROR,
+				 "[%d][makebd-H2B]:chl=0x%x,len=%d,slow=0x%x,",
+				 i, pdmalbase_v[i].chl, pdmalbase_v[i].len,
+				 pdmalbase_v[i].slow);
+			VETH_LOG(DLOG_ERROR,
+				 "shi=0x%x,dlow=0x%x,dhi=0x%x,skb=%p,",
+				 pdmalbase_v[i].shi, pdmalbase_v[i].dlow,
+				 pdmalbase_v[i].dhi, skb);
+			VETH_LOG(DLOG_ERROR,
+				 "skb->data=%p,skb->len=%d,host_tail+i=%d,",
+				 skb->data, skb->len,
+				 QUEUE_MASK(host_tail + i));
+			VETH_LOG(DLOG_ERROR,
+				 "shm_head+i=%d,off=%d\n",
+				 QUEUE_MASK(shm_head + i), off);
+		}
+#endif
+	}
+
+	pdmalbase_v[i].chl = 0x7;
+	pdmalbase_v[i].len = 0x0;
+	pdmalbase_v[i].slow = lower_32_bits((u64)prxtx_queue->pdmalbase_p);
+	pdmalbase_v[i].shi = upper_32_bits((u64)prxtx_queue->pdmalbase_p);
+	pdmalbase_v[i].dlow = 0;
+	pdmalbase_v[i].dhi = 0;
+
+	prxtx_queue->dmal_cnt = cnt;
+	prxtx_queue->dmal_byte = len;
+
+#ifdef __UT_TEST
+	if (g_testdma) {
+		VETH_LOG(DLOG_ERROR,
+			 "[END][makebd-H2B]:chl=0x%x,len=%d,slow=0x%x,",
+			 pdmalbase_v[i].chl, pdmalbase_v[i].len,
+			 pdmalbase_v[i].slow);
+		VETH_LOG(DLOG_ERROR,
+			 "shi=0x%x,dmal_cnt=%d,dmal_dir=%d,dmal_byte=%d,",
+			 pdmalbase_v[i].shi, cnt, type, len);
+		VETH_LOG(DLOG_ERROR, "pdmalbase_v=%p\n", pdmalbase_v);
+	}
+#endif
+
+	return 0;
+}
+
+int __make_dmalistbd_b2h_H(struct bspveth_rxtx_q *prxtx_queue, u32 cnt,
+			   u32 type)
+{
+	u32 i, len = 0, host_head, shm_tail, off;
+	struct bspveth_dmal *pdmalbase_v = NULL;
+	struct bspveth_shmq_hd *pshmq_head = NULL;
+	struct bspveth_bd_info *pbdinfobase_v = NULL;
+	struct bspveth_dma_bd *pbdbase_v = NULL;
+	struct bspveth_dma_shmbd *pshmbdbase_v = NULL;
+
+	if (!prxtx_queue) {
+		VETH_LOG(DLOG_ERROR,
+			 "[END][makebd-B2H]:prxtx_queue NULL!!!\n");
+		return BSP_ERR_NULL_POINTER;
+	}
+
+	pdmalbase_v = prxtx_queue->pdmalbase_v;
+	pshmq_head = prxtx_queue->pshmqhd_v;
+	pbdinfobase_v = prxtx_queue->pbdinfobase_v;
+	pbdbase_v = prxtx_queue->pbdbase_v;
+	pshmbdbase_v = prxtx_queue->pshmbdbase_v;
+	if (!pdmalbase_v || !pshmq_head || !pbdinfobase_v ||
+	    !pbdbase_v || !pshmbdbase_v) {
+		VETH_LOG(DLOG_ERROR,
+			 "[END][makebd-B2H]:pdmalbase_v NULL!!!\n");
+		return BSP_ERR_NULL_POINTER;
+	}
+
+	host_head = prxtx_queue->head;
+	shm_tail = pshmq_head->tail;
+
+	for (i = 0; i < cnt; i++) {
+		off = pshmbdbase_v[QUEUE_MASK(shm_tail + i)].off;
+		if (i == (cnt - 1))
+			pdmalbase_v[i].chl = 0x9;
+		else
+			pdmalbase_v[i].chl = 0x0000001;
+		pdmalbase_v[i].len = pshmbdbase_v[QUEUE_MASK(shm_tail + i)].len;
+		pdmalbase_v[i].slow =
+		    lower_32_bits(pshmbdbase_v[QUEUE_MASK(shm_tail + i)].dma_p);
+		pdmalbase_v[i].shi = 0;
+		pdmalbase_v[i].dlow =
+		    lower_32_bits(pbdbase_v[QUEUE_MASK(host_head + i)].dma_p);
+		pdmalbase_v[i].dhi =
+		    upper_32_bits(pbdbase_v[QUEUE_MASK(host_head + i)].dma_p);
+		pdmalbase_v[i].len += off;
+
+		pbdbase_v[QUEUE_MASK(host_head + i)].off = off;
+		pbdbase_v[QUEUE_MASK(host_head + i)].len = pdmalbase_v[i].len;
+
+		len += pdmalbase_v[i].len;
+
+#ifdef __UT_TEST
+		if (g_testdma) {
+			struct sk_buff *skb =
+				pbdinfobase_v[QUEUE_MASK(host_head + i)].pdma_v;
+
+			VETH_LOG(DLOG_ERROR,
+				 "[%d][makebd-B2H]:chl=0x%x,len=%d,slow=0x%x,",
+				 i, pdmalbase_v[i].chl, pdmalbase_v[i].len,
+				 pdmalbase_v[i].slow);
+			VETH_LOG(DLOG_ERROR,
+				 "shi=0x%x,dlow=0x%x,dhi=0x%x,skb=%p,",
+				 pdmalbase_v[i].shi, pdmalbase_v[i].dlow,
+				 pdmalbase_v[i].dhi, skb);
+			VETH_LOG(DLOG_ERROR,
+				 "skb->data=%p,skb->len=%d,shm_tail+i=%d,",
+				 skb->data, skb->len,
+				 QUEUE_MASK(shm_tail + i));
+			VETH_LOG(DLOG_ERROR,
+				 "host_head+i=%d,off=%d\n",
+				 QUEUE_MASK(host_head + i), off);
+		}
+#endif
+	}
+
+	pdmalbase_v[i].chl = 0x0000007;
+	pdmalbase_v[i].len = 0x0;
+	pdmalbase_v[i].slow = lower_32_bits((u64)prxtx_queue->pdmalbase_p);
+	pdmalbase_v[i].shi = upper_32_bits((u64)prxtx_queue->pdmalbase_p);
+	pdmalbase_v[i].dlow = 0;
+	pdmalbase_v[i].dhi = 0;
+
+	prxtx_queue->dmal_cnt = cnt;
+	prxtx_queue->dmal_byte = len;
+
+#ifdef __UT_TEST
+	if (g_testdma) {
+		VETH_LOG(DLOG_ERROR,
+			 "[END][makebd-B2H]:chl=0x%x,len=%d,slow=0x%x,",
+			 pdmalbase_v[i].chl, pdmalbase_v[i].len,
+			 pdmalbase_v[i].slow);
+		VETH_LOG(DLOG_ERROR,
+			 "shi=0x%x,dmal_cnt=%d,dmal_dir=%d,dmal_byte=%d ",
+			 pdmalbase_v[i].shi, cnt, type, len);
+		VETH_LOG(DLOG_ERROR, "pdmalbase_v=%p\n", pdmalbase_v);
+	}
+
+#endif
+
+	return 0;
+}
+
+s32 __start_dmalist_H(struct bspveth_rxtx_q *prxtx_queue, u32 cnt, u32 type)
+{
+	int ret = BSP_OK;
+	struct bma_dma_transfer_s dma_transfer = { 0 };
+
+	if (!prxtx_queue)
+		return -1;
+
+	switch (type) {
+	case BSPVETH_RX:
+		ret = __make_dmalistbd_b2h_H(prxtx_queue, cnt, type);
+		if (ret)
+			goto failed;
+		dma_transfer.dir = BMC_TO_HOST;
+
+		break;
+
+	case BSPVETH_TX:
+		ret = __make_dmalistbd_h2b_H(prxtx_queue, cnt, type);
+		if (ret)
+			goto failed;
+		dma_transfer.dir = HOST_TO_BMC;
+
+		break;
+
+	default:
+		ret = -1;
+		goto failed;
+	}
+
+	dma_transfer.type = DMA_LIST;
+	dma_transfer.transfer.list.dma_addr =
+		(dma_addr_t)prxtx_queue->pdmalbase_p;
+
+	ret = bma_intf_start_dma(g_bspveth_dev.bma_priv, &dma_transfer);
+	if (ret < 0)
+		goto failed;
+
+	prxtx_queue->start_dma = 1;
+
+	return BSP_OK;
+
+failed:
+	return ret;
+}
+
+int check_dma_queue_fault(struct bspveth_rxtx_q *prxtx_queue,
+			  u32 queue, u32 type, u32 *pcnt)
+{
+	int ret = BSP_OK;
+	u32 cnt = 0;
+
+	if (prxtx_queue->dma_overtime > BSPVETH_MAX_QUE_DEEP)
+		return -EFAULT;
+
+	ret = __check_dmacmp_H(prxtx_queue, queue, type);
+	if (ret != BSP_OK)
+		return -EFAULT;
+
+	ret = __checkspace_H(prxtx_queue, queue, type, &cnt);
+	if (ret != BSP_OK)
+		return -EFAULT;
+
+	if (CHECK_DMA_RXQ_FAULT(prxtx_queue, type, cnt)) {
+		udelay(50);
+		prxtx_queue->dmal_cnt--;
+
+		return -EFAULT;
+	}
+
+	*pcnt = cnt;
+
+	return BSP_OK;
+}
+
+s32 __dma_rxtx_H(struct bspveth_rxtx_q *prxtx_queue, u32 queue, u32 type)
+{
+	int ret = BSP_OK;
+	u32 cnt = 0;
+	u32 shm_init;
+	struct bspveth_shmq_hd *pshmq_head = NULL;
+
+	if (!prxtx_queue || !prxtx_queue->pshmqhd_v)
+		return BSP_ERR_NULL_POINTER;
+
+	pshmq_head = prxtx_queue->pshmqhd_v;
+	shm_init = pshmq_head->init;
+	if (shm_init != BSPVETH_SHMQUEUE_INITOK) {
+		INC_STATIS_RXTX(queue, shmqueue_noinit, 1, type);
+		return -EFAULT;
+	}
+
+	if (CHECK_DMA_QUEUE_EMPTY(type, prxtx_queue))
+		return BSP_OK;
+
+	ret = check_dma_queue_fault(prxtx_queue, queue, type, &cnt);
+	if (ret != BSP_OK)
+		return -EFAULT;
+
+	ret = __start_dmalist_H(prxtx_queue, cnt, type);
+	if (ret != BSP_OK)
+		return -EFAULT;
+
+	if (cnt <= 16) {
+		ret = __check_dmacmp_H(prxtx_queue, queue, type);
+		if (ret != BSP_OK)
+			return -EFAULT;
+	}
+
+	return BSP_OK;
+}
+
+int veth_dma_task_H(u32 type)
+{
+	int i;
+	struct bspveth_rxtx_q *prxtx_queue = NULL;
+
+	for (i = 0; i < MAX_QUEUE_NUM; i++) {
+		if (type == BSPVETH_RX) {
+			g_bspveth_dev.run_dma_rx_task++;
+			prxtx_queue = g_bspveth_dev.prx_queue[i];
+		} else {
+			g_bspveth_dev.run_dma_tx_task++;
+			prxtx_queue = g_bspveth_dev.ptx_queue[i];
+		}
+
+		if (prxtx_queue) {
+			struct bspveth_shmq_hd *pshmq_head =
+				prxtx_queue->pshmqhd_v;
+			(void)__dma_rxtx_H(prxtx_queue, i, type);
+			if ((type == BSPVETH_RX &&
+			     pshmq_head->head != pshmq_head->tail) ||
+				(type == BSPVETH_TX &&
+				prxtx_queue->head != prxtx_queue->tail))
+				return BSP_ERR_AGAIN;
+		}
+	}
+
+	return BSP_OK;
+}
+
+#ifdef __UT_TEST
+
+s32 __atu_config_H(struct pci_dev *pdev, unsigned int region,
+		   unsigned int hostaddr_h, unsigned int hostaddr_l,
+		   unsigned int bmcaddr_h, unsigned int bmcaddr_l,
+		   unsigned int len)
+{
+	(void)pci_write_config_dword(pdev, 0x900,
+					 0x80000000 + (region & 0x00000007));
+	(void)pci_write_config_dword(pdev, 0x90c, hostaddr_l);
+	(void)pci_write_config_dword(pdev, 0x910, hostaddr_h);
+	(void)pci_write_config_dword(pdev, 0x914, hostaddr_l + len - 1);
+	(void)pci_write_config_dword(pdev, 0x918, bmcaddr_l);
+	(void)pci_write_config_dword(pdev, 0x91c, bmcaddr_h);
+	/*  atu ctrl1 reg	*/
+	(void)pci_write_config_dword(pdev, 0x904, 0x00000000);
+	/*  atu ctrl2 reg	*/
+	(void)pci_write_config_dword(pdev, 0x908, 0x80000000);
+
+	return 0;
+}
+
+void bspveth_atu_config_H(void)
+{
+	__atu_config_H(g_bspveth_dev.ppcidev,
+		       REGION_HOST,
+		       (sizeof(unsigned long) == SIZE_OF_UNSIGNED_LONG) ?
+		       ((u64)(g_bspveth_dev.phostrtc_p) >> ADDR_H_SHIFT) : 0,
+		       ((u64)(g_bspveth_dev.phostrtc_p) & 0xffffffff),
+		       0, HOSTRTC_REG_BASE, HOSTRTC_REG_SIZE);
+
+	__atu_config_H(g_bspveth_dev.ppcidev,
+		       REGION_BMC,
+		       (sizeof(unsigned long) == SIZE_OF_UNSIGNED_LONG) ?
+		       ((u64)(g_bspveth_dev.pshmpool_p) >> ADDR_H_SHIFT) : 0,
+		       ((u64)(g_bspveth_dev.pshmpool_p) & 0xffffffff),
+		       0, VETH_SHAREPOOL_BASE_INBMC, VETH_SHAREPOOL_SIZE);
+}
+
+void bspveth_pcie_free_H(void)
+{
+	struct pci_dev *pdev = g_bspveth_dev.ppcidev;
+
+	if (pdev)
+		pci_disable_device(pdev);
+	else
+		VETH_LOG(DLOG_ERROR, "bspveth_dev.ppcidev  IS NULL\n");
+
+	VETH_LOG(DLOG_DEBUG, "bspveth_pcie_exit_H ok\n");
+}
+
+#endif
+
+void bspveth_host_exit_H(void)
+{
+	int ret = 0;
+
+	ret = bma_intf_unregister_type((void **)&g_bspveth_dev.bma_priv);
+	if (ret < 0) {
+		VETH_LOG(DLOG_ERROR, "bma_intf_unregister_type failed\n");
+
+		return;
+	}
+
+	VETH_LOG(DLOG_DEBUG, "bspveth host exit H OK\n");
+}
+
+s32 bspveth_host_init_H(void)
+{
+	int ret = 0;
+	struct bma_priv_data_s *bma_priv = NULL;
+
+	ret = bma_intf_register_type(TYPE_VETH, 0, INTR_ENABLE,
+				     (void **)&bma_priv);
+	if (ret) {
+		ret = -1;
+		goto failed;
+	}
+
+	if (!bma_priv) {
+		VETH_LOG(DLOG_ERROR, "bma_priv is NULL\n");
+		return -1;
+	}
+
+	VETH_LOG(DLOG_DEBUG,
+		 "bma_intf_register_type pdev = %p, veth_swap_addr = %p, ",
+		 bma_priv->specific.veth.pdev,
+		 bma_priv->specific.veth.veth_swap_addr);
+
+	VETH_LOG(DLOG_DEBUG,
+		 "veth_swap_len = 0x%lx, veth_swap_phy_addr = 0x%lx\n",
+		 bma_priv->specific.veth.veth_swap_len,
+		 bma_priv->specific.veth.veth_swap_phy_addr);
+
+	g_bspveth_dev.bma_priv = bma_priv;
+	g_bspveth_dev.ppcidev = bma_priv->specific.veth.pdev;
+
+	/*bspveth_dev.phostrtc_p = (u8 *)bar1_base;*/
+	/*bspveth_dev.phostrtc_v = (u8 *)bar1_remap;*/
+	g_bspveth_dev.pshmpool_p =
+			(u8 *)bma_priv->specific.veth.veth_swap_phy_addr;
+	g_bspveth_dev.pshmpool_v =
+			(u8 *)bma_priv->specific.veth.veth_swap_addr;
+	g_bspveth_dev.shmpoolsize = bma_priv->specific.veth.veth_swap_len;
+
+	VETH_LOG(DLOG_DEBUG, "bspveth host init H OK\n");
+
+	return BSP_OK;
+
+failed:
+	return ret;
+}
+
+static int __init veth_init(void)
+{
+	int ret = BSP_OK;
+	int buf_len = 0;
+
+	if (!bma_intf_check_edma_supported())
+		return -ENXIO;
+
+	memset(&g_bspveth_dev, 0, sizeof(g_bspveth_dev));
+
+	buf_len = snprintf(g_bspveth_dev.name, NET_NAME_LEN,
+			   "%s", BSPVETH_DEV_NAME);
+	if (buf_len < 0 || ((u32)buf_len >= (NET_NAME_LEN))) {
+		VETH_LOG(DLOG_ERROR, "BSP_SNPRINTF lRet =0x%x\n", buf_len);
+		return BSP_ERR_INVALID_STR;
+	}
+
+	ret = bspveth_host_init_H();
+	if (ret != BSP_OK) {
+		ret = -1;
+		goto failed1;
+	}
+
+	ret = veth_netdev_init();
+	if (ret != BSP_OK) {
+		ret = -1;
+		goto failed2;
+	}
+
+	GET_SYS_SECONDS(g_bspveth_dev.init_time);
+
+	return BSP_OK;
+
+failed2:
+	bspveth_host_exit_H();
+
+failed1:
+
+	return ret;
+}
+
+static void __exit veth_exit(void)
+{
+	veth_netdev_exit();
+
+	bspveth_host_exit_H();
+}
+
+MODULE_AUTHOR("HUAWEI TECHNOLOGIES CO., LTD.");
+MODULE_DESCRIPTION("HUAWEI VETH DRIVER");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(VETH_VERSION);
+
+module_init(veth_init);
+module_exit(veth_exit);
diff --git a/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h
new file mode 100644
index 000000000000..060f8766afd1
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h
@@ -0,0 +1,442 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*Huawei iBMA driver.
+ *Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ *This program is free software; you can redistribute it and/or
+ *modify it under the terms of the GNU General Public License
+ *as published by the Free Software Foundation; either version 2
+ *of the License, or (at your option) any later version.
+ *
+ *This program is distributed in the hope that it will be useful,
+ *but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VETH_HB_H_
+#define _VETH_HB_H_
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#include <linux/interrupt.h>
+
+#define DEP_BMA
+
+#include "../edma_drv/bma_include.h"
+#include "../include/bma_ker_intf.h"
+
+#ifdef DRV_VERSION
+#define VETH_VERSION	MICRO_TO_STR(DRV_VERSION)
+#else
+#define VETH_VERSION	"0.3.4"
+#endif
+
+#define MODULE_NAME	"veth"
+#define BSP_VETH_T	u64
+
+#define BSP_OK				(0)
+#define BSP_ERR				(0xFFFFFFFF)
+#define BSP_NETDEV_TX_BUSY		(1)
+#define BSP_ERR_INIT_ERR		(BSP_NETDEV_TX_BUSY)
+#define BSP_ETH_ERR_BASE		(0x0FFFF000)
+#define BSP_ERR_OUT_OF_MEM		(BSP_ETH_ERR_BASE + 1)
+#define BSP_ERR_NULL_POINTER		(BSP_ETH_ERR_BASE + 2)
+#define BSP_ERR_INVALID_STR		(BSP_ETH_ERR_BASE + 3)
+#define BSP_ERR_INVALID_PARAM		(BSP_ETH_ERR_BASE + 4)
+#define BSP_ERR_INVALID_DATA		(BSP_ETH_ERR_BASE + 5)
+#define BSP_ERR_OUT_OF_RANGE		(BSP_ETH_ERR_BASE + 6)
+#define BSP_ERR_INVALID_CARD		(BSP_ETH_ERR_BASE + 7)
+#define BSP_ERR_INVALID_GRP		(BSP_ETH_ERR_BASE + 8)
+#define BSP_ERR_INVALID_ETH		(BSP_ETH_ERR_BASE + 9)
+#define BSP_ERR_SEND_ERR		(BSP_ETH_ERR_BASE + 10)
+#define BSP_ERR_DMA_ERR			(BSP_ETH_ERR_BASE + 11)
+#define BSP_ERR_RECV_ERR		(BSP_ETH_ERR_BASE + 12)
+#define BSP_ERR_SKB_ERR			(BSP_ETH_ERR_BASE + 13)
+#define BSP_ERR_DMA_ADDR_ERR		(BSP_ETH_ERR_BASE + 14)
+#define BSP_ERR_IOREMAP_ERR		(BSP_ETH_ERR_BASE + 15)
+#define BSP_ERR_LEN_ERR			(BSP_ETH_ERR_BASE + 16)
+#define BSP_ERR_STAT_ERR		(BSP_ETH_ERR_BASE + 17)
+#define BSP_ERR_AGAIN			(BSP_ETH_ERR_BASE + 18)
+#define BSP_ERR_NOT_TO_HANDLE		(BSP_ETH_ERR_BASE + 19)
+
+#define VETH_H2B_IRQ_NO			(113)
+#define SYSCTL_REG_BASE			(0x20000000)
+#define SYSCTL_REG_SIZE			(0x1000)
+#define PCIE1_REG_BASE			(0x29000000)
+#define PCIE1_REG_SIZE			(0x1000)
+#define VETH_SHAREPOOL_BASE_INBMC	(0x84820000)
+#define VETH_SHAREPOOL_SIZE		(0xdf000)
+#define VETH_SHAREPOOL_OFFSET		(0x10000)
+#define MAX_SHAREQUEUE_SIZE		(0x20000)
+
+#define BSPVETH_SHMBDBASE_OFFSET	(0x80)
+#define SHMDMAL_OFFSET			(0x10000)
+#define MAX_SHMDMAL_SIZE		(BSPVETH_DMABURST_MAX * 32)
+
+#define BSPVETH_DMABURST_MAX		64
+#define BSPVETH_SKBTIMER_INTERVAL	(1)
+#define BSPVETH_DMATIMER_INTERVAL	(1)
+#define BSPVETH_CTLTIMER_INTERVAL	(10)
+#define BSPVETH_HDCMD_CHKTIMER_INTERVAL	(10)
+#define BSP_DMA_64BIT_MASK		(0xffffffffffffffffULL)
+#define BSP_DMA_32BIT_MASK		(0x00000000ffffffffULL)
+#define HOSTRTC_REG_BASE		(0x2f000000)
+#define HOSTRTC_REG_SIZE		(0x10000)
+#define REG_SYSCTL_HOSTINT_CLEAR	(0x44)
+#define SHIFT_SYSCTL_HOSTINT_CLEAR	(22)
+#define REG_SYSCTL_HOSTINT		(0xf4)
+#define SHIFT_SYSCTL_HOSTINT		(26)
+
+#define NET_TYPE_LEN			(16)
+
+#define MAX_QUEUE_NUM			(1)
+#define MAX_QUEUE_BDNUM			(128)
+#define BSPVETH_MAX_QUE_DEEP		(MAX_QUEUE_BDNUM)
+#define BSPVETH_POINT_MASK		(MAX_QUEUE_BDNUM - 1)
+#define BSPVETH_WORK_LIMIT		(64)
+#define BSPVETH_CHECK_DMA_STATUS_TIMES	(120)
+
+#define REG_PCIE1_DMAREAD_ENABLE	(0xa18)
+#define SHIFT_PCIE1_DMAREAD_ENABLE	(0)
+#define REG_PCIE1_DMAWRITE_ENABLE	(0x9c4)
+#define SHIFT_PCIE1_DMAWRITE_ENABLE	(0)
+#define REG_PCIE1_DMAREAD_STATUS	(0xa10)
+#define SHIFT_PCIE1_DMAREAD_STATUS	(0)
+#define REG_PCIE1_DMAREADINT_CLEAR	(0xa1c)
+#define SHIFT_PCIE1_DMAREADINT_CLEAR	(0)
+#define REG_PCIE1_DMAWRITE_STATUS	(0x9bc)
+#define SHIFT_PCIE1_DMAWRITE_STATUS	(0)
+#define REG_PCIE1_DMAWRITEINT_CLEAR	(0x9c8)
+#define SHIFT_PCIE1_DMAWRITEINT_CLEAR	(0)
+
+#define BSPVETH_DMA_OK			(1)
+#define BSPVETH_DMA_BUSY		(0)
+#define BSPVETH_RX			(2)
+#define BSPVETH_TX			(3)
+#define HOSTRTC_INT_OFFSET		(0x10)
+#define BSPVETH_DEV_NAME		(MODULE_NAME)
+#define NET_NAME_LEN			(64)
+
+#ifdef PCI_VENDOR_ID_HUAWEI
+#undef PCI_VENDOR_ID_HUAWEI
+#endif
+#define PCI_VENDOR_ID_HUAWEI		(0x19e5)
+
+#define PCI_DEVICE_ID_KBOX		(0x1710)
+#define BSPVETH_MTU_MAX			(1500)
+#define BSPVETH_MTU_MIN			(64)
+#define BSPVETH_SKB_SIZE		(1536)
+#define BSPVETH_NET_TIMEOUT		(5 * HZ)
+#define BSPVETH_QUEUE_TIMEOUT_10MS	(100)
+#define BSPVETH_SHMQUEUE_INITOK		(0x12)
+#define BSPVETH_LBK_TYPE		(0x800)
+
+#ifndef VETH_BMC
+#define BSPVETH_CACHELINE_SIZE		(64)
+#else
+#define BSPVETH_CACHELINE_SIZE		(32)
+#endif
+#define BSPVETH_HBCMD_WCMP		(0x44)
+#define BSPVETH_HBCMD_CMP		(0x55)
+#define BSPVETH_HBCMD_OK		(0x66)
+#define BSPVETH_HEART_WACK		(0x99)
+#define BSPVETH_HEART_ACK		(0xaa)
+
+#define BSPVETH_HBCMD_TIMEOUT		(1000)
+
+#define SIZE_OF_UNSIGNED_LONG 8
+#define ADDR_H_SHIFT 32
+#define REGION_HOST 1
+#define REGION_BMC 2
+
+enum veth_hb_cmd {
+	VETH_HBCMD_UNKNOWN = 0x0,
+	VETH_HBCMD_SETIP,
+
+	VETH_HBCMD_MAX,
+};
+
+#define USE_TASKLET
+
+#define BSPVETH_ETHTOOL_BASE		0x89F0
+#define BSPVETH_ETHTOOL_TESTINT		(BSPVETH_ETHTOOL_BASE + 1)
+#define BSPVETH_ETHTOOL_TESTSHAREMEM	(BSPVETH_ETHTOOL_BASE + 2)
+#define BSPVETH_ETHTOOL_DUMPSHAREMEM	(BSPVETH_ETHTOOL_BASE + 3)
+#define BSPVETH_ETHTOOL_TESTDMA		(BSPVETH_ETHTOOL_BASE + 4)
+#define BSPVETH_ETHTOOL_RWPCIEREG	(BSPVETH_ETHTOOL_BASE + 5)
+#define BSPVETH_ETHTOOL_TESTLBK		(BSPVETH_ETHTOOL_BASE + 6)
+#define BSPVETH_ETHTOOL_INITSTATIS	(BSPVETH_ETHTOOL_BASE + 7)
+#define BSPVETH_HBCMD			(BSPVETH_ETHTOOL_BASE + 8)
+
+struct bspveth_test {
+	u32 intdirect;	/*0--H2B,1--B2H*/
+	u32 rwshmcheck;	/*0--w,1--r and check*/
+	u32 dshmbase;
+	u32 dshmlen;
+	u32 testdma;	/*0--disable,1---enable*/
+	u32 pcierw;	/*0--w,1---r*/
+	u32 reg;
+	u32 data;
+	u32 testlbk;	/*0--disable,1---enable*/
+};
+
+struct bspveth_hdcmd {
+	u32 cmd;
+	u32 stat;
+	u32 heart;
+	u32 err;
+	u32 sequence;
+	u32 len;
+	u8 data[256];
+};
+
+struct bspveth_rxtx_statis {
+	u64 pkt;
+	u64 pktbyte;
+	u64 refill;
+	u64 freetx;
+	u64 dmapkt;
+	u64 dmapktbyte;
+
+	u32 dropped_pkt;
+	u32 netifrx_err;
+	u32 null_point;
+	u32 retry_err;
+	u32 dma_mapping_err;
+	u32 allocskb_err;
+	u32 q_full;
+	u32 q_emp;
+	u32 shm_full;
+	u32 shm_emp;
+	u32 dma_busy;
+	u32 need_fill;
+	u32 need_free;
+	u32 dmacmp_err;
+	u32 type_err;
+	u32 shmqueue_noinit;
+	u32 shmretry_err;
+	u32 dma_earlyint;
+	u32 clr_dma_earlyint;
+	u32 clr_dma_int;
+	u32 dmarx_shmaddr_unalign;
+	u32 dmarx_hostaddr_unalign;
+	u32 dmatx_shmaddr_unalign;
+	u32 dmatx_hostaddr_unalign;
+	u32 dma_need_offset;
+	u32 lastdmadir_err;
+	u32 dma_failed;
+	u32 dma_burst;
+	u32 lbk_cnt;
+	u32 lbk_txerr;
+};
+
+struct bspveth_bd_info {
+	struct sk_buff *pdma_v;
+	u32 len;
+	unsigned long time_stamp;
+};
+
+struct bspveth_dma_shmbd {
+	u32 dma_p;
+	u32 len;
+	u32 off;
+};
+
+struct bspveth_shmq_hd {
+	u32 count;
+	u32 size;	/*count x sizeof(dmaBD)*/
+	u32 next_to_fill;
+	u32 next_to_free;
+	u32 head;
+	u32 tail;
+	u16 init;	/*  1--ok,0--nok*/
+};
+
+struct bspveth_dma_bd {
+	u64 dma_p;
+	u32 len;
+	u32 off;
+};
+
+struct bspveth_dmal {
+	u32 chl;
+	u32 len;
+	u32 slow;
+	u32 shi;
+	u32 dlow;
+	u32 dhi;
+};
+
+struct bspveth_rxtx_q {
+#ifndef VETH_BMC
+	struct bspveth_dma_bd *pbdbase_v;
+	u8 *pbdbase_p;
+#endif
+
+	struct bspveth_bd_info *pbdinfobase_v;
+	struct bspveth_shmq_hd *pshmqhd_v;
+	u8 *pshmqhd_p;
+
+	struct bspveth_dma_shmbd *pshmbdbase_v;
+	u8 *pshmbdbase_p;
+
+	struct bspveth_dmal *pdmalbase_v;
+	u8 *pdmalbase_p;
+
+	u32 dmal_cnt;
+	u32 dmal_byte;
+
+	u32 count;
+	u32 size;
+	u32 rx_buf_len;
+
+	u32 next_to_fill;
+	u32 next_to_free;
+	u32 head;
+	u32 tail;
+	u16 start_dma;
+	u16 dmacmperr;
+
+	u16 dma_overtime;
+
+	u32 work_limit;
+	struct bspveth_rxtx_statis s;
+};
+
+struct bspveth_device {
+	struct bspveth_rxtx_q *ptx_queue[MAX_QUEUE_NUM];
+	struct bspveth_rxtx_q *prx_queue[MAX_QUEUE_NUM];
+	struct net_device *pnetdev;
+	char name[NET_NAME_LEN];
+
+	struct pci_dev *ppcidev;
+	u8 *phostrtc_p;
+	u8 *phostrtc_v;
+
+	u8 *psysctl_v;
+	u8 *ppcie1_v;
+
+	u8 *pshmpool_p;
+	u8 *pshmpool_v;
+	u32 shmpoolsize;
+
+	u32 recv_int;
+	u32 tobmc_int;
+	u32 tohost_int;
+	u32 run_dma_tx_task;
+	u32 run_dma_rx_task;
+	u32 run_skb_rx_task;
+	u32 run_skb_fr_task;
+	u32 shutdown_cnt;
+	__kernel_time_t init_time;
+
+	/* spinlock for register */
+	spinlock_t reg_lock;
+#ifndef USE_TASKLET
+	struct timer_list skbtrtimer;
+	struct timer_list dmatimer;
+#else
+	struct tasklet_struct skb_task;
+	struct tasklet_struct dma_task;
+#endif
+
+	struct net_device_stats stats;
+	struct work_struct shutdown_task;
+#ifdef DEP_BMA
+	struct bma_priv_data_s *bma_priv;
+#else
+	void *edma_priv;
+#endif
+};
+
+struct tag_pcie_comm_priv {
+	char net_type[NET_TYPE_LEN];
+	struct net_device_stats stats;
+	int status;
+	int irq_enable;
+	int pcie_comm_rx_flag;
+	spinlock_t lock; /* spinlock for priv data */
+};
+
+#define QUEUE_MASK(p)		((p) & (BSPVETH_POINT_MASK))
+
+#define CHECK_ADDR_ALIGN(addr, statis)\
+do {                         \
+	if ((addr) & 0x3) \
+		statis;\
+} while (0)
+
+#define PROC_P_STATIS(name, statis)\
+	PROC_DPRINTK("[%10s]:\t0x%llx", #name, statis)
+
+#define  INC_STATIS_RXTX(queue, name, count, type) \
+do {                 \
+	if (type == BSPVETH_RX)\
+		g_bspveth_dev.prx_queue[queue]->s.name += count;\
+	else\
+		g_bspveth_dev.ptx_queue[queue]->s.name += count;\
+} while (0)
+
+#define PROC_DPRINTK(fmt, args...) (len += sprintf(buf + len, fmt, ##args))
+
+#define JUDGE_TX_QUEUE_SPACE(head, tail, len) \
+	(((BSPVETH_MAX_QUE_DEEP + (tail) - (head) - 1) \
+	    & BSPVETH_POINT_MASK) >= (len))
+
+#define JUDGE_RX_QUEUE_SPACE(head, tail, len) \
+	(((BSPVETH_MAX_QUE_DEEP + (tail) - (head)) \
+	    & BSPVETH_POINT_MASK) > (len))
+
+#define DMA_MAPPING_ERROR(device, dma)	dma_mapping_error(device, dma)
+
+#ifndef VETH_BMC
+#define BSPVETH_UNMAP_DMA(data, len) \
+	dma_unmap_single(&g_bspveth_dev.ppcidev->dev, \
+			 data, len, DMA_FROM_DEVICE)
+#else
+#define BSPVETH_UNMAP_DMA(data, len) \
+	dma_unmap_single(NULL, data, len, DMA_FROM_DEVICE)
+#endif
+
+int veth_tx(struct sk_buff *pstr_skb, struct net_device *pstr_dev);
+int veth_dma_task_H(u32 type);
+s32 veth_skbtimer_close(void);
+void veth_skbtimer_init(void);
+s32 veth_dmatimer_close_H(void);
+void veth_dmatimer_init_H(void);
+int veth_skb_tr_task(void);
+
+s32 __dma_rxtx_H(struct bspveth_rxtx_q *prxtx_queue, u32 queue, u32 type);
+s32 veth_recv_pkt(struct bspveth_rxtx_q *prx_queue, int queue);
+s32 veth_free_txskb(struct bspveth_rxtx_q *ptx_queue, int queue);
+
+enum {
+	QUEUE_TX_STATS,
+	QUEUE_RX_STATS,
+	VETH_STATS,
+	SHMQ_TX_STATS,
+	SHMQ_RX_STATS,
+	NET_STATS,
+};
+
+struct veth_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int type;
+	int sizeof_stat;
+	int stat_offset;
+};
+
+#define VETH_STAT_SIZE(m)	sizeof(((struct bspveth_device *)0)->m)
+#define VETH_STAT_OFFSET(m)	offsetof(struct bspveth_device, m)
+#define QUEUE_TXRX_STAT_SIZE(m)	sizeof(((struct bspveth_rxtx_q *)0)->m)
+#define QUEUE_TXRX_STAT_OFFSET(m)	offsetof(struct bspveth_rxtx_q, m)
+#define SHMQ_TXRX_STAT_SIZE(m)	sizeof(((struct bspveth_shmq_hd *)0)->m)
+#define SHMQ_TXRX_STAT_OFFSET(m)	offsetof(struct bspveth_shmq_hd, m)
+
+#ifdef __cplusplus
+}
+#endif
+#endif
-- 
2.26.2.windows.1


