Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB97E3F3FA4
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhHVOCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbhHVOCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:19 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694FC061764;
        Sun, 22 Aug 2021 07:01:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso12230231wmb.2;
        Sun, 22 Aug 2021 07:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cQmhOSk8nRoBGUH/oIz/pxzaMjxJu0UzyDUdrY2chFM=;
        b=WK/MKhhMqT8T774X8c4BN0sDzTxROtezMCDV/xOyIo+wWhxSg3uDO65pGvJ+sK4TRY
         51NII4XC6E0RYiccfjfQ/MmfPdBX0Q/7cY4Px7pb8XC2nANjc1u3fXldKxfgihkWgtZA
         SfbPWTtaEJfavHNt4C0Ejah8lUUAx+Yp1yek4DSeeApufd/KP0lZCBWtsYrPxKjFFTVh
         PFjoki0AVX05m41+SVB5XSJdl+Ol5MwT5Wwa1bVvh7PlpkpIuCcT/BdCsNIyLmDNEC5N
         BOpH4P4g4UeAcNaVdDUlyLT7H9JltfoQvU+qfKly2K1KvBVMkTLJU6a7hglOeC9COTeR
         QjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cQmhOSk8nRoBGUH/oIz/pxzaMjxJu0UzyDUdrY2chFM=;
        b=pdwXdNEF6LspdcS2LOqgXbKRg9LYOSkmYFLG5UYfleB8M7W7CY2ShE6TjfYR2qRVdr
         rKp2mU0MkQmsGl64t2QkNVuj8OdHOpX/0bX5i4RyvuTBSkyHRTX9qMe/nFgwjZymUj1R
         rwfEvsq3lFTx70vNZpM07eoz74oP6IcMr4h1K+LvFCFcFsOuCxixKP3YRiVoADHnDqyG
         Q88XQ4m0RWexpT6XvDKveqdiq4HvxFDlxEjnVSeP/pgXGEjA8wPWMfLw6DdpP79oJ31Y
         Y/6BLZ6Gj9nkgxBZYpsj90ga3r5N8Ow9HE/+GItW2jeDpeFvN5JZr3RjuA4HLp4IXgaH
         7kFQ==
X-Gm-Message-State: AOAM5312zBc8og0k3I5VUZj7URsSrR64ZTLbRJgq8Am65q3WzMH2NEJf
        Umd66by6bwpZ0D8CAL8FL96Q/UAC6Oj1OA==
X-Google-Smtp-Source: ABdhPJxGy90XgokmWtzC10wWOFMJvPk1J8eDfHV+g7fP9j5JWik/hdWaQXta1iKU+GwH+NODzmcB2w==
X-Received: by 2002:a05:600c:3b0e:: with SMTP id m14mr12410237wms.34.1629640890470;
        Sun, 22 Aug 2021 07:01:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id p9sm6866472wmq.40.2021.08.22.07.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:30 -0700 (PDT)
Subject: [PATCH 08/12] bnxt: Search VPD with pci_vpd_find_ro_info_keyword()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <f062921c-ad33-3b3e-8ada-b53427a9cd4a@gmail.com>
Date:   Sun, 22 Aug 2021 15:56:24 +0200
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

Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 38 ++++++-----------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 00a9b7126..5df00a520 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13174,8 +13174,8 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
 static void bnxt_vpd_read_info(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
-	int i, len, pos, ro_size, size;
-	unsigned int vpd_size;
+	unsigned int vpd_size, kw_len;
+	int pos, size;
 	u8 *vpd_data;
 
 	vpd_data = pci_vpd_alloc(pdev, &vpd_size);
@@ -13184,42 +13184,22 @@ static void bnxt_vpd_read_info(struct bnxt *bp)
 		return;
 	}
 
-	i = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
-	if (i < 0) {
-		netdev_err(bp->dev, "VPD READ-Only not found\n");
-		goto exit;
-	}
-
-	ro_size = pci_vpd_lrdt_size(&vpd_data[i]);
-	i += PCI_VPD_LRDT_TAG_SIZE;
-	if (i + ro_size > vpd_size)
-		goto exit;
-
-	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
-					PCI_VPD_RO_KEYWORD_PARTNO);
+	pos = pci_vpd_find_ro_info_keyword(vpd_data, vpd_size,
+					   PCI_VPD_RO_KEYWORD_PARTNO, &kw_len);
 	if (pos < 0)
 		goto read_sn;
 
-	len = pci_vpd_info_field_size(&vpd_data[pos]);
-	pos += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (len + pos > vpd_size)
-		goto read_sn;
-
-	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	size = min_t(int, kw_len, BNXT_VPD_FLD_LEN - 1);
 	memcpy(bp->board_partno, &vpd_data[pos], size);
 
 read_sn:
-	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
-					PCI_VPD_RO_KEYWORD_SERIALNO);
+	pos = pci_vpd_find_ro_info_keyword(vpd_data, vpd_size,
+					   PCI_VPD_RO_KEYWORD_SERIALNO,
+					   &kw_len);
 	if (pos < 0)
 		goto exit;
 
-	len = pci_vpd_info_field_size(&vpd_data[pos]);
-	pos += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (len + pos > vpd_size)
-		goto exit;
-
-	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	size = min_t(int, kw_len, BNXT_VPD_FLD_LEN - 1);
 	memcpy(bp->board_serialno, &vpd_data[pos], size);
 exit:
 	kfree(vpd_data);
-- 
2.33.0


