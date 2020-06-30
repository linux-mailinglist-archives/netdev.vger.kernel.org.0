Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0195D20F436
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgF3MM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:12:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56870 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387472AbgF3MM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:12:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D2F07200AC;
        Tue, 30 Jun 2020 12:12:25 +0000 (UTC)
Received: from us4-mdac16-50.at1.mdlocal (unknown [10.110.50.133])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D10136009B;
        Tue, 30 Jun 2020 12:12:25 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 705DD220078;
        Tue, 30 Jun 2020 12:12:25 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 35DF228007B;
        Tue, 30 Jun 2020 12:12:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:12:20 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 07/14] sfc: commonise TSO fallback code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <2a94b533-79de-646a-8038-5d2ddd22816d@solarflare.com>
Date:   Tue, 30 Jun 2020 13:12:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-6.922600-8.000000-10
X-TMASE-MatchedRID: qQUFOL0tEEFJhDcRXZUUxqiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3MjmzjEr3tKb/k3rl+MaNgxDUIkoTEP0J+UkrZ4mFjTbDS1J
        WS+txB/9gQfB04A8o2U+A1TkNxPExROB90vNXRhrykdOisNw8yrfHCp+e+coekaEC8FJraL9vAl
        nua0Nm7c5dU83Z+Lu0kZOl7WKIImrvXOvQVlExsAtuKBGekqUpI/NGWt0UYPAUCKGKnUyAIpvk2
        F+OwpbyhfORTzTn8nVRMZmpY155jmioXxLS6UzT
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.922600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519145-7q7DNRRhQIVu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ef100 will need this if it gets GSO skbs it can't handle (e.g. too long
 header length).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/tx.c        | 28 ----------------------------
 drivers/net/ethernet/sfc/tx_common.c | 27 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tx_common.h |  2 +-
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 19b58563cb78..ed20f6aef435 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -268,34 +268,6 @@ static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
 }
 #endif /* EFX_USE_PIO */
 
-/*
- * Fallback to software TSO.
- *
- * This is used if we are unable to send a GSO packet through hardware TSO.
- * This should only ever happen due to per-queue restrictions - unsupported
- * packets should first be filtered by the feature flags.
- *
- * Returns 0 on success, error code otherwise.
- */
-static int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue,
-			       struct sk_buff *skb)
-{
-	struct sk_buff *segments, *next;
-
-	segments = skb_gso_segment(skb, 0);
-	if (IS_ERR(segments))
-		return PTR_ERR(segments);
-
-	dev_consume_skb_any(skb);
-
-	skb_list_walk_safe(segments, skb, next) {
-		skb_mark_not_on_list(skb);
-		efx_enqueue_skb(tx_queue, skb);
-	}
-
-	return 0;
-}
-
 /*
  * Add a socket buffer to a TX queue
  *
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 70876df1da69..9a005e7c2c68 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -405,3 +405,30 @@ unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
 
 	return max_descs;
 }
+
+/*
+ * Fallback to software TSO.
+ *
+ * This is used if we are unable to send a GSO packet through hardware TSO.
+ * This should only ever happen due to per-queue restrictions - unsupported
+ * packets should first be filtered by the feature flags.
+ *
+ * Returns 0 on success, error code otherwise.
+ */
+int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+{
+	struct sk_buff *segments, *next;
+
+	segments = skb_gso_segment(skb, 0);
+	if (IS_ERR(segments))
+		return PTR_ERR(segments);
+
+	dev_consume_skb_any(skb);
+
+	skb_list_walk_safe(segments, skb, next) {
+		skb_mark_not_on_list(skb);
+		efx_enqueue_skb(tx_queue, skb);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index 99cf7ce2f36c..82e2e291317d 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -38,5 +38,5 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		    unsigned int segment_count);
 
 unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
-
+int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 #endif

