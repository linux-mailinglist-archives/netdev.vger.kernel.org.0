Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D0D3F0B6E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhHRTHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHRTHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E6CC061764;
        Wed, 18 Aug 2021 12:07:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j12-20020a05600c1c0c00b002e6d80c902dso2434438wms.4;
        Wed, 18 Aug 2021 12:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BbhCVONKCGt83p5epp5UNjY/vD+Rp31aBgSbhnRKOjs=;
        b=Z+KZ96YeqtnTNkx2sTg1e0YxjG8IhBMyrmDm9AkyhzvVsbeXXFdOBPdz+G0iYLDOlN
         QtlUWa9VPPZzmAgZ1B+jVG5OfOtjyH1qIKUEb4AJ/9qdsQrau/yKZNHkmSjcClI08RUO
         lPNZLi51pTas3jFtJBZAKxVvu97YgzjhkSIYV0q5t9pm/v6/9TEql3zITS9Oe5ijDlig
         Eps5assQdyyj/pqUMs7nsuWq1ALmwpQCM7bgHlUr9oq6CYg31J1DzlM30mQogAGk+hyg
         ctVj/+hIRhDHx5Io6IQ5h8q8UnkwPmM1TcQlJsegR6j7V0Pf0JzPJq1hmzN9Ls5hpEiT
         A1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BbhCVONKCGt83p5epp5UNjY/vD+Rp31aBgSbhnRKOjs=;
        b=WJvkokRZWW2DsC1BOsYXmK2z45S/9DJrfdRvGT3JfMjgr4u2CW52fEo3Eq+pPLduB9
         1PS8pZzGf4bEv1isgTNpJ+LRRJ5Qc4BjbnoBEi5XYiBNFhM1kLv90qbv489oMLUUsr7W
         krGh7hAjtsVBVX9XrsiOXYNezaThlJkqPpSImvoZnL7fJOGHL/G3N79icmd/k5XNrs2Y
         gcPaJVgwyKh20CUs9gzaQ8nXqEkE9JsAW0ReaczyTbqMb4Q3Y7Ej71Psj18B90QKAYZ3
         OFqeGTg0s0iqI2ppgj40fqzqzeqon1xVQQOeKrJDN/j9d9dpzPSLowhtSce1dUk28ci1
         QiDw==
X-Gm-Message-State: AOAM531eX/ZUw1L6i7qLnYy24zHlYxG7JNECDnyse22w+WFKsbHbfIfc
        sGFgM1qRnUbnanaCsAhXbmB+Kit2kNBwkg==
X-Google-Smtp-Source: ABdhPJzGnfHTuVuFIvk0GGTqkcaILlxTxEX/EOBviyfYbdNl6VOL9nErWQjL2Oxn/FGDAnYXaRsBPQ==
X-Received: by 2002:a1c:7506:: with SMTP id o6mr10252795wmc.112.1629313623221;
        Wed, 18 Aug 2021 12:07:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id l2sm662914wrx.2.2021.08.18.12.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:02 -0700 (PDT)
Subject: [PATCH 2/8] PCI/VPD: Add pci_vpd_find_ro_info_keyword and
 pci_vpd_check_csum
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <1643bd7a-088e-1028-c9b0-9d112cf48d63@gmail.com>
Date:   Wed, 18 Aug 2021 21:00:57 +0200
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

All Users of pci_vpd_find_info_keyword() are interested in the VPD RO
section only. In addition all calls are followed by the same
activities to calculate start of tag data area and size of the data
area. Therefore add an API function that combines these
functionalities. pci_vpd_find_info_keyword() can be phased out once
all users are converted.

VPD checksum information and checksum calculation are part of the PCI
standard. Therefore checksum handling can and should be moved into
PCI VPD core. Add an API function pci_vpd_check_csum() for that.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h | 21 +++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 7c3a09737..01e575947 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -380,6 +380,62 @@ ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void
 }
 EXPORT_SYMBOL(pci_write_vpd);
 
+int pci_vpd_find_ro_info_keyword(const void *buf, unsigned int len,
+				 const char *kw, unsigned int *size)
+{
+	int ro_start, infokw_start;
+	unsigned int ro_len, infokw_size;
+
+	ro_start = pci_vpd_find_tag(buf, len, PCI_VPD_LRDT_RO_DATA);
+	if (ro_start < 0)
+		return ro_start;
+
+	ro_len = pci_vpd_lrdt_size(buf + ro_start);
+	ro_start += PCI_VPD_LRDT_TAG_SIZE;
+
+	if (ro_start + ro_len > len)
+		ro_len = len - ro_start;
+
+	infokw_start = pci_vpd_find_info_keyword(buf, ro_start, ro_len, kw);
+	if (infokw_start < 0)
+		return infokw_start;
+
+	infokw_size = pci_vpd_info_field_size(buf + infokw_start);
+	infokw_start += PCI_VPD_INFO_FLD_HDR_SIZE;
+
+	if (infokw_start + infokw_size > len)
+		return -EINVAL;
+
+	if (size)
+		*size = infokw_size;
+
+	return infokw_start;
+}
+EXPORT_SYMBOL_GPL(pci_vpd_find_ro_info_keyword);
+
+int pci_vpd_check_csum(const void *buf, unsigned int len)
+{
+	const u8 *vpd = buf;
+	unsigned int size;
+	u8 csum = 0;
+	int rv_start;
+
+	rv_start = pci_vpd_find_ro_info_keyword(buf, len, PCI_VPD_RO_KEYWORD_CHKSUM, &size);
+	if (rv_start == -ENOENT) /* no checksum in VPD */
+		return 1;
+	else if (rv_start < 0)
+		return rv_start;
+
+	if (!size)
+		return -EINVAL;
+
+	while (rv_start >= 0)
+		csum += vpd[rv_start--];
+
+	return csum ? -EILSEQ : 0;
+}
+EXPORT_SYMBOL_GPL(pci_vpd_check_csum);
+
 #ifdef CONFIG_PCI_QUIRKS
 /*
  * Quirk non-zero PCI functions to route VPD access through function 0 for
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3061cc943..a82f5910f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2363,6 +2363,27 @@ int pci_vpd_find_tag(const u8 *buf, unsigned int len, u8 rdt);
 int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 			      unsigned int len, const char *kw);
 
+/**
+ * pci_vpd_check_csum - Check VPD checksum
+ * @buf: Pointer to buffered vpd data
+ * @len: VPD size
+ *
+ * Returns 1 if VPD has no checksum, otherwise 0 or an errno
+ */
+int pci_vpd_check_csum(const void *buf, unsigned int len);
+
+/**
+ * pci_vpd_find_ro_info_keyword - Locates an info field keyword in VPD RO section
+ * @buf: Pointer to buffered vpd data
+ * @len: The length of the buffer area in which to search
+ * @kw: The keyword to search for
+ * @size: pointer to field where length of found keyword data is returned
+ *
+ * Returns the index of the information field keyword data or -ENOENT if not found.
+ */
+int pci_vpd_find_ro_info_keyword(const void *buf, unsigned int len,
+				 const char *kw, unsigned int *size);
+
 /* PCI <-> OF binding helpers */
 #ifdef CONFIG_OF
 struct device_node;
-- 
2.32.0


