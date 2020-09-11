Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC2D267603
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIKWju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:39:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42162 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgIKWjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:39:49 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 48948600BB;
        Fri, 11 Sep 2020 22:39:49 +0000 (UTC)
Received: from us4-mdac16-10.ut7.mdlocal (unknown [10.7.65.180])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4711F2009A;
        Fri, 11 Sep 2020 22:39:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD9941C0057;
        Fri, 11 Sep 2020 22:39:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 83638600061;
        Fri, 11 Sep 2020 22:39:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 23:39:43 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 4/7] sfc: select inner-csum-offload TX queues for
 skbs that need it
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Message-ID: <c2d81300-f18f-19f6-487a-e3bdb1b3f379@solarflare.com>
Date:   Fri, 11 Sep 2020 23:39:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-9.815300-8.000000-10
X-TMASE-MatchedRID: rbzO2egx+l3U1EMggm+xDqiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5qxpjy1K0tDfpaASgYEJ4rc2Hlwa3CYC+SVLkhtDy7dOlVkJxysad/I1Db
        vxsIF6u6RKSoqryx7WKECjH0m76Zjx4Slly3Yaw0WqJ/PBjhtWi9Xl/s/QdUMp694fFjbH3cnui
        +WQ9elLQk3T8rNqp8oHxUUw2kVJz5byxAy8+P9fB23b+lJHvPA4F58RPNYsrGvcOJbZ17mD1tKp
        tFhGFqyOLMHugQK30AAWHUOmhrVwLuz8zGC5XEHRXgK+YLiGCZ9LQinZ4QefL6qvLNjDYTwmTDw
        p0zM3zoqtq5d3cxkNfjNw87GVY3w1f0yGWGA+lL0iZ0X/6nIwCyrNUn7HX3w2BB34zlGoRvAvpL
        E+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.815300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599863989-iqgCoVoX9dZK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Won't actually be exercised until we start advertising the corresponding
 offload features.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c |  3 ++-
 drivers/net/ethernet/sfc/tx.c  |  2 +-
 drivers/net/ethernet/sfc/tx.h  | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index bd99517f06db..2e8c4569f03b 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -43,6 +43,7 @@
 #include "mcdi_pcol.h"
 #include "io.h"
 #include "farch_regs.h"
+#include "tx.h"
 #include "nic.h" /* indirectly includes ptp.h */
 
 /* Maximum number of events expected to make up a PTP event */
@@ -1081,8 +1082,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 /* Transmit a PTP packet via the dedicated hardware timestamped queue. */
 static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 {
-	u8 type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OUTER_CSUM : 0;
 	struct efx_ptp_data *ptp_data = efx->ptp_data;
+	u8 type = efx_tx_csum_type_skb(skb);
 	struct efx_tx_queue *tx_queue;
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index bb3b41f9f9c0..13e960b23de8 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -506,7 +506,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 	EFX_WARN_ON_PARANOID(!netif_device_present(net_dev));
 
 	index = skb_get_queue_mapping(skb);
-	type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OUTER_CSUM : 0;
+	type = efx_tx_csum_type_skb(skb);
 	if (index >= efx->n_tx_channels) {
 		index -= efx->n_tx_channels;
 		type |= EFX_TXQ_TYPE_HIGHPRI;
diff --git a/drivers/net/ethernet/sfc/tx.h b/drivers/net/ethernet/sfc/tx.h
index a3cf06c5570d..f2c4d2f89919 100644
--- a/drivers/net/ethernet/sfc/tx.h
+++ b/drivers/net/ethernet/sfc/tx.h
@@ -18,4 +18,30 @@ unsigned int efx_tx_limit_len(struct efx_tx_queue *tx_queue,
 u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
 				   struct efx_tx_buffer *buffer, size_t len);
 
+/* What TXQ type will satisfy the checksum offloads required for this skb? */
+static inline unsigned int efx_tx_csum_type_skb(struct sk_buff *skb)
+{
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0; /* no checksum offload */
+
+	if (skb->encapsulation &&
+	    skb_checksum_start_offset(skb) == skb_inner_transport_offset(skb)) {
+		/* we only advertise features for IPv4 and IPv6 checksums on
+		 * encapsulated packets, so if the checksum is for the inner
+		 * packet, it must be one of them; no further checking required.
+		 */
+
+		/* Do we also need to offload the outer header checksum? */
+		if (skb_shinfo(skb)->gso_segs > 1 &&
+		    !(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL) &&
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM))
+			return EFX_TXQ_TYPE_OUTER_CSUM | EFX_TXQ_TYPE_INNER_CSUM;
+		return EFX_TXQ_TYPE_INNER_CSUM;
+	}
+
+	/* similarly, we only advertise features for IPv4 and IPv6 checksums,
+	 * so it must be one of them. No need for further checks.
+	 */
+	return EFX_TXQ_TYPE_OUTER_CSUM;
+}
 #endif /* EFX_TX_H */

