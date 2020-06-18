Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B881FEDC9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgFRIiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:38:00 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:41730 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFRIh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592469478; x=1624005478;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=op9Dwd0owILrsaDW41uZbpQG/X+/tABWDFLpAQRIZB4=;
  b=EmUXVCYblOXfXlO5FvERxo3CZ9rZH/j4nNHLTPYRX1FT4h7bTAr8ny01
   CWfv5BPDA4r28X+NcLwOifiHTPeIwjlhxZRkbxvtwmd5zH+zINbx6Prn4
   b+7NSHu/KSleoZtDxkdjRP8OxPJ2sUSM0EYdU9Y32C0F/iGy1HtF0o2sf
   DFpsMgric1rZMY+Caxz2ApIssPET/m70Nk3hcEZsA4d8qGyRacUjaZz+W
   jF1qr2YKxsNWVM0EUQXSYy4E1jlCug4SPitQV3rNqxjmDR+MDC3kku8Qa
   IhwLra9gkdHIkFAwa3s59Wyny+0AJBOsHjj//bpJyYBkbtlvf5zQ3tcJY
   Q==;
IronPort-SDR: au0IV5Gn5V62aYnSuTdr0sQppXDQt0c0vpZtbIb7dDb2iuVlD2QVSxEYlx8oXTrN6jD7Ek/+oe
 cleVbeORNQBSMWYk2zULg8s5x9htvzfXaf3vsfddhwHjBLUmonuBPONs3LLCiTHlvCRChDfDSO
 BFUdIiL8eQrG+eVe7QCWBLakVRnNmYAbiro5oVn0lQ/KDAJlXAKb3UzeemwYwnoNgKH55QWc+u
 D34Ibohb94mO3kFg84Xoa8mOTLFejnH/M30HViNSbL0xRmjkDhlNQGuZWhIvc+ISodgtNuugPM
 stw=
X-IronPort-AV: E=Sophos;i="5.73,526,1583218800"; 
   d="scan'208";a="77021584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jun 2020 01:37:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 01:37:39 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Jun 2020 01:37:43 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <antoine.tenart@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2] net: macb: undo operations in case of failure
Date:   Thu, 18 Jun 2020 11:37:40 +0300
Message-ID: <1592469460-17825-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Undo previously done operation in case macb_phylink_connect()
fails. Since macb_reset_hw() is the 1st undo operation the
napi_exit label was renamed to reset_hw.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Changes in v2:
- corrected fixes SHA1

 drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 67933079aeea..257c4920cb88 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2558,7 +2558,7 @@ static int macb_open(struct net_device *dev)
 
 	err = macb_phylink_connect(bp);
 	if (err)
-		goto napi_exit;
+		goto reset_hw;
 
 	netif_tx_start_all_queues(dev);
 
@@ -2567,9 +2567,11 @@ static int macb_open(struct net_device *dev)
 
 	return 0;
 
-napi_exit:
+reset_hw:
+	macb_reset_hw(bp);
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
+	macb_free_consistent(bp);
 pm_exit:
 	pm_runtime_put_sync(&bp->pdev->dev);
 	return err;
-- 
2.7.4

