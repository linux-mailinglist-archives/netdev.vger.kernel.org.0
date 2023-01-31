Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7301683233
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjAaQGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjAaQGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:06:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59043A597
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675181133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJUfBg5WUyDRR7XeuomJTWwLxnFnbdVZzYikPHmQJC0=;
        b=BcjIcwmTD6m1Ny0JFPu16JQCmnLL8+RzXydzgeNm+i5Be14+zlNktYBwPyTBOvAJ7Hv7gz
        DEIheHh3iZImWmn02fKO1tyKI5bV3p39EYbC/B9B+thPt/TcVaBvb3c/0GNLNDBGLC8HsX
        lurfcvaP3SzafZ5ZBQtC1OWQWf5OXko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-dcnhL_6EM4iE8QqYit-JHg-1; Tue, 31 Jan 2023 11:05:25 -0500
X-MC-Unique: dcnhL_6EM4iE8QqYit-JHg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35CC1100DEA3;
        Tue, 31 Jan 2023 16:05:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D799492B05;
        Tue, 31 Jan 2023 16:05:21 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH net 3/4] sfc: support unicast PTP
Date:   Tue, 31 Jan 2023 17:05:05 +0100
Message-Id: <20230131160506.47552-4-ihuguet@redhat.com>
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

When sending a PTP event packet, add the correct filters that will make
that future incoming unicast PTP event packets will be timestamped.
The unicast address for the filter is gotten from the outgoing skb
before sending it.

Until now they were not timestamped because only filters that match with
the PTP multicast addressed were being configured into the NIC for the
PTP special channel. Packets received through different channels are not
timestamped, getting "received SYNC without timestamp" error in ptp4l.

Note that the inserted filters are never removed unless the NIC is stopped
or reconfigured, so efx_ptp_stop is called. Removal of old filters will
be handled by the next patch.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 104 ++++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 5d5f70c56048..f9342e21bf31 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -217,10 +217,15 @@ struct efx_ptp_timeset {
 /**
  * struct efx_ptp_rxfilter - Filter for PTP packets
  * @list: Node of the list where the filter is added
+ * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
+ * @loc_host: IPv4/v6 address of the filter
  * @handle: Handle ID for the MCDI filters table
  */
 struct efx_ptp_rxfilter {
 	struct list_head list;
+	__be16 ether_type;
+	__be16 loc_port;
+	__be32 loc_host[4];
 	int handle;
 };
 
@@ -369,6 +374,8 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
 			   const struct timespec64 *e_ts);
 static int efx_phc_enable(struct ptp_clock_info *ptp,
 			  struct ptp_clock_request *request, int on);
+static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
+					 struct sk_buff *skb);
 
 bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
 {
@@ -1114,6 +1121,8 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		skb_get(skb);
+
 		/* This code invokes normal driver TX code which is always
 		 * protected from softirqs when called from generic TX code,
 		 * which in turn disables preemption. Look at __dev_queue_xmit
@@ -1137,6 +1146,13 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
 		local_bh_enable();
+
+		/* We need to add the filters after enqueuing the packet.
+		 * Otherwise, there's high latency in sending back the
+		 * timestamp, causing ptp4l timeouts
+		 */
+		efx_ptp_insert_unicast_filter(efx, skb);
+		dev_consume_skb_any(skb);
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
@@ -1148,7 +1164,7 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
 {
 	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	struct skb_shared_hwtstamps timestamps;
-	int rc = -EIO;
+	int rc;
 	MCDI_DECLARE_BUF(txtime, MC_CMD_PTP_OUT_TRANSMIT_LEN);
 	size_t len;
 
@@ -1184,7 +1200,10 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
 
 	skb_tstamp_tx(skb, &timestamps);
 
-	rc = 0;
+	/* Add the filters after sending back the timestamp to avoid delaying it
+	 * or ptp4l may timeout.
+	 */
+	efx_ptp_insert_unicast_filter(efx, skb);
 
 fail:
 	dev_kfree_skb_any(skb);
@@ -1300,6 +1319,21 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }
 
+static bool efx_ptp_filter_exists(struct list_head *ptp_list,
+				  struct efx_filter_spec *spec)
+{
+	struct efx_ptp_rxfilter *rxfilter;
+
+	list_for_each_entry(rxfilter, ptp_list, list) {
+		if (rxfilter->ether_type == spec->ether_type &&
+		    rxfilter->loc_port == spec->loc_port &&
+		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
+			return true;
+	}
+
+	return false;
+}
+
 static void efx_ptp_remove_filters(struct efx_nic *efx,
 				   struct list_head *ptp_list)
 {
@@ -1328,8 +1362,12 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 				 struct efx_filter_spec *spec)
 {
 	struct efx_ptp_rxfilter *rxfilter;
+	int rc;
+
+	if (efx_ptp_filter_exists(ptp_list, spec))
+		return 0;
 
-	int rc = efx_filter_insert_filter(efx, spec, true);
+	rc = efx_filter_insert_filter(efx, spec, true);
 	if (rc < 0)
 		return rc;
 
@@ -1338,6 +1376,9 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 		return -ENOMEM;
 
 	rxfilter->handle = rc;
+	rxfilter->ether_type = spec->ether_type;
+	rxfilter->loc_port = spec->loc_port;
+	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
 	list_add(&rxfilter->list, ptp_list);
 
 	return 0;
@@ -1426,6 +1467,63 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	return rc;
 }
 
+static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
+{
+	if (skb->protocol == htons(ETH_P_IP)) {
+		return ip_hdr(skb)->protocol == IPPROTO_UDP &&
+			udp_hdr(skb)->source == htons(PTP_EVENT_PORT);
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP &&
+			udp_hdr(skb)->source == htons(PTP_EVENT_PORT);
+	}
+	return false;
+}
+
+static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
+					 struct sk_buff *skb)
+{
+	struct efx_ptp_data *ptp = efx->ptp_data;
+	int rc;
+
+	if (!efx_ptp_valid_unicast_event_pkt(skb))
+		return -EINVAL;
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		__be32 addr = ip_hdr(skb)->saddr;
+
+		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_EVENT_PORT);
+		if (rc < 0)
+			goto fail;
+
+		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_GENERAL_PORT);
+		if (rc < 0)
+			goto fail;
+	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
+		/* IPv6 PTP only supported by devices with MAC hw timestamp */
+		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
+
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_EVENT_PORT);
+		if (rc < 0)
+			goto fail;
+
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_GENERAL_PORT);
+		if (rc < 0)
+			goto fail;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+
+fail:
+	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
+	return rc;
+}
+
 static int efx_ptp_start(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-- 
2.34.3

