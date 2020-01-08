Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7BD134747
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAHQKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:10:54 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34156 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728904AbgAHQKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:10:54 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2B441B40055;
        Wed,  8 Jan 2020 16:10:53 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:10:48 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 02/14] sfc: further preparation for code split
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <d54e7738-72d9-5afb-252b-e560feb5132a@solarflare.com>
Date:   Wed, 8 Jan 2020 16:10:45 +0000
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
X-TM-AS-Result: No-9.068000-8.000000-10
X-TMASE-MatchedRID: DcqGgPTZcVldZy3SxU1dnHYZxYoZm58FMHi1Ydy2WEhjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ4vV5f7P0HVDKSiMyrXKm9UQGn
        3MUIZ+3uEqK732q7561wDAh1dfD74ppxtrT/r6lEyIyttzvQ99w/o5bNHEsCTI7vGkGphvBhfMR
        ZFmBPqiPlf//t8PlzgHTKb768hcJGDzdmvk4Gt0sebIMlISwjbXGjQf7uckKs9phCcpYL3wQrer
        Kgs93AsEfK4ZMBzHazTwqurdQMjUvnmhzCNpxuqJDhQKCgPbQLgXnxE81iysZtxcHs098N0ngIg
        pj8eDcC063Wh9WVqgt063cjuGtrt+gtHj7OwNO2BSJy8ngwKGRrXF0qM1gk/MKouZLuWDIpnPk5
        Rwm2g8KfQz/MPf7d8870wkN6HZb4=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.068000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499853-ZA3EZIIlboQ5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added more arguments for a couple of functions.
Also moved a function to the common header.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 31 +++++++--------------------
 drivers/net/ethernet/sfc/efx_common.h | 15 ++++++++++---
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c5bcdfcfee87..ce8c0db2ba4b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -233,16 +233,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			ASSERT_RTNL();			\
 	} while (0)
 
-int efx_check_disabled(struct efx_nic *efx)
-{
-	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
-		netif_err(efx, drv, efx->net_dev,
-			  "device is disabled due to earlier errors\n");
-		return -EIO;
-	}
-	return 0;
-}
-
 /**************************************************************************
  *
  * Event queue processing
@@ -1283,17 +1273,14 @@ static void efx_dissociate(struct efx_nic *efx)
 }
 
 /* This configures the PCI device to enable I/O and DMA. */
-int efx_init_io(struct efx_nic *efx)
+int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
+		unsigned int mem_map_size)
 {
 	struct pci_dev *pci_dev = efx->pci_dev;
-	dma_addr_t dma_mask = efx->type->max_dma_mask;
-	unsigned int mem_map_size = efx->type->mem_map_size(efx);
-	int rc, bar;
+	int rc;
 
 	netif_dbg(efx, probe, efx->net_dev, "initialising I/O\n");
 
-	bar = efx->type->mem_bar(efx);
-
 	rc = pci_enable_device(pci_dev);
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev,
@@ -1354,10 +1341,8 @@ int efx_init_io(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_fini_io(struct efx_nic *efx)
+void efx_fini_io(struct efx_nic *efx, int bar)
 {
-	int bar;
-
 	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
 
 	if (efx->membase) {
@@ -1366,7 +1351,6 @@ void efx_fini_io(struct efx_nic *efx)
 	}
 
 	if (efx->membase_phys) {
-		bar = efx->type->mem_bar(efx);
 		pci_release_region(efx->pci_dev, bar);
 		efx->membase_phys = 0;
 	}
@@ -3548,7 +3532,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_pci_remove_main(efx);
 
-	efx_fini_io(efx);
+	efx_fini_io(efx, efx->type->mem_bar(efx));
 	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
 
 	efx_fini_struct(efx);
@@ -3771,7 +3755,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		efx_probe_vpd_strings(efx);
 
 	/* Set up basic I/O (BAR mappings etc) */
-	rc = efx_init_io(efx);
+	rc = efx_init_io(efx, efx->type->mem_bar(efx), efx->type->max_dma_mask,
+			 efx->type->mem_map_size(efx));
 	if (rc)
 		goto fail2;
 
@@ -3815,7 +3800,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	return 0;
 
  fail3:
-	efx_fini_io(efx);
+	efx_fini_io(efx, efx->type->mem_bar(efx));
  fail2:
 	efx_fini_struct(efx);
  fail1:
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index cb690d01adbc..c602e5257088 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -11,8 +11,9 @@
 #ifndef EFX_COMMON_H
 #define EFX_COMMON_H
 
-int efx_init_io(struct efx_nic *efx);
-void efx_fini_io(struct efx_nic *efx);
+int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
+		unsigned int mem_map_size);
+void efx_fini_io(struct efx_nic *efx, int bar);
 int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
 		    struct net_device *net_dev);
 void efx_fini_struct(struct efx_nic *efx);
@@ -44,7 +45,15 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
 int efx_reset(struct efx_nic *efx, enum reset_type method);
 void efx_schedule_reset(struct efx_nic *efx, enum reset_type type);
 
-int efx_check_disabled(struct efx_nic *efx);
+static inline int efx_check_disabled(struct efx_nic *efx)
+{
+	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
+		netif_err(efx, drv, efx->net_dev,
+			  "device is disabled due to earlier errors\n");
+		return -EIO;
+	}
+	return 0;
+}
 
 void efx_mac_reconfigure(struct efx_nic *efx);
 void efx_link_status_changed(struct efx_nic *efx);
-- 
2.20.1


