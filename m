Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944043F8E57
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbhHZS7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243488AbhHZS7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 14:59:23 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4684FC0613CF;
        Thu, 26 Aug 2021 11:58:35 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g138so2405674wmg.4;
        Thu, 26 Aug 2021 11:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A+DG0W5+2eklf4TtXNvnExlRa/zaKSRLzk5O/0U5K0w=;
        b=NhIehY5x0I1crqrN8X/OvkFkmhiGAEGNPVzzb1TTCJsZpj/NCdbuz4dtjGwo7BFF0U
         01ogskY0N4lf5MraG/rPsWF6o81Iujt9KOiYkFTVFlgTnp9ifMUa1hA4/c88NxwLfmn/
         W2bW7L6xgV9ojPXzbLvHSXEXZU/pPJrAtQmpU41pYRauvIQWxmyzM1rYHqWNUKLnA6fp
         0oXHCMjL9bpWEujJ1R0fiv/ZI97YtJw5xPZ/gkLrL+HWmdJzJ7iLJWBSX7vxkbY/0cjP
         UPrmiktgPwz4/ZXRsje/jcCAs/NmXNMfYQ0O/9jZ53ASQZMcHSvq9i3ZjeznqdexJEkx
         2nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+DG0W5+2eklf4TtXNvnExlRa/zaKSRLzk5O/0U5K0w=;
        b=ntxjUS//jsX2GlJA6Y/T3yZfcTgxULDV6kcG2n13OzpiuBckcKV9NT1+AmntroV0Uo
         74w2vuZEesYXP8tCoPsZfYhn1Ae6aC8nLaJoY97J3MamrHbsZ1A4cr3IMEvtlNVW5ubh
         UF7yiFIoT1cOkHkU1pxcJVXnK2/6gEYVg92MJNj654nOK6y8KZLbFo8mnspdzkIwdoM0
         8YGX5pxiZ+ueodVTjKAMpELL8k9At4/sOwdgvlps336AVdUyUO4rWU9nND1KtXuPRnAd
         QYJ04DQ2VBisI2J6XoYc6hUi0Q8EZeiORE4m7doSOvqHNAlyxy2qTtKnfQf1vGzHHIdU
         VgVw==
X-Gm-Message-State: AOAM5338H4q/hMfsGR9YaxbIpBc4/v+ZOR1Oy1oGMbO1BYtHbztyzBhA
        2+e+IFg1kkJ5awtzbk1YqmVHoLx9Y3HeNQ==
X-Google-Smtp-Source: ABdhPJyzhanBtGemLIKksbfa5mBbVLTxY1yOPby8E/bgSyo4RyYV8xu0zGQ5ruG7kD9PVI7DLA6+Jw==
X-Received: by 2002:a7b:c927:: with SMTP id h7mr5124646wml.154.1630004313599;
        Thu, 26 Aug 2021 11:58:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2? (p200300ea8f084500b5d8a3dcf88fcae2.dip0.t-ipconnect.de. [2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2])
        by smtp.googlemail.com with ESMTPSA id b15sm4506476wru.1.2021.08.26.11.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 11:58:33 -0700 (PDT)
Subject: [PATCH 5/7] cxgb4: Use pci_vpd_find_id_string() to find VPD id string
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5fa6578d-1515-20d3-be5f-9e7dc7db4424@gmail.com>
Message-ID: <19ea2e9b-6e94-288a-6612-88db01b1b417@gmail.com>
Date:   Thu, 26 Aug 2021 20:56:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5fa6578d-1515-20d3-be5f-9e7dc7db4424@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_find_id_string() for finding the VPD
id string. This simplifies the code and avoids using VPD low-level
function pci_vpd_lrdt_size().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 5e8ac42ac..64144b617 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2744,7 +2744,7 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
 int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
 	unsigned int id_len, pn_len, sn_len, na_len;
-	int sn, pn, na, addr, ret = 0;
+	int id, sn, pn, na, addr, ret = 0;
 	u8 *vpd, base_val = 0;
 
 	vpd = vmalloc(VPD_LEN);
@@ -2764,13 +2764,10 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	if (ret < 0)
 		goto out;
 
-	if (vpd[0] != PCI_VPD_LRDT_ID_STRING) {
-		dev_err(adapter->pdev_dev, "missing VPD ID string\n");
-		ret = -EINVAL;
+	ret = pci_vpd_find_id_string(vpd, VPD_LEN, &id_len);
+	if (ret < 0)
 		goto out;
-	}
-
-	id_len = pci_vpd_lrdt_size(vpd);
+	id = ret;
 
 	ret = pci_vpd_check_csum(vpd, VPD_LEN);
 	if (ret) {
@@ -2796,7 +2793,7 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	na = ret;
 
-	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, min_t(int, id_len, ID_LEN));
+	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
 	strim(p->id);
 	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
 	strim(p->sn);
-- 
2.33.0


