Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4B4D9447
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345099AbiCOGBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345005AbiCOGBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:01:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3DF49F3D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE22B81118
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C989DC36AE2;
        Tue, 15 Mar 2022 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647324017;
        bh=cl0PxrQPIzU76kiF1TO9XSRV0dyibwWuRAlnIJjHUuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xlv3aEYLrmrhF4x0nRNjktyaIL6esXHX/VbqlZeLg/10U39qkKQ7Kdvm9FOuV1F9D
         tqvJjLMzSwsIVzVo0VevnYEO+HR/AUFpSXzPcoCO1oS8BDvtGB168GRNSG2abZhszG
         Y+OwlaKmmKFNGwqtvIqLu5eluXVxCbmG+173VeL8+axx6/67P1kI1TZ7RBpY9IJe7j
         MJhVmqvn+2giMD0JQSU8J61VYXc7tMq2+Ti7keOWEGRjsWeP7kdZ7ZiSqCOK9l2Xb3
         ZsCvM4isotOxWxIQfM4zal3rMXECbQNurBUTiF9Y472yFSrnRJbAzx+VVCAUW9vmPq
         qrNi0cA5ov1Dw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] eth: nfp: replace driver's "pf" lock with devlink instance lock
Date:   Mon, 14 Mar 2022 23:00:06 -0700
Message-Id: <20220315060009.1028519-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole reason for existence of the pf mutex is that we could
not lock the devlink instance around port splitting. There are
more types of reconfig which can make ports appear or disappear.
Now that the devlink instance lock is exposed to drivers and
"locked" helpers exist we can switch to using the devlink lock
directly.

Next patches will move the locking inside .port_(un)split to
the core.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_app.h  | 11 +++---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 16 ++++-----
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 19 ++++++-----
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  6 ++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 34 +++++++++++--------
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  3 +-
 6 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.h b/drivers/net/ethernet/netronome/nfp/nfp_app.h
index 60cb8a71e02d..dd56207df246 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.h
@@ -4,12 +4,10 @@
 #ifndef _NFP_APP_H
 #define _NFP_APP_H 1
 
-#include <linux/lockdep.h>
 #include <net/devlink.h>
 
 #include <trace/events/devlink.h>
 
-#include "nfp_main.h"
 #include "nfp_net_repr.h"
 
 #define NFP_APP_CTRL_MTU_MAX	U32_MAX
@@ -77,7 +75,7 @@ extern const struct nfp_app_type app_abm;
  * @bpf:	BPF ndo offload-related calls
  * @xdp_offload:    offload an XDP program
  * @eswitch_mode_get:    get SR-IOV eswitch mode
- * @eswitch_mode_set:    set SR-IOV eswitch mode (under pf->lock)
+ * @eswitch_mode_set:    set SR-IOV eswitch mode
  * @sriov_enable: app-specific sriov initialisation
  * @sriov_disable: app-specific sriov clean-up
  * @dev_get:	get representor or internal port representing netdev
@@ -178,10 +176,13 @@ struct nfp_app {
 
 static inline void assert_nfp_app_locked(struct nfp_app *app)
 {
-	lockdep_assert_held(&app->pf->lock);
+	devl_assert_locked(priv_to_devlink(app->pf));
 }
 
-#define nfp_app_is_locked(app)	lockdep_is_held(&(app)->pf->lock)
+static inline bool nfp_app_is_locked(struct nfp_app *app)
+{
+	return devl_lock_is_held(priv_to_devlink(app->pf));
+}
 
 void nfp_check_rhashtable_empty(void *ptr, void *arg);
 bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index bea978df7713..865f62958a72 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -70,7 +70,7 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 	unsigned int lanes;
 	int ret;
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 
 	rtnl_lock();
 	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
@@ -90,7 +90,7 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 
 	ret = nfp_devlink_set_lanes(pf, eth_port.index, lanes);
 out:
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
@@ -104,7 +104,7 @@ nfp_devlink_port_unsplit(struct devlink *devlink, unsigned int port_index,
 	unsigned int lanes;
 	int ret;
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 
 	rtnl_lock();
 	ret = nfp_devlink_fill_eth_port_from_id(pf, port_index, &eth_port);
@@ -124,7 +124,7 @@ nfp_devlink_port_unsplit(struct devlink *devlink, unsigned int port_index,
 
 	ret = nfp_devlink_set_lanes(pf, eth_port.index, lanes);
 out:
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
@@ -163,9 +163,9 @@ static int nfp_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	struct nfp_pf *pf = devlink_priv(devlink);
 	int ret;
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	ret = nfp_app_eswitch_mode_set(pf->app, mode);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	return ret;
 }
@@ -375,12 +375,12 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 
 	devlink = priv_to_devlink(app->pf);
 
-	return devlink_port_register(devlink, &port->dl_port, port->eth_id);
+	return devl_port_register(devlink, &port->dl_port, port->eth_id);
 }
 
 void nfp_devlink_port_unregister(struct nfp_port *port)
 {
-	devlink_port_unregister(&port->dl_port);
+	devl_port_unregister(&port->dl_port);
 }
 
 void nfp_devlink_port_type_eth_set(struct nfp_port *port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 8693f9905fbe..eeda39e34f84 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -227,6 +227,7 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 #ifdef CONFIG_PCI_IOV
 	struct nfp_pf *pf = pci_get_drvdata(pdev);
+	struct devlink *devlink;
 	int err;
 
 	if (num_vfs > pf->limit_vfs) {
@@ -241,7 +242,8 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return err;
 	}
 
-	mutex_lock(&pf->lock);
+	devlink = priv_to_devlink(pf);
+	devl_lock(devlink);
 
 	err = nfp_app_sriov_enable(pf->app, num_vfs);
 	if (err) {
@@ -255,11 +257,11 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 
 	dev_dbg(&pdev->dev, "Created %d VFs.\n", pf->num_vfs);
 
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 	return num_vfs;
 
 err_sriov_disable:
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 	pci_disable_sriov(pdev);
 	return err;
 #endif
@@ -270,8 +272,10 @@ static int nfp_pcie_sriov_disable(struct pci_dev *pdev)
 {
 #ifdef CONFIG_PCI_IOV
 	struct nfp_pf *pf = pci_get_drvdata(pdev);
+	struct devlink *devlink;
 
-	mutex_lock(&pf->lock);
+	devlink = priv_to_devlink(pf);
+	devl_lock(devlink);
 
 	/* If the VFs are assigned we cannot shut down SR-IOV without
 	 * causing issues, so just leave the hardware available but
@@ -279,7 +283,7 @@ static int nfp_pcie_sriov_disable(struct pci_dev *pdev)
 	 */
 	if (pci_vfs_assigned(pdev)) {
 		dev_warn(&pdev->dev, "Disabling while VFs assigned - VFs will not be deallocated\n");
-		mutex_unlock(&pf->lock);
+		devl_unlock(devlink);
 		return -EPERM;
 	}
 
@@ -287,7 +291,7 @@ static int nfp_pcie_sriov_disable(struct pci_dev *pdev)
 
 	pf->num_vfs = 0;
 
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	pci_disable_sriov(pdev);
 	dev_dbg(&pdev->dev, "Removed VFs.\n");
@@ -707,7 +711,6 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	pf = devlink_priv(devlink);
 	INIT_LIST_HEAD(&pf->vnics);
 	INIT_LIST_HEAD(&pf->ports);
-	mutex_init(&pf->lock);
 	pci_set_drvdata(pdev, pf);
 	pf->pdev = pdev;
 	pf->dev_info = dev_info;
@@ -798,7 +801,6 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	destroy_workqueue(pf->wq);
 err_pci_priv_unset:
 	pci_set_drvdata(pdev, NULL);
-	mutex_destroy(&pf->lock);
 	devlink_free(devlink);
 err_rel_regions:
 	pci_release_regions(pdev);
@@ -835,7 +837,6 @@ static void __nfp_pci_shutdown(struct pci_dev *pdev, bool unload_fw)
 
 	kfree(pf->eth_tbl);
 	kfree(pf->nspi);
-	mutex_destroy(&pf->lock);
 	devlink_free(priv_to_devlink(pf));
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 9c72a0ad18ea..f56ca11de134 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -13,7 +13,6 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/msi.h>
-#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 #include <net/devlink.h>
@@ -85,7 +84,8 @@ struct nfp_dumpspec {
  * @port_refresh_work:	Work entry for taking netdevs out
  * @shared_bufs:	Array of shared buffer structures if FW has any SBs
  * @num_shared_bufs:	Number of elements in @shared_bufs
- * @lock:		Protects all fields which may change after probe
+ *
+ * Fields which may change after proble are protected by devlink instance lock.
  */
 struct nfp_pf {
 	struct pci_dev *pdev;
@@ -141,8 +141,6 @@ struct nfp_pf {
 
 	struct nfp_shared_buf *shared_bufs;
 	unsigned int num_shared_bufs;
-
-	struct mutex lock;
 };
 
 extern struct pci_driver nfp_netvf_pci_driver;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index a18b99c93ab3..09a0a2076c6e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -308,6 +308,7 @@ static int nfp_net_pf_init_vnics(struct nfp_pf *pf)
 static int
 nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
 	u8 __iomem *ctrl_bar;
 	int err;
 
@@ -315,9 +316,9 @@ nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 	if (IS_ERR(pf->app))
 		return PTR_ERR(pf->app);
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	err = nfp_app_init(pf->app);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 	if (err)
 		goto err_free;
 
@@ -344,9 +345,9 @@ nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 err_unmap:
 	nfp_cpp_area_release_free(pf->ctrl_vnic_bar);
 err_app_clean:
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	nfp_app_clean(pf->app);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 err_free:
 	nfp_app_free(pf->app);
 	pf->app = NULL;
@@ -355,14 +356,16 @@ nfp_net_pf_app_init(struct nfp_pf *pf, u8 __iomem *qc_bar, unsigned int stride)
 
 static void nfp_net_pf_app_clean(struct nfp_pf *pf)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
+
 	if (pf->ctrl_vnic) {
 		nfp_net_pf_free_vnic(pf, pf->ctrl_vnic);
 		nfp_cpp_area_release_free(pf->ctrl_vnic_bar);
 	}
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	nfp_app_clean(pf->app);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	nfp_app_free(pf->app);
 	pf->app = NULL;
@@ -548,12 +551,13 @@ nfp_net_eth_port_update(struct nfp_cpp *cpp, struct nfp_port *port,
 
 int nfp_net_refresh_port_table_sync(struct nfp_pf *pf)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
 	struct nfp_eth_table *eth_table;
 	struct nfp_net *nn, *next;
 	struct nfp_port *port;
 	int err;
 
-	lockdep_assert_held(&pf->lock);
+	devl_assert_locked(devlink);
 
 	/* Check for nfp_net_pci_remove() racing against us */
 	if (list_empty(&pf->vnics))
@@ -602,10 +606,11 @@ static void nfp_net_refresh_vnics(struct work_struct *work)
 {
 	struct nfp_pf *pf = container_of(work, struct nfp_pf,
 					 port_refresh_work);
+	struct devlink *devlink = priv_to_devlink(pf);
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	nfp_net_refresh_port_table_sync(pf);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 }
 
 void nfp_net_refresh_port_table(struct nfp_port *port)
@@ -711,7 +716,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_shared_buf_unreg;
 
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	pf->ddir = nfp_net_debugfs_device_add(pf->pdev);
 
 	/* Allocate the vnics and do basic init */
@@ -731,7 +736,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_stop_app;
 
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 	devlink_register(devlink);
 
 	return 0;
@@ -744,7 +749,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_net_pf_free_vnics(pf);
 err_clean_ddir:
 	nfp_net_debugfs_dir_clean(&pf->ddir);
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 	nfp_devlink_params_unregister(pf);
 err_shared_buf_unreg:
 	nfp_shared_buf_unregister(pf);
@@ -758,10 +763,11 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 
 void nfp_net_pci_remove(struct nfp_pf *pf)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
 	struct nfp_net *nn, *next;
 
 	devlink_unregister(priv_to_devlink(pf));
-	mutex_lock(&pf->lock);
+	devl_lock(devlink);
 	list_for_each_entry_safe(nn, next, &pf->vnics, vnic_list) {
 		if (!nfp_net_is_data_vnic(nn))
 			continue;
@@ -773,7 +779,7 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
 
-	mutex_unlock(&pf->lock);
+	devl_unlock(devlink);
 
 	nfp_devlink_params_unregister(pf);
 	nfp_shared_buf_unregister(pf);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 93c5bfc0510b..236cd3c1201f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -78,9 +78,10 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 struct nfp_port *
 nfp_port_from_id(struct nfp_pf *pf, enum nfp_port_type type, unsigned int id)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
 	struct nfp_port *port;
 
-	lockdep_assert_held(&pf->lock);
+	devl_assert_locked(devlink);
 
 	if (type != NFP_PORT_PHYS_PORT)
 		return NULL;
-- 
2.34.1

