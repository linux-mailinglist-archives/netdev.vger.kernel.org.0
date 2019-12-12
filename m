Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38D11CA43
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfLLKJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:09:01 -0500
Received: from inva020.nxp.com ([92.121.34.13]:44792 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbfLLKI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:08:58 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A70C21A0924;
        Thu, 12 Dec 2019 11:08:56 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7AC791A06C1;
        Thu, 12 Dec 2019 11:08:54 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 686F6402D2;
        Thu, 12 Dec 2019 18:08:51 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 2/3] ptp_qoriq: export extts_clean_up() function
Date:   Thu, 12 Dec 2019 18:08:05 +0800
Message-Id: <20191212100806.17447-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212100806.17447-1-yangbo.lu@nxp.com>
References: <20191212100806.17447-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export extts_clean_up() function so that dpaa2-ptp
driver is able to reuse it.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_qoriq.c       | 4 ++--
 include/linux/fsl/ptp_qoriq.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index a3062cd..b27c46e 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -74,8 +74,7 @@ static void set_fipers(struct ptp_qoriq *ptp_qoriq)
 	ptp_qoriq->write(&regs->fiper_regs->tmr_fiper2, ptp_qoriq->tmr_fiper2);
 }
 
-static int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index,
-			  bool update_event)
+int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool update_event)
 {
 	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
 	struct ptp_clock_event event;
@@ -121,6 +120,7 @@ static int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(extts_clean_up);
 
 /*
  * Interrupt service routine
diff --git a/include/linux/fsl/ptp_qoriq.h b/include/linux/fsl/ptp_qoriq.h
index 992bf9f..b0b7435 100644
--- a/include/linux/fsl/ptp_qoriq.h
+++ b/include/linux/fsl/ptp_qoriq.h
@@ -192,6 +192,7 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
 		      const struct timespec64 *ts);
 int ptp_qoriq_enable(struct ptp_clock_info *ptp,
 		     struct ptp_clock_request *rq, int on);
+int extts_clean_up(struct ptp_qoriq *ptp_qoriq, int index, bool update_event);
 #ifdef CONFIG_DEBUG_FS
 void ptp_qoriq_create_debugfs(struct ptp_qoriq *ptp_qoriq);
 void ptp_qoriq_remove_debugfs(struct ptp_qoriq *ptp_qoriq);
-- 
2.7.4

