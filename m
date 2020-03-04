Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7243E17945F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgCDQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:04:40 -0500
Received: from inva020.nxp.com ([92.121.34.13]:32780 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgCDQEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:04:38 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 856D41A01C6;
        Wed,  4 Mar 2020 17:04:35 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 81D4A1A01C4;
        Wed,  4 Mar 2020 17:04:35 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2450D202D2;
        Wed,  4 Mar 2020 17:04:35 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net v2 3/4] fsl/fman: detect FMan erratum A050385
Date:   Wed,  4 Mar 2020 18:04:27 +0200
Message-Id: <1583337868-3320-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

Detect the presence of the A050385 erratum.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
Changes in v2:
 - added CONFIG_DPAA_ERRATUM_A050385

 drivers/net/ethernet/freescale/fman/Kconfig | 28 ++++++++++++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.c  | 18 ++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.h  |  5 +++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index 0139cb9042ec..34150182cc35 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -8,3 +8,31 @@ config FSL_FMAN
 	help
 		Freescale Data-Path Acceleration Architecture Frame Manager
 		(FMan) support
+
+config DPAA_ERRATUM_A050385
+	bool
+	depends on ARM64 && FSL_DPAA
+	default y
+	help
+		DPAA FMan erratum A050385 software workaround implementation:
+		align buffers, data start, SG fragment length to avoid FMan DMA
+		splits.
+		FMAN DMA read or writes under heavy traffic load may cause FMAN
+		internal resource leak thus stopping further packet processing.
+		The FMAN internal queue can overflow when FMAN splits single
+		read or write transactions into multiple smaller transactions
+		such that more than 17 AXI transactions are in flight from FMAN
+		to interconnect. When the FMAN internal queue overflows, it can
+		stall further packet processing. The issue can occur with any
+		one of the following three conditions:
+		1. FMAN AXI transaction crosses 4K address boundary (Errata
+		A010022)
+		2. FMAN DMA address for an AXI transaction is not 16 byte
+		aligned, i.e. the last 4 bits of an address are non-zero
+		3. Scatter Gather (SG) frames have more than one SG buffer in
+		the SG list and any one of the buffers, except the last
+		buffer in the SG list has data size that is not a multiple
+		of 16 bytes, i.e., other than 16, 32, 48, 64, etc.
+		With any one of the above three conditions present, there is
+		likelihood of stalled FMAN packet processing, especially under
+		stress with multiple ports injecting line-rate traffic.
diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 934111def0be..f151d6e111dd 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -566,6 +567,10 @@ struct fman_cfg {
 	u32 qmi_def_tnums_thresh;
 };
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+static bool fman_has_err_a050385;
+#endif
+
 static irqreturn_t fman_exceptions(struct fman *fman,
 				   enum fman_exceptions exception)
 {
@@ -2518,6 +2523,14 @@ struct fman *fman_bind(struct device *fm_dev)
 }
 EXPORT_SYMBOL(fman_bind);
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+bool fman_has_errata_a050385(void)
+{
+	return fman_has_err_a050385;
+}
+EXPORT_SYMBOL(fman_has_errata_a050385);
+#endif
+
 static irqreturn_t fman_err_irq(int irq, void *handle)
 {
 	struct fman *fman = (struct fman *)handle;
@@ -2845,6 +2858,11 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 		goto fman_free;
 	}
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+	fman_has_err_a050385 =
+		of_property_read_bool(fm_node, "fsl,erratum-a050385");
+#endif
+
 	return fman;
 
 fman_node_put:
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index 935c317fa696..f2ede1360f03 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -398,6 +399,10 @@ u16 fman_get_max_frm(void);
 
 int fman_get_rx_extra_headroom(void);
 
+#ifdef CONFIG_DPAA_ERRATUM_A050385
+bool fman_has_errata_a050385(void);
+#endif
+
 struct fman *fman_bind(struct device *dev);
 
 #endif /* __FM_H */
-- 
2.1.0

