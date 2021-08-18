Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6263F0B75
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhHRTIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHRTHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:51 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED13C061764;
        Wed, 18 Aug 2021 12:07:15 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id j12-20020a05600c1c0c00b002e6d80c902dso2434743wms.4;
        Wed, 18 Aug 2021 12:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zGVsAIqhBW/AmYXXyLcUHMTNx7/cUwe/kNJ8uYF+hyA=;
        b=DA4wFZJS5eSLfAj1x7y+bgbSzYsUgF52jeBsnr8XxTkCOaADmb1rMM3Hi53OuOl7op
         /NvrK9Je00lo90ArycDzc7jEt9wVUwnbu3WbI6Cz8lfAG8gyFTpAeMPMYou+1zssavst
         NXAZjyOKgZ8pUKM05CLrtlLnISlyvWDc/IvfE7d1smEl6Qz/IQfUxMVXDpwgPUmwuMHm
         jywtjVWKgcuwVJfI93ROwC/8iem9OLP9gYNwVAFgoR5h2Fy28WZm+a0ZxFAHB2kb5T/I
         CA3u1m6PB9S3CXR1Wtyu+7H4Hg7IySsOylMNYoMn9etrpPU7wPXVEi8OM1u5Rrgv/ESR
         nh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zGVsAIqhBW/AmYXXyLcUHMTNx7/cUwe/kNJ8uYF+hyA=;
        b=kDo/5bM0mQUkx/1X9xIXOXefOF4eQKPQNipeOMf00CJ420GU+DUf+Mgk3FsSqoHJcA
         zlV02h8uaTaQGYsJ9ErHQoGtxwX1kcxJ6CoSuN1PhBsGS/3jf0XfX6XBrSJcuz5zqbuB
         WbQy/vfzhMxWviKrlT2uWAS4XpNLHpEgZVLsyS15h3LzWCJCS+Nej7cmG5DDKG0//aAL
         5N7nfCB0P3EEiVDKLvbDvcn5uGfR4TSOKZJtsL877WUenykKyF0tSYpYSZlB9AJWvY1y
         r5de6tqiLKflU17osZZIPx94mr/9P8FCyVyFR/kzGZK9+t4n0+hjQgC6jGS0gPaDopM0
         j36Q==
X-Gm-Message-State: AOAM530wfvJvE4NIiTqYxIpdQMGaOn+LJn3fpY9v45Kkw04SeYF0g9BV
        m2rlMvdeRKlCv0MjZJgV+W0GmdfruprPIg==
X-Google-Smtp-Source: ABdhPJwqj0Xpepf9nk1a7nfLAgF9q5Vzguo/sCttvAxUUrCkVPD1+3sPgQAEiWpOyagzGcnvfKRTrA==
X-Received: by 2002:a05:600c:22c2:: with SMTP id 2mr9862895wmg.3.1629313633523;
        Wed, 18 Aug 2021 12:07:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id p18sm679702wrt.13.2021.08.18.12.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:13 -0700 (PDT)
Subject: [PATCH 5/8] sfc: Use new VPD API function
 pci_vpd_find_ro_info_keyword
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <bf5d4ba9-61a9-2bfe-19ec-75472732d74d@gmail.com>
Date:   Wed, 18 Aug 2021 21:03:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_find_ro_info_keyword() to simplify
the code. In addition replace netif_err() with pci_err() because the
netdevice isn't registered yet what results in very ugly messages.
Use kmemdup_nul() instead of open-coding it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c | 65 ++++++++--------------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e04a63109..43ef4f529 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -905,9 +905,9 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 static void efx_probe_vpd_strings(struct efx_nic *efx)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	int ro_start, ro_size, i, j;
-	unsigned int vpd_size;
+	unsigned int vpd_size, kw_len;
 	u8 *vpd_data;
+	int start;
 
 	vpd_data = pci_vpd_alloc(dev, &vpd_size);
 	if (IS_ERR(vpd_data)) {
@@ -915,57 +915,20 @@ static void efx_probe_vpd_strings(struct efx_nic *efx)
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
+		pci_err(dev, "Part number not found or incomplete\n");
+	else
+		pci_info(dev, "Part Number : %.*s\n", kw_len, vpd_data + start);
 
-	efx->vpd_sn = kmalloc(j + 1, GFP_KERNEL);
-	if (!efx->vpd_sn)
-		goto out;
+	start = pci_vpd_find_ro_info_keyword(vpd_data, vpd_size,
+					     PCI_VPD_RO_KEYWORD_SERIALNO, &kw_len);
+	if (start < 0)
+		pci_err(dev, "Serial number not found or incomplete\n");
+	else
+		efx->vpd_sn = kmemdup_nul(vpd_data + start, kw_len, GFP_KERNEL);
 
-	snprintf(efx->vpd_sn, j + 1, "%s", &vpd_data[i]);
-out:
 	kfree(vpd_data);
 }
 
-- 
2.32.0


