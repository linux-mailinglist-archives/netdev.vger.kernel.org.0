Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5671C3BA1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgEDNrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:47:07 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21352 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbgEDNrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 09:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588600026; x=1620136026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tE91w861pxg0ps3UOR5O7pcA0Vt5sQbNgdVLyXzR7B0=;
  b=ZqSVKX4ZIQ1tffKtZI1aDyNVNIu95pNodUK3noiysQVfUI9tNqKKuBi8
   ZdwzwzajURZA4fW6/lgpbkqOrpSJlTb+9Cxd79ZU//ljCltE6zeTAxzbC
   r9geZIt9FPQ4t1BASEzSx4ILcj35vJLD7SFKrzA5mqbNKCWHHCedyMZkj
   wrk6XWlModNapnr+SqYvXQ3mMgQmlRG81Dr/gLMBM+quxmKZ918qTdYzX
   G56QVLwESVnrMhIHXx8x7ApT4hqP62NstiYe/VXv0dziVSWRbJv31r9yO
   oD9UCYiafjCaf6BVwruxi5vz+zph0QeTenXsVyzagZ8sX3cwqK4wJ47AL
   Q==;
IronPort-SDR: +xPiIMwaLvNJjMlB6h11BC5RYHbjuL+WHgjVAB8fBLQ4obJ7YVwoNMs/BCNYNygc/WnXieRiwB
 uZQcvgxafDKeofruOtThliYyd48KHyWwYUN3vkZYJPpmqfBbRv8FU8oWUvr6E1GjkfcTHn2oso
 Tw2eK1Gcn+F6b2tFx8SLZZGMX1+jC4RshTUJ/ki/ZhY/n4l7Pmi8E1IImzUsRJMTVgPIgW6bcE
 kmxVFIwQWskwhqVxEb2/X199I8CxZOQgghJhoiEpRTjb0z6YXpLfDzQajhYeQWrfgYoNXORi/A
 ngc=
X-IronPort-AV: E=Sophos;i="5.73,352,1583218800"; 
   d="scan'208";a="74135752"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2020 06:46:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 May 2020 06:46:33 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 May 2020 06:46:30 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>
Subject: [PATCH v3 1/7] net: macb: fix wakeup test in runtime suspend/resume routines
Date:   Mon, 4 May 2020 15:44:16 +0200
Message-ID: <760ececd082c834c1ab4b1b410c605cc10bb6224.1588597759.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588597759.git.nicolas.ferre@microchip.com>
References: <cover.1588597759.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Use the proper struct device pointer to check if the wakeup flag
and wakeup source are positioned.
Use the one passed by function call which is equivalent to
&bp->dev->dev.parent.

It's preventing the trigger of a spurious interrupt in case the
Wake-on-Lan feature is used.

Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..d1b4d6b6d7c8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4616,7 +4616,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_disable_unprepare(bp->tx_clk);
 		clk_disable_unprepare(bp->hclk);
 		clk_disable_unprepare(bp->pclk);
@@ -4632,7 +4632,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	if (!(device_may_wakeup(&bp->dev->dev))) {
+	if (!(device_may_wakeup(dev))) {
 		clk_prepare_enable(bp->pclk);
 		clk_prepare_enable(bp->hclk);
 		clk_prepare_enable(bp->tx_clk);
-- 
2.26.2

