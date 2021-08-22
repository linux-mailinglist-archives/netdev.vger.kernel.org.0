Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EA93F3F99
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhHVOCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHVOCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:06 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7BFC061575;
        Sun, 22 Aug 2021 07:01:25 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x12so21920138wrr.11;
        Sun, 22 Aug 2021 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CpBIYdrsUs68KAyEiAlWKUwUStL3DPn+RhHbfb4DLQg=;
        b=fA2gLRGoLtDgyz1NUzccwk5dA4tCnsI12ztmJcxdy+Fm8mBQM3oN5kDbeyyfaNyLDx
         lR6k7NuSmFzaIjj1MLYA+7NxpAIx2XoCik5m7D9NnRagMtnssMnfhlpD0TGWwVagMFga
         IBbz0tuc+3yLW5jOxra7gheaG6bkWfbGberxwzSDcGyIkMFnk1XbTC7FPn1i4pgftjVF
         1JlvH0BMVcHhocrfWEf3icfXY8J7mXCnLsWMTfdlceLn3udla/09Xw3rffQsIQxhKDin
         1ut9JqGiw4DzJl/bxlxTNDh20dFGCM9lTzKYwlT1q9YPREM8y1yiW8/5umok9PT6EiGe
         sq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CpBIYdrsUs68KAyEiAlWKUwUStL3DPn+RhHbfb4DLQg=;
        b=uGhgnbFr4n7ffWxmcomyNHKxCYUoWTsM8Lwu4LcDVwh6axXS+lAJhOUIKJxT+wJerT
         jczvxDfvt5wfLXhAuEMbMHord0udpGzCeP0cIcfNpdlSUI3j9Wx/94/7omkbgghU9rAE
         M0J9g6NEl2ZiX/FTq9EHS4cXxXhTFaQvayJQ/DDBM7fNGk8/Up2RPXYnIkrchv32QTv4
         YyqySgN/GTGJ0kUlGuao0tuDZRldf2Jd2ZCdjyavYgc6sR46HXYO/5ngRiJdZsnSFss4
         W1X9O0p7NfH4g64DL8RHYTMONQnyDOgcjtDeKFUnaVB9uEHfVlfLPm19mKR4/jH1DNEq
         i/aw==
X-Gm-Message-State: AOAM533nWzeOMKlZ1VRzQmH66BTv2BG+3noDzIHAx7SgszFtLkTcB6ws
        kmxUajcBww6aLoZT+1HGG5EcIA5LrG/sHg==
X-Google-Smtp-Source: ABdhPJyay3Lq6dztsuisnUsCmirevaSytLHSZh6xzltwhCab4KrKj6kBMHi4GfP0a/Fqrsqjuv65+g==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr8852259wrv.370.1629640883695;
        Sun, 22 Aug 2021 07:01:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id m16sm641870wmq.8.2021.08.22.07.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:23 -0700 (PDT)
Subject: [PATCH 03/12] bnx2: Search VPD with pci_vpd_find_ro_info_keyword()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <7ca2b8b5-4c94-f644-1d80-b2ffb8df2d05@gmail.com>
Date:   Sun, 22 Aug 2021 15:50:50 +0200
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
 drivers/net/ethernet/broadcom/bnx2.c | 33 +++++++---------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 89ee1c0e9..de1a60a95 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8033,9 +8033,9 @@ bnx2_get_pci_speed(struct bnx2 *bp)
 static void
 bnx2_read_vpd_fw_ver(struct bnx2 *bp)
 {
+	unsigned int len;
 	int rc, i, j;
 	u8 *data;
-	unsigned int block_end, rosize, len;
 
 #define BNX2_VPD_NVRAM_OFFSET	0x300
 #define BNX2_VPD_LEN		128
@@ -8057,38 +8057,21 @@ bnx2_read_vpd_fw_ver(struct bnx2 *bp)
 		data[i + 3] = data[i + BNX2_VPD_LEN];
 	}
 
-	i = pci_vpd_find_tag(data, BNX2_VPD_LEN, PCI_VPD_LRDT_RO_DATA);
-	if (i < 0)
-		goto vpd_done;
-
-	rosize = pci_vpd_lrdt_size(&data[i]);
-	i += PCI_VPD_LRDT_TAG_SIZE;
-	block_end = i + rosize;
-
-	if (block_end > BNX2_VPD_LEN)
-		goto vpd_done;
-
-	j = pci_vpd_find_info_keyword(data, i, rosize,
-				      PCI_VPD_RO_KEYWORD_MFR_ID);
+	j = pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
+					 PCI_VPD_RO_KEYWORD_MFR_ID, &len);
 	if (j < 0)
 		goto vpd_done;
 
-	len = pci_vpd_info_field_size(&data[j]);
-
-	j += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (j + len > block_end || len != 4 ||
-	    memcmp(&data[j], "1028", 4))
+	if (len != 4 || memcmp(&data[j], "1028", 4))
 		goto vpd_done;
 
-	j = pci_vpd_find_info_keyword(data, i, rosize,
-				      PCI_VPD_RO_KEYWORD_VENDOR0);
+	j = pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
+					 PCI_VPD_RO_KEYWORD_VENDOR0,
+					 &len);
 	if (j < 0)
 		goto vpd_done;
 
-	len = pci_vpd_info_field_size(&data[j]);
-
-	j += PCI_VPD_INFO_FLD_HDR_SIZE;
-	if (j + len > block_end || len > BNX2_MAX_VER_SLEN)
+	if (len > BNX2_MAX_VER_SLEN)
 		goto vpd_done;
 
 	memcpy(bp->fw_version, &data[j], len);
-- 
2.33.0


