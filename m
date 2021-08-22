Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1B3F3F96
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhHVOCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhHVOCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744EC061575;
        Sun, 22 Aug 2021 07:01:24 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so9005694wmi.1;
        Sun, 22 Aug 2021 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qsOp9qT56v4HmRyiUQT77z85goMAUjXgZo93KXhkEYA=;
        b=IyLT4e7/dWmqfV0jybUvZnJERhpUoDwkkNjo6/RnkQe5nFKxdbrwRVdXUOIazugdGp
         Ko+LdQy66agMlJkBzUeA99s96wAncLcTsE+MJv39+b0oP9eCXUiVb+L36XJPKEX98yFW
         LHKpD64cXHtWDPfsYSGQAos8eojqUTemhvqH+dpYXwfwk59ypDHzdv1ukfpatkDVgzUc
         OvF5A46J9/KmT4rA2B+ko8VpungezGGPX5/Tw/q6smTLH5e45wWsjM9EbvFa79kp1Zqw
         POz6qyrL2JyAOAtdxry28ePOv9/i/yp4DMrligMBUEudO/ROXoScEkyYzDYubTznPbdR
         EZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qsOp9qT56v4HmRyiUQT77z85goMAUjXgZo93KXhkEYA=;
        b=TJ3H90PkffuK9dem8WLEN7TovftMg59UYujrGyxx702bZBJdEY7qOEJVGxq0ASRl+G
         GIVdo1jRhLT7WGqPpZ39h04ICKs5zVZQ96LhW1WvniN+iXBWNziTQrkB/aendpD0+4ff
         /BI2FXHP7nS5K33/OXAJmq8kjIulNB3T45nZLHhXT3azpAkhV6Bcky7a0bNc9c394DFs
         sAeSppcdcnW1MpXLvigw/EoTiwc0TqMz2nW+mqGKewilBXUiQAw0PsIrR1L8GgGu+qr7
         v1wGD3pbdbUbR955Pe8Ht/JB7ifikbTwIAOX6qMPgIcYPp82N/alirhRazQoldYM/+dC
         Rwew==
X-Gm-Message-State: AOAM530nyR7bbLd41jA9Y6fQwC8f9biJ7CX15erF/9jxkI/5osnyDnAH
        nO9d/O/nqJDptYnhRMXWfo58lDzZVpr/yA==
X-Google-Smtp-Source: ABdhPJzhl8aVEl4lGyc7HUcO/xSXSeD//dwoam8H5WTnKFFNg44w73jOrjRLo4qQmDcKz5yTFW/BzQ==
X-Received: by 2002:a05:600c:3792:: with SMTP id o18mr6174780wmr.27.1629640882523;
        Sun, 22 Aug 2021 07:01:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id d7sm12362542wrs.39.2021.08.22.07.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:22 -0700 (PDT)
Subject: [PATCH 02/12] sfc: falcon: Search VPD with
 pci_vpd_find_ro_info_keyword()
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
Message-ID: <898282a1-13bd-17bc-2e9a-d3dcd336b46c@gmail.com>
Date:   Sun, 22 Aug 2021 15:49:36 +0200
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

This is the same as 37838aa437c7 "sfc: Search VPD with
pci_vpd_find_ro_info_keyword()", just for the falcon chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sfc/falcon/efx.c | 65 ++++++---------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 5ab1e863d..423bdf812 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2785,9 +2785,9 @@ static void ef4_pci_remove(struct pci_dev *pci_dev)
 static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	int ro_start, ro_size, i, j;
-	unsigned int vpd_size;
+	unsigned int vpd_size, kw_len;
 	u8 *vpd_data;
+	int start;
 
 	vpd_data = pci_vpd_alloc(dev, &vpd_size);
 	if (IS_ERR(vpd_data)) {
@@ -2795,57 +2795,20 @@ static void ef4_probe_vpd_strings(struct ef4_nic *efx)
 		return;
 	}
 
-	/* Get the Read only section */
-	ro_start = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
-	if (ro_start < 0) {
-		netif_err(efx, drv, efx->net_dev, "VPD Read-only not found\n");
-		goto out;
-	}
-
-	ro_size = pci_vpd_lrdt_size(&vpd_data[ro_start]);
-	j = ro_size;
-	i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
-	if (i + j > vpd_size)
-		j = vpd_size - i;
-
-	/* Get the Part number */
-	i = pci_vpd_find_info_keyword(vpd_data, i, j, "PN");
-	if (i < 0) {
-		netif_err(efx, drv, efx->net_dev, "Part number not found\n");
-		goto out;
-	}
-
-	j = pci_vpd_info_field_size(&vpd_data[i]);
-	i += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (i + j > vpd_size) {
-		netif_err(efx, drv, efx->net_dev, "Incomplete part number\n");
-		goto out;
-	}
-
-	netif_info(efx, drv, efx->net_dev,
-		   "Part Number : %.*s\n", j, &vpd_data[i]);
-
-	i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
-	j = ro_size;
-	i = pci_vpd_find_info_keyword(vpd_data, i, j, "SN");
-	if (i < 0) {
-		netif_err(efx, drv, efx->net_dev, "Serial number not found\n");
-		goto out;
-	}
-
-	j = pci_vpd_info_field_size(&vpd_data[i]);
-	i += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (i + j > vpd_size) {
-		netif_err(efx, drv, efx->net_dev, "Incomplete serial number\n");
-		goto out;
-	}
+	start = pci_vpd_find_ro_info_keyword(vpd_data, vpd_size,
+					     PCI_VPD_RO_KEYWORD_PARTNO, &kw_len);
+	if (start < 0)
+		pci_warn(dev, "Part number not found or incomplete\n");
+	else
+		pci_info(dev, "Part Number : %.*s\n", kw_len, vpd_data + start);
 
-	efx->vpd_sn = kmalloc(j + 1, GFP_KERNEL);
-	if (!efx->vpd_sn)
-		goto out;
+	start = pci_vpd_find_ro_info_keyword(vpd_data, vpd_size,
+					     PCI_VPD_RO_KEYWORD_SERIALNO, &kw_len);
+	if (start < 0)
+		pci_warn(dev, "Serial number not found or incomplete\n");
+	else
+		efx->vpd_sn = kmemdup_nul(vpd_data + start, kw_len, GFP_KERNEL);
 
-	snprintf(efx->vpd_sn, j + 1, "%s", &vpd_data[i]);
-out:
 	kfree(vpd_data);
 }
 
-- 
2.33.0


