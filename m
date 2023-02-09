Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF2690580
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBIKqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBIKpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:45:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4FF3928B
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675939453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkQ6bxuxgMPBOnOgZTCmHrQjDRM6SYpl7bdTQBwt0e8=;
        b=UkaTZtFrbD4LuqF1gboWnQcwo2VAemt+eJvrMVyb0CSY5M/ZuaMkCF+PE+0gkE/bv1R1xK
        pke3t2W1wPvAmjYv1OS5roBAWsJngjE9hwvwdG1jfS9tLKOI6B6BED6yBQk7qcLpMgejwF
        0N8OqPhyN7KVgBXTfIChJlNVjunJbsg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-ximx4SkWOAOrB1I-mMZz1w-1; Thu, 09 Feb 2023 05:44:12 -0500
X-MC-Unique: ximx4SkWOAOrB1I-mMZz1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6382101A521;
        Thu,  9 Feb 2023 10:44:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AD82403D0D2;
        Thu,  9 Feb 2023 10:44:09 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net-next v3 4/4] sfc: remove expired unicast PTP filters
Date:   Thu,  9 Feb 2023 11:43:49 +0100
Message-Id: <20230209104349.15830-5-ihuguet@redhat.com>
In-Reply-To: <20230209104349.15830-1-ihuguet@redhat.com>
References: <20230209104349.15830-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 drivers/net/ethernet/sfc/ptp.c | 83 ++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 5b6ee3d23a64..b93e7220e207 100644
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
 
@@ -1318,8 +1323,8 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
-static bool efx_ptp_filter_exists(struct list_head *ptp_list,
-				  struct efx_filter_spec *spec)
+static struct efx_ptp_rxfilter *
+efx_ptp_find_filter(struct list_head *ptp_list, struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 
@@ -1327,10 +1332,19 @@ static bool efx_ptp_filter_exists(struct list_head *ptp_list,
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
@@ -1339,10 +1353,7 @@ static void efx_ptp_remove_filters(struct efx_nic *efx,
 	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
 	list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
-		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  rxfilter->handle);
-		list_del(&rxfilter->list);
-		kfree(rxfilter);
+		efx_ptp_remove_one_filter(efx, rxfilter);
 	}
 }
 
@@ -1358,13 +1369,17 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 
 static int efx_ptp_insert_filter(struct efx_nic *efx,
 				 struct list_head *ptp_list,
-				 struct efx_filter_spec *spec)
+				 struct efx_filter_spec *spec,
+				 unsigned long expiry)
 {
 	struct efx_ptp_rxfilter *rxfilter;
 	int rc;
 
-	if (efx_ptp_filter_exists(ptp_list, spec))
+	rxfilter = efx_ptp_find_filter(ptp_list, spec);
+	if (rxfilter) {
+		rxfilter->expiry = expiry;
 		return 0;
+	}
 
 	rc = efx_filter_insert_filter(efx, spec, true);
 	if (rc < 0)
@@ -1378,6 +1393,7 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 	rxfilter->ether_type = spec->ether_type;
 	rxfilter->loc_port = spec->loc_port;
 	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
+	rxfilter->expiry = expiry;
 	list_add(&rxfilter->list, ptp_list);
 
 	return 0;
@@ -1385,28 +1401,31 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 
 static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
 				      struct list_head *ptp_list,
-				      __be32 addr, u16 port)
+				      __be32 addr, u16 port,
+				      unsigned long expiry)
 {
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
 	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, addr, htons(port));
-	return efx_ptp_insert_filter(efx, ptp_list, &spec);
+	return efx_ptp_insert_filter(efx, ptp_list, &spec, expiry);
 }
 
 static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
 				      struct list_head *ptp_list,
-				      struct in6_addr *addr, u16 port)
+				      struct in6_addr *addr, u16 port,
+				      unsigned long expiry)
 {
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
 	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, addr, htons(port));
-	return efx_ptp_insert_filter(efx, ptp_list, &spec);
+	return efx_ptp_insert_filter(efx, ptp_list, &spec, expiry);
 }
 
 static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 {
+	struct efx_ptp_data *ptp = efx->ptp_data;
 	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
 	struct efx_filter_spec spec;
 
@@ -1414,7 +1433,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
 	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
 	spec.ether_type = htons(ETH_P_1588);
-	return efx_ptp_insert_filter(efx, &efx->ptp_data->rxfilters_mcast, &spec);
+	return efx_ptp_insert_filter(efx, &ptp->rxfilters_mcast, &spec, 0);
 }
 
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
@@ -1429,12 +1448,14 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
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
 
@@ -1445,12 +1466,12 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
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
 
@@ -1486,21 +1507,24 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
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
 			goto fail;
 
 		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
+						addr, PTP_GENERAL_PORT, expiry);
 		if (rc < 0)
 			goto fail;
 	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
@@ -1508,12 +1532,12 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_EVENT_PORT);
+						addr, PTP_EVENT_PORT, expiry);
 		if (rc < 0)
 			goto fail;
 
 		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
-						addr, PTP_GENERAL_PORT);
+						addr, PTP_GENERAL_PORT, expiry);
 		if (rc < 0)
 			goto fail;
 	} else {
@@ -1527,6 +1551,17 @@ static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
 	return rc;
 }
 
+static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
+{
+	struct efx_ptp_data *ptp = efx->ptp_data;
+	struct efx_ptp_rxfilter *rxfilter, *tmp;
+
+	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
+		if (time_is_before_jiffies(rxfilter->expiry))
+			efx_ptp_remove_one_filter(efx, rxfilter);
+	}
+}
+
 static int efx_ptp_start(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1627,6 +1662,8 @@ static void efx_ptp_worker(struct work_struct *work)
 
 	while ((skb = __skb_dequeue(&tempq)))
 		efx_ptp_process_rx(efx, skb);
+
+	efx_ptp_drop_expired_unicast_filters(efx);
 }
 
 static const struct ptp_clock_info efx_phc_clock_info = {
-- 
2.34.3

