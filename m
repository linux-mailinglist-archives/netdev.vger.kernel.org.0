Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26E919389E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgCZGau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:30:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34498 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZGau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:30:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id 26so6607247wmk.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yNdnIuvlj7tnKOaaFXwPrb5iiqVU7ce1Jl6I80NDyRQ=;
        b=e3XdiZAqQan3GnpDAtnfc0IB9tYosczzoUKxSvBOAeSBGAZEyEGBNEUShdB7S5pzdL
         W8AdhuJyaH0FxBY0qFwQw4lSJV5jx9fxwk06eYpSmvD2tXF2twVmA0Ptn7FLZKvpuDaZ
         NaLXbP8QvYkLIhPBihQgifE0YJpOl20n3APoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yNdnIuvlj7tnKOaaFXwPrb5iiqVU7ce1Jl6I80NDyRQ=;
        b=DDelNIPE34WI6hdzeDfTiwuV/nsSIOSxhu1m1lORF0ZlzPIsUnT4r5r6cZnByXsPKQ
         RNEQS/DxvXT9eQBlam4KtYPQRFa9YkPG+g93HDSe+c38i8aKgXFSzAKpoRllyKZjBL1y
         sjYzU8cy3QP3VSRo2Ry+TCKcOfhfbecC0pnfRaqAie7CaykSg1S/LB6GRGVnNm9QcIGw
         3jC/6JsFJ7VT5Ol/LLn7Mjr61qzWn2e9CgqS9MvEEMGyX98mSXwYmaDMp8+pcJqEIMSc
         23nWvUkD2w+NxrBuZE8x/v+FjwidKtznUL4WBR42NmGd2gl1a5xzSgiGoziPthUiEopk
         mUMA==
X-Gm-Message-State: ANhLgQ2DgInvGRaLD/oyyFYRscyXGdfEaF4tjmw2VxuT9JQHjrPCzFKV
        wGOf6Uo0iie7FUQ7Been4h6f5A==
X-Google-Smtp-Source: ADFU+vvyUaxiVm5qi72PCQWGoyDWhnYgWvLq30Hu5RP4bp7/IgHRNRorRKdYP8eJbIiucCFFrqTcVA==
X-Received: by 2002:a1c:f213:: with SMTP id s19mr1410433wmc.116.1585204247888;
        Wed, 25 Mar 2020 23:30:47 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o9sm2155583wrw.20.2020.03.25.23.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:30:47 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 6/7] bnxt_en: Read partno and serialno of the board from VPD
Date:   Thu, 26 Mar 2020 11:59:02 +0530
Message-Id: <1585204143-10417-1-git-send-email-vasundhara-v.volam@broadcom.com>
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
index 7bcd313..7298cee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11740,6 +11740,63 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
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
@@ -11797,6 +11854,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
+	bnxt_vpd_read_info(bp);
+
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
 		goto init_err_pci_clean;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cc57538..0690009 100644
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

