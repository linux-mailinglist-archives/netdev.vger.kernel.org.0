Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7520B088
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgFZLbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:31:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40460 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgFZLbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:31:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 570752008D;
        Fri, 26 Jun 2020 11:31:21 +0000 (UTC)
Received: from us4-mdac16-7.at1.mdlocal (unknown [10.110.49.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 563198009B;
        Fri, 26 Jun 2020 11:31:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 032B840058;
        Fri, 26 Jun 2020 11:31:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AAB5DB80065;
        Fri, 26 Jun 2020 11:31:20 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:31:15 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 11/15] sfc: track which BAR is mapped
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <146e3c06-87f6-c316-f45d-11fb80046d2b@solarflare.com>
Date:   Fri, 26 Jun 2020 12:31:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-4.243300-8.000000-10
X-TMASE-MatchedRID: 1eBVS6kWC5nxUUqAQjZLciyKzJY7d2nb3V4UShoTXafg+jsHnpr1WG41
        Eag8oZOh8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQsHl
        rSGNSOmYR8rhkwHMdrBchBqsrRYEQL36i8o633SBQ+S0N05fR+9xWLypmYlZzqPGqHIPGZiNNH9
        H34pgEaNKGOTerCvX3s9tvwbbix8KKhA2hG2DTq6oNIG7S1SGvrP7zBZ710YZF/5XzBv3ecp/p6
        742jA2BabKVIfM/3xbzXMT1mj8mC1+L4kKGn3opFOawCcdiU0NKRaXN2yYjHmRkNDqHE6hJvphV
        FiQ+RgKKsuZhl84RTlrVfJFK4nvRF2y1NgZbB62eAiCmPx4NwLTrdaH1ZWqCGtkvK5L7RXEXvQk
        Gi3tjz46HM5rqDwqtTcutWOyMfnKVqKBItvbl0vnuMjAEtM092i+ZJz6vurKLJiCMv16bGw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.243300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593171081-SHR9ooIrGJbm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 needs to map multiple BARs (sequentially, not concurrently) in
 order to read the Function Control Window during probe.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        |  4 ++--
 drivers/net/ethernet/sfc/efx_common.c | 19 ++++++++++++-------
 drivers/net/ethernet/sfc/efx_common.h |  2 +-
 drivers/net/ethernet/sfc/net_driver.h |  3 +++
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 474cfce5c042..86639b1e4e5c 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1074,7 +1074,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_pci_remove_main(efx);
 
-	efx_fini_io(efx, efx->type->mem_bar(efx));
+	efx_fini_io(efx);
 	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
 
 	efx_fini_struct(efx);
@@ -1342,7 +1342,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	return 0;
 
  fail3:
-	efx_fini_io(efx, efx->type->mem_bar(efx));
+	efx_fini_io(efx);
  fail2:
 	efx_fini_struct(efx);
  fail1:
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 02459d90afb0..36c0ab57d3bd 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -953,6 +953,8 @@ int efx_init_struct(struct efx_nic *efx,
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
 
+	efx->mem_bar = UINT_MAX;
+
 	rc = efx_init_channels(efx);
 	if (rc)
 		goto fail;
@@ -996,7 +998,9 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	struct pci_dev *pci_dev = efx->pci_dev;
 	int rc;
 
-	netif_dbg(efx, probe, efx->net_dev, "initialising I/O\n");
+	efx->mem_bar = UINT_MAX;
+
+	netif_dbg(efx, probe, efx->net_dev, "initialising I/O bar=%d\n", bar);
 
 	rc = pci_enable_device(pci_dev);
 	if (rc) {
@@ -1038,21 +1042,21 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	rc = pci_request_region(pci_dev, bar, "sfc");
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev,
-			  "request for memory BAR failed\n");
+			  "request for memory BAR[%d] failed\n", bar);
 		rc = -EIO;
 		goto fail3;
 	}
-
+	efx->mem_bar = bar;
 	efx->membase = ioremap(efx->membase_phys, mem_map_size);
 	if (!efx->membase) {
 		netif_err(efx, probe, efx->net_dev,
-			  "could not map memory BAR at %llx+%x\n",
+			  "could not map memory BAR[%d] at %llx+%x\n", bar,
 			  (unsigned long long)efx->membase_phys, mem_map_size);
 		rc = -ENOMEM;
 		goto fail4;
 	}
 	netif_dbg(efx, probe, efx->net_dev,
-		  "memory BAR at %llx+%x (virtual %p)\n",
+		  "memory BAR[%d] at %llx+%x (virtual %p)\n", bar,
 		  (unsigned long long)efx->membase_phys, mem_map_size,
 		  efx->membase);
 
@@ -1068,7 +1072,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	return rc;
 }
 
-void efx_fini_io(struct efx_nic *efx, int bar)
+void efx_fini_io(struct efx_nic *efx)
 {
 	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
 
@@ -1078,8 +1082,9 @@ void efx_fini_io(struct efx_nic *efx, int bar)
 	}
 
 	if (efx->membase_phys) {
-		pci_release_region(efx->pci_dev, bar);
+		pci_release_region(efx->pci_dev, efx->mem_bar);
 		efx->membase_phys = 0;
+		efx->mem_bar = UINT_MAX;
 	}
 
 	/* Don't disable bus-mastering if VFs are assigned */
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index c522a5be43d2..93a017aafb9f 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -13,7 +13,7 @@
 
 int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 		unsigned int mem_map_size);
-void efx_fini_io(struct efx_nic *efx, int bar);
+void efx_fini_io(struct efx_nic *efx);
 int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
 		    struct net_device *net_dev);
 void efx_fini_struct(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7bc4d1cbb398..e0b84b2e3bd2 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -961,6 +961,7 @@ struct efx_async_filter_insertion {
  * @vpd_sn: Serial number read from VPD
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
+ * @mem_bar: The BAR that is mapped into membase.
  * @monitor_work: Hardware monitor workitem
  * @biu_lock: BIU (bus interface unit) lock
  * @last_irq_cpu: Last CPU to handle a possible test interrupt.  This
@@ -1137,6 +1138,8 @@ struct efx_nic {
 	char *vpd_sn;
 	bool xdp_rxq_info_failed;
 
+	unsigned int mem_bar;
+
 	/* The following fields may be written more often */
 
 	struct delayed_work monitor_work ____cacheline_aligned_in_smp;

