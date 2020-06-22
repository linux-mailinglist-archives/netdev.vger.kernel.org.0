Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFE2035FF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFVLoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFVLoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5503CC061794;
        Mon, 22 Jun 2020 04:44:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b201so8317622pfb.0;
        Mon, 22 Jun 2020 04:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGnJOhO4SDYQP4rIHcqc+jo7CYqIdXY8MtdWzsoIdCI=;
        b=bOs13kjt6xy7YNxCUBgjD5k9fmCgmyX2SS4xWIWAQlvC5MvA5oTmblZRMWNsBNC/ul
         ULrMAs8Vr76/7RP5upSYHmUzXj43Hg9b8WYrc3mlv9KyffbrFyATHbKkdKhBs86C6k9c
         HOfZh6I0l4ZUq2UBL8FloPUkvCiUNj8aOisbAg4f00lTUypZ8v7eqBA1W4dewDB3NdyG
         Pt7ifMfDSuDm+x/fnMMmDJdVyioMsanuXPh75c659IQaA6uOb7bsepo4d/JuWTj53uNt
         EyotPx4DMmJlmPySOyisyJ0kBk/Tw/+MJGGPDvuFO42rirhiRHdW0QUQUTpR61bCnqFt
         FedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGnJOhO4SDYQP4rIHcqc+jo7CYqIdXY8MtdWzsoIdCI=;
        b=osUjybSUVb/6vHGjLap+DL9OHP+3HjPHBYjaloJsWCDF1qo1SHDSg4vr+hW6tSQh+B
         n83t24jcFa22vvseojY4fdpzssZozXgV8461TmzAK38M7UatmGJvIM+g1CN2Rqq6zJYq
         8ohygH5OOcxMZlliKekpcxtY9kEBB+iWOwIcLajesQYVEEZuwCENo7wH9vjN8csJpojk
         jE/PL0uDhayoaLx8LlbSEdoAWd7xL2JZLmnq2cUh4rT0a17CctjxX0bmRaxvuFsnJrt/
         Ow6r5rj1pPjht74m90z3L3ye6ZBJ71+VDQNOFSu3KJKh1yPBv0tK6PDMBg0MjHtMlyxS
         7VEw==
X-Gm-Message-State: AOAM530UazyqmYthBJVSLLGDUznlZSotAkNiq6YmIexde18J8BvYdzZK
        Sb1LMnp6rkNYTopQ8ag5QOM=
X-Google-Smtp-Source: ABdhPJymCgIHPEgnF1nd3ZAxp1jzRQj5T7dU3KfC+xW015Y6+X/L/kwwJFSB0Tp0cxzOSCtEpyOMzA==
X-Received: by 2002:a62:5c03:: with SMTP id q3mr20118520pfb.58.1592826255851;
        Mon, 22 Jun 2020 04:44:15 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:15 -0700 (PDT)
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
Subject: [PATCH v1 2/5] tulip: windbond-840: use generic power management
Date:   Mon, 22 Jun 2020 17:12:25 +0530
Message-Id: <20200622114228.60027-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
References: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With stable support of generic PM callbacks, drivers no longer need to use
legacy .suspend() and .resume() in which they had to maintain PCI states
changes and device's power state themselves.

Earlier, .resume() was invoking pci_enable_device(). Drivers should not
call PCI legacy helper functions, hence, it was removed. This should not
change the behavior of the device as this function is called by PCI core
if somehow pm_ops is not able to bind with the driver, else, required tasks
are managed by the core itself.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/dec/tulip/winbond-840.c | 26 ++++++--------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 4d5e4fa53023..5dcc66f60144 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -1530,8 +1530,6 @@ static void w840_remove1(struct pci_dev *pdev)
 	}
 }
 
-#ifdef CONFIG_PM
-
 /*
  * suspend/resume synchronization:
  * - open, close, do_ioctl:
@@ -1555,9 +1553,9 @@ static void w840_remove1(struct pci_dev *pdev)
  * Detach must occur under spin_unlock_irq(), interrupts from a detached
  * device would cause an irq storm.
  */
-static int w840_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused w840_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem *ioaddr = np->base_addr;
 
@@ -1590,21 +1588,15 @@ static int w840_suspend (struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int w840_resume (struct pci_dev *pdev)
+static int __maybe_unused w840_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct netdev_private *np = netdev_priv(dev);
-	int retval = 0;
 
 	rtnl_lock();
 	if (netif_device_present(dev))
 		goto out; /* device not suspended */
 	if (netif_running(dev)) {
-		if ((retval = pci_enable_device(pdev))) {
-			dev_err(&dev->dev,
-				"pci_enable_device failed in resume\n");
-			goto out;
-		}
 		spin_lock_irq(&np->lock);
 		iowrite32(1, np->base_addr+PCIBusCfg);
 		ioread32(np->base_addr+PCIBusCfg);
@@ -1622,19 +1614,17 @@ static int w840_resume (struct pci_dev *pdev)
 	}
 out:
 	rtnl_unlock();
-	return retval;
+	return 0;
 }
-#endif
+
+static SIMPLE_DEV_PM_OPS(w840_pm_ops, w840_suspend, w840_resume);
 
 static struct pci_driver w840_driver = {
 	.name		= DRV_NAME,
 	.id_table	= w840_pci_tbl,
 	.probe		= w840_probe1,
 	.remove		= w840_remove1,
-#ifdef CONFIG_PM
-	.suspend	= w840_suspend,
-	.resume		= w840_resume,
-#endif
+	.driver.pm	= &w840_pm_ops,
 };
 
 static int __init w840_init(void)
-- 
2.27.0

