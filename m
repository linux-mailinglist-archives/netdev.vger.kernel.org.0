Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8E26CC61
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgIPUnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:43:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48466 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgIPREp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 13:04:45 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 780E21A0CB5;
        Wed, 16 Sep 2020 14:16:46 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2EC011A0098;
        Wed, 16 Sep 2020 14:16:43 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 342344029E;
        Wed, 16 Sep 2020 14:16:38 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [v3, 2/6] dpaa2-eth: define a global ptp_qoriq structure pointer
Date:   Wed, 16 Sep 2020 20:08:26 +0800
Message-Id: <20200916120830.11456-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916120830.11456-1-yangbo.lu@nxp.com>
References: <20200916120830.11456-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a global ptp_qoriq structure pointer, and export to use.
The ptp clock operations will be used in dpaa2-eth driver.
For example, supporting one step timestamping needs to write
current time to hardware frame annotation before sending and
then hardware inserts the delay time on frame during sending.
So in driver, at least clock gettime operation will be needed
to make sure right time is written to hardware frame annotation
for one step timestamping.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
Changes for v3:
	- Fixed sparse warning.
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 3 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h | 4 ++++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index ceaf761..daf8fd4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -15,6 +15,7 @@
 #include <linux/fsl/mc.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/fsl/ptp_qoriq.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 
@@ -30,6 +31,9 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
 
+struct ptp_qoriq *dpaa2_ptp;
+EXPORT_SYMBOL(dpaa2_ptp);
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7f3c41d..7be684b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -491,6 +491,7 @@ struct dpaa2_eth_priv {
 
 extern const struct ethtool_ops dpaa2_ethtool_ops;
 extern int dpaa2_phc_index;
+extern struct ptp_qoriq *dpaa2_ptp;
 
 static inline int dpaa2_eth_cmp_dpni_ver(struct dpaa2_eth_priv *priv,
 					 u16 ver_major, u16 ver_minor)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index cc1b7f8..32b5faa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016-2018 NXP
+ * Copyright 2020 NXP
  */
 
 #include <linux/module.h>
@@ -9,7 +10,6 @@
 #include <linux/of_address.h>
 #include <linux/msi.h>
 #include <linux/fsl/mc.h>
-#include <linux/fsl/ptp_qoriq.h>
 
 #include "dpaa2-ptp.h"
 
@@ -201,6 +201,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 		goto err_free_threaded_irq;
 
 	dpaa2_phc_index = ptp_qoriq->phc_index;
+	dpaa2_ptp = ptp_qoriq;
 	dev_set_drvdata(dev, ptp_qoriq);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
index df2458a..e102353 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
@@ -1,14 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2018 NXP
+ * Copyright 2020 NXP
  */
 
 #ifndef __RTC_H
 #define __RTC_H
 
+#include <linux/fsl/ptp_qoriq.h>
+
 #include "dprtc.h"
 #include "dprtc-cmd.h"
 
 extern int dpaa2_phc_index;
+extern struct ptp_qoriq *dpaa2_ptp;
 
 #endif
-- 
2.7.4

