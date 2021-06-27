Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEF63B547A
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhF0RWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhF0RWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 13:22:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFF4C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g24so8526277pji.4
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qaot+TzaDvBtYaDU+kGb+b0QPRw378XDllUyXE9l1cA=;
        b=Q406fZkwFw7JTEg8cRr+5+yjq8l7TLJgHPiYee5N1ytLyoFq6yCeLzmqDF9geFVUkF
         k1R1zlcKSnof5CilQ8qYvvFCH4tBs5mV8pE6hkQglrNs1nx/t6w2EWRv2zaZnJMO5CpP
         wUKz4BqMEvOGQoQisPPqiYW6XXB+v3wSl3Wd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qaot+TzaDvBtYaDU+kGb+b0QPRw378XDllUyXE9l1cA=;
        b=IF24URyJYKMFDw4mKZPTiiiPbOjdYZOPEHkkRMB/dyLguU1QCytjo3/8Zi5nQL39XN
         TcFfOxSbh6i6fl3NOmDhKFugZn+C0rSi3zVgrWBW4eiA9mylektO0sShL350DZxmangE
         84zMSseEeFgk01KNcz64gWmPHtumeY5vYNnNppdfEosmEWKFeBH1jRfgAN+aQXqtCVDt
         TB6QF0ajPbgiJwE872Gfb9UYmksODRGD4rcjRhZf4WKqjLuOHkTJZ0DwSwP1KguJi/40
         LKZ/f9vsHkDyWB3e8WsvS4zLu1S/HlMuF7llnfFoZPLS5oY8VH4SvAFc6mwFm0Z4OAjN
         /tjw==
X-Gm-Message-State: AOAM533+UuzrIaDnouH++yaGDhViicYRgEJIqb2sF1EeKWd5iGpw/yFl
        ykduFz0Lu5TTL16aXyoE3EA4Ag==
X-Google-Smtp-Source: ABdhPJz78aTIhClY4NWtK3derfUoM02OwJMMNGccUfi6OAOJXkbCmrtp8Xw0w3nGfsMf9A3+sXu1eA==
X-Received: by 2002:a17:903:248e:b029:101:fa49:3f96 with SMTP id p14-20020a170903248eb0290101fa493f96mr18673272plw.16.1624814424929;
        Sun, 27 Jun 2021 10:20:24 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm11011584pfu.60.2021.06.27.10.20.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 10:20:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next v2 3/7] bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods
Date:   Sun, 27 Jun 2021 13:19:46 -0400
Message-Id: <1624814390-1300-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
References: <1624814390-1300-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a738b205c5c296f4"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a738b205c5c296f4

Add the clock APIs to set/get/adjust the hw clock, and the related
ioctls and ethtool methods.

v2: Propagate error code from ptp_clock_register().
    Add spinlock to serialize access to the timecounter.  The
    timecounter is accessed in process context and the RX datapath.
    Read the PHC using direct registers.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/Kconfig         |   1 +
 drivers/net/ethernet/broadcom/bnxt/Makefile   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   6 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  34 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 324 ++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  16 +
 6 files changed, 382 insertions(+), 1 deletion(-)
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
index 081cdcb02b48..1250a5b50b50 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10390,6 +10390,12 @@ static int bnxt_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
index 000000000000..47f1f9c3380c
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -0,0 +1,324 @@
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
+	spin_lock_bh(&ptp->ptp_lock);
+	timecounter_init(&ptp->tc, &ptp->cc, ns);
+	spin_unlock_bh(&ptp->ptp_lock);
+	return 0;
+}
+
+/* Caller holds ptp_lock */
+static u64 bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u64 ns;
+
+	ptp_read_system_prets(sts);
+	ns = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+	ptp_read_system_postts(sts);
+	ns |= (u64)readl(bp->bar0 + ptp->refclk_mapped_regs[1]) << 32;
+	return ns;
+}
+
+static int bnxt_ptp_gettimex(struct ptp_clock_info *ptp_info,
+			     struct timespec64 *ts,
+			     struct ptp_system_timestamp *sts)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	u64 ns, cycles;
+
+	spin_lock_bh(&ptp->ptp_lock);
+	cycles = bnxt_refclk_read(ptp->bp, sts);
+	ns = timecounter_cyc2time(&ptp->tc, cycles);
+	spin_unlock_bh(&ptp->ptp_lock);
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
+	spin_lock_bh(&ptp->ptp_lock);
+	timecounter_adjtime(&ptp->tc, delta);
+	spin_unlock_bh(&ptp->ptp_lock);
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
+	req.ptp_freq_adj_ppb = cpu_to_le32(ppb);
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
+static int bnxt_map_regs(struct bnxt *bp, u32 *reg_arr, int count, int reg_win)
+{
+	u32 reg_base = *reg_arr & BNXT_GRC_BASE_MASK;
+	u32 win_off;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if ((reg_arr[i] & BNXT_GRC_BASE_MASK) != reg_base)
+			return -ERANGE;
+	}
+	win_off = BNXT_GRCPF_REG_WINDOW_BASE_OUT + (reg_win - 1) * 4;
+	writel(reg_base, bp->bar0 + win_off);
+	return 0;
+}
+
+static int bnxt_map_ptp_regs(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u32 *reg_arr;
+	int rc, i;
+
+	reg_arr = ptp->refclk_regs;
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		rc = bnxt_map_regs(bp, reg_arr, 2, BNXT_PTP_GRC_WIN);
+		if (rc)
+			return rc;
+		for (i = 0; i < 2; i++)
+			ptp->refclk_mapped_regs[i] = BNXT_PTP_GRC_WIN_BASE +
+				(ptp->refclk_regs[i] & BNXT_GRC_OFFSET_MASK);
+		return 0;
+	}
+	return -ENODEV;
+}
+
+static void bnxt_unmap_ptp_regs(struct bnxt *bp)
+{
+	writel(0, bp->bar0 + BNXT_GRCPF_REG_WINDOW_BASE_OUT +
+		  (BNXT_PTP_GRC_WIN - 1) * 4);
+}
+
+static u64 bnxt_cc_read(const struct cyclecounter *cc)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(cc, struct bnxt_ptp_cfg, cc);
+
+	return bnxt_refclk_read(ptp->bp, NULL);
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
+	int rc;
+
+	if (!ptp)
+		return 0;
+
+	rc = bnxt_map_ptp_regs(bp);
+	if (rc)
+		return rc;
+
+	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
+	spin_lock_init(&ptp->ptp_lock);
+
+	memset(&ptp->cc, 0, sizeof(ptp->cc));
+	ptp->cc.read = bnxt_cc_read;
+	ptp->cc.mask = CYCLECOUNTER_MASK(48);
+	ptp->cc.shift = 0;
+	ptp->cc.mult = 1;
+
+	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
+
+	ptp->ptp_info = bnxt_ptp_caps;
+	ptp->ptp_clock = ptp_clock_register(&ptp->ptp_info, &bp->pdev->dev);
+	if (IS_ERR(ptp->ptp_clock)) {
+		int err = PTR_ERR(ptp->ptp_clock);
+
+		ptp->ptp_clock = NULL;
+		bnxt_unmap_ptp_regs(bp);
+		return err;
+	}
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
+	bnxt_unmap_ptp_regs(bp);
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 603f0fdb71c2..93a9921a8b46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -10,6 +10,17 @@
 #ifndef BNXT_PTP_H
 #define BNXT_PTP_H
 
+#define BNXT_PTP_GRC_WIN	5
+#define BNXT_PTP_GRC_WIN_BASE	0x5000
+
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
@@ -46,4 +57,9 @@ struct bnxt_ptp_cfg {
 	u32			refclk_regs[2];
 	u32			refclk_mapped_regs[2];
 };
+
+int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
+int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
+int bnxt_ptp_init(struct bnxt *bp);
+void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.18.1


--000000000000a738b205c5c296f4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBU7pss3bqrGWrQQJ3DigGODcftDxCiB
yWJnn0EV2glbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYy
NzE3MjAyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBvrtbq67uNatOvH6NXxjLACSJx2bRhe9pj/1Ye5p52F5kGG+5Z
eSufhgs7IuPQ741DEOIsWKuRt6HH1xKQIB7acJ4O/qZF+O3HlWvwDy348kiuR6b6ihn21htWTIIU
X2AVW7jk+sWlZ0pttGI1RBbT2y1wa6RvJYJEqtewir1AfO6LQqNW22W6sP6WB7FHfa9KkuvBSN+4
CpiBDYSI9owQ1QbhU5MLDvi1prSWO6XNxqctUYukTRJ2oewoAjjTqQqnZV22Xw96GfnhPtfv98pS
uNjuo9W589cLeBReGDjBf1Hn+gA1NKTbsuieM3SOBeBgdmjqQ/Pg5LmWTmTtYWqz
--000000000000a738b205c5c296f4--
