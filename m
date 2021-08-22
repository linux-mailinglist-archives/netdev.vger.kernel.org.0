Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AA43F3FAD
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhHVOCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhHVOCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:20 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A92C0617AE;
        Sun, 22 Aug 2021 07:01:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f5so21904039wrm.13;
        Sun, 22 Aug 2021 07:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IPujwYC6E9l7jqY2RWqen9mgADujdWEnooR3WaHxdYM=;
        b=XFcTU7lkZFZ7hC4iTBXDTcHN55VjjNH6RXOTDZkKc0YnZc/6jT31WBHS6tmdfcrj5M
         kMM2+OOtNmzrzyN89i530GbMMw20IC3bZr992+nEvn+KZpnJRJc7g0XcLYPKutrOkx3Q
         5Ovr0pwYzdGVAueDJqzIbFDskOII2+fegMIkd7usoBudkWR1D18UDmfI4WgtoYRveg1T
         EmxhAnJdQwkzhmAg0pDeGctKYwXEwbkNfL4R8Br+RWe/JlHsrRvzLhc4esdysyI399n4
         Bw509HxI+TTLM20zIx9YqDKrEJBSW3JKEhtCEgtJYyv5QfFIrCVJke+KfM+itFkIM8V4
         WiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IPujwYC6E9l7jqY2RWqen9mgADujdWEnooR3WaHxdYM=;
        b=WoPHLqQOnLIIV8VTXd/aoKWl8Iw+2swvpYH1giMzT8olrXxQzeZfGkjYXBXQ7/eRau
         Qy3RnP64x8aKYVSbwnfPe3fQx2pZBt7SoEE4LO9HWVP9K9hxQ6CctOdzhMIzW70H8M17
         K0lE75nMvRuDxiWkkSF3GVxBADzQx8qEgLA+V4CJqCKNl29sYMYjO0wHcDbRac5hAZmE
         XsETwjmos7CJkPe3xSKPueQiy2Oc5EQVbbe958s3gS8svizLHdGgwlanbey4NHLC+fL1
         UwRxrb6pcesVeFlr7XSd2TX0JJgjhudbADIazJ+GWnREoUm9TtwI4lnYdwjdfr+mciOW
         FGEA==
X-Gm-Message-State: AOAM532ONk112tuK2i+PXYZocnMi4vW+0qDCiTDchDYhDL+axQ4OnAmp
        BQGnXCVjYCC0gR6Fte2/5NnGT10Iv6g+Iw==
X-Google-Smtp-Source: ABdhPJw1WUokU8P1rcYCEmDesECHWY5gmLrlPx40jjL8iTSNLxSN1cQkQhTsu5pBrfWwtH+7dgAYpw==
X-Received: by 2002:a5d:690b:: with SMTP id t11mr6974024wru.182.1629640893822;
        Sun, 22 Aug 2021 07:01:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id m21sm9894283wms.3.2021.08.22.07.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:33 -0700 (PDT)
Subject: [PATCH 11/12] cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <db576a3e-e877-b37b-98ed-cfc03d225ab3@gmail.com>
Date:   Sun, 22 Aug 2021 15:59:21 +0200
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
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 67 +++++++++-------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 2aeb2f80f..5e8ac42ac 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2743,10 +2743,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
  */
 int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
-	int i, ret = 0, addr;
-	int sn, pn, na;
+	unsigned int id_len, pn_len, sn_len, na_len;
+	int sn, pn, na, addr, ret = 0;
 	u8 *vpd, base_val = 0;
-	unsigned int vpdr_len, kw_offset, id_len;
 
 	vpd = vmalloc(VPD_LEN);
 	if (!vpd)
@@ -2772,60 +2771,48 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	}
 
 	id_len = pci_vpd_lrdt_size(vpd);
-	if (id_len > ID_LEN)
-		id_len = ID_LEN;
 
-	i = pci_vpd_find_tag(vpd, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
-	if (i < 0) {
-		dev_err(adapter->pdev_dev, "missing VPD-R section\n");
+	ret = pci_vpd_check_csum(vpd, VPD_LEN);
+	if (ret) {
+		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
-	vpdr_len = pci_vpd_lrdt_size(&vpd[i]);
-	kw_offset = i + PCI_VPD_LRDT_TAG_SIZE;
-	if (vpdr_len + kw_offset > VPD_LEN) {
-		dev_err(adapter->pdev_dev, "bad VPD-R length %u\n", vpdr_len);
-		ret = -EINVAL;
+	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
+					   PCI_VPD_RO_KEYWORD_SERIALNO, &sn_len);
+	if (ret < 0)
 		goto out;
-	}
+	sn = ret;
 
-#define FIND_VPD_KW(var, name) do { \
-	var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
-	if (var < 0) { \
-		dev_err(adapter->pdev_dev, "missing VPD keyword " name "\n"); \
-		ret = -EINVAL; \
-		goto out; \
-	} \
-	var += PCI_VPD_INFO_FLD_HDR_SIZE; \
-} while (0)
-
-	ret = pci_vpd_check_csum(vpd, VPD_LEN);
-	if (ret) {
-		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
-		ret = -EINVAL;
+	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
+					   PCI_VPD_RO_KEYWORD_PARTNO, &pn_len);
+	if (ret < 0)
 		goto out;
-	}
+	pn = ret;
 
-	FIND_VPD_KW(sn, "SN");
-	FIND_VPD_KW(pn, "PN");
-	FIND_VPD_KW(na, "NA");
-#undef FIND_VPD_KW
+	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN, "NA", &na_len);
+	if (ret < 0)
+		goto out;
+	na = ret;
 
-	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, id_len);
+	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, min_t(int, id_len, ID_LEN));
 	strim(p->id);
-	i = pci_vpd_info_field_size(vpd + sn - PCI_VPD_INFO_FLD_HDR_SIZE);
-	memcpy(p->sn, vpd + sn, min(i, SERNUM_LEN));
+	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
 	strim(p->sn);
-	i = pci_vpd_info_field_size(vpd + pn - PCI_VPD_INFO_FLD_HDR_SIZE);
-	memcpy(p->pn, vpd + pn, min(i, PN_LEN));
+	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
 	strim(p->pn);
-	memcpy(p->na, vpd + na, min(i, MACADDR_LEN));
+	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
 	strim((char *)p->na);
 
 out:
 	vfree(vpd);
-	return ret < 0 ? ret : 0;
+	if (ret < 0) {
+		dev_err(adapter->pdev_dev, "error reading VPD\n");
+		return ret;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.33.0


