Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF03135D1F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbgAIPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:45:10 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58916 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728357AbgAIPpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:45:09 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5094478006E;
        Thu,  9 Jan 2020 15:45:07 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:45:02 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 6/9] sfc: move MCDI transmit queue management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <768d0e04-34ae-cdff-ddcb-d2c6963b0511@solarflare.com>
Date:   Thu, 9 Jan 2020 15:44:59 +0000
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
X-TM-AS-Result: No-5.348800-8.000000-10
X-TMASE-MatchedRID: Ig6GCquy+lIZG2O2X/JQZRouoVvF2i0ZAf1C358hdK9jLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5/64NkLyMdN5u6++Cllkj5P5v
        0VYIETy3iUbHr9+jEYIDGySr3NZUt8SaOVAGEZoJlpwNsTvdlKQ/o5bNHEsCTDpCUEeEFm7AL8b
        Sq+AkUJ2c5xJalDrvMH5VvilZUGGQdqirDt7KDjEdAWPMBu8kQRElFv2Ob9BJFsPBvc3lnClGRh
        NKlKyVFp7q20A/R7wv1kwmFvpSklJFXLDgU0XwyalRqQPhHMT5ReWnUUdhI9XxbHSW75Ustc9ZY
        NjuFJJVMQmNkSSNknkUtrDtCnnxyjtapcCTXkeBtawJSSsDgSXyzRzLq38pIydmEN0UhdkScpsr
        vWeoKLawx1AZuq2dUU3pAK/eq+U7lRxm3A2wKujl/1fD/GopdkvL+Ti49jcrEQdG7H66TyMdRT5
        TQAJnAY5yoDjbJhYmiPR7AiKDb/uB2kL4CXfNZxCA3ZLyl14eeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.348800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584708-f7KDJh87ctQT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function was split, the others were renamed.

Code style fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           |  94 ++------------------
 drivers/net/ethernet/sfc/mcdi_functions.c | 100 ++++++++++++++++++++++
 2 files changed, 109 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index e21ee5ccea6a..aeb6c2059eb1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2378,20 +2378,15 @@ static u32 efx_ef10_tso_versions(struct efx_nic *efx)
 
 static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 {
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
-						       EFX_BUF_SIZE));
 	bool csum_offload = tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD;
-	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	struct efx_ef10_nic_data *nic_data;
 	bool tso_v2 = false;
-	size_t inlen;
-	dma_addr_t dma_addr;
 	efx_qword_t *txd;
 	int rc;
-	int i;
-	BUILD_BUG_ON(MC_CMD_INIT_TXQ_OUT_LEN != 0);
+
+	nic_data = efx->nic_data;
 
 	/* Only attempt to enable TX timestamping if we have the license for it,
 	 * otherwise TXQ init will fail
@@ -2418,51 +2413,9 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 				channel->channel);
 	}
 
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_SIZE, tx_queue->ptr_mask + 1);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_TARGET_EVQ, channel->channel);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_LABEL, tx_queue->queue);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_INSTANCE, tx_queue->queue);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_OWNER_ID, 0);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_PORT_ID, nic_data->vport_id);
-
-	dma_addr = tx_queue->txd.buf.dma_addr;
-
-	netif_dbg(efx, hw, efx->net_dev, "pushing TXQ %d. %zu entries (%llx)\n",
-		  tx_queue->queue, entries, (u64)dma_addr);
-
-	for (i = 0; i < entries; ++i) {
-		MCDI_SET_ARRAY_QWORD(inbuf, INIT_TXQ_IN_DMA_ADDR, i, dma_addr);
-		dma_addr += EFX_BUF_SIZE;
-	}
-
-	inlen = MC_CMD_INIT_TXQ_IN_LEN(entries);
-
-	do {
-		MCDI_POPULATE_DWORD_4(inbuf, INIT_TXQ_IN_FLAGS,
-				/* This flag was removed from mcdi_pcol.h for
-				 * the non-_EXT version of INIT_TXQ.  However,
-				 * firmware still honours it.
-				 */
-				INIT_TXQ_EXT_IN_FLAG_TSOV2_EN, tso_v2,
-				INIT_TXQ_IN_FLAG_IP_CSUM_DIS, !csum_offload,
-				INIT_TXQ_IN_FLAG_TCP_CSUM_DIS, !csum_offload,
-				INIT_TXQ_EXT_IN_FLAG_TIMESTAMP,
-						tx_queue->timestamping);
-
-		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_INIT_TXQ, inbuf, inlen,
-					NULL, 0, NULL);
-		if (rc == -ENOSPC && tso_v2) {
-			/* Retry without TSOv2 if we're short on contexts. */
-			tso_v2 = false;
-			netif_warn(efx, probe, efx->net_dev,
-				   "TSOv2 context not available to segment in hardware. TCP performance may be reduced.\n");
-		} else if (rc) {
-			efx_mcdi_display_error(efx, MC_CMD_INIT_TXQ,
-					       MC_CMD_INIT_TXQ_EXT_IN_LEN,
-					       NULL, 0, rc);
-			goto fail;
-		}
-	} while (rc);
+	rc = efx_mcdi_tx_init(tx_queue, tso_v2);
+	if (rc)
+		goto fail;
 
 	/* A previous user of this TX queue might have set us up the
 	 * bomb by writing a descriptor to the TX push collector but
@@ -2500,35 +2453,6 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 		    tx_queue->queue);
 }
 
-static void efx_ef10_tx_fini(struct efx_tx_queue *tx_queue)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_TXQ_IN_LEN);
-	MCDI_DECLARE_BUF_ERR(outbuf);
-	struct efx_nic *efx = tx_queue->efx;
-	size_t outlen;
-	int rc;
-
-	MCDI_SET_DWORD(inbuf, FINI_TXQ_IN_INSTANCE,
-		       tx_queue->queue);
-
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_TXQ, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
-
-	if (rc && rc != -EALREADY)
-		goto fail;
-
-	return;
-
-fail:
-	efx_mcdi_display_error(efx, MC_CMD_FINI_TXQ, MC_CMD_FINI_TXQ_IN_LEN,
-			       outbuf, outlen, rc);
-}
-
-static void efx_ef10_tx_remove(struct efx_tx_queue *tx_queue)
-{
-	efx_nic_free_buffer(tx_queue->efx, &tx_queue->txd.buf);
-}
-
 /* This writes to the TX_DESC_WPTR; write pointer for TX descriptor ring */
 static inline void efx_ef10_notify_tx_desc(struct efx_tx_queue *tx_queue)
 {
@@ -3857,7 +3781,7 @@ static int efx_ef10_fini_dmaq(struct efx_nic *efx)
 			efx_for_each_channel_rx_queue(rx_queue, channel)
 				efx_ef10_rx_fini(rx_queue);
 			efx_for_each_channel_tx_queue(tx_queue, channel)
-				efx_ef10_tx_fini(tx_queue);
+				efx_mcdi_tx_fini(tx_queue);
 		}
 
 		wait_event_timeout(efx->flush_wq,
@@ -6529,7 +6453,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.irq_handle_legacy = efx_ef10_legacy_interrupt,
 	.tx_probe = efx_ef10_tx_probe,
 	.tx_init = efx_ef10_tx_init,
-	.tx_remove = efx_ef10_tx_remove,
+	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
 	.rx_push_rss_config = efx_ef10_vf_rx_push_rss_config,
@@ -6638,7 +6562,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.irq_handle_legacy = efx_ef10_legacy_interrupt,
 	.tx_probe = efx_ef10_tx_probe,
 	.tx_init = efx_ef10_tx_init,
-	.tx_remove = efx_ef10_tx_remove,
+	.tx_remove = efx_mcdi_tx_remove,
 	.tx_write = efx_ef10_tx_write,
 	.tx_limit_len = efx_ef10_tx_limit_len,
 	.rx_push_rss_config = efx_ef10_pf_rx_push_rss_config,
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index a1d37aec6013..9dc1395e5f68 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -162,3 +162,103 @@ void efx_mcdi_ev_fini(struct efx_channel *channel)
 	efx_mcdi_display_error(efx, MC_CMD_FINI_EVQ, MC_CMD_FINI_EVQ_IN_LEN,
 			       outbuf, outlen, rc);
 }
+
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
+						       EFX_BUF_SIZE));
+	bool csum_offload = tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD;
+	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
+	struct efx_channel *channel = tx_queue->channel;
+	struct efx_nic *efx = tx_queue->efx;
+	struct efx_ef10_nic_data *nic_data;
+	dma_addr_t dma_addr;
+	size_t inlen;
+	int rc, i;
+
+	BUILD_BUG_ON(MC_CMD_INIT_TXQ_OUT_LEN != 0);
+
+	nic_data = efx->nic_data;
+
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_SIZE, tx_queue->ptr_mask + 1);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_TARGET_EVQ, channel->channel);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_LABEL, tx_queue->queue);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_INSTANCE, tx_queue->queue);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_OWNER_ID, 0);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_PORT_ID, nic_data->vport_id);
+
+	dma_addr = tx_queue->txd.buf.dma_addr;
+
+	netif_dbg(efx, hw, efx->net_dev, "pushing TXQ %d. %zu entries (%llx)\n",
+		  tx_queue->queue, entries, (u64)dma_addr);
+
+	for (i = 0; i < entries; ++i) {
+		MCDI_SET_ARRAY_QWORD(inbuf, INIT_TXQ_IN_DMA_ADDR, i, dma_addr);
+		dma_addr += EFX_BUF_SIZE;
+	}
+
+	inlen = MC_CMD_INIT_TXQ_IN_LEN(entries);
+
+	do {
+		MCDI_POPULATE_DWORD_4(inbuf, INIT_TXQ_IN_FLAGS,
+				/* This flag was removed from mcdi_pcol.h for
+				 * the non-_EXT version of INIT_TXQ.  However,
+				 * firmware still honours it.
+				 */
+				INIT_TXQ_EXT_IN_FLAG_TSOV2_EN, tso_v2,
+				INIT_TXQ_IN_FLAG_IP_CSUM_DIS, !csum_offload,
+				INIT_TXQ_IN_FLAG_TCP_CSUM_DIS, !csum_offload,
+				INIT_TXQ_EXT_IN_FLAG_TIMESTAMP,
+						tx_queue->timestamping);
+
+		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_INIT_TXQ, inbuf, inlen,
+					NULL, 0, NULL);
+		if (rc == -ENOSPC && tso_v2) {
+			/* Retry without TSOv2 if we're short on contexts. */
+			tso_v2 = false;
+			netif_warn(efx, probe, efx->net_dev,
+				   "TSOv2 context not available to segment in "
+				   "hardware. TCP performance may be reduced.\n"
+				   );
+		} else if (rc) {
+			efx_mcdi_display_error(efx, MC_CMD_INIT_TXQ,
+					       MC_CMD_INIT_TXQ_EXT_IN_LEN,
+					       NULL, 0, rc);
+			goto fail;
+		}
+	} while (rc);
+
+	return 0;
+
+fail:
+	return rc;
+}
+
+void efx_mcdi_tx_remove(struct efx_tx_queue *tx_queue)
+{
+	efx_nic_free_buffer(tx_queue->efx, &tx_queue->txd.buf);
+}
+
+void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_TXQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efx_nic *efx = tx_queue->efx;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, FINI_TXQ_IN_INSTANCE,
+		       tx_queue->queue);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_TXQ, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
+
+	if (rc && rc != -EALREADY)
+		goto fail;
+
+	return;
+
+fail:
+	efx_mcdi_display_error(efx, MC_CMD_FINI_TXQ, MC_CMD_FINI_TXQ_IN_LEN,
+			       outbuf, outlen, rc);
+}
-- 
2.20.1


