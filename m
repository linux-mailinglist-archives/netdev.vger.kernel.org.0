Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBDA248504
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHRMo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:44:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52702 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgHRMo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:44:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 14E93200A8;
        Tue, 18 Aug 2020 12:44:58 +0000 (UTC)
Received: from us4-mdac16-36.at1.mdlocal (unknown [10.110.51.51])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1353E600A7;
        Tue, 18 Aug 2020 12:44:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.234])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A218D220071;
        Tue, 18 Aug 2020 12:44:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6B42978006B;
        Tue, 18 Aug 2020 12:44:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 13:44:53 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 4/4] sfc: don't free_irq()s if they were never requested
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Message-ID: <94cf6748-2adb-a85b-9d95-c2dc02fe586e@solarflare.com>
Date:   Tue, 18 Aug 2020 13:44:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25610.005
X-TM-AS-Result: No-5.273400-8.000000-10
X-TMASE-MatchedRID: 3xYPTUmvdolvYiFBtKLWhixYq3WqsPihurOlC+PL0QCxLSxkQHtzxt84
        NUiA4ZF8RshMHFySWyo2ZNtJRz3gK/36sqVF/VZoMIxbvM3AVoh14aBeBfQOLgAheUymmndf035
        U7xRHgyHJ/hRSI+YUuoo243wxl3VEIeFIFB+CV+wD2WXLXdz+AZ8kBWlYDDNg0SxMhOhuA0RBzv
        Gtsfv/0T/bLymuCi5PFFGVHCK0F0nxJo5UAYRmglmU3gdLaqKb+eBf9ovw8I2KIo9dsR2z7vi/Q
        OHQsjAJcZutroCkFkVJPQ34bti/Gvr252PTOmm/RFakFvQb7am6hgVvSdGKo+y9vsxhLmze77Db
        /s+j3t7i8zVgXoAltkWL4rBlm20vjaPj0W1qn0SyO81X3yak89pWdAlJ0bAmdWYSr9lXkEAlS2i
        evEPM31ISVucSYrNTt8T/RO37r1h+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.273400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.005
X-MDID: 1597754698-P3I2Nat7wpoP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If efx_nic_init_interrupt fails, or was never run (e.g. due to an earlier
 failure in ef100_net_open), freeing irqs in efx_nic_fini_interrupt is not
 needed and will cause error messages and stack traces.
So instead, only do this if efx_nic_init_interrupt successfully completed,
 as indicated by the new efx->irqs_hooked flag.

Fixes: 965b549f3c20 ("sfc_ef100: implement ndo_open/close and EVQ probing")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/net_driver.h | 2 ++
 drivers/net/ethernet/sfc/nic.c        | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index dcb741d8bd11..062462a13847 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -846,6 +846,7 @@ struct efx_async_filter_insertion {
  * @timer_quantum_ns: Interrupt timer quantum, in nanoseconds
  * @timer_max_ns: Interrupt timer maximum value, in nanoseconds
  * @irq_rx_adaptive: Adaptive IRQ moderation enabled for RX event queues
+ * @irqs_hooked: Channel interrupts are hooked
  * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
  * @irq_rx_moderation_us: IRQ moderation time for RX event queues
  * @msg_enable: Log message enable flags
@@ -1004,6 +1005,7 @@ struct efx_nic {
 	unsigned int timer_quantum_ns;
 	unsigned int timer_max_ns;
 	bool irq_rx_adaptive;
+	bool irqs_hooked;
 	unsigned int irq_mod_step_us;
 	unsigned int irq_rx_moderation_us;
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index d994d136bb03..d1e908846f5d 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -129,6 +129,7 @@ int efx_nic_init_interrupt(struct efx_nic *efx)
 #endif
 	}
 
+	efx->irqs_hooked = true;
 	return 0;
 
  fail2:
@@ -154,6 +155,8 @@ void efx_nic_fini_interrupt(struct efx_nic *efx)
 	efx->net_dev->rx_cpu_rmap = NULL;
 #endif
 
+	if (!efx->irqs_hooked)
+		return;
 	if (EFX_INT_MODE_USE_MSI(efx)) {
 		/* Disable MSI/MSI-X interrupts */
 		efx_for_each_channel(channel, efx)
@@ -163,6 +166,7 @@ void efx_nic_fini_interrupt(struct efx_nic *efx)
 		/* Disable legacy interrupt */
 		free_irq(efx->legacy_irq, efx);
 	}
+	efx->irqs_hooked = false;
 }
 
 /* Register dump */
