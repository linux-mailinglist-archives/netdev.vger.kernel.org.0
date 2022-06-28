Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44FC55E6A1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347087AbiF1OAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbiF1OAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:00:02 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7471336170
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:00:01 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 9F892320102;
        Tue, 28 Jun 2022 15:00:00 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6Bkz-0008Hw-Oh;
        Tue, 28 Jun 2022 14:59:57 +0100
Subject: [PATCH net-next v2 06/10] sfc: Separate efx_nic memory from
 net_device memory
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 14:59:57 +0100
Message-ID: <165642479764.31669.184417069047565479.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

As we have a lot of common code this applies to all NIC architectures.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100.c        |   18 +++++++++++++++---
 drivers/net/ethernet/sfc/ef100_netdev.c |    2 +-
 drivers/net/ethernet/sfc/efx.c          |   20 ++++++++++++++++----
 drivers/net/ethernet/sfc/net_driver.h   |   15 ++++++++++++++-
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 96b99966ce25..a77100239e7c 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -423,6 +423,7 @@ static int ef100_pci_find_func_ctrl_window(struct efx_nic *efx,
  */
 static void ef100_pci_remove(struct pci_dev *pci_dev)
 {
+	struct efx_probe_data *probe_data;
 	struct efx_nic *efx;
 
 	efx = pci_get_drvdata(pci_dev);
@@ -448,6 +449,8 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	pci_set_drvdata(pci_dev, NULL);
 	efx_fini_struct(efx);
 	free_netdev(efx->net_dev);
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	kfree(probe_data);
 
 	pci_disable_pcie_error_reporting(pci_dev);
 };
@@ -455,16 +458,25 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 static int ef100_pci_probe(struct pci_dev *pci_dev,
 			   const struct pci_device_id *entry)
 {
+	struct efx_probe_data *probe_data, **probe_ptr;
 	struct ef100_func_ctl_window fcw = { 0 };
 	struct net_device *net_dev;
 	struct efx_nic *efx;
 	int rc;
 
-	/* Allocate and initialise a struct net_device and struct efx_nic */
-	net_dev = alloc_etherdev_mq(sizeof(*efx), EFX_MAX_CORE_TX_QUEUES);
+	/* Allocate probe data and struct efx_nic */
+	probe_data = kzalloc(sizeof(*probe_data), GFP_KERNEL);
+	if (!probe_data)
+		return -ENOMEM;
+	probe_data->pci_dev = pci_dev;
+	efx = &probe_data->efx;
+
+	/* Allocate and initialise a struct net_device */
+	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
 	if (!net_dev)
 		return -ENOMEM;
-	efx = efx_netdev_priv(net_dev);
+	probe_ptr = netdev_priv(net_dev);
+	*probe_ptr = probe_data;
 	efx->type = (const struct efx_nic_type *)entry->driver_data;
 
 	pci_set_drvdata(pci_dev, efx);
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index e833eaaf61b6..7a80979f4ab7 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -243,7 +243,7 @@ int ef100_netdev_event(struct notifier_block *this,
 	struct efx_nic *efx = container_of(this, struct efx_nic, netdev_notifier);
 	struct net_device *net_dev = netdev_notifier_info_to_dev(ptr);
 
-	if (efx_netdev_priv(net_dev) == efx && event == NETDEV_CHANGENAME)
+	if (efx->net_dev == net_dev && event == NETDEV_CHANGENAME)
 		ef100_update_name(efx);
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index f874835e1764..c88e9de9dcd0 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -861,6 +861,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
  */
 static void efx_pci_remove(struct pci_dev *pci_dev)
 {
+	struct efx_probe_data *probe_data;
 	struct efx_nic *efx;
 
 	efx = pci_get_drvdata(pci_dev);
@@ -889,6 +890,8 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_fini_struct(efx);
 	free_netdev(efx->net_dev);
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	kfree(probe_data);
 
 	pci_disable_pcie_error_reporting(pci_dev);
 };
@@ -1042,16 +1045,25 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 static int efx_pci_probe(struct pci_dev *pci_dev,
 			 const struct pci_device_id *entry)
 {
+	struct efx_probe_data *probe_data, **probe_ptr;
 	struct net_device *net_dev;
 	struct efx_nic *efx;
 	int rc;
 
-	/* Allocate and initialise a struct net_device and struct efx_nic */
-	net_dev = alloc_etherdev_mqs(sizeof(*efx), EFX_MAX_CORE_TX_QUEUES,
-				     EFX_MAX_RX_QUEUES);
+	/* Allocate probe data and struct efx_nic */
+	probe_data = kzalloc(sizeof(*probe_data), GFP_KERNEL);
+	if (!probe_data)
+		return -ENOMEM;
+	probe_data->pci_dev = pci_dev;
+	efx = &probe_data->efx;
+
+	/* Allocate and initialise a struct net_device */
+	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
 	if (!net_dev)
 		return -ENOMEM;
-	efx = efx_netdev_priv(net_dev);
+	probe_ptr = netdev_priv(net_dev);
+	*probe_ptr = probe_data;
+	efx->net_dev = net_dev;
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
 	efx->fixed_features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index df93ffd7092a..2228c88a7f31 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1166,9 +1166,22 @@ struct efx_nic {
 	atomic_t n_rx_noskb_drops;
 };
 
+/**
+ * struct efx_probe_data - State after hardware probe
+ * @pci_dev: The PCI device
+ * @efx: Efx NIC details
+ */
+struct efx_probe_data {
+	struct pci_dev *pci_dev;
+	struct efx_nic efx;
+};
+
 static inline struct efx_nic *efx_netdev_priv(struct net_device *dev)
 {
-	return netdev_priv(dev);
+	struct efx_probe_data **probe_ptr = netdev_priv(dev);
+	struct efx_probe_data *probe_data = *probe_ptr;
+
+	return &probe_data->efx;
 }
 
 static inline int efx_dev_registered(struct efx_nic *efx)


