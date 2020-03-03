Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836B7176CF9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgCCDAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgCCCrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 873CF2468D;
        Tue,  3 Mar 2020 02:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203645;
        bh=jYY9onVjt5nIJMEtgE+UH1baq7Rw12q18+wK0cv1hhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDWV8kwAS1Tfsxs2Zuc8CzmZXvGJHqiTij5oZvpv2KvtnQmA7bsoUncbZ2HmkG7C7
         2YDR8qLWLstsqkxz0Lh4lpqkFiH+3cVj9thm2Z6oiSvynhRP6YIaZLO6LTbj5AdTqZ
         pcNAvfDGZ61U7u+pIXMInoCJSTV4BqtQlBV8VrgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 56/66] ionic: fix fw_status read
Date:   Mon,  2 Mar 2020 21:46:05 -0500
Message-Id: <20200303024615.8889-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 68b759a75d6257759d1e37ff13f2d0659baf1112 ]

The fw_status field is only 8 bits, so fix the read.  Also,
we only want to look at the one status bit, to allow for future
use of the other bits, and watch for a bad PCI read.

Fixes: 97ca486592c0 ("ionic: add heartbeat check")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 11 +++++++----
 drivers/net/ethernet/pensando/ionic/ionic_if.h  |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 5f9d2ec70446f..61c06fbe10dbb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -103,7 +103,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
 	unsigned long hb_time;
-	u32 fw_status;
+	u8 fw_status;
 	u32 hb;
 
 	/* wait a little more than one second before testing again */
@@ -111,9 +111,12 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
 		return 0;
 
-	/* firmware is useful only if fw_status is non-zero */
-	fw_status = ioread32(&idev->dev_info_regs->fw_status);
-	if (!fw_status)
+	/* firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	fw_status = ioread8(&idev->dev_info_regs->fw_status);
+	if (fw_status == 0xff ||
+	    !(fw_status & IONIC_FW_STS_F_RUNNING))
 		return -ENXIO;
 
 	/* early FW has no heartbeat, else FW will return non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index ed23a05f2642f..d5e8b4e2a96e0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -2348,6 +2348,7 @@ union ionic_dev_info_regs {
 		u8     version;
 		u8     asic_type;
 		u8     asic_rev;
+#define IONIC_FW_STS_F_RUNNING	0x1
 		u8     fw_status;
 		u32    fw_heartbeat;
 		char   fw_version[IONIC_DEVINFO_FWVERS_BUFLEN];
-- 
2.20.1

