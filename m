Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D011C5D9E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgEEQbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:31:34 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33970 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbgEEQbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:31:34 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045GVTWB119652;
        Tue, 5 May 2020 11:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588696289;
        bh=taYNfOw1PERNYYRNSf6RpqbmydDX/ba8q0uroLuaJ+A=;
        h=From:To:CC:Subject:Date;
        b=ACdEEFfLuoAHZtJh1cM1BSIgKLA4wfntKTjCv8fjI981M1UVDFnq7Jd3xPxJaUJbO
         /1HomyBWx+8qMr/AWy6mX4CuhHmQcbf3+PFGG/xG8yP+3mRTHLP7+IiGIve870t3I1
         GPZZI1tdE/va7R9+D8/23qGvKKIT+S5JH5+T98Ig=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 045GVTDq045409
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 May 2020 11:31:29 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 11:31:29 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 11:31:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045GVRfw048550;
        Tue, 5 May 2020 11:31:28 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: am65-cpsw-nuss: fix irqs type
Date:   Tue, 5 May 2020 19:31:26 +0300
Message-ID: <20200505163126.13942-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The K3 INTA driver, which is source TX/RX IRQs for CPSW NUSS, defines IRQs
triggering type as EDGE by default, but triggering type for CPSW NUSS TX/RX
IRQs has to be LEVEL as the EDGE triggering type may cause unnecessary IRQs
triggering and NAPI scheduling for empty queues. It was discovered with
RT-kernel.

Fix it by explicitly specifying CPSW NUSS TX/RX IRQ type as
IRQF_TRIGGER_HIGH.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2bf56733ba94..2517ffba8178 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1719,7 +1719,8 @@ static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
 
 		ret = devm_request_irq(dev, tx_chn->irq,
 				       am65_cpsw_nuss_tx_irq,
-				       0, tx_chn->tx_chn_name, tx_chn);
+				       IRQF_TRIGGER_HIGH,
+				       tx_chn->tx_chn_name, tx_chn);
 		if (ret) {
 			dev_err(dev, "failure requesting tx%u irq %u, %d\n",
 				tx_chn->id, tx_chn->irq, ret);
@@ -1744,7 +1745,7 @@ static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
 
 	ret = devm_request_irq(dev, common->rx_chns.irq,
 			       am65_cpsw_nuss_rx_irq,
-			       0, dev_name(dev), common);
+			       IRQF_TRIGGER_HIGH, dev_name(dev), common);
 	if (ret) {
 		dev_err(dev, "failure requesting rx irq %u, %d\n",
 			common->rx_chns.irq, ret);
-- 
2.17.1

