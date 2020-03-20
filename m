Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98A718CE12
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCTMzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 08:55:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50460 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgCTMzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 08:55:42 -0400
Received: from mail-qv1-f69.google.com ([209.85.219.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1jFHBb-0006pJ-9V
        for netdev@vger.kernel.org; Fri, 20 Mar 2020 12:55:39 +0000
Received: by mail-qv1-f69.google.com with SMTP id o102so5628245qvo.14
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 05:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQQYN18U+Ixm8K0qvV3C/c4kjknwZwojXBOMDo2RLAw=;
        b=soPKLnqdA/0fAMhuPqjzX1YiNlxU+kivobQgUGO26B+OLqGe01Wow+Z7HI3dSzYDed
         RDRWoMB5730xNC0CwyQgcK/CqkUpn/f8KYvCoKXm9wqgrZKbc9OJRQrbbXg/4TnlCuVK
         NmcSN06JgYUCsvXPwp6LxLxqSJm/X1/vQTipmy334xGt07ow9K8Qdqj0xg675eQGpdOA
         pA6rnHgisdXbFE8pGmvN5iUQgV+9I4ig6SEKMn21/yhL3986fb9iTzYRnMOM9cUleZl5
         LDUxl9yYE0ix2NFKgs6xDjlEzYyqoKyHPXteLiySVlQrskzfM8RFLs8D5Ey/CLvRF87B
         7DGw==
X-Gm-Message-State: ANhLgQ2JL0jwF13J9enty1v2JoRcnIq75WfA5DoNJWKvRCuzSEewLaTM
        eTttdd7pDz6Ka3P9NgT7KAtDcr2cOUMeG/HpkAoyTbz8gkhg8j+fyvkuEBiH4amSMtC627PXGmz
        XyeKt8fsVZCEfvd+bEtqRwUasXpJrp6C81w==
X-Received: by 2002:a0c:a993:: with SMTP id a19mr7898379qvb.201.1584708938346;
        Fri, 20 Mar 2020 05:55:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvh62xg1FvR6zDglPLyySL2qpCRC9G3j3ih9h3AnKlILMhXY2pAO0A6fhU1Dmott8ZxsnxvNw==
X-Received: by 2002:a0c:a993:: with SMTP id a19mr7898351qvb.201.1584708938047;
        Fri, 20 Mar 2020 05:55:38 -0700 (PDT)
Received: from localhost (189-47-87-73.dsl.telesp.net.br. [189.47.87.73])
        by smtp.gmail.com with ESMTPSA id u123sm4029979qkf.77.2020.03.20.05.55.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2020 05:55:37 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     netanel@amazon.com, akiyano@amazon.com, netdev@vger.kernel.org
Cc:     gtzalik@amazon.com, saeedb@amazon.com, zorik@amazon.com,
        gpiccoli@canonical.com, kernel@gpiccoli.net, gshan@redhat.com,
        gavin.guo@canonical.com, jay.vosburgh@canonical.com,
        pedro.principeza@canonical.com
Subject: [PATCH] net: ena: Add PCI shutdown handler to allow safe kexec
Date:   Fri, 20 Mar 2020 09:55:34 -0300
Message-Id: <20200320125534.28966-1-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ENA only provides the PCI remove() handler, used during rmmod
for example. This is not called on shutdown/kexec path; we are potentially
creating a failure scenario on kexec:

(a) Kexec is triggered, no shutdown() / remove() handler is called for ENA;
instead pci_device_shutdown() clears the master bit of the PCI device,
stopping all DMA transactions;

(b) Kexec reboot happens and the device gets enabled again, likely having
its FW with that DMA transaction buffered; then it may trigger the (now
invalid) memory operation in the new kernel, corrupting kernel memory area.

This patch aims to prevent this, by implementing a shutdown() handler
quite similar to the remove() one - the difference being the handling
of the netdev, which is unregistered on remove(), but following the
convention observed in other drivers, it's only detached on shutdown().

This prevents an odd issue in AWS Nitro instances, in which after the 2nd
kexec the next one will fail with an initrd corruption, caused by a wild
DMA write to invalid kernel memory. The lspci output for the adapter
present in my instance is:

00:05.0 Ethernet controller [0200]: Amazon.com, Inc. Elastic Network
Adapter (ENA) [1d0f:ec20]

Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---


The idea for this patch came from an informal conversation with my
friend Gavin Shan, based on his past experience with similar issues.
I'd like to thank him for the great suggestion!

As a test metric, I've performed 1000 kexecs with this patch, whereas
without this one, the 3rd kexec failed with initrd corruption. Also,
one test that I've done before writing the patch was just to rmmod
the driver before the kexecs, and it worked fine too.

I suggest we add this patch in stable releases as well.
Thanks in advance for reviews,

Guilherme


 drivers/net/ethernet/amazon/ena/ena_netdev.c | 51 ++++++++++++++++----
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0b2fd96b93d7..7a5c01ff2ee8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4325,13 +4325,15 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 /*****************************************************************************/
 
-/* ena_remove - Device Removal Routine
+/* __ena_shutoff - Helper used in both PCI remove/shutdown routines
  * @pdev: PCI device information struct
+ * @shutdown: Is it a shutdown operation? If false, means it is a removal
  *
- * ena_remove is called by the PCI subsystem to alert the driver
- * that it should release a PCI device.
+ * __ena_shutoff is a helper routine that does the real work on shutdown and
+ * removal paths; the difference between those paths is with regards to whether
+ * dettach or unregister the netdevice.
  */
-static void ena_remove(struct pci_dev *pdev)
+static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 {
 	struct ena_adapter *adapter = pci_get_drvdata(pdev);
 	struct ena_com_dev *ena_dev;
@@ -4350,13 +4352,17 @@ static void ena_remove(struct pci_dev *pdev)
 
 	cancel_work_sync(&adapter->reset_task);
 
-	rtnl_lock();
+	rtnl_lock(); /* lock released inside the below if-else block */
 	ena_destroy_device(adapter, true);
-	rtnl_unlock();
-
-	unregister_netdev(netdev);
-
-	free_netdev(netdev);
+	if (shutdown) {
+		netif_device_detach(netdev);
+		dev_close(netdev);
+		rtnl_unlock();
+	} else {
+		rtnl_unlock();
+		unregister_netdev(netdev);
+		free_netdev(netdev);
+	}
 
 	ena_com_rss_destroy(ena_dev);
 
@@ -4371,6 +4377,30 @@ static void ena_remove(struct pci_dev *pdev)
 	vfree(ena_dev);
 }
 
+/* ena_remove - Device Removal Routine
+ * @pdev: PCI device information struct
+ *
+ * ena_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+
+static void ena_remove(struct pci_dev *pdev)
+{
+	__ena_shutoff(pdev, false);
+}
+
+/* ena_shutdown - Device Shutdown Routine
+ * @pdev: PCI device information struct
+ *
+ * ena_shutdown is called by the PCI subsystem to alert the driver that
+ * a shutdown/reboot (or kexec) is happening and device must be disabled.
+ */
+
+static void ena_shutdown(struct pci_dev *pdev)
+{
+	__ena_shutoff(pdev, true);
+}
+
 #ifdef CONFIG_PM
 /* ena_suspend - PM suspend callback
  * @pdev: PCI device information struct
@@ -4420,6 +4450,7 @@ static struct pci_driver ena_pci_driver = {
 	.id_table	= ena_pci_tbl,
 	.probe		= ena_probe,
 	.remove		= ena_remove,
+	.shutdown	= ena_shutdown,
 #ifdef CONFIG_PM
 	.suspend    = ena_suspend,
 	.resume     = ena_resume,
-- 
2.25.1

