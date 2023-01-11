Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD31665C31
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjAKNN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjAKNNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:13:17 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1FA1A078
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:16 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ja17so11062876wmb.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5XI6O5OGOUi65kKyM2uI+qDJhHK/8TPexHTOPEJ1Oxg=;
        b=p4xjPM9yySTOOuC7d7oHUOGlSiTJhnYcHGgn9hcBQuRLwmEj0HP0ZH9fS3OwEio26q
         mjKH2WmkRtLvY6bicOBjj4cTxVFpZ+gIMDxHYbHk/S8BcVNQZuBUL9PgL/xDQ7mEBU/j
         sCdfV8YDWKYYzseOvaSuQHznUdKC4ipQKayqmWDnKgl/0wGsHbMdOupN+sqKHJfrhaA7
         q9rBiCIUd6rUgYs/gH9TrNfbwbI00o78S8ebkwil8WV1a0X3GAAQIeeSEDB2eCLBW++q
         YAFgXhktqtslwGC6ZBQqzzXVnjxYwT0gjveAvvUJWr0xk8SJqeNadHviTBQ/mf/JuWUs
         QolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5XI6O5OGOUi65kKyM2uI+qDJhHK/8TPexHTOPEJ1Oxg=;
        b=JquP+xLSmv2pDbSY6yGQeyxhILYdovdMRVkmBTGRLdBmgAmLDekluSpBn874N9DXit
         ZH4P6Cjbo5amyts1EtFzOziPGx+xipJLj2YqzIfP2N7NI90DtPjxb4nuW8RZrox6cyXl
         H9aa24yW2SydjKj2Jmx9QElNCRBuWgwc+C2/MrVCM9dXUvYGOd9dWGJaL3GuOh82R5c4
         mfPddclIlUguhQ7VyBkEyM12ewGPqbz19BTqsUJvd4dVy6Kxr/A+sAuK2Q2Tld6F4vuI
         AYnQ2wv7YX7Kuz7qeNL8uQOZCey4sCkSgpOcBgCZjPEhgc3PKITBPSGW8H57lkthlD4u
         ty8A==
X-Gm-Message-State: AFqh2kpYnlkPfJf1bss3uKlk8EDmnVl0TN9+UOy/N5i3MIBaMZ1EbfYa
        e1rUDYYCehjfW4gGrGz6iLU=
X-Google-Smtp-Source: AMrXdXscyxsf3u5r6L6UYu7QUyLbQEOfzOKU1TZwHMHGos6xuRT2Lz8ZUUcp+Cg/nw43extXeZKfWQ==
X-Received: by 2002:a05:600c:a10:b0:3d5:64bf:ccb8 with SMTP id z16-20020a05600c0a1000b003d564bfccb8mr52248719wmp.12.1673442794328;
        Wed, 11 Jan 2023 05:13:14 -0800 (PST)
Received: from ThinkStation-P340.tmt.telital.com ([2a01:7d0:4800:7:4ce:b9aa:c77:7d5e])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c3b0700b003cfd4cf0761sm25796521wms.1.2023.01.11.05.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:13:14 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v4 2/3] net: qualcomm: rmnet: add tx packets aggregation
Date:   Wed, 11 Jan 2023 14:05:19 +0100
Message-Id: <20230111130520.483222-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230111130520.483222-1-dnlplm@gmail.com>
References: <20230111130520.483222-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tx packets aggregation.

Bidirectional TCP throughput tests through iperf with low-cat
Thread-x based modems revelead performance issues both in tx
and rx.

The Windows driver does not show this issue: inspecting USB
packets revealed that the only notable change is the driver
enabling tx packets aggregation.

Tx packets aggregation is by default disabled and can be enabled
by increasing the value of ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES.

The maximum aggregated size is by default set to a reasonably low
value in order to support the majority of modems.

This implementation is based on patches available in Code Aurora
repositories (msm kernel) whose main authors are

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Sean Tranchetti <stranche@codeaurora.org>

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hi all,

in v4 I should have met all Paolo's remarks, besides the one related
to removing the scheduled work, since according to my understanding
of the code in dev_queue_xmit it's not possible to avoid the
WARN_ONCE when called directly from the timer function.

Context at https://lore.kernel.org/netdev/CAGRyCJGHSPO+i_xKHGbNg+Hki5tQC3_6Kc8RNcHWN6pxQdjODw@mail.gmail.com/

v4
- Solved race when accessing egress_agg_params
- Removed duplicated code for error in rmnet_map_tx_aggregate
v3
- Fixed no previous prototype for rmnet_map_flush_tx_packet_queue
  warning reported by kernel test robot
v2
- Removed icmp packets direct sending
- Changed spin_lock_irqsave to spin_lock_bh
- Increased the possible maximum size of an aggregated block
- Aligned rmnet_egress_agg_params and types to ethtool ones
- Changed bypass time from variable to define
- Fixed RCT style in rmnet_map_tx_aggregate
- Fixed order of skb freeing in rmnet_map_tx_aggregate
- rmnet_map_tx_aggregate refactoring
- Change aggregation function to use frag_list
- Removed RMNET_FLAGS_EGRESS_AGGREGATION
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  20 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  18 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   6 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 191 ++++++++++++++++++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   9 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 +
 7 files changed, 246 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 27b1663c476e..39d24e07f306 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -12,6 +12,7 @@
 #include "rmnet_handlers.h"
 #include "rmnet_vnd.h"
 #include "rmnet_private.h"
+#include "rmnet_map.h"
 
 /* Local Definitions and Declarations */
 
@@ -39,6 +40,8 @@ static int rmnet_unregister_real_device(struct net_device *real_dev)
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
+	rmnet_map_tx_aggregate_exit(port);
+
 	netdev_rx_handler_unregister(real_dev);
 
 	kfree(port);
@@ -79,6 +82,8 @@ static int rmnet_register_real_device(struct net_device *real_dev,
 	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
 		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
 
+	rmnet_map_tx_aggregate_init(port);
+
 	netdev_dbg(real_dev, "registered with rmnet\n");
 	return 0;
 }
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 3d3cba56c516..ed112d51ac5a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -6,6 +6,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <linux/time.h>
 #include <net/gro_cells.h>
 
 #ifndef _RMNET_CONFIG_H_
@@ -19,6 +20,12 @@ struct rmnet_endpoint {
 	struct hlist_node hlnode;
 };
 
+struct rmnet_egress_agg_params {
+	u32 bytes;
+	u32 count;
+	u64 time_nsec;
+};
+
 /* One instance of this structure is instantiated for each real_dev associated
  * with rmnet.
  */
@@ -30,6 +37,19 @@ struct rmnet_port {
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
 	struct net_device *rmnet_dev;
+
+	/* Egress aggregation information */
+	struct rmnet_egress_agg_params egress_agg_params;
+	/* Protect aggregation related elements */
+	spinlock_t agg_lock;
+	struct sk_buff *skbagg_head;
+	struct sk_buff *skbagg_tail;
+	int agg_state;
+	u8 agg_count;
+	struct timespec64 agg_time;
+	struct timespec64 agg_last;
+	struct hrtimer hrtimer;
+	struct work_struct agg_wq;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index a313242a762e..9f3479500f85 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -164,8 +164,18 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 
 	map_header->mux_id = mux_id;
 
-	skb->protocol = htons(ETH_P_MAP);
+	if (READ_ONCE(port->egress_agg_params.count) > 1) {
+		unsigned int len;
+
+		len = rmnet_map_tx_aggregate(skb, port, orig_dev);
+		if (likely(len)) {
+			rmnet_vnd_tx_fixup_len(len, orig_dev);
+			return -EINPROGRESS;
+		}
+		return -ENOMEM;
+	}
 
+	skb->protocol = htons(ETH_P_MAP);
 	return 0;
 }
 
@@ -235,6 +245,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	struct rmnet_port *port;
 	struct rmnet_priv *priv;
 	u8 mux_id;
+	int err;
 
 	sk_pacing_shift_update(skb->sk, 8);
 
@@ -247,8 +258,11 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	if (!port)
 		goto drop;
 
-	if (rmnet_map_egress_handler(skb, port, mux_id, orig_dev))
+	err = rmnet_map_egress_handler(skb, port, mux_id, orig_dev);
+	if (err == -ENOMEM)
 		goto drop;
+	else if (err == -EINPROGRESS)
+		return;
 
 	rmnet_vnd_tx_fixup(skb, orig_dev);
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 2b033060fc20..b70284095568 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -53,5 +53,11 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 				      struct net_device *orig_dev,
 				      int csum_type);
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
+unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+				    struct net_device *orig_dev);
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port);
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port);
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u32 size,
+				    u32 count, u32 time);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ba194698cc14..a5e3d1a88305 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -12,6 +12,7 @@
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
+#include "rmnet_vnd.h"
 
 #define RMNET_MAP_DEAGGR_SPACING  64
 #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
@@ -518,3 +519,193 @@ int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 
 	return 0;
 }
+
+#define RMNET_AGG_BYPASS_TIME_NSEC 10000000L
+
+static void reset_aggr_params(struct rmnet_port *port)
+{
+	port->skbagg_head = NULL;
+	port->agg_count = 0;
+	port->agg_state = 0;
+	memset(&port->agg_time, 0, sizeof(struct timespec64));
+}
+
+static void rmnet_send_skb(struct rmnet_port *port, struct sk_buff *skb)
+{
+	if (skb_needs_linearize(skb, port->dev->features)) {
+		if (unlikely(__skb_linearize(skb))) {
+			struct rmnet_priv *priv;
+
+			priv = netdev_priv(port->rmnet_dev);
+			this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+	}
+
+	dev_queue_xmit(skb);
+}
+
+static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	struct rmnet_port *port;
+
+	port = container_of(work, struct rmnet_port, agg_wq);
+
+	spin_lock_bh(&port->agg_lock);
+	if (likely(port->agg_state == -EINPROGRESS)) {
+		/* Buffer may have already been shipped out */
+		if (likely(port->skbagg_head)) {
+			skb = port->skbagg_head;
+			reset_aggr_params(port);
+		}
+		port->agg_state = 0;
+	}
+
+	spin_unlock_bh(&port->agg_lock);
+	if (skb)
+		rmnet_send_skb(port, skb);
+}
+
+static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
+{
+	struct rmnet_port *port;
+
+	port = container_of(t, struct rmnet_port, hrtimer);
+
+	schedule_work(&port->agg_wq);
+
+	return HRTIMER_NORESTART;
+}
+
+unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
+				    struct net_device *orig_dev)
+{
+	struct timespec64 diff, last;
+	unsigned int len = skb->len;
+	struct sk_buff *agg_skb;
+	int size;
+
+	spin_lock_bh(&port->agg_lock);
+	memcpy(&last, &port->agg_last, sizeof(struct timespec64));
+	ktime_get_real_ts64(&port->agg_last);
+
+	if (!port->skbagg_head) {
+		/* Check to see if we should agg first. If the traffic is very
+		 * sparse, don't aggregate.
+		 */
+new_packet:
+		diff = timespec64_sub(port->agg_last, last);
+		size = port->egress_agg_params.bytes - skb->len;
+
+		if (size < 0) {
+			/* dropped */
+			spin_unlock_bh(&port->agg_lock);
+			return 0;
+		}
+
+		if (diff.tv_sec > 0 || diff.tv_nsec > RMNET_AGG_BYPASS_TIME_NSEC ||
+		    size == 0)
+			goto no_aggr;
+
+		port->skbagg_head = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
+		if (!port->skbagg_head)
+			goto no_aggr;
+
+		dev_kfree_skb_any(skb);
+		port->skbagg_head->protocol = htons(ETH_P_MAP);
+		port->agg_count = 1;
+		ktime_get_real_ts64(&port->agg_time);
+		skb_frag_list_init(port->skbagg_head);
+		goto schedule;
+	}
+	diff = timespec64_sub(port->agg_last, port->agg_time);
+	size = port->egress_agg_params.bytes - port->skbagg_head->len;
+
+	if (skb->len > size) {
+		agg_skb = port->skbagg_head;
+		reset_aggr_params(port);
+		spin_unlock_bh(&port->agg_lock);
+		hrtimer_cancel(&port->hrtimer);
+		rmnet_send_skb(port, agg_skb);
+		spin_lock_bh(&port->agg_lock);
+		goto new_packet;
+	}
+
+	if (skb_has_frag_list(port->skbagg_head))
+		port->skbagg_tail->next = skb;
+	else
+		skb_shinfo(port->skbagg_head)->frag_list = skb;
+
+	port->skbagg_head->len += skb->len;
+	port->skbagg_head->data_len += skb->len;
+	port->skbagg_head->truesize += skb->truesize;
+	port->skbagg_tail = skb;
+	port->agg_count++;
+
+	if (diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.time_nsec ||
+	    port->agg_count >= port->egress_agg_params.count ||
+	    port->skbagg_head->len == port->egress_agg_params.bytes) {
+		agg_skb = port->skbagg_head;
+		reset_aggr_params(port);
+		spin_unlock_bh(&port->agg_lock);
+		hrtimer_cancel(&port->hrtimer);
+		rmnet_send_skb(port, agg_skb);
+		return len;
+	}
+
+schedule:
+	if (!hrtimer_active(&port->hrtimer) && port->agg_state != -EINPROGRESS) {
+		port->agg_state = -EINPROGRESS;
+		hrtimer_start(&port->hrtimer,
+			      ns_to_ktime(port->egress_agg_params.time_nsec),
+			      HRTIMER_MODE_REL);
+	}
+	spin_unlock_bh(&port->agg_lock);
+
+	return len;
+
+no_aggr:
+	spin_unlock_bh(&port->agg_lock);
+	skb->protocol = htons(ETH_P_MAP);
+	dev_queue_xmit(skb);
+
+	return len;
+}
+
+void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u32 size,
+				    u32 count, u32 time)
+{
+	spin_lock_bh(&port->agg_lock);
+	port->egress_agg_params.bytes = size;
+	WRITE_ONCE(port->egress_agg_params.count, count);
+	port->egress_agg_params.time_nsec = time * NSEC_PER_USEC;
+	spin_unlock_bh(&port->agg_lock);
+}
+
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
+{
+	hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
+	spin_lock_init(&port->agg_lock);
+	rmnet_map_update_ul_agg_config(port, 4096, 1, 800);
+	INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
+}
+
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
+{
+	hrtimer_cancel(&port->hrtimer);
+	cancel_work_sync(&port->agg_wq);
+
+	spin_lock_bh(&port->agg_lock);
+	if (port->agg_state == -EINPROGRESS) {
+		if (port->skbagg_head) {
+			dev_kfree_skb_any(port->skbagg_head);
+			reset_aggr_params(port);
+		}
+
+		port->agg_state = 0;
+	}
+	spin_unlock_bh(&port->agg_lock);
+}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 3f5e6572d20e..6d8b8fdb9d03 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -29,7 +29,7 @@ void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev)
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
-void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
+void rmnet_vnd_tx_fixup_len(unsigned int len, struct net_device *dev)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_pcpu_stats *pcpu_ptr;
@@ -38,10 +38,15 @@ void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
 
 	u64_stats_update_begin(&pcpu_ptr->syncp);
 	pcpu_ptr->stats.tx_pkts++;
-	pcpu_ptr->stats.tx_bytes += skb->len;
+	pcpu_ptr->stats.tx_bytes += len;
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
+void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
+{
+	rmnet_vnd_tx_fixup_len(skb->len, dev);
+}
+
 /* Network Device Operations */
 
 static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index dc3a4443ef0a..c2b2baf86894 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -16,6 +16,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
+void rmnet_vnd_tx_fixup_len(unsigned int len, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_setup(struct net_device *dev);
 int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev);
-- 
2.37.1

