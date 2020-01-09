Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A00135D15
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732553AbgAIPoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:44:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33582 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgAIPoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:44:37 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1258AB40069;
        Thu,  9 Jan 2020 15:44:36 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:44:31 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 4/9] sfc: move MCDI VI alloc/free code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <73e93e1c-9cb3-f891-3bde-68bd61e73fbd@solarflare.com>
Date:   Thu, 9 Jan 2020 15:44:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-7.695900-8.000000-10
X-TMASE-MatchedRID: Ig6GCquy+lJh44VlLBLudBxF6n3xHm7hDmTV5r5yWnpjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8JfTUJMI/BDGSVIFgun+1oxxA9lly13c/gGVEBFE/RqSjdEsTITobgNED6C
        6Ni8q1p53g2kzVskNpK1TSd3U5mjSQWUWXBoRfKHN+qWlu2ZxaPpAG8AHGkHxR2YNIFh+clGEPj
        gfexai7rTS8V4781v3K8abtsOcLcmfT/zxNL8LPhIRh9wkXSlFOyBTDrxRCtgCqZIZo3TxUKt3L
        bZQ6GwMXyVchwHbmNzUlAIDUI+T81i05ywc2mSS/ccgt/EtX/040Z7wJJ2tFZh4xM9oAcstKRF2
        K5JKQbwIqLXq8tvjOyKqCHsuzU7ZlWvOHK6wACuEksV+sNN6bqrFemr66cZVOTEpRIdRHfQSgHs
        IPe1XmGk7S9xm8HyHHN5frAMTKMyR9GF2J2xqMzl/1fD/GopdkvL+Ti49jcrEQdG7H66TyH4gKq
        42LRYkLeWHTqGvNt66PuFgqfMMgyWNPqRSftJSQ0u6w/cWHlJ+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.695900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584676-jESaM2jYb6uU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One function was renamed here, the other contains code extracted from
another.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile         |  2 +-
 drivers/net/ethernet/sfc/ef10.c           | 45 +++--------------
 drivers/net/ethernet/sfc/mcdi_functions.c | 61 +++++++++++++++++++++++
 3 files changed, 68 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_functions.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index f6d4b2b2dd83..ffa84b3ff8e2 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -4,7 +4,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   tx.o tx_common.o rx.o rx_common.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
-			   mcdi_mon.o
+			   mcdi_functions.o mcdi_mon.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index d752ed34672d..f7df5ee801ef 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -11,6 +11,7 @@
 #include "mcdi.h"
 #include "mcdi_pcol.h"
 #include "mcdi_port_common.h"
+#include "mcdi_functions.h"
 #include "nic.h"
 #include "workarounds.h"
 #include "selftest.h"
@@ -834,22 +835,6 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	return rc;
 }
 
-static int efx_ef10_free_vis(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF_ERR(outbuf);
-	size_t outlen;
-	int rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FREE_VIS, NULL, 0,
-				    outbuf, sizeof(outbuf), &outlen);
-
-	/* -EALREADY means nothing to free, so ignore */
-	if (rc == -EALREADY)
-		rc = 0;
-	if (rc)
-		efx_mcdi_display_error(efx, MC_CMD_FREE_VIS, 0, outbuf, outlen,
-				       rc);
-	return rc;
-}
-
 #ifdef EFX_USE_PIO
 
 static void efx_ef10_free_piobufs(struct efx_nic *efx)
@@ -1092,7 +1077,7 @@ static void efx_ef10_remove(struct efx_nic *efx)
 	if (nic_data->wc_membase)
 		iounmap(nic_data->wc_membase);
 
-	rc = efx_ef10_free_vis(efx);
+	rc = efx_mcdi_free_vis(efx);
 	WARN_ON(rc != 0);
 
 	if (!nic_data->must_restore_piobufs)
@@ -1263,28 +1248,10 @@ static int efx_ef10_probe_vf(struct efx_nic *efx __attribute__ ((unused)))
 static int efx_ef10_alloc_vis(struct efx_nic *efx,
 			      unsigned int min_vis, unsigned int max_vis)
 {
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_ALLOC_VIS_IN_LEN);
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_ALLOC_VIS_OUT_LEN);
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	size_t outlen;
-	int rc;
-
-	MCDI_SET_DWORD(inbuf, ALLOC_VIS_IN_MIN_VI_COUNT, min_vis);
-	MCDI_SET_DWORD(inbuf, ALLOC_VIS_IN_MAX_VI_COUNT, max_vis);
-	rc = efx_mcdi_rpc(efx, MC_CMD_ALLOC_VIS, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc != 0)
-		return rc;
 
-	if (outlen < MC_CMD_ALLOC_VIS_OUT_LEN)
-		return -EIO;
-
-	netif_dbg(efx, drv, efx->net_dev, "base VI is A0x%03x\n",
-		  MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_BASE));
-
-	nic_data->vi_base = MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_BASE);
-	nic_data->n_allocated_vis = MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_COUNT);
-	return 0;
+	return efx_mcdi_alloc_vis(efx, min_vis, max_vis, &nic_data->vi_base,
+				  &nic_data->n_allocated_vis);
 }
 
 /* Note that the failure path of this function does not free
@@ -1366,7 +1333,7 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 	}
 
 	/* In case the last attached driver failed to free VIs, do it now */
-	rc = efx_ef10_free_vis(efx);
+	rc = efx_mcdi_free_vis(efx);
 	if (rc != 0)
 		return rc;
 
@@ -1387,7 +1354,7 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 		efx->max_tx_channels =
 			nic_data->n_allocated_vis / EFX_TXQ_TYPES;
 
-		efx_ef10_free_vis(efx);
+		efx_mcdi_free_vis(efx);
 		return -EAGAIN;
 	}
 
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
new file mode 100644
index 000000000000..65a4689337db
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include "efx.h"
+#include "nic.h"
+#include "mcdi_functions.h"
+#include "mcdi.h"
+#include "mcdi_pcol.h"
+
+int efx_mcdi_free_vis(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	size_t outlen;
+	int rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FREE_VIS, NULL, 0,
+				    outbuf, sizeof(outbuf), &outlen);
+
+	/* -EALREADY means nothing to free, so ignore */
+	if (rc == -EALREADY)
+		rc = 0;
+	if (rc)
+		efx_mcdi_display_error(efx, MC_CMD_FREE_VIS, 0, outbuf, outlen,
+				       rc);
+	return rc;
+}
+
+int efx_mcdi_alloc_vis(struct efx_nic *efx, unsigned int min_vis,
+		       unsigned int max_vis, unsigned int *vi_base,
+		       unsigned int *allocated_vis)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_ALLOC_VIS_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_ALLOC_VIS_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, ALLOC_VIS_IN_MIN_VI_COUNT, min_vis);
+	MCDI_SET_DWORD(inbuf, ALLOC_VIS_IN_MAX_VI_COUNT, max_vis);
+	rc = efx_mcdi_rpc(efx, MC_CMD_ALLOC_VIS, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc != 0)
+		return rc;
+
+	if (outlen < MC_CMD_ALLOC_VIS_OUT_LEN)
+		return -EIO;
+
+	netif_dbg(efx, drv, efx->net_dev, "base VI is A0x%03x\n",
+		  MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_BASE));
+
+	if (vi_base)
+		*vi_base = MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_BASE);
+	if (allocated_vis)
+		*allocated_vis = MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_COUNT);
+	return 0;
+}
-- 
2.20.1


