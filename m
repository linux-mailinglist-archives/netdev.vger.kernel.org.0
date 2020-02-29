Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 541AE1749AE
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgB2W3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40477 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgB2W3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id e26so1600565wme.5;
        Sat, 29 Feb 2020 14:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jnuDTYj9lUlehqsBH2n0F57ZiFU3IVBaej0e8OE23bM=;
        b=RQ2LpkttKbS8cs24JMeBKn32qIaxneyzbEMRLIrtE/fzLtZPHt/75IEPf+N/lJTKt8
         169s9nLEnk4zg5DjB7iei2/Op5P5q/FlUz+y9/WuD2D96FoI5+bE08wfLWbmdkeGFvZW
         /+Jq8Y1Ny44UEy5gHYVrfvk4hGZKs1Xv8dbJZAUnabJc1czQWorxkOwMN8RfeerLAa/Z
         IYcYYbjEqlfXE64NVURam/aZT0eUl0kwk3tckYMpzAOaMkKWngMb8+xWru9cwSYxeytz
         uHjxDeIhlUERmxKqwgUg7hjWXOQUOgyr+55r4JhEgwUYKExL/jjfA13CobF4JZ3j9lrT
         UgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jnuDTYj9lUlehqsBH2n0F57ZiFU3IVBaej0e8OE23bM=;
        b=HQi4LlQ7gzKkL8PnXT4Gj5vQPjhDoN6E7KjRvT33GEYK1Tnp9U1QAl3C6xQTFh0KdL
         i0LRa9vr0+vAXQ98Jf76ZkjRNUG+mq/qhEBg1wGJyRSqQOP7Dc52wS7xsP1KTbf3K1pE
         nFBJ/LMi3819JzT8Gw5W/ZKqR66CbECq/usVxE7DFmd0qkphRVbN88oTDhzL3j5i0Oxy
         AToSHXJFykncpMHW48Hlf6SHejefQjasd0nnW8uEsxW5lk/ME6Vt9XeAN/NEB1dxc/xC
         clTVLORbvFxwXcr5ONr0jy3u+4VYnHAxQXi5qWBEo4bYBWiAtumKyHnVuY9kfr4WRTXh
         msNQ==
X-Gm-Message-State: APjAAAU4G9ZOBBzABPPTPxlbIpDkX0bvaSGBl5MnWCFdoPmMVH/RloGq
        Kk+hlwV7DeqOdInXliIgTa4=
X-Google-Smtp-Source: APXvYqzXO1TqpbaM9Fj6cDDlASNAwTaZ6t7s1GA3ldX6bahXJCDNJZCdyHUYjavqs+wiunrbffUlkw==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr11789810wmc.159.1583015368922;
        Sat, 29 Feb 2020 14:29:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id a26sm8442899wmm.18.2020.02.29.14.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:28 -0800 (PST)
Subject: [PATCH v4 05/10] PCI: Add pci_status_get_and_clear_errors
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
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <e0251b07-d08f-df4d-7e80-9eba3d3e43af@gmail.com>
Date:   Sat, 29 Feb 2020 23:24:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers use the following code sequence:
1. Read PCI_STATUS
2. Mask out non-error bits
3. Action based on error bits set
4. Write back set error bits to clear them

As this is a repeated pattern, add a helper to the PCI core.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v4:
- improve commit description
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
index 101d71e0a..7beaf51e9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1210,6 +1210,7 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 bool pci_device_is_present(struct pci_dev *pdev);
 void pci_ignore_hotplug(struct pci_dev *dev);
 struct pci_dev *pci_real_dma_dev(struct pci_dev *dev);
+int pci_status_get_and_clear_errors(struct pci_dev *pdev);
 
 int __printf(6, 7) pci_request_irq(struct pci_dev *dev, unsigned int nr,
 		irq_handler_t handler, irq_handler_t thread_fn, void *dev_id,
-- 
2.25.1


