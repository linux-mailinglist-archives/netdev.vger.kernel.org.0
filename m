Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB05350BB01
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449092AbiDVPCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449100AbiDVPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:22 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 827905D196
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:59:20 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 272DF320133;
        Fri, 22 Apr 2022 15:59:18 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhuke-0007A4-6j; Fri, 22 Apr 2022 15:59:16 +0100
Subject: [PATCH net-next 10/28] sfc/siena: Rename functions in rx_common.h
 to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:59:15 +0100
Message-ID: <165063955516.27138.14461751045463833784.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

For siena use efx_siena_ as the function prefix.
Several functions are not used in Siena, so they are removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c            |   10 +-
 drivers/net/ethernet/sfc/siena/efx.h            |    2 
 drivers/net/ethernet/sfc/siena/efx_channels.c   |   19 ++--
 drivers/net/ethernet/sfc/siena/efx_common.c     |    2 
 drivers/net/ethernet/sfc/siena/ethtool_common.c |   15 ++-
 drivers/net/ethernet/sfc/siena/farch.c          |    9 +-
 drivers/net/ethernet/sfc/siena/rx.c             |   22 ++--
 drivers/net/ethernet/sfc/siena/rx_common.c      |  116 ++++++++++++-----------
 drivers/net/ethernet/sfc/siena/rx_common.h      |   89 ++++++++----------
 9 files changed, 144 insertions(+), 140 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index f54f3619705a..f1a46a28b934 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -306,7 +306,7 @@ static int efx_probe_nic(struct efx_nic *efx)
 	if (efx->n_channels > 1)
 		netdev_rss_key_fill(efx->rss_context.rx_hash_key,
 				    sizeof(efx->rss_context.rx_hash_key));
-	efx_set_default_rx_indir_table(efx, &efx->rss_context);
+	efx_siena_set_default_rx_indir_table(efx, &efx->rss_context);
 
 	/* Initialise the interrupt moderation settings */
 	efx->irq_mod_step_us = DIV_ROUND_UP(efx->timer_quantum_ns, 1000);
@@ -366,7 +366,7 @@ static int efx_probe_all(struct efx_nic *efx)
 			   " VFs may not function\n", rc);
 #endif
 
-	rc = efx_probe_filters(efx);
+	rc = efx_siena_probe_filters(efx);
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev,
 			  "failed to create filter tables\n");
@@ -380,7 +380,7 @@ static int efx_probe_all(struct efx_nic *efx)
 	return 0;
 
  fail5:
-	efx_remove_filters(efx);
+	efx_siena_remove_filters(efx);
  fail4:
 #ifdef CONFIG_SFC_SRIOV
 	efx->type->vswitching_remove(efx);
@@ -400,7 +400,7 @@ static void efx_remove_all(struct efx_nic *efx)
 	rtnl_unlock();
 
 	efx_siena_remove_channels(efx);
-	efx_remove_filters(efx);
+	efx_siena_remove_filters(efx);
 #ifdef CONFIG_SFC_SRIOV
 	efx->type->vswitching_remove(efx);
 #endif
@@ -602,7 +602,7 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_get_phys_port_name	= efx_siena_get_phys_port_name,
 	.ndo_setup_tc		= efx_siena_setup_tc,
 #ifdef CONFIG_RFS_ACCEL
-	.ndo_rx_flow_steer	= efx_filter_rfs,
+	.ndo_rx_flow_steer	= efx_siena_filter_rfs,
 #endif
 	.ndo_xdp_xmit		= efx_xdp_xmit,
 	.ndo_bpf		= efx_xdp
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index a4f9e6e962b0..18099bb21f61 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -78,7 +78,7 @@ static inline bool efx_rss_enabled(struct efx_nic *efx)
  *
  * 2. If the existing filters have higher priority, return -%EPERM.
  *
- * 3. If !efx_filter_is_mc_recipient(@spec), or the NIC does not
+ * 3. If !efx_siena_filter_is_mc_recipient(@spec), or the NIC does not
  *    support delivery to multiple recipients, return -%EEXIST.
  *
  * This implies that filters for multiple multicast recipients must
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 0c261a2f0f96..bc17d8e7c6bc 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -521,7 +521,8 @@ static void efx_filter_rfs_expire(struct work_struct *data)
 	channel = container_of(dwork, struct efx_channel, filter_work);
 	time = jiffies - channel->rfs_last_expiry;
 	quota = channel->rfs_filter_count * time / (30 * HZ);
-	if (quota >= 20 && __efx_filter_rfs_expire(channel, min(channel->rfs_filter_count, quota)))
+	if (quota >= 20 && __efx_siena_filter_rfs_expire(channel,
+					min(channel->rfs_filter_count, quota)))
 		channel->rfs_last_expiry += time;
 	/* Ensure we do more work eventually even if NAPI poll is not happening */
 	schedule_delayed_work(dwork, 30 * HZ);
@@ -558,7 +559,7 @@ static struct efx_channel *efx_alloc_channel(struct efx_nic *efx, int i)
 
 	rx_queue = &channel->rx_queue;
 	rx_queue->efx = efx;
-	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
+	timer_setup(&rx_queue->slow_fill, efx_siena_rx_slow_fill, 0);
 
 	return channel;
 }
@@ -631,7 +632,7 @@ struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 	rx_queue = &channel->rx_queue;
 	rx_queue->buffer = NULL;
 	memset(&rx_queue->rxd, 0, sizeof(rx_queue->rxd));
-	timer_setup(&rx_queue->slow_fill, efx_rx_slow_fill, 0);
+	timer_setup(&rx_queue->slow_fill, efx_siena_rx_slow_fill, 0);
 #ifdef CONFIG_RFS_ACCEL
 	INIT_DELAYED_WORK(&channel->filter_work, efx_filter_rfs_expire);
 #endif
@@ -663,7 +664,7 @@ static int efx_probe_channel(struct efx_channel *channel)
 	}
 
 	efx_for_each_channel_rx_queue(rx_queue, channel) {
-		rc = efx_probe_rx_queue(rx_queue);
+		rc = efx_siena_probe_rx_queue(rx_queue);
 		if (rc)
 			goto fail;
 	}
@@ -751,7 +752,7 @@ void efx_siena_remove_channel(struct efx_channel *channel)
 		  "destroy chan %d\n", channel->channel);
 
 	efx_for_each_channel_rx_queue(rx_queue, channel)
-		efx_remove_rx_queue(rx_queue);
+		efx_siena_remove_rx_queue(rx_queue);
 	efx_for_each_channel_tx_queue(tx_queue, channel)
 		efx_remove_tx_queue(tx_queue);
 	efx_remove_eventq(channel);
@@ -1119,10 +1120,10 @@ void efx_siena_start_channels(struct efx_nic *efx)
 		}
 
 		efx_for_each_channel_rx_queue(rx_queue, channel) {
-			efx_init_rx_queue(rx_queue);
+			efx_siena_init_rx_queue(rx_queue);
 			atomic_inc(&efx->active_queues);
 			efx_siena_stop_eventq(channel);
-			efx_fast_push_rx_descriptors(rx_queue, false);
+			efx_siena_fast_push_rx_descriptors(rx_queue, false);
 			efx_siena_start_eventq(channel);
 		}
 
@@ -1168,7 +1169,7 @@ void efx_siena_stop_channels(struct efx_nic *efx)
 
 	efx_for_each_channel(channel, efx) {
 		efx_for_each_channel_rx_queue(rx_queue, channel)
-			efx_fini_rx_queue(rx_queue);
+			efx_siena_fini_rx_queue(rx_queue);
 		efx_for_each_channel_tx_queue(tx_queue, channel)
 			efx_fini_tx_queue(tx_queue);
 	}
@@ -1212,7 +1213,7 @@ static int efx_process_channel(struct efx_channel *channel, int budget)
 			efx_channel_get_rx_queue(channel);
 
 		efx_rx_flush_packet(channel);
-		efx_fast_push_rx_descriptors(rx_queue, true);
+		efx_siena_fast_push_rx_descriptors(rx_queue, true);
 	}
 
 	/* Update BQL */
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index fb6fb345cc56..e12083d28a47 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -395,7 +395,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 		efx->rx_buffer_order = get_order(rx_buf_len);
 	}
 
-	efx_rx_config_page_split(efx);
+	efx_siena_rx_config_page_split(efx);
 	if (efx->rx_buffer_order)
 		netif_dbg(efx, drv, efx->net_dev,
 			  "RX buf len=%u; page order=%u batch=%u\n",
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index e177b58e0664..f54510cf4e72 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -824,7 +824,8 @@ int efx_ethtool_get_rxnfc(struct net_device *net_dev,
 
 		mutex_lock(&efx->rss_lock);
 		if (info->flow_type & FLOW_RSS && info->rss_context) {
-			ctx = efx_find_rss_context_entry(efx, info->rss_context);
+			ctx = efx_siena_find_rss_context_entry(efx,
+							info->rss_context);
 			if (!ctx) {
 				rc = -ENOENT;
 				goto out_unlock;
@@ -1213,7 +1214,7 @@ int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
 		return -EOPNOTSUPP;
 
 	mutex_lock(&efx->rss_lock);
-	ctx = efx_find_rss_context_entry(efx, rss_context);
+	ctx = efx_siena_find_rss_context_entry(efx, rss_context);
 	if (!ctx) {
 		rc = -ENOENT;
 		goto out_unlock;
@@ -1257,18 +1258,18 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 			rc = -EINVAL;
 			goto out_unlock;
 		}
-		ctx = efx_alloc_rss_context_entry(efx);
+		ctx = efx_siena_alloc_rss_context_entry(efx);
 		if (!ctx) {
 			rc = -ENOMEM;
 			goto out_unlock;
 		}
 		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		/* Initialise indir table and key to defaults */
-		efx_set_default_rx_indir_table(efx, ctx);
+		efx_siena_set_default_rx_indir_table(efx, ctx);
 		netdev_rss_key_fill(ctx->rx_hash_key, sizeof(ctx->rx_hash_key));
 		allocated = true;
 	} else {
-		ctx = efx_find_rss_context_entry(efx, *rss_context);
+		ctx = efx_siena_find_rss_context_entry(efx, *rss_context);
 		if (!ctx) {
 			rc = -ENOENT;
 			goto out_unlock;
@@ -1279,7 +1280,7 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 		/* delete this context */
 		rc = efx->type->rx_push_rss_context_config(efx, ctx, NULL, NULL);
 		if (!rc)
-			efx_free_rss_context_entry(ctx);
+			efx_siena_free_rss_context_entry(ctx);
 		goto out_unlock;
 	}
 
@@ -1290,7 +1291,7 @@ int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 
 	rc = efx->type->rx_push_rss_context_config(efx, ctx, indir, key);
 	if (rc && allocated)
-		efx_free_rss_context_entry(ctx);
+		efx_siena_free_rss_context_entry(ctx);
 	else
 		*rss_context = ctx->user_id;
 out_unlock:
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 6ee6ca192a44..4de36c6c28e1 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -1160,7 +1160,7 @@ static void efx_farch_handle_generated_event(struct efx_channel *channel,
 		/* The queue must be empty, so we won't receive any rx
 		 * events, so efx_process_channel() won't refill the
 		 * queue. Refill it here */
-		efx_fast_push_rx_descriptors(rx_queue, true);
+		efx_siena_fast_push_rx_descriptors(rx_queue, true);
 	} else if (rx_queue && magic == EFX_CHANNEL_MAGIC_RX_DRAIN(rx_queue)) {
 		efx_farch_handle_drain_event(channel);
 	} else if (code == _EFX_CHANNEL_MAGIC_TX_DRAIN) {
@@ -2925,13 +2925,14 @@ bool efx_farch_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 			 */
 			arfs_id = 0;
 		} else {
-			rule = efx_rps_hash_find(efx, &spec);
+			rule = efx_siena_rps_hash_find(efx, &spec);
 			if (!rule) {
 				/* ARFS table doesn't know of this filter, remove it */
 				force = true;
 			} else {
 				arfs_id = rule->arfs_id;
-				if (!efx_rps_check_rule(rule, index, &force))
+				if (!efx_siena_rps_check_rule(rule, index,
+							      &force))
 					goto out_unlock;
 			}
 		}
@@ -2939,7 +2940,7 @@ bool efx_farch_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 						 flow_id, arfs_id)) {
 			if (rule)
 				rule->filter_id = EFX_ARFS_FILTER_ID_REMOVING;
-			efx_rps_hash_del(efx, &spec);
+			efx_siena_rps_hash_del(efx, &spec);
 			efx_farch_filter_table_clear_entry(efx, table, index);
 			ret = true;
 		}
diff --git a/drivers/net/ethernet/sfc/siena/rx.c b/drivers/net/ethernet/sfc/siena/rx.c
index 099cb23e3250..47c09b93f7c4 100644
--- a/drivers/net/ethernet/sfc/siena/rx.c
+++ b/drivers/net/ethernet/sfc/siena/rx.c
@@ -157,7 +157,7 @@ void efx_siena_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 	 */
 	if (unlikely(rx_buf->flags & EFX_RX_PKT_DISCARD)) {
 		efx_rx_flush_packet(channel);
-		efx_discard_rx_packet(channel, rx_buf, n_frags);
+		efx_siena_discard_rx_packet(channel, rx_buf, n_frags);
 		return;
 	}
 
@@ -195,7 +195,7 @@ void efx_siena_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 
 	/* All fragments have been DMA-synced, so recycle pages. */
 	rx_buf = efx_rx_buffer(rx_queue, index);
-	efx_recycle_rx_pages(channel, rx_buf, n_frags);
+	efx_siena_recycle_rx_pages(channel, rx_buf, n_frags);
 
 	/* Pipeline receives so that we give time for packet headers to be
 	 * prefetched into cache.
@@ -217,7 +217,7 @@ static void efx_rx_deliver(struct efx_channel *channel, u8 *eh,
 		struct efx_rx_queue *rx_queue;
 
 		rx_queue = efx_channel_get_rx_queue(channel);
-		efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf, n_frags);
 		return;
 	}
 	skb_record_rx_queue(skb, channel->rx_queue.core_index);
@@ -268,8 +268,8 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 
 	if (unlikely(channel->rx_pkt_n_frags > 1)) {
 		/* We can't do XDP on fragmented packets - drop. */
-		efx_free_rx_buffers(rx_queue, rx_buf,
-				    channel->rx_pkt_n_frags);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf,
+					  channel->rx_pkt_n_frags);
 		if (net_ratelimit())
 			netif_err(efx, rx_err, efx->net_dev,
 				  "XDP is not possible with multiple receive fragments (%d)\n",
@@ -312,7 +312,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		xdpf = xdp_convert_buff_to_frame(&xdp);
 		err = efx_siena_xdp_tx_buffers(efx, 1, &xdpf, true);
 		if (unlikely(err != 1)) {
-			efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			efx_siena_free_rx_buffers(rx_queue, rx_buf, 1);
 			if (net_ratelimit())
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP TX failed (%d)\n", err);
@@ -326,7 +326,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
 		if (unlikely(err)) {
-			efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			efx_siena_free_rx_buffers(rx_queue, rx_buf, 1);
 			if (net_ratelimit())
 				netif_err(efx, rx_err, efx->net_dev,
 					  "XDP redirect failed (%d)\n", err);
@@ -339,7 +339,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 
 	default:
 		bpf_warn_invalid_xdp_action(efx->net_dev, xdp_prog, xdp_act);
-		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf, 1);
 		channel->n_rx_xdp_bad_drops++;
 		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		break;
@@ -348,7 +348,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
 		fallthrough;
 	case XDP_DROP:
-		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf, 1);
 		channel->n_rx_xdp_drops++;
 		break;
 	}
@@ -379,8 +379,8 @@ void __efx_siena_rx_packet(struct efx_channel *channel)
 
 		efx_loopback_rx_packet(efx, eh, rx_buf->len);
 		rx_queue = efx_channel_get_rx_queue(channel);
-		efx_free_rx_buffers(rx_queue, rx_buf,
-				    channel->rx_pkt_n_frags);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf,
+					  channel->rx_pkt_n_frags);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.c b/drivers/net/ethernet/sfc/siena/rx_common.c
index d737c7c5b2ab..ccf0bde01ba3 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.c
+++ b/drivers/net/ethernet/sfc/siena/rx_common.c
@@ -30,6 +30,9 @@ MODULE_PARM_DESC(rx_refill_threshold,
  */
 #define EFX_RXD_HEAD_ROOM (1 + EFX_RX_MAX_FRAGS)
 
+static void efx_unmap_rx_buffer(struct efx_nic *efx,
+				struct efx_rx_buffer *rx_buf);
+
 /* Check the RX page recycle ring for a page that can be reused. */
 static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
 {
@@ -103,9 +106,9 @@ static void efx_recycle_rx_page(struct efx_channel *channel,
 }
 
 /* Recycle the pages that are used by buffers that have just been received. */
-void efx_recycle_rx_pages(struct efx_channel *channel,
-			  struct efx_rx_buffer *rx_buf,
-			  unsigned int n_frags)
+void efx_siena_recycle_rx_pages(struct efx_channel *channel,
+				struct efx_rx_buffer *rx_buf,
+				unsigned int n_frags)
 {
 	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
 
@@ -118,15 +121,15 @@ void efx_recycle_rx_pages(struct efx_channel *channel,
 	} while (--n_frags);
 }
 
-void efx_discard_rx_packet(struct efx_channel *channel,
-			   struct efx_rx_buffer *rx_buf,
-			   unsigned int n_frags)
+void efx_siena_discard_rx_packet(struct efx_channel *channel,
+				 struct efx_rx_buffer *rx_buf,
+				 unsigned int n_frags)
 {
 	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
 
-	efx_recycle_rx_pages(channel, rx_buf, n_frags);
+	efx_siena_recycle_rx_pages(channel, rx_buf, n_frags);
 
-	efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
+	efx_siena_free_rx_buffers(rx_queue, rx_buf, n_frags);
 }
 
 static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
@@ -178,12 +181,12 @@ static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 	/* If this is the last buffer in a page, unmap and free it. */
 	if (rx_buf->flags & EFX_RX_BUF_LAST_IN_PAGE) {
 		efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
-		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf, 1);
 	}
 	rx_buf->page = NULL;
 }
 
-int efx_probe_rx_queue(struct efx_rx_queue *rx_queue)
+int efx_siena_probe_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	unsigned int entries;
@@ -214,7 +217,7 @@ int efx_probe_rx_queue(struct efx_rx_queue *rx_queue)
 	return rc;
 }
 
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
+void efx_siena_init_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	unsigned int max_fill, trigger, max_trigger;
 	struct efx_nic *efx = rx_queue->efx;
@@ -269,7 +272,7 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 	efx_nic_init_rx(rx_queue);
 }
 
-void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
+void efx_siena_fini_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	struct efx_rx_buffer *rx_buf;
 	int i;
@@ -298,7 +301,7 @@ void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 	rx_queue->xdp_rxq_info_valid = false;
 }
 
-void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
+void efx_siena_remove_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
 		  "destroying RX queue %d\n", efx_rx_queue_index(rx_queue));
@@ -312,8 +315,8 @@ void efx_remove_rx_queue(struct efx_rx_queue *rx_queue)
 /* Unmap a DMA-mapped page.  This function is only called for the final RX
  * buffer in a page.
  */
-void efx_unmap_rx_buffer(struct efx_nic *efx,
-			 struct efx_rx_buffer *rx_buf)
+static void efx_unmap_rx_buffer(struct efx_nic *efx,
+				struct efx_rx_buffer *rx_buf)
 {
 	struct page *page = rx_buf->page;
 
@@ -327,9 +330,9 @@ void efx_unmap_rx_buffer(struct efx_nic *efx,
 	}
 }
 
-void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
-			 struct efx_rx_buffer *rx_buf,
-			 unsigned int num_bufs)
+void efx_siena_free_rx_buffers(struct efx_rx_queue *rx_queue,
+			       struct efx_rx_buffer *rx_buf,
+			       unsigned int num_bufs)
 {
 	do {
 		if (rx_buf->page) {
@@ -340,7 +343,7 @@ void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
 	} while (--num_bufs);
 }
 
-void efx_rx_slow_fill(struct timer_list *t)
+void efx_siena_rx_slow_fill(struct timer_list *t)
 {
 	struct efx_rx_queue *rx_queue = from_timer(rx_queue, t, slow_fill);
 
@@ -349,7 +352,7 @@ void efx_rx_slow_fill(struct timer_list *t)
 	++rx_queue->slow_fill_count;
 }
 
-void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
+static void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue)
 {
 	mod_timer(&rx_queue->slow_fill, jiffies + msecs_to_jiffies(10));
 }
@@ -422,7 +425,7 @@ static int efx_init_rx_buffers(struct efx_rx_queue *rx_queue, bool atomic)
 	return 0;
 }
 
-void efx_rx_config_page_split(struct efx_nic *efx)
+void efx_siena_rx_config_page_split(struct efx_nic *efx)
 {
 	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align +
 				      EFX_XDP_HEADROOM + EFX_XDP_TAILROOM,
@@ -436,7 +439,7 @@ void efx_rx_config_page_split(struct efx_nic *efx)
 					       efx->rx_bufs_per_page);
 }
 
-/* efx_fast_push_rx_descriptors - push new RX descriptors quickly
+/* efx_siena_fast_push_rx_descriptors - push new RX descriptors quickly
  * @rx_queue:		RX descriptor queue
  *
  * This will aim to fill the RX descriptor queue up to
@@ -447,7 +450,8 @@ void efx_rx_config_page_split(struct efx_nic *efx)
  * this means this function must run from the NAPI handler, or be called
  * when NAPI is disabled.
  */
-void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
+void efx_siena_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue,
+					bool atomic)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	unsigned int fill_level, batch_size;
@@ -514,7 +518,7 @@ efx_siena_rx_packet_gro(struct efx_channel *channel,
 		struct efx_rx_queue *rx_queue;
 
 		rx_queue = efx_channel_get_rx_queue(channel);
-		efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
+		efx_siena_free_rx_buffers(rx_queue, rx_buf, n_frags);
 		return;
 	}
 
@@ -553,7 +557,7 @@ efx_siena_rx_packet_gro(struct efx_channel *channel,
 /* RSS contexts.  We're using linked lists and crappy O(n) algorithms, because
  * (a) this is an infrequent control-plane operation and (b) n is small (max 64)
  */
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
+struct efx_rss_context *efx_siena_alloc_rss_context_entry(struct efx_nic *efx)
 {
 	struct list_head *head = &efx->rss_context.list;
 	struct efx_rss_context *ctx, *new;
@@ -586,7 +590,8 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 	return new;
 }
 
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id)
+struct efx_rss_context *efx_siena_find_rss_context_entry(struct efx_nic *efx,
+							 u32 id)
 {
 	struct list_head *head = &efx->rss_context.list;
 	struct efx_rss_context *ctx;
@@ -599,14 +604,14 @@ struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id)
 	return NULL;
 }
 
-void efx_free_rss_context_entry(struct efx_rss_context *ctx)
+void efx_siena_free_rss_context_entry(struct efx_rss_context *ctx)
 {
 	list_del(&ctx->list);
 	kfree(ctx);
 }
 
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx)
+void efx_siena_set_default_rx_indir_table(struct efx_nic *efx,
+					  struct efx_rss_context *ctx)
 {
 	size_t i;
 
@@ -616,7 +621,7 @@ void efx_set_default_rx_indir_table(struct efx_nic *efx,
 }
 
 /**
- * efx_filter_is_mc_recipient - test whether spec is a multicast recipient
+ * efx_siena_filter_is_mc_recipient - test whether spec is a multicast recipient
  * @spec: Specification to test
  *
  * Return: %true if the specification is a non-drop RX filter that
@@ -624,7 +629,7 @@ void efx_set_default_rx_indir_table(struct efx_nic *efx,
  * IPv4 or IPv6 address value in the respective multicast address
  * range.  Otherwise %false.
  */
-bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec)
+bool efx_siena_filter_is_mc_recipient(const struct efx_filter_spec *spec)
 {
 	if (!(spec->flags & EFX_FILTER_FLAG_RX) ||
 	    spec->dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP)
@@ -649,8 +654,8 @@ bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec)
 	return false;
 }
 
-bool efx_filter_spec_equal(const struct efx_filter_spec *left,
-			   const struct efx_filter_spec *right)
+bool efx_siena_filter_spec_equal(const struct efx_filter_spec *left,
+				 const struct efx_filter_spec *right)
 {
 	if ((left->match_flags ^ right->match_flags) |
 	    ((left->flags ^ right->flags) &
@@ -662,7 +667,7 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
 		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
 }
 
-u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
+u32 efx_siena_filter_spec_hash(const struct efx_filter_spec *spec)
 {
 	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
 	return jhash2((const u32 *)&spec->outer_vid,
@@ -672,8 +677,8 @@ u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
 }
 
 #ifdef CONFIG_RFS_ACCEL
-bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
-			bool *force)
+bool efx_siena_rps_check_rule(struct efx_arfs_rule *rule,
+			      unsigned int filter_idx, bool *force)
 {
 	if (rule->filter_id == EFX_ARFS_FILTER_ID_PENDING) {
 		/* ARFS is currently updating this entry, leave it */
@@ -689,7 +694,7 @@ bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
 	} else if (WARN_ON(rule->filter_id != filter_idx)) { /* can't happen */
 		/* ARFS has moved on, so old filter is not needed.  Since we did
 		 * not mark the rule with EFX_ARFS_FILTER_ID_REMOVING, it will
-		 * not be removed by efx_rps_hash_del() subsequently.
+		 * not be removed by efx_siena_rps_hash_del() subsequently.
 		 */
 		*force = true;
 		return true;
@@ -702,7 +707,7 @@ static
 struct hlist_head *efx_rps_hash_bucket(struct efx_nic *efx,
 				       const struct efx_filter_spec *spec)
 {
-	u32 hash = efx_filter_spec_hash(spec);
+	u32 hash = efx_siena_filter_spec_hash(spec);
 
 	lockdep_assert_held(&efx->rps_hash_lock);
 	if (!efx->rps_hash_table)
@@ -710,7 +715,7 @@ struct hlist_head *efx_rps_hash_bucket(struct efx_nic *efx,
 	return &efx->rps_hash_table[hash % EFX_ARFS_HASH_TABLE_SIZE];
 }
 
-struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
+struct efx_arfs_rule *efx_siena_rps_hash_find(struct efx_nic *efx,
 					const struct efx_filter_spec *spec)
 {
 	struct efx_arfs_rule *rule;
@@ -722,15 +727,15 @@ struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
 		return NULL;
 	hlist_for_each(node, head) {
 		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec))
+		if (efx_siena_filter_spec_equal(spec, &rule->spec))
 			return rule;
 	}
 	return NULL;
 }
 
-struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
-				       const struct efx_filter_spec *spec,
-				       bool *new)
+static struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
+					const struct efx_filter_spec *spec,
+					bool *new)
 {
 	struct efx_arfs_rule *rule;
 	struct hlist_head *head;
@@ -741,7 +746,7 @@ struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
 		return NULL;
 	hlist_for_each(node, head) {
 		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec)) {
+		if (efx_siena_filter_spec_equal(spec, &rule->spec)) {
 			*new = false;
 			return rule;
 		}
@@ -755,7 +760,8 @@ struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
 	return rule;
 }
 
-void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
+void efx_siena_rps_hash_del(struct efx_nic *efx,
+			    const struct efx_filter_spec *spec)
 {
 	struct efx_arfs_rule *rule;
 	struct hlist_head *head;
@@ -766,7 +772,7 @@ void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
 		return;
 	hlist_for_each(node, head) {
 		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec)) {
+		if (efx_siena_filter_spec_equal(spec, &rule->spec)) {
 			/* Someone already reused the entry.  We know that if
 			 * this check doesn't fire (i.e. filter_id == REMOVING)
 			 * then the REMOVING mark was put there by our caller,
@@ -785,7 +791,7 @@ void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
 }
 #endif
 
-int efx_probe_filters(struct efx_nic *efx)
+int efx_siena_probe_filters(struct efx_nic *efx)
 {
 	int rc;
 
@@ -832,7 +838,7 @@ int efx_probe_filters(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_remove_filters(struct efx_nic *efx)
+void efx_siena_remove_filters(struct efx_nic *efx)
 {
 #ifdef CONFIG_RFS_ACCEL
 	struct efx_channel *channel;
@@ -867,7 +873,7 @@ static void efx_filter_rfs_work(struct work_struct *data)
 		rc %= efx->type->max_rx_ip_filters;
 	if (efx->rps_hash_table) {
 		spin_lock_bh(&efx->rps_hash_lock);
-		rule = efx_rps_hash_find(efx, &req->spec);
+		rule = efx_siena_rps_hash_find(efx, &req->spec);
 		/* The rule might have already gone, if someone else's request
 		 * for the same spec was already worked and then expired before
 		 * we got around to our work.  In that case we have nothing
@@ -927,8 +933,9 @@ static void efx_filter_rfs_work(struct work_struct *data)
 		/* We're overloading the NIC's filter tables, so let's do a
 		 * chunk of extra expiry work.
 		 */
-		__efx_filter_rfs_expire(channel, min(channel->rfs_filter_count,
-						     100u));
+		__efx_siena_filter_rfs_expire(channel,
+					      min(channel->rfs_filter_count,
+						  100u));
 	}
 
 	/* Release references */
@@ -936,8 +943,8 @@ static void efx_filter_rfs_work(struct work_struct *data)
 	dev_put(req->net_dev);
 }
 
-int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
-		   u16 rxq_index, u32 flow_id)
+int efx_siena_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
+			 u16 rxq_index, u32 flow_id)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_async_filter_insertion *req;
@@ -1038,7 +1045,8 @@ int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	return rc;
 }
 
-bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
+bool __efx_siena_filter_rfs_expire(struct efx_channel *channel,
+				   unsigned int quota)
 {
 	bool (*expire_one)(struct efx_nic *efx, u32 flow_id, unsigned int index);
 	struct efx_nic *efx = channel->efx;
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.h b/drivers/net/ethernet/sfc/siena/rx_common.h
index 909d06a4fdc9..6b37f83ecb30 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.h
+++ b/drivers/net/ethernet/sfc/siena/rx_common.h
@@ -43,26 +43,19 @@ static inline u32 efx_rx_buf_hash(struct efx_nic *efx, const u8 *eh)
 #endif
 }
 
-void efx_rx_slow_fill(struct timer_list *t);
-
-void efx_recycle_rx_pages(struct efx_channel *channel,
-			  struct efx_rx_buffer *rx_buf,
-			  unsigned int n_frags);
-void efx_discard_rx_packet(struct efx_channel *channel,
-			   struct efx_rx_buffer *rx_buf,
-			   unsigned int n_frags);
-
-int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_fini_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_remove_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_destroy_rx_queue(struct efx_rx_queue *rx_queue);
-
-void efx_init_rx_buffer(struct efx_rx_queue *rx_queue,
-			struct page *page,
-			unsigned int page_offset,
-			u16 flags);
-void efx_unmap_rx_buffer(struct efx_nic *efx, struct efx_rx_buffer *rx_buf);
+void efx_siena_rx_slow_fill(struct timer_list *t);
+
+void efx_siena_recycle_rx_pages(struct efx_channel *channel,
+				struct efx_rx_buffer *rx_buf,
+				unsigned int n_frags);
+void efx_siena_discard_rx_packet(struct efx_channel *channel,
+				 struct efx_rx_buffer *rx_buf,
+				 unsigned int n_frags);
+
+int efx_siena_probe_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_siena_init_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_siena_fini_rx_queue(struct efx_rx_queue *rx_queue);
+void efx_siena_remove_rx_queue(struct efx_rx_queue *rx_queue);
 
 static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				      struct efx_rx_buffer *rx_buf,
@@ -72,46 +65,46 @@ static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				DMA_FROM_DEVICE);
 }
 
-void efx_free_rx_buffers(struct efx_rx_queue *rx_queue,
-			 struct efx_rx_buffer *rx_buf,
-			 unsigned int num_bufs);
+void efx_siena_free_rx_buffers(struct efx_rx_queue *rx_queue,
+			       struct efx_rx_buffer *rx_buf,
+			       unsigned int num_bufs);
 
-void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue);
-void efx_rx_config_page_split(struct efx_nic *efx);
-void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
+void efx_siena_rx_config_page_split(struct efx_nic *efx);
+void efx_siena_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue,
+					bool atomic);
 
 void
 efx_siena_rx_packet_gro(struct efx_channel *channel,
 			struct efx_rx_buffer *rx_buf,
 			unsigned int n_frags, u8 *eh, __wsum csum);
 
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
-void efx_free_rss_context_entry(struct efx_rss_context *ctx);
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx);
+struct efx_rss_context *efx_siena_alloc_rss_context_entry(struct efx_nic *efx);
+struct efx_rss_context *efx_siena_find_rss_context_entry(struct efx_nic *efx,
+							 u32 id);
+void efx_siena_free_rss_context_entry(struct efx_rss_context *ctx);
+void efx_siena_set_default_rx_indir_table(struct efx_nic *efx,
+					  struct efx_rss_context *ctx);
 
-bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec);
-bool efx_filter_spec_equal(const struct efx_filter_spec *left,
-			   const struct efx_filter_spec *right);
-u32 efx_filter_spec_hash(const struct efx_filter_spec *spec);
+bool efx_siena_filter_is_mc_recipient(const struct efx_filter_spec *spec);
+bool efx_siena_filter_spec_equal(const struct efx_filter_spec *left,
+				 const struct efx_filter_spec *right);
+u32 efx_siena_filter_spec_hash(const struct efx_filter_spec *spec);
 
 #ifdef CONFIG_RFS_ACCEL
-bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
-			bool *force);
-struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
+bool efx_siena_rps_check_rule(struct efx_arfs_rule *rule,
+			      unsigned int filter_idx, bool *force);
+struct efx_arfs_rule *efx_siena_rps_hash_find(struct efx_nic *efx,
 					const struct efx_filter_spec *spec);
-struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
-				       const struct efx_filter_spec *spec,
-				       bool *new);
-void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec);
-
-int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
-		   u16 rxq_index, u32 flow_id);
-bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
+void efx_siena_rps_hash_del(struct efx_nic *efx,
+			    const struct efx_filter_spec *spec);
+
+int efx_siena_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
+			 u16 rxq_index, u32 flow_id);
+bool __efx_siena_filter_rfs_expire(struct efx_channel *channel,
+				   unsigned int quota);
 #endif
 
-int efx_probe_filters(struct efx_nic *efx);
-void efx_remove_filters(struct efx_nic *efx);
+int efx_siena_probe_filters(struct efx_nic *efx);
+void efx_siena_remove_filters(struct efx_nic *efx);
 
 #endif

