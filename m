Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E17B3949B8
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhE2AzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:02 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39874 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhE2AzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:01 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9F4247DAF;
        Fri, 28 May 2021 17:53:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9F4247DAF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249605;
        bh=7WfXg0dcuxbOxviOPUfsw8YCBe/J7ieaoRhBc8JRcCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmvRTSSFGuzykz1dqfKBk1lozhKly1192pEg2hUIVD5cPH2dPAoKZdwfwd+IHIm36
         6RM7nB53ptcAXfwpPpK4ryaiNQ5ejmROVkhFp3Gmle6IiPEA/wjrr+lE8qiI2gjIa1
         rSGZzEKjxDoWiFtGAcko7JysEir7Tyeon4W30tCs=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 3/7] bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods.
Date:   Fri, 28 May 2021 20:53:17 -0400
Message-Id: <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the clock APIs to set/get/adjust the hw clock, and the related
ioctls and ethtool methods.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/Kconfig         |   1 +
 drivers/net/ethernet/broadcom/bnxt/Makefile   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   6 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  34 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 291 ++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  13 +
 6 files changed, 346 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index cb88ffb8f12f..1a02ca600b71 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -206,6 +206,7 @@ config SYSTEMPORT
 config BNXT
 	tristate "Broadcom NetXtreme-C/E support"
 	depends on PCI
+	imply PTP_1588_CLOCK
 	select FW_LOADER
 	select LIBCRC32C
 	select NET_DEVLINK
diff --git a/drivers/net/ethernet/broadcom/bnxt/Makefile b/drivers/net/ethernet/broadcom/bnxt/Makefile
index cb97ec56fdec..2b8ae687b3c1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/Makefile
+++ b/drivers/net/ethernet/broadcom/bnxt/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_BNXT) += bnxt_en.o
 
-bnxt_en-y := bnxt.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o
+bnxt_en-y := bnxt.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_ptp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o
 bnxt_en-$(CONFIG_BNXT_FLOWER_OFFLOAD) += bnxt_tc.o
 bnxt_en-$(CONFIG_DEBUG_FS) += bnxt_debugfs.o
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index faf5fdbdf8c7..e89207413155 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10379,6 +10379,12 @@ static int bnxt_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return bnxt_hwrm_port_phy_write(bp, mdio->phy_id, mdio->reg_num,
 						mdio->val_in);
 
+	case SIOCSHWTSTAMP:
+		return bnxt_hwtstamp_set(dev, ifr);
+
+	case SIOCGHWTSTAMP:
+		return bnxt_hwtstamp_get(dev, ifr);
+
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c664ec52ebcf..786ca51e669b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -19,9 +19,13 @@
 #include <linux/firmware.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/net_tstamp.h>
+#include <linux/timecounter.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_xdp.h"
+#include "bnxt_ptp.h"
 #include "bnxt_ethtool.h"
 #include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
 #include "bnxt_fw_hdr.h"	/* Firmware hdr constant and structure defs */
@@ -3926,6 +3930,35 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	return 0;
 }
 
+static int bnxt_get_ts_info(struct net_device *dev,
+			    struct ethtool_ts_info *info)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_ptp_cfg *ptp;
+
+	ptp = bp->ptp_cfg;
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
+
+	info->phc_index = -1;
+	if (!ptp)
+		return 0;
+
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	if (ptp->ptp_clock)
+		info->phc_index = ptp_clock_index(ptp->ptp_clock);
+
+	info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
+
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+	return 0;
+}
+
 void bnxt_ethtool_init(struct bnxt *bp)
 {
 	struct hwrm_selftest_qlist_output *resp = bp->hwrm_cmd_resp_addr;
@@ -4172,6 +4205,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.nway_reset		= bnxt_nway_reset,
 	.set_phys_id		= bnxt_set_phys_id,
 	.self_test		= bnxt_self_test,
+	.get_ts_info		= bnxt_get_ts_info,
 	.reset			= bnxt_reset,
 	.set_dump		= bnxt_set_dump,
 	.get_dump_flag		= bnxt_get_dump_flag,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
new file mode 100644
index 000000000000..53fe98245b89
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -0,0 +1,291 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2021 Broadcom Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/net_tstamp.h>
+#include <linux/timecounter.h>
+#include <linux/timekeeping.h>
+#include "bnxt_hsi.h"
+#include "bnxt.h"
+#include "bnxt_ptp.h"
+
+static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
+			    const struct timespec64 *ts)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	u64 ns = timespec64_to_ns(ts);
+
+	timecounter_init(&ptp->tc, &ptp->cc, ns);
+	return 0;
+}
+
+static int bnxt_hwrm_port_ts_query(struct bnxt *bp, u32 flags, u64 *ts,
+				   struct ptp_system_timestamp *sts)
+{
+	struct hwrm_port_ts_query_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_port_ts_query_input req = {0};
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_TS_QUERY, -1, -1);
+	req.flags = cpu_to_le32(flags);
+	if ((flags & PORT_TS_QUERY_REQ_FLAGS_PATH) ==
+	    PORT_TS_QUERY_REQ_FLAGS_PATH_TX) {
+		req.enables = cpu_to_le16(BNXT_PTP_QTS_TX_ENABLES);
+		req.ptp_seq_id = cpu_to_le32(bp->ptp_cfg->tx_seqid);
+		req.ts_req_timeout = cpu_to_le16(BNXT_PTP_QTS_TIMEOUT);
+	}
+	mutex_lock(&bp->hwrm_cmd_lock);
+	ptp_read_system_prets(sts);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	ptp_read_system_postts(sts);
+	if (!rc)
+		*ts = le64_to_cpu(resp->ptp_msg_ts);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
+static int bnxt_ptp_gettimex(struct ptp_clock_info *ptp_info,
+			     struct timespec64 *ts,
+			     struct ptp_system_timestamp *sts)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	u32 flags = PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME;
+	u64 ns, cycles;
+	int rc;
+
+	rc = bnxt_hwrm_port_ts_query(ptp->bp, flags, &cycles, sts);
+	if (rc)
+		return rc;
+
+	ns = timecounter_cyc2time(&ptp->tc, cycles);
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+
+	timecounter_adjtime(&ptp->tc, delta);
+	return 0;
+}
+
+static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	struct hwrm_port_mac_cfg_input req = {0};
+	struct bnxt *bp = ptp->bp;
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_MAC_CFG, -1, -1);
+	req.ptp_freq_adj_ppb = ppb;
+	req.enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		netdev_err(ptp->bp->dev,
+			   "ptp adjfreq failed. rc = %d\n", rc);
+	return rc;
+}
+
+static int bnxt_ptp_enable(struct ptp_clock_info *ptp,
+			   struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
+{
+	struct hwrm_port_mac_cfg_input req = {0};
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u32 flags = 0;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PORT_MAC_CFG, -1, -1);
+	if (ptp->rx_filter)
+		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_ENABLE;
+	else
+		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
+	if (ptp->tx_tstamp_en)
+		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_ENABLE;
+	else
+		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_DISABLE;
+	req.flags = cpu_to_le32(flags);
+	req.enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
+	req.rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
+
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
+int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct hwtstamp_config stmpconf;
+	struct bnxt_ptp_cfg *ptp;
+	u16 old_rxctl;
+	int old_rx_filter, rc;
+	u8 old_tx_tstamp_en;
+
+	ptp = bp->ptp_cfg;
+	if (!ptp)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&stmpconf, ifr->ifr_data, sizeof(stmpconf)))
+		return -EFAULT;
+
+	if (stmpconf.flags)
+		return -EINVAL;
+
+	if (stmpconf.tx_type != HWTSTAMP_TX_ON &&
+	    stmpconf.tx_type != HWTSTAMP_TX_OFF)
+		return -ERANGE;
+
+	old_rx_filter = ptp->rx_filter;
+	old_rxctl = ptp->rxctl;
+	old_tx_tstamp_en = ptp->tx_tstamp_en;
+	switch (stmpconf.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ptp->rxctl = 0;
+		ptp->rx_filter = HWTSTAMP_FILTER_NONE;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+		ptp->rxctl = BNXT_PTP_MSG_EVENTS;
+		ptp->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+		ptp->rxctl = BNXT_PTP_MSG_SYNC;
+		ptp->rx_filter = HWTSTAMP_FILTER_PTP_V2_SYNC;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		ptp->rxctl = BNXT_PTP_MSG_DELAY_REQ;
+		ptp->rx_filter = HWTSTAMP_FILTER_PTP_V2_DELAY_REQ;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (stmpconf.tx_type == HWTSTAMP_TX_ON)
+		ptp->tx_tstamp_en = 1;
+	else
+		ptp->tx_tstamp_en = 0;
+
+	rc = bnxt_hwrm_ptp_cfg(bp);
+	if (rc)
+		goto ts_set_err;
+
+	stmpconf.rx_filter = ptp->rx_filter;
+	return copy_to_user(ifr->ifr_data, &stmpconf, sizeof(stmpconf)) ?
+		-EFAULT : 0;
+
+ts_set_err:
+	ptp->rx_filter = old_rx_filter;
+	ptp->rxctl = old_rxctl;
+	ptp->tx_tstamp_en = old_tx_tstamp_en;
+	return rc;
+}
+
+int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	struct hwtstamp_config stmpconf;
+	struct bnxt_ptp_cfg *ptp;
+
+	ptp = bp->ptp_cfg;
+	if (!ptp)
+		return -EOPNOTSUPP;
+
+	stmpconf.flags = 0;
+	stmpconf.tx_type = ptp->tx_tstamp_en ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
+
+	stmpconf.rx_filter = ptp->rx_filter;
+	return copy_to_user(ifr->ifr_data, &stmpconf, sizeof(stmpconf)) ?
+		-EFAULT : 0;
+}
+
+static u64 bnxt_cc_read(const struct cyclecounter *cc)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(cc, struct bnxt_ptp_cfg, cc);
+	u32 flags = PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME;
+	struct bnxt *bp = ptp->bp;
+	int rc;
+	u64 ns;
+
+	rc = bnxt_hwrm_port_ts_query(bp, flags, &ns, NULL);
+	if (rc)
+		netdev_err(bp->dev, "TS query for cc_read failed rc = %x\n",
+			   rc);
+	return ns;
+}
+
+static const struct ptp_clock_info bnxt_ptp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "bnxt clock",
+	.max_adj	= BNXT_MAX_PHC_DRIFT,
+	.n_alarm	= 0,
+	.n_ext_ts	= 0,
+	.n_per_out	= 0,
+	.n_pins		= 0,
+	.pps		= 0,
+	.adjfreq	= bnxt_ptp_adjfreq,
+	.adjtime	= bnxt_ptp_adjtime,
+	.gettimex64	= bnxt_ptp_gettimex,
+	.settime64	= bnxt_ptp_settime,
+	.enable		= bnxt_ptp_enable,
+};
+
+int bnxt_ptp_init(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (!ptp)
+		return 0;
+
+	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
+
+	memset(&ptp->cc, 0, sizeof(ptp->cc));
+	ptp->cc.read = bnxt_cc_read;
+	ptp->cc.mask = CYCLECOUNTER_MASK(64);
+	ptp->cc.shift = 0;
+	ptp->cc.mult = 1;
+
+	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+
+	ptp->ptp_info = bnxt_ptp_caps;
+	ptp->ptp_clock = ptp_clock_register(&ptp->ptp_info, &bp->pdev->dev);
+	if (IS_ERR(ptp->ptp_clock))
+		ptp->ptp_clock = NULL;
+
+	return 0;
+}
+
+void bnxt_ptp_clear(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	if (!ptp)
+		return;
+
+	if (ptp->ptp_clock)
+		ptp_clock_unregister(ptp->ptp_clock);
+
+	ptp->ptp_clock = NULL;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index aecca18ecfbd..54b368d49fa8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -10,6 +10,14 @@
 #ifndef BNXT_PTP_H
 #define BNXT_PTP_H
 
+#define BNXT_MAX_PHC_DRIFT	31000000
+#define BNXT_LO_TIMER_MASK	0x0000ffffffffUL
+#define BNXT_HI_TIMER_MASK	0xffff00000000UL
+
+#define BNXT_PTP_QTS_TIMEOUT	1000
+#define BNXT_PTP_QTS_TX_ENABLES	(PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID |	\
+				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT)
+
 struct bnxt_ptp_cfg {
 	struct ptp_clock_info	ptp_info;
 	struct ptp_clock	*ptp_clock;
@@ -41,4 +49,9 @@ struct bnxt_ptp_cfg {
 	u8			tx_tstamp_en:1;
 	int			rx_filter;
 };
+
+int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
+int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_ptp_init(struct bnxt *bp);
+void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.18.1

