Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D981FCE50
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgFQNYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:24:02 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:6663 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgFQNYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592400241; x=1623936241;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ZSKIFjgWSGvcd2TA1EkZxZotKMUxU9qjgTH4dFWXe7w=;
  b=dJ5QT2RBb6TREMLewoZ5nJrPloU2s1PgL9itXqkjpjWcTCP3L2yNG16K
   PdlbNbHDKS38CMgYlR9tfnUp11yK6SKxzB35MBcjLYVyKb9c8tg1Hc8Lq
   sZOOYzPc/V6pSUhq9bBbH/rkYtQ7kvc2bBLr/Y4Wsmwjw6Slzr9UX558i
   l4yCW+/+YFtZvxl37n1R6dwHHHSvcYmJwWO58xP+Iw1fmhPR8Z+v0Wo26
   0Iy5c0fkct9z/tzDJZ7bmPNxhBrX60wvmRZU42JSKFh39VHooCaV9rnO8
   XDogxPGLBwS2ps8dfgFqcEpLAc0tRum3orSAjWwxYSQtnF5qInCymPhPW
   A==;
IronPort-SDR: SM6Y4i1it7Ug8rGDOTz14WiIWZ+m/ZhnSVBWLDzhhMGCoOkE3bgT8aXPKCxWQMIpMqkvCXjMX6
 764rj56As5fjMwFSDn7r6qNQHh5Y3qkLxU4XfYrRn5lvxC33C+LE1KHwvuNMZlJix56L9PwGD1
 Z19kM3oiZoOa+Fji+mTh3V88izo/NaOp3SXEN0PqPN+I+NI1MpxXVXnMnJbwC0vGMsg/bsvNSz
 MNWj6ygAh8y8galIbj0bEiR08ayQzwgNhTfcP18onXlqbuSbig19DCuRdgqyIisg/QMh5aai1r
 408=
X-IronPort-AV: E=Sophos;i="5.73,522,1583218800"; 
   d="scan'208";a="16108969"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2020 06:24:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 06:24:00 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 17 Jun 2020 06:23:52 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <antoine.tenart@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: macb: undo operations in case of failure
Date:   Wed, 17 Jun 2020 16:23:55 +0300
Message-ID: <1592400235-11833-1-git-send-email-claudiu.beznea@microchip.com>
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

Fixes: b2b041417299 ("net: macb: convert to phylink")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
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

