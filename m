Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F1B683235
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjAaQG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjAaQG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:06:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C6212C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675181142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlcsKLNA2wTDQ8gNIAxEjA0aN93UuUpfQr4erKan12U=;
        b=cI+skwDc6fjFV+H/aoCLT4AEA99owoUecKL+RQBYdbx3JuJcNTp/ZTHaOcc2uIl8oNPRJO
        kiD6La4tLSlLzHrnwYJX7BxQIizrtLv5gHjjXgey44l3XgOMYECCzEk5e8tIwuoJTikgP4
        ictlc30DjpjQN36CRnQ2eMbH6EcrDvA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-ltirPfqZMOS-eWNlu0fSNg-1; Tue, 31 Jan 2023 11:05:24 -0500
X-MC-Unique: ltirPfqZMOS-eWNlu0fSNg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 004743811F3D;
        Tue, 31 Jan 2023 16:05:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AE65492B05;
        Tue, 31 Jan 2023 16:05:17 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net 1/4] sfc: store PTP filters in a list
Date:   Tue, 31 Jan 2023 17:05:03 +0100
Message-Id: <20230131160506.47552-2-ihuguet@redhat.com>
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

Instead of using a fixed sized array for the PTP filters, use a list.

This is not actually necessary at this point because the filters for
multicast PTP are a fixed number, but this is a preparation for the
following patches adding support for unicast PTP.

To avoid confusion with the new struct type efx_ptp_rxfilter, change the
name of some local variables from rxfilter to spec, given they're of the
type efx_filter_spec.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 72 ++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 9f07e1ba7780..53817b4350a5 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -33,6 +33,7 @@
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <linux/time.h>
+#include <linux/errno.h>
 #include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/pps_kernel.h>
@@ -213,6 +214,16 @@ struct efx_ptp_timeset {
 	u32 window;	/* Derived: end - start, allowing for wrap */
 };
 
+/**
+ * struct efx_ptp_rxfilter - Filter for PTP packets
+ * @list: Node of the list where the filter is added
+ * @handle: Handle ID for the MCDI filters table
+ */
+struct efx_ptp_rxfilter {
+	struct list_head list;
+	int handle;
+};
+
 /**
  * struct efx_ptp_data - Precision Time Protocol (PTP) state
  * @efx: The NIC context
@@ -229,8 +240,7 @@ struct efx_ptp_timeset {
  * @work: Work task
  * @reset_required: A serious error has occurred and the PTP task needs to be
  *                  reset (disable, enable).
- * @rxfilters: Receive filters when operating
- * @rxfilters_count: Num of installed rxfilters, should be == PTP_RXFILTERS_LEN
+ * @rxfilters_mcast: Receive filters for multicast PTP packets
  * @config: Current timestamp configuration
  * @enabled: PTP operation enabled
  * @mode: Mode in which PTP operating (PTP version)
@@ -299,8 +309,7 @@ struct efx_ptp_data {
 	struct workqueue_struct *workwq;
 	struct work_struct work;
 	bool reset_required;
-	u32 rxfilters[PTP_RXFILTERS_LEN];
-	size_t rxfilters_count;
+	struct list_head rxfilters_mcast;
 	struct hwtstamp_config config;
 	bool enabled;
 	unsigned int mode;
@@ -1292,11 +1301,13 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 static void efx_ptp_remove_multicast_filters(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
+	struct efx_ptp_rxfilter *rxfilter, *tmp;
 
-	while (ptp->rxfilters_count) {
-		ptp->rxfilters_count--;
+	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_mcast, list) {
 		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
-					  ptp->rxfilters[ptp->rxfilters_count]);
+					  rxfilter->handle);
+		list_del(&rxfilter->list);
+		kfree(rxfilter);
 	}
 }
 
@@ -1311,48 +1322,55 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 }
 
 static int efx_ptp_insert_filter(struct efx_nic *efx,
-				 struct efx_filter_spec *rxfilter)
+				 struct efx_filter_spec *spec)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
+	struct efx_ptp_rxfilter *rxfilter;
 
-	int rc = efx_filter_insert_filter(efx, rxfilter, true);
+	int rc = efx_filter_insert_filter(efx, spec, true);
 	if (rc < 0)
 		return rc;
-	ptp->rxfilters[ptp->rxfilters_count] = rc;
-	ptp->rxfilters_count++;
+
+	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
+	if (!rxfilter)
+		return -ENOMEM;
+
+	rxfilter->handle = rc;
+	list_add(&rxfilter->list, &ptp->rxfilters_mcast);
+
 	return 0;
 }
 
 static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
 {
-	struct efx_filter_spec rxfilter;
+	struct efx_filter_spec spec;
 
-	efx_ptp_init_filter(efx, &rxfilter);
-	efx_filter_set_ipv4_local(&rxfilter, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
+	efx_ptp_init_filter(efx, &spec);
+	efx_filter_set_ipv4_local(&spec, IPPROTO_UDP, htonl(PTP_ADDR_IPV4),
 				  htons(port));
-	return efx_ptp_insert_filter(efx, &rxfilter);
+	return efx_ptp_insert_filter(efx, &spec);
 }
 
 static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx, u16 port)
 {
 	const struct in6_addr addr = {{PTP_ADDR_IPV6}};
-	struct efx_filter_spec rxfilter;
+	struct efx_filter_spec spec;
 
-	efx_ptp_init_filter(efx, &rxfilter);
-	efx_filter_set_ipv6_local(&rxfilter, IPPROTO_UDP, &addr, htons(port));
-	return efx_ptp_insert_filter(efx, &rxfilter);
+	efx_ptp_init_filter(efx, &spec);
+	efx_filter_set_ipv6_local(&spec, IPPROTO_UDP, &addr, htons(port));
+	return efx_ptp_insert_filter(efx, &spec);
 }
 
 static int efx_ptp_insert_eth_filter(struct efx_nic *efx)
 {
 	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
-	struct efx_filter_spec rxfilter;
+	struct efx_filter_spec spec;
 
-	efx_ptp_init_filter(efx, &rxfilter);
-	efx_filter_set_eth_local(&rxfilter, EFX_FILTER_VID_UNSPEC, addr);
-	rxfilter.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
-	rxfilter.ether_type = htons(ETH_P_1588);
-	return efx_ptp_insert_filter(efx, &rxfilter);
+	efx_ptp_init_filter(efx, &spec);
+	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
+	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
+	spec.ether_type = htons(ETH_P_1588);
+	return efx_ptp_insert_filter(efx, &spec);
 }
 
 static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
@@ -1360,7 +1378,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	int rc;
 
-	if (!ptp->channel || ptp->rxfilters_count)
+	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
 		return 0;
 
 	/* Must filter on both event and general ports to ensure
@@ -1566,6 +1584,8 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	for (pos = 0; pos < MAX_RECEIVE_EVENTS; pos++)
 		list_add(&ptp->rx_evts[pos].link, &ptp->evt_free_list);
 
+	INIT_LIST_HEAD(&ptp->rxfilters_mcast);
+
 	/* Get the NIC PTP attributes and set up time conversions */
 	rc = efx_ptp_get_attributes(efx);
 	if (rc < 0)
-- 
2.34.3

