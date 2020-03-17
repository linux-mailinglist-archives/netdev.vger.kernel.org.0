Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865161888FE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCQPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:19:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36049 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCQPTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:19:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so22468844wme.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=t5EZSWArlDkJThKqU9M4TgErWWuNwLLtIEjo1J6YeRg=;
        b=fIAcaMwP1yDuay3qyY7NG7+LTvd18KdflbuB+llddnKjRF0FZzeREbspJMOIpOQ272
         S1pL4chJZo9VwY1LoThu0gumHzAJ+oZAJwLot1BjdUsnGxiKmGnvku4mURUlOWgD8dT2
         91Uty3AR4gOCvO8RdOE2QRCeGXKMVbi7eIiw8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t5EZSWArlDkJThKqU9M4TgErWWuNwLLtIEjo1J6YeRg=;
        b=SZdBumZ5hj2blFmTjMXVHWWnC93c6dswhDha/BkveJN5oIZsSW8qdEk7nKlI3O+GMJ
         Ud3l4tyc61nVP5Gw5/NoOUJmsmz07Zf/9247bMckx9ECiMcei9btMd16JvbC0KTDael4
         EXlqFM22VrXPGEuhLkihvbSKmYV9l+Q5RZUvGPC+UTtK5Hyu+i9kuOUkt3e8rwcTeN71
         lY1fbTXuCNZVKejiid+tqhY1dyJTKOYvPM7xceP/+3fZr9Te41HKgVMWBjNDRIdB5bvz
         yM9zbWyOj7McGSnOeKrnyllcUa4jWyBNBS9BAjOFnwNWLQnmcsgRaVM7m6+ec48GbuCs
         weEw==
X-Gm-Message-State: ANhLgQ2C695MjYvV98zPCRoepeLIUZsSbmSV/CGUUmEgPheCGlHSBZdf
        O+JOhzRebYLKY3jEqeVM0e7J5ng/sVc=
X-Google-Smtp-Source: ADFU+vvwOkQSJLGFI3OxjnPNHCmp1xB90SXOnzt9VSPT9GIrn1Ra+tiMtf14VM99ViNz4cgibyoEkA==
X-Received: by 2002:a1c:9815:: with SMTP id a21mr5814322wme.11.1584458350031;
        Tue, 17 Mar 2020 08:19:10 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z19sm4363534wma.41.2020.03.17.08.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:19:09 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 07/11] bnxt_en: Read partno and serialno of the board from VPD
Date:   Tue, 17 Mar 2020 20:47:22 +0530
Message-Id: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the part number and serial number information from VPD in
the bnxt structure. Follow up patch will add the support to display
the information via devlink command.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 59 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 +++
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 663dcf6..b03cdda 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11727,6 +11727,63 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
 	return rc;
 }
 
+#define BNXT_VPD_LEN	512
+static void bnxt_vpd_read_info(struct bnxt *bp)
+{
+	struct pci_dev *pdev = bp->pdev;
+	int i, len, pos, ro_size;
+	ssize_t vpd_size;
+	u8 *vpd_data;
+
+	vpd_data = kmalloc(BNXT_VPD_LEN, GFP_KERNEL);
+	if (!vpd_data)
+		return;
+
+	vpd_size = pci_read_vpd(pdev, 0, BNXT_VPD_LEN, vpd_data);
+	if (vpd_size <= 0) {
+		netdev_err(bp->dev, "Unable to read VPD\n");
+		goto exit;
+	}
+
+	i = pci_vpd_find_tag(vpd_data, 0, vpd_size, PCI_VPD_LRDT_RO_DATA);
+	if (i < 0) {
+		netdev_err(bp->dev, "VPD READ-Only not found\n");
+		goto exit;
+	}
+
+	ro_size = pci_vpd_lrdt_size(&vpd_data[i]);
+	i += PCI_VPD_LRDT_TAG_SIZE;
+	if (i + ro_size > vpd_size)
+		goto exit;
+
+	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
+					PCI_VPD_RO_KEYWORD_PARTNO);
+	if (pos < 0)
+		goto read_sn;
+
+	len = pci_vpd_info_field_size(&vpd_data[pos]);
+	pos += PCI_VPD_INFO_FLD_HDR_SIZE;
+	if (len + pos > vpd_size)
+		goto read_sn;
+
+	strlcpy(bp->board_partno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+
+read_sn:
+	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
+					PCI_VPD_RO_KEYWORD_SERIALNO);
+	if (pos < 0)
+		goto exit;
+
+	len = pci_vpd_info_field_size(&vpd_data[pos]);
+	pos += PCI_VPD_INFO_FLD_HDR_SIZE;
+	if (len + pos > vpd_size)
+		goto exit;
+
+	strlcpy(bp->board_serialno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+exit:
+	kfree(vpd_data);
+}
+
 static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
 {
 	struct pci_dev *pdev = bp->pdev;
@@ -11784,6 +11841,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
+	bnxt_vpd_read_info(bp);
+
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
 		goto init_err_pci_clean;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5adc25f..7f5f35b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1500,6 +1500,10 @@ struct bnxt {
 	 (chip_num) == CHIP_NUM_58804 ||        \
 	 (chip_num) == CHIP_NUM_58808)
 
+#define BNXT_VPD_FLD_LEN	32
+	char			board_partno[BNXT_VPD_FLD_LEN];
+	char			board_serialno[BNXT_VPD_FLD_LEN];
+
 	struct net_device	*dev;
 	struct pci_dev		*pdev;
 
-- 
1.8.3.1

