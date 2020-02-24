Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2746B16B25A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgBXV3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:29:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40608 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXV3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so891833wmi.5;
        Mon, 24 Feb 2020 13:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=KRGL7Dfw9AmYBgTT355/arXlkJj94zoHK4aI5FwEBCgeAAHABMXyXfeqml3pUhVNqi
         nbVsnJkyvruO/bKeeCsXGMJTlD+IjpGOc4c0bZZm1K/gOKpZ5BZhrCHeBPRp0E/gH1PI
         6tY12nlIUMHfEL15oIz9d1D2ALTLN3Mv4pW3ycJUIbI4yrF+KHehSosxsAUwr5vhkLgL
         orLqvKoV2BqyS5frnEfJx4hYZyWZ3mlSoCymHVaEaWUnHXaD+paWtJrvnNmuM1RHQzrH
         GczYFDXRaH5muw0O9X/QupgIKxJv2hJ84RY9Y9vYBHxk441PX8UVYQt0no9ICxnz8CpN
         9G3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=XjTT4hFUzBOgFSipO/nGGhWC9GQQLdCV9b9RW7Na/MnWEEiMHfg7Vq+bz7P1pl06Se
         LvG07kzGw3Q6KEwjNGjmfbJTaJYPyQHrizZ70kZbGULOC/Su8pbZC2+cUvAlFS/mfL5T
         de0xJrWfIF83AHw3ZGYCG8ocQjm0F4EZfH68V2ObEsl0tV6mbwpmAeAXZdG0MEnZf1BI
         h8hcFIOUNpmc07E2G7cOvDhk1E1k+8BWhts2XPZqrjxyqeOx1o6+ZvR53Lrz155GZb1D
         2EwJS+O6K5P9qS4GFoL/oY5S8A2Y09OJZ2wsbeTIFdzH60iRdW0sHp2G2kzyM/kxvwyk
         WtNQ==
X-Gm-Message-State: APjAAAUbqsF9Jjwm1lt+MBESQDuX87dD2LkaMNm45NVvpDHW6BvkCsMV
        unHfE2dhNUQbf3lOm3ZbnMVsr2s1
X-Google-Smtp-Source: APXvYqz1pSYPGX7ya+KOU9Qz2kP/11cBDByqV1RM+qFHBF3nwF57XPovbTgCNy3mmiS4bOicy9H/ew==
X-Received: by 2002:a7b:c147:: with SMTP id z7mr945164wmi.168.1582579783841;
        Mon, 24 Feb 2020 13:29:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id v17sm19784361wrt.91.2020.02.24.13.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:43 -0800 (PST)
Subject: [PATCH 2/8] PCI: add pci_status_get_and_clear_errors
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Message-ID: <cf7fce71-1711-2756-38e2-2d08a6c496d2@gmail.com>
Date:   Mon, 24 Feb 2020 22:23:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few drivers use the following code sequence:
1. Read PCI_STATUS
2. Mask out non-error bits
3. Action based on error bits set
4. Write back set error bits to clear them

As this is a repeated pattern, add a helper to the PCI core.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/pci.c   | 23 +++++++++++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d828ca835..c16b0ba2a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -173,6 +173,29 @@ unsigned char pci_bus_max_busnr(struct pci_bus *bus)
 }
 EXPORT_SYMBOL_GPL(pci_bus_max_busnr);
 
+/**
+ * pci_status_get_and_clear_errors - return and clear error bits in PCI_STATUS
+ * @pdev: the PCI device
+ *
+ * Returns error bits set in PCI_STATUS and clears them.
+ */
+int pci_status_get_and_clear_errors(struct pci_dev *pdev)
+{
+	u16 status;
+	int ret;
+
+	ret = pci_read_config_word(pdev, PCI_STATUS, &status);
+	if (ret != PCIBIOS_SUCCESSFUL)
+		return -EIO;
+
+	status &= PCI_STATUS_ERROR_BITS;
+	if (status)
+		pci_write_config_word(pdev, PCI_STATUS, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(pci_status_get_and_clear_errors);
+
 #ifdef CONFIG_HAS_IOMEM
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3840a541a..7a75aae04 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1203,6 +1203,7 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 bool pci_device_is_present(struct pci_dev *pdev);
 void pci_ignore_hotplug(struct pci_dev *dev);
 struct pci_dev *pci_real_dma_dev(struct pci_dev *dev);
+int pci_status_get_and_clear_errors(struct pci_dev *pdev);
 
 int __printf(6, 7) pci_request_irq(struct pci_dev *dev, unsigned int nr,
 		irq_handler_t handler, irq_handler_t thread_fn, void *dev_id,
-- 
2.25.1


