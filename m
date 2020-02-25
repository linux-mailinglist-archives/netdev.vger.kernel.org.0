Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2520D16BA4E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgBYHPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33926 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgBYHP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id i10so423695wmd.1;
        Mon, 24 Feb 2020 23:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=Od3dKqOGyx7CGpgEcg/z3RM+fgBWwQldQC3dH+rvheNeTH11sjtzFehN8afnYpGCAX
         n2POegXkGf0snflpaPXg73M65UbZhsQSKw/mflO7XPjHzwVHv2Wtn9Gdo4dm4Hl4R4Dt
         BPORNFHqj/dEnzvMns694quL3w5KqiKY/6UpXWwllN2YXmvb/EOcur0AS+03u8115EGl
         9g1NxXdYfFcFn0Y/sNzzTAlyHGk44WGvH8AEqrhRbG8uLqv0Ne/UnRyTaLZ3mxEnw+Fv
         beePnc9l87xyQaeoPVzaUQTL5Yu4RbrmPGTIDYsVcl/LZOYvXaI+dO5gfbAUui/csV5V
         hTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cq/SO7uTxQFQRkUdTESCHn0ibY8lprisVUmHlf5Q8N8=;
        b=jalXFBLJ7EzGSIXTz1y5DdSDaKsLXFMDRQp1FmtNaxs3OMg76CaaNcXEbQLBpOmw0V
         9K7IYfdxSWnEd2725lK6DfDWNbuaXp7t0MDpVdnDdAwitmOysWVkmn7JourTRzM51vim
         K3qBh2kPmjrxxSNFvg96nqbZfl8P7i3EtjIS1FCnCsy/IssioskOc6T5+fpMX5w18k9c
         ugm4PbOrlyq6qB9vl+UqaoZ0XwCJdHM84INhvg7gMpLfelvWFkL9ha0hwJBarxarquIH
         xEYJGgJcoKQpmC5gpBZCb3pHWPr3OhBRCa4ov2OS8XZi+mR0IdXTKBJcipSZ3+aeS3tk
         s5tw==
X-Gm-Message-State: APjAAAWrvDlHxWVMwOM/TvyZmWKyAxabEKYrOmHXGuIga1QVW/o+6jIC
        7hmRUYJIgXyfPIkZ044E4NA=
X-Google-Smtp-Source: APXvYqyXRXFGsE4pulqQxZGWYfvwyZaZ74LkQrElUPtbkrAA1aabhzS+tFzlW7s7nOhPtaJ6NMBf5w==
X-Received: by 2002:a1c:b603:: with SMTP id g3mr3740024wmf.133.1582614927275;
        Mon, 24 Feb 2020 23:15:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id o2sm2853477wmh.46.2020.02.24.23.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:26 -0800 (PST)
Subject: [PATCH v2 2/8] PCI: add pci_status_get_and_clear_errors
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
References: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Message-ID: <6fee9e06-5926-a920-ee28-44e47a8f685f@gmail.com>
Date:   Tue, 25 Feb 2020 08:09:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
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



