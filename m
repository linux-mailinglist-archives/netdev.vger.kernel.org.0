Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EBA3F3FA1
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhHVOCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhHVOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B545DC061756;
        Sun, 22 Aug 2021 07:01:28 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f5so21903561wrm.13;
        Sun, 22 Aug 2021 07:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GhA3sTWdBctF9+XF0H4+34NcfxyTAeGY2X6mJWKS4kY=;
        b=jUSmWVAgEhYpz3iJ8axdw43hDeqRJNMl4rEKQZvKg5+Bboh6POi4+InERI2zRp6l3z
         n2G3sa9bMdqe80YpnG/kXZT5JWddHQ709TsNXRvQnUNdDjBO8AKYPhO2dMPLZvfgSpZ0
         VQHEtiUf5GxNr8DeKTp5fwZT2CxOq/BW19ou92xP0PzfKO05bxxpRzPLV1iFR7mEr6vN
         UXf8wYVOSnwBtSxFwCAe9WESlSDL5bw96BpHNLrfJ27lWx8AqfaCJohiTFtBV3JlqK5t
         HCOfc3I6ZnV6fnDhJkuyuQ0NqGAYcklcGcwI61sQSdYPdpsuk5Oaga6k7L+yZ2myWdxa
         C7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GhA3sTWdBctF9+XF0H4+34NcfxyTAeGY2X6mJWKS4kY=;
        b=JApJ9cAbEKVUwQeDyMXzq+oN8zOiXH2gloa6emz08BRf4GJrlI+/kQruNGQyYrI610
         /9P2y4zFyivLg7QNSQBehDRbpB0FIqSSvNVUpUBXv9LSfsrDv2HS4o7g/84X8UaepKXs
         9KmbPNW35Ufx7rifEl+raMiXMrdXMcxH590jwpQeWwK8tR32X3891oAhmKU4cq23WjtZ
         Jjv/nySGxByBd/OmbcX/jmQbPDYsIOs5RcaIoY4wSl1oDnFN+yIJjQYuFGVWPle5+Jhm
         SwQhW81d9jYgLA7JocvuGvh9gETQpabrk29py2cwVbkE3rqUQ9ydtdIYNwZJR2fD9O80
         6xyw==
X-Gm-Message-State: AOAM531GEe6OHrJLtHfgK8Q/pDeTQPQ/Ei8Kly+kOllbFPsvy32XzSXQ
        u1h32F/Q05k2s5R+chjbnQiTMZVXYcHxCw==
X-Google-Smtp-Source: ABdhPJwzuftrtv/gnZaUzK2aqhteQyQFR1+wjAg5sHZjY1P7MCE0R4DE9WA3WGNlin0S0t47MhG5Zw==
X-Received: by 2002:adf:fd51:: with SMTP id h17mr6569599wrs.178.1629640887149;
        Sun, 22 Aug 2021 07:01:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id y15sm1680262wmi.18.2021.08.22.07.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:26 -0700 (PDT)
Subject: [PATCH 06/12] bnx2x: Search VPD with pci_vpd_find_ro_info_keyword()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <a9f730cf-e31e-902b-7b39-0ff2e99636e0@gmail.com>
Date:   Sun, 22 Aug 2021 15:54:23 +0200
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

str_id_reg and str_id_cap hold the same string and are used in the same
comparison. This doesn't make sense, use one string str_id instead.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 57 +++++--------------
 1 file changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 0466adf8d..2c7bfc416 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12189,11 +12189,10 @@ static int bnx2x_get_hwinfo(struct bnx2x *bp)
 
 static void bnx2x_read_fwinfo(struct bnx2x *bp)
 {
-	int i, block_end, rodi;
-	char str_id_reg[VENDOR_ID_LEN+1];
-	char str_id_cap[VENDOR_ID_LEN+1];
-	unsigned int vpd_len;
-	u8 *vpd_data, len;
+	char str_id[VENDOR_ID_LEN + 1];
+	unsigned int vpd_len, kw_len;
+	u8 *vpd_data;
+	int rodi;
 
 	memset(bp->fw_ver, 0, sizeof(bp->fw_ver));
 
@@ -12201,46 +12200,20 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
 	if (IS_ERR(vpd_data))
 		return;
 
-	/* VPD RO tag should be first tag after identifier string, hence
-	 * we should be able to find it in first BNX2X_VPD_LEN chars
-	 */
-	i = pci_vpd_find_tag(vpd_data, vpd_len, PCI_VPD_LRDT_RO_DATA);
-	if (i < 0)
-		goto out_not_found;
-
-	block_end = i + PCI_VPD_LRDT_TAG_SIZE +
-		    pci_vpd_lrdt_size(&vpd_data[i]);
-	i += PCI_VPD_LRDT_TAG_SIZE;
-
-	rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
-				   PCI_VPD_RO_KEYWORD_MFR_ID);
-	if (rodi < 0)
-		goto out_not_found;
-
-	len = pci_vpd_info_field_size(&vpd_data[rodi]);
-
-	if (len != VENDOR_ID_LEN)
+	rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
+					    PCI_VPD_RO_KEYWORD_MFR_ID, &kw_len);
+	if (rodi < 0 || kw_len != VENDOR_ID_LEN)
 		goto out_not_found;
 
-	rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
-
 	/* vendor specific info */
-	snprintf(str_id_reg, VENDOR_ID_LEN + 1, "%04x", PCI_VENDOR_ID_DELL);
-	snprintf(str_id_cap, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
-	if (!strncmp(str_id_reg, &vpd_data[rodi], VENDOR_ID_LEN) ||
-	    !strncmp(str_id_cap, &vpd_data[rodi], VENDOR_ID_LEN)) {
-
-		rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
-						PCI_VPD_RO_KEYWORD_VENDOR0);
-		if (rodi >= 0) {
-			len = pci_vpd_info_field_size(&vpd_data[rodi]);
-
-			rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
-
-			if (len < 32 && (len + rodi) <= vpd_len) {
-				memcpy(bp->fw_ver, &vpd_data[rodi], len);
-				bp->fw_ver[len] = ' ';
-			}
+	snprintf(str_id, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
+	if (!strncmp(str_id, &vpd_data[rodi], VENDOR_ID_LEN)) {
+		rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
+						    PCI_VPD_RO_KEYWORD_VENDOR0,
+						    &kw_len);
+		if (rodi >= 0 && kw_len < sizeof(bp->fw_ver)) {
+			memcpy(bp->fw_ver, &vpd_data[rodi], kw_len);
+			bp->fw_ver[kw_len] = ' ';
 		}
 	}
 out_not_found:
-- 
2.33.0


