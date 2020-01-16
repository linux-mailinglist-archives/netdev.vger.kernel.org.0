Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BF413E8B2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404374AbgAPRaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404361AbgAPRaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C59724726;
        Thu, 16 Jan 2020 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195815;
        bh=PhvuH+HLctDanKx8bPk85Hu20V8us4OjBHDnxeiBOjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xr+4488d2p1bToRGeivrjMbQY8pY12FQLRm3TIlOVhCile4V3S8ns/uo9hpDBkjqi
         MoJesbfYD5b70MIousYhYVvhY40+7tAXibiNmla4AGY+KnQY3I32VNnvaCUX4FTuXG
         safaCTY/A35ksSHSLxex1KmbpwIqix82quMd24XY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@in-tech.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 326/371] net: qca_spi: Move reset_count to struct qcaspi
Date:   Thu, 16 Jan 2020 12:23:18 -0500
Message-Id: <20200116172403.18149-269-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Wahren <stefan.wahren@in-tech.com>

[ Upstream commit bc19c32904e36548335b35fdce6ce734e20afc0a ]

The reset counter is specific for every QCA700x chip. So move this
into the private driver struct. Otherwise we get unpredictable reset
behavior in setups with multiple QCA700x chips.

Fixes: 291ab06ecf67 (net: qualcomm: new Ethernet over SPI driver for QCA7000)
Signed-off-by: Stefan Wahren <stefan.wahren@in-tech.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 9 ++++-----
 drivers/net/ethernet/qualcomm/qca_spi.h | 1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 275fc6f154a7..1c87178fc485 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -475,7 +475,6 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 	u16 signature = 0;
 	u16 spi_config;
 	u16 wrbuf_space = 0;
-	static u16 reset_count;
 
 	if (event == QCASPI_EVENT_CPUON) {
 		/* Read signature twice, if not valid
@@ -528,13 +527,13 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 
 		qca->sync = QCASPI_SYNC_RESET;
 		qca->stats.trig_reset++;
-		reset_count = 0;
+		qca->reset_count = 0;
 		break;
 	case QCASPI_SYNC_RESET:
-		reset_count++;
+		qca->reset_count++;
 		netdev_dbg(qca->net_dev, "sync: waiting for CPU on, count %u.\n",
-			   reset_count);
-		if (reset_count >= QCASPI_RESET_TIMEOUT) {
+			   qca->reset_count);
+		if (qca->reset_count >= QCASPI_RESET_TIMEOUT) {
 			/* reset did not seem to take place, try again */
 			qca->sync = QCASPI_SYNC_UNKNOWN;
 			qca->stats.reset_timeout++;
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index fc0e98726b36..719c41227f22 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -92,6 +92,7 @@ struct qcaspi {
 
 	unsigned int intr_req;
 	unsigned int intr_svc;
+	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
-- 
2.20.1

