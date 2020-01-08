Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB04E134749
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgAHQLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:11:09 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36414 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728083AbgAHQLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:11:08 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 482FC180062;
        Wed,  8 Jan 2020 16:11:07 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:11:02 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 03/14] sfc: move reset workqueue code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <a2d0f42b-61c4-42b8-df6e-184d8f3b503e@solarflare.com>
Date:   Wed, 8 Jan 2020 16:10:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-6.559100-8.000000-10
X-TMASE-MatchedRID: AvNNcJ0njJ+0sP6cmNYpOKiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrEwS
        eVQnSS/F/SrcY9Zl4TqPQi9XuOWoOMOJmY4XRXkVB8Lglj0iCABKgIbix5+XxEPJD9TF1GCwpZX
        MpWZIsI4Ka+KeKWIfys15zhPQfP58Kdr48H7XWFvCWOwlsiwAbW9Xf86cwKVaLVW/BafIUxXSJJ
        cbp1Y+WyYhpFLNY0umKP2/buXOXzW6QAtC4sI1vzvMSga43p0036DIeK03Kb9UjspoiX02F+LRG
        GmsnnSD7eAwavPQoIWCFezKcF3T/bWfqrMzDJSXuoibJpHRrFkvV5f7P0HVDPpruoHpsPduEUS3
        3ulD4LxmGBR/0obHSn2/RqwseasXcePffSvsvWCcxB01DrjF96LwP+jjbL9Kv5ndmnZN3UQ/yCf
        99zBqMb/YkCk00rZtRT0ctbI6uxy9b+2IefOhtLu9iqQJLR0vqV3VmuIFNEsIPuuOlevAylAxnW
        8l7v5mtTSHCTzZZhLLjIHRTtAWF6PFjJEFr+olfeZdJ1XsoriZUuVCTQbcZ8K21zBg2KlfiPbfA
        0kXryG7TiNjlMSBIThyh1fI+WWckrh5ixLsopF7tsYs2GGj8FZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.559100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499868-r1r367RFXkkH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small functions doing work that will be common, related to reset
workqueue management.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile     |  7 +++-
 drivers/net/ethernet/sfc/efx.c        | 22 ++++------
 drivers/net/ethernet/sfc/efx_common.c | 58 +++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_common.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index c5c297e78d06..7022cffa31f8 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -1,7 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
-sfc-y			+= efx.o nic.o farch.o siena.o ef10.o tx.o rx.o \
+sfc-y			+= efx.o efx_common.o nic.o \
+			   farch.o siena.o ef10.o \
+			   tx.o rx.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
-			   mcdi.o mcdi_port.o mcdi_mon.o
+			   mcdi.o mcdi_port.o \
+			   mcdi_mon.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index ce8c0db2ba4b..c881e35b0477 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -108,12 +108,6 @@ void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen)
 		snprintf(buf, buflen, "type %d", type);
 }
 
-/* Reset workqueue. If any NIC has a hardware failure then a reset will be
- * queued onto this work queue. This is not a per-nic work queue, because
- * efx_reset_work() acquires the rtnl lock, so resets are naturally serialised.
- */
-static struct workqueue_struct *reset_workqueue;
-
 /* How often and how many times to poll for a reset while waiting for a
  * BIST that another function started to complete.
  */
@@ -3106,7 +3100,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	 * reset is scheduled. So switch back to poll'd MCDI completions. */
 	efx_mcdi_mode_poll(efx);
 
-	queue_work(reset_workqueue, &efx->reset_work);
+	efx_queue_reset_work(efx);
 }
 
 /**************************************************************************
@@ -3492,7 +3486,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	 * are not READY.
 	 */
 	BUG_ON(efx->state == STATE_READY);
-	cancel_work_sync(&efx->reset_work);
+	efx_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
 	efx_clear_interrupt_affinity(efx);
@@ -3878,7 +3872,7 @@ static int efx_pm_thaw(struct device *dev)
 	rtnl_unlock();
 
 	/* Reschedule any quenched resets scheduled during efx_pm_freeze() */
-	queue_work(reset_workqueue, &efx->reset_work);
+	efx_queue_reset_work(efx);
 
 	return 0;
 
@@ -4077,11 +4071,9 @@ static int __init efx_init_module(void)
 		goto err_sriov;
 #endif
 
-	reset_workqueue = create_singlethread_workqueue("sfc_reset");
-	if (!reset_workqueue) {
-		rc = -ENOMEM;
+	rc = efx_create_reset_workqueue();
+	if (rc)
 		goto err_reset;
-	}
 
 	rc = pci_register_driver(&efx_pci_driver);
 	if (rc < 0)
@@ -4090,7 +4082,7 @@ static int __init efx_init_module(void)
 	return 0;
 
  err_pci:
-	destroy_workqueue(reset_workqueue);
+	efx_destroy_reset_workqueue();
  err_reset:
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_sriov();
@@ -4106,7 +4098,7 @@ static void __exit efx_exit_module(void)
 	printk(KERN_INFO "Solarflare NET driver unloading\n");
 
 	pci_unregister_driver(&efx_pci_driver);
-	destroy_workqueue(reset_workqueue);
+	efx_destroy_reset_workqueue();
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_sriov();
 #endif
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
new file mode 100644
index 000000000000..5cadfba37fc4
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include "efx_common.h"
+#include "efx_channels.h"
+#include "efx.h"
+#include "mcdi.h"
+#include "selftest.h"
+#include "rx_common.h"
+#include "tx_common.h"
+#include "nic.h"
+#include "io.h"
+#include "mcdi_pcol.h"
+
+/* Reset workqueue. If any NIC has a hardware failure then a reset will be
+ * queued onto this work queue. This is not a per-nic work queue, because
+ * efx_reset_work() acquires the rtnl lock, so resets are naturally serialised.
+ */
+static struct workqueue_struct *reset_workqueue;
+
+int efx_create_reset_workqueue(void)
+{
+	reset_workqueue = create_singlethread_workqueue("sfc_reset");
+	if (!reset_workqueue) {
+		printk(KERN_ERR "Failed to create reset workqueue\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void efx_queue_reset_work(struct efx_nic *efx)
+{
+	queue_work(reset_workqueue, &efx->reset_work);
+}
+
+void efx_flush_reset_workqueue(struct efx_nic *efx)
+{
+	cancel_work_sync(&efx->reset_work);
+}
+
+void efx_destroy_reset_workqueue(void)
+{
+	if (reset_workqueue) {
+		destroy_workqueue(reset_workqueue);
+		reset_workqueue = NULL;
+	}
+}
-- 
2.20.1


