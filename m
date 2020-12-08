Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32442D31AB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgLHSEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:04:21 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:18320 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730859AbgLHSEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450660; x=1638986660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XVreMNAA58fNOe0MRjhKLDy/juCKyr9h7fIOv+0v4Qw=;
  b=SDAF0OVPxNPM3jN7OIMGw14qpBYDsd7OV3dEVdeT/e4YRculroTSnjbU
   hsR3Yy50N2R/wFmBteNbZmGwi2mZ05EDzmezGVJdVRXOYYYabo3I0JxF5
   o157VKg8zfpQT/1NLBr3aKlc7LplbBsEI6w4Rhy1rE1mb3+OgXQyYiWiA
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="67962154"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Dec 2020 18:03:33 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 69176A20A3;
        Tue,  8 Dec 2020 18:03:32 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.211) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:03:22 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        David Woodhouse <dwmw@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Bshara Saeed <saeedb@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Nafea Bshara <nafea@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Samih Jubran <sameehj@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ido Segev <idose@amazon.com>, Igor Chauskin <igorch@amazon.com>
Subject: [PATCH net-next v5 3/9] net: ena: store values in their appropriate variables types
Date:   Tue, 8 Dec 2020 20:02:02 +0200
Message-ID: <20201208180208.26111-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
References: <20201208180208.26111-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes some of the variables types to match the values they
hold. These wrong types fail some of our static checkers that search for
accidental conversions in our driver.

Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 15 +++++++--------
 drivers/net/ethernet/amazon/ena/ena_com.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e168edf3c930..02087d443e73 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1360,16 +1360,15 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
 	comp_ctx = ena_com_submit_admin_cmd(admin_queue, cmd, cmd_size,
 					    comp, comp_size);
 	if (IS_ERR(comp_ctx)) {
-		if (comp_ctx == ERR_PTR(-ENODEV))
+		ret = PTR_ERR(comp_ctx);
+		if (ret == -ENODEV)
 			netdev_dbg(admin_queue->ena_dev->net_device,
-				   "Failed to submit command [%ld]\n",
-				   PTR_ERR(comp_ctx));
+				   "Failed to submit command [%d]\n", ret);
 		else
 			netdev_err(admin_queue->ena_dev->net_device,
-				   "Failed to submit command [%ld]\n",
-				   PTR_ERR(comp_ctx));
+				   "Failed to submit command [%d]\n", ret);
 
-		return PTR_ERR(comp_ctx);
+		return ret;
 	}
 
 	ret = ena_com_wait_and_process_admin_cq(comp_ctx, admin_queue);
@@ -1595,7 +1594,7 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
 int ena_com_get_dma_width(struct ena_com_dev *ena_dev)
 {
 	u32 caps = ena_com_reg_bar_read32(ena_dev, ENA_REGS_CAPS_OFF);
-	int width;
+	u32 width;
 
 	if (unlikely(caps == ENA_MMIO_READ_TIMEOUT)) {
 		netdev_err(ena_dev->net_device, "Reg read timeout occurred\n");
@@ -2247,7 +2246,7 @@ int ena_com_get_dev_basic_stats(struct ena_com_dev *ena_dev,
 	return ret;
 }
 
-int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu)
+int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, u32 mtu)
 {
 	struct ena_com_admin_queue *admin_queue;
 	struct ena_admin_set_feat_cmd cmd;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index b0f76fb3b1d7..343caf41e709 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -605,7 +605,7 @@ int ena_com_get_eni_stats(struct ena_com_dev *ena_dev,
  *
  * @return: 0 on Success and negative value otherwise.
  */
-int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu);
+int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, u32 mtu);
 
 /* ena_com_get_offload_settings - Retrieve the device offloads capabilities
  * @ena_dev: ENA communication layer struct
-- 
2.17.1

