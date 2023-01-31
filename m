Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC4683236
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjAaQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjAaQG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC994DBF7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675181135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M15miINuBv6FsNuNApYKWaWafj4pvjnY1ZlJNI6mzg4=;
        b=h3kRLZidUaf/jcU43bUJ9eT781YhHZfVCeTYC3/gE60qUMQz2YjysG4KioKH6gfpFtk3kN
        Q/6AyZQfNumGarpPZk2K3p75xaDRX1rRcQQdF9R3bMUwUhyBf7hKztlkvRzE3FG95Ml1yi
        a48W6bSFF7rx1CqpjncqR9h4gFMRjCM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-LNKkWdxtPcmCuMAXXhh66Q-1; Tue, 31 Jan 2023 11:05:28 -0500
X-MC-Unique: LNKkWdxtPcmCuMAXXhh66Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4863B85CAB4;
        Tue, 31 Jan 2023 16:05:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80081492B05;
        Tue, 31 Jan 2023 16:05:23 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net 4/4] sfc: remove expired unicast PTP filters
Date:   Tue, 31 Jan 2023 17:05:06 +0100
Message-Id: <20230131160506.47552-5-ihuguet@redhat.com>
In-Reply-To: <20230131160506.47552-1-ihuguet@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Filters inserted to support unicast PTP mode might become unused after
some time, so we need to remove them to avoid accumulating many of them.

Actually, it would be a very unusual situation that many different
addresses are used, normally only a small set of predefined
addresses are tried. Anyway, some cleanup is necessary because
maintaining old filters forever makes very little sense.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 120 +++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index f9342e21bf31..fd37a61058e7 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -75,6 +75,9 @@
 /* How long an unmatched event or packet can be held */
 #define PKT_EVENT_LIFETIME_MS		10
 
+/* How long unused unicast filters can be held */
+#define UCAST_FILTER_EXPIRY_JIFFIES	msecs_to_jiffies(30000)
+
 /* Offsets into PTP packet for identification.  These offsets are from the
  * start of the IP header, not the MAC header.  Note that neither PTP V1 nor
  * PTP V2 permit the use of IPV4 options.
@@ -226,6 +229,7 @@ struct efx_ptp_rxfilter {
 	__be16 ether_type;
 	__be16 loc_port;
 	__be32 loc_host[4];
+	unsigned long expiry;
 	int handle;
 };
 
@@ -1319,8 +1323,8 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
-static bool efx_ptp_filter_exists(struct list_head *ptp_list,
-				  struct efx_filter_spec *spec)
+static struct efx_ptp_rxfilter *
+efx_ptp_find_filter(struct list_head *ptp_list, struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 
@@ -1328,10 +1332,19 @@ static bool efx_ptp_filter_exists(struct list_head *ptp_list,
 		if (rxfilter->ether_type == spec->ether_type &&
 		    rxfilter->loc_port == spec->loc_port &&
 		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
-			return true;
+			return rxfilter;
 	}
 
-	return false;
+	return NULL;
+}
+
+static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
+					     struct efx_ptp_rxfilter *rxfilter)
+{
+	efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
+				  rxfilter->handle);
+	list_del(&rxfilter->list);
+	kfree(rxfilter);
 }
 
 static void efx_ptp_remove_filters(struct efx_nic *efx,
@@ -1340,10 +1353,7 @@ static void efx_ptp_remove_filters(struct efx_nic *efx,
 	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
 	list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
-		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  rxfilter->handle);
-		list_del(&rxfilter->list);
-		kfree(rxfilter);
+		efx_ptp_remove_one_filter(efx, rxfilter);
 	}
 }
 
@@ -1357,23 +1367,24 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 			   efx_rx_queue_index(queue));
 }
 
-static int efx_ptp_insert_filter(struct efx_nic *efx,
-				 struct list_head *ptp_list,
-				 struct efx_filter_spec *spec)
+static struct efx_ptp_rxfilter *
+efx_ptp_insert_filter(struct efx_nic *efx, struct list_head *ptp_list,
+		      struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 	int rc;
 
-	if (efx_ptp_filter_exists(ptp_list, spec))
-		return 0;
+	rxfilter = efx_ptp_find_filter(ptp_list, spec);
+	if (rxfilter)
+		return rxfilter;
 
 	rc = efx_filter_insert_filter(efx, spec, true);
 	if (rc < 0)
-		return rc;
+		return ERR_PTR(rc);
 
 	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
 	if (!rxfilter)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	rxfilter->handle = rc;
 	rxfilter->ether_type = spec->ether_type;
@@ -1381,12 +1392,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
 	list_add(&rxfilter->list, ptp_list);
 
-	return 0;
+	return rxfilter;
 }
 
-static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
-				      struct list_head *ptp_list,
-				      __be32 addr, u16 port)
+static struct efx_ptp_rxfilter *
+efx_ptp_insert_ipv4_filter(struct efx_nic *efx, struct list_head *ptp_list,
+			   __be32 addr, u16 port)
 {
 	struct efx_filter_spec spec;
 
@@ -1395,9 +1406,9 @@ static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
 	return efx_ptp_insert_filter(efx, ptp_list, &spec);
 }
 
-static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
-				      struct list_head *ptp_list,
-				      struct in6_addr *addr, u16 port)
+static struct efx_ptp_rxfilter *
+efx_ptp_insert_ipv6_filter(struct efx_nic *efx, struct list_head *ptp_list,
+			   struct in6_addr *addr, u16 port)
 {
 	struct efx_filter_spec spec;
 
@@ -1406,7 +1417,8 @@ static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
 	return efx_ptp_insert_filter(efx, ptp_list, &spec);
 }
 
-static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
+static struct efx_ptp_rxfilter *
+efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 {
 	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
 	struct efx_filter_spec spec;
@@ -1421,7 +1433,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc;
+	struct efx_ptp_rxfilter *rc;
 
 	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
 		return 0;
@@ -1431,12 +1443,12 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	 */
 	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
 					htonl(PTP_ADDR_IPV4), PTP_EVENT_PORT);
-	if (rc < 0)
+	if (IS_ERR(rc))
 		goto fail;
 
 	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
 					htonl(PTP_ADDR_IPV4), PTP_GENERAL_PORT);
-	if (rc < 0)
+	if (IS_ERR(rc))
 		goto fail;
 
 	/* if the NIC supports hw timestamps by the MAC, we can support
@@ -1447,16 +1459,16 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
 						&ipv6_addr, PTP_EVENT_PORT);
-		if (rc < 0)
+		if (IS_ERR(rc))
 			goto fail;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
 						&ipv6_addr, PTP_GENERAL_PORT);
-		if (rc < 0)
+		if (IS_ERR(rc))
 			goto fail;
 
 		rc = efx_ptp_insert_eth_multicast_filter(efx);
-		if (rc < 0)
+		if (IS_ERR(rc))
 			goto fail;
 	}
 
@@ -1464,7 +1476,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 
 fail:
 	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
-	return rc;
+	return PTR_ERR(rc);
 }
 
 static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
@@ -1483,7 +1495,7 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 					 struct sk_buff *skb)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc;
+	struct efx_ptp_rxfilter *rxfilter;
 
 	if (!efx_ptp_valid_unicast_event_pkt(skb))
 		return -EINVAL;
@@ -1491,28 +1503,36 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 	if (skb->protocol == htons(ETH_P_IP)) {
 		__be32 addr = ip_hdr(skb)->saddr;
 
-		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_EVENT_PORT);
-		if (rc < 0)
+		rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
+						      addr, PTP_EVENT_PORT);
+		if (IS_ERR(rxfilter))
 			goto fail;
 
-		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
-		if (rc < 0)
+		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
+
+		rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
+						      addr, PTP_GENERAL_PORT);
+		if (rxfilter < 0)
 			goto fail;
+
+		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
 	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
 		/* IPv6 PTP only supported by devices with MAC hw timestamp */
 		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
 
-		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_EVENT_PORT);
-		if (rc < 0)
+		rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						      addr, PTP_EVENT_PORT);
+		if (IS_ERR(rxfilter))
 			goto fail;
 
-		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
-		if (rc < 0)
+		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
+
+		rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						      addr, PTP_GENERAL_PORT);
+		if (IS_ERR(rxfilter))
 			goto fail;
+
+		rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -1521,7 +1541,18 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 
 fail:
 	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
-	return rc;
+	return PTR_ERR(rxfilter);
+}
+
+static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
+{
+	struct efx_ptp_data *ptp = efx->ptp_data;
+	struct efx_ptp_rxfilter *rxfilter, *tmp;
+
+	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
+		if (time_is_before_jiffies(rxfilter->expiry))
+			efx_ptp_remove_one_filter(efx, rxfilter);
+	}
 }
 
 static int efx_ptp_start(struct efx_nic *efx)
@@ -1615,6 +1646,7 @@ static void efx_ptp_worker(struct work_struct *work)
 	}
 
 	efx_ptp_drop_time_expired_events(efx);
+	efx_ptp_drop_expired_unicast_filters(efx);
 
 	__skb_queue_head_init(&tempq);
 	efx_ptp_process_events(efx, &tempq);
-- 
2.34.3

