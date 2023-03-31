Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2796D1ED5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjCaLPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjCaLP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:15:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647AF4C3D
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680261280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHq0zXvMK81OV18CB0uexUVX2noCWuNlagUW3O56hFA=;
        b=TarSdVb+2ZwaRR7R0Pmn0QxNweXkWZllIJMxY+kf6+Rktv0u6a6NNbQB4iN/tW+7hW/mjd
        Y46smJOt+BQtfN1CUod/6TC1B1I/cyCj3BgcLkSq/AwXmuprrKdjz+x8SIbRnVExKm2tKm
        IPJ6KlcLpJBYUmF43CLwhY9ATAJYZmk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-v1pdscNYOVu5YjK7WML5nw-1; Fri, 31 Mar 2023 07:14:32 -0400
X-MC-Unique: v1pdscNYOVu5YjK7WML5nw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2286889047;
        Fri, 31 Mar 2023 11:14:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EE0440B3ED9;
        Fri, 31 Mar 2023 11:14:27 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: [PATCH v6 net-next 3/4] sfc: support unicast PTP
Date:   Fri, 31 Mar 2023 13:14:03 +0200
Message-Id: <20230331111404.17256-4-ihuguet@redhat.com>
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

Additionally, cleanup a bit efx_ptp_xmit_skb_mc to use the reverse xmas
tree convention and remove an unnecessary assignment to rc variable in
void function.

Reported-by: Yalin Li <yalli@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ptp.c | 101 ++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index d5631e02e626..b495f3d0616b 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -215,10 +215,16 @@ struct efx_ptp_timeset {
 /**
  * struct efx_ptp_rxfilter - Filter for PTP packets
  * @list: Node of the list where the filter is added
+ * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_IPV6)
+ * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_PORT)
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

@@ -367,6 +373,8 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
 			   const struct timespec64 *e_ts);
 static int efx_phc_enable(struct ptp_clock_info *ptp,
 			  struct ptp_clock_request *request, int on);
+static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
+					 struct sk_buff *skb);

 bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
 {
@@ -1112,6 +1120,8 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)

 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		skb_get(skb);
+
 		/* This code invokes normal driver TX code which is always
 		 * protected from softirqs when called from generic TX code,
 		 * which in turn disables preemption. Look at __dev_queue_xmit
@@ -1135,6 +1145,13 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
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
@@ -1144,11 +1161,11 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 /* Transmit a PTP packet, via the MCDI interface, to the wire. */
 static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
 {
+	MCDI_DECLARE_BUF(txtime, MC_CMD_PTP_OUT_TRANSMIT_LEN);
 	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	struct skb_shared_hwtstamps timestamps;
-	int rc = -EIO;
-	MCDI_DECLARE_BUF(txtime, MC_CMD_PTP_OUT_TRANSMIT_LEN);
 	size_t len;
+	int rc;

 	MCDI_SET_DWORD(ptp_data->txbuf, PTP_IN_OP, MC_CMD_PTP_OP_TRANSMIT);
 	MCDI_SET_DWORD(ptp_data->txbuf, PTP_IN_PERIPH_ID, 0);
@@ -1182,7 +1199,10 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)

 	skb_tstamp_tx(skb, &timestamps);

-	rc = 0;
+	/* Add the filters after sending back the timestamp to avoid delaying it
+	 * or ptp4l may timeout.
+	 */
+	efx_ptp_insert_unicast_filter(efx, skb);

 fail:
 	dev_kfree_skb_any(skb);
@@ -1298,6 +1318,21 @@ static inline void efx_ptp_process_rx(struct efx_nic *efx, struct sk_buff *skb)
 	local_bh_enable();
 }

+static bool efx_ptp_filter_exists(struct list_head *filter_list,
+				  struct efx_filter_spec *spec)
+{
+	struct efx_ptp_rxfilter *rxfilter;
+
+	list_for_each_entry(rxfilter, filter_list, list) {
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
 				   struct list_head *filter_list)
 {
@@ -1328,6 +1363,9 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 	struct efx_ptp_rxfilter *rxfilter;
 	int rc;

+	if (efx_ptp_filter_exists(filter_list, spec))
+		return 0;
+
 	rxfilter = kzalloc(sizeof(*rxfilter), GFP_KERNEL);
 	if (!rxfilter)
 		return -ENOMEM;
@@ -1337,6 +1375,9 @@ static int efx_ptp_insert_filter(struct efx_nic *efx,
 		goto fail;

 	rxfilter->handle = rc;
+	rxfilter->ether_type = spec->ether_type;
+	rxfilter->loc_port = spec->loc_port;
+	memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host));
 	list_add(&rxfilter->list, filter_list);

 	return 0;
@@ -1430,6 +1471,60 @@ static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
 	return rc;
 }

+static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
+{
+	if (skb->protocol == htons(ETH_P_IP)) {
+		return ip_hdr(skb)->daddr != htonl(PTP_ADDR_IPV4) &&
+			ip_hdr(skb)->protocol == IPPROTO_UDP &&
+			udp_hdr(skb)->source == htons(PTP_EVENT_PORT);
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct in6_addr mcast_addr = {{PTP_ADDR_IPV6}};
+
+		return !ipv6_addr_equal(&ipv6_hdr(skb)->daddr, &mcast_addr) &&
+			ipv6_hdr(skb)->nexthdr == IPPROTO_UDP &&
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
+			goto out;
+
+		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_GENERAL_PORT);
+	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
+		/* IPv6 PTP only supported by devices with MAC hw timestamp */
+		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
+
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_EVENT_PORT);
+		if (rc < 0)
+			goto out;
+
+		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
+						addr, PTP_GENERAL_PORT);
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+out:
+	return rc;
+}
+
 static int efx_ptp_start(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
--
2.39.2

