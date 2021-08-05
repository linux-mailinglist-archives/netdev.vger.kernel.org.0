Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DE53E1F0A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242022AbhHEW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:56:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43424 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241915AbhHEWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:55:59 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175Mtf1u088750;
        Thu, 5 Aug 2021 17:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628204141;
        bh=Ihw5B3VT48zl/jq0yS0kqrykoMK/Th5kIKx42qr8YaY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=KbXNVqVoA3jsSqQTlzFSgr8edlS/zLIRX2fZ+sjQYQNtPluZ/qj8i3im3OUECw0kH
         Jr03/HBHlY953w8tHKYLalW2/O+N1SWsutj5GfStBkLWhlwjyZ0h5G87Wx7FDPOKy0
         Waek6bh2+x9Zm7WDejqH+fyoExi4a6pc21T8aPRI=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175MtfuO102294
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 17:55:41 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 17:55:41 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 17:55:41 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175MteeI007169;
        Thu, 5 Aug 2021 17:55:41 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/2] net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()
Date:   Fri, 6 Aug 2021 01:55:31 +0300
Message-ID: <20210805225532.2667-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805225532.2667-1-grygorii.strashko@ti.com>
References: <20210805225532.2667-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

On TI K3 am64x platform the issue with RX IRQ is observed - it's become
disabled forever after .ndo_stop(). The K3 CPSW driver manipulates RX IRQ
by using standard Linux enable_irq()/disable_irq_nosync() API as there is
no IRQ enable/disable options in CPSW HW itself, as result during
.ndo_stop() following sequence happens

  phy_stop()
  teardown TX/RX channels
  wait for TX tdown complete
  napi_disable(TX)
  clean up TX channels

  (a)

  napi_disable(RX)

At point (a) it's not possible to predict if RX IRQ was triggered or not.
if RX IRQ was triggered then it also not possible to definitely say if RX
NAPI was run or only scheduled and immediately canceled by
napi_disable(RX). Actually the last case causes RX IRQ to be permanently
disabled.

Another observed issue is that RX IRQ enable counter become unbalanced if
(gro_flush_timeout =! 0) while (napi_defer_hard_irqs == 0):

Unbalanced enable for IRQ 44
WARNING: CPU: 0 PID: 10 at ../kernel/irq/manage.c:776 __enable_irq+0x38/0x80
__enable_irq+0x38/0x80
enable_irq+0x54/0xb0
am65_cpsw_nuss_rx_poll+0x2f4/0x368
__napi_poll+0x34/0x1b8
net_rx_action+0xe4/0x220
_stext+0x11c/0x284
run_ksoftirqd+0x4c/0x60

To avoid above issues introduce flag indicating if RX was actually disabled
before enabling it in am65_cpsw_nuss_rx_poll() and restore RX IRQ state in
.ndo_open()

Fixes: 4f7cce272403 ("net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++++++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 629c267d5254..08399f572091 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -519,6 +519,10 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	}
 
 	napi_enable(&common->napi_rx);
+	if (common->rx_irq_disabled) {
+		common->rx_irq_disabled = false;
+		enable_irq(common->rx_chns.irq);
+	}
 
 	dev_dbg(common->dev, "cpsw_nuss started\n");
 	return 0;
@@ -872,8 +876,12 @@ static int am65_cpsw_nuss_rx_poll(struct napi_struct *napi_rx, int budget)
 
 	dev_dbg(common->dev, "%s num_rx:%d %d\n", __func__, num_rx, budget);
 
-	if (num_rx < budget && napi_complete_done(napi_rx, num_rx))
-		enable_irq(common->rx_chns.irq);
+	if (num_rx < budget && napi_complete_done(napi_rx, num_rx)) {
+		if (common->rx_irq_disabled) {
+			common->rx_irq_disabled = false;
+			enable_irq(common->rx_chns.irq);
+		}
+	}
 
 	return num_rx;
 }
@@ -1091,6 +1099,7 @@ static irqreturn_t am65_cpsw_nuss_rx_irq(int irq, void *dev_id)
 {
 	struct am65_cpsw_common *common = dev_id;
 
+	common->rx_irq_disabled = true;
 	disable_irq_nosync(irq);
 	napi_schedule(&common->napi_rx);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 5d93e346f05e..048ed10143c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -126,6 +126,8 @@ struct am65_cpsw_common {
 	struct am65_cpsw_rx_chn	rx_chns;
 	struct napi_struct	napi_rx;
 
+	bool			rx_irq_disabled;
+
 	u32			nuss_ver;
 	u32			cpsw_ver;
 	unsigned long		bus_freq;
-- 
2.17.1

