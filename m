Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23373F3FA7
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhHVOCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbhHVOCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:20 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742BC06179A;
        Sun, 22 Aug 2021 07:01:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k8so21969759wrn.3;
        Sun, 22 Aug 2021 07:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+0IRWd8qcrzfdJzo7TwSuHReOvCmzpH73e603jr2UKA=;
        b=o9JlqtELaYOjXCpljBT1K3bmAVNymZVHCWbDooNz6memSBOiIoQ6UWTABTZopD1N93
         uyRiUfzuWS/IFL7WX5c96ofw4/CjGk+CJCAxv5SJwV0PIlfjEIto6yeZ7Ble9FI+z4sQ
         txmLG1CnA45RRDnA5oCdM0yc7gCGO/lrsmtbab2pkjCGM+7hQEr23qmQXnAKUGd2uYu0
         iZBUp/SFXIKDkEdCsB71l+s7bhfo0Ox/y0OgNo1ZICcYa6LMu26VCgvHAERkGHc8H+8M
         f6ekeMUKWcglFy0Q/OvQYHPY7oseAs5oyxKA2xR+0EEq9VIangleJlTxSndQf82gwL79
         LL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+0IRWd8qcrzfdJzo7TwSuHReOvCmzpH73e603jr2UKA=;
        b=KK2o+RQua42WjtNb39tGi764K/JX0EAMpzNTfgQdhioD0EnRGeot+gxSkyqzfx2jbu
         8gvQIz/oX/Cv7wlxUNn7etDC7Tpf8Opb6e1Zn0XdIfvePw/IsuyQRbw8tAl41R/zl1Yh
         JE4EKaeu15LKas54VYC3jGiAHPC5rV33EyA9Dgiug47giIlTU3MTdFW+xzSSiJy/UHiI
         +NLAgW2mwUl1g7PtOMTsFnAcRYXMlbQum0XOmVkQV5vqYF1ZdJEGvtoo9h1a8H7d1TCN
         GnaQWBQGrarwUiYO+8DsdkQbgduRdbuLbyfGf9mi4iuTkT0JiQMYgHtF1nnhSsaidLp8
         U2gQ==
X-Gm-Message-State: AOAM530KUe+dOv2Lx40bGSWUcX+VxsuEy1h8wcXWB1bz+ziV7BtONxXS
        DKMXCJdNsWCa/5HRydhrVe/p7Cq3M9aZEQ==
X-Google-Smtp-Source: ABdhPJzV5ChAJYQXNRquCR77YhSexY9jbvNSKwV6FOGcUWNFikup6PwrClRu3OG7q2v0TL70LSlodA==
X-Received: by 2002:a5d:4643:: with SMTP id j3mr1864491wrs.138.1629640891525;
        Sun, 22 Aug 2021 07:01:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id y4sm6638981wmi.22.2021.08.22.07.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:31 -0700 (PDT)
Subject: [PATCH 09/12] cxgb4: Validate VPD checksum with pci_vpd_check_csum()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <70404ece-0036-c0ce-f824-f5637e54115e@gmail.com>
Date:   Sun, 22 Aug 2021 15:57:27 +0200
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

Validate the VPD checksum with pci_vpd_check_csum() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 6606fb8b3..1ae3ee994 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2745,7 +2745,7 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
 	int i, ret = 0, addr;
 	int ec, sn, pn, na;
-	u8 *vpd, csum, base_val = 0;
+	u8 *vpd, base_val = 0;
 	unsigned int vpdr_len, kw_offset, id_len;
 
 	vpd = vmalloc(VPD_LEN);
@@ -2800,13 +2800,9 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	var += PCI_VPD_INFO_FLD_HDR_SIZE; \
 } while (0)
 
-	FIND_VPD_KW(i, "RV");
-	for (csum = 0; i >= 0; i--)
-		csum += vpd[i];
-
-	if (csum) {
-		dev_err(adapter->pdev_dev,
-			"corrupted VPD EEPROM, actual csum %u\n", csum);
+	ret = pci_vpd_check_csum(vpd, VPD_LEN);
+	if (ret) {
+		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.33.0


