Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA9F1076D8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKVR5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:57:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40804 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVR5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:57:38 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8672B4C0058;
        Fri, 22 Nov 2019 17:57:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 22 Nov
 2019 17:57:31 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/4] sfc: add statistics for ARFS
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dahern@digitalocean.com>
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Message-ID: <964dd1b3-b26a-e5ee-7ac2-b4643206cb5f@solarflare.com>
Date:   Fri, 22 Nov 2019 17:57:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25058.003
X-TM-AS-Result: No-4.469600-8.000000-10
X-TMASE-MatchedRID: OyKQ2s7PfcGkzHBRdMk1zKiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrH5x
        FL8+A6pUSjVIFO5E44Bw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5C3iRApcRQCqzk9k6NqjPui9w
        qKeXPJfXkISS46y5nX/CjmS9GZutK6biOAxfBSkYJ6xTeI+I0LA73P4/aDCIFlVcRi0Wk5Zif27
        pkMe/LtxtdIB8dtMfczOGKvPIFIheZzIEe4t3y1nV7tdtvoibavvsJC2qWnXexW4YXFsTUDvDGS
        U3bZF254vM1YF6AJbZFi+KwZZttL42j49Ftap9ExlblqLlYqXJOPHzZwMy9yrRXqQVFFAk8xAU0
        K0kLzNLGDFDMx2UqxPBcBNvvo2mQmHAKqCi+6Cgl5L5k4cl1+hToOcvYKeQWHYBFDgneea+QRHK
        5EcWCeFIypztSlSisEpGw8LptO86qtDFfJ0jAbwAXzdZ50duF
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.469600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25058.003
X-MDID: 1574445457-egLa0N1BvHYc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the number of successful and failed insertions, and also the
 current count of filters, to aid in tuning e.g. rps_flow_cnt.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c    | 6 ++++++
 drivers/net/ethernet/sfc/net_driver.h | 4 ++++
 drivers/net/ethernet/sfc/rx.c         | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 8db593fb9699..6a9347cd67f3 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -56,6 +56,9 @@ static u64 efx_get_atomic_stat(void *field)
 #define EFX_ETHTOOL_UINT_CHANNEL_STAT(field)			\
 	EFX_ETHTOOL_STAT(field, channel, n_##field,		\
 			 unsigned int, efx_get_uint_stat)
+#define EFX_ETHTOOL_UINT_CHANNEL_STAT_NO_N(field)		\
+	EFX_ETHTOOL_STAT(field, channel, field,			\
+			 unsigned int, efx_get_uint_stat)
 
 #define EFX_ETHTOOL_UINT_TXQ_STAT(field)			\
 	EFX_ETHTOOL_STAT(tx_##field, tx_queue, field,		\
@@ -87,6 +90,9 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT_NO_N(rfs_filter_count),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_succeeded),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_failed),
 };
 
 #define EFX_ETHTOOL_SW_STAT_COUNT ARRAY_SIZE(efx_sw_stat_desc)
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 5b1b882f6c67..ccd480e699d3 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -444,6 +444,8 @@ enum efx_sync_events_state {
  * @rfs_last_expiry: value of jiffies last time some accelerated RFS filters
  *	were checked for expiry
  * @rfs_expire_index: next accelerated RFS filter ID to check for expiry
+ * @n_rfs_succeeded: number of successful accelerated RFS filter insertions
+ * @n_rfs_failed; number of failed accelerated RFS filter insertions
  * @filter_work: Work item for efx_filter_rfs_expire()
  * @rps_flow_id: Flow IDs of filters allocated for accelerated RFS,
  *      indexed by filter ID
@@ -497,6 +499,8 @@ struct efx_channel {
 	unsigned int rfs_filter_count;
 	unsigned int rfs_last_expiry;
 	unsigned int rfs_expire_index;
+	unsigned int n_rfs_succeeded;
+	unsigned int n_rfs_failed;
 	struct work_struct filter_work;
 #define RPS_FLOW_ID_INVALID 0xFFFFFFFF
 	u32 *rps_flow_id;
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 252a5f10596d..ef52b24ad9e7 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -1032,6 +1032,7 @@ static void efx_filter_rfs_work(struct work_struct *data)
 				   req->spec.rem_host, ntohs(req->spec.rem_port),
 				   req->spec.loc_host, ntohs(req->spec.loc_port),
 				   req->rxq_index, req->flow_id, rc, arfs_id);
+		channel->n_rfs_succeeded++;
 	} else {
 		if (req->spec.ether_type == htons(ETH_P_IP))
 			netif_dbg(efx, rx_status, efx->net_dev,
@@ -1047,6 +1048,7 @@ static void efx_filter_rfs_work(struct work_struct *data)
 				  req->spec.rem_host, ntohs(req->spec.rem_port),
 				  req->spec.loc_host, ntohs(req->spec.loc_port),
 				  req->rxq_index, req->flow_id, rc, arfs_id);
+		channel->n_rfs_failed++;
 		/* We're overloading the NIC's filter tables, so let's do a
 		 * chunk of extra expiry work.
 		 */

