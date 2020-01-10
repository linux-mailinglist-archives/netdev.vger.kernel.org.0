Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FA8136E06
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgAJN2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:28:00 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56388 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbgAJN2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:28:00 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB01ABC0067;
        Fri, 10 Jan 2020 13:27:58 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:27:53 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 6/9] sfc: move a couple more functions
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <f8e0f900-145e-61bb-394b-f4ca03a58a99@solarflare.com>
Date:   Fri, 10 Jan 2020 13:27:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-10.314900-8.000000-10
X-TMASE-MatchedRID: LLuk46qspz+h9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGb6
        PphVtfZgOKjcIhHUkSbadfjfbzW18jiULkq/3BRuydRP56yRRA+6s6UL48vRAMc322cceBeEFIh
        31JkvrpYc0CnxKIsj0jeVZt+wt7S/pljg/F9ExYSiAZ3zAhQYgkpFpc3bJiMeG64y8JtpBrbNYm
        nwJ/qUK7A8VWmoWpna4H1Edaf3xkFGH77qCcquWBYZoKAPfQ6CZAGtCJE23YhahAEL9o+TWz7r0
        3R6I3FBkIHWX4I/7rFFlrniINYkWf1opoHDJD6EngIgpj8eDcC063Wh9WVqgt063cjuGtrt+gtH
        j7OwNO3DW0xVTs41PFkBl4x9vxHFpXc6ejAWwJ+aml7eV7x1br2cMkScTzOS
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.314900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662879-I5ViawYPR5-V
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c        | 33 --------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 34 +++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_port_common.h |  1 +
 drivers/net/ethernet/sfc/tx.c               | 18 -----------
 drivers/net/ethernet/sfc/tx_common.c        | 18 +++++++++++
 drivers/net/ethernet/sfc/tx_common.h        |  3 ++
 6 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index a5785205c32b..ab5227b13ae6 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -675,39 +675,6 @@ u32 efx_mcdi_phy_get_caps(struct efx_nic *efx)
 	return phy_data->supported_cap;
 }
 
-static unsigned int efx_mcdi_event_link_speed[] = {
-	[MCDI_EVENT_LINKCHANGE_SPEED_100M] = 100,
-	[MCDI_EVENT_LINKCHANGE_SPEED_1G] = 1000,
-	[MCDI_EVENT_LINKCHANGE_SPEED_10G] = 10000,
-	[MCDI_EVENT_LINKCHANGE_SPEED_40G] = 40000,
-	[MCDI_EVENT_LINKCHANGE_SPEED_25G] = 25000,
-	[MCDI_EVENT_LINKCHANGE_SPEED_50G] = 50000,
-	[MCDI_EVENT_LINKCHANGE_SPEED_100G] = 100000,
-};
-
-void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
-{
-	u32 flags, fcntl, speed, lpa;
-
-	speed = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_SPEED);
-	EFX_WARN_ON_PARANOID(speed >= ARRAY_SIZE(efx_mcdi_event_link_speed));
-	speed = efx_mcdi_event_link_speed[speed];
-
-	flags = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_LINK_FLAGS);
-	fcntl = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_FCNTL);
-	lpa = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_LP_CAP);
-
-	/* efx->link_state is only modified by efx_mcdi_phy_get_link(),
-	 * which is only run after flushing the event queues. Therefore, it
-	 * is safe to modify the link state outside of the mac_lock here.
-	 */
-	efx_mcdi_phy_decode_link(efx, &efx->link_state, speed, flags, fcntl);
-
-	efx_mcdi_phy_check_fcntl(efx, lpa);
-
-	efx_link_status_changed(efx);
-}
-
 bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 0f3237fc68af..a6a072ba46d3 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -9,6 +9,7 @@
  */
 
 #include "mcdi_port_common.h"
+#include "efx_common.h"
 
 int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 {
@@ -532,3 +533,36 @@ int efx_mcdi_port_get_number(struct efx_nic *efx)
 
 	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
 }
+
+static unsigned int efx_mcdi_event_link_speed[] = {
+	[MCDI_EVENT_LINKCHANGE_SPEED_100M] = 100,
+	[MCDI_EVENT_LINKCHANGE_SPEED_1G] = 1000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_10G] = 10000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_40G] = 40000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_25G] = 25000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_50G] = 50000,
+	[MCDI_EVENT_LINKCHANGE_SPEED_100G] = 100000,
+};
+
+void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
+{
+	u32 flags, fcntl, speed, lpa;
+
+	speed = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_SPEED);
+	EFX_WARN_ON_PARANOID(speed >= ARRAY_SIZE(efx_mcdi_event_link_speed));
+	speed = efx_mcdi_event_link_speed[speed];
+
+	flags = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_LINK_FLAGS);
+	fcntl = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_FCNTL);
+	lpa = EFX_QWORD_FIELD(*ev, MCDI_EVENT_LINKCHANGE_LP_CAP);
+
+	/* efx->link_state is only modified by efx_mcdi_phy_get_link(),
+	 * which is only run after flushing the event queues. Therefore, it
+	 * is safe to modify the link state outside of the mac_lock here.
+	 */
+	efx_mcdi_phy_decode_link(efx, &efx->link_state, speed, flags, fcntl);
+
+	efx_mcdi_phy_check_fcntl(efx, lpa);
+
+	efx_link_status_changed(efx);
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index 6b08a2b7eddf..b16f11265269 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -52,5 +52,6 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
 int efx_mcdi_set_mac(struct efx_nic *efx);
 int efx_mcdi_port_get_number(struct efx_nic *efx);
+void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index bb666cba3ea0..3b3a29ce749d 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -268,24 +268,6 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
-/* Remove buffers put into a tx_queue for the current packet.
- * None of the buffers must have an skb attached.
- */
-static void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
-			       unsigned int insert_count)
-{
-	struct efx_tx_buffer *buffer;
-	unsigned int bytes_compl = 0;
-	unsigned int pkts_compl = 0;
-
-	/* Work backwards until we hit the original insert pointer value */
-	while (tx_queue->insert_count != insert_count) {
-		--tx_queue->insert_count;
-		buffer = __efx_tx_queue_get_insert_buffer(tx_queue);
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
-	}
-}
-
 /*
  * Fallback to software TSO.
  *
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 0ce699ecae5a..b1571e9789d0 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -267,6 +267,24 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 	}
 }
 
+/* Remove buffers put into a tx_queue for the current packet.
+ * None of the buffers must have an skb attached.
+ */
+void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
+			unsigned int insert_count)
+{
+	struct efx_tx_buffer *buffer;
+	unsigned int bytes_compl = 0;
+	unsigned int pkts_compl = 0;
+
+	/* Work backwards until we hit the original insert pointer value */
+	while (tx_queue->insert_count != insert_count) {
+		--tx_queue->insert_count;
+		buffer = __efx_tx_queue_get_insert_buffer(tx_queue);
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+	}
+}
+
 struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 				       dma_addr_t dma_addr, size_t len)
 {
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index 58add94ab500..f92f1fe3a87f 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -23,6 +23,9 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 
+void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
+			unsigned int insert_count);
+
 struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 				       dma_addr_t dma_addr, size_t len);
 int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-- 
2.20.1


