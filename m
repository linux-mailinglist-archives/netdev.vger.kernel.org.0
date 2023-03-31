Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7336D6D1ED4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCaLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjCaLPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:15:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBB9014
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680261275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rntwKt7pHia2LoN8Fq5XmoSbaAuHcKiDb197ZWHd7ws=;
        b=MXD0L/j92YilcdTFH03yhfgkQLE777RoQHamgEsza+xqexf4lsK1gjHcX+BpL0556T582b
        vN59rNBmgpmGejlUraqRKyOiBl66/2IkTJ9qE9SNvwT0c4eikMOaxTjnV1Q6Oovc88vOOs
        5EqmPCdKYYeF1NGtkxt7+zgOLE0fdJs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330--5F1c4I7PyuUWSO43PG2hg-1; Fri, 31 Mar 2023 07:14:32 -0400
X-MC-Unique: -5F1c4I7PyuUWSO43PG2hg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBAD2101A54F;
        Fri, 31 Mar 2023 11:14:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3492740B3ED9;
        Fri, 31 Mar 2023 11:14:30 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH v6 net-next 4/4] sfc: remove expired unicast PTP filters
Date:   Fri, 31 Mar 2023 13:14:04 +0200
Message-Id: <20230331111404.17256-5-ihuguet@redhat.com>
In-Reply-To: <20230331111404.17256-1-ihuguet@redhat.com>
References: <20230331111404.17256-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Filters inserted to support unicast PTP mode might become unused after
some time, so we need to remove them to avoid accumulating many of them.

Refresh the expiration time of a filter each time it's used. Then check
periodically if any filter hasn't been used for a long time (30s) and
remove it.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 97 +++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index b495f3d0616b..0c40571133cb 100644
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
@@ -218,6 +221,7 @@ struct efx_ptp_timeset {
  * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
  * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_PORT)
  * @loc_host: IPv4/v6 address of the filter
+ * @expiry: time when the filter expires, in jiffies
  * @handle: Handle ID for the MCDI filters table
  */
 struct efx_ptp_rxfilter {
@@ -225,6 +229,7 @@ struct efx_ptp_rxfilter {
 	__be16 ether_type;
 	__be16 loc_port;
 	__be32 loc_host[4];
+	unsigned long expiry;
 	int handle;
 };
 
@@ -242,6 +247,7 @@ struct efx_ptp_rxfilter {
  * @rx_evts: Instantiated events (on evt_list and evt_free_list)
  * @workwq: Work queue for processing pending PTP operations
  * @work: Work task
+ * @cleanup_work: Work task for periodic cleanup
  * @reset_required: A serious error has occurred and the PTP task needs to be
  *                  reset (disable, enable).
  * @rxfilters_mcast: Receive filters for multicast PTP packets
@@ -313,6 +319,7 @@ struct efx_ptp_data {
 	struct efx_ptp_event_rx rx_evts[MAX_RECEIVE_EVENTS];
 	struct workqueue_struct *workwq;
 	struct work_struct work;
+	struct delayed_work cleanup_work;
 	bool reset_required;
 	struct list_head rxfilters_mcast;
 	struct list_head rxfilters_ucast;
@@ -1318,8 +1325,8 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
-static bool efx_ptp_filter_exists(struct list_head *filter_list,
-				  struct efx_filter_spec *spec)
+static struct efx_ptp_rxfilter *
+efx_ptp_find_filter(struct list_head *filter_list, struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 
@@ -1327,10 +1334,19 @@ static bool efx_ptp_filter_exists(struct list_head *filter_list,
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
+static void efx_ptp_remove_one_filter(struct efx_nic *efx,
+				      struct efx_ptp_rxfilter *rxfilter)
+{
+	efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
+				  rxfilter->handle);
+	list_del(&rxfilter->list);
+	kfree(rxfilter);
 }
 
 static void efx_ptp_remove_filters(struct efx_nic *efx,
@@ -1338,12 +1354,8 @@ static void efx_ptp_remove_filters(struct efx_nic *efx,
 {
 	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
-	list_for_each_entry_safe(rxfilter, tmp, filter_list, list) {
-		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  rxfilter->handle);
-		list_del(&rxfilter->list);
-		kfree(rxfilter);
-	}
+	list_for_each_entry_safe(rxfilter, tmp, filter_list, list)
+		efx_ptp_remove_one_filter(efx, rxfilter);
 }
 
 static void efx_ptp_init_filter(struct efx_nic *efx,
@@ -1358,13 +1370,18 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 
 static int efx_ptp_insert_filter(struct efx_nic *efx,
 				 struct list_head *filter_list,
-				 struct efx_filter_spec *spec)
+				 struct efx_filter_spec *spec,
+				 unsigned long expiry)
 {
+	struct efx_ptp_data *ptp = efx->ptp_data;
 	struct efx_ptp_rxfilter *rxfilter;
 	int rc;
 
-	if (efx_ptp_filter_exists(filter_list, spec))
+	rxfilter = efx_ptp_find_filter(filter_list, spec);
+	if (rxfilter) {
+		rxfilter->expiry = expiry;
 		return 0;
+	}
 
 	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
 	if (!rxfilter)
@@ -1378,8 +1395,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 	rxfilter->ether_type = spec->ether_type;
 	rxfilter->loc_port = spec->loc_port;
 	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
+	rxfilter->expiry = expiry;
 	list_add(&rxfilter->list, filter_list);
 
+	queue_delayed_work(ptp->workwq, &ptp->cleanup_work,
+			   UCAST_FILTER_EXPIRY_JIFFIES + 1);
+
 	return 0;
 
 fail:
@@ -1389,24 +1410,26 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 
 static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
 				      struct list_head *filter_list,
-				      __be32 addr, u16 port)
+				      __be32 addr, u16 port,
+				      unsigned long expiry)
 {
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
 	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, addr, htons(port));
-	return efx_ptp_insert_filter(efx, filter_list, &spec);
+	return efx_ptp_insert_filter(efx, filter_list, &spec, expiry);
 }
 
 static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
 				      struct list_head *filter_list,
-				      struct in6_addr *addr, u16 port)
+				      struct in6_addr *addr, u16 port,
+				      unsigned long expiry)
 {
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
 	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, addr, htons(port));
-	return efx_ptp_insert_filter(efx, filter_list, &spec);
+	return efx_ptp_insert_filter(efx, filter_list, &spec, expiry);
 }
 
 static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
@@ -1419,7 +1442,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
 	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
 	spec.ether_type = htons(ETH_P_1588);
-	return efx_ptp_insert_filter(efx, &ptp->rxfilters_mcast, &spec);
+	return efx_ptp_insert_filter(efx, &ptp->rxfilters_mcast, &spec, 0);
 }
 
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
@@ -1434,12 +1457,14 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	 * that there is no packet re-ordering.
 	 */
 	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
-					htonl(PTP_ADDR_IPV4), PTP_EVENT_PORT);
+					htonl(PTP_ADDR_IPV4), PTP_EVENT_PORT,
+					0);
 	if (rc < 0)
 		goto fail;
 
 	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
-					htonl(PTP_ADDR_IPV4), PTP_GENERAL_PORT);
+					htonl(PTP_ADDR_IPV4), PTP_GENERAL_PORT,
+					0);
 	if (rc < 0)
 		goto fail;
 
@@ -1450,12 +1475,12 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 		struct in6_addr ipv6_addr = {{PTP_ADDR_IPV6}};
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
-						&ipv6_addr, PTP_EVENT_PORT);
+						&ipv6_addr, PTP_EVENT_PORT, 0);
 		if (rc < 0)
 			goto fail;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
-						&ipv6_addr, PTP_GENERAL_PORT);
+						&ipv6_addr, PTP_GENERAL_PORT, 0);
 		if (rc < 0)
 			goto fail;
 
@@ -1491,32 +1516,35 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 					 struct sk_buff *skb)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
+	unsigned long expiry;
 	int rc;
 
 	if (!efx_ptp_valid_unicast_event_pkt(skb))
 		return -EINVAL;
 
+	expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
+
 	if (skb->protocol == htons(ETH_P_IP)) {
 		__be32 addr = ip_hdr(skb)->saddr;
 
 		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_EVENT_PORT);
+						addr, PTP_EVENT_PORT, expiry);
 		if (rc < 0)
 			goto out;
 
 		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
+						addr, PTP_GENERAL_PORT, expiry);
 	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
 		/* IPv6 PTP only supported by devices with MAC hw timestamp */
 		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_EVENT_PORT);
+						addr, PTP_EVENT_PORT, expiry);
 		if (rc < 0)
 			goto out;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
+						addr, PTP_GENERAL_PORT, expiry);
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -1627,6 +1655,23 @@ static void efx_ptp_worker(struct work_struct *work)
 		efx_ptp_process_rx(efx, skb);
 }
 
+static void efx_ptp_cleanup_worker(struct work_struct *work)
+{
+	struct efx_ptp_data *ptp =
+		container_of(work, struct efx_ptp_data, cleanup_work.work);
+	struct efx_ptp_rxfilter *rxfilter, *tmp;
+
+	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
+		if (time_is_before_jiffies(rxfilter->expiry))
+			efx_ptp_remove_one_filter(ptp->efx, rxfilter);
+	}
+
+	if (!list_empty(&ptp->rxfilters_ucast)) {
+		queue_delayed_work(ptp->workwq, &ptp->cleanup_work,
+				   UCAST_FILTER_EXPIRY_JIFFIES + 1);
+	}
+}
+
 static const struct ptp_clock_info efx_phc_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "sfc",
@@ -1685,6 +1730,7 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	}
 
 	INIT_WORK(&ptp->work, efx_ptp_worker);
+	INIT_DELAYED_WORK(&ptp->cleanup_work, efx_ptp_cleanup_worker);
 	ptp->config.flags = 0;
 	ptp->config.tx_type = HWTSTAMP_TX_OFF;
 	ptp->config.rx_filter = HWTSTAMP_FILTER_NONE;
@@ -1776,6 +1822,7 @@ void efx_ptp_remove(struct efx_nic *efx)
 	(void)efx_ptp_disable(efx);
 
 	cancel_work_sync(&efx->ptp_data->work);
+	cancel_delayed_work_sync(&efx->ptp_data->cleanup_work);
 	if (efx->ptp_data->pps_workwq)
 		cancel_work_sync(&efx->ptp_data->pps_work);
 
-- 
2.39.2

