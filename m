Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3B38BD6B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbhEUE2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:44 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47116 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 279681A042E;
        Fri, 21 May 2021 06:26:31 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 279681A042E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1621571191;
        bh=z3u4vjghb1aCcF5nu/LY7fkYl80SW2eGPBiznkYvWSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfMOan5zBO21MecgpAgSox8Djo/AgdT9zWJ2A1/KiPDwQ3avWu75Fxvv8LiUBIgTJ
         LoBV6E14+C017JlBWuGhPf2QdAaoEeE87Fx7m78zXm1qnRTTmGIQLbdRF4dQKu2N9J
         48Ah4oDVSlbxm0W/QWeZbINHqb++zOsiSi1gZE/zAaHb41wSRFx2WTgLObhlHu51Jx
         1z6BUauyE093Kn8fg+jNDRAJFTWsOCWrg+fbvgeI7U8Jh3137DIUOfIoDEi8HbKD2j
         3ttXMUB0LVSz+h1XaNGsPUmP62qIaualGQN0w0IEtIK8m97+ZNWv+wxVwRZA/xYz9w
         7/0zFoCk9pJZw==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 73F811A010C;
        Fri, 21 May 2021 06:26:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 73F811A010C
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2D4C34024E;
        Fri, 21 May 2021 12:26:25 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 4/7] ptp_qoriq: export ptp clock reading function for cyclecounter
Date:   Fri, 21 May 2021 12:36:16 +0800
Message-Id: <20210521043619.44694-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export ptp clock reading function for cyclecounter to read cycles.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Updated copyright.
---
 drivers/ptp/ptp_qoriq.c       | 16 ++++++++++++++++
 include/linux/fsl/ptp_qoriq.h |  3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..2bcbe9da2a29 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -3,6 +3,7 @@
  * PTP 1588 clock for Freescale QorIQ 1588 timer
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
+ * Copyright 2021 NXP
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -311,6 +312,21 @@ int ptp_qoriq_enable(struct ptp_clock_info *ptp,
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
index 01acebe37fab..4590e70f1afb 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2010 OMICRON electronics GmbH
- * Copyright 2018 NXP
+ * Copyright 2018-2021 NXP
  */
 #ifndef __PTP_QORIQ_H__
 #define __PTP_QORIQ_H__
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

