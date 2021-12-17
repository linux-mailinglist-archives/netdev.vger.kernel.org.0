Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E9E47863F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhLQIea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:34:30 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:34138 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231714AbhLQIea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 03:34:30 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowACHjp53S7xhJSbCAw--.25597S2;
        Fri, 17 Dec 2021 16:34:01 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v2] sfc: potential dereference null pointer of rx_queue->page_ring
Date:   Fri, 17 Dec 2021 16:33:58 +0800
Message-Id: <20211217083358.564333-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowACHjp53S7xhJSbCAw--.25597S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Zw18KFW7CF13KFy3Gr4rXwb_yoWkWw17pa
        y2yrW7ur4Sqan8Ww1xGrZ7uF45trn5t342gryfK34Fvr98Ar1fZF1kt3Wj9rZ8JrW8Gr4a
        yr12yan7Ga13JrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUf9NsUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kcalloc() needs to be checked.
To avoid dereference of null pointer in case of the failure of alloc.
Therefore, it might be better to change the return type of
efx_init_rx_recycle_ring(), efx_init_rx_queue(), efx_start_channels(),
efx_start_datapath() and efx_start_all(), and return -ENOMEM when alloc
fails and return 0 the others.
Also, efx_net_open(), efx_pm_thaw(), efx_realloc_channels(),
efx_reset_up() and efx_change_mtu() should deal with the return value of
efx_start_all().
By the way, I have no idea where the code come from, which does not
mention in the commit message.
But I find the same bug in another two places in the ethernet and I will
then commit the patches to repair them.
The Fixes tag below is the one I guess.

Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog:

v1 -> v2

*Change 1. Casade return -ENOMEM when alloc fails and deal with the
error.
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  4 +++-
 drivers/net/ethernet/sfc/efx.c          |  9 ++++++--
 drivers/net/ethernet/sfc/efx_channels.c | 14 ++++++++++---
 drivers/net/ethernet/sfc/efx_channels.h |  2 +-
 drivers/net/ethernet/sfc/efx_common.c   | 28 ++++++++++++++++++-------
 drivers/net/ethernet/sfc/efx_common.h   |  2 +-
 drivers/net/ethernet/sfc/rx_common.c    | 14 ++++++++++---
 drivers/net/ethernet/sfc/rx_common.h    |  2 +-
 8 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..aaba36e40446 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -162,7 +162,9 @@ static int ef100_net_open(struct net_device *net_dev)
 	if (rc)
 		goto fail;
 
-	efx_start_all(efx);
+	rc = efx_start_all(efx);
+	if (rc)
+		goto fail;
 
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c746ca7235f1..874301cda686 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -540,7 +540,10 @@ int efx_net_open(struct net_device *net_dev)
 	 * before the monitor starts running */
 	efx_link_status_changed(efx);
 
-	efx_start_all(efx);
+	rc = efx_start_all(efx);
+	if (rc)
+		return rc;
+
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
 	efx_selftest_async_start(efx);
@@ -1224,7 +1227,9 @@ static int efx_pm_thaw(struct device *dev)
 		efx_mcdi_port_reconfigure(efx);
 		mutex_unlock(&efx->mac_lock);
 
-		efx_start_all(efx);
+		rc = efx_start_all(efx);
+		if (rc)
+			goto fail;
 
 		efx_device_attach_if_not_resetting(efx);
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index bb48a139dd15..451f7c6a7680 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -837,7 +837,10 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 			  "unable to restart interrupts on channel reallocation\n");
 		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
 	} else {
-		efx_start_all(efx);
+		rc = efx_start_all(efx);
+		if (rc)
+			goto rollback;
+
 		efx_device_attach_if_not_resetting(efx);
 	}
 	return rc;
@@ -1055,11 +1058,12 @@ void efx_disable_interrupts(struct efx_nic *efx)
 	efx->type->irq_disable_non_ev(efx);
 }
 
-void efx_start_channels(struct efx_nic *efx)
+int efx_start_channels(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
 	struct efx_channel *channel;
+	int ret;
 
 	efx_for_each_channel(channel, efx) {
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
@@ -1068,7 +1072,10 @@ void efx_start_channels(struct efx_nic *efx)
 		}
 
 		efx_for_each_channel_rx_queue(rx_queue, channel) {
-			efx_init_rx_queue(rx_queue);
+			ret = efx_init_rx_queue(rx_queue);
+			if (ret)
+				return ret;
+
 			atomic_inc(&efx->active_queues);
 			efx_stop_eventq(channel);
 			efx_fast_push_rx_descriptors(rx_queue, false);
@@ -1077,6 +1084,7 @@ void efx_start_channels(struct efx_nic *efx)
 
 		WARN_ON(channel->rx_pkt_n_frags);
 	}
+	return 0;
 }
 
 void efx_stop_channels(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index d77ec1f77fb1..da38b6be5a45 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -42,7 +42,7 @@ void efx_remove_channel(struct efx_channel *channel);
 void efx_remove_channels(struct efx_nic *efx);
 void efx_fini_channels(struct efx_nic *efx);
 struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel);
-void efx_start_channels(struct efx_nic *efx);
+int efx_start_channels(struct efx_nic *efx);
 void efx_stop_channels(struct efx_nic *efx);
 
 void efx_init_napi_channel(struct efx_channel *channel);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..0b5fec7769ea 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -309,7 +309,10 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	efx_mac_reconfigure(efx, true);
 	mutex_unlock(&efx->mac_lock);
 
-	efx_start_all(efx);
+	rc = efx_start_all(efx);
+	if (rc)
+		return rc;
+
 	efx_device_attach_if_not_resetting(efx);
 	return 0;
 }
@@ -361,11 +364,12 @@ void efx_start_monitor(struct efx_nic *efx)
  * to propagate configuration changes (mtu, checksum offload), or
  * to clear hardware error conditions
  */
-static void efx_start_datapath(struct efx_nic *efx)
+static int efx_start_datapath(struct efx_nic *efx)
 {
 	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
 	size_t rx_buf_len;
+	int ret;
 
 	/* Calculate the rx buffer allocation parameters required to
 	 * support the current MTU, including padding for header
@@ -431,12 +435,15 @@ static void efx_start_datapath(struct efx_nic *efx)
 	efx->txq_wake_thresh = efx->txq_stop_thresh / 2;
 
 	/* Initialise the channels */
-	efx_start_channels(efx);
+	ret = efx_start_channels(efx);
+	if (ret)
+		return ret;
 
 	efx_ptp_start_datapath(efx);
 
 	if (netif_device_present(efx->net_dev))
 		netif_tx_wake_all_queues(efx->net_dev);
+	return 0;
 }
 
 static void efx_stop_datapath(struct efx_nic *efx)
@@ -524,8 +531,9 @@ static void efx_stop_port(struct efx_nic *efx)
  * is safe to call multiple times, so long as the NIC is not disabled.
  * Requires the RTNL lock.
  */
-void efx_start_all(struct efx_nic *efx)
+int efx_start_all(struct efx_nic *efx)
 {
+	int ret;
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->state == STATE_DISABLED);
 
@@ -534,10 +542,12 @@ void efx_start_all(struct efx_nic *efx)
 	 */
 	if (efx->port_enabled || !netif_running(efx->net_dev) ||
 	    efx->reset_pending)
-		return;
+		return 0;
 
 	efx_start_port(efx);
-	efx_start_datapath(efx);
+	ret = efx_start_datapath(efx);
+	if (ret)
+		return ret;
 
 	/* Start the hardware monitor if there is one */
 	efx_start_monitor(efx);
@@ -557,6 +567,8 @@ void efx_start_all(struct efx_nic *efx)
 		efx->type->update_stats(efx, NULL, NULL);
 		spin_unlock_bh(&efx->stats_lock);
 	}
+
+	return 0;
 }
 
 /* Quiesce the hardware and software data path, and regular activity
@@ -786,7 +798,9 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	mutex_unlock(&efx->mac_lock);
 
-	efx_start_all(efx);
+	rc = efx_start_all(efx);
+	if (rc)
+		goto fail;
 
 	if (efx->type->udp_tnl_push_ports)
 		efx->type->udp_tnl_push_ports(efx);
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..adf84a64760b 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -28,7 +28,7 @@ void efx_fini_struct(struct efx_nic *efx);
 void efx_link_clear_advertising(struct efx_nic *efx);
 void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 
-void efx_start_all(struct efx_nic *efx);
+int efx_start_all(struct efx_nic *efx);
 void efx_stop_all(struct efx_nic *efx);
 
 void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317693..b7d974e25a43 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -131,7 +131,7 @@ void efx_discard_rx_packet(struct efx_channel *channel,
 	efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
 }
 
-static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
+static int efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 {
 	unsigned int bufs_in_recycle_ring, page_ring_size;
 	struct efx_nic *efx = rx_queue->efx;
@@ -150,7 +150,11 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 					    efx->rx_bufs_per_page);
 	rx_queue->page_ring = kcalloc(page_ring_size,
 				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
+	if (!rx_queue->page_ring)
+		return -ENOMEM;
+
 	rx_queue->page_ptr_mask = page_ring_size - 1;
+	return 0;
 }
 
 static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
@@ -222,7 +226,7 @@ int efx_probe_rx_queue(struct efx_rx_queue *rx_queue)
 	return rc;
 }
 
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
+int efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 {
 	unsigned int max_fill, trigger, max_trigger;
 	struct efx_nic *efx = rx_queue->efx;
@@ -236,7 +240,9 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 	rx_queue->notified_count = 0;
 	rx_queue->removed_count = 0;
 	rx_queue->min_fill = -1U;
-	efx_init_rx_recycle_ring(rx_queue);
+	rc = efx_init_rx_recycle_ring(rx_queue);
+	if (rc)
+		return rc;
 
 	rx_queue->page_remove = 0;
 	rx_queue->page_add = rx_queue->page_ptr_mask + 1;
@@ -275,6 +281,8 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 
 	/* Set up RX descriptor ring */
 	efx_nic_init_rx(rx_queue);
+
+	return 0;
 }
 
 void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 207ccd8ba062..16133d3f46b2 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -47,7 +47,7 @@ void efx_discard_rx_packet(struct efx_channel *channel,
 			   unsigned int n_frags);
 
 int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
-void efx_init_rx_queue(struct efx_rx_queue *rx_queue);
+int efx_init_rx_queue(struct efx_rx_queue *rx_queue);
 void efx_fini_rx_queue(struct efx_rx_queue *rx_queue);
 void efx_remove_rx_queue(struct efx_rx_queue *rx_queue);
 void efx_destroy_rx_queue(struct efx_rx_queue *rx_queue);
-- 
2.25.1

