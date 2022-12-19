Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C939650EDF
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiLSPmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiLSPmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0B8120B0;
        Mon, 19 Dec 2022 07:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DB1B80EA4;
        Mon, 19 Dec 2022 15:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E08C433F0;
        Mon, 19 Dec 2022 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671464551;
        bh=sLaV3PORdHQIelCzXuJI8Bq0/5k16dDGcnYvMnrp1xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjWGl09KIrnRFqsxJUJNmhu6SOj6GWQwvrniX8nXWAiaTCdy1l5Iu/7d0QGx8NW6F
         xUZ5qlwDKHv4xuFKOm2TFq5hNeoostCM2LIxUAAY/XKHBl7AWE2KbXJNlAv5BfDKDA
         p8zSkCDxLQOVq0VCb/71xSkiFhrCFXcuSIJLcZ5WDho1OhgrCHh2SwiGagiTIRnwh+
         JkcPNf6oRNi3XboPaEnQ3bWltdejy90eYoG+hJ6+1WKpaNu3VccTAO2QRRyhsdO5t7
         NxqSCWTfTJgQb6cruoaWfdAlb0XE4fbVW9WWS05P0jXoTPG2AtRrdO225nMg9XKVKL
         ZRat7qK7kHXGg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: [RFC bpf-next 3/8] drivers: net: turn on XDP features
Date:   Mon, 19 Dec 2022 16:41:32 +0100
Message-Id: <43a674257d9950e5867aff3dbd6df9a4d9b43c75.1671462950.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1671462950.git.lorenzo@kernel.org>
References: <cover.1671462950.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <alardam@gmail.com>

A summary of the flags being set for various drivers is given below.
Note that XDP_F_REDIRECT_TARGET and XDP_F_FRAG_TARGET are features
that can be turned off and on at runtime. This means that these flags
may be set and unset under RTNL lock protection by the driver. Hence,
READ_ONCE must be used by code loading the flag value.

Also, these flags are not used for synchronization against the availability
of XDP resources on a device. It is merely a hint, and hence the read
may race with the actual teardown of XDP resources on the device. This
may change in the future, e.g. operations taking a reference on the XDP
resources of the driver, and in turn inhibiting turning off this flag.
However, for now, it can only be used as a hint to check whether device
supports becoming a redirection target.

Turn 'hw-offload' feature flag on for:
 - netronome (nfp)
 - netdevsim.

Turn 'native' and 'zerocopy' features flags on for:
 - intel (i40e, ice, ixgbe, igc)
 - mellanox (mlx5).
 - stmmac

Turn 'native' features flags on for:
 - amazon (ena)
 - broadcom (bnxt)
 - freescale (dpaa, dpaa2, enetc)
 - funeth
 - intel (igb)
 - marvell (mvneta, mvpp2, octeontx2)
 - mellanox (mlx4)
 - qlogic (qede)
 - sfc
 - socionext (netsec)
 - ti (cpsw)
 - tap
 - veth
 - xen
 - virtio_net.

Turn 'basic' (tx, pass, aborted and drop) features flags on for:
 - netronome (nfp)
 - cavium (thunder)
 - hyperv.

Turn 'tx_lock' feature flag on for:
 - aquantia
 - freescale (dpaa2)
 - intel (igb)
 - marvell (mvneta, mvpp2)
 - microsoft (mana)
 - mediatek
 - qlogic (qede)
 - socionext (netsec)
 - ti (cpsw)
 - tap
 - veth
 - xen

Turn 'redirect_target' feature flag on for:
 - amanzon (ena)
 - broadcom (bnxt)
 - freescale (dpaa, dpaa2)
 - intel (i40e, ice, igb, ixgbe)
 - ti (cpsw)
 - marvell (mvneta, mvpp2)
 - sfc
 - socionext (netsec)
 - qlogic (qede)
 - mellanox (mlx5)
 - tap
 - veth
 - virtio_net
 - xen

Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Marek Majtyka <alardam@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  5 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  3 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 ++
 .../ethernet/fungible/funeth/funeth_main.c    |  6 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  9 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  5 +++
 drivers/net/ethernet/intel/igb/igb_main.c     |  9 ++++-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +
 drivers/net/ethernet/intel/igc/igc_xdp.c      |  5 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 +++
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  1 +
 drivers/net/ethernet/marvell/mvneta.c         |  3 ++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 ++
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  9 ++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  5 +++
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++++
 drivers/net/ethernet/microsoft/mana/mana_en.c |  2 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  3 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +
 drivers/net/ethernet/sfc/efx.c                |  2 +
 drivers/net/ethernet/sfc/siena/efx.c          |  2 +
 drivers/net/ethernet/socionext/netsec.c       |  2 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  1 +
 drivers/net/ethernet/ti/cpsw.c                |  2 +
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +
 drivers/net/hyperv/netvsc_drv.c               |  2 +
 drivers/net/netdevsim/netdev.c                |  1 +
 drivers/net/tun.c                             |  3 ++
 drivers/net/veth.c                            |  4 ++
 drivers/net/virtio_net.c                      |  5 +++
 drivers/net/xen-netfront.c                    |  1 +
 include/net/xdp.h                             | 39 +++++++++++++++++++
 38 files changed, 161 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a95529a69cbb..679d75b69870 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -589,7 +589,10 @@ static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
 				if (rc)
 					return rc;
 			}
+			__xdp_features_set_redirect_target(&netdev->xdp_features,
+							   XDP_F_REDIRECT_TARGET);
 		} else if (old_bpf_prog) {
+			xdp_features_clear_redirect_target(&netdev->xdp_features);
 			rc = ena_destroy_and_free_all_xdp_queues(adapter);
 			if (rc)
 				return rc;
@@ -4066,6 +4069,8 @@ static void ena_set_conf_feat_params(struct ena_adapter *adapter,
 	/* Set offload features */
 	ena_set_dev_offloads(feat, netdev);
 
+	netdev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK;
+
 	adapter->max_mtu = feat->dev_attr.max_mtu;
 	netdev->max_mtu = adapter->max_mtu;
 	netdev->min_mtu = ENA_MIN_MTU;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 06508eebb585..db4cf1c977d7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -384,6 +384,9 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->mtu = aq_nic_cfg->mtu - ETH_HLEN;
 	self->ndev->max_mtu = aq_hw_caps->mtu - ETH_FCS_LEN - ETH_HLEN;
 
+	self->ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+				   XDP_F_REDIRECT_TARGET | XDP_F_FRAG_RX |
+				   XDP_F_FRAG_TARGET;
 }
 
 void aq_nic_set_tx_ring(struct aq_nic_s *self, unsigned int idx,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4c7d07c684c4..2c02833b5bdf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13681,6 +13681,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 
+	dev->xdp_features = XDP_F_FULL | XDP_F_FRAG_RX;
+
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c3065ec0a479..3c1b1ee7a37b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -424,9 +424,11 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 
 	if (prog) {
 		bnxt_set_rx_skb_mode(bp, true);
+		xdp_features_set_redirect_target(&dev->xdp_features);
 	} else {
 		int rx, tx;
 
+		xdp_features_clear_redirect_target(&dev->xdp_features);
 		bnxt_set_rx_skb_mode(bp, false);
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index f2f95493ec89..067bdd20aec8 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2218,6 +2218,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
 
+	netdev->xdp_features = XDP_F_BASIC;
+
 	/* MTU range: 64 - 9200 */
 	netdev->min_mtu = NIC_HW_MIN_FRS;
 	netdev->max_mtu = NIC_HW_MAX_FRS;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3f8032947d86..24faa37a9a04 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -244,6 +244,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->features |= net_dev->hw_features;
 	net_dev->vlan_features = net_dev->features;
 
+	net_dev->xdp_features = XDP_F_FULL | XDP_F_REDIRECT_TARGET;
+
 	if (is_valid_ether_addr(mac_addr)) {
 		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
 		eth_hw_addr_set(net_dev, mac_addr);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0c35abb7d065..99eb7bbb8ca1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4593,6 +4593,7 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 			    NETIF_F_LLTX | NETIF_F_HW_TC | NETIF_F_TSO;
 	net_dev->gso_max_segs = DPAA2_ETH_ENQUEUE_MAX_FDS;
 	net_dev->hw_features = net_dev->features;
+	net_dev->xdp_features = XDP_F_FULL_ZC | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
 
 	if (priv->dpni_attrs.vlan_filter_entries)
 		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 9f6c4f5c0a6c..e83062e780e5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -825,6 +825,9 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 		ndev->hw_features |= NETIF_F_RXHASH;
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+			     XDP_F_REDIRECT_TARGET | XDP_F_FRAG_RX |
+			     XDP_F_FRAG_TARGET;
 
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index b4cce30e526a..1ba7e51cce8d 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1160,6 +1160,11 @@ static int fun_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
 			WRITE_ONCE(rxqs[i]->xdp_prog, prog);
 	}
 
+	if (prog)
+		xdp_features_set_redirect_target(&dev->xdp_features);
+	else
+		xdp_features_clear_redirect_target(&dev->xdp_features);
+
 	dev->max_mtu = prog ? XDP_MAX_MTU : FUN_MAX_MTU;
 	old_prog = xchg(&fp->xdp_prog, prog);
 	if (old_prog)
@@ -1765,6 +1770,7 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	netdev->vlan_features = netdev->features & VLAN_FEAT;
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
+	netdev->xdp_features = XDP_F_FULL;
 
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = FUN_MAX_MTU;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 94feea3b2599..e71a53677f06 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13339,9 +13339,11 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	old_prog = xchg(&vsi->xdp_prog, prog);
 
 	if (need_reset) {
-		if (!prog)
+		if (!prog) {
+			xdp_features_clear_redirect_target(&vsi->netdev->xdp_features);
 			/* Wait until ndo_xsk_wakeup completes. */
 			synchronize_rcu();
+		}
 		i40e_reset_and_rebuild(pf, true, true);
 	}
 
@@ -13362,11 +13364,13 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
 	 */
-	if (need_reset && prog)
+	if (need_reset && prog) {
 		for (i = 0; i < vsi->num_queue_pairs; i++)
 			if (vsi->xdp_rings[i]->xsk_pool)
 				(void)i40e_xsk_wakeup(vsi->netdev, i,
 						      XDP_WAKEUP_RX);
+		xdp_features_set_redirect_target(&vsi->netdev->xdp_features);
+	}
 
 	return 0;
 }
@@ -13783,6 +13787,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev->features &= ~NETIF_F_HW_TC;
+	netdev->xdp_features = XDP_F_FULL_ZC;
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9a7f8b52140..07f1d0fd0571 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -22,6 +22,7 @@
 #include "ice_eswitch.h"
 #include "ice_tc_lib.h"
 #include "ice_vsi_vlan_ops.h"
+#include <net/xdp_sock_drv.h>
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -2899,11 +2900,14 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
+		__xdp_features_set_redirect_target(&vsi->netdev->xdp_features,
+						   XDP_F_REDIRECT_TARGET);
 		/* reallocate Rx queues that are used for zero-copy */
 		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Rx resources failed");
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
+		xdp_features_clear_redirect_target(&vsi->netdev->xdp_features);
 		xdp_ring_err = ice_destroy_xdp_rings(vsi);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
@@ -3446,6 +3450,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	np->vsi = vsi;
 
 	ice_set_netdev_features(netdev);
+	netdev->xdp_features = XDP_F_FULL_ZC;
 
 	ice_set_ops(netdev);
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 97290fc0fddd..2834b6e9f604 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2871,8 +2871,14 @@ static int igb_xdp_setup(struct net_device *dev, struct netdev_bpf *bpf)
 		bpf_prog_put(old_prog);
 
 	/* bpf is just replaced, RXQ and MTU are already setup */
-	if (!need_reset)
+	if (!need_reset) {
 		return 0;
+	} else {
+		if (prog)
+			xdp_features_set_redirect_target(&dev->xdp_features);
+		else
+			xdp_features_clear_redirect_target(&dev->xdp_features);
+	}
 
 	if (running)
 		igb_open(dev);
@@ -3317,6 +3323,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK;
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1586e1e435c6..64917a272cf4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6379,6 +6379,8 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
+	netdev->xdp_features = XDP_F_FULL_ZC;
+
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = MAX_STD_JUMBO_FRAME_SIZE;
diff --git a/drivers/net/ethernet/intel/igc/igc_xdp.c b/drivers/net/ethernet/intel/igc/igc_xdp.c
index aeeb34e64610..570170a29e3a 100644
--- a/drivers/net/ethernet/intel/igc/igc_xdp.c
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.c
@@ -29,6 +29,11 @@ int igc_xdp_set_prog(struct igc_adapter *adapter, struct bpf_prog *prog,
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
+	if (prog)
+		xdp_features_set_redirect_target(&dev->xdp_features);
+	else
+		xdp_features_clear_redirect_target(&dev->xdp_features);
+
 	if (if_running)
 		igc_open(dev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..4550b80f4ebd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10301,6 +10301,8 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			rcu_assign_pointer(adapter->xdp_prog, old_prog);
 			return -EINVAL;
 		}
+		if (!prog)
+			xdp_features_clear_redirect_target(&dev->xdp_features);
 	} else {
 		for (i = 0; i < adapter->num_rx_queues; i++)
 			(void)xchg(&adapter->rx_ring[i]->xdp_prog,
@@ -10320,6 +10322,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			if (adapter->xdp_ring[i]->xsk_pool)
 				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
 						       XDP_WAKEUP_RX);
+		xdp_features_set_redirect_target(&dev->xdp_features);
 	}
 
 	return 0;
@@ -11017,6 +11020,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
+	netdev->xdp_features = XDP_F_FULL_ZC;
+
 	/* MTU range: 68 - 9710 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = IXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ea0a230c1153..8bc32ab2c2dd 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4634,6 +4634,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_HW_VLAN_CTAG_TX;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->xdp_features = XDP_F_BASIC;
 
 	/* MTU range: 68 - 1504 or 9710 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f8925cac61e4..e3928a534308 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5612,6 +5612,9 @@ static int mvneta_probe(struct platform_device *pdev)
 			NETIF_F_TSO | NETIF_F_RXCSUM;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+	dev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+			    XDP_F_REDIRECT_TARGET | XDP_F_FRAG_RX |
+			    XDP_F_FRAG_TARGET;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	netif_set_tso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4da45c5abba5..6bfe28aafb4f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6866,6 +6866,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	dev->vlan_features |= features;
 	netif_set_tso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
+
+	dev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
+
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 68 - 9704 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c1ea60bc2630..3c7fc7bf8339 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2512,10 +2512,14 @@ static int otx2_xdp_setup(struct otx2_nic *pf, struct bpf_prog *prog)
 	/* Network stack and XDP shared same rx queues.
 	 * Use separate tx queues for XDP and network stack.
 	 */
-	if (pf->xdp_prog)
+	if (pf->xdp_prog) {
 		pf->hw.xdp_queues = pf->hw.rx_queues;
-	else
+		__xdp_features_set_redirect_target(&dev->xdp_features,
+						   XDP_F_REDIRECT_TARGET);
+	} else {
 		pf->hw.xdp_queues = 0;
+		xdp_features_clear_redirect_target(&dev->xdp_features);
+	}
 
 	pf->hw.tot_tx_queues += pf->hw.xdp_queues;
 
@@ -2878,6 +2882,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
+	netdev->xdp_features = XDP_F_FULL;
 
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = otx2_get_max_mtu(pf);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e3de9a53b2d9..17831770b494 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4186,6 +4186,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		register_netdevice_notifier(&mac->device_notifier);
 	}
 
+	if (mtk_page_pool_enabled(eth))
+		eth->netdev[id]->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+						XDP_F_REDIRECT_TARGET |
+						XDP_F_FRAG_TARGET;
+
 	return 0;
 
 free_netdev:
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 8800d3f1f55c..3c7b011de300 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3410,6 +3410,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		priv->rss_hash_fn = ETH_RSS_HASH_TOP;
 	}
 
+	dev->xdp_features = XDP_F_FULL;
+
 	/* MTU range: 68 - hw-specific max */
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8d36e2de53a9..2a406dddae84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4776,6 +4776,13 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
+	if (reset) {
+		if (prog)
+			xdp_features_set_redirect_target(&netdev->xdp_features);
+		else
+			xdp_features_clear_redirect_target(&netdev->xdp_features);
+	}
+
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
 		goto unlock;
 
@@ -5170,6 +5177,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
 
+	netdev->xdp_features = XDP_F_FULL_ZC | XDP_F_FRAG_RX;
+
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
 	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2f6a048dee90..61955359931b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2160,6 +2160,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->hw_features |= NETIF_F_RXHASH;
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = 0;
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+			     XDP_F_REDIRECT_TARGET;
 
 	err = register_netdev(ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 2314cf55e821..f704b4ad5702 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2482,10 +2482,13 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
 
+	nn->dp.netdev->xdp_features = XDP_F_BASIC | XDP_F_HW_OFFLOAD;
+
 	/* Finalise the netdev setup */
 	switch (nn->dp.ops->version) {
 	case NFP_NFD_VER_NFD3:
 		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
+		nn->dp.netdev->xdp_features |= XDP_F_SOCK_ZEROCOPY;
 		break;
 	case NFP_NFD_VER_NFDK:
 		netdev->netdev_ops = &nfp_nfdk_netdev_ops;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 953f304b8588..f090ce57befd 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -892,6 +892,8 @@ static void qede_init_ndev(struct qede_dev *edev)
 
 	ndev->hw_features = hw_features;
 
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
+
 	/* MTU range: 46 - 9600 */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
 	ndev->max_mtu = QEDE_MAX_JUMBO_PACKET_SIZE;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 0556542d7a6b..bc624c2ea016 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1078,6 +1078,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_info(pci_dev, "Solarflare NIC detected\n");
 
+	efx->net_dev->xdp_features = XDP_F_FULL | XDP_F_REDIRECT_TARGET;
+
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 60e5b7c8ccf9..0872e075ea3a 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1048,6 +1048,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_info(pci_dev, "Solarflare NIC detected\n");
 
+	efx->net_dev->xdp_features = XDP_F_FULL | XDP_F_REDIRECT_TARGET;
+
 	if (!efx->type->is_vf)
 		efx_probe_vpd_strings(efx);
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 9b46579b5a10..e4586c49f5b8 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2104,6 +2104,8 @@ static int netsec_probe(struct platform_device *pdev)
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	ndev->hw_features = ndev->features;
 
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
+
 	priv->rx_cksum_offload_flag = true;
 
 	ret = netsec_register_mdio(priv, phy_addr);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ec64b65dee34..4b759cb1a9ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7144,6 +7144,7 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_RXCSUM;
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 13c9c2d6b79b..6e76345a0d46 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1458,6 +1458,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1635,6 +1636,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	cpsw->slaves[0].ndev = ndev;
 
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 83596ec0c7cb..a8a20840a05a 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1405,6 +1405,8 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 
+		ndev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
+
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f9b219e6cd58..4bb09de440b2 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2559,6 +2559,8 @@ static int netvsc_probe(struct hv_device *dev,
 
 	netdev_lockdep_set_classes(net);
 
+	net->xdp_features = XDP_F_FULL;
+
 	/* MTU range: 68 - 1500 or 65521 */
 	net->min_mtu = NETVSC_MTU_MIN;
 	if (nvdev->nvsp_version >= NVSP_PROTOCOL_VERSION_2)
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 6db6a75ff9b9..20962dd54bac 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -286,6 +286,7 @@ static void nsim_setup(struct net_device *dev)
 			 NETIF_F_TSO;
 	dev->hw_features |= NETIF_F_HW_TC;
 	dev->max_mtu = ETH_MAX_MTU;
+	dev->xdp_features = XDP_F_HW_OFFLOAD;
 }
 
 static int nsim_init_netdevsim(struct netdevsim *ns)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a7d17c680f4a..b35210a6371b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1401,6 +1401,9 @@ static void tun_net_initialize(struct net_device *dev)
 
 		eth_hw_addr_random(dev);
 
+		/* Currently tun does not support XDP, only tap does. */
+		dev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
+
 		break;
 	}
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ac7c0653695f..e2518ed81dc5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1648,6 +1648,10 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
+
+	dev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK |
+			    XDP_F_REDIRECT_TARGET | XDP_F_FRAG_RX |
+			    XDP_F_FRAG_TARGET;
 }
 
 /*
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7723b2a49d8e..bbd0e306c098 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3155,7 +3155,11 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			if (i == 0 && !old_prog)
 				virtnet_clear_guest_offloads(vi);
 		}
+		if (!old_prog)
+			__xdp_features_set_redirect_target(&dev->xdp_features,
+							   XDP_F_REDIRECT_TARGET);
 	} else {
+		xdp_features_clear_redirect_target(&dev->xdp_features);
 		vi->xdp_enabled = false;
 	}
 
@@ -3785,6 +3789,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->hw_features |= NETIF_F_GRO_HW;
 
 	dev->vlan_features = dev->features;
+	dev->xdp_features = XDP_F_FULL;
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 14aec417fa06..65820489bb9a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1741,6 +1741,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
          * negotiate with the backend regarding supported features.
          */
 	netdev->features |= netdev->hw_features;
+	netdev->xdp_features = XDP_F_FULL | XDP_F_TX_LOCK | XDP_F_REDIRECT_TARGET;
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffc..68b322735b5c 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -7,6 +7,7 @@
 #define __LINUX_NET_XDP_H__
 
 #include <linux/skbuff.h> /* skb_shared_info */
+#include <linux/xdp_features.h>
 
 /**
  * DOC: XDP RX-queue information
@@ -407,6 +408,44 @@ struct netdev_bpf;
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
 
+#if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
+
+static inline void
+__xdp_features_set_redirect_target(xdp_features_t *xdp_features, u32 flags)
+{
+	flags &= (XDP_F_REDIRECT_TARGET | XDP_F_FRAG_TARGET);
+	WRITE_ONCE(*xdp_features, *xdp_features | flags);
+}
+
+static inline void
+xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
+{
+	WRITE_ONCE(*xdp_features,
+		   *xdp_features & ~(XDP_F_REDIRECT_TARGET | XDP_F_FRAG_TARGET));
+}
+
+#else
+
+static inline void
+__xdp_features_set_redirect_target(xdp_features_t *xdp_features, u32 flags)
+{
+}
+
+static inline void
+xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
+{
+}
+
+#endif
+
+static inline void
+xdp_features_set_redirect_target(xdp_features_t *xdp_features)
+{
+	__xdp_features_set_redirect_target(xdp_features,
+					   XDP_F_REDIRECT_TARGET |
+					   XDP_F_FRAG_TARGET);
+}
+
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
 #endif /* __LINUX_NET_XDP_H__ */
-- 
2.38.1

