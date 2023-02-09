Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE03690584
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBIKqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBIKpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:45:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970766950C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675939449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=entF7ymCQK6fW4lznQEK+hTvwFGinZs608m4QMRmy+c=;
        b=MSdULSic0eFt88XrkxPsBl4EUnB09qczBM1m3fK2cnZi9VRn6E5crGRTmDxiNqBQ0ymEQK
        kxyockBSPwuKsss5CpHissdDtOsu+G9yXPTwkokwY9M9m3evMV/gf/C7G9XIRC73r/7IRU
        ZNfh8RBh/URpKUskYyelFCot0b+f8pg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-JJVKUPyxOXOWpQMV1AM4yA-1; Thu, 09 Feb 2023 05:44:08 -0500
X-MC-Unique: JJVKUPyxOXOWpQMV1AM4yA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C6E23C0F1A2;
        Thu,  9 Feb 2023 10:44:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA1344043840;
        Thu,  9 Feb 2023 10:44:05 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net-next v3 2/4] sfc: allow insertion of filters for unicast PTP
Date:   Thu,  9 Feb 2023 11:43:47 +0100
Message-Id: <20230209104349.15830-3-ihuguet@redhat.com>
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

Add a second list for unicast filters and generalize the
efx_ptp_insert/remove_filters functions to allow acting in any of the 2
lists.

No filters for unicast are inserted yet. That will be done in the next
patch.

The reason to use 2 different lists instead of a single one is that, in
next patches, we will want to check if unicast filters are already added
and if they're expired. We don't need that for multicast filters.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 58 ++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index b98c50874bb7..57e9355471b1 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -239,6 +239,7 @@ struct efx_ptp_rxfilter {
  * @reset_required: A serious error has occurred and the PTP task needs to be
  *                  reset (disable, enable).
  * @rxfilters_mcast: Receive filters for multicast PTP packets
+ * @rxfilters_ucast: Receive filters for unicast PTP packets
  * @config: Current timestamp configuration
  * @enabled: PTP operation enabled
  * @mode: Mode in which PTP operating (PTP version)
@@ -308,6 +309,7 @@ struct efx_ptp_data {
 	struct work_struct work;
 	bool reset_required;
 	struct list_head rxfilters_mcast;
+	struct list_head rxfilters_ucast;
 	struct hwtstamp_config config;
 	bool enabled;
 	unsigned int mode;
@@ -1296,12 +1298,12 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
-static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
+static void efx_ptp_remove_filters(struct efx_nic *efx,
+				   struct list_head *ptp_list)
 {
-	struct efx_ptp_data *ptp = efx->ptp_data;
 	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
-	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_mcast, list) {
+	list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
 		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
 					  rxfilter->handle);
 		list_del(&rxfilter->list);
@@ -1320,9 +1322,9 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 }
 
 static int efx_ptp_insert_filter(struct efx_nic *efx,
+				 struct list_head *ptp_list,
 				 struct efx_filter_spec *spec)
 {
-	struct efx_ptp_data *ptp = efx->ptp_data;
 	struct efx_ptp_rxfilter *rxfilter;
 
 	int rc = efx_filter_insert_filter(efx, spec, true);
@@ -1334,32 +1336,34 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 		return -ENOMEM;
 
 	rxfilter->handle = rc;
-	list_add(&rxfilter->list, &ptp->rxfilters_mcast);
+	list_add(&rxfilter->list, ptp_list);
 
 	return 0;
 }
 
-static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
+static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
+				      struct list_head *ptp_list,
+				      __be32 addr, u16 port)
 {
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
-	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
-				  htons(port));
-	return efx_ptp_insert_filter(efx, &spec);
+	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, addr, htons(port));
+	return efx_ptp_insert_filter(efx, ptp_list, &spec);
 }
 
-static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, u16 port)
+static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
+				      struct list_head *ptp_list,
+				      struct in6_addr *addr, u16 port)
 {
-	const struct in6_addr addr = {{PTP_ADDR_IPV6}};
 	struct efx_filter_spec spec;
 
 	efx_ptp_init_filter(efx, &spec);
-	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, &addr, htons(port));
-	return efx_ptp_insert_filter(efx, &spec);
+	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, addr, htons(port));
+	return efx_ptp_insert_filter(efx, ptp_list, &spec);
 }
 
-static int efx_ptp_insert_eth_filter(struct efx_nic *efx)
+static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
 {
 	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
 	struct efx_filter_spec spec;
@@ -1368,7 +1372,7 @@ static int efx_ptp_insert_eth_filter(struct efx_nic *efx)
 	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
 	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
 	spec.ether_type = htons(ETH_P_1588);
-	return efx_ptp_insert_filter(efx, &spec);
+	return efx_ptp_insert_filter(efx, &efx->ptp_data->rxfilters_mcast, &spec);
 }
 
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
@@ -1382,11 +1386,13 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	/* Must filter on both event and general ports to ensure
 	 * that there is no packet re-ordering.
 	 */
-	rc = efx_ptp_insert_ipv4_filter(efx, PTP_EVENT_PORT);
+	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
+					htonl(PTP_ADDR_IPV4), PTP_EVENT_PORT);
 	if (rc < 0)
 		goto fail;
 
-	rc = efx_ptp_insert_ipv4_filter(efx, PTP_GENERAL_PORT);
+	rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
+					htonl(PTP_ADDR_IPV4), PTP_GENERAL_PORT);
 	if (rc < 0)
 		goto fail;
 
@@ -1394,15 +1400,19 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	 * PTP over IPv6 and Ethernet
 	 */
 	if (efx_ptp_use_mac_tx_timestamps(efx)) {
-		rc = efx_ptp_insert_ipv6_filter(efx, PTP_EVENT_PORT);
+		struct in6_addr ipv6_addr = {{PTP_ADDR_IPV6}};
+
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
+						&ipv6_addr, PTP_EVENT_PORT);
 		if (rc < 0)
 			goto fail;
 
-		rc = efx_ptp_insert_ipv6_filter(efx, PTP_GENERAL_PORT);
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mcast,
+						&ipv6_addr, PTP_GENERAL_PORT);
 		if (rc < 0)
 			goto fail;
 
-		rc = efx_ptp_insert_eth_filter(efx);
+		rc = efx_ptp_insert_eth_multicast_filter(efx);
 		if (rc < 0)
 			goto fail;
 	}
@@ -1410,7 +1420,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	return 0;
 
 fail:
-	efx_ptp_remove_multicast_filters(efx);
+	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
 	return rc;
 }
 
@@ -1435,7 +1445,7 @@ static int efx_ptp_start(struct efx_nic *efx)
 	return 0;
 
 fail:
-	efx_ptp_remove_multicast_filters(efx);
+	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
 	return rc;
 }
 
@@ -1451,7 +1461,8 @@ static int efx_ptp_stop(struct efx_nic *efx)
 
 	rc = efx_ptp_disable(efx);
 
-	efx_ptp_remove_multicast_filters(efx);
+	efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
+	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
 
 	/* Make sure RX packets are really delivered */
 	efx_ptp_deliver_rx_queue(&efx->ptp_data->rxq);
@@ -1583,6 +1594,7 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 		list_add(&ptp->rx_evts[pos].link, &ptp->evt_free_list);
 
 	INIT_LIST_HEAD(&ptp->rxfilters_mcast);
+	INIT_LIST_HEAD(&ptp->rxfilters_ucast);
 
 	/* Get the NIC PTP attributes and set up time conversions */
 	rc = efx_ptp_get_attributes(efx);
-- 
2.34.3

