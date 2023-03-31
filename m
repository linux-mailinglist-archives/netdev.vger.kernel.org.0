Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAC26D1ED2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjCaLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjCaLPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A774B8A43
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680261258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTUNxXB8waGM5klCOXVJjaX6sSxl38RK0MX/Rq9S0D4=;
        b=Ul1NJRWUuuLlaQhxIzqVlF/b7kZzPr288VmzP6Dzo5QQ4Yd4+ftrPpZccL9WFTkmxIo7vd
        bZ3aezDT+sO5OewaHd2tk28P/mS8T6sfodxBCFoDwca0uT6PiEgYE1Gg0z8UxsViET05my
        7AUB5+pChSW2TDj/A7yGF0DJPX3wyak=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-LkJdGoFtPKGPo-CByfSfKA-1; Fri, 31 Mar 2023 07:14:15 -0400
X-MC-Unique: LkJdGoFtPKGPo-CByfSfKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 033BE1C17425;
        Fri, 31 Mar 2023 11:14:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53C2840B3ED9;
        Fri, 31 Mar 2023 11:14:13 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH v6 net-next 1/4] sfc: store PTP filters in a list
Date:   Fri, 31 Mar 2023 13:14:01 +0200
Message-Id: <20230331111404.17256-2-ihuguet@redhat.com>
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
 drivers/net/ethernet/sfc/ptp.c | 81 ++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 9f07e1ba7780..8418a25ed724 100644
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
@@ -118,8 +119,6 @@
 
 #define	PTP_MIN_LENGTH		63
 
-#define PTP_RXFILTERS_LEN	5
-
 #define PTP_ADDR_IPV4		0xe0000181	/* 224.0.1.129 */
 #define PTP_ADDR_IPV6		{0xff, 0x0e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
 				0, 0x01, 0x81}	/* ff0e::181 */
@@ -213,6 +212,16 @@ struct efx_ptp_timeset {
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
@@ -229,8 +238,7 @@ struct efx_ptp_timeset {
  * @work: Work task
  * @reset_required: A serious error has occurred and the PTP task needs to be
  *                  reset (disable, enable).
- * @rxfilters: Receive filters when operating
- * @rxfilters_count: Num of installed rxfilters, should be == PTP_RXFILTERS_LEN
+ * @rxfilters_mcast: Receive filters for multicast PTP packets
  * @config: Current timestamp configuration
  * @enabled: PTP operation enabled
  * @mode: Mode in which PTP operating (PTP version)
@@ -299,8 +307,7 @@ struct efx_ptp_data {
 	struct workqueue_struct *workwq;
 	struct work_struct work;
 	bool reset_required;
-	u32 rxfilters[PTP_RXFILTERS_LEN];
-	size_t rxfilters_count;
+	struct list_head rxfilters_mcast;
 	struct hwtstamp_config config;
 	bool enabled;
 	unsigned int mode;
@@ -1292,11 +1299,13 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
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
 
@@ -1311,48 +1320,60 @@ static void efx_ptp_init_filter(struct efx_nic *efx,
 }
 
 static int efx_ptp_insert_filter(struct efx_nic *efx,
-				 struct efx_filter_spec *rxfilter)
+				 struct efx_filter_spec *spec)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
+	struct efx_ptp_rxfilter *rxfilter;
+	int rc;
+
+	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
+	if (!rxfilter)
+		return -ENOMEM;
 
-	int rc = efx_filter_insert_filter(efx, rxfilter, true);
+	rc = efx_filter_insert_filter(efx, spec, true);
 	if (rc < 0)
-		return rc;
-	ptp->rxfilters[ptp->rxfilters_count] = rc;
-	ptp->rxfilters_count++;
+		goto fail;
+
+	rxfilter->handle = rc;
+	list_add(&rxfilter->list, &ptp->rxfilters_mcast);
+
 	return 0;
+
+fail:
+	kfree(rxfilter);
+	return rc;
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
@@ -1360,7 +1381,7 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	int rc;
 
-	if (!ptp->channel || ptp->rxfilters_count)
+	if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
 		return 0;
 
 	/* Must filter on both event and general ports to ensure
@@ -1566,6 +1587,8 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	for (pos = 0; pos < MAX_RECEIVE_EVENTS; pos++)
 		list_add(&ptp->rx_evts[pos].link, &ptp->evt_free_list);
 
+	INIT_LIST_HEAD(&ptp->rxfilters_mcast);
+
 	/* Get the NIC PTP attributes and set up time conversions */
 	rc = efx_ptp_get_attributes(efx);
 	if (rc < 0)
-- 
2.39.2

