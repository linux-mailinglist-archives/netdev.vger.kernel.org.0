Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F37CF98B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfJHML1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:27 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54192 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbfJHML0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F06481A00FC;
        Tue,  8 Oct 2019 14:11:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E35421A002E;
        Tue,  8 Oct 2019 14:11:24 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A250E205DB;
        Tue,  8 Oct 2019 14:11:24 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 14/20] soc: fsl: qbman: allow registering a device link for the portal user
Date:   Tue,  8 Oct 2019 15:10:35 +0300
Message-Id: <1570536641-25104-15-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the API required to make sure that the devices that use
the QMan portal are unbound when the portal is unbound.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/soc/fsl/qbman/qman.c | 13 +++++++++++++
 include/soc/fsl/qman.h       | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index bf68d86d80ee..bc75a5882b9e 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -1749,6 +1749,19 @@ struct qman_portal *qman_get_affine_portal(int cpu)
 }
 EXPORT_SYMBOL(qman_get_affine_portal);
 
+int qman_start_using_portal(struct qman_portal *p, struct device *dev)
+{
+	return (!device_link_add(dev, p->config->dev,
+				 DL_FLAG_AUTOREMOVE_CONSUMER)) ? -EINVAL : 0;
+}
+EXPORT_SYMBOL(qman_start_using_portal);
+
+void qman_stop_using_portal(struct qman_portal *p, struct device *dev)
+{
+	device_link_remove(dev, p->config->dev);
+}
+EXPORT_SYMBOL(qman_stop_using_portal);
+
 int qman_p_poll_dqrr(struct qman_portal *p, unsigned int limit)
 {
 	return __poll_portal_fast(p, limit);
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index aa31c05a103a..c499c5cfa7c9 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -32,6 +32,7 @@
 #define __FSL_QMAN_H
 
 #include <linux/bitops.h>
+#include <linux/device.h>
 
 /* Hardware constants */
 #define QM_CHANNEL_SWPORTAL0 0
@@ -915,6 +916,23 @@ u16 qman_affine_channel(int cpu);
 struct qman_portal *qman_get_affine_portal(int cpu);
 
 /**
+ * qman_start_using_portal - register a device link for the portal user
+ * @p: the portal that will be in use
+ * @dev: the device that will use the portal
+ *
+ * Makes sure that the devices that use the portal are unbound when the
+ * portal is unbound
+ */
+int qman_start_using_portal(struct qman_portal *p, struct device *dev);
+
+/**
+ * qman_stop_using_portal - deregister a device link for the portal user
+ * @p: the portal that will no longer be in use
+ * @dev: the device that uses the portal
+ */
+void qman_stop_using_portal(struct qman_portal *p, struct device *dev);
+
+/**
  * qman_p_poll_dqrr - process DQRR (fast-path) entries
  * @limit: the maximum number of DQRR entries to process
  *
-- 
2.1.0

