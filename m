Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CBB135D1B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbgAIPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:44:55 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36272 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732600AbgAIPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:44:54 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 40A0E4C007D;
        Thu,  9 Jan 2020 15:44:52 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:44:47 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 5/9] sfc: move MCDI event queue management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <be5e792a-2677-6a10-3158-d10ad4c6a324@solarflare.com>
Date:   Thu, 9 Jan 2020 15:44:43 +0000
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
X-TM-AS-Result: No-11.003000-8.000000-10
X-TMASE-MatchedRID: FovyEv4jNeoZG2O2X/JQZRouoVvF2i0ZAf1C358hdK9jLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSR/j040fRFpIvsOOmgOo1mVVkJxysad/IqfA
        eBzp+4yQAwXM9XSqdiSRP0D74JlLSvYtt39hpnmPJ1E/nrJFEDzawe48Wd+zOqPGqHIPGZiNLvX
        uEv/ny9qejC9LjX9sMyFrcOXFEc+1WmVSbj8vwrDIjK23O9D33ab+ZPXqZNQKExk6c4qzx8hy++
        wzvxIpoVU3XU64zCzo91Z08bZPyj035WIWBwPo0NDrSVZCgbSuhhKooH+/fy8eQfu6iwSfs2Z5d
        2c6tpnaC0wODpikdHQAOXy7qIPMIem9j3cWUGvAwjFu8zcBWiCIHuRqEr/Ty2An5g1C6+/L9xdt
        HRs1FPZGvMg4KPUhRnArk+q2OwUtJJT1WS212gcgVrCfx7T+rfS0Ip2eEHny+qryzYw2E8CrT0J
        wyZBpHKrauXd3MZDVyWZ6n4A6NAaWmdUqZsoBtbK5aAZ7Nuq/XuL+i3Lo53f6D3kTUvT+7
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.003000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584693-OVpmplDTpZKc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function was split, the others were renamed.

Code style fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 117 +++-------------------
 drivers/net/ethernet/sfc/mcdi_functions.c | 103 +++++++++++++++++++
 2 files changed, 116 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index f7df5ee801ef..e21ee5ccea6a 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3199,106 +3199,20 @@ efx_ef10_rx_defer_refill_complete(struct efx_nic *efx, unsigned long cookie,
 	/* nothing to do */
 }
 
-static int efx_ef10_ev_probe(struct efx_channel *channel)
-{
-	return efx_nic_alloc_buffer(channel->efx, &channel->eventq.buf,
-				    (channel->eventq_mask + 1) *
-				    sizeof(efx_qword_t),
-				    GFP_KERNEL);
-}
-
-static void efx_ef10_ev_fini(struct efx_channel *channel)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_EVQ_IN_LEN);
-	MCDI_DECLARE_BUF_ERR(outbuf);
-	struct efx_nic *efx = channel->efx;
-	size_t outlen;
-	int rc;
-
-	MCDI_SET_DWORD(inbuf, FINI_EVQ_IN_INSTANCE, channel->channel);
-
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_EVQ, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
-
-	if (rc && rc != -EALREADY)
-		goto fail;
-
-	return;
-
-fail:
-	efx_mcdi_display_error(efx, MC_CMD_FINI_EVQ, MC_CMD_FINI_EVQ_IN_LEN,
-			       outbuf, outlen, rc);
-}
-
 static int efx_ef10_ev_init(struct efx_channel *channel)
 {
-	MCDI_DECLARE_BUF(inbuf,
-			 MC_CMD_INIT_EVQ_V2_IN_LEN(EFX_MAX_EVQ_SIZE * 8 /
-						   EFX_BUF_SIZE));
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_INIT_EVQ_V2_OUT_LEN);
-	size_t entries = channel->eventq.buf.len / EFX_BUF_SIZE;
 	struct efx_nic *efx = channel->efx;
 	struct efx_ef10_nic_data *nic_data;
-	size_t inlen, outlen;
 	unsigned int enabled, implemented;
-	dma_addr_t dma_addr;
+	bool use_v2, cut_thru;
 	int rc;
-	int i;
 
 	nic_data = efx->nic_data;
-
-	/* Fill event queue with all ones (i.e. empty events) */
-	memset(channel->eventq.buf.addr, 0xff, channel->eventq.buf.len);
-
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_SIZE, channel->eventq_mask + 1);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_INSTANCE, channel->channel);
-	/* INIT_EVQ expects index in vector table, not absolute */
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_IRQ_NUM, channel->channel);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_MODE,
-		       MC_CMD_INIT_EVQ_IN_TMR_MODE_DIS);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_LOAD, 0);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_RELOAD, 0);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_COUNT_MODE,
-		       MC_CMD_INIT_EVQ_IN_COUNT_MODE_DIS);
-	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_COUNT_THRSHLD, 0);
-
-	if (nic_data->datapath_caps2 &
-	    1 << MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_LBN) {
-		/* Use the new generic approach to specifying event queue
-		 * configuration, requesting lower latency or higher throughput.
-		 * The options that actually get used appear in the output.
-		 */
-		MCDI_POPULATE_DWORD_2(inbuf, INIT_EVQ_V2_IN_FLAGS,
-				      INIT_EVQ_V2_IN_FLAG_INTERRUPTING, 1,
-				      INIT_EVQ_V2_IN_FLAG_TYPE,
-				      MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_AUTO);
-	} else {
-		bool cut_thru = !(nic_data->datapath_caps &
-			1 << MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_LBN);
-
-		MCDI_POPULATE_DWORD_4(inbuf, INIT_EVQ_IN_FLAGS,
-				      INIT_EVQ_IN_FLAG_INTERRUPTING, 1,
-				      INIT_EVQ_IN_FLAG_RX_MERGE, 1,
-				      INIT_EVQ_IN_FLAG_TX_MERGE, 1,
-				      INIT_EVQ_IN_FLAG_CUT_THRU, cut_thru);
-	}
-
-	dma_addr = channel->eventq.buf.dma_addr;
-	for (i = 0; i < entries; ++i) {
-		MCDI_SET_ARRAY_QWORD(inbuf, INIT_EVQ_IN_DMA_ADDR, i, dma_addr);
-		dma_addr += EFX_BUF_SIZE;
-	}
-
-	inlen = MC_CMD_INIT_EVQ_IN_LEN(entries);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_EVQ, inbuf, inlen,
-			  outbuf, sizeof(outbuf), &outlen);
-
-	if (outlen >= MC_CMD_INIT_EVQ_V2_OUT_LEN)
-		netif_dbg(efx, drv, efx->net_dev,
-			  "Channel %d using event queue flags %08x\n",
-			  channel->channel,
-			  MCDI_DWORD(outbuf, INIT_EVQ_V2_OUT_FLAGS));
+	use_v2 = nic_data->datapath_caps2 &
+			    1 << MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_LBN;
+	cut_thru = !(nic_data->datapath_caps &
+			      1 << MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_LBN);
+	rc = efx_mcdi_ev_init(channel, cut_thru, use_v2);
 
 	/* IRQ return is ignored */
 	if (channel->channel || rc)
@@ -3356,15 +3270,10 @@ static int efx_ef10_ev_init(struct efx_channel *channel)
 		return 0;
 
 fail:
-	efx_ef10_ev_fini(channel);
+	efx_mcdi_ev_fini(channel);
 	return rc;
 }
 
-static void efx_ef10_ev_remove(struct efx_channel *channel)
-{
-	efx_nic_free_buffer(channel->efx, &channel->eventq.buf);
-}
-
 static void efx_ef10_handle_rx_wrong_queue(struct efx_rx_queue *rx_queue,
 					   unsigned int rx_queue_label)
 {
@@ -6630,10 +6539,10 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.rx_remove = efx_ef10_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
-	.ev_probe = efx_ef10_ev_probe,
+	.ev_probe = efx_mcdi_ev_probe,
 	.ev_init = efx_ef10_ev_init,
-	.ev_fini = efx_ef10_ev_fini,
-	.ev_remove = efx_ef10_ev_remove,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
@@ -6742,10 +6651,10 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.rx_remove = efx_ef10_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
-	.ev_probe = efx_ef10_ev_probe,
+	.ev_probe = efx_mcdi_ev_probe,
 	.ev_init = efx_ef10_ev_init,
-	.ev_fini = efx_ef10_ev_fini,
-	.ev_remove = efx_ef10_ev_remove,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 65a4689337db..a1d37aec6013 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -59,3 +59,106 @@ int efx_mcdi_alloc_vis(struct efx_nic *efx, unsigned int min_vis,
 		*allocated_vis = MCDI_DWORD(outbuf, ALLOC_VIS_OUT_VI_COUNT);
 	return 0;
 }
+
+int efx_mcdi_ev_probe(struct efx_channel *channel)
+{
+	return efx_nic_alloc_buffer(channel->efx, &channel->eventq.buf,
+				    (channel->eventq_mask + 1) *
+				    sizeof(efx_qword_t),
+				    GFP_KERNEL);
+}
+
+int efx_mcdi_ev_init(struct efx_channel *channel, bool v1_cut_thru, bool v2)
+{
+	MCDI_DECLARE_BUF(inbuf,
+			 MC_CMD_INIT_EVQ_V2_IN_LEN(EFX_MAX_EVQ_SIZE * 8 /
+						   EFX_BUF_SIZE));
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_INIT_EVQ_V2_OUT_LEN);
+	size_t entries = channel->eventq.buf.len / EFX_BUF_SIZE;
+	struct efx_nic *efx = channel->efx;
+	struct efx_ef10_nic_data *nic_data;
+	size_t inlen, outlen;
+	dma_addr_t dma_addr;
+	int rc, i;
+
+	nic_data = efx->nic_data;
+
+	/* Fill event queue with all ones (i.e. empty events) */
+	memset(channel->eventq.buf.addr, 0xff, channel->eventq.buf.len);
+
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_SIZE, channel->eventq_mask + 1);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_INSTANCE, channel->channel);
+	/* INIT_EVQ expects index in vector table, not absolute */
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_IRQ_NUM, channel->channel);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_MODE,
+		       MC_CMD_INIT_EVQ_IN_TMR_MODE_DIS);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_LOAD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_TMR_RELOAD, 0);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_COUNT_MODE,
+		       MC_CMD_INIT_EVQ_IN_COUNT_MODE_DIS);
+	MCDI_SET_DWORD(inbuf, INIT_EVQ_IN_COUNT_THRSHLD, 0);
+
+	if (v2) {
+		/* Use the new generic approach to specifying event queue
+		 * configuration, requesting lower latency or higher throughput.
+		 * The options that actually get used appear in the output.
+		 */
+		MCDI_POPULATE_DWORD_2(inbuf, INIT_EVQ_V2_IN_FLAGS,
+				      INIT_EVQ_V2_IN_FLAG_INTERRUPTING, 1,
+				      INIT_EVQ_V2_IN_FLAG_TYPE,
+				      MC_CMD_INIT_EVQ_V2_IN_FLAG_TYPE_AUTO);
+	} else {
+		MCDI_POPULATE_DWORD_4(inbuf, INIT_EVQ_IN_FLAGS,
+				      INIT_EVQ_IN_FLAG_INTERRUPTING, 1,
+				      INIT_EVQ_IN_FLAG_RX_MERGE, 1,
+				      INIT_EVQ_IN_FLAG_TX_MERGE, 1,
+				      INIT_EVQ_IN_FLAG_CUT_THRU, v1_cut_thru);
+	}
+
+	dma_addr = channel->eventq.buf.dma_addr;
+	for (i = 0; i < entries; ++i) {
+		MCDI_SET_ARRAY_QWORD(inbuf, INIT_EVQ_IN_DMA_ADDR, i, dma_addr);
+		dma_addr += EFX_BUF_SIZE;
+	}
+
+	inlen = MC_CMD_INIT_EVQ_IN_LEN(entries);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_EVQ, inbuf, inlen,
+			  outbuf, sizeof(outbuf), &outlen);
+
+	if (outlen >= MC_CMD_INIT_EVQ_V2_OUT_LEN)
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Channel %d using event queue flags %08x\n",
+			  channel->channel,
+			  MCDI_DWORD(outbuf, INIT_EVQ_V2_OUT_FLAGS));
+
+	return rc;
+}
+
+void efx_mcdi_ev_remove(struct efx_channel *channel)
+{
+	efx_nic_free_buffer(channel->efx, &channel->eventq.buf);
+}
+
+void efx_mcdi_ev_fini(struct efx_channel *channel)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_EVQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efx_nic *efx = channel->efx;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, FINI_EVQ_IN_INSTANCE, channel->channel);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_EVQ, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
+
+	if (rc && rc != -EALREADY)
+		goto fail;
+
+	return;
+
+fail:
+	efx_mcdi_display_error(efx, MC_CMD_FINI_EVQ, MC_CMD_FINI_EVQ_IN_LEN,
+			       outbuf, outlen, rc);
+}
-- 
2.20.1


