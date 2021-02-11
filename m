Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F75318F88
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhBKQIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:08:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62412 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhBKQAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:00:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFtQY1007947;
        Thu, 11 Feb 2021 07:59:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NubEOiD6pgFuEc0omb/QeWEs0KRuPj96HVFTCkhLpQw=;
 b=LaPvoZ4uY9L86ypbjnweDMPvZz8KqkDfdDizMAxHBM6s0kf3sgZAlKqmmdULXcqsoxP0
 BBwwkME91hwjjMceHocYTz2umu0M2oe8B8cCD50kJIJuRACtp5bizTLfoS1BHpFG5iEM
 kkfw4QFJGSB/mCNHA3RCvad2paIuH1UhM2qfl4PHjlROEA8hk3J06sWxx+AEo16+Pe+m
 3Nwx6E05LtKk8iHZLagGWyKaErTYmpicgK9YfMTb1vGV5Orx00YJMnLjrqB2UvyWsKJO
 9dFSq26ggzQWiXP97hGgeYK/0wzG1LhNqlGJklb65WAUbFywFPFlDxq9sjI7jtNsIsPm kQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqf9k9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:59:44 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:59:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:59:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:59:41 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id F07783F7040;
        Thu, 11 Feb 2021 07:59:37 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v6 08/14] octeontx2-af: cn10k: Add RPM MAC support
Date:   Thu, 11 Feb 2021 21:28:28 +0530
Message-ID: <20210211155834.31874-9-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211155834.31874-1-gakula@marvell.com>
References: <20210211155834.31874-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

OcteonTx2's next gen platform the CN10K has RPM MAC which has a
different serdes when compared to CGX MAC. Though the underlying
HW is different, the CSR interface has been designed largely inline
with CGX MAC, with few exceptions though. So we are using the same
CGX driver for RPM MAC as well and will have a different set of APIs
for RPM where ever necessary.

This patch adds initial support for CN10K's RPM MAC i.e. the driver
registration, communication with firmware etc. For communication with
firmware, RPM provides a different IRQ when compared to CGX.
The CGX and RPM blocks support different features. Currently few
features like ptp, flowcontrol and higig are not supported by RPM. This
patch adds new mailbox message "CGX_FEATURES_GET" to get the list of
features supported by underlying MAC.

RPM has different implementations for RX/TX stats. Unlike CGX,
bar offset of stat registers are different. This patch adds
support to access the same and dump the values in debugfs.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 MAINTAINERS                                   |   1 +
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 271 ++++++++++++------
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  16 +-
 .../marvell/octeontx2/af/lmac_common.h        |  96 +++++++
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  15 +-
 .../net/ethernet/marvell/octeontx2/af/rpm.c   |  39 +++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  23 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  60 +++-
 .../marvell/octeontx2/af/rvu_debugfs.c        |  54 +++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   6 +-
 12 files changed, 479 insertions(+), 106 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0bbd95b73c39..ab8939e72ed8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10719,6 +10719,7 @@ M:	Sunil Goutham <sgoutham@marvell.com>
 M:	Linu Cherian <lcherian@marvell.com>
 M:	Geetha sowjanya <gakula@marvell.com>
 M:	Jerin Jacob <jerinj@marvell.com>
+M:	hariprasad <hkelam@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index eb535c98ca38..a6afbdeeaf30 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
-		  rvu_cpt.o rvu_devlink.o
+		  rvu_cpt.o rvu_devlink.o rpm.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9c62129e283b..7eccc35c14e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -21,47 +21,11 @@
 #include <linux/of_net.h>
 
 #include "cgx.h"
+#include "rvu.h"
+#include "lmac_common.h"
 
-#define DRV_NAME	"octeontx2-cgx"
-#define DRV_STRING      "Marvell OcteonTX2 CGX/MAC Driver"
-
-/**
- * struct lmac
- * @wq_cmd_cmplt:	waitq to keep the process blocked until cmd completion
- * @cmd_lock:		Lock to serialize the command interface
- * @resp:		command response
- * @link_info:		link related information
- * @event_cb:		callback for linkchange events
- * @event_cb_lock:	lock for serializing callback with unregister
- * @cmd_pend:		flag set before new command is started
- *			flag cleared after command response is received
- * @cgx:		parent cgx port
- * @lmac_id:		lmac port id
- * @name:		lmac port name
- */
-struct lmac {
-	wait_queue_head_t wq_cmd_cmplt;
-	struct mutex cmd_lock;
-	u64 resp;
-	struct cgx_link_user_info link_info;
-	struct cgx_event_cb event_cb;
-	spinlock_t event_cb_lock;
-	bool cmd_pend;
-	struct cgx *cgx;
-	u8 lmac_id;
-	char *name;
-};
-
-struct cgx {
-	void __iomem		*reg_base;
-	struct pci_dev		*pdev;
-	u8			cgx_id;
-	u8			lmac_count;
-	struct lmac		*lmac_idmap[MAX_LMAC_PER_CGX];
-	struct			work_struct cgx_cmd_work;
-	struct			workqueue_struct *cgx_cmd_workq;
-	struct list_head	cgx_list;
-};
+#define DRV_NAME	"Marvell-CGX/RPM"
+#define DRV_STRING      "Marvell CGX/RPM Driver"
 
 static LIST_HEAD(cgx_list);
 
@@ -77,22 +41,45 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool en);
 /* Supported devices */
 static const struct pci_device_id cgx_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_CGX) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM) },
 	{ 0, }  /* end of table */
 };
 
 MODULE_DEVICE_TABLE(pci, cgx_id_table);
 
-static void cgx_write(struct cgx *cgx, u64 lmac, u64 offset, u64 val)
+static bool is_dev_rpm(void *cgxd)
 {
-	writeq(val, cgx->reg_base + (lmac << 18) + offset);
+	struct cgx *cgx = cgxd;
+
+	return (cgx->pdev->device == PCI_DEVID_CN10K_RPM);
+}
+
+bool is_lmac_valid(struct cgx *cgx, int lmac_id)
+{
+	return cgx && test_bit(lmac_id, &cgx->lmac_bmap);
 }
 
-static u64 cgx_read(struct cgx *cgx, u64 lmac, u64 offset)
+struct mac_ops *get_mac_ops(void *cgxd)
 {
-	return readq(cgx->reg_base + (lmac << 18) + offset);
+	if (!cgxd)
+		return cgxd;
+
+	return ((struct cgx *)cgxd)->mac_ops;
 }
 
-static inline struct lmac *lmac_pdata(u8 lmac_id, struct cgx *cgx)
+void cgx_write(struct cgx *cgx, u64 lmac, u64 offset, u64 val)
+{
+	writeq(val, cgx->reg_base + (lmac << cgx->mac_ops->lmac_offset) +
+	       offset);
+}
+
+u64 cgx_read(struct cgx *cgx, u64 lmac, u64 offset)
+{
+	return readq(cgx->reg_base + (lmac << cgx->mac_ops->lmac_offset) +
+		     offset);
+}
+
+struct lmac *lmac_pdata(u8 lmac_id, struct cgx *cgx)
 {
 	if (!cgx || lmac_id >= MAX_LMAC_PER_CGX)
 		return NULL;
@@ -186,8 +173,10 @@ static u64 mac2u64 (u8 *mac_addr)
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct mac_ops *mac_ops;
 	u64 cfg;
 
+	mac_ops = cgx_dev->mac_ops;
 	/* copy 6bytes from macaddr */
 	/* memcpy(&cfg, mac_addr, 6); */
 
@@ -206,8 +195,11 @@ int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct mac_ops *mac_ops;
 	u64 cfg;
 
+	mac_ops = cgx_dev->mac_ops;
+
 	cfg = cgx_read(cgx_dev, 0, CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8);
 	return cfg & CGX_RX_DMAC_ADR_MASK;
 }
@@ -216,7 +208,7 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 {
 	struct cgx *cgx = cgxd;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	cgx_write(cgx, lmac_id, CGXX_CMRX_RX_ID_MAP, (pkind & 0x3F));
@@ -238,7 +230,7 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 	u8 lmac_type;
 	u64 cfg;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	lmac_type = cgx_get_lmac_type(cgx, lmac_id);
@@ -263,11 +255,13 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgx_get_pdata(cgx_id);
+	struct mac_ops *mac_ops;
 	u64 cfg = 0;
 
 	if (!cgx)
 		return;
 
+	mac_ops = cgx->mac_ops;
 	if (enable) {
 		/* Enable promiscuous mode on LMAC */
 		cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
@@ -299,6 +293,9 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
+	if (is_dev_rpm(cgx))
+		return;
+
 	if (!cgx)
 		return;
 
@@ -323,9 +320,11 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 {
+	struct mac_ops *mac_ops;
 	struct cgx *cgx = cgxd;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	mac_ops = cgx->mac_ops;
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
@@ -333,14 +332,21 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 {
+	struct mac_ops *mac_ops;
 	struct cgx *cgx = cgxd;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	mac_ops = cgx->mac_ops;
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 	*tx_stat = cgx_read(cgx, lmac_id, CGXX_CMRX_TX_STAT0 + (idx * 8));
 	return 0;
 }
 
+u64 cgx_features_get(void *cgxd)
+{
+	return ((struct cgx *)cgxd)->hw_features;
+}
+
 static int cgx_set_fec_stats_count(struct cgx_link_user_info *linfo)
 {
 	if (!linfo->fec)
@@ -400,7 +406,7 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
@@ -417,7 +423,7 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 	struct cgx *cgx = cgxd;
 	u64 cfg, last;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
@@ -438,7 +444,10 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (is_dev_rpm(cgx))
+		return 0;
+
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
@@ -455,7 +464,10 @@ int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 	struct cgx *cgx = cgxd;
 	u64 cfg;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (is_dev_rpm(cgx))
+		return 0;
+
+	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
@@ -483,7 +495,10 @@ static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
 {
 	u64 cfg;
 
-	if (!cgx || lmac_id >= cgx->lmac_count)
+	if (is_dev_rpm(cgx))
+		return;
+
+	if (!is_lmac_valid(cgx, lmac_id))
 		return;
 	if (enable) {
 		/* Enable receive pause frames */
@@ -541,6 +556,9 @@ void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
 	if (!cgx)
 		return;
 
+	if (is_dev_rpm(cgx))
+		return;
+
 	if (enable) {
 		/* Enable inbound PTP timestamping */
 		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
@@ -563,7 +581,7 @@ void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
 }
 
 /* CGX Firmware interface low level support */
-static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
+int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 {
 	struct cgx *cgx = lmac->cgx;
 	struct device *dev;
@@ -611,8 +629,7 @@ static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 	return err;
 }
 
-static inline int cgx_fwi_cmd_generic(u64 req, u64 *resp,
-				      struct cgx *cgx, int lmac_id)
+int cgx_fwi_cmd_generic(u64 req, u64 *resp, struct cgx *cgx, int lmac_id)
 {
 	struct lmac *lmac;
 	int err;
@@ -885,12 +902,16 @@ static inline bool cgx_event_is_linkevent(u64 event)
 
 static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 {
+	u64 event, offset, clear_bit;
 	struct lmac *lmac = data;
 	struct cgx *cgx;
-	u64 event;
 
 	cgx = lmac->cgx;
 
+	/* Clear SW_INT for RPM and CMR_INT for CGX */
+	offset     = cgx->mac_ops->int_register;
+	clear_bit  = cgx->mac_ops->int_ena_bit;
+
 	event = cgx_read(cgx, lmac->lmac_id, CGX_EVENT_REG);
 
 	if (!FIELD_GET(EVTREG_ACK, event))
@@ -926,7 +947,7 @@ static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 	 * Ack the interrupt register as well.
 	 */
 	cgx_write(lmac->cgx, lmac->lmac_id, CGX_EVENT_REG, 0);
-	cgx_write(lmac->cgx, lmac->lmac_id, CGXX_CMRX_INT, FW_CGX_INT);
+	cgx_write(lmac->cgx, lmac->lmac_id, offset, clear_bit);
 
 	return IRQ_HANDLED;
 }
@@ -970,14 +991,16 @@ int cgx_get_fwdata_base(u64 *base)
 {
 	u64 req = 0, resp;
 	struct cgx *cgx;
+	int first_lmac;
 	int err;
 
 	cgx = list_first_entry_or_null(&cgx_list, struct cgx, cgx_list);
 	if (!cgx)
 		return -ENXIO;
 
+	first_lmac = find_first_bit(&cgx->lmac_bmap, MAX_LMAC_PER_CGX);
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_FWD_BASE, req);
-	err = cgx_fwi_cmd_generic(req, &resp, cgx, 0);
+	err = cgx_fwi_cmd_generic(req, &resp, cgx, first_lmac);
 	if (!err)
 		*base = FIELD_GET(RESP_FWD_BASE, resp);
 
@@ -1056,10 +1079,11 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 
 static inline int cgx_fwi_read_version(u64 *resp, struct cgx *cgx)
 {
+	int first_lmac = find_first_bit(&cgx->lmac_bmap, MAX_LMAC_PER_CGX);
 	u64 req = 0;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_FW_VER, req);
-	return cgx_fwi_cmd_generic(req, resp, cgx, 0);
+	return cgx_fwi_cmd_generic(req, resp, cgx, first_lmac);
 }
 
 static int cgx_lmac_verify_fwi_version(struct cgx *cgx)
@@ -1092,8 +1116,8 @@ static void cgx_lmac_linkup_work(struct work_struct *work)
 	struct device *dev = &cgx->pdev->dev;
 	int i, err;
 
-	/* Do Link up for all the lmacs */
-	for (i = 0; i < cgx->lmac_count; i++) {
+	/* Do Link up for all the enabled lmacs */
+	for_each_set_bit(i, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
 		err = cgx_fwi_link_change(cgx, i, true);
 		if (err)
 			dev_info(dev, "cgx port %d:%d Link up command failed\n",
@@ -1113,12 +1137,67 @@ int cgx_lmac_linkup_start(void *cgxd)
 	return 0;
 }
 
+static int cgx_configure_interrupt(struct cgx *cgx, struct lmac *lmac,
+				   int cnt, bool req_free)
+{
+	struct mac_ops *mac_ops = cgx->mac_ops;
+	u64 offset, ena_bit;
+	unsigned int irq;
+	int err;
+
+	irq      = pci_irq_vector(cgx->pdev, mac_ops->lmac_fwi +
+				  cnt * mac_ops->irq_offset);
+	offset   = mac_ops->int_set_reg;
+	ena_bit  = mac_ops->int_ena_bit;
+
+	if (req_free) {
+		free_irq(irq, lmac);
+		return 0;
+	}
+
+	err = request_irq(irq, cgx_fwi_event_handler, 0, lmac->name, lmac);
+	if (err)
+		return err;
+
+	/* Enable interrupt */
+	cgx_write(cgx, lmac->lmac_id, offset, ena_bit);
+	return 0;
+}
+
+int cgx_get_nr_lmacs(void *cgxd)
+{
+	struct cgx *cgx = cgxd;
+
+	return cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0x7ULL;
+}
+
+u8 cgx_get_lmacid(void *cgxd, u8 lmac_index)
+{
+	struct cgx *cgx = cgxd;
+
+	return cgx->lmac_idmap[lmac_index]->lmac_id;
+}
+
+unsigned long cgx_get_lmac_bmap(void *cgxd)
+{
+	struct cgx *cgx = cgxd;
+
+	return cgx->lmac_bmap;
+}
+
 static int cgx_lmac_init(struct cgx *cgx)
 {
 	struct lmac *lmac;
+	u64 lmac_list;
 	int i, err;
 
-	cgx->lmac_count = cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0x7;
+	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
+	/* lmac_list specifies which lmacs are enabled
+	 * when bit n is set to 1, LMAC[n] is enabled
+	 */
+	if (cgx->mac_ops->non_contiguous_serdes_lane)
+		lmac_list = cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0xFULL;
+
 	if (cgx->lmac_count > MAX_LMAC_PER_CGX)
 		cgx->lmac_count = MAX_LMAC_PER_CGX;
 
@@ -1132,24 +1211,25 @@ static int cgx_lmac_init(struct cgx *cgx)
 			goto err_lmac_free;
 		}
 		sprintf(lmac->name, "cgx_fwi_%d_%d", cgx->cgx_id, i);
-		lmac->lmac_id = i;
+		if (cgx->mac_ops->non_contiguous_serdes_lane) {
+			lmac->lmac_id = __ffs64(lmac_list);
+			lmac_list   &= ~BIT_ULL(lmac->lmac_id);
+		} else {
+			lmac->lmac_id = i;
+		}
+
 		lmac->cgx = cgx;
 		init_waitqueue_head(&lmac->wq_cmd_cmplt);
 		mutex_init(&lmac->cmd_lock);
 		spin_lock_init(&lmac->event_cb_lock);
-		err = request_irq(pci_irq_vector(cgx->pdev,
-						 CGX_LMAC_FWI + i * 9),
-				   cgx_fwi_event_handler, 0, lmac->name, lmac);
+		err = cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, false);
 		if (err)
 			goto err_irq;
 
-		/* Enable interrupt */
-		cgx_write(cgx, lmac->lmac_id, CGXX_CMRX_INT_ENA_W1S,
-			  FW_CGX_INT);
-
 		/* Add reference */
-		cgx->lmac_idmap[i] = lmac;
-		cgx_lmac_pause_frm_config(cgx, i, true);
+		cgx->lmac_idmap[lmac->lmac_id] = lmac;
+		cgx_lmac_pause_frm_config(cgx, lmac->lmac_id, true);
+		set_bit(lmac->lmac_id, &cgx->lmac_bmap);
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
@@ -1173,12 +1253,12 @@ static int cgx_lmac_exit(struct cgx *cgx)
 	}
 
 	/* Free all lmac related resources */
-	for (i = 0; i < cgx->lmac_count; i++) {
-		cgx_lmac_pause_frm_config(cgx, i, false);
+	for_each_set_bit(i, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
-		free_irq(pci_irq_vector(cgx->pdev, CGX_LMAC_FWI + i * 9), lmac);
+		cgx_lmac_pause_frm_config(cgx, lmac->lmac_id, false);
+		cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, true);
 		kfree(lmac->name);
 		kfree(lmac);
 	}
@@ -1186,6 +1266,27 @@ static int cgx_lmac_exit(struct cgx *cgx)
 	return 0;
 }
 
+static void cgx_populate_features(struct cgx *cgx)
+{
+	if (is_dev_rpm(cgx))
+		cgx->hw_features =  RVU_MAC_RPM;
+	else
+		cgx->hw_features = (RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
+}
+
+static struct mac_ops	cgx_mac_ops    = {
+	.name		=       "cgx",
+	.csr_offset	=       0,
+	.lmac_offset    =       18,
+	.int_register	=       CGXX_CMRX_INT,
+	.int_set_reg	=       CGXX_CMRX_INT_ENA_W1S,
+	.irq_offset	=       9,
+	.int_ena_bit    =       FW_CGX_INT,
+	.lmac_fwi	=	CGX_LMAC_FWI,
+	.non_contiguous_serdes_lane = false,
+	.get_nr_lmacs	=	cgx_get_nr_lmacs,
+};
+
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -1199,6 +1300,12 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, cgx);
 
+	/* Use mac_ops to get MAC specific features */
+	if (pdev->device == PCI_DEVID_CN10K_RPM)
+		cgx->mac_ops = rpm_get_mac_ops();
+	else
+		cgx->mac_ops = &cgx_mac_ops;
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(dev, "Failed to enable PCI device\n");
@@ -1220,7 +1327,7 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_regions;
 	}
 
-	nvec = CGX_NVEC;
+	nvec = pci_msix_vec_count(cgx->pdev);
 	err = pci_alloc_irq_vectors(pdev, nvec, nvec, PCI_IRQ_MSIX);
 	if (err < 0 || err != nvec) {
 		dev_err(dev, "Request for %d msix vectors failed, err %d\n",
@@ -1244,6 +1351,8 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	cgx_link_usertable_init();
 
+	cgx_populate_features(cgx);
+
 	err = cgx_lmac_init(cgx);
 	if (err)
 		goto err_release_lmac;
@@ -1267,8 +1376,10 @@ static void cgx_remove(struct pci_dev *pdev)
 {
 	struct cgx *cgx = pci_get_drvdata(pdev);
 
-	cgx_lmac_exit(cgx);
-	list_del(&cgx->cgx_list);
+	if (cgx) {
+		cgx_lmac_exit(cgx);
+		list_del(&cgx->cgx_list);
+	}
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index b458ad0cebc8..301b830d262a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -13,6 +13,7 @@
 
 #include "mbox.h"
 #include "cgx_fw_if.h"
+#include "rpm.h"
 
  /* PCI device IDs */
 #define	PCI_DEVID_OCTEONTX2_CGX		0xA059
@@ -40,18 +41,18 @@
 #define FW_CGX_INT			BIT_ULL(1)
 #define CGXX_CMRX_INT_ENA_W1S		0x058
 #define CGXX_CMRX_RX_ID_MAP		0x060
-#define CGXX_CMRX_RX_STAT0		0x070
+#define CGXX_CMRX_RX_STAT0		(0x070 + mac_ops->csr_offset)
 #define CGXX_CMRX_RX_LMACS		0x128
-#define CGXX_CMRX_RX_DMAC_CTL0		0x1F8
+#define CGXX_CMRX_RX_DMAC_CTL0		(0x1F8 + mac_ops->csr_offset)
 #define CGX_DMAC_CTL0_CAM_ENABLE	BIT_ULL(3)
 #define CGX_DMAC_CAM_ACCEPT		BIT_ULL(3)
 #define CGX_DMAC_MCAST_MODE		BIT_ULL(1)
 #define CGX_DMAC_BCAST_MODE		BIT_ULL(0)
-#define CGXX_CMRX_RX_DMAC_CAM0		0x200
+#define CGXX_CMRX_RX_DMAC_CAM0		(0x200 + mac_ops->csr_offset)
 #define CGX_DMAC_CAM_ADDR_ENABLE	BIT_ULL(48)
 #define CGXX_CMRX_RX_DMAC_CAM1		0x400
 #define CGX_RX_DMAC_ADR_MASK		GENMASK_ULL(47, 0)
-#define CGXX_CMRX_TX_STAT0		0x700
+#define CGXX_CMRX_TX_STAT0		(0x700 + mac_ops->csr_offset)
 #define CGXX_SCRATCH0_REG		0x1050
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
@@ -86,7 +87,6 @@
 #define CGX_CMD_TIMEOUT			2200 /* msecs */
 #define DEFAULT_PAUSE_TIME		0x7FF
 
-#define CGX_NVEC			37
 #define CGX_LMAC_FWI			0
 
 enum  cgx_nix_stat_type {
@@ -157,5 +157,9 @@ int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
 int cgx_get_phy_fec_stats(void *cgxd, int lmac_id);
 int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
 		      int cgx_id, int lmac_id);
-
+u64 cgx_features_get(void *cgxd);
+struct mac_ops *get_mac_ops(void *cgxd);
+int cgx_get_nr_lmacs(void *cgxd);
+u8 cgx_get_lmacid(void *cgxd, u8 lmac_index);
+unsigned long cgx_get_lmac_bmap(void *cgxd);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
new file mode 100644
index 000000000000..ac36e1527d09
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RPM driver
+ *
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef LMAC_COMMON_H
+#define LMAC_COMMON_H
+
+#include "rvu.h"
+#include "cgx.h"
+/**
+ * struct lmac
+ * @wq_cmd_cmplt:	waitq to keep the process blocked until cmd completion
+ * @cmd_lock:		Lock to serialize the command interface
+ * @resp:		command response
+ * @link_info:		link related information
+ * @event_cb:		callback for linkchange events
+ * @event_cb_lock:	lock for serializing callback with unregister
+ * @cmd_pend:		flag set before new command is started
+ *			flag cleared after command response is received
+ * @cgx:		parent cgx port
+ * @lmac_id:		lmac port id
+ * @name:		lmac port name
+ */
+struct lmac {
+	wait_queue_head_t wq_cmd_cmplt;
+	/* Lock to serialize the command interface */
+	struct mutex cmd_lock;
+	u64 resp;
+	struct cgx_link_user_info link_info;
+	struct cgx_event_cb event_cb;
+	/* lock for serializing callback with unregister */
+	spinlock_t event_cb_lock;
+	bool cmd_pend;
+	struct cgx *cgx;
+	u8 lmac_id;
+	char *name;
+};
+
+/* CGX & RPM has different feature set
+ * update the structure fields with different one
+ */
+struct mac_ops {
+	char		       *name;
+	/* Features like RXSTAT, TXSTAT, DMAC FILTER csrs differs by fixed
+	 * bar offset for example
+	 * CGX DMAC_CTL0  0x1f8
+	 * RPM DMAC_CTL0  0x4ff8
+	 */
+	u64			csr_offset;
+	/* For ATF to send events to kernel, there is no dedicated interrupt
+	 * defined hence CGX uses OVERFLOW bit in CMR_INT. RPM block supports
+	 * SW_INT so that ATF triggers this interrupt after processing of
+	 * requested command
+	 */
+	u64			int_register;
+	u64			int_set_reg;
+	/* lmac offset is different is RPM */
+	u8			lmac_offset;
+	u8			irq_offset;
+	u8			int_ena_bit;
+	u8			lmac_fwi;
+	bool			non_contiguous_serdes_lane;
+	/* Incase of RPM get number of lmacs from RPMX_CMR_RX_LMACS[LMAC_EXIST]
+	 * number of setbits in lmac_exist tells number of lmacs
+	 */
+	int			(*get_nr_lmacs)(void *cgx);
+};
+
+struct cgx {
+	void __iomem		*reg_base;
+	struct pci_dev		*pdev;
+	u8			cgx_id;
+	u8			lmac_count;
+	struct lmac		*lmac_idmap[MAX_LMAC_PER_CGX];
+	struct			work_struct cgx_cmd_work;
+	struct			workqueue_struct *cgx_cmd_workq;
+	struct list_head	cgx_list;
+	u64			hw_features;
+	struct mac_ops		*mac_ops;
+	unsigned long		lmac_bmap; /* bitmap of enabled lmacs */
+};
+
+typedef struct cgx rpm_t;
+
+/* Function Declarations */
+void cgx_write(struct cgx *cgx, u64 lmac, u64 offset, u64 val);
+u64 cgx_read(struct cgx *cgx, u64 lmac, u64 offset);
+struct lmac *lmac_pdata(u8 lmac_id, struct cgx *cgx);
+int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac);
+int cgx_fwi_cmd_generic(u64 req, u64 *resp, struct cgx *cgx, int lmac_id);
+bool is_lmac_valid(struct cgx *cgx, int lmac_id);
+struct mac_ops *rpm_get_mac_ops(void);
+
+#endif /* LMAC_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f1a4f1985a61..28ef0769b3ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -159,6 +159,8 @@ M(CGX_GET_PHY_FEC_STATS, 0x212, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
 M(CGX_FW_DATA_GET,	0x213, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
 M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
 			       cgx_set_link_mode_rsp)	\
+M(CGX_FEATURES_GET,	0x215, cgx_features_get, msg_req,		\
+			       cgx_features_info_msg)			\
  /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
@@ -367,7 +369,7 @@ struct get_hw_cap_rsp {
 
 struct cgx_stats_rsp {
 	struct mbox_msghdr hdr;
-#define CGX_RX_STATS_COUNT	13
+#define CGX_RX_STATS_COUNT	9
 #define CGX_TX_STATS_COUNT	18
 	u64 rx_stats[CGX_RX_STATS_COUNT];
 	u64 tx_stats[CGX_TX_STATS_COUNT];
@@ -484,6 +486,17 @@ struct cgx_set_link_mode_rsp {
 	int status;
 };
 
+#define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
+#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precison time protocol */
+#define RVU_MAC_VERSION			BIT_ULL(2)
+#define RVU_MAC_CGX			0
+#define RVU_MAC_RPM			1
+
+struct cgx_features_info_msg {
+	struct mbox_msghdr hdr;
+	u64    lmac_features;
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
new file mode 100644
index 000000000000..e97baeea4e19
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Marvell OcteonTx2 RPM driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include "cgx.h"
+#include "lmac_common.h"
+
+static struct mac_ops	rpm_mac_ops   = {
+	.name		=       "rpm",
+	.csr_offset     =       0x4e00,
+	.lmac_offset    =       20,
+	.int_register	=       RPMX_CMRX_SW_INT,
+	.int_set_reg    =       RPMX_CMRX_SW_INT_ENA_W1S,
+	.irq_offset     =       1,
+	.int_ena_bit    =       BIT_ULL(0),
+	.lmac_fwi	=	RPM_LMAC_FWI,
+	.non_contiguous_serdes_lane = true,
+	.get_nr_lmacs	=	rpm_get_nr_lmacs,
+};
+
+struct mac_ops *rpm_get_mac_ops(void)
+{
+	return &rpm_mac_ops;
+}
+
+static u64 rpm_read(rpm_t *rpm, u64 lmac, u64 offset)
+{
+	return	cgx_read(rpm, lmac, offset);
+}
+
+int rpm_get_nr_lmacs(void *rpmd)
+{
+	rpm_t *rpm = rpmd;
+
+	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
new file mode 100644
index 000000000000..7f45c1c645bf
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RPM driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef RPM_H
+#define RPM_H
+
+/* PCI device IDs */
+#define PCI_DEVID_CN10K_RPM		0xA060
+
+/* Registers */
+#define RPMX_CMRX_SW_INT                0x180
+#define RPMX_CMRX_SW_INT_W1S            0x188
+#define RPMX_CMRX_SW_INT_ENA_W1S        0x198
+
+#define RPM_LMAC_FWI			0xa
+
+/* Function Declarations */
+int rpm_get_nr_lmacs(void *cgxd);
+#endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7714ec5a8dbe..d39fbefdd284 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -635,6 +635,8 @@ void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
+bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
+
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index be4a82c176a1..57327a91018b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -42,6 +42,20 @@ static struct _req_type __maybe_unused					\
 MBOX_UP_CGX_MESSAGES
 #undef M
 
+bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature)
+{
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return 0;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	return  (cgx_features_get(cgxd) & feature);
+}
+
 /* Returns bitmap of mapped PFs */
 static u16 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
 {
@@ -92,9 +106,10 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 {
 	struct npc_pkind *pkind = &rvu->hw->pkind;
 	int cgx_cnt_max = rvu->cgx_cnt_max;
-	int cgx, lmac_cnt, lmac;
 	int pf = PF_CGXMAP_BASE;
+	unsigned long lmac_bmap;
 	int size, free_pkind;
+	int cgx, lmac, iter;
 
 	if (!cgx_cnt_max)
 		return 0;
@@ -125,14 +140,17 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 	for (cgx = 0; cgx < cgx_cnt_max; cgx++) {
 		if (!rvu_cgx_pdata(cgx, rvu))
 			continue;
-		lmac_cnt = cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
-		for (lmac = 0; lmac < lmac_cnt; lmac++, pf++) {
+		lmac_bmap = cgx_get_lmac_bmap(rvu_cgx_pdata(cgx, rvu));
+		for_each_set_bit(iter, &lmac_bmap, MAX_LMAC_PER_CGX) {
+			lmac = cgx_get_lmacid(rvu_cgx_pdata(cgx, rvu),
+					      iter);
 			rvu->pf2cgxlmac_map[pf] = cgxlmac_id_to_bmap(cgx, lmac);
 			rvu->cgxlmac2pf_map[CGX_OFFSET(cgx) + lmac] = 1 << pf;
 			free_pkind = rvu_alloc_rsrc(&pkind->rsrc);
 			pkind->pfchan_map[free_pkind] = ((pf) & 0x3F) << 16;
 			rvu_map_cgx_nix_block(rvu, pf, cgx, lmac);
 			rvu->cgx_mapped_pfs++;
+			pf++;
 		}
 	}
 	return 0;
@@ -154,8 +172,10 @@ static int rvu_cgx_send_link_info(int cgx_id, int lmac_id, struct rvu *rvu)
 				&qentry->link_event.link_uinfo);
 	qentry->link_event.cgx_id = cgx_id;
 	qentry->link_event.lmac_id = lmac_id;
-	if (err)
+	if (err) {
+		kfree(qentry);
 		goto skip_add;
+	}
 	list_add_tail(&qentry->evq_node, &rvu->cgx_evq_head);
 skip_add:
 	spin_unlock_irqrestore(&rvu->cgx_evq_lock, flags);
@@ -251,6 +271,7 @@ static void cgx_evhandler_task(struct work_struct *work)
 
 static int cgx_lmac_event_handler_init(struct rvu *rvu)
 {
+	unsigned long lmac_bmap;
 	struct cgx_event_cb cb;
 	int cgx, lmac, err;
 	void *cgxd;
@@ -271,7 +292,8 @@ static int cgx_lmac_event_handler_init(struct rvu *rvu)
 		cgxd = rvu_cgx_pdata(cgx, rvu);
 		if (!cgxd)
 			continue;
-		for (lmac = 0; lmac < cgx_get_lmac_cnt(cgxd); lmac++) {
+		lmac_bmap = cgx_get_lmac_bmap(cgxd);
+		for_each_set_bit(lmac, &lmac_bmap, MAX_LMAC_PER_CGX) {
 			err = cgx_lmac_evh_register(&cb, cgxd, lmac);
 			if (err)
 				dev_err(rvu->dev,
@@ -349,6 +371,7 @@ int rvu_cgx_init(struct rvu *rvu)
 
 int rvu_cgx_exit(struct rvu *rvu)
 {
+	unsigned long lmac_bmap;
 	int cgx, lmac;
 	void *cgxd;
 
@@ -356,7 +379,8 @@ int rvu_cgx_exit(struct rvu *rvu)
 		cgxd = rvu_cgx_pdata(cgx, rvu);
 		if (!cgxd)
 			continue;
-		for (lmac = 0; lmac < cgx_get_lmac_cnt(cgxd); lmac++)
+		lmac_bmap = cgx_get_lmac_bmap(cgxd);
+		for_each_set_bit(lmac, &lmac_bmap, MAX_LMAC_PER_CGX)
 			cgx_lmac_evh_unregister(cgxd, lmac);
 	}
 
@@ -554,6 +578,9 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	u8 cgx_id, lmac_id;
 	void *cgxd;
 
+	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_PTP))
+		return 0;
+
 	/* This msg is expected only from PFs that are mapped to CGX LMACs,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
@@ -640,6 +667,24 @@ int rvu_mbox_handler_cgx_get_linkinfo(struct rvu *rvu, struct msg_req *req,
 	return err;
 }
 
+int rvu_mbox_handler_cgx_features_get(struct rvu *rvu,
+				      struct msg_req *req,
+				      struct cgx_features_info_msg *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_idx, lmac;
+	void *cgxd;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return 0;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
+	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+	rsp->lmac_features = cgx_features_get(cgxd);
+
+	return 0;
+}
+
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
@@ -675,6 +720,9 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
+	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_FC))
+		return 0;
+
 	/* This msg is expected only from PF/VFs that are mapped to CGX LMACs,
 	 * if received from other PF/VF simply ACK, nothing to do.
 	 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 02775d49cf0f..96ae6f79568d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -19,6 +19,7 @@
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "cgx.h"
+#include "lmac_common.h"
 #include "npc.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
@@ -234,6 +235,8 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 {
 	struct rvu *rvu = filp->private;
 	struct pci_dev *pdev = NULL;
+	struct mac_ops *mac_ops;
+	int rvu_def_cgx_id = 0;
 	char cgx[10], lmac[10];
 	struct rvu_pfvf *pfvf;
 	int pf, domain, blkid;
@@ -241,7 +244,9 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 	u16 pcifunc;
 
 	domain = 2;
-	seq_puts(filp, "PCI dev\t\tRVU PF Func\tNIX block\tCGX\tLMAC\n");
+	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	seq_printf(filp, "PCI dev\t\tRVU PF Func\tNIX block\t%s\tLMAC\n",
+		   mac_ops->name);
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		if (!is_pf_cgxmapped(rvu, pf))
 			continue;
@@ -262,7 +267,7 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id,
 				    &lmac_id);
-		sprintf(cgx, "CGX%d", cgx_id);
+		sprintf(cgx, "%s%d", mac_ops->name, cgx_id);
 		sprintf(lmac, "LMAC%d", lmac_id);
 		seq_printf(filp, "%s\t0x%x\t\tNIX%d\t\t%s\t%s\n",
 			   dev_name(&pdev->dev), pcifunc, blkid, cgx, lmac);
@@ -1601,6 +1606,7 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 static int cgx_print_stats(struct seq_file *s, int lmac_id)
 {
 	struct cgx_link_user_info linfo;
+	struct mac_ops *mac_ops;
 	void *cgxd = s->private;
 	u64 ucast, mcast, bcast;
 	int stat = 0, err = 0;
@@ -1612,6 +1618,11 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 	if (!rvu)
 		return -ENODEV;
 
+	mac_ops = get_mac_ops(cgxd);
+
+	if (!mac_ops)
+		return 0;
+
 	/* Link status */
 	seq_puts(s, "\n=======Link Status======\n\n");
 	err = cgx_get_link_info(cgxd, lmac_id, &linfo);
@@ -1621,7 +1632,8 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		   linfo.link_up ? "UP" : "DOWN", linfo.speed);
 
 	/* Rx stats */
-	seq_puts(s, "\n=======NIX RX_STATS(CGX port level)======\n\n");
+	seq_printf(s, "\n=======NIX RX_STATS(%s port level)======\n\n",
+		   mac_ops->name);
 	ucast = PRINT_CGX_CUML_NIXRX_STATUS(RX_UCAST, "rx_ucast_frames");
 	if (err)
 		return err;
@@ -1643,7 +1655,8 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		return err;
 
 	/* Tx stats */
-	seq_puts(s, "\n=======NIX TX_STATS(CGX port level)======\n\n");
+	seq_printf(s, "\n=======NIX TX_STATS(%s port level)======\n\n",
+		   mac_ops->name);
 	ucast = PRINT_CGX_CUML_NIXTX_STATUS(TX_UCAST, "tx_ucast_frames");
 	if (err)
 		return err;
@@ -1662,7 +1675,7 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		return err;
 
 	/* Rx stats */
-	seq_puts(s, "\n=======CGX RX_STATS======\n\n");
+	seq_printf(s, "\n=======%s RX_STATS======\n\n", mac_ops->name);
 	while (stat < CGX_RX_STATS_COUNT) {
 		err = cgx_get_rx_stats(cgxd, lmac_id, stat, &rx_stat);
 		if (err)
@@ -1673,7 +1686,7 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 
 	/* Tx stats */
 	stat = 0;
-	seq_puts(s, "\n=======CGX TX_STATS======\n\n");
+	seq_printf(s, "\n=======%s TX_STATS======\n\n", mac_ops->name);
 	while (stat < CGX_TX_STATS_COUNT) {
 		err = cgx_get_tx_stats(cgxd, lmac_id, stat, &tx_stat);
 		if (err)
@@ -1709,6 +1722,9 @@ RVU_DEBUG_SEQ_FOPS(cgx_stat, cgx_stat_display, NULL);
 
 static void rvu_dbg_cgx_init(struct rvu *rvu)
 {
+	struct mac_ops *mac_ops;
+	unsigned long lmac_bmap;
+	int rvu_def_cgx_id = 0;
 	int i, lmac_id;
 	char dname[20];
 	void *cgx;
@@ -1716,17 +1732,24 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 	if (!cgx_get_cgxcnt_max())
 		return;
 
-	rvu->rvu_dbg.cgx_root = debugfs_create_dir("cgx", rvu->rvu_dbg.root);
+	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	if (!mac_ops)
+		return;
+
+	rvu->rvu_dbg.cgx_root = debugfs_create_dir(mac_ops->name,
+						   rvu->rvu_dbg.root);
 
 	for (i = 0; i < cgx_get_cgxcnt_max(); i++) {
 		cgx = rvu_cgx_pdata(i, rvu);
 		if (!cgx)
 			continue;
+		lmac_bmap = cgx_get_lmac_bmap(cgx);
 		/* cgx debugfs dir */
-		sprintf(dname, "cgx%d", i);
+		sprintf(dname, "%s%d", mac_ops->name, i);
 		rvu->rvu_dbg.cgx = debugfs_create_dir(dname,
 						      rvu->rvu_dbg.cgx_root);
-		for (lmac_id = 0; lmac_id < cgx_get_lmac_cnt(cgx); lmac_id++) {
+
+		for_each_set_bit(lmac_id, &lmac_bmap, MAX_LMAC_PER_CGX) {
 			/* lmac debugfs dir */
 			sprintf(dname, "lmac%d", lmac_id);
 			rvu->rvu_dbg.lmac =
@@ -2307,9 +2330,18 @@ void rvu_dbg_init(struct rvu *rvu)
 
 	debugfs_create_file("rsrc_alloc", 0444, rvu->rvu_dbg.root, rvu,
 			    &rvu_dbg_rsrc_status_fops);
-	debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root, rvu,
-			    &rvu_dbg_rvu_pf_cgx_map_fops);
 
+	if (!cgx_get_cgxcnt_max())
+		goto create;
+
+	if (is_rvu_otx2(rvu))
+		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
+				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
+	else
+		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
+				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
+
+create:
 	rvu_dbg_npa_init(rvu);
 	rvu_dbg_nix_init(rvu, BLKADDR_NIX0);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 46da18d611d4..0c9b1c37a8c6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3631,10 +3631,14 @@ static int rvu_nix_lf_ptp_tx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
-	int blkaddr;
+	int blkaddr, pf;
 	int nixlf;
 	u64 cfg;
 
+	pf = rvu_get_pf(pcifunc);
+	if (!is_mac_feature_supported(rvu, pf, RVU_LMAC_FEAT_PTP))
+		return 0;
+
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
 		return NIX_AF_ERR_AF_LF_INVALID;
-- 
2.17.1

