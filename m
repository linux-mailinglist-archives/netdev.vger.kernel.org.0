Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8281C50BAEE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448706AbiDVPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449056AbiDVPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:01:18 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8C8C5C85B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:58:16 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id C0165320133;
        Fri, 22 Apr 2022 15:58:12 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhuja-00078v-Jb; Fri, 22 Apr 2022 15:58:10 +0100
Subject: [PATCH net-next 05/28] sfc/siena: Rename functions in efx_common.h
 to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:58:09 +0100
Message-ID: <165063948945.27138.11155445182541211296.stgit@palantir17.mph.net>
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

When building with allyesconfig there are many identical
symbol names.
For siena use efx_siena_ as the function and variable prefix
to avoid build errors.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c              |   67 +++++-----
 drivers/net/ethernet/sfc/siena/efx_channels.c     |    6 -
 drivers/net/ethernet/sfc/siena/efx_common.c       |  144 +++++++++++----------
 drivers/net/ethernet/sfc/siena/efx_common.h       |   90 +++++++------
 drivers/net/ethernet/sfc/siena/enum.h             |    2 
 drivers/net/ethernet/sfc/siena/ethtool_common.c   |    6 -
 drivers/net/ethernet/sfc/siena/farch.c            |   16 +-
 drivers/net/ethernet/sfc/siena/mcdi.c             |   12 +-
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c |    6 -
 drivers/net/ethernet/sfc/siena/net_driver.h       |   10 +
 drivers/net/ethernet/sfc/siena/selftest.c         |    8 +
 drivers/net/ethernet/sfc/siena/siena.c            |   14 +-
 drivers/net/ethernet/sfc/siena/tx.c               |    2 
 drivers/net/ethernet/sfc/siena/tx_common.c        |    2 
 14 files changed, 196 insertions(+), 189 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index f11e870b2eef..bc107aac3a8d 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -174,7 +174,7 @@ static void efx_fini_port(struct efx_nic *efx)
 	efx->port_initialized = false;
 
 	efx->link_state.up = false;
-	efx_link_status_changed(efx);
+	efx_siena_link_status_changed(efx);
 }
 
 static void efx_remove_port(struct efx_nic *efx)
@@ -533,14 +533,14 @@ int efx_net_open(struct net_device *net_dev)
 		return rc;
 	if (efx->phy_mode & PHY_MODE_SPECIAL)
 		return -EBUSY;
-	if (efx_mcdi_poll_reboot(efx) && efx_reset(efx, RESET_TYPE_ALL))
+	if (efx_mcdi_poll_reboot(efx) && efx_siena_reset(efx, RESET_TYPE_ALL))
 		return -EIO;
 
 	/* Notify the kernel of the link state polled during driver load,
 	 * before the monitor starts running */
-	efx_link_status_changed(efx);
+	efx_siena_link_status_changed(efx);
 
-	efx_start_all(efx);
+	efx_siena_start_all(efx);
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
 	efx_selftest_async_start(efx);
@@ -559,7 +559,7 @@ int efx_net_stop(struct net_device *net_dev)
 		  raw_smp_processor_id());
 
 	/* Stop the device and flush all the channels */
-	efx_stop_all(efx);
+	efx_siena_stop_all(efx);
 
 	return 0;
 }
@@ -587,16 +587,16 @@ static int efx_vlan_rx_kill_vid(struct net_device *net_dev, __be16 proto, u16 vi
 static const struct net_device_ops efx_netdev_ops = {
 	.ndo_open		= efx_net_open,
 	.ndo_stop		= efx_net_stop,
-	.ndo_get_stats64	= efx_net_stats,
-	.ndo_tx_timeout		= efx_watchdog,
+	.ndo_get_stats64	= efx_siena_net_stats,
+	.ndo_tx_timeout		= efx_siena_watchdog,
 	.ndo_start_xmit		= efx_hard_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_eth_ioctl		= efx_ioctl,
-	.ndo_change_mtu		= efx_change_mtu,
-	.ndo_set_mac_address	= efx_set_mac_address,
-	.ndo_set_rx_mode	= efx_set_rx_mode,
-	.ndo_set_features	= efx_set_features,
-	.ndo_features_check	= efx_features_check,
+	.ndo_change_mtu		= efx_siena_change_mtu,
+	.ndo_set_mac_address	= efx_siena_set_mac_address,
+	.ndo_set_rx_mode	= efx_siena_set_rx_mode,
+	.ndo_set_features	= efx_siena_set_features,
+	.ndo_features_check	= efx_siena_features_check,
 	.ndo_vlan_rx_add_vid	= efx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= efx_vlan_rx_kill_vid,
 #ifdef CONFIG_SFC_SRIOV
@@ -606,8 +606,8 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_get_vf_config	= efx_sriov_get_vf_config,
 	.ndo_set_vf_link_state  = efx_sriov_set_vf_link_state,
 #endif
-	.ndo_get_phys_port_id   = efx_get_phys_port_id,
-	.ndo_get_phys_port_name	= efx_get_phys_port_name,
+	.ndo_get_phys_port_id   = efx_siena_get_phys_port_id,
+	.ndo_get_phys_port_name	= efx_siena_get_phys_port_name,
 	.ndo_setup_tc		= efx_setup_tc,
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= efx_filter_rfs,
@@ -626,10 +626,10 @@ static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog)
 		return -EINVAL;
 	}
 
-	if (prog && efx->net_dev->mtu > efx_xdp_max_mtu(efx)) {
+	if (prog && efx->net_dev->mtu > efx_siena_xdp_max_mtu(efx)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Unable to configure XDP with MTU of %d (max: %d)\n",
-			  efx->net_dev->mtu, efx_xdp_max_mtu(efx));
+			  efx->net_dev->mtu, efx_siena_xdp_max_mtu(efx));
 		return -EINVAL;
 	}
 
@@ -756,7 +756,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 		goto fail_registered;
 	}
 
-	efx_init_mcdi_logging(efx);
+	efx_siena_init_mcdi_logging(efx);
 
 	return 0;
 
@@ -780,7 +780,7 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 
 	if (efx_dev_registered(efx)) {
 		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));
-		efx_fini_mcdi_logging(efx);
+		efx_siena_fini_mcdi_logging(efx);
 		device_remove_file(&efx->pci_dev->dev, &dev_attr_phy_type);
 		unregister_netdev(efx->net_dev);
 	}
@@ -833,7 +833,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	 * are not READY.
 	 */
 	BUG_ON(efx->state == STATE_READY);
-	efx_flush_reset_workqueue(efx);
+	efx_siena_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
 	efx_clear_interrupt_affinity(efx);
@@ -873,10 +873,10 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_pci_remove_main(efx);
 
-	efx_fini_io(efx);
+	efx_siena_fini_io(efx);
 	netif_dbg(efx, drv, efx->net_dev, "shutdown successful\n");
 
-	efx_fini_struct(efx);
+	efx_siena_fini_struct(efx);
 	free_netdev(efx->net_dev);
 
 	pci_disable_pcie_error_reporting(pci_dev);
@@ -1046,7 +1046,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
-	rc = efx_init_struct(efx, pci_dev, net_dev);
+	rc = efx_siena_init_struct(efx, pci_dev, net_dev);
 	if (rc)
 		goto fail1;
 
@@ -1056,8 +1056,9 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		efx_probe_vpd_strings(efx);
 
 	/* Set up basic I/O (BAR mappings etc) */
-	rc = efx_init_io(efx, efx->type->mem_bar(efx), efx->type->max_dma_mask,
-			 efx->type->mem_map_size(efx));
+	rc = efx_siena_init_io(efx, efx->type->mem_bar(efx),
+			       efx->type->max_dma_mask,
+			       efx->type->mem_map_size(efx));
 	if (rc)
 		goto fail2;
 
@@ -1101,9 +1102,9 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	return 0;
 
  fail3:
-	efx_fini_io(efx);
+	efx_siena_fini_io(efx);
  fail2:
-	efx_fini_struct(efx);
+	efx_siena_fini_struct(efx);
  fail1:
 	WARN_ON(rc > 0);
 	netif_dbg(efx, drv, efx->net_dev, "initialisation failed. rc=%d\n", rc);
@@ -1142,7 +1143,7 @@ static int efx_pm_freeze(struct device *dev)
 
 		efx_device_detach_sync(efx);
 
-		efx_stop_all(efx);
+		efx_siena_stop_all(efx);
 		efx_disable_interrupts(efx);
 	}
 
@@ -1167,7 +1168,7 @@ static int efx_pm_thaw(struct device *dev)
 		efx_mcdi_port_reconfigure(efx);
 		mutex_unlock(&efx->mac_lock);
 
-		efx_start_all(efx);
+		efx_siena_start_all(efx);
 
 		efx_device_attach_if_not_resetting(efx);
 
@@ -1179,7 +1180,7 @@ static int efx_pm_thaw(struct device *dev)
 	rtnl_unlock();
 
 	/* Reschedule any quenched resets scheduled during efx_pm_freeze() */
-	efx_queue_reset_work(efx);
+	efx_siena_queue_reset_work(efx);
 
 	return 0;
 
@@ -1255,7 +1256,7 @@ static struct pci_driver efx_pci_driver = {
 	.probe		= efx_pci_probe,
 	.remove		= efx_pci_remove,
 	.driver.pm	= &efx_pm_ops,
-	.err_handler	= &efx_err_handlers,
+	.err_handler	= &efx_siena_err_handlers,
 #ifdef CONFIG_SFC_SRIOV
 	.sriov_configure = efx_pci_sriov_configure,
 #endif
@@ -1277,7 +1278,7 @@ static int __init efx_init_module(void)
 	if (rc)
 		goto err_notifier;
 
-	rc = efx_create_reset_workqueue();
+	rc = efx_siena_create_reset_workqueue();
 	if (rc)
 		goto err_reset;
 
@@ -1288,7 +1289,7 @@ static int __init efx_init_module(void)
 	return 0;
 
  err_pci:
-	efx_destroy_reset_workqueue();
+	efx_siena_destroy_reset_workqueue();
  err_reset:
 	unregister_netdevice_notifier(&efx_netdev_notifier);
  err_notifier:
@@ -1300,7 +1301,7 @@ static void __exit efx_exit_module(void)
 	printk(KERN_INFO "Solarflare NET driver unloading\n");
 
 	pci_unregister_driver(&efx_pci_driver);
-	efx_destroy_reset_workqueue();
+	efx_siena_destroy_reset_workqueue();
 	unregister_netdevice_notifier(&efx_netdev_notifier);
 
 }
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 4ab2ff8e82d3..5e22edc51ad2 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -801,7 +801,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	}
 
 	efx_device_detach_sync(efx);
-	efx_stop_all(efx);
+	efx_siena_stop_all(efx);
 	efx_soft_disable_interrupts(efx);
 
 	/* Clone channels (where possible) */
@@ -854,9 +854,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		rc = rc ? rc : rc2;
 		netif_err(efx, drv, efx->net_dev,
 			  "unable to restart interrupts on channel reallocation\n");
-		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+		efx_siena_schedule_reset(efx, RESET_TYPE_DISABLE);
 	} else {
-		efx_start_all(efx);
+		efx_siena_start_all(efx);
 		efx_device_attach_if_not_resetting(efx);
 	}
 	return rc;
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index f6577e74d6e6..2f53bb9446d6 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -110,7 +110,7 @@ const char *const efx_loopback_mode_names[] = {
  */
 static struct workqueue_struct *reset_workqueue;
 
-int efx_create_reset_workqueue(void)
+int efx_siena_create_reset_workqueue(void)
 {
 	reset_workqueue = create_singlethread_workqueue("sfc_reset");
 	if (!reset_workqueue) {
@@ -121,17 +121,17 @@ int efx_create_reset_workqueue(void)
 	return 0;
 }
 
-void efx_queue_reset_work(struct efx_nic *efx)
+void efx_siena_queue_reset_work(struct efx_nic *efx)
 {
 	queue_work(reset_workqueue, &efx->reset_work);
 }
 
-void efx_flush_reset_workqueue(struct efx_nic *efx)
+void efx_siena_flush_reset_workqueue(struct efx_nic *efx)
 {
 	cancel_work_sync(&efx->reset_work);
 }
 
-void efx_destroy_reset_workqueue(void)
+void efx_siena_destroy_reset_workqueue(void)
 {
 	if (reset_workqueue) {
 		destroy_workqueue(reset_workqueue);
@@ -142,7 +142,7 @@ void efx_destroy_reset_workqueue(void)
 /* We assume that efx->type->reconfigure_mac will always try to sync RX
  * filters and therefore needs to read-lock the filter table against freeing
  */
-void efx_mac_reconfigure(struct efx_nic *efx, bool mtu_only)
+void efx_siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only)
 {
 	if (efx->type->reconfigure_mac) {
 		down_read(&efx->filter_sem);
@@ -161,11 +161,11 @@ static void efx_mac_work(struct work_struct *data)
 
 	mutex_lock(&efx->mac_lock);
 	if (efx->port_enabled)
-		efx_mac_reconfigure(efx, false);
+		efx_siena_mac_reconfigure(efx, false);
 	mutex_unlock(&efx->mac_lock);
 }
 
-int efx_set_mac_address(struct net_device *net_dev, void *data)
+int efx_siena_set_mac_address(struct net_device *net_dev, void *data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct sockaddr *addr = data;
@@ -193,14 +193,14 @@ int efx_set_mac_address(struct net_device *net_dev, void *data)
 
 	/* Reconfigure the MAC */
 	mutex_lock(&efx->mac_lock);
-	efx_mac_reconfigure(efx, false);
+	efx_siena_mac_reconfigure(efx, false);
 	mutex_unlock(&efx->mac_lock);
 
 	return 0;
 }
 
 /* Context: netif_addr_lock held, BHs disabled. */
-void efx_set_rx_mode(struct net_device *net_dev)
+void efx_siena_set_rx_mode(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -209,7 +209,7 @@ void efx_set_rx_mode(struct net_device *net_dev)
 	/* Otherwise efx_start_port() will do this */
 }
 
-int efx_set_features(struct net_device *net_dev, netdev_features_t data)
+int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -226,10 +226,10 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	 */
 	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
 					  NETIF_F_RXFCS)) {
-		/* efx_set_rx_mode() will schedule MAC work to update filters
+		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
-		efx_set_rx_mode(net_dev);
+		efx_siena_set_rx_mode(net_dev);
 	}
 
 	return 0;
@@ -239,7 +239,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
  * netif_carrier_on/off) of the link status, and also maintains the
  * link status's stop on the port's TX queue.
  */
-void efx_link_status_changed(struct efx_nic *efx)
+void efx_siena_link_status_changed(struct efx_nic *efx)
 {
 	struct efx_link_state *link_state = &efx->link_state;
 
@@ -270,7 +270,7 @@ void efx_link_status_changed(struct efx_nic *efx)
 		netif_info(efx, link, efx->net_dev, "link down\n");
 }
 
-unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
+unsigned int efx_siena_xdp_max_mtu(struct efx_nic *efx)
 {
 	/* The maximum MTU that we can fit in a single page, allowing for
 	 * framing, overhead and XDP headroom + tailroom.
@@ -283,7 +283,7 @@ unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
 }
 
 /* Context: process, rtnl_lock() held. */
-int efx_change_mtu(struct net_device *net_dev, int new_mtu)
+int efx_siena_change_mtu(struct net_device *net_dev, int new_mtu)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -293,24 +293,24 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 		return rc;
 
 	if (rtnl_dereference(efx->xdp_prog) &&
-	    new_mtu > efx_xdp_max_mtu(efx)) {
+	    new_mtu > efx_siena_xdp_max_mtu(efx)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Requested MTU of %d too big for XDP (max: %d)\n",
-			  new_mtu, efx_xdp_max_mtu(efx));
+			  new_mtu, efx_siena_xdp_max_mtu(efx));
 		return -EINVAL;
 	}
 
 	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
 
 	efx_device_detach_sync(efx);
-	efx_stop_all(efx);
+	efx_siena_stop_all(efx);
 
 	mutex_lock(&efx->mac_lock);
 	net_dev->mtu = new_mtu;
-	efx_mac_reconfigure(efx, true);
+	efx_siena_mac_reconfigure(efx, true);
 	mutex_unlock(&efx->mac_lock);
 
-	efx_start_all(efx);
+	efx_siena_start_all(efx);
 	efx_device_attach_if_not_resetting(efx);
 	return 0;
 }
@@ -342,10 +342,10 @@ static void efx_monitor(struct work_struct *data)
 		mutex_unlock(&efx->mac_lock);
 	}
 
-	efx_start_monitor(efx);
+	efx_siena_start_monitor(efx);
 }
 
-void efx_start_monitor(struct efx_nic *efx)
+void efx_siena_start_monitor(struct efx_nic *efx)
 {
 	if (efx->type->monitor)
 		queue_delayed_work(efx->workqueue, &efx->monitor_work,
@@ -459,13 +459,13 @@ static void efx_stop_datapath(struct efx_nic *efx)
 /* Equivalent to efx_link_set_advertising with all-zeroes, except does not
  * force the Autoneg bit on.
  */
-void efx_link_clear_advertising(struct efx_nic *efx)
+void efx_siena_link_clear_advertising(struct efx_nic *efx)
 {
 	bitmap_zero(efx->link_advertising, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	efx->wanted_fc &= ~(EFX_FC_TX | EFX_FC_RX);
 }
 
-void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
+void efx_siena_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
 {
 	efx->wanted_fc = wanted_fc;
 	if (efx->link_advertising[0]) {
@@ -489,7 +489,7 @@ static void efx_start_port(struct efx_nic *efx)
 	efx->port_enabled = true;
 
 	/* Ensure MAC ingress/egress is enabled */
-	efx_mac_reconfigure(efx, false);
+	efx_siena_mac_reconfigure(efx, false);
 
 	mutex_unlock(&efx->mac_lock);
 }
@@ -525,7 +525,7 @@ static void efx_stop_port(struct efx_nic *efx)
  * is safe to call multiple times, so long as the NIC is not disabled.
  * Requires the RTNL lock.
  */
-void efx_start_all(struct efx_nic *efx)
+void efx_siena_start_all(struct efx_nic *efx)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->state == STATE_DISABLED);
@@ -541,14 +541,14 @@ void efx_start_all(struct efx_nic *efx)
 	efx_start_datapath(efx);
 
 	/* Start the hardware monitor if there is one */
-	efx_start_monitor(efx);
+	efx_siena_start_monitor(efx);
 
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
 	 */
 	mutex_lock(&efx->mac_lock);
 	if (efx_mcdi_phy_poll(efx))
-		efx_link_status_changed(efx);
+		efx_siena_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
 	if (efx->type->start_stats) {
@@ -565,7 +565,7 @@ void efx_start_all(struct efx_nic *efx)
  * times with the NIC in almost any state, but interrupts should be
  * enabled.  Requires the RTNL lock.
  */
-void efx_stop_all(struct efx_nic *efx)
+void efx_siena_stop_all(struct efx_nic *efx)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
 
@@ -598,7 +598,8 @@ void efx_stop_all(struct efx_nic *efx)
 }
 
 /* Context: process, dev_base_lock or RTNL held, non-blocking. */
-void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
+void efx_siena_net_stats(struct net_device *net_dev,
+			 struct rtnl_link_stats64 *stats)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -614,7 +615,7 @@ void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
  *
  * Callers must hold the mac_lock
  */
-int __efx_reconfigure_port(struct efx_nic *efx)
+int __efx_siena_reconfigure_port(struct efx_nic *efx)
 {
 	enum efx_phy_mode phy_mode;
 	int rc = 0;
@@ -640,14 +641,14 @@ int __efx_reconfigure_port(struct efx_nic *efx)
 /* Reinitialise the MAC to pick up new PHY settings, even if the port is
  * disabled.
  */
-int efx_reconfigure_port(struct efx_nic *efx)
+int efx_siena_reconfigure_port(struct efx_nic *efx)
 {
 	int rc;
 
 	EFX_ASSERT_RESET_SERIALISED(efx);
 
 	mutex_lock(&efx->mac_lock);
-	rc = __efx_reconfigure_port(efx);
+	rc = __efx_siena_reconfigure_port(efx);
 	mutex_unlock(&efx->mac_lock);
 
 	return rc;
@@ -682,7 +683,7 @@ static void efx_wait_for_bist_end(struct efx_nic *efx)
  * Returns 0 if the recovery mechanisms are unsuccessful.
  * Returns a non-zero value otherwise.
  */
-int efx_try_recovery(struct efx_nic *efx)
+int efx_siena_try_recovery(struct efx_nic *efx)
 {
 #ifdef CONFIG_EEH
 	/* A PCI error can occur and not be seen by EEH because nothing
@@ -704,14 +705,14 @@ int efx_try_recovery(struct efx_nic *efx)
 /* Tears down the entire software state and most of the hardware state
  * before reset.
  */
-void efx_reset_down(struct efx_nic *efx, enum reset_type method)
+void efx_siena_reset_down(struct efx_nic *efx, enum reset_type method)
 {
 	EFX_ASSERT_RESET_SERIALISED(efx);
 
 	if (method == RESET_TYPE_MCDI_TIMEOUT)
 		efx->type->prepare_flr(efx);
 
-	efx_stop_all(efx);
+	efx_siena_stop_all(efx);
 	efx_disable_interrupts(efx);
 
 	mutex_lock(&efx->mac_lock);
@@ -721,7 +722,7 @@ void efx_reset_down(struct efx_nic *efx, enum reset_type method)
 }
 
 /* Context: netif_tx_lock held, BHs disabled. */
-void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
+void efx_siena_watchdog(struct net_device *net_dev, unsigned int txqueue)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -729,16 +730,16 @@ void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
 		  "TX stuck with port_enabled=%d: resetting channels\n",
 		  efx->port_enabled);
 
-	efx_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
+	efx_siena_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
 }
 
 /* This function will always ensure that the locks acquired in
- * efx_reset_down() are released. A failure return code indicates
+ * efx_siena_reset_down() are released. A failure return code indicates
  * that we were unable to reinitialise the hardware, and the
  * driver should be disabled. If ok is false, then the rx and tx
  * engines are not restarted, pending a RESET_DISABLE.
  */
-int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
+int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 {
 	int rc;
 
@@ -787,7 +788,7 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	mutex_unlock(&efx->mac_lock);
 
-	efx_start_all(efx);
+	efx_siena_start_all(efx);
 
 	if (efx->type->udp_tnl_push_ports)
 		efx->type->udp_tnl_push_ports(efx);
@@ -809,7 +810,7 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
  *
  * Caller must hold the rtnl_lock.
  */
-int efx_reset(struct efx_nic *efx, enum reset_type method)
+int efx_siena_reset(struct efx_nic *efx, enum reset_type method)
 {
 	int rc, rc2 = 0;
 	bool disabled;
@@ -818,11 +819,11 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 		   RESET_TYPE(method));
 
 	efx_device_detach_sync(efx);
-	/* efx_reset_down() grabs locks that prevent recovery on EF100.
+	/* efx_siena_reset_down() grabs locks that prevent recovery on EF100.
 	 * EF100 reset is handled in the efx_nic_type callback below.
 	 */
 	if (efx_nic_rev(efx) != EFX_REV_EF100)
-		efx_reset_down(efx, method);
+		efx_siena_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
 	if (rc) {
@@ -851,7 +852,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 		method == RESET_TYPE_DISABLE ||
 		method == RESET_TYPE_RECOVER_OR_DISABLE;
 	if (efx_nic_rev(efx) != EFX_REV_EF100)
-		rc2 = efx_reset_up(efx, method, !disabled);
+		rc2 = efx_siena_reset_up(efx, method, !disabled);
 	if (rc2) {
 		disabled = true;
 		if (!rc)
@@ -886,7 +887,7 @@ static void efx_reset_work(struct work_struct *data)
 
 	if ((method == RESET_TYPE_RECOVER_OR_DISABLE ||
 	     method == RESET_TYPE_RECOVER_OR_ALL) &&
-	    efx_try_recovery(efx))
+	    efx_siena_try_recovery(efx))
 		return;
 
 	if (!pending)
@@ -894,17 +895,17 @@ static void efx_reset_work(struct work_struct *data)
 
 	rtnl_lock();
 
-	/* We checked the state in efx_schedule_reset() but it may
+	/* We checked the state in efx_siena_schedule_reset() but it may
 	 * have changed by now.  Now that we have the RTNL lock,
 	 * it cannot change again.
 	 */
 	if (efx->state == STATE_READY)
-		(void)efx_reset(efx, method);
+		(void)efx_siena_reset(efx, method);
 
 	rtnl_unlock();
 }
 
-void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
+void efx_siena_schedule_reset(struct efx_nic *efx, enum reset_type type)
 {
 	enum reset_type method;
 
@@ -951,7 +952,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	 */
 	efx_mcdi_mode_poll(efx);
 
-	efx_queue_reset_work(efx);
+	efx_siena_queue_reset_work(efx);
 }
 
 /**************************************************************************
@@ -963,11 +964,12 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
  * before use
  *
  **************************************************************************/
-int efx_port_dummy_op_int(struct efx_nic *efx)
+int efx_siena_port_dummy_op_int(struct efx_nic *efx)
 {
 	return 0;
 }
-void efx_port_dummy_op_void(struct efx_nic *efx) {}
+
+void efx_siena_port_dummy_op_void(struct efx_nic *efx) {}
 
 /**************************************************************************
  *
@@ -978,8 +980,8 @@ void efx_port_dummy_op_void(struct efx_nic *efx) {}
 /* This zeroes out and then fills in the invariants in a struct
  * efx_nic (including all sub-structures).
  */
-int efx_init_struct(struct efx_nic *efx,
-		    struct pci_dev *pci_dev, struct net_device *net_dev)
+int efx_siena_init_struct(struct efx_nic *efx,
+			  struct pci_dev *pci_dev, struct net_device *net_dev)
 {
 	int rc = -ENOMEM;
 
@@ -1049,11 +1051,11 @@ int efx_init_struct(struct efx_nic *efx,
 	return 0;
 
 fail:
-	efx_fini_struct(efx);
+	efx_siena_fini_struct(efx);
 	return rc;
 }
 
-void efx_fini_struct(struct efx_nic *efx)
+void efx_siena_fini_struct(struct efx_nic *efx)
 {
 #ifdef CONFIG_RFS_ACCEL
 	kfree(efx->rps_hash_table);
@@ -1070,8 +1072,8 @@ void efx_fini_struct(struct efx_nic *efx)
 }
 
 /* This configures the PCI device to enable I/O and DMA. */
-int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
-		unsigned int mem_map_size)
+int efx_siena_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
+		      unsigned int mem_map_size)
 {
 	struct pci_dev *pci_dev = efx->pci_dev;
 	int rc;
@@ -1140,7 +1142,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
 	return rc;
 }
 
-void efx_fini_io(struct efx_nic *efx)
+void efx_siena_fini_io(struct efx_nic *efx)
 {
 	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
 
@@ -1185,7 +1187,7 @@ static ssize_t mcdi_logging_store(struct device *dev,
 
 static DEVICE_ATTR_RW(mcdi_logging);
 
-void efx_init_mcdi_logging(struct efx_nic *efx)
+void efx_siena_init_mcdi_logging(struct efx_nic *efx)
 {
 	int rc = device_create_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
 
@@ -1195,7 +1197,7 @@ void efx_init_mcdi_logging(struct efx_nic *efx)
 	}
 }
 
-void efx_fini_mcdi_logging(struct efx_nic *efx)
+void efx_siena_fini_mcdi_logging(struct efx_nic *efx)
 {
 	device_remove_file(&efx->pci_dev->dev, &dev_attr_mcdi_logging);
 }
@@ -1222,7 +1224,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 
 		efx_device_detach_sync(efx);
 
-		efx_stop_all(efx);
+		efx_siena_stop_all(efx);
 		efx_disable_interrupts(efx);
 
 		status = PCI_ERS_RESULT_NEED_RESET;
@@ -1266,10 +1268,10 @@ static void efx_io_resume(struct pci_dev *pdev)
 	if (efx->state == STATE_DISABLED)
 		goto out;
 
-	rc = efx_reset(efx, RESET_TYPE_ALL);
+	rc = efx_siena_reset(efx, RESET_TYPE_ALL);
 	if (rc) {
 		netif_err(efx, hw, efx->net_dev,
-			  "efx_reset failed after PCI error (%d)\n", rc);
+			  "efx_siena_reset failed after PCI error (%d)\n", rc);
 	} else {
 		efx->state = STATE_READY;
 		netif_dbg(efx, hw, efx->net_dev,
@@ -1286,7 +1288,7 @@ static void efx_io_resume(struct pci_dev *pdev)
  * with our request for slot reset the mmio_enabled callback will never be
  * called, and the link_reset callback is not used by AER or EEH mechanisms.
  */
-const struct pci_error_handlers efx_err_handlers = {
+const struct pci_error_handlers efx_siena_err_handlers = {
 	.error_detected = efx_io_error_detected,
 	.slot_reset	= efx_io_slot_reset,
 	.resume		= efx_io_resume,
@@ -1354,8 +1356,9 @@ static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
 	}
 }
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features)
+netdev_features_t efx_siena_features_check(struct sk_buff *skb,
+					   struct net_device *dev,
+					   netdev_features_t features)
 {
 	struct efx_nic *efx = netdev_priv(dev);
 
@@ -1375,8 +1378,8 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 	return features;
 }
 
-int efx_get_phys_port_id(struct net_device *net_dev,
-			 struct netdev_phys_item_id *ppid)
+int efx_siena_get_phys_port_id(struct net_device *net_dev,
+			       struct netdev_phys_item_id *ppid)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -1386,7 +1389,8 @@ int efx_get_phys_port_id(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 }
 
-int efx_get_phys_port_name(struct net_device *net_dev, char *name, size_t len)
+int efx_siena_get_phys_port_name(struct net_device *net_dev,
+				 char *name, size_t len)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.h b/drivers/net/ethernet/sfc/siena/efx_common.h
index 65513fd0cf6c..470033611436 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.h
+++ b/drivers/net/ethernet/sfc/siena/efx_common.h
@@ -11,12 +11,12 @@
 #ifndef EFX_COMMON_H
 #define EFX_COMMON_H
 
-int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
-		unsigned int mem_map_size);
-void efx_fini_io(struct efx_nic *efx);
-int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
-		    struct net_device *net_dev);
-void efx_fini_struct(struct efx_nic *efx);
+int efx_siena_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
+		      unsigned int mem_map_size);
+void efx_siena_fini_io(struct efx_nic *efx);
+int efx_siena_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
+			  struct net_device *net_dev);
+void efx_siena_fini_struct(struct efx_nic *efx);
 
 #define EFX_MAX_DMAQ_SIZE 4096UL
 #define EFX_DEFAULT_DMAQ_SIZE 1024UL
@@ -25,23 +25,24 @@ void efx_fini_struct(struct efx_nic *efx);
 #define EFX_MAX_EVQ_SIZE 16384UL
 #define EFX_MIN_EVQ_SIZE 512UL
 
-void efx_link_clear_advertising(struct efx_nic *efx);
-void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
+void efx_siena_link_clear_advertising(struct efx_nic *efx);
+void efx_siena_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc);
 
-void efx_start_all(struct efx_nic *efx);
-void efx_stop_all(struct efx_nic *efx);
+void efx_siena_start_all(struct efx_nic *efx);
+void efx_siena_stop_all(struct efx_nic *efx);
 
-void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
+void efx_siena_net_stats(struct net_device *net_dev,
+			 struct rtnl_link_stats64 *stats);
 
-int efx_create_reset_workqueue(void);
-void efx_queue_reset_work(struct efx_nic *efx);
-void efx_flush_reset_workqueue(struct efx_nic *efx);
-void efx_destroy_reset_workqueue(void);
+int efx_siena_create_reset_workqueue(void);
+void efx_siena_queue_reset_work(struct efx_nic *efx);
+void efx_siena_flush_reset_workqueue(struct efx_nic *efx);
+void efx_siena_destroy_reset_workqueue(void);
 
-void efx_start_monitor(struct efx_nic *efx);
+void efx_siena_start_monitor(struct efx_nic *efx);
 
-int __efx_reconfigure_port(struct efx_nic *efx);
-int efx_reconfigure_port(struct efx_nic *efx);
+int __efx_siena_reconfigure_port(struct efx_nic *efx);
+int efx_siena_reconfigure_port(struct efx_nic *efx);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
@@ -51,16 +52,16 @@ int efx_reconfigure_port(struct efx_nic *efx);
 			ASSERT_RTNL();			\
 	} while (0)
 
-int efx_try_recovery(struct efx_nic *efx);
-void efx_reset_down(struct efx_nic *efx, enum reset_type method);
-void efx_watchdog(struct net_device *net_dev, unsigned int txqueue);
-int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
-int efx_reset(struct efx_nic *efx, enum reset_type method);
-void efx_schedule_reset(struct efx_nic *efx, enum reset_type type);
+int efx_siena_try_recovery(struct efx_nic *efx);
+void efx_siena_reset_down(struct efx_nic *efx, enum reset_type method);
+void efx_siena_watchdog(struct net_device *net_dev, unsigned int txqueue);
+int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok);
+int efx_siena_reset(struct efx_nic *efx, enum reset_type method);
+void efx_siena_schedule_reset(struct efx_nic *efx, enum reset_type type);
 
 /* Dummy PHY ops for PHY drivers */
-int efx_port_dummy_op_int(struct efx_nic *efx);
-void efx_port_dummy_op_void(struct efx_nic *efx);
+int efx_siena_port_dummy_op_int(struct efx_nic *efx);
+void efx_siena_port_dummy_op_void(struct efx_nic *efx);
 
 static inline int efx_check_disabled(struct efx_nic *efx)
 {
@@ -88,29 +89,30 @@ static inline void efx_schedule_channel_irq(struct efx_channel *channel)
 }
 
 #ifdef CONFIG_SFC_MCDI_LOGGING
-void efx_init_mcdi_logging(struct efx_nic *efx);
-void efx_fini_mcdi_logging(struct efx_nic *efx);
+void efx_siena_init_mcdi_logging(struct efx_nic *efx);
+void efx_siena_fini_mcdi_logging(struct efx_nic *efx);
 #else
-static inline void efx_init_mcdi_logging(struct efx_nic *efx) {}
-static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
+static inline void efx_siena_init_mcdi_logging(struct efx_nic *efx) {}
+static inline void efx_siena_fini_mcdi_logging(struct efx_nic *efx) {}
 #endif
 
-void efx_mac_reconfigure(struct efx_nic *efx, bool mtu_only);
-int efx_set_mac_address(struct net_device *net_dev, void *data);
-void efx_set_rx_mode(struct net_device *net_dev);
-int efx_set_features(struct net_device *net_dev, netdev_features_t data);
-void efx_link_status_changed(struct efx_nic *efx);
-unsigned int efx_xdp_max_mtu(struct efx_nic *efx);
-int efx_change_mtu(struct net_device *net_dev, int new_mtu);
+void efx_siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only);
+int efx_siena_set_mac_address(struct net_device *net_dev, void *data);
+void efx_siena_set_rx_mode(struct net_device *net_dev);
+int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data);
+void efx_siena_link_status_changed(struct efx_nic *efx);
+unsigned int efx_siena_xdp_max_mtu(struct efx_nic *efx);
+int efx_siena_change_mtu(struct net_device *net_dev, int new_mtu);
 
-extern const struct pci_error_handlers efx_err_handlers;
+extern const struct pci_error_handlers efx_siena_err_handlers;
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features);
+netdev_features_t efx_siena_features_check(struct sk_buff *skb,
+					   struct net_device *dev,
+					   netdev_features_t features);
 
-int efx_get_phys_port_id(struct net_device *net_dev,
-			 struct netdev_phys_item_id *ppid);
+int efx_siena_get_phys_port_id(struct net_device *net_dev,
+			       struct netdev_phys_item_id *ppid);
 
-int efx_get_phys_port_name(struct net_device *net_dev,
-			   char *name, size_t len);
+int efx_siena_get_phys_port_name(struct net_device *net_dev,
+				 char *name, size_t len);
 #endif
diff --git a/drivers/net/ethernet/sfc/siena/enum.h b/drivers/net/ethernet/sfc/siena/enum.h
index cd590e0685e5..25b28b3969d7 100644
--- a/drivers/net/ethernet/sfc/siena/enum.h
+++ b/drivers/net/ethernet/sfc/siena/enum.h
@@ -127,7 +127,7 @@ enum efx_loopback_mode {
  *
  * %RESET_TYPE_INVSIBLE, %RESET_TYPE_ALL, %RESET_TYPE_WORLD and
  * %RESET_TYPE_DISABLE specify the method/scope of the reset.  The
- * other valuesspecify reasons, which efx_schedule_reset() will choose
+ * other valuesspecify reasons, which efx_siena_schedule_reset() will choose
  * a method for.
  *
  * Reset methods are numbered in order of increasing scope.
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index bd552c7dffcb..e177b58e0664 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -218,7 +218,7 @@ int efx_ethtool_set_pauseparam(struct net_device *net_dev,
 
 	old_adv = efx->link_advertising[0];
 	old_fc = efx->wanted_fc;
-	efx_link_set_wanted_fc(efx, wanted_fc);
+	efx_siena_link_set_wanted_fc(efx, wanted_fc);
 	if (efx->link_advertising[0] != old_adv ||
 	    (efx->wanted_fc ^ old_fc) & EFX_FC_AUTO) {
 		rc = efx_mcdi_port_reconfigure(efx);
@@ -233,7 +233,7 @@ int efx_ethtool_set_pauseparam(struct net_device *net_dev,
 	/* Reconfigure the MAC. The PHY *may* generate a link state change event
 	 * if the user just changed the advertised capabilities, but there's no
 	 * harm doing this twice */
-	efx_mac_reconfigure(efx, false);
+	efx_siena_mac_reconfigure(efx, false);
 
 out:
 	mutex_unlock(&efx->mac_lock);
@@ -1307,7 +1307,7 @@ int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
 	if (rc < 0)
 		return rc;
 
-	return efx_reset(efx, rc);
+	return efx_siena_reset(efx, rc);
 }
 
 int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 9599123bc28d..8c85bda54b86 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -849,7 +849,7 @@ efx_farch_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
 		efx_farch_notify_tx_desc(tx_queue);
 		netif_tx_unlock(efx->net_dev);
 	} else if (EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_PKT_ERR)) {
-		efx_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
+		efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 	} else {
 		netif_err(efx, tx_err, efx->net_dev,
 			  "channel %d unexpected TX event "
@@ -956,7 +956,7 @@ efx_farch_handle_rx_bad_index(struct efx_rx_queue *rx_queue, unsigned index)
 		   "dropped %d events (index=%d expected=%d)\n",
 		   dropped, index, expected);
 
-	efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+	efx_siena_schedule_reset(efx, RESET_TYPE_DISABLE);
 	return false;
 }
 
@@ -1222,7 +1222,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 			  "channel %d seen DRIVER RX_RESET event. "
 			"Resetting.\n", channel->channel);
 		atomic_inc(&efx->rx_reset);
-		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+		efx_siena_schedule_reset(efx, RESET_TYPE_DISABLE);
 		break;
 	case FSE_BZ_RX_DSC_ERROR_EV:
 		if (ev_sub_data < EFX_VI_BASE) {
@@ -1230,7 +1230,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 				  "RX DMA Q %d reports descriptor fetch error."
 				  " RX Q %d is disabled.\n", ev_sub_data,
 				  ev_sub_data);
-			efx_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
+			efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 		}
 #ifdef CONFIG_SFC_SRIOV
 		else
@@ -1243,7 +1243,7 @@ efx_farch_handle_driver_event(struct efx_channel *channel, efx_qword_t *event)
 				  "TX DMA Q %d reports descriptor fetch error."
 				  " TX Q %d is disabled.\n", ev_sub_data,
 				  ev_sub_data);
-			efx_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
+			efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 		}
 #ifdef CONFIG_SFC_SRIOV
 		else
@@ -1496,12 +1496,12 @@ irqreturn_t efx_farch_fatal_interrupt(struct efx_nic *efx)
 	if (++efx->int_error_count < EFX_MAX_INT_ERRORS) {
 		netif_err(efx, hw, efx->net_dev,
 			  "SYSTEM ERROR - reset scheduled\n");
-		efx_schedule_reset(efx, RESET_TYPE_INT_ERROR);
+		efx_siena_schedule_reset(efx, RESET_TYPE_INT_ERROR);
 	} else {
 		netif_err(efx, hw, efx->net_dev,
 			  "SYSTEM ERROR - max number of errors seen."
 			  "NIC will be disabled\n");
-		efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+		efx_siena_schedule_reset(efx, RESET_TYPE_DISABLE);
 	}
 
 	return IRQ_HANDLED;
@@ -1529,7 +1529,7 @@ irqreturn_t efx_farch_legacy_interrupt(int irq, void *dev_id)
 	 * code. Disable them earlier.
 	 * If an EEH error occurred, the read will have returned all ones.
 	 */
-	if (EFX_DWORD_IS_ALL_ONES(reg) && efx_try_recovery(efx) &&
+	if (EFX_DWORD_IS_ALL_ONES(reg) && efx_siena_try_recovery(efx) &&
 	    !efx->eeh_disabled_legacy_irq) {
 		disable_irq_nosync(efx->legacy_irq);
 		efx->eeh_disabled_legacy_irq = true;
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 50baf62b2cbc..7f8f0889bf8d 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -725,7 +725,7 @@ static int _efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned int cmd,
 				  cmd, -rc);
 			if (efx->type->mcdi_reboot_detected)
 				efx->type->mcdi_reboot_detected(efx);
-			efx_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
+			efx_siena_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
 		} else if (proxy_handle && (rc == -EPROTO) &&
 			   efx_mcdi_get_proxy_handle(efx, hdr_len, data_len,
 						     proxy_handle)) {
@@ -849,7 +849,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 				       cmd, rc);
 
 			if (rc == -EINTR || rc == -EIO)
-				efx_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
+				efx_siena_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
 			efx_mcdi_release(mcdi);
 		}
 	}
@@ -1254,7 +1254,7 @@ static void efx_mcdi_ev_death(struct efx_nic *efx, int rc)
 		mcdi->new_epoch = true;
 
 		/* Nobody was waiting for an MCDI request, so trigger a reset */
-		efx_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
+		efx_siena_schedule_reset(efx, RESET_TYPE_MC_FAILURE);
 	}
 
 	spin_unlock(&mcdi->iface_lock);
@@ -1282,7 +1282,7 @@ static void efx_mcdi_ev_bist(struct efx_nic *efx)
 		}
 	}
 	mcdi->new_epoch = true;
-	efx_schedule_reset(efx, RESET_TYPE_MC_BIST);
+	efx_siena_schedule_reset(efx, RESET_TYPE_MC_BIST);
 	spin_unlock(&mcdi->iface_lock);
 }
 
@@ -1296,7 +1296,7 @@ static void efx_mcdi_abandon(struct efx_nic *efx)
 	if (xchg(&mcdi->mode, MCDI_MODE_FAIL) == MCDI_MODE_FAIL)
 		return; /* it had already been done */
 	netif_dbg(efx, hw, efx->net_dev, "MCDI is timing out; trying to recover\n");
-	efx_schedule_reset(efx, RESET_TYPE_MCDI_TIMEOUT);
+	efx_siena_schedule_reset(efx, RESET_TYPE_MCDI_TIMEOUT);
 }
 
 static void efx_handle_drain_event(struct efx_nic *efx)
@@ -1387,7 +1387,7 @@ void efx_mcdi_process_event(struct efx_channel *channel,
 			  "%s DMA error (event: "EFX_QWORD_FMT")\n",
 			  code == MCDI_EVENT_CODE_TX_ERR ? "TX" : "RX",
 			  EFX_QWORD_VAL(*event));
-		efx_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
+		efx_siena_schedule_reset(efx, RESET_TYPE_DMA_ERROR);
 		break;
 	case MCDI_EVENT_CODE_PROXY_RESPONSE:
 		efx_mcdi_ev_proxy_response(efx,
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
index 899cc1671004..57908045fb15 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
@@ -518,7 +518,7 @@ int efx_mcdi_phy_probe(struct efx_nic *efx)
 	efx->wanted_fc = EFX_FC_RX | EFX_FC_TX;
 	if (phy_data->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
 		efx->wanted_fc |= EFX_FC_AUTO;
-	efx_link_set_wanted_fc(efx, efx->wanted_fc);
+	efx_siena_link_set_wanted_fc(efx, efx->wanted_fc);
 
 	return 0;
 
@@ -605,7 +605,7 @@ int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_li
 		efx_link_set_advertising(efx, cmd->link_modes.advertising);
 		phy_cfg->forced_cap = 0;
 	} else {
-		efx_link_clear_advertising(efx);
+		efx_siena_link_clear_advertising(efx);
 		phy_cfg->forced_cap = caps;
 	}
 	return 0;
@@ -1297,5 +1297,5 @@ void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
 
 	efx_mcdi_phy_check_fcntl(efx, lpa);
 
-	efx_link_status_changed(efx);
+	efx_siena_link_status_changed(efx);
 }
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 318db906a154..ec88bbfcb5be 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -869,12 +869,12 @@ enum efx_xdp_tx_queues_mode {
  * @nic_data: Hardware dependent state
  * @mcdi: Management-Controller-to-Driver Interface state
  * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
- *	efx_monitor() and efx_reconfigure_port()
+ *	efx_monitor() and efx_siena_reconfigure_port()
  * @port_enabled: Port enabled indicator.
- *	Serialises efx_stop_all(), efx_start_all(), efx_monitor() and
- *	efx_mac_work() with kernel interfaces. Safe to read under any
- *	one of the rtnl_lock, mac_lock, or netif_tx_lock, but all three must
- *	be held to modify it.
+ *	Serialises efx_siena_stop_all(), efx_siena_start_all(),
+ *	efx_monitor() and efx_mac_work() with kernel interfaces.
+ *	Safe to read under any one of the rtnl_lock, mac_lock, or netif_tx_lock,
+ *	but all three must be held to modify it.
  * @port_initialized: Port initialized?
  * @net_dev: Operating system network device. Consider holding the rtnl lock
  * @fixed_features: Features which cannot be turned off
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 3c5227afd497..1985f5fc0a8f 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -637,7 +637,7 @@ static int efx_test_loopbacks(struct efx_nic *efx, struct efx_self_tests *tests,
 		state->flush = true;
 		mutex_lock(&efx->mac_lock);
 		efx->loopback_mode = mode;
-		rc = __efx_reconfigure_port(efx);
+		rc = __efx_siena_reconfigure_port(efx);
 		mutex_unlock(&efx->mac_lock);
 		if (rc) {
 			netif_err(efx, drv, efx->net_dev,
@@ -731,7 +731,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 		if (rc_reset) {
 			netif_err(efx, hw, efx->net_dev,
 				  "Unable to recover from chip test\n");
-			efx_schedule_reset(efx, RESET_TYPE_DISABLE);
+			efx_siena_schedule_reset(efx, RESET_TYPE_DISABLE);
 			return rc_reset;
 		}
 
@@ -744,7 +744,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	mutex_lock(&efx->mac_lock);
 	efx->phy_mode &= ~PHY_MODE_LOW_POWER;
 	efx->loopback_mode = LOOPBACK_NONE;
-	__efx_reconfigure_port(efx);
+	__efx_siena_reconfigure_port(efx);
 	mutex_unlock(&efx->mac_lock);
 
 	rc = efx_test_phy(efx, tests, flags);
@@ -759,7 +759,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	mutex_lock(&efx->mac_lock);
 	efx->phy_mode = phy_mode;
 	efx->loopback_mode = loopback_mode;
-	__efx_reconfigure_port(efx);
+	__efx_siena_reconfigure_port(efx);
 	mutex_unlock(&efx->mac_lock);
 
 	efx_device_attach_if_not_resetting(efx);
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index ce3060e15b54..e072b5842f78 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -102,7 +102,7 @@ static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 	enum reset_type reset_method = RESET_TYPE_ALL;
 	int rc, rc2;
 
-	efx_reset_down(efx, reset_method);
+	efx_siena_reset_down(efx, reset_method);
 
 	/* Reset the chip immediately so that it is completely
 	 * quiescent regardless of what any VF driver does.
@@ -118,7 +118,7 @@ static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 
 	rc = efx_mcdi_reset(efx, reset_method);
 out:
-	rc2 = efx_reset_up(efx, reset_method, rc == 0);
+	rc2 = efx_siena_reset_up(efx, reset_method, rc == 0);
 	return rc ? rc : rc2;
 }
 
@@ -980,7 +980,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.remove = siena_remove_nic,
 	.init = siena_init_nic,
 	.dimension_resources = siena_dimension_resources,
-	.fini = efx_port_dummy_op_void,
+	.fini = efx_siena_port_dummy_op_void,
 #ifdef CONFIG_EEH
 	.monitor = siena_monitor,
 #else
@@ -994,7 +994,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.fini_dmaq = efx_farch_fini_dmaq,
 	.prepare_flush = siena_prepare_flush,
 	.finish_flush = siena_finish_flush,
-	.prepare_flr = efx_port_dummy_op_void,
+	.prepare_flr = efx_siena_port_dummy_op_void,
 	.finish_flr = efx_farch_finish_flr,
 	.describe_stats = siena_describe_nic_stats,
 	.update_stats = siena_update_nic_stats,
@@ -1075,9 +1075,9 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.sriov_set_vf_vlan = efx_siena_sriov_set_vf_vlan,
 	.sriov_set_vf_spoofchk = efx_siena_sriov_set_vf_spoofchk,
 	.sriov_get_vf_config = efx_siena_sriov_get_vf_config,
-	.vswitching_probe = efx_port_dummy_op_int,
-	.vswitching_restore = efx_port_dummy_op_int,
-	.vswitching_remove = efx_port_dummy_op_void,
+	.vswitching_probe = efx_siena_port_dummy_op_int,
+	.vswitching_restore = efx_siena_port_dummy_op_int,
+	.vswitching_remove = efx_siena_port_dummy_op_void,
 	.set_mac_address = efx_siena_sriov_mac_address_changed,
 #endif
 
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index 81ef6dc353f7..9777a0af0790 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -370,7 +370,7 @@ void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
 			netif_err(efx, hw, efx->net_dev,
 				  "TX queue %d spurious single TX completion\n",
 				  tx_queue->queue);
-			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
+			efx_siena_schedule_reset(efx, RESET_TYPE_TX_SKIP);
 			return;
 		}
 
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index d530cde2b864..622c8d72b52f 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -212,7 +212,7 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
 			netif_err(efx, tx_err, efx->net_dev,
 				  "TX queue %d spurious TX completion id %d\n",
 				  tx_queue->queue, read_ptr);
-			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
+			efx_siena_schedule_reset(efx, RESET_TYPE_TX_SKIP);
 			return;
 		}
 

