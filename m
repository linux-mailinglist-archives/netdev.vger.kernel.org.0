Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5DB4293C6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbhJKPu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:50:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58849 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhJKPu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633967309; x=1665503309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qdqRhy8u30cGTSDqA5uDEb07g7Exe+Dpl/5HUZmeZ6Y=;
  b=rj78fZ/+tbixmWy/FCGYiyPfsM3812SenOGVHEsqAPBqH33SQOEv58AL
   t1iOQEM56wn1qWAQ7HW93qhO8WrlcVdhM8PmM0dhzZYz1oF/BBomJf3vX
   W3koldl0PRODn/0CEd/Pzc9j9HKv26tDo9b0cnGR7UGqyTgz0iL1z3iUJ
   YA2vyg6PDpy0tXLVHsHtKxHNT0kIVRECUk4AbAAGI+0vTva63lcGj89xK
   xE1tBssr/0yf6U5A/4kpET+POwdJWdTMNJRsM4PmwleTsHhCBBaz9BwUA
   GzaxPJ7Em0dXJW3xM+k//zNgzEhEOZM/xJzz0E+CyZb65RoqObl/NEei+
   g==;
IronPort-SDR: eXAG0+Y+QE2GIUA0wW8YGynIrXo/pOdnWSUJbSl5DUdA5iPeZGxMB9Febo/ohrUpDGnXMiHxko
 MedadBfjgAzydw1M04AQJZPdmZEXJU33OmphqdeS8wE5hwLWBsHV3CmU16SQ8f+vmsLQRa5qGz
 /uVgBC4g0WgWyyDib9vcr1bBOpfsz8uvyHypVFXdaXfuO8XN9OwSTfbo6su9a8ikrF9RMlMYuM
 uIlJKQDn6xByxu4zyyb2E/ccQ5bnE/AjMe6i9mcW7YrcR0/YhjLE66gOKpU1ab0atuFMF/KHf6
 b7OXpzLcHDfa153NhScBfYeU
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="135109164"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2021 08:48:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 11 Oct 2021 08:48:27 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 11 Oct 2021 08:48:23 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH v2 net] net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work
Date:   Mon, 11 Oct 2021 21:18:08 +0530
Message-ID: <20211011154808.25820-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ksz module is installed and removed using rmmod, kernel crashes
with null pointer dereferrence error. During rmmod, ksz_switch_remove
function tries to cancel the mib_read_workqueue using
cancel_delayed_work_sync routine and unregister switch from dsa.

During dsa_unregister_switch it calls ksz_mac_link_down, which in turn
reschedules the workqueue since mib_interval is non-zero.
Due to which queue executed after mib_interval and it tries to access
dp->slave. But the slave is unregistered in the ksz_switch_remove
function. Hence kernel crashes.

To avoid this crash, before canceling the workqueue, resetted the
mib_interval to 0.

v1 -> v2:
-Removed the if condition in ksz_mib_read_work

Fixes: 469b390e1ba3 ("net: dsa: microchip: use delayed_work instead of timer + work")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1542bfb8b5e5..7c2968a639eb 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -449,8 +449,10 @@ EXPORT_SYMBOL(ksz_switch_register);
 void ksz_switch_remove(struct ksz_device *dev)
 {
 	/* timer started */
-	if (dev->mib_read_interval)
+	if (dev->mib_read_interval) {
+		dev->mib_read_interval = 0;
 		cancel_delayed_work_sync(&dev->mib_read);
+	}
 
 	dev->dev_ops->exit(dev);
 	dsa_unregister_switch(dev->ds);
-- 
2.33.0

