Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71295203602
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgFVLo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFVLoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C095AC061794;
        Mon, 22 Jun 2020 04:44:21 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b7so6565509pju.0;
        Mon, 22 Jun 2020 04:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BPbjKYMHm32Cbq8mcRL1k19s011F/vdrw1Z/1h/BoFI=;
        b=W9WgbAOKoQ9vJ+KfjZt44yCSuN6FjFvqzAiNjUlfhV7txGEG3vtw3b3rD86ksCnkrx
         G/Oz1KBaCQbtLY9yPTT4aT1aQx4Qk+27aKmrCxjltwg6tWVd/PxOhEGaorD0XbV4+3y5
         T+pLGjjW5tjiRifgebT9pvqspqhMPNh1zTSKJVzQO1t3ADjp8Jvnc4TbyW9YZg8ePr2/
         6I6Foa55k4QvKyvch1mjgcR/ppgH1DBjV2iCXCMyXEUBVX96CpT6XrBsczUeTvJJkkiP
         RWytvzzjbTMt30hkiIDbfuFPRixxftMVR1Wg8pS7rcTdsfmk8iEIgKlMmwpDjP2BKstB
         GaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPbjKYMHm32Cbq8mcRL1k19s011F/vdrw1Z/1h/BoFI=;
        b=ZUbxUlJx6fnOIMWjGrH7fHU7SpFL0PSaR2NHPGqeVs/ZkV1qWFRRdG+Yui9WWTddvw
         qCU5fHWQdIm1cid5SRZAnEY9U2Bfdqtfd84vsV2FwIx6hp14gWiEg95sOk3FpgwOyhBx
         vRWPYz0qm8gPNrbmGMZbllSHwdg0KuQnogytC/3tK5Xa0K40jMtIjOF8vKUA+VVF13dq
         ZiztpBQATJNcC4Y8oNK2g7Fl/LSM3e9GcEz0g8Dgn0QTD90WlbIWTewD9ucRLAyRzsGX
         YV+Al3fgRoZYELfSndVC6d4uOm7gYlXolGLo40c8YDeA2B7YMm+kuO40eFc+oC1/izT0
         RsoQ==
X-Gm-Message-State: AOAM532dS0bJVFJrIvVgo+blRFmg2ATZ4sWyFwblNjLeXK23qx7heLZ8
        8+gDBns4mPBJqMCt5ODz1yk=
X-Google-Smtp-Source: ABdhPJyxLKscGneV+xX9/87Zow8KbCDQ5hwGFnKH5GJFjesozVOayiLOZjXNm6HA4MgkJm5vYIvmOw==
X-Received: by 2002:a17:902:3:: with SMTP id 3mr17681289pla.120.1592826261334;
        Mon, 22 Jun 2020 04:44:21 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:20 -0700 (PDT)
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
Subject: [PATCH v1 3/5] tulip: de2104x: use generic power management
Date:   Mon, 22 Jun 2020 17:12:26 +0530
Message-Id: <20200622114228.60027-4-vaibhavgupta40@gmail.com>
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

Earlier, .suspend() and .resume() were invoking pci_disable_device()
and pci_enable_device() respectively to manage the device's power state.
With generic PM, it is no longer needed. The driver is expected to just
implement driver-specific operations and leave power transitions to PCI
core.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 25 ++++++++----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 592454f444ce..cb116b530f5e 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2105,11 +2105,10 @@ static void de_remove_one(struct pci_dev *pdev)
 	free_netdev(dev);
 }
 
-#ifdef CONFIG_PM
-
-static int de_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused de_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct net_device *dev = pci_get_drvdata(pdev);
 	struct de_private *de = netdev_priv(dev);
 
 	rtnl_lock();
@@ -2136,7 +2135,6 @@ static int de_suspend (struct pci_dev *pdev, pm_message_t state)
 		de_clean_rings(de);
 
 		de_adapter_sleep(de);
-		pci_disable_device(pdev);
 	} else {
 		netif_device_detach(dev);
 	}
@@ -2144,21 +2142,17 @@ static int de_suspend (struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int de_resume (struct pci_dev *pdev)
+static int __maybe_unused de_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct net_device *dev = pci_get_drvdata(pdev);
 	struct de_private *de = netdev_priv(dev);
-	int retval = 0;
 
 	rtnl_lock();
 	if (netif_device_present(dev))
 		goto out;
 	if (!netif_running(dev))
 		goto out_attach;
-	if ((retval = pci_enable_device(pdev))) {
-		netdev_err(dev, "pci_enable_device failed in resume\n");
-		goto out;
-	}
 	pci_set_master(pdev);
 	de_init_rings(de);
 	de_init_hw(de);
@@ -2169,17 +2163,14 @@ static int de_resume (struct pci_dev *pdev)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
+static SIMPLE_DEV_PM_OPS(de_pm_ops, de_suspend, de_resume);
 
 static struct pci_driver de_driver = {
 	.name		= DRV_NAME,
 	.id_table	= de_pci_tbl,
 	.probe		= de_init_one,
 	.remove		= de_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= de_suspend,
-	.resume		= de_resume,
-#endif
+	.driver.pm	= &de_pm_ops,
 };
 
 static int __init de_init (void)
-- 
2.27.0

