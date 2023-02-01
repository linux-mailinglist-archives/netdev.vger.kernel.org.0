Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CBD68614D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjBAIKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjBAIKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:10:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E87A49968
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675238955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47otdz5Ll2HU+O4r9RhOAXMxNeic6f02I4lNwXUv+aM=;
        b=ZepS2y3zkGuX+PHnRSdjPU3ebHb/CCEGHE5CwPn9MhPdGoEBAgjkNG6PjqaWfDlI/VAVuP
        Qp8dhayxZaorPIMXHNO49h9psachO2bItbI+/IbRfs8zPcrUo6t6LZJOKunVFduktMJO1C
        rGaD1OyGn/L9xmb6gOwH8+meImafb4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-pZL5n-tPPRiRZhTE5Hj3JQ-1; Wed, 01 Feb 2023 03:09:12 -0500
X-MC-Unique: pZL5n-tPPRiRZhTE5Hj3JQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 195B2811E6E;
        Wed,  1 Feb 2023 08:09:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52269492B05;
        Wed,  1 Feb 2023 08:09:08 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net-next v2 4/4] sfc: remove expired unicast PTP filters
Date:   Wed,  1 Feb 2023 09:08:49 +0100
Message-Id: <20230201080849.10482-5-ihuguet@redhat.com>
In-Reply-To: <20230201080849.10482-1-ihuguet@redhat.com>
References: <20230131160506.47552-1-ihuguet@redhat.com>
 <20230201080849.10482-1-ihuguet@redhat.com>
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
 drivers/net/ethernet/sfc/ptp.c | 121 +++++++++++++++++++++------------
 1 file changed, 77 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index a3e827cd84a8..dd46ca6c070e 100644
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
@@ -220,6 +223,7 @@ struct efx_ptp_timeset {
  * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
  * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_PORT)
  * @loc_host: IPv4/v6 address of the filter
+ * @expiry: time when the filter expires, in jiffies
  * @handle: Handle ID for the MCDI filters table
  */
 struct efx_ptp_rxfilter {
@@ -227,6 +231,7 @@ struct efx_ptp_rxfilter {
 	__be16 ether_type;
 	__be16 loc_port;
 	__be32 loc_host[4];
+	unsigned long expiry;
 	int handle;
 };
 
@@ -1320,8 +1325,8 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
-static bool efx_ptp_filter_exists(struct list_head *ptp_list,
-				  struct efx_filter_spec *spec)
+static struct efx_ptp_rxfilter *
+efx_ptp_find_filter(struct list_head *ptp_list, struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 
@@ -1329,10 +1334,19 @@ static bool efx_ptp_filter_exists(struct list_head *ptp_list,
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
@@ -1341,10 +1355,7 @@ static void efx_ptp_remove_filters(struct efx_nic *efx,
 	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
 	list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
-		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  rxfilter->handle);
-		list_del(&rxfilter->list);
-		kfree(rxfilter);
+		efx_ptp_remove_one_filter(efx, rxfilter);
 	}
 }
 
@@ -1358,23 +1369,24 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
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
@@ -1382,12 +1394,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
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
 
@@ -1396,9 +1408,9 @@ static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
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
 
@@ -1407,7 +1419,8 @@ static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
 	return efx_ptp_insert_filter(efx, ptp_list, &spec);
 }
 
-static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
+static struct efx_ptp_rxfilter *
+efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 {
 	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
 	struct efx_filter_spec spec;
@@ -1422,7 +1435,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc;
+	struct efx_ptp_rxfilter *rc;
 
 	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
 		return 0;
@@ -1432,12 +1445,12 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
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
@@ -1448,16 +1461,16 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 
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
 
@@ -1465,7 +1478,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 
 fail:
 	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
-	return rc;
+	return PTR_ERR(rc);
 }
 
 static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
@@ -1484,7 +1497,7 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 					 struct sk_buff *skb)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc;
+	struct efx_ptp_rxfilter *rxfilter;
 
 	if (!efx_ptp_valid_unicast_event_pkt(skb))
 		return -EINVAL;
@@ -1492,28 +1505,36 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
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
+		if (IS_ERR(rxfilter))
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
@@ -1522,7 +1543,18 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 
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
@@ -1616,6 +1648,7 @@ static void efx_ptp_worker(struct work_struct *work)
 	}
 
 	efx_ptp_drop_time_expired_events(efx);
+	efx_ptp_drop_expired_unicast_filters(efx);
 
 	__skb_queue_head_init(&tempq);
 	efx_ptp_process_events(efx, &tempq);
-- 
2.34.3

