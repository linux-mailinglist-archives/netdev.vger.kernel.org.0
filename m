Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D38177B39
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgCCPzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:55:50 -0500
Received: from inva021.nxp.com ([92.121.34.21]:33894 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbgCCPzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 10:55:48 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3728520146B;
        Tue,  3 Mar 2020 16:55:46 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2A2E420146A;
        Tue,  3 Mar 2020 16:55:46 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8809A20414;
        Tue,  3 Mar 2020 16:55:45 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net 3/4] fsl/fman: detect FMan erratum A050385
Date:   Tue,  3 Mar 2020 17:55:38 +0200
Message-Id: <1583250939-24645-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583250939-24645-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583250939-24645-1-git-send-email-madalin.bucur@oss.nxp.com>
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
 drivers/net/ethernet/freescale/fman/fman.c | 18 ++++++++++++++++++
 drivers/net/ethernet/freescale/fman/fman.h | 10 ++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 934111def0be..a673917b7411 100644
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
 
+#ifdef DPAA_FMAN_ERRATUM_A050385
+static bool fman_has_err_a050385;
+#endif
+
 static irqreturn_t fman_exceptions(struct fman *fman,
 				   enum fman_exceptions exception)
 {
@@ -2518,6 +2523,14 @@ struct fman *fman_bind(struct device *fm_dev)
 }
 EXPORT_SYMBOL(fman_bind);
 
+#ifdef DPAA_FMAN_ERRATUM_A050385
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
 
+#ifdef DPAA_FMAN_ERRATUM_A050385
+	fman_has_err_a050385 =
+		of_property_read_bool(fm_node, "fsl,erratum-a050385");
+#endif
+
 	return fman;
 
 fman_node_put:
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index 935c317fa696..7b14ef4c306d 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2008-2015 Freescale Semiconductor Inc.
+ * Copyright 2020 NXP
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
@@ -37,6 +38,11 @@
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
 
+#ifdef CONFIG_ARM64
+/* only some ARM64 platforms are affected */
+#define DPAA_FMAN_ERRATUM_A050385 1
+#endif
+
 /* FM Frame descriptor macros  */
 /* Frame queue Context Override */
 #define FM_FD_CMD_FCO                   0x80000000
@@ -398,6 +404,10 @@ u16 fman_get_max_frm(void);
 
 int fman_get_rx_extra_headroom(void);
 
+#ifdef DPAA_FMAN_ERRATUM_A050385
+bool fman_has_errata_a050385(void);
+#endif
+
 struct fman *fman_bind(struct device *dev);
 
 #endif /* __FM_H */
-- 
2.1.0

