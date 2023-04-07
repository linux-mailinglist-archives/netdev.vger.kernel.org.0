Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEB56DB5BB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjDGVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDGVLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:11:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A61A276;
        Fri,  7 Apr 2023 14:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680901905; x=1712437905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dmGWqTSrOW/+VaTyIkHQuKIVIiJoMxzxDh5GY82mhvg=;
  b=Ao1zn6zVpPrXvSYFKTtmtUpTtpt+mprgv6cOgFg59Ob1pHVyPUE/fNAz
   8cy1rcCmQLus1kNDUtdygUMVCcUM+ZJMcDGwQgctr4NNZOqaITLJWPpOf
   tj8oJhU9d7IpWUbYhjooasIRBr9ZNiis/yxXfuclSUoLiry9+MYLU/axA
   VHBAJXV+IC1cKSzDUB2I7QyWUKpAQ2/haIro/W9pQp8U7hC3PaZKYjBQp
   ZieWIY2wQZnM+q4d5cLyGbUuCZ+dvkpZS2NxQlR6BJURGe9bqEZJZNrJt
   qB2xxVTLmzyEZNDujiPoayv1OKyBWbhauwVai2rWMZ0LBe49cwpgMwhZA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="343076842"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="343076842"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 14:11:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="687630872"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="687630872"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 14:11:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Andrii Staikov <andrii.staikov@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 1/1] i40e: Fix crash when rebuild fails in i40e_xdp_setup
Date:   Fri,  7 Apr 2023 14:09:18 -0700
Message-Id: <20230407210918.3046293-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When attaching XDP program on i40e driver there was a reset and rebuild
of the interface to reconfigure the queues for XDP operation.
If one of the steps of rebuild failed then the interface was left
in incorrect state that could lead to a crash. If rebuild failed while
getting capabilities from HW such crash occurs:

capability discovery failed, err I40E_ERR_ADMIN_QUEUE_TIMEOUT aq_err OK
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Call Trace:
? i40e_reconfig_rss_queues+0x120/0x120 [i40e]
  dev_xdp_install+0x70/0x100
  dev_xdp_attach+0x1d7/0x530
  dev_change_xdp_fd+0x1f4/0x230
  do_setlink+0x45f/0xf30
  ? irq_work_interrupt+0xa/0x20
  ? __nla_validate_parse+0x12d/0x1a0
  rtnl_setlink+0xb5/0x120
  rtnetlink_rcv_msg+0x2b1/0x360
  ? sock_has_perm+0x80/0xa0
  ? rtnl_calcit.isra.42+0x120/0x120
  netlink_rcv_skb+0x4c/0x120
  netlink_unicast+0x196/0x230
  netlink_sendmsg+0x204/0x3d0
  sock_sendmsg+0x4c/0x50
  __sys_sendto+0xee/0x160
  ? handle_mm_fault+0xc1/0x1e0
  ? syscall_trace_enter+0x1fb/0x2c0
  ? __sys_setsockopt+0xd6/0x1d0
  __x64_sys_sendto+0x24/0x30
  do_syscall_64+0x5b/0x1a0
  entry_SYSCALL_64_after_hwframe+0x65/0xca
  RIP: 0033:0x7f3535d99781

Fix this by removing reset and rebuild from i40e_xdp_setup and replace it
by interface down, reconfigure queues and interface up. This way if any
step fails the interface will remain in a correct state.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Note: This will conflict when merging with net-next.

Resolution:
static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
                          struct netlink_ext_ack *extack)
  {
 -      int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 +      int frame_size = i40e_max_vsi_frame_size(vsi, prog);

 drivers/net/ethernet/intel/i40e/i40e_main.c | 159 +++++++++++++++-----
 1 file changed, 118 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 228cd502bb48..5c424f6af834 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -50,6 +50,8 @@ static int i40e_veb_get_bw_info(struct i40e_veb *veb);
 static int i40e_get_capabilities(struct i40e_pf *pf,
 				 enum i40e_admin_queue_opc list_type);
 static bool i40e_is_total_port_shutdown_enabled(struct i40e_pf *pf);
+static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi,
+					      bool is_xdp);
 
 /* i40e_pci_tbl - PCI Device ID Table
  *
@@ -3563,11 +3565,16 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	/* clear the context structure first */
 	memset(&rx_ctx, 0, sizeof(rx_ctx));
 
-	if (ring->vsi->type == I40E_VSI_MAIN)
-		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+	if (ring->vsi->type == I40E_VSI_MAIN &&
+	    !xdp_rxq_info_is_reg(&ring->xdp_rxq))
+		xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+				 ring->queue_index,
+				 ring->q_vector->napi.napi_id);
 
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
+		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+
 		ring->rx_buf_len =
 		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		/* For AF_XDP ZC, we disallow packets to span on
@@ -13307,6 +13314,39 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+/**
+ * i40e_vsi_assign_bpf_prog - set or clear bpf prog pointer on VSI
+ * @vsi: VSI to changed
+ * @prog: XDP program
+ **/
+static void i40e_vsi_assign_bpf_prog(struct i40e_vsi *vsi,
+				     struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
+	int i;
+
+	old_prog = xchg(&vsi->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	for (i = 0; i < vsi->num_queue_pairs; i++)
+		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
+}
+
+/**
+ * i40e_vsi_rx_napi_schedule - Schedule napi on RX queues from VSI
+ * @vsi: VSI to schedule napi on
+ */
+static void i40e_vsi_rx_napi_schedule(struct i40e_vsi *vsi)
+{
+	int i;
+
+	for (i = 0; i < vsi->num_queue_pairs; i++)
+		if (vsi->xdp_rings[i]->xsk_pool)
+			(void)i40e_xsk_wakeup(vsi->netdev, i,
+					      XDP_WAKEUP_RX);
+}
+
 /**
  * i40e_xdp_setup - add/remove an XDP program
  * @vsi: VSI to changed
@@ -13317,10 +13357,12 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 			  struct netlink_ext_ack *extack)
 {
 	int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	bool is_xdp_enabled = i40e_enabled_xdp_vsi(vsi);
+	bool if_running = netif_running(vsi->netdev);
+	bool need_reinit = is_xdp_enabled != !!prog;
 	struct i40e_pf *pf = vsi->back;
 	struct bpf_prog *old_prog;
-	bool need_reset;
-	int i;
+	int ret = 0;
 
 	/* Don't allow frames that span over multiple buffers */
 	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) {
@@ -13328,53 +13370,84 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 		return -EINVAL;
 	}
 
-	/* When turning XDP on->off/off->on we reset and rebuild the rings. */
-	need_reset = (i40e_enabled_xdp_vsi(vsi) != !!prog);
-
-	if (need_reset)
-		i40e_prep_for_reset(pf);
-
 	/* VSI shall be deleted in a moment, just return EINVAL */
 	if (test_bit(__I40E_IN_REMOVE, pf->state))
 		return -EINVAL;
 
-	old_prog = xchg(&vsi->xdp_prog, prog);
+	if (!need_reinit)
+		goto assign_prog;
 
-	if (need_reset) {
-		if (!prog) {
-			xdp_features_clear_redirect_target(vsi->netdev);
-			/* Wait until ndo_xsk_wakeup completes. */
-			synchronize_rcu();
-		}
-		i40e_reset_and_rebuild(pf, true, true);
+	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
+		i40e_down(vsi);
+
+	i40e_vsi_assign_bpf_prog(vsi, prog);
+
+	vsi = i40e_vsi_reinit_setup(vsi, true);
+
+	if (!vsi) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to reinitialize VSI during XDP setup");
+		ret = -EIO;
+		goto err_vsi_setup;
 	}
 
-	if (!i40e_enabled_xdp_vsi(vsi) && prog) {
-		if (i40e_realloc_rx_bi_zc(vsi, true))
-			return -ENOMEM;
-	} else if (i40e_enabled_xdp_vsi(vsi) && !prog) {
-		if (i40e_realloc_rx_bi_zc(vsi, false))
-			return -ENOMEM;
+	/* allocate descriptors */
+	ret = i40e_vsi_setup_tx_resources(vsi);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to configure TX resources during XDP setup");
+		goto err_vsi_setup;
+	}
+	ret = i40e_vsi_setup_rx_resources(vsi);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to configure RX resources during XDP setup");
+		goto err_setup_tx;
 	}
 
-	for (i = 0; i < vsi->num_queue_pairs; i++)
-		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
+	if (!is_xdp_enabled && prog)
+		ret = i40e_realloc_rx_bi_zc(vsi, true);
+	else if (is_xdp_enabled && !prog)
+		ret = i40e_realloc_rx_bi_zc(vsi, false);
 
-	if (old_prog)
-		bpf_prog_put(old_prog);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to reallocate RX resources during XDP setup");
+		goto err_setup_rx;
+	}
+
+	if (if_running) {
+		ret = i40e_up(vsi);
+
+		if (ret) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to open VSI during XDP setup");
+			goto err_setup_rx;
+		}
+	}
+	return 0;
+
+assign_prog:
+	i40e_vsi_assign_bpf_prog(vsi, prog);
+
+	if (need_reinit && !prog)
+		xdp_features_clear_redirect_target(vsi->netdev);
 
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
 	 */
-	if (need_reset && prog) {
-		for (i = 0; i < vsi->num_queue_pairs; i++)
-			if (vsi->xdp_rings[i]->xsk_pool)
-				(void)i40e_xsk_wakeup(vsi->netdev, i,
-						      XDP_WAKEUP_RX);
+	if (need_reinit && prog) {
+		i40e_vsi_rx_napi_schedule(vsi);
 		xdp_features_set_redirect_target(vsi->netdev, true);
 	}
 
 	return 0;
+
+err_setup_rx:
+	i40e_vsi_free_rx_resources(vsi);
+err_setup_tx:
+	i40e_vsi_free_tx_resources(vsi);
+err_vsi_setup:
+	i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
+	old_prog = xchg(&vsi->xdp_prog, prog);
+	i40e_vsi_assign_bpf_prog(vsi, old_prog);
+
+	return ret;
 }
 
 /**
@@ -14320,13 +14393,14 @@ static int i40e_vsi_setup_vectors(struct i40e_vsi *vsi)
 /**
  * i40e_vsi_reinit_setup - return and reallocate resources for a VSI
  * @vsi: pointer to the vsi.
+ * @is_xdp: flag indicating if this is reinit during XDP setup
  *
  * This re-allocates a vsi's queue resources.
  *
  * Returns pointer to the successfully allocated and configured VSI sw struct
  * on success, otherwise returns NULL on failure.
  **/
-static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi)
+static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi, bool is_xdp)
 {
 	u16 alloc_queue_pairs;
 	struct i40e_pf *pf;
@@ -14362,12 +14436,14 @@ static struct i40e_vsi *i40e_vsi_reinit_setup(struct i40e_vsi *vsi)
 	/* Update the FW view of the VSI. Force a reset of TC and queue
 	 * layout configurations.
 	 */
-	enabled_tc = pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
-	pf->vsi[pf->lan_vsi]->tc_config.enabled_tc = 0;
-	pf->vsi[pf->lan_vsi]->seid = pf->main_vsi_seid;
-	i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
-	if (vsi->type == I40E_VSI_MAIN)
-		i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
+	if (!is_xdp) {
+		enabled_tc = pf->vsi[pf->lan_vsi]->tc_config.enabled_tc;
+		pf->vsi[pf->lan_vsi]->tc_config.enabled_tc = 0;
+		pf->vsi[pf->lan_vsi]->seid = pf->main_vsi_seid;
+		i40e_vsi_config_tc(pf->vsi[pf->lan_vsi], enabled_tc);
+		if (vsi->type == I40E_VSI_MAIN)
+			i40e_rm_default_mac_filter(vsi, pf->hw.mac.perm_addr);
+	}
 
 	/* assign it some queues */
 	ret = i40e_alloc_rings(vsi);
@@ -15133,7 +15209,8 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acqui
 		if (pf->lan_vsi == I40E_NO_VSI)
 			vsi = i40e_vsi_setup(pf, I40E_VSI_MAIN, uplink_seid, 0);
 		else if (reinit)
-			vsi = i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi]);
+			vsi = i40e_vsi_reinit_setup(pf->vsi[pf->lan_vsi],
+						    false);
 		if (!vsi) {
 			dev_info(&pf->pdev->dev, "setup of MAIN VSI failed\n");
 			i40e_cloud_filter_exit(pf);
-- 
2.38.1

