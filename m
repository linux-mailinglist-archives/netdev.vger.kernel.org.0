Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C2F6460B4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiLGRxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLGRxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:53:21 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1583B2FFDB
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:53:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so2407926pjd.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 09:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8cTriZC7dG7Cv3sWQbJQ6cOQZPbm8lQrqAhbST45CPg=;
        b=Liqy9UXm+nIqZv514OzCO+3frH46vWpYEvfUHBxqj+cNmV5vUkjvqdRB5u3QUfi4TJ
         ME0R4Hje/OZIjBHOkn6VdOV5FIqpCJrW0gDdfoATVaXO8JR7xbV3wrpPBYSgZ9qNlXdd
         7zDnUD/CFWwawIAMMjXM8X+4QX4K72Ui3W1tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cTriZC7dG7Cv3sWQbJQ6cOQZPbm8lQrqAhbST45CPg=;
        b=YM5pdKyrvx1xbaF2twWtKNwHEcCMdqcdR2rfsQTNyp2AKDN+WFmAS1bXuJrd66VCJ3
         KiCqIygK7dzq2dHOiPTrY7x7RMiZyVVBPu5w6O9TnedzXVVwGCOe7dk9CsJF8ZXwZmrL
         Zurw8EXurbrJhVco/Z/alA8+trQRz/J9tkuOPy9OiBDMAPKxwbZ/5hdQgwBa/dF/5L6Z
         iCAF2+oKQ8lT/oW1XTrOOCLyCb90zt9dRbKj+5N2iy0w5bjCnhuNOthbiWq6oiUfqA1H
         abGdsRRdXLTTyN5V9tXezKgcasJz1NyiCSw4i3ZbP4fNdEE/kSrbaru3yt7p842YrdLM
         jtoA==
X-Gm-Message-State: ANoB5pk7MPVZ6lQQk1Z4LZIZ+IC/IbRRIX7LwEk8A2pW0KiQXKxfOhJC
        oiNhdDAPEmUhVVmgYNtR2fDKgQ==
X-Google-Smtp-Source: AA0mqf78eZmZYQJ5sniu/rToNh0m0O+Ykf96ZwuM1sm0kEt9Re30onH1fiQg6bjKcJS3vbVR/wVNWw==
X-Received: by 2002:a17:903:555:b0:189:959a:84cc with SMTP id jo21-20020a170903055500b00189959a84ccmr43918708plb.41.1670435599376;
        Wed, 07 Dec 2022 09:53:19 -0800 (PST)
Received: from C02GC2QQMD6T.wifi.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l6-20020a622506000000b005748aca80fesm13862242pfl.32.2022.12.07.09.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:53:18 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: [PATCH v5 2/7] RDMA/bnxt_re: Use auxiliary driver interface
Date:   Wed,  7 Dec 2022 09:53:05 -0800
Message-Id: <20221207175310.23656-3-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20221207175310.23656-1-ajit.khaparde@broadcom.com>
References: <20221207175310.23656-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008c89d105ef409825"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008c89d105ef409825
Content-Transfer-Encoding: 8bit

Use auxiliary driver interface for driver load, unload ROCE driver.
The driver does not need to register the interface using the netdev
notifier anymore. Removed the bnxt_re_dev_list which is not needed.
Currently probe, remove and shutdown ops have been implemented for
the auxiliary device.
Also remove exccessve validation checks for rdev.

Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
 drivers/infiniband/hw/bnxt_re/main.c          | 395 ++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  29 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 -
 4 files changed, 132 insertions(+), 304 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 785c37cae3c0..b0465c8d229a 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -89,13 +89,6 @@ struct bnxt_re_ring_attr {
 	u8		mode;
 };
 
-struct bnxt_re_work {
-	struct work_struct	work;
-	unsigned long		event;
-	struct bnxt_re_dev      *rdev;
-	struct net_device	*vlan_dev;
-};
-
 struct bnxt_re_sqp_entries {
 	struct bnxt_qplib_sge sge;
 	u64 wrid;
@@ -132,6 +125,7 @@ struct bnxt_re_dev {
 #define BNXT_RE_FLAG_ERR_DEVICE_DETACHED       17
 #define BNXT_RE_FLAG_ISSUE_ROCE_STATS          29
 	struct net_device		*netdev;
+	struct notifier_block		nb;
 	unsigned int			version, major, minor;
 	struct bnxt_qplib_chip_ctx	*chip_ctx;
 	struct bnxt_en_dev		*en_dev;
@@ -194,5 +188,4 @@ static inline struct device *rdev_to_dev(struct bnxt_re_dev *rdev)
 		return  &rdev->ibdev.dev;
 	return NULL;
 }
-
 #endif
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 8c0c80a8d338..165ae11b927d 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -48,6 +48,7 @@
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 #include <linux/if_ether.h>
+#include <linux/auxiliary_bus.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
@@ -74,14 +75,14 @@ MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* globals */
-static struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
-/* Mutex to protect the list of bnxt_re devices added */
-static DEFINE_MUTEX(bnxt_re_dev_lock);
-static struct workqueue_struct *bnxt_re_wq;
-static void bnxt_re_remove_device(struct bnxt_re_dev *rdev);
-static void bnxt_re_dealloc_driver(struct ib_device *ib_dev);
+static DEFINE_MUTEX(bnxt_re_mutex);
+
 static void bnxt_re_stop_irq(void *handle);
 static void bnxt_re_dev_stop(struct bnxt_re_dev *rdev);
+static int bnxt_re_netdev_event(struct notifier_block *notifier,
+				unsigned long event, void *ptr);
+static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev);
+static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev);
 
 static void bnxt_re_set_drv_mode(struct bnxt_re_dev *rdev, u8 mode)
 {
@@ -233,7 +234,6 @@ static void bnxt_re_stop(void *p)
 
 	if (!rdev)
 		return;
-	ASSERT_RTNL();
 
 	/* L2 driver invokes this callback during device error/crash or device
 	 * reset. Current RoCE driver doesn't recover the device in case of
@@ -269,9 +269,6 @@ static void bnxt_re_sriov_config(void *p, int num_vfs)
 {
 	struct bnxt_re_dev *rdev = p;
 
-	if (!rdev)
-		return;
-
 	if (test_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags))
 		return;
 	rdev->num_vfs = num_vfs;
@@ -282,16 +279,14 @@ static void bnxt_re_sriov_config(void *p, int num_vfs)
 	}
 }
 
-static void bnxt_re_shutdown(void *p)
+static void bnxt_re_shutdown(struct auxiliary_device *adev)
 {
-	struct bnxt_re_dev *rdev = p;
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
 
 	if (!rdev)
 		return;
-	ASSERT_RTNL();
-	/* Release the MSIx vectors before queuing unregister */
-	bnxt_re_stop_irq(rdev);
-	ib_unregister_device_queued(&rdev->ibdev);
+	ib_unregister_device(&rdev->ibdev);
+	bnxt_re_dev_uninit(rdev);
 }
 
 static void bnxt_re_stop_irq(void *handle)
@@ -346,11 +341,9 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 }
 
 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
-	.ulp_async_notifier = NULL,
 	.ulp_stop = bnxt_re_stop,
 	.ulp_start = bnxt_re_start,
 	.ulp_sriov_config = bnxt_re_sriov_config,
-	.ulp_shutdown = bnxt_re_shutdown,
 	.ulp_irq_stop = bnxt_re_stop_irq,
 	.ulp_irq_restart = bnxt_re_start_irq
 };
@@ -380,9 +373,6 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 	struct bnxt_en_dev *en_dev;
 	int rc = 0;
 
-	if (!rdev)
-		return -EINVAL;
-
 	en_dev = rdev->en_dev;
 
 	rc = en_dev->en_ops->bnxt_register_device(en_dev, BNXT_ROCE_ULP,
@@ -401,7 +391,6 @@ static int bnxt_re_free_msix(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-
 	rc = en_dev->en_ops->bnxt_free_msix(rdev->en_dev, BNXT_ROCE_ULP);
 
 	return rc;
@@ -412,9 +401,6 @@ static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 	int rc = 0, num_msix_want = BNXT_RE_MAX_MSIX, num_msix_got;
 	struct bnxt_en_dev *en_dev;
 
-	if (!rdev)
-		return -EINVAL;
-
 	en_dev = rdev->en_dev;
 
 	num_msix_want = min_t(u32, BNXT_RE_MAX_MSIX, num_online_cpus());
@@ -458,12 +444,17 @@ static void bnxt_re_fill_fw_msg(struct bnxt_fw_msg *fw_msg, void *msg,
 static int bnxt_re_net_ring_free(struct bnxt_re_dev *rdev,
 				 u16 fw_ring_id, int type)
 {
-	struct bnxt_en_dev *en_dev = rdev->en_dev;
+	struct bnxt_en_dev *en_dev;
 	struct hwrm_ring_free_input req = {0};
 	struct hwrm_ring_free_output resp;
 	struct bnxt_fw_msg fw_msg;
 	int rc = -EINVAL;
 
+	if (!rdev)
+		return rc;
+
+	en_dev = rdev->en_dev;
+
 	if (!en_dev)
 		return rc;
 
@@ -584,21 +575,6 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 
 /* Device */
 
-static bool is_bnxt_re_dev(struct net_device *netdev)
-{
-	struct ethtool_drvinfo drvinfo;
-
-	if (netdev->ethtool_ops && netdev->ethtool_ops->get_drvinfo) {
-		memset(&drvinfo, 0, sizeof(drvinfo));
-		netdev->ethtool_ops->get_drvinfo(netdev, &drvinfo);
-
-		if (strcmp(drvinfo.driver, "bnxt_en"))
-			return false;
-		return true;
-	}
-	return false;
-}
-
 static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev)
 {
 	struct ib_device *ibdev =
@@ -609,31 +585,6 @@ static struct bnxt_re_dev *bnxt_re_from_netdev(struct net_device *netdev)
 	return container_of(ibdev, struct bnxt_re_dev, ibdev);
 }
 
-static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
-{
-	struct bnxt_en_dev *en_dev;
-	struct pci_dev *pdev;
-
-	en_dev = bnxt_ulp_probe(netdev);
-	if (IS_ERR(en_dev))
-		return en_dev;
-
-	pdev = en_dev->pdev;
-	if (!pdev)
-		return ERR_PTR(-EINVAL);
-
-	if (!(en_dev->flags & BNXT_EN_FLAG_ROCE_CAP)) {
-		dev_info(&pdev->dev,
-			"%s: probe error: RoCE is not supported on this device",
-			ROCE_DRV_MODULE_NAME);
-		return ERR_PTR(-ENODEV);
-	}
-
-	dev_hold(netdev);
-
-	return en_dev;
-}
-
 static ssize_t hw_rev_show(struct device *device, struct device_attribute *attr,
 			   char *buf)
 {
@@ -679,7 +630,6 @@ static const struct ib_device_ops bnxt_re_dev_ops = {
 	.create_qp = bnxt_re_create_qp,
 	.create_srq = bnxt_re_create_srq,
 	.create_user_ah = bnxt_re_create_ah,
-	.dealloc_driver = bnxt_re_dealloc_driver,
 	.dealloc_pd = bnxt_re_dealloc_pd,
 	.dealloc_ucontext = bnxt_re_dealloc_ucontext,
 	.del_gid = bnxt_re_del_gid,
@@ -744,18 +694,7 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	return ib_register_device(ibdev, "bnxt_re%d", &rdev->en_dev->pdev->dev);
 }
 
-static void bnxt_re_dev_remove(struct bnxt_re_dev *rdev)
-{
-	dev_put(rdev->netdev);
-	rdev->netdev = NULL;
-	mutex_lock(&bnxt_re_dev_lock);
-	list_del_rcu(&rdev->list);
-	mutex_unlock(&bnxt_re_dev_lock);
-
-	synchronize_rcu();
-}
-
-static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
+static struct bnxt_re_dev *bnxt_re_dev_add(struct bnxt_aux_dev *aux_dev,
 					   struct bnxt_en_dev *en_dev)
 {
 	struct bnxt_re_dev *rdev;
@@ -768,8 +707,8 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 		return NULL;
 	}
 	/* Default values */
-	rdev->netdev = netdev;
-	dev_hold(rdev->netdev);
+	rdev->nb.notifier_call = NULL;
+	rdev->netdev = en_dev->net;
 	rdev->en_dev = en_dev;
 	rdev->id = rdev->en_dev->pdev->devfn;
 	INIT_LIST_HEAD(&rdev->qp_list);
@@ -784,9 +723,6 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 	rdev->cosq[0] = 0xFFFF;
 	rdev->cosq[1] = 0xFFFF;
 
-	mutex_lock(&bnxt_re_dev_lock);
-	list_add_tail_rcu(&rdev->list, &bnxt_re_dev_list);
-	mutex_unlock(&bnxt_re_dev_lock);
 	return rdev;
 }
 
@@ -1323,7 +1259,7 @@ static int bnxt_re_ib_init(struct bnxt_re_dev *rdev)
 		pr_err("Failed to register with IB: %#x\n", rc);
 		return rc;
 	}
-	dev_info(rdev_to_dev(rdev), "Device registered successfully");
+	dev_info(rdev_to_dev(rdev), "Device registered with IB successfully");
 	ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
 			 &rdev->active_width);
 	set_bit(BNXT_RE_FLAG_ISSUE_ROCE_STATS, &rdev->flags);
@@ -1541,135 +1477,43 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	return rc;
 }
 
-static void bnxt_re_dev_unreg(struct bnxt_re_dev *rdev)
-{
-	struct net_device *netdev = rdev->netdev;
-
-	bnxt_re_dev_remove(rdev);
-
-	if (netdev)
-		dev_put(netdev);
-}
-
-static int bnxt_re_dev_reg(struct bnxt_re_dev **rdev, struct net_device *netdev)
+static int bnxt_re_add_device(struct auxiliary_device *adev, u8 wqe_mode)
 {
+	struct bnxt_aux_dev *aux_dev =
+		container_of(adev, struct bnxt_aux_dev, aux_dev);
 	struct bnxt_en_dev *en_dev;
+	struct bnxt_re_dev *rdev;
 	int rc = 0;
 
-	if (!is_bnxt_re_dev(netdev))
-		return -ENODEV;
+	/* en_dev should never be NULL as long as adev and aux_dev are valid. */
+	en_dev = aux_dev->edev;
 
-	en_dev = bnxt_re_dev_probe(netdev);
-	if (IS_ERR(en_dev)) {
-		if (en_dev != ERR_PTR(-ENODEV))
-			ibdev_err(&(*rdev)->ibdev, "%s: Failed to probe\n",
-				  ROCE_DRV_MODULE_NAME);
-		rc = PTR_ERR(en_dev);
-		goto exit;
-	}
-	*rdev = bnxt_re_dev_add(netdev, en_dev);
-	if (!*rdev) {
+	rdev = bnxt_re_dev_add(aux_dev, en_dev);
+	if (!rdev || !rdev_to_dev(rdev)) {
 		rc = -ENOMEM;
-		dev_put(netdev);
 		goto exit;
 	}
-exit:
-	return rc;
-}
-
-static void bnxt_re_remove_device(struct bnxt_re_dev *rdev)
-{
-	bnxt_re_dev_uninit(rdev);
-	pci_dev_put(rdev->en_dev->pdev);
-	bnxt_re_dev_unreg(rdev);
-}
-
-static int bnxt_re_add_device(struct bnxt_re_dev **rdev,
-			      struct net_device *netdev, u8 wqe_mode)
-{
-	int rc;
 
-	rc = bnxt_re_dev_reg(rdev, netdev);
-	if (rc == -ENODEV)
-		return rc;
-	if (rc) {
-		pr_err("Failed to register with the device %s: %#x\n",
-		       netdev->name, rc);
-		return rc;
-	}
+	rc = bnxt_re_dev_init(rdev, wqe_mode);
+	if (rc)
+		goto re_dev_dealloc;
 
-	pci_dev_get((*rdev)->en_dev->pdev);
-	rc = bnxt_re_dev_init(*rdev, wqe_mode);
+	rc = bnxt_re_ib_init(rdev);
 	if (rc) {
-		pci_dev_put((*rdev)->en_dev->pdev);
-		bnxt_re_dev_unreg(*rdev);
+		pr_err("Failed to register with IB: %s",
+			aux_dev->aux_dev.name);
+		goto re_dev_uninit;
 	}
+	auxiliary_set_drvdata(adev, rdev);
 
-	return rc;
-}
-
-static void bnxt_re_dealloc_driver(struct ib_device *ib_dev)
-{
-	struct bnxt_re_dev *rdev =
-		container_of(ib_dev, struct bnxt_re_dev, ibdev);
-
-	dev_info(rdev_to_dev(rdev), "Unregistering Device");
-
-	rtnl_lock();
-	bnxt_re_remove_device(rdev);
-	rtnl_unlock();
-}
-
-/* Handle all deferred netevents tasks */
-static void bnxt_re_task(struct work_struct *work)
-{
-	struct bnxt_re_work *re_work;
-	struct bnxt_re_dev *rdev;
-	int rc = 0;
-
-	re_work = container_of(work, struct bnxt_re_work, work);
-	rdev = re_work->rdev;
-
-	if (re_work->event == NETDEV_REGISTER) {
-		rc = bnxt_re_ib_init(rdev);
-		if (rc) {
-			ibdev_err(&rdev->ibdev,
-				  "Failed to register with IB: %#x", rc);
-			rtnl_lock();
-			bnxt_re_remove_device(rdev);
-			rtnl_unlock();
-			goto exit;
-		}
-		goto exit;
-	}
-
-	if (!ib_device_try_get(&rdev->ibdev))
-		goto exit;
+	return 0;
 
-	switch (re_work->event) {
-	case NETDEV_UP:
-		bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
-				       IB_EVENT_PORT_ACTIVE);
-		break;
-	case NETDEV_DOWN:
-		bnxt_re_dev_stop(rdev);
-		break;
-	case NETDEV_CHANGE:
-		if (!netif_carrier_ok(rdev->netdev))
-			bnxt_re_dev_stop(rdev);
-		else if (netif_carrier_ok(rdev->netdev))
-			bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
-					       IB_EVENT_PORT_ACTIVE);
-		ib_get_eth_speed(&rdev->ibdev, 1, &rdev->active_speed,
-				 &rdev->active_width);
-		break;
-	default:
-		break;
-	}
-	ib_device_put(&rdev->ibdev);
+re_dev_uninit:
+	bnxt_re_dev_uninit(rdev);
+re_dev_dealloc:
+	ib_dealloc_device(&rdev->ibdev);
 exit:
-	put_device(&rdev->ibdev.dev);
-	kfree(re_work);
+	return rc;
 }
 
 /*
@@ -1690,109 +1534,130 @@ static int bnxt_re_netdev_event(struct notifier_block *notifier,
 				unsigned long event, void *ptr)
 {
 	struct net_device *real_dev, *netdev = netdev_notifier_info_to_dev(ptr);
-	struct bnxt_re_work *re_work;
 	struct bnxt_re_dev *rdev;
-	int rc = 0;
-	bool sch_work = false;
-	bool release = true;
 
 	real_dev = rdma_vlan_dev_real_dev(netdev);
 	if (!real_dev)
 		real_dev = netdev;
 
-	rdev = bnxt_re_from_netdev(real_dev);
-	if (!rdev && event != NETDEV_REGISTER)
-		return NOTIFY_OK;
-
 	if (real_dev != netdev)
 		goto exit;
 
-	switch (event) {
-	case NETDEV_REGISTER:
-		if (rdev)
-			break;
-		rc = bnxt_re_add_device(&rdev, real_dev,
-					BNXT_QPLIB_WQE_MODE_STATIC);
-		if (!rc)
-			sch_work = true;
-		release = false;
-		break;
+	rdev = bnxt_re_from_netdev(real_dev);
+	if (!rdev)
+		return NOTIFY_DONE;
 
-	case NETDEV_UNREGISTER:
-		ib_unregister_device_queued(&rdev->ibdev);
-		break;
 
+	switch (event) {
+	case NETDEV_UP:
+	case NETDEV_DOWN:
+	case NETDEV_CHANGE:
+		bnxt_re_dispatch_event(&rdev->ibdev, NULL, 1,
+					netif_carrier_ok(real_dev) ?
+					IB_EVENT_PORT_ACTIVE :
+					IB_EVENT_PORT_ERR);
+		break;
 	default:
-		sch_work = true;
 		break;
 	}
-	if (sch_work) {
-		/* Allocate for the deferred task */
-		re_work = kzalloc(sizeof(*re_work), GFP_KERNEL);
-		if (re_work) {
-			get_device(&rdev->ibdev.dev);
-			re_work->rdev = rdev;
-			re_work->event = event;
-			re_work->vlan_dev = (real_dev == netdev ?
-					     NULL : netdev);
-			INIT_WORK(&re_work->work, bnxt_re_task);
-			queue_work(bnxt_re_wq, &re_work->work);
-		}
-	}
-
+	ib_device_put(&rdev->ibdev);
 exit:
-	if (rdev && release)
-		ib_device_put(&rdev->ibdev);
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block bnxt_re_netdev_notifier = {
-	.notifier_call = bnxt_re_netdev_event
-};
+#define BNXT_ADEV_NAME "bnxt_en"
 
-static int __init bnxt_re_mod_init(void)
+static void bnxt_re_remove(struct auxiliary_device *adev)
 {
-	int rc = 0;
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
 
-	pr_info("%s: %s", ROCE_DRV_MODULE_NAME, version);
+	if (!rdev)
+		return;
 
-	bnxt_re_wq = create_singlethread_workqueue("bnxt_re");
-	if (!bnxt_re_wq)
-		return -ENOMEM;
+	mutex_lock(&bnxt_re_mutex);
+	if (rdev->nb.notifier_call) {
+		unregister_netdevice_notifier(&rdev->nb);
+		rdev->nb.notifier_call = NULL;
+	} else {
+		/* If notifier is null, we should have already done a
+		 * clean up before coming here.
+		 */
+		goto skip_remove;
+	}
+
+	ib_unregister_device(&rdev->ibdev);
+	ib_dealloc_device(&rdev->ibdev);
+	bnxt_re_dev_uninit(rdev);
+skip_remove:
+	mutex_unlock(&bnxt_re_mutex);
+}
+
+static int bnxt_re_probe(struct auxiliary_device *adev,
+			 const struct auxiliary_device_id *id)
+{
+	struct bnxt_re_dev *rdev;
+	int rc;
+
+	mutex_lock(&bnxt_re_mutex);
+	rc = bnxt_re_add_device(adev, BNXT_QPLIB_WQE_MODE_STATIC);
+	if (rc) {
+		mutex_unlock(&bnxt_re_mutex);
+		return rc;
+	}
 
-	INIT_LIST_HEAD(&bnxt_re_dev_list);
+	rdev = auxiliary_get_drvdata(adev);
 
-	rc = register_netdevice_notifier(&bnxt_re_netdev_notifier);
+	rdev->nb.notifier_call = bnxt_re_netdev_event;
+	rc = register_netdevice_notifier(&rdev->nb);
 	if (rc) {
+		rdev->nb.notifier_call = NULL;
 		pr_err("%s: Cannot register to netdevice_notifier",
 		       ROCE_DRV_MODULE_NAME);
-		goto err_netdev;
+		goto err;
 	}
+
+	mutex_unlock(&bnxt_re_mutex);
 	return 0;
 
-err_netdev:
-	destroy_workqueue(bnxt_re_wq);
+err:
+	mutex_unlock(&bnxt_re_mutex);
+	bnxt_re_remove(adev);
 
 	return rc;
 }
 
-static void __exit bnxt_re_mod_exit(void)
+static const struct auxiliary_device_id bnxt_re_id_table[] = {
+	{ .name = BNXT_ADEV_NAME ".rdma", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, bnxt_re_id_table);
+
+static struct auxiliary_driver bnxt_re_driver = {
+	.name = "rdma",
+	.probe = bnxt_re_probe,
+	.remove = bnxt_re_remove,
+	.shutdown = bnxt_re_shutdown,
+	.id_table = bnxt_re_id_table,
+};
+
+static int __init bnxt_re_mod_init(void)
 {
-	struct bnxt_re_dev *rdev;
+	int rc = 0;
 
-	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
-	if (bnxt_re_wq)
-		destroy_workqueue(bnxt_re_wq);
-	list_for_each_entry(rdev, &bnxt_re_dev_list, list) {
-		/* VF device removal should be called before the removal
-		 * of PF device. Queue VFs unregister first, so that VFs
-		 * shall be removed before the PF during the call of
-		 * ib_unregister_driver.
-		 */
-		if (rdev->is_virtfn)
-			ib_unregister_device(&rdev->ibdev);
+	pr_info("%s: %s", ROCE_DRV_MODULE_NAME, version);
+	rc = auxiliary_driver_register(&bnxt_re_driver);
+	if (rc) {
+		pr_err("%s: Failed to register auxiliary driver\n",
+			ROCE_DRV_MODULE_NAME);
+		return rc;
 	}
-	ib_unregister_driver(RDMA_DRIVER_BNXT_RE);
+	return 0;
+}
+
+static void __exit bnxt_re_mod_exit(void)
+{
+	auxiliary_driver_unregister(&bnxt_re_driver);
 }
 
 module_init(bnxt_re_mod_init);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 7ffd61ec2683..1d2d30f97ed9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <asm/byteorder.h>
 #include <linux/bitmap.h>
+#include <linux/auxiliary_bus.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -78,8 +79,6 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	if (ulp_id >= BNXT_MAX_ULP)
 		return -EINVAL;
 
-	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
-
 	ulp = &edev->ulp_tbl[ulp_id];
 	if (!rcu_access_pointer(ulp->ulp_ops)) {
 		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
@@ -595,29 +594,3 @@ int bnxt_rdma_aux_device_add(struct bnxt *bp)
 
 	return 0;
 }
-
-struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
-{
-	struct bnxt *bp = netdev_priv(dev);
-	struct bnxt_en_dev *edev;
-
-	edev = bp->edev;
-	if (!edev) {
-		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
-		if (!edev)
-			return ERR_PTR(-ENOMEM);
-		edev->en_ops = &bnxt_en_ops_tbl;
-		edev->net = dev;
-		edev->pdev = bp->pdev;
-		edev->l2_db_size = bp->db_size;
-		edev->l2_db_size_nc = bp->db_size;
-		bp->edev = edev;
-	}
-	edev->flags &= ~BNXT_EN_FLAG_ROCE_CAP;
-	if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
-		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
-	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
-		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
-	return bp->edev;
-}
-EXPORT_SYMBOL(bnxt_ulp_probe);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 8b85c663d881..aaf55d847505 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -32,7 +32,6 @@ struct bnxt_ulp_ops {
 	void (*ulp_stop)(void *);
 	void (*ulp_start)(void *);
 	void (*ulp_sriov_config)(void *, int);
-	void (*ulp_shutdown)(void *);
 	void (*ulp_irq_stop)(void *);
 	void (*ulp_irq_restart)(void *, struct bnxt_msix_entry *);
 };
@@ -111,6 +110,4 @@ int bnxt_rdma_aux_device_add(struct bnxt *bp);
 void bnxt_rdma_aux_device_uninit(struct bnxt_aux_dev *bnxt_adev);
 void bnxt_rdma_aux_device_init(struct bnxt *bp);
 void bnxt_aux_dev_free(struct bnxt *bp);
-struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev);
-
 #endif
-- 
2.37.1 (Apple Git-137.1)


--0000000000008c89d105ef409825
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINfBK93gthRiZgpfS59k
UGOUCilPEYRcNqd5/8oX9MatMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTIwNzE3NTMxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAlQn8yIJSJAmx5bbIRVck8Sq8pHAcmFeTa0Tep
wtK0XdagibWSp/QIrxDZftdCozOkLd+OGvH6xGARnmiKvXmKz22y6qKN5ZAcpbysUdpx8iU/5cJm
ULhOJKrtHU3sKNSVbXiPTwr0Xy7QzzNTmnku/XzteWHmJsWxlCdtydk16MHP7v7SXT/f+SnHaZEn
x9MJgOlqiJ/KwDWtkemFn13F5oe3Lk4Skl9LRcDnnhGFIL4JUCC1FgQNp4hPz9c3+0OuIPEKCoEf
Py+u51vN7lkdJGXgfrxGQUPr3OjYf5u/9JQMHEVgyKM8zKg/ySvxZx55A7BAd8G/OvucVqbHVNyX
--0000000000008c89d105ef409825--
