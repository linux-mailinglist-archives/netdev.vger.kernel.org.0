Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5270713EB30
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406690AbgAPRqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406668AbgAPRq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD659246B7;
        Thu, 16 Jan 2020 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196786;
        bh=FUskxwFtJmB85g2QoWufT+EQlsqoA9fp/l3uqUwyw5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ4O0IpYZbRh3/X28IvOTtrgRukS4jcCikzd9DrJWhc8G4zNB8DyWR1SEG29kPJLW
         IRQ7muT5iInLeK7un9P92iyf8nloG8VS2AlFFAVf2Xw+00h9xzT5ZToSGzu071t4qU
         cSev6X6sKrMTdMpcqd7jyxd4dgLo+anKXffY8k9Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@in-tech.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 150/174] net: qca_spi: Move reset_count to struct qcaspi
Date:   Thu, 16 Jan 2020 12:42:27 -0500
Message-Id: <20200116174251.24326-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
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
index 7886a8a5b55b..fb944e65c632 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -438,7 +438,6 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 	u16 signature = 0;
 	u16 spi_config;
 	u16 wrbuf_space = 0;
-	static u16 reset_count;
 
 	if (event == QCASPI_EVENT_CPUON) {
 		/* Read signature twice, if not valid
@@ -491,13 +490,13 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 
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
index 6e31a0e744a4..c48c314ca4df 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -97,6 +97,7 @@ struct qcaspi {
 
 	unsigned int intr_req;
 	unsigned int intr_svc;
+	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
-- 
2.20.1

