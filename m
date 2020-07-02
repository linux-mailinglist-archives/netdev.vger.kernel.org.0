Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9836021297D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgGBQaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:30:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39602 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgGBQau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:30:50 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 94310600A2;
        Thu,  2 Jul 2020 16:30:49 +0000 (UTC)
Received: from us4-mdac16-54.ut7.mdlocal (unknown [10.7.66.25])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9317D2009A;
        Thu,  2 Jul 2020 16:30:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 26B771C0076;
        Thu,  2 Jul 2020 16:30:49 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C700BBC009F;
        Thu,  2 Jul 2020 16:30:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:30:43 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 09/16] sfc: factor out
 efx_mcdi_filter_table_down() from _remove()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <357aba3a-7d3f-986d-fc9b-f7f22aa4837c@solarflare.com>
Date:   Thu, 2 Jul 2020 17:30:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-5.639900-8.000000-10
X-TMASE-MatchedRID: LFhZ4D3QpawcVEpQrFQCmojyEdGtYuoX5xJf2EAcYnC6pZ/o2Hu2YciT
        Wug2C4DNl1M7KT9/aqA65JDztUKj+SHhSBQfglfsA9lly13c/gE7IFMOvFEK2DEDYvokod/q3WY
        osUsOkYGt3u3G3/fqBu8pnOh8aIs8Q/2dy3++/gUK4MBRf7I7pmhuG2wmYC0X1Q7MHsm8hA26WH
        BNmATVQgy7vDGs8HQbPM0OcNL4IdJ4ha1qhP6vPglpVkdtt3WufS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDVPUMjJU8QZ2GzEK1+NM1dQrA+wZJ3NVz9Deuf2EZIjQZkwZdiuAetNwL6S
        xPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.639900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707449-nciBoZ0W1Pnz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

_down() merely removes all our filters and VLANs, it doesn't free
 efx->filter_state itself.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 37 ++++++++++++++++---------
 drivers/net/ethernet/sfc/mcdi_filters.h |  1 +
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 74ee06fe0996..283f68264b66 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1459,7 +1459,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		table->must_restore_filters = false;
 }
 
-void efx_mcdi_filter_table_remove(struct efx_nic *efx)
+void efx_mcdi_filter_table_down(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_EXT_IN_LEN);
@@ -1467,21 +1467,11 @@ void efx_mcdi_filter_table_remove(struct efx_nic *efx)
 	unsigned int filter_idx;
 	int rc;
 
-	efx_mcdi_filter_cleanup_vlans(efx);
-	efx->filter_state = NULL;
-	/*
-	 * If we were called without locking, then it's not safe to free
-	 * the table as others might be using it.  So we just WARN, leak
-	 * the memory, and potentially get an inconsistent filter table
-	 * state.
-	 * This should never actually happen.
-	 */
-	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
-		return;
-
 	if (!table)
 		return;
 
+	efx_mcdi_filter_cleanup_vlans(efx);
+
 	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		spec = efx_mcdi_filter_entry_spec(table, filter_idx);
 		if (!spec)
@@ -1501,6 +1491,27 @@ void efx_mcdi_filter_table_remove(struct efx_nic *efx)
 				   __func__, filter_idx);
 		kfree(spec);
 	}
+}
+
+void efx_mcdi_filter_table_remove(struct efx_nic *efx)
+{
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+
+	efx_mcdi_filter_table_down(efx);
+
+	efx->filter_state = NULL;
+	/*
+	 * If we were called without locking, then it's not safe to free
+	 * the table as others might be using it.  So we just WARN, leak
+	 * the memory, and potentially get an inconsistent filter table
+	 * state.
+	 * This should never actually happen.
+	 */
+	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
+		return;
+
+	if (!table)
+		return;
 
 	vfree(table->entry);
 	kfree(table);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 03a8bf74c733..23f9d08d071d 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -93,6 +93,7 @@ struct efx_mcdi_filter_table {
 };
 
 int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining);
+void efx_mcdi_filter_table_down(struct efx_nic *efx);
 void efx_mcdi_filter_table_remove(struct efx_nic *efx);
 void efx_mcdi_filter_table_restore(struct efx_nic *efx);
 

