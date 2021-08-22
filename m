Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C733F3F93
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhHVOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhHVOCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE21C061575;
        Sun, 22 Aug 2021 07:01:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d26so1625241wrc.0;
        Sun, 22 Aug 2021 07:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Euz0E6isscBYyFQ42pM4Z2EOYe57hCAo87czLinH3tQ=;
        b=Ku7NYMjn9nIwgb2ynMqcuTcWBtHsvWS2W57WhgpdY7Z4cL+aUN2DyL3RcNwP9ZKoLP
         ibLcGD0I/IRefzks/kJyucgsHGK9S2R7cFW3jiW2uU44uXOulsd76cmwk7CyF+rILsTN
         ONHjh3vcoQmrwMl9tJ4YoEZJt4qJr5/Hzv48lYjX8vhmIZojU1F0hkFTXV231HJmcaMj
         1CcH28LUJdpqvOxvC/ZhkJVj+au958joOU4vUS0PFAhPiPaLGxaQYyrgoe+tbKmT0GUA
         9eB1RnZEjXfBmnzh9cLfkGM+TyEf06yczr9N3SSq4R7GEazFqS5fCc/lEtlcoasH7Uyf
         vRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Euz0E6isscBYyFQ42pM4Z2EOYe57hCAo87czLinH3tQ=;
        b=lf4nr76hQ6ufSzwBAPDdUJI/j9SZOtdBBcLGKcOJl0IpPC+cW2MK6ILctwprpZnaSy
         aRP1Aa2WQt1U20UvqIRxd3tRkifnt554FzkD+LczqmZJTmXVWcWyus3f2sOpte54fh23
         j8a5eSYpHZ5OLald1S2w9NQc30jiR2HiheC5MMlTpt4ALKK2ACS65baNgJZ4wFXhnIf9
         5kn+XeOkeNVQf0QSAmNxbFdfQSM03bRzb5Lou2pa2CxuM+YlV6tCkPUZhwFftck5pM0R
         dGqth4s+qsM/UNnzAzOQaIb73VQPCWcH0mMhctkcS7di+dp2jVlPrOT9pNAVM2Ppy1So
         v0pA==
X-Gm-Message-State: AOAM533rwLq3wcuLiNVU9ejFnCvoR4Y4clInvTFN8NgGdbhd3txgme7C
        92gWX8UzM9f9CrFsqFdFsbCvNBseJyBTEw==
X-Google-Smtp-Source: ABdhPJxsxqZLYUrdIsPO90PZWWoJEriPEnNBkC+1jahdkQlcQTd45SQhdMkwHyALbQl9HWEmfTsHlA==
X-Received: by 2002:a5d:6381:: with SMTP id p1mr9133141wru.310.1629640881263;
        Sun, 22 Aug 2021 07:01:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id w14sm11818452wrt.23.2021.08.22.07.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:20 -0700 (PDT)
Subject: [PATCH 01/12] sfc: falcon: Read VPD with pci_vpd_alloc()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <2a8d069e-9516-50d8-6520-2614222c8f5f@gmail.com>
Date:   Sun, 22 Aug 2021 15:48:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the same as 5119e20facfa "sfc: Read VPD with pci_vpd_alloc()",
just for the falcon chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sfc/falcon/efx.c | 30 +++++++++++++--------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index c177ea0f3..5ab1e863d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2780,22 +2780,18 @@ static void ef4_pci_remove(struct pci_dev *pci_dev)
 };
 
 /* NIC VPD information
- * Called during probe to display the part number of the
- * installed NIC.  VPD is potentially very large but this should
- * always appear within the first 512 bytes.
+ * Called during probe to display the part number of the installed NIC.
  */
-#define SFC_VPD_LEN 512
 static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	char vpd_data[SFC_VPD_LEN];
-	ssize_t vpd_size;
 	int ro_start, ro_size, i, j;
+	unsigned int vpd_size;
+	u8 *vpd_data;
 
-	/* Get the vpd data from the device */
-	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
-	if (vpd_size <= 0) {
-		netif_err(efx, drv, efx->net_dev, "Unable to read VPD\n");
+	vpd_data = pci_vpd_alloc(dev, &vpd_size);
+	if (IS_ERR(vpd_data)) {
+		pci_warn(dev, "Unable to read VPD\n");
 		return;
 	}
 
@@ -2803,7 +2799,7 @@ static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
 	if (ro_start < 0) {
 		netif_err(efx, drv, efx->net_dev, "VPD Read-only not found\n");
-		return;
+		goto out;
 	}
 
 	ro_size = pci_vpd_lrdt_size(&vpd_data[ro_start]);
@@ -2816,14 +2812,14 @@ static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 	i = pci_vpd_find_info_keyword(vpd_data, i, j, "PN");
 	if (i < 0) {
 		netif_err(efx, drv, efx->net_dev, "Part number not found\n");
-		return;
+		goto out;
 	}
 
 	j = pci_vpd_info_field_size(&vpd_data[i]);
 	i += PCI_VPD_INFO_FLD_HDR_SIZE;
 	if (i + j > vpd_size) {
 		netif_err(efx, drv, efx->net_dev, "Incomplete part number\n");
-		return;
+		goto out;
 	}
 
 	netif_info(efx, drv, efx->net_dev,
@@ -2834,21 +2830,23 @@ static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 	i = pci_vpd_find_info_keyword(vpd_data, i, j, "SN");
 	if (i < 0) {
 		netif_err(efx, drv, efx->net_dev, "Serial number not found\n");
-		return;
+		goto out;
 	}
 
 	j = pci_vpd_info_field_size(&vpd_data[i]);
 	i += PCI_VPD_INFO_FLD_HDR_SIZE;
 	if (i + j > vpd_size) {
 		netif_err(efx, drv, efx->net_dev, "Incomplete serial number\n");
-		return;
+		goto out;
 	}
 
 	efx->vpd_sn = kmalloc(j + 1, GFP_KERNEL);
 	if (!efx->vpd_sn)
-		return;
+		goto out;
 
 	snprintf(efx->vpd_sn, j + 1, "%s", &vpd_data[i]);
+out:
+	kfree(vpd_data);
 }
 
 
-- 
2.33.0


