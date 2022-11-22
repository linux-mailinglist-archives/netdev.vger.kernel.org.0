Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AFD633867
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiKVJ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiKVJ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:28:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB222FFF9
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:28:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so7787571pjk.1
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/GVFeQ7YQxZxifzanltQSzgNMaKfrPVzQi5mw4Z3bF4=;
        b=InlihnCtBXub3e4GGhMCBwY1/GPSUE/nd2yAnHD2vdhAGxwrNEgB9rOSw/YuihxPJ6
         O5k7Bggkul+2KPHCPA6WcrVckzd2qSw+plh8tGOMIKHtSnWM6C7k9BLbfWCInLryFm8C
         1E9oidtS4WE1nQFGv44edb8P6ZIZUuJF9/Mz4cy/zHLq+niDa+k1gx0yzALzi5+GGYw5
         96h9zc3fgKrj9tms7P58EBKRhwy+rtwSKsE//H6ooFmZqOuvrQ8E6eCvkQQYAiftlLNe
         x9fSp9HeDFyHBvg0P838npW4aMYcTU9dPK1ANnA+r8myNRq8G5jQY3hY7xl9Kroh2GxH
         +JDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/GVFeQ7YQxZxifzanltQSzgNMaKfrPVzQi5mw4Z3bF4=;
        b=sdDAuPjpa5LWqO8k3Nqg7Mo3vpf9rqt+SCiOjCxDb2Q+qauI/jsF7nhQf0mROFi4e2
         gf9Rdlm7DP5wNkffVOTOMKRmGSAqhBmaY5M2t24zn9tmQ635LUcxeR4Sg+MbpsjI5hPs
         tdPzvACyZz+FwClCQVwZ2jVAPj63KlJlzUyZJeB9GqzZXJjUTG7ygmFJ44/E9cnbqwQo
         LqUANQmL0w6mPJW8dgQV6ZAAXCGQeO6njkNCOaoK1iWSg/Ui0boegF9M3GL9NsyOVWCd
         zBYHhGQc3PEPrzItS8SQnfShrZHbXjjm5cqbC5wRfhqID/73pPKjJv1St08s1N6RVd5V
         F9Sw==
X-Gm-Message-State: ANoB5pl8F+LRKYtbZUWpMw+BpvcMbb9OcIwheEkiXtE5l/liYJxElVH/
        L9VS7YBKgZo4W8+ZXKMtvTZtng==
X-Google-Smtp-Source: AA0mqf5voQeb5q+y0iCbkC5x9G+rL6VjFxbtDwT+AZaXlqsIb0KbSzfOgfT4Fyt5x0BQg7QWOATYDQ==
X-Received: by 2002:a17:902:a984:b0:188:feab:4fd3 with SMTP id bh4-20020a170902a98400b00188feab4fd3mr4013430plb.167.1669109296171;
        Tue, 22 Nov 2022 01:28:16 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id e7-20020aa798c7000000b0056d98e31439sm10558784pfm.140.2022.11.22.01.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 01:28:15 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] igb: Enable SR-IOV after reinit
Date:   Tue, 22 Nov 2022 18:28:03 +0900
Message-Id: <20221122092803.31083-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling SR-IOV causes the virtual functions to make requests to the
PF via the mailbox. Notably, E1000_VF_RESET request will happen during
the initialization of the VF. However, unless the reinit is done, the
VMMB interrupt, which delivers mailbox interrupt from VF to PF will be
kept masked and such requests will be silently ignored.

Enable SR-IOV at the very end of the procedure to configure the device
for SR-IOV so that the PF is configured properly for SR-IOV when a VF is
activated.

Fixes: fa44f2f185f7 ("igb: Enable SR-IOV configuration via PCI sysfs interface")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 135 ++++++++++------------
 1 file changed, 58 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index cfe6bf6e2336..74694a27e35d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -109,6 +109,7 @@ static void igb_free_all_rx_resources(struct igb_adapter *);
 static void igb_setup_mrqc(struct igb_adapter *);
 static int igb_probe(struct pci_dev *, const struct pci_device_id *);
 static void igb_remove(struct pci_dev *pdev);
+static void igb_init_queue_configuration(struct igb_adapter *adapter);
 static int igb_sw_init(struct igb_adapter *);
 int igb_open(struct net_device *);
 int igb_close(struct net_device *);
@@ -175,9 +176,7 @@ static void igb_nfc_filter_restore(struct igb_adapter *adapter);
 
 #ifdef CONFIG_PCI_IOV
 static int igb_vf_configure(struct igb_adapter *adapter, int vf);
-static int igb_pci_enable_sriov(struct pci_dev *dev, int num_vfs);
-static int igb_disable_sriov(struct pci_dev *dev);
-static int igb_pci_disable_sriov(struct pci_dev *dev);
+static int igb_disable_sriov(struct pci_dev *dev, bool reinit);
 #endif
 
 static int igb_suspend(struct device *);
@@ -3616,7 +3615,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(adapter->shadow_vfta);
 	igb_clear_interrupt_scheme(adapter);
 #ifdef CONFIG_PCI_IOV
-	igb_disable_sriov(pdev);
+	igb_disable_sriov(pdev, false);
 #endif
 	pci_iounmap(pdev, adapter->io_addr);
 err_ioremap:
@@ -3631,7 +3630,38 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 }
 
 #ifdef CONFIG_PCI_IOV
-static int igb_disable_sriov(struct pci_dev *pdev)
+static int igb_sriov_reinit(struct pci_dev *dev)
+{
+	struct net_device *netdev = pci_get_drvdata(dev);
+	struct igb_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
+
+	rtnl_lock();
+
+	if (netif_running(netdev))
+		igb_close(netdev);
+	else
+		igb_reset(adapter);
+
+	igb_clear_interrupt_scheme(adapter);
+
+	igb_init_queue_configuration(adapter);
+
+	if (igb_init_interrupt_scheme(adapter, true)) {
+		rtnl_unlock();
+		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
+		return -ENOMEM;
+	}
+
+	if (netif_running(netdev))
+		igb_open(netdev);
+
+	rtnl_unlock();
+
+	return 0;
+}
+
+static int igb_disable_sriov(struct pci_dev *pdev, bool reinit)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
@@ -3665,10 +3695,10 @@ static int igb_disable_sriov(struct pci_dev *pdev)
 		adapter->flags |= IGB_FLAG_DMAC;
 	}
 
-	return 0;
+	return reinit ? igb_sriov_reinit(pdev) : 0;
 }
 
-static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
+static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs, bool reinit)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
@@ -3733,12 +3763,6 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 			"Unable to allocate memory for VF MAC filter list\n");
 	}
 
-	/* only call pci_enable_sriov() if no VFs are allocated already */
-	if (!old_vfs) {
-		err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
-		if (err)
-			goto err_out;
-	}
 	dev_info(&pdev->dev, "%d VFs allocated\n",
 		 adapter->vfs_allocated_count);
 	for (i = 0; i < adapter->vfs_allocated_count; i++)
@@ -3746,6 +3770,17 @@ static int igb_enable_sriov(struct pci_dev *pdev, int num_vfs)
 
 	/* DMA Coalescing is not supported in IOV mode. */
 	adapter->flags &= ~IGB_FLAG_DMAC;
+
+	if (reinit) {
+		err = igb_sriov_reinit(pdev);
+		if (err)
+			goto err_out;
+	}
+
+	/* only call pci_enable_sriov() if no VFs are allocated already */
+	if (!old_vfs)
+		err = pci_enable_sriov(pdev, adapter->vfs_allocated_count);
+
 	goto out;
 
 err_out:
@@ -3816,7 +3851,7 @@ static void igb_remove(struct pci_dev *pdev)
 
 #ifdef CONFIG_PCI_IOV
 	rtnl_lock();
-	igb_disable_sriov(pdev);
+	igb_disable_sriov(pdev, false);
 	rtnl_unlock();
 #endif
 
@@ -3865,7 +3900,7 @@ static void igb_probe_vfs(struct igb_adapter *adapter)
 	igb_reset_interrupt_capability(adapter);
 
 	pci_sriov_set_totalvfs(pdev, 7);
-	igb_enable_sriov(pdev, max_vfs);
+	igb_enable_sriov(pdev, max_vfs, false);
 
 #endif /* CONFIG_PCI_IOV */
 }
@@ -9475,71 +9510,17 @@ static void igb_shutdown(struct pci_dev *pdev)
 	}
 }
 
-#ifdef CONFIG_PCI_IOV
-static int igb_sriov_reinit(struct pci_dev *dev)
-{
-	struct net_device *netdev = pci_get_drvdata(dev);
-	struct igb_adapter *adapter = netdev_priv(netdev);
-	struct pci_dev *pdev = adapter->pdev;
-
-	rtnl_lock();
-
-	if (netif_running(netdev))
-		igb_close(netdev);
-	else
-		igb_reset(adapter);
-
-	igb_clear_interrupt_scheme(adapter);
-
-	igb_init_queue_configuration(adapter);
-
-	if (igb_init_interrupt_scheme(adapter, true)) {
-		rtnl_unlock();
-		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
-		return -ENOMEM;
-	}
-
-	if (netif_running(netdev))
-		igb_open(netdev);
-
-	rtnl_unlock();
-
-	return 0;
-}
-
-static int igb_pci_disable_sriov(struct pci_dev *dev)
-{
-	int err = igb_disable_sriov(dev);
-
-	if (!err)
-		err = igb_sriov_reinit(dev);
-
-	return err;
-}
-
-static int igb_pci_enable_sriov(struct pci_dev *dev, int num_vfs)
-{
-	int err = igb_enable_sriov(dev, num_vfs);
-
-	if (err)
-		goto out;
-
-	err = igb_sriov_reinit(dev);
-	if (!err)
-		return num_vfs;
-
-out:
-	return err;
-}
-
-#endif
 static int igb_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
 {
 #ifdef CONFIG_PCI_IOV
-	if (num_vfs == 0)
-		return igb_pci_disable_sriov(dev);
-	else
-		return igb_pci_enable_sriov(dev, num_vfs);
+	int err;
+
+	if (num_vfs == 0) {
+		return igb_disable_sriov(dev, true);
+	} else {
+		err = igb_enable_sriov(dev, num_vfs, true);
+		return err ? err : num_vfs;
+	}
 #endif
 	return 0;
 }
-- 
2.38.1

