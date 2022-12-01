Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3C63F595
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLAQq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLAQqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:19 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875BFB0DD8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so3094181edc.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1CqhJ+IEn0Y3eZimXaaShqn5A+Zf1N2q0dtDg8Htr8=;
        b=2LWOkhGBS/ZQgkt5NoPEVB/j37B21qAVZOkG+/15CxXKc9bBlCeuLFbLt7N//2zhlC
         m07AjATRox0ezeqUWDRM0S1lyzBJ7Qkpr8hhJZjKJhE0BoqOoSn2bHJ5ar0j8Ql5xBwA
         JFveuGs52Q1zAQpuQYL971PESSEmc4I0Stx0Hbvo4QkW7uFXdljoNaoH+cSNvOOUkgYD
         2njx0mgRp2XfEDSGpJT5zdr16c0u/vtBWuu9vIBZz3RJegRUAQc38mrvIQG+nKPD94FM
         tGq7NrGVJ8F7jaxfUe/Qn21tk/JJ4swgq5ruCoAK+vWlN26d2bk9nVfnkV2WYpkR5nVg
         NCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1CqhJ+IEn0Y3eZimXaaShqn5A+Zf1N2q0dtDg8Htr8=;
        b=PDfMzZ29xG1azirnkNg2JssqhBpKBq4qa40DQqJ96gl1Ran1YBfZUBr+ApLARLZGPp
         QkG2C5Z3c7mtaltQDDtvmbA3yDqEBvQ7zothxZoHS1g/2zgrmAhoC2Y0AMgBvoG46O1t
         gcyLyYBMUdR1okCwOReVk7xxsQPfR6/v5yYB6U6WB/Bzc6KwuQ0tOE2hwEJmnDLq44LJ
         wv1HCKbawqdNLe5yfZV5kiAzGgdKgtyTky5P/bJXTjNIr6urfeOZWPZTap5WG/SXvN/4
         DiVi1tvf+XZQ9HsamSCFY8O2qtqMI6rAnP0O+J1XfV77N8qPQxh3L3LKLFQBrf7VU3g7
         xrWg==
X-Gm-Message-State: ANoB5plwwLSAeua8yk3zD7FbjLmVuZdBNulbo4UENjn6q+WPQES9L0xK
        JAfOTXwuQX5r4h+RkQ2sRVpg0aLvbr/ts27P
X-Google-Smtp-Source: AA0mqf5MnkBWRSYmYRrMJEHXJwfVmPOf05ZS0ce6fdQta+L17avgxNBod0udao+F2+yCCfbGVI0yiw==
X-Received: by 2002:a05:6402:2409:b0:45c:935b:ae15 with SMTP id t9-20020a056402240900b0045c935bae15mr38187974eda.357.1669913171998;
        Thu, 01 Dec 2022 08:46:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id kx16-20020a170907775000b007c0934db0e0sm1966624ejc.141.2022.12.01.08.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 1/7] devlink: Reorder devlink_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:02 +0100
Message-Id: <20221201164608.209537-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Change the drivers that use devlink_port_register/unregister() to call
these functions only in case devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 ++++++++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++--
 .../ethernet/fungible/funeth/funeth_main.c    | 17 +++++++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++++++------
 .../ethernet/marvell/prestera/prestera_main.c |  6 ++--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 +++----
 .../ethernet/pensando/ionic/ionic_devlink.c   |  6 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +++--
 8 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 26913dc816d3..c2600ce7313c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -1285,8 +1285,15 @@ int bnxt_dl_register(struct bnxt *bp)
 	    bp->hwrm_spec_code > 0x10803)
 		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
+	if (BNXT_PF(bp)) {
+		rc = bnxt_dl_params_register(bp);
+		if (rc)
+			goto err_dl_free;
+	}
+
+	devlink_register(dl);
 	if (!BNXT_PF(bp))
-		goto out;
+		return 0;
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = bp->pf.port_id;
@@ -1296,20 +1303,16 @@ int bnxt_dl_register(struct bnxt *bp)
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed\n");
-		goto err_dl_free;
+		goto err_dl_unreg;
 	}
 
-	rc = bnxt_dl_params_register(bp);
-	if (rc)
-		goto err_dl_port_unreg;
-
 	devlink_set_features(dl, DEVLINK_F_RELOAD);
-out:
-	devlink_register(dl);
 	return 0;
 
-err_dl_port_unreg:
-	devlink_port_unregister(&bp->dl_port);
+err_dl_unreg:
+	devlink_unregister(dl);
+	if (BNXT_PF(bp))
+		bnxt_dl_params_unregister(bp);
 err_dl_free:
 	devlink_free(dl);
 	return rc;
@@ -1319,10 +1322,10 @@ void bnxt_dl_unregister(struct bnxt *bp)
 {
 	struct devlink *dl = bp->dl;
 
+	if (BNXT_PF(bp))
+		devlink_port_unregister(&bp->dl_port);
 	devlink_unregister(dl);
-	if (BNXT_PF(bp)) {
+	if (BNXT_PF(bp))
 		bnxt_dl_params_unregister(bp);
-		devlink_port_unregister(&bp->dl_port);
-	}
 	devlink_free(dl);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0c35abb7d065..4e468c4c20e0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4954,6 +4954,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_dl_trap_register;
 
+	dpaa2_eth_dl_register(priv);
+
 	err = dpaa2_eth_dl_port_add(priv);
 	if (err)
 		goto err_dl_port_add;
@@ -4968,12 +4970,12 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	dpaa2_dbg_add(priv);
 #endif
 
-	dpaa2_eth_dl_register(priv);
 	dev_info(dev, "Probed interface %s\n", net_dev->name);
 	return 0;
 
 err_netdev_reg:
 	dpaa2_eth_dl_port_del(priv);
+	dpaa2_eth_dl_unregister(priv);
 err_dl_port_add:
 	dpaa2_eth_dl_traps_unregister(priv);
 err_dl_trap_register:
@@ -5026,8 +5028,6 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	net_dev = dev_get_drvdata(dev);
 	priv = netdev_priv(net_dev);
 
-	dpaa2_eth_dl_unregister(priv);
-
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
@@ -5035,6 +5035,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	unregister_netdev(net_dev);
 
 	dpaa2_eth_dl_port_del(priv);
+	dpaa2_eth_dl_unregister(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
 	dpaa2_eth_dl_free(priv);
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index b4cce30e526a..e335071bf530 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -2018,17 +2018,22 @@ static int funeth_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto free_devlink;
 
+	fun_devlink_register(devlink);
+
 	rc = fun_get_res_count(fdev, FUN_ADMIN_OP_PORT);
-	if (rc > 0)
-		rc = fun_create_ports(ed, rc);
 	if (rc < 0)
-		goto disable_dev;
+		goto unregister_devlink;
+	if (rc > 0) {
+		rc = fun_create_ports(ed, rc);
+		if (rc < 0)
+			goto unregister_devlink;
+	}
 
 	fun_serv_restart(fdev);
-	fun_devlink_register(devlink);
 	return 0;
 
-disable_dev:
+unregister_devlink:
+	fun_devlink_unregister(devlink);
 	fun_dev_disable(fdev);
 free_devlink:
 	mutex_destroy(&ed->state_mutex);
@@ -2044,7 +2049,6 @@ static void funeth_remove(struct pci_dev *pdev)
 
 	ed = to_fun_ethdev(fdev);
 	devlink = priv_to_devlink(ed);
-	fun_devlink_unregister(devlink);
 
 #ifdef CONFIG_PCI_IOV
 	funeth_sriov_configure(pdev, 0);
@@ -2052,6 +2056,7 @@ static void funeth_remove(struct pci_dev *pdev)
 
 	fun_serv_stop(fdev);
 	fun_destroy_ports(ed);
+	fun_devlink_unregister(devlink);
 	fun_dev_disable(fdev);
 	mutex_destroy(&ed->state_mutex);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2b23b4714a26..f47d5b87f99b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4919,11 +4919,13 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	pcie_print_link_status(pf->pdev);
 
 probe_done:
-	err = ice_register_netdev(pf);
+	err = ice_devlink_register_params(pf);
 	if (err)
-		goto err_netdev_reg;
+		goto err_devlink_reg_param;
 
-	err = ice_devlink_register_params(pf);
+	ice_devlink_register(pf);
+
+	err = ice_register_netdev(pf);
 	if (err)
 		goto err_netdev_reg;
 
@@ -4934,7 +4936,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		if (pf->aux_idx < 0) {
 			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
 			err = -ENOMEM;
-			goto err_devlink_reg_param;
+			goto err_ida_alloc;
 		}
 
 		err = ice_init_rdma(pf);
@@ -4947,15 +4949,16 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		dev_warn(dev, "RDMA is not supported on this device\n");
 	}
 
-	ice_devlink_register(pf);
 	return 0;
 
 err_init_aux_unroll:
 	pf->adev = NULL;
 	ida_free(&ice_aux_ida, pf->aux_idx);
-err_devlink_reg_param:
-	ice_devlink_unregister_params(pf);
+err_ida_alloc:
 err_netdev_reg:
+	ice_devlink_unregister(pf);
+	ice_devlink_unregister_params(pf);
+err_devlink_reg_param:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
@@ -5051,7 +5054,6 @@ static void ice_remove(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	ice_devlink_unregister(pf);
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;
@@ -5071,7 +5073,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_unplug_aux_dev(pf);
 	if (pf->aux_idx >= 0)
 		ida_free(&ice_aux_ida, pf->aux_idx);
-	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
 	ice_deinit_lag(pf);
@@ -5083,6 +5084,8 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
+	ice_devlink_unregister(pf);
+	ice_devlink_unregister_params(pf);
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_set_wake(pf);
 	ice_free_irq_msix_misc(pf);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 9d504142e51a..815056a130d9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -1421,14 +1421,16 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_lag_init;
 
+	prestera_devlink_register(sw);
+
 	err = prestera_create_ports(sw);
 	if (err)
 		goto err_ports_create;
 
-	prestera_devlink_register(sw);
 	return 0;
 
 err_ports_create:
+	prestera_devlink_unregister(sw);
 	prestera_lag_fini(sw);
 err_lag_init:
 	prestera_devlink_traps_unregister(sw);
@@ -1455,8 +1457,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
 
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
-	prestera_devlink_unregister(sw);
 	prestera_destroy_ports(sw);
+	prestera_devlink_unregister(sw);
 	prestera_lag_fini(sw);
 	prestera_devlink_traps_unregister(sw);
 	prestera_span_fini(sw);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index b097fd4a4061..69adde1da2a0 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -562,10 +562,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	err = mscc_ocelot_init_ports(pdev, ports);
-	if (err)
-		goto out_ocelot_devlink_unregister;
-
 	if (ocelot->fdma)
 		ocelot_fdma_start(ocelot);
 
@@ -589,6 +585,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	of_node_put(ports);
 	devlink_register(devlink);
 
+	err = mscc_ocelot_init_ports(pdev, ports);
+	if (err)
+		goto out_ocelot_devlink_unregister;
+
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
 	return 0;
@@ -611,10 +611,10 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 
 	if (ocelot->fdma)
 		ocelot_fdma_deinit(ocelot);
+	mscc_ocelot_release_ports(ocelot);
 	devlink_unregister(ocelot->devlink);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_devlink_sb_unregister(ocelot);
-	mscc_ocelot_release_ports(ocelot);
 	mscc_ocelot_teardown_devlink_ports(ocelot);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index e6ff757895ab..06670343f90b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -78,16 +78,18 @@ int ionic_devlink_register(struct ionic *ionic)
 	struct devlink_port_attrs attrs = {};
 	int err;
 
+	devlink_register(dl);
+
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err) {
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
+		devlink_unregister(dl);
 		return err;
 	}
 
 	SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
-	devlink_register(dl);
 	return 0;
 }
 
@@ -95,6 +97,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	devlink_unregister(dl);
 	devlink_port_unregister(&ionic->dl_port);
+	devlink_unregister(dl);
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 51c37e99d086..4ac4b7ada890 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2522,6 +2522,8 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 		}
 	}
 
+	devlink_register(common->devlink);
+
 	for (i = 1; i <= common->port_num; i++) {
 		port = am65_common_get_port(common, i);
 		dl_port = &port->devlink_port;
@@ -2542,7 +2544,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 			goto dl_port_unreg;
 		}
 	}
-	devlink_register(common->devlink);
 	return ret;
 
 dl_port_unreg:
@@ -2552,6 +2553,7 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 
 		devlink_port_unregister(dl_port);
 	}
+	devlink_unregister(common->devlink);
 dl_unreg:
 	devlink_free(common->devlink);
 	return ret;
@@ -2563,14 +2565,13 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 	struct am65_cpsw_port *port;
 	int i;
 
-	devlink_unregister(common->devlink);
-
 	for (i = 1; i <= common->port_num; i++) {
 		port = am65_common_get_port(common, i);
 		dl_port = &port->devlink_port;
 
 		devlink_port_unregister(dl_port);
 	}
+	devlink_unregister(common->devlink);
 
 	if (!AM65_CPSW_IS_CPSW2G(common) &&
 	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV))
-- 
2.37.3

