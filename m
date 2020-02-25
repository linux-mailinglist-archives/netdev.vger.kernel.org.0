Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1A16C36B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgBYOIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56091 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgBYOIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so3130200wmj.5;
        Tue, 25 Feb 2020 06:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=Q9p7MIr9xWRKWE9Ty1ThKuuhqbmR2gydxI1QmC31E4fU6oEw1qyYN13nAuMeBxxFVm
         qP9hZawDDi+Eicy68neorNTY0QOY7M6KWWfkTcU9o1S/2+L7/Hx3bl4KXYv91B4pqxWC
         oPlVgUov5Px6vRWuBLchvHgrq4JX00kFqH1zpwGiaJSfRwC8fqNUDteQBJlWLszEkbGA
         W3wj8eaJHB/EIvuskiezWfTVNgsOAj79LLtQONbkHWfjv6Inm5KtZ02ksnbocfQ2OWwk
         GByy225FyvRe53ffwWC1fyKV7kI4vl786QMW0Mz9A+dS0kQrgUIdw+LkPUnHuK6EfnBj
         KH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=R2wfQhcWWEMuUZploTRZrzOISzwgianFFbv5qA8BVL+O/k3jzZkdt0F/EbgzIFizl0
         MOYLS7cxqn1kQZzxD5siWk4OA5CjXv5THrm3eB2RVopQutbaePAhCa+NtXe1ehfM9n/0
         9lOBJFReNR94BUVllgtWukKNf4s+fWDhXyNJXlFv48NGXBSmvb6w7t3pS0gKm5VMH/pp
         n/tqnhPgNxCsmxowYrVEtw/HYyt+S9QTejTpBaVL56c6bSwEG/hFm4rAWUMip+k+lBO1
         rN+8ZiMMVy33dVeIAz/EDDuLN+xRendQa38H+VGYTKPiNf9T0SEh+w0HRhtKn7sHuaRn
         /B7w==
X-Gm-Message-State: APjAAAXYhC6h4eSWz2GNAVWfZodN5L4A5+BFx2gkB8TUaiVih3c/Tlch
        37k/FZRooC6eEO3raAzt1HD13kBn
X-Google-Smtp-Source: APXvYqyUzpStr0QjVTOF5Pg3dDwRXUodZKtEow20iA4KzrQS/+Vr/ncLCrfWCpQ4SyVLIni24lpXSg==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5718352wmi.31.1582639710701;
        Tue, 25 Feb 2020 06:08:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id q3sm3868407wrs.1.2020.02.25.06.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:30 -0800 (PST)
Subject: [PATCH v3 2/8] PCI: add pci_status_get_and_clear_errors
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
References: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
Message-ID: <45054c7d-cc48-2be0-11fa-4c3ffce8fdd7@gmail.com>
Date:   Tue, 25 Feb 2020 15:04:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
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




