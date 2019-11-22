Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1801076D6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVR5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:57:13 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59766 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVR5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:57:13 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 951AD140055;
        Fri, 22 Nov 2019 17:57:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 22 Nov
 2019 17:57:06 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/4] sfc: change ARFS expiry mechanism
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dahern@digitalocean.com>
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
Message-ID: <921437ed-3799-acb5-c451-9cdd5385c219@solarflare.com>
Date:   Fri, 22 Nov 2019 17:57:03 +0000
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
X-TM-AS-Result: No-6.684700-8.000000-10
X-TMASE-MatchedRID: d+gpvr7InGetZlrqOgsY0o6MisxJraxHBGvINcfHqhccNByoSo036V24
        YvC9/lw+u6Xct9F0rbcTtMPWJoz0sAEj1AVDtJJ4yEC2oYVhSLdMNRZhAlg8Xfa7agslQWYY8b1
        mXTqetmxfXgaBel9gNVO9V994jC9DBRx9b+h52ar9xyC38S1f/UqAhuLHn5fEBph69XjMbdlAHO
        g8qEtqyI+pAn19BHXOJkB8cahV/fn5aaD8UJf+6xIRh9wkXSlFYyd8vdGoWl6Ou0peLig4NqbTa
        68ieFBImE9rrt2FS01+8BOKv4EeDJaASgYEJ4rcPja3w1ExF8ThwsEcDDUFFpGvQzrZru7Ov98j
        ro28kFdk1QMds9nkrdj7RGFK0n0rACxdMInUvFn1xv2JHBkcHyJCx+FdkFrEtnbn9SmDi/zx9fz
        91y6x5Tai5E+OmyyTTIyzaGGqlyVONK8V/h3BL8nUT+eskUQPUGKOMTReNj426TIMgH4duoq6kl
        7TAoONbP6xeqc/RKQ7kMqQYJ/FFIvNXvKDwKtAVvRU70CYUV3CRWLCji6qWZ6fSoF3Lt+MNjNDs
        0sHRtri8zVgXoAltkWL4rBlm20vjaPj0W1qn0Q7AFczfjr/7OgLMHsLj+mlgI/ryeszxO45+KmV
        FEDlwuvVhi9+xtb9TjFoGNTw/vQ=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.684700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25058.003
X-MDID: 1574445432-WRhPnie7R0Zz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old rfs_filters_added method for determining the quota could potentially
 allow the NIC to become filled with old filters, which never get tested for
 expiry.  Instead, explicitly make expiry check work depend on the number of
 filters installed, and don't count checking slots without filters in as
 doing work.  This guarantees that each filter will be checked for expiry at
 least once every thirty seconds (assuming the channel to which it belongs is
 NAPI polling actively) regardless of fill level.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        |  8 +++--
 drivers/net/ethernet/sfc/efx.h        |  9 +++---
 drivers/net/ethernet/sfc/net_driver.h | 14 ++++----
 drivers/net/ethernet/sfc/rx.c         | 46 ++++++++++++++++-----------
 4 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 0fa9972027db..38d186b949be 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1969,6 +1969,8 @@ static int efx_probe_filters(struct efx_nic *efx)
 				     ++i)
 					channel->rps_flow_id[i] =
 						RPS_FLOW_ID_INVALID;
+			channel->rfs_expire_index = 0;
+			channel->rfs_filter_count = 0;
 		}
 
 		if (!success) {
@@ -1978,8 +1980,6 @@ static int efx_probe_filters(struct efx_nic *efx)
 			rc = -ENOMEM;
 			goto out_unlock;
 		}
-
-		efx->rps_expire_index = efx->rps_expire_channel = 0;
 	}
 #endif
 out_unlock:
@@ -1993,8 +1993,10 @@ static void efx_remove_filters(struct efx_nic *efx)
 #ifdef CONFIG_RFS_ACCEL
 	struct efx_channel *channel;
 
-	efx_for_each_channel(channel, efx)
+	efx_for_each_channel(channel, efx) {
+		flush_work(&channel->filter_work);
 		kfree(channel->rps_flow_id);
+	}
 #endif
 	down_write(&efx->filter_sem);
 	efx->type->filter_table_remove(efx);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 45c7ae4114ec..e58c2b6d64d9 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -166,15 +166,16 @@ static inline s32 efx_filter_get_rx_ids(struct efx_nic *efx,
 #ifdef CONFIG_RFS_ACCEL
 int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 		   u16 rxq_index, u32 flow_id);
-bool __efx_filter_rfs_expire(struct efx_nic *efx, unsigned quota);
+bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
 static inline void efx_filter_rfs_expire(struct work_struct *data)
 {
 	struct efx_channel *channel = container_of(data, struct efx_channel,
 						   filter_work);
+	unsigned int time = jiffies - channel->rfs_last_expiry, quota;
 
-	if (channel->rfs_filters_added >= 60 &&
-	    __efx_filter_rfs_expire(channel->efx, 100))
-		channel->rfs_filters_added -= 60;
+	quota = channel->rfs_filter_count * time / (30 * HZ);
+	if (quota > 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
+		channel->rfs_last_expiry += time;
 }
 #define efx_filter_rfs_enabled() 1
 #else
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 04e49eac7327..5b1b882f6c67 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -439,6 +439,11 @@ enum efx_sync_events_state {
  * @event_test_cpu: Last CPU to handle interrupt or test event for this channel
  * @irq_count: Number of IRQs since last adaptive moderation decision
  * @irq_mod_score: IRQ moderation score
+ * @rfs_filter_count: number of accelerated RFS filters currently in place;
+ *	equals the count of @rps_flow_id slots filled
+ * @rfs_last_expiry: value of jiffies last time some accelerated RFS filters
+ *	were checked for expiry
+ * @rfs_expire_index: next accelerated RFS filter ID to check for expiry
  * @filter_work: Work item for efx_filter_rfs_expire()
  * @rps_flow_id: Flow IDs of filters allocated for accelerated RFS,
  *      indexed by filter ID
@@ -489,7 +494,9 @@ struct efx_channel {
 	unsigned int irq_count;
 	unsigned int irq_mod_score;
 #ifdef CONFIG_RFS_ACCEL
-	unsigned int rfs_filters_added;
+	unsigned int rfs_filter_count;
+	unsigned int rfs_last_expiry;
+	unsigned int rfs_expire_index;
 	struct work_struct filter_work;
 #define RPS_FLOW_ID_INVALID 0xFFFFFFFF
 	u32 *rps_flow_id;
@@ -923,9 +930,6 @@ struct efx_async_filter_insertion {
  * @filter_sem: Filter table rw_semaphore, protects existence of @filter_state
  * @filter_state: Architecture-dependent filter table state
  * @rps_mutex: Protects RPS state of all channels
- * @rps_expire_channel: Next channel to check for expiry
- * @rps_expire_index: Next index to check for expiry in
- *	@rps_expire_channel's @rps_flow_id
  * @rps_slot_map: bitmap of in-flight entries in @rps_slot
  * @rps_slot: array of ARFS insertion requests for efx_filter_rfs_work()
  * @rps_hash_lock: Protects ARFS filter mapping state (@rps_hash_table and
@@ -1096,8 +1100,6 @@ struct efx_nic {
 	void *filter_state;
 #ifdef CONFIG_RFS_ACCEL
 	struct mutex rps_mutex;
-	unsigned int rps_expire_channel;
-	unsigned int rps_expire_index;
 	unsigned long rps_slot_map;
 	struct efx_async_filter_insertion rps_slot[EFX_RPS_MAX_IN_FLIGHT];
 	spinlock_t rps_hash_lock;
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index bec261905530..bbf2393f7599 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -988,6 +988,7 @@ static void efx_filter_rfs_work(struct work_struct *data)
 
 	rc = efx->type->filter_insert(efx, &req->spec, true);
 	if (rc >= 0)
+		/* Discard 'priority' part of EF10+ filter ID (mcdi_filters) */
 		rc %= efx->type->max_rx_ip_filters;
 	if (efx->rps_hash_table) {
 		spin_lock_bh(&efx->rps_hash_lock);
@@ -1012,8 +1013,9 @@ static void efx_filter_rfs_work(struct work_struct *data)
 		 * later.
 		 */
 		mutex_lock(&efx->rps_mutex);
+		if (channel->rps_flow_id[rc] == RPS_FLOW_ID_INVALID)
+			channel->rfs_filter_count++;
 		channel->rps_flow_id[rc] = req->flow_id;
-		++channel->rfs_filters_added;
 		mutex_unlock(&efx->rps_mutex);
 
 		if (req->spec.ether_type == htons(ETH_P_IP))
@@ -1139,38 +1141,44 @@ int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	return rc;
 }
 
-bool __efx_filter_rfs_expire(struct efx_nic *efx, unsigned int quota)
+bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
 {
 	bool (*expire_one)(struct efx_nic *efx, u32 flow_id, unsigned int index);
-	unsigned int channel_idx, index, size;
+	struct efx_nic *efx = channel->efx;
+	unsigned int index, size, start;
 	u32 flow_id;
 
 	if (!mutex_trylock(&efx->rps_mutex))
 		return false;
 	expire_one = efx->type->filter_rfs_expire_one;
-	channel_idx = efx->rps_expire_channel;
-	index = efx->rps_expire_index;
+	index = channel->rfs_expire_index;
+	start = index;
 	size = efx->type->max_rx_ip_filters;
-	while (quota--) {
-		struct efx_channel *channel = efx_get_channel(efx, channel_idx);
+	while (quota) {
 		flow_id = channel->rps_flow_id[index];
 
-		if (flow_id != RPS_FLOW_ID_INVALID &&
-		    expire_one(efx, flow_id, index)) {
-			netif_info(efx, rx_status, efx->net_dev,
-				   "expired filter %d [queue %u flow %u]\n",
-				   index, channel_idx, flow_id);
-			channel->rps_flow_id[index] = RPS_FLOW_ID_INVALID;
+		if (flow_id != RPS_FLOW_ID_INVALID) {
+			quota--;
+			if (expire_one(efx, flow_id, index)) {
+				netif_info(efx, rx_status, efx->net_dev,
+					   "expired filter %d [channel %u flow %u]\n",
+					   index, channel->channel, flow_id);
+				channel->rps_flow_id[index] = RPS_FLOW_ID_INVALID;
+				channel->rfs_filter_count--;
+			}
 		}
-		if (++index == size) {
-			if (++channel_idx == efx->n_channels)
-				channel_idx = 0;
+		if (++index == size)
 			index = 0;
-		}
+		/* If we were called with a quota that exceeds the total number
+		 * of filters in the table (which should never happen), ensure
+		 * that we don't loop forever - stop when we've examined every
+		 * row of the table.
+		 */
+		if (WARN_ON(index == start && quota))
+			break;
 	}
-	efx->rps_expire_channel = channel_idx;
-	efx->rps_expire_index = index;
 
+	channel->rfs_expire_index = index;
 	mutex_unlock(&efx->rps_mutex);
 	return true;
 }

