Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4D6426622
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhJHIp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:45:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62447 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhJHIp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 04:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633682641; x=1665218641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6Dm9aMViI8ReP+IFTphshx0D0ke/ykpEn4jugDYx6Ts=;
  b=rzuf7LTIxIgU6cYtTcO5o6r9bSFnOjO08NVYXFz0aaEOPdArU10v3CwI
   T+w7oco2JN3NRKH6KVUhwFICgl/iNAPapJqyya0dzzXgvqeZvslgXU+f4
   7yvTc9OUC4FMRaI2ogTyhxyie7OlCsCrRhmttRaKgIhOj5yj4+DtglIeH
   hRqrVSRtpkCTrikpI2J3yQ6WCt7FOnFCPaz/2UYiaE6ALLCioga+qRMoF
   FI9b/vAPjf1E+FZdN+ZwFwuFolunHSTzIWHi3kBdJVOkaA+MbeS9iMogR
   IJQHM2WL60McK4nKvSNLqZyA3Kt5W0ObV7qoMgA1rXbDaCdZjoi1CITb9
   w==;
IronPort-SDR: XUAliwqaByR0S4MfZETclano9WkUxU+5vweg8Qu+XMTZhfnS61T9vlMsLgOa3Yyt8G5XsAV8LN
 YqAIn0qABtQC3uEk1nwhi2EiU0zfpuID7MukO1NRCuZ5w9jauzegpDQDlsBeuIhXJ9PlInaCR5
 PtT91LFqrOst+Lr8ThhjgDXXL8eMypg5GVCRRdyyEsZ02z0/lMEAOmy71CEsKefjmQBCOhvlFL
 kgoPinCAs4dXtMii+nglzfAuJ0X2JwrH11eI3Vquf+3UwwaLcxy4elWimWxXyfYZ1iZATR8hru
 nPXHvMTs1zYQW32vMvOd4Myj
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="147263658"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Oct 2021 01:44:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 8 Oct 2021 01:44:00 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 8 Oct 2021 01:43:54 -0700
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
Subject: [PATCH net] net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work
Date:   Fri, 8 Oct 2021 14:13:48 +0530
Message-ID: <20211008084348.7306-1-arun.ramadoss@microchip.com>
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
cancel_delayed_work_sync routine.

At the end of  mib_read_workqueue execution, it again reschedule the
workqueue unconditionally. Due to which queue rescheduled after
mib_interval, during this execution it tries to access dp->slave. But
the slave is unregistered in the ksz_switch_remove function. Hence
kernel crashes.

To avoid this crash, before canceling the workqueue, resetted the
mib_interval to 0. In the work queue execution, it schedules the
workqueue next time only if the mib_interval is non zero.

Fixes: 469b390e1ba3 ("net: dsa: microchip: use delayed_work instead of timer + work")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1542bfb8b5e5..ffc8e6fb300a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -94,7 +94,8 @@ static void ksz_mib_read_work(struct work_struct *work)
 		mutex_unlock(&mib->cnt_mutex);
 	}
 
-	schedule_delayed_work(&dev->mib_read, dev->mib_read_interval);
+	if (dev->mib_read_interval)
+		schedule_delayed_work(&dev->mib_read, dev->mib_read_interval);
 }
 
 void ksz_init_mib_timer(struct ksz_device *dev)
@@ -449,8 +450,10 @@ EXPORT_SYMBOL(ksz_switch_register);
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

