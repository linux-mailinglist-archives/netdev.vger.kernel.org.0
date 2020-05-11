Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DFC1CD9DA
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgEKM3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:29:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56956 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgEKM3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:29:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A385B60085;
        Mon, 11 May 2020 12:29:33 +0000 (UTC)
Received: from us4-mdac16-35.ut7.mdlocal (unknown [10.7.66.154])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A21802009A;
        Mon, 11 May 2020 12:29:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 178F71C0059;
        Mon, 11 May 2020 12:29:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 979DC700080;
        Mon, 11 May 2020 12:29:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:29:27 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 5/8] sfc: rework handling of (firmware) multicast
 chaining state
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <6dea102b-1241-63c6-8e2e-a34099248e12@solarflare.com>
Date:   Mon, 11 May 2020 13:29:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-10.738600-8.000000-10
X-TMASE-MatchedRID: Ojaueh+HKT9Tj03Jjr4vPQlpVkdtt3WuRiPTMMc/MmnbqdHxGsFfafOP
        Ra/sN+oGhkOf78j1+sybZkVCatrPSKH2g9syPs888Kg68su2wyE/pOSL72dTfwdkFovAReUoaUX
        s6FguVy0fVLDIDiHvdO00FyVc4yHvSGsRClC1CmfbTbThIInD+pYaT3cL9WdKmXw0RNbqkoJHKo
        wsiP9YDQ1Bnq55lTg3F6w8puyi5jH55ocwjacbqh3IeIGfKJW/4oSd18bdmwLWXfwzppZ8SPzos
        tNASZmb26bKvjJzaWMrdEKOY+7gNvKJu1A4gJa5FqifzwY4bVp0f6daRtk8Sl9QIc+ez/4+CgBj
        jp+WlmGG5KUa7FdvCvAJhtRHt4BiIiC/wzCK1DMPe5gzF3TVt7ovx3KX3L+EVI7KaIl9Nhd4I1X
        WYyL/jpIj3AH8mhdE+kJpEGVLY8VbCLz0g5c8jCNHByyOpYYCy733NwuklsKMJxigKCCiS7Lnxn
        7dN6NWhvg0bLyWXzVebJqqJm1oLBSy+Y19jTwZfDrjzXCwK0KpR2kMGcsw7XLutXdeITtopIson
        G6IBJLXnS1WgMMINZGTpe1iiCJq71zr0FZRMbALbigRnpKlKSPzRlrdFGDwnbTQ2XEAT0eVuVxQ
        3JnPRn3feM3HHqFXQI0HUb7l5vVOll8Awlduig==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.738600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200173-FLdZBrXZ4S5I
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the mc_chaining bit in struct efx_mcdi_filter_table, so that common
 code in mcdi_filters.c doesn't need to get it from ef10-specific nic_data.
Also, probe the firmware workaround just before the call to
 efx_mcdi_filter_table_probe(), rather than in a random other part of the
 driver bringup, to ensure that (a) it gets probed in time and (b) it gets
 reprobed as necessary on resets, no matter how the surrounding code gets
 reorganised and reordered.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 141 +++++++++++++-----------
 drivers/net/ethernet/sfc/mcdi_filters.c |  15 ++-
 drivers/net/ethernet/sfc/mcdi_filters.h |   9 +-
 3 files changed, 90 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index b33bd6b77501..0779dda7d29f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2388,6 +2388,76 @@ static void efx_ef10_tx_write(struct efx_tx_queue *tx_queue)
 	}
 }
 
+static int efx_ef10_probe_multicast_chaining(struct efx_nic *efx)
+{
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	unsigned int enabled, implemented;
+	bool want_workaround_26807;
+	int rc;
+
+	rc = efx_mcdi_get_workarounds(efx, &implemented, &enabled);
+	if (rc == -ENOSYS) {
+		/* GET_WORKAROUNDS was implemented before this workaround,
+		 * thus it must be unavailable in this firmware.
+		 */
+		nic_data->workaround_26807 = false;
+		return 0;
+	}
+	if (rc)
+		return rc;
+	want_workaround_26807 =
+		implemented & MC_CMD_GET_WORKAROUNDS_OUT_BUG26807;
+	nic_data->workaround_26807 =
+		!!(enabled & MC_CMD_GET_WORKAROUNDS_OUT_BUG26807);
+
+	if (want_workaround_26807 && !nic_data->workaround_26807) {
+		unsigned int flags;
+
+		rc = efx_mcdi_set_workaround(efx,
+					     MC_CMD_WORKAROUND_BUG26807,
+					     true, &flags);
+		if (!rc) {
+			if (flags &
+			    1 << MC_CMD_WORKAROUND_EXT_OUT_FLR_DONE_LBN) {
+				netif_info(efx, drv, efx->net_dev,
+					   "other functions on NIC have been reset\n");
+
+				/* With MCFW v4.6.x and earlier, the
+				 * boot count will have incremented,
+				 * so re-read the warm_boot_count
+				 * value now to ensure this function
+				 * doesn't think it has changed next
+				 * time it checks.
+				 */
+				rc = efx_ef10_get_warm_boot_count(efx);
+				if (rc >= 0) {
+					nic_data->warm_boot_count = rc;
+					rc = 0;
+				}
+			}
+			nic_data->workaround_26807 = true;
+		} else if (rc == -EPERM) {
+			rc = 0;
+		}
+	}
+	return rc;
+}
+
+static int efx_ef10_filter_table_probe(struct efx_nic *efx)
+{
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	int rc = efx_ef10_probe_multicast_chaining(efx);
+
+	if (rc)
+		return rc;
+	rc = efx_mcdi_filter_table_probe(efx, nic_data->workaround_26807);
+
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 /* This creates an entry in the RX descriptor queue */
 static inline void
 efx_ef10_build_rx_desc(struct efx_rx_queue *rx_queue, unsigned int index)
@@ -2463,75 +2533,14 @@ static int efx_ef10_ev_init(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	struct efx_ef10_nic_data *nic_data;
-	unsigned int enabled, implemented;
 	bool use_v2, cut_thru;
-	int rc;
 
 	nic_data = efx->nic_data;
 	use_v2 = nic_data->datapath_caps2 &
 			    1 << MC_CMD_GET_CAPABILITIES_V2_OUT_INIT_EVQ_V2_LBN;
 	cut_thru = !(nic_data->datapath_caps &
 			      1 << MC_CMD_GET_CAPABILITIES_OUT_RX_BATCHING_LBN);
-	rc = efx_mcdi_ev_init(channel, cut_thru, use_v2);
-
-	/* IRQ return is ignored */
-	if (channel->channel || rc)
-		return rc;
-
-	/* Successfully created event queue on channel 0 */
-	rc = efx_mcdi_get_workarounds(efx, &implemented, &enabled);
-	if (rc == -ENOSYS) {
-		/* GET_WORKAROUNDS was implemented before this workaround,
-		 * thus it must be unavailable in this firmware.
-		 */
-		nic_data->workaround_26807 = false;
-		rc = 0;
-	} else if (rc) {
-		goto fail;
-	} else {
-		nic_data->workaround_26807 =
-			!!(enabled & MC_CMD_GET_WORKAROUNDS_OUT_BUG26807);
-
-		if (implemented & MC_CMD_GET_WORKAROUNDS_OUT_BUG26807 &&
-		    !nic_data->workaround_26807) {
-			unsigned int flags;
-
-			rc = efx_mcdi_set_workaround(efx,
-						     MC_CMD_WORKAROUND_BUG26807,
-						     true, &flags);
-
-			if (!rc) {
-				if (flags &
-				    1 << MC_CMD_WORKAROUND_EXT_OUT_FLR_DONE_LBN) {
-					netif_info(efx, drv, efx->net_dev,
-						   "other functions on NIC have been reset\n");
-
-					/* With MCFW v4.6.x and earlier, the
-					 * boot count will have incremented,
-					 * so re-read the warm_boot_count
-					 * value now to ensure this function
-					 * doesn't think it has changed next
-					 * time it checks.
-					 */
-					rc = efx_ef10_get_warm_boot_count(efx);
-					if (rc >= 0) {
-						nic_data->warm_boot_count = rc;
-						rc = 0;
-					}
-				}
-				nic_data->workaround_26807 = true;
-			} else if (rc == -EPERM) {
-				rc = 0;
-			}
-		}
-	}
-
-	if (!rc)
-		return 0;
-
-fail:
-	efx_mcdi_ev_fini(channel);
-	return rc;
+	return efx_mcdi_ev_init(channel, cut_thru, use_v2);
 }
 
 static void efx_ef10_handle_rx_wrong_queue(struct efx_rx_queue *rx_queue,
@@ -3185,7 +3194,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 		goto reset_nic;
 restore_filters:
 	down_write(&efx->filter_sem);
-	rc2 = efx_mcdi_filter_table_probe(efx);
+	rc2 = efx_ef10_filter_table_probe(efx);
 	up_write(&efx->filter_sem);
 	if (rc2)
 		goto reset_nic;
@@ -3227,7 +3236,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_VADAPTOR_SET_MAC, inbuf,
 				sizeof(inbuf), NULL, 0, NULL);
 
-	efx_mcdi_filter_table_probe(efx);
+	efx_ef10_filter_table_probe(efx);
 	up_write(&efx->filter_sem);
 	mutex_unlock(&efx->mac_lock);
 
@@ -4041,7 +4050,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
-	.filter_table_probe = efx_mcdi_filter_table_probe,
+	.filter_table_probe = efx_ef10_filter_table_probe,
 	.filter_table_restore = efx_mcdi_filter_table_restore,
 	.filter_table_remove = efx_mcdi_filter_table_remove,
 	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
@@ -4154,7 +4163,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.ev_process = efx_ef10_ev_process,
 	.ev_read_ack = efx_ef10_ev_read_ack,
 	.ev_test_generate = efx_ef10_ev_test_generate,
-	.filter_table_probe = efx_mcdi_filter_table_probe,
+	.filter_table_probe = efx_ef10_filter_table_probe,
 	.filter_table_restore = efx_mcdi_filter_table_restore,
 	.filter_table_remove = efx_mcdi_filter_table_remove,
 	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index bb29fc0063bf..d3c2e6eb3191 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -811,7 +811,7 @@ static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
 				      enum efx_encap_type encap_type,
 				      bool multicast, bool rollback)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	enum efx_filter_flags filter_flags;
 	struct efx_filter_spec spec;
 	u8 baddr[ETH_ALEN];
@@ -896,7 +896,7 @@ static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
 
 		EFX_WARN_ON_PARANOID(*id != EFX_EF10_FILTER_ID_INVALID);
 		*id = efx_mcdi_filter_get_unsafe_id(rc);
-		if (!nic_data->workaround_26807 && !encap_type) {
+		if (!table->mc_chaining && !encap_type) {
 			/* Also need an Ethernet broadcast filter */
 			efx_filter_init_rx(&spec, EFX_FILTER_PRI_AUTO,
 					   filter_flags, 0);
@@ -962,7 +962,6 @@ static void efx_mcdi_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 					      struct efx_mcdi_filter_vlan *vlan)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 
 	/*
 	 * Do not install unspecified VID if VLAN filtering is enabled.
@@ -1009,11 +1008,10 @@ static void efx_mcdi_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 	 * If changing promiscuous state with cascaded multicast filters, remove
 	 * old filters first, so that packets are dropped rather than duplicated
 	 */
-	if (nic_data->workaround_26807 &&
-	    table->mc_promisc_last != table->mc_promisc)
+	if (table->mc_chaining && table->mc_promisc_last != table->mc_promisc)
 		efx_mcdi_filter_remove_old(efx);
 	if (table->mc_promisc) {
-		if (nic_data->workaround_26807) {
+		if (table->mc_chaining) {
 			/*
 			 * If we failed to insert promiscuous filters, rollback
 			 * and fall back to individual multicast filters
@@ -1048,7 +1046,7 @@ static void efx_mcdi_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 		 */
 		if (efx_mcdi_filter_insert_addr_list(efx, vlan, true, true)) {
 			/* Changing promisc state, so remove old filters */
-			if (nic_data->workaround_26807)
+			if (table->mc_chaining)
 				efx_mcdi_filter_remove_old(efx);
 			if (efx_mcdi_filter_insert_def(efx, vlan,
 						       EFX_ENCAP_TYPE_NONE,
@@ -1285,7 +1283,7 @@ efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
 	return 0;
 }
 
-int efx_mcdi_filter_table_probe(struct efx_nic *efx)
+int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct net_device *net_dev = efx->net_dev;
@@ -1303,6 +1301,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 	if (!table)
 		return -ENOMEM;
 
+	table->mc_chaining = multicast_chaining;
 	table->rx_match_count = 0;
 	rc = efx_mcdi_filter_table_probe_matches(efx, table, false);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 884ba9731131..15b5d62e3670 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -79,11 +79,18 @@ struct efx_mcdi_filter_table {
 	bool must_restore_rss_contexts;
 	/* filters have yet to be restored after MC reboot */
 	bool must_restore_filters;
+	/* Multicast filter chaining allows less-specific filters to receive
+	 * multicast packets that matched more-specific filters.  Early EF10
+	 * firmware didn't support this (SF bug 26807); if mc_chaining == false
+	 * then we still subscribe the dev_mc_list even when mc_promisc to
+	 * prevent another VI stealing the traffic.
+	 */
+	bool mc_chaining;
 	bool vlan_filter;
 	struct list_head vlan_list;
 };
 
-int efx_mcdi_filter_table_probe(struct efx_nic *efx);
+int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining);
 void efx_mcdi_filter_table_remove(struct efx_nic *efx);
 void efx_mcdi_filter_table_restore(struct efx_nic *efx);
 

