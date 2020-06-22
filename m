Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC6B203608
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgFVLoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgFVLoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:34 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A6C061794;
        Mon, 22 Jun 2020 04:44:34 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so8040475pje.4;
        Mon, 22 Jun 2020 04:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fPbZUQT1VbLR1XExkOHhJDqfB6VA400G+a21PYV/3fs=;
        b=EeazGPCwfh2zRSycCdzNh59i+CgRWTtwh5JVoLDA7o2ZIBQc7oJHD5YpMHIsIG0o1d
         qtCXNe6U+RlUEu12o/GMl2OESvR0StKwfq2WWB3YFurqkjsel1BLQvbEmwJo2MVBdHse
         STvv2P3lgLHUS9GWfYMk+gt2KcYT4PgTOXo5ALKGDihYq0tiuW5AI0t/Knr2dWqEJIu6
         3Cxn3B3sD1qxzbAdZ2weHc5fx/UuvNusplgz4CLxXIO8dp9s9yfVB3A2SbYCEX3GLNTU
         lgDl6UXt0Hh+zYqReIR0P//hRTGNRrP+xXrHM17H6Js0MASNVBPxscuSIyJfcg660cLL
         tPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPbZUQT1VbLR1XExkOHhJDqfB6VA400G+a21PYV/3fs=;
        b=GV3rtmon2PSvXVCOv0ScoJkHq5EFtIe2SOfyQjGiXPsrupAnrYeSiHrmYYg+To9laI
         tzzWby+TugzdydoAiL254maiQFJqDyGNO9pVeJZK+1X29+f8EGxnF87CVSB2ec3IfYiC
         ctjaaBb2ITJlDQZ5+rkeE0lNP3FH/H0xWgZFZU2vy57hO4CzHyJ90NK7ekUv/F3q3raw
         tvpmdU/KEpzDw2zF/GbNwzhUTbPY/BMDUyZ3Cwk9hTx1yQoVpjbiP2NfOd2qlUETq1+o
         VGQgjitq+H6hL/C/FGpCJZpZpPi/vdpJGwl45M7s3acbgqjkykQvZ6C/T1SIgQ/MYfl9
         UwZg==
X-Gm-Message-State: AOAM532PatIvJaUOGLKe522lYz17KUskXvr9VpXdnqAO8rRV0f0k5uBF
        c25x4w8JNdyzq22n43C2CjI=
X-Google-Smtp-Source: ABdhPJwNzqwp+OTurFYW2OqobXmnFONIUpFUSOsdLqGPvxoglUQTXM7D0MROKehtPSHZWTfKKGGaaw==
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr18192326pjb.206.1592826273778;
        Mon, 22 Jun 2020 04:44:33 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:33 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 5/5] tulip: uli526x: use generic power management
Date:   Mon, 22 Jun 2020 17:12:28 +0530
Message-Id: <20200622114228.60027-6-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
References: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves.

Legacy PM involves usage of PCI helper functions like pci_enable_wake()
which is no longer recommended.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/dec/tulip/uli526x.c | 48 ++++--------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index f726436b1985..f942399f0f32 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -1163,65 +1163,41 @@ static void uli526x_dynamic_reset(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-
-#ifdef CONFIG_PM
-
 /*
  *	Suspend the interface.
  */
 
-static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused uli526x_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	pci_power_t power_state;
-	int err;
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	ULI526X_DBUG(0, "uli526x_suspend", 0);
 
-	pci_save_state(pdev);
-
 	if (!netif_running(dev))
 		return 0;
 
 	netif_device_detach(dev);
 	uli526x_reset_prepare(dev);
 
-	power_state = pci_choose_state(pdev, state);
-	pci_enable_wake(pdev, power_state, 0);
-	err = pci_set_power_state(pdev, power_state);
-	if (err) {
-		netif_device_attach(dev);
-		/* Re-initialize ULI526X board */
-		uli526x_init(dev);
-		/* Restart upper layer interface */
-		netif_wake_queue(dev);
-	}
+	device_set_wakeup_enable(dev_d, 0);
 
-	return err;
+	return 0;
 }
 
 /*
  *	Resume the interface.
  */
 
-static int uli526x_resume(struct pci_dev *pdev)
+static int __maybe_unused uli526x_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	int err;
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	ULI526X_DBUG(0, "uli526x_resume", 0);
 
-	pci_restore_state(pdev);
 
 	if (!netif_running(dev))
 		return 0;
 
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err) {
-		netdev_warn(dev, "Could not put device into D0\n");
-		return err;
-	}
-
 	netif_device_attach(dev);
 	/* Re-initialize ULI526X board */
 	uli526x_init(dev);
@@ -1231,14 +1207,6 @@ static int uli526x_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#else /* !CONFIG_PM */
-
-#define uli526x_suspend	NULL
-#define uli526x_resume	NULL
-
-#endif /* !CONFIG_PM */
-
-
 /*
  *	free all allocated rx buffer
  */
@@ -1761,14 +1729,14 @@ static const struct pci_device_id uli526x_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, uli526x_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(uli526x_pm_ops, uli526x_suspend, uli526x_resume);
 
 static struct pci_driver uli526x_driver = {
 	.name		= "uli526x",
 	.id_table	= uli526x_pci_tbl,
 	.probe		= uli526x_init_one,
 	.remove		= uli526x_remove_one,
-	.suspend	= uli526x_suspend,
-	.resume		= uli526x_resume,
+	.driver.pm	= &uli526x_pm_ops,
 };
 
 MODULE_AUTHOR("Peer Chen, peer.chen@uli.com.tw");
-- 
2.27.0

