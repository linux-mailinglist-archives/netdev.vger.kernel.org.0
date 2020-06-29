Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0515520D81F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgF2TgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:36:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45134 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730017AbgF2TgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:36:18 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 15727ABBF4
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:39:42 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 07B4A6005E;
        Mon, 29 Jun 2020 13:39:42 +0000 (UTC)
Received: from us4-mdac16-23.ut7.mdlocal (unknown [10.7.65.247])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0715A8009E;
        Mon, 29 Jun 2020 13:39:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8CEC6280079;
        Mon, 29 Jun 2020 13:39:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3164AB40064;
        Mon, 29 Jun 2020 13:39:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:39:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 13/15] sfc: commonise drain event handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <a2dd4668-298d-3ffd-46d7-8919817e5c4f@solarflare.com>
Date:   Mon, 29 Jun 2020 14:39:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-3.472600-8.000000-10
X-TMASE-MatchedRID: dZQo7Y/1fG2/JxRBHWTApqiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3MtEYJsLZsWT8FqifzwY4bVqVLkhtDy7dOl7OLL/a8shjXmr
        nY1Xus+1xwgUwEs72kereuMOwkhlxkXoWBThuuCgJ6xTeI+I0LORjXRoZjRDh0SxMhOhuA0QnOW
        hZYy8qHYgR+HqWoAp/k9oRcfKmGoV2biRssqT/bp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtY+LAcPqdSWdDChHnET8uyIi0fj5E2iQGERdrinXPBmQ4OS2J2bnCw4eqFa76aLeNDyQe
        yOuWd4TcRJSz8/P4b5k7+a/ecdHFl01pcF5ZcQp85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.472600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437982-ieRcBevhx5gg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoids a call from generic MCDI code into ef10.c.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c |  8 --------
 drivers/net/ethernet/sfc/mcdi.c | 10 +++++++++-
 drivers/net/ethernet/sfc/nic.h  |  1 -
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 3bdb8606512a..efc49869320f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3117,14 +3117,6 @@ static void efx_ef10_ev_test_generate(struct efx_channel *channel)
 	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
 }
 
-void efx_ef10_handle_drain_event(struct efx_nic *efx)
-{
-	if (atomic_dec_and_test(&efx->active_queues))
-		wake_up(&efx->flush_wq);
-
-	WARN_ON(atomic_read(&efx->active_queues) < 0);
-}
-
 static int efx_ef10_fini_dmaq(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index a8cc3881edce..244fb621d17b 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1299,6 +1299,14 @@ static void efx_mcdi_abandon(struct efx_nic *efx)
 	efx_schedule_reset(efx, RESET_TYPE_MCDI_TIMEOUT);
 }
 
+static void efx_handle_drain_event(struct efx_nic *efx)
+{
+	if (atomic_dec_and_test(&efx->active_queues))
+		wake_up(&efx->flush_wq);
+
+	WARN_ON(atomic_read(&efx->active_queues) < 0);
+}
+
 /* Called from efx_farch_ev_process and efx_ef10_ev_process for MCDI events */
 void efx_mcdi_process_event(struct efx_channel *channel,
 			    efx_qword_t *event)
@@ -1371,7 +1379,7 @@ void efx_mcdi_process_event(struct efx_channel *channel,
 		BUILD_BUG_ON(MCDI_EVENT_TX_FLUSH_TO_DRIVER_LBN !=
 			     MCDI_EVENT_RX_FLUSH_TO_DRIVER_LBN);
 		if (!MCDI_EVENT_FIELD(*event, TX_FLUSH_TO_DRIVER))
-			efx_ef10_handle_drain_event(efx);
+			efx_handle_drain_event(efx);
 		break;
 	case MCDI_EVENT_CODE_TX_ERR:
 	case MCDI_EVENT_CODE_RX_ERR:
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 135c43146c13..c24dc55532c2 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -376,7 +376,6 @@ void falcon_stop_nic_stats(struct efx_nic *efx);
 int falcon_reset_xaui(struct efx_nic *efx);
 void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw);
 void efx_farch_init_common(struct efx_nic *efx);
-void efx_ef10_handle_drain_event(struct efx_nic *efx);
 void efx_farch_rx_push_indir_table(struct efx_nic *efx);
 void efx_farch_rx_pull_indir_table(struct efx_nic *efx);
 

