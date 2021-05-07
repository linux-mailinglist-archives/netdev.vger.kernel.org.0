Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33AF376250
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbhEGIsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44708 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236424AbhEGIsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:50 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35E3A203797;
        Fri,  7 May 2021 10:47:48 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7EEDE200143;
        Fri,  7 May 2021 10:47:45 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9664640314;
        Fri,  7 May 2021 10:47:41 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 3/6] ptp_qoriq: export ptp clock reading function for cyclecounter
Date:   Fri,  7 May 2021 16:57:53 +0800
Message-Id: <20210507085756.20427-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export ptp clock reading function for cyclecounter to read cycles.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c       | 15 +++++++++++++++
 include/linux/fsl/ptp_qoriq.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..4617055a3307 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -311,6 +311,21 @@ int ptp_qoriq_enable(struct ptp_clock_info *ptp,
 }
 EXPORT_SYMBOL_GPL(ptp_qoriq_enable);
 
+u64 ptp_qoriq_clock_read(const struct cyclecounter *cc)
+{
+	struct ptp_clock_info *ptp = ptp_get_pclock_info(cc);
+	struct ptp_qoriq *ptp_qoriq = container_of(ptp, struct ptp_qoriq, caps);
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&ptp_qoriq->lock, flags);
+	ns = tmr_cnt_read(ptp_qoriq);
+	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
+
+	return ns;
+}
+EXPORT_SYMBOL_GPL(ptp_qoriq_clock_read);
+
 static const struct ptp_clock_info ptp_qoriq_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "qoriq ptp clock",
diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index 01acebe37fab..9a2ecd696c7e 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -193,6 +193,7 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
 		      const struct timespec64 *ts);
 int ptp_qoriq_enable(struct ptp_clock_info *ptp,
 		     struct ptp_clock_request *rq, int on);
+u64 ptp_qoriq_clock_read(const struct cyclecounter *cc);
 int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool update_event);
 #ifdef CONFIG_DEBUG_FS
 void ptp_qoriq_create_debugfs(struct ptp_qoriq *ptp_qoriq);
-- 
2.25.1

