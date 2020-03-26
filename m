Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D8193E90
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgCZMFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:05:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42866 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgCZMFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:05:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so7410458wrx.9
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yNdnIuvlj7tnKOaaFXwPrb5iiqVU7ce1Jl6I80NDyRQ=;
        b=MlBJPTPAMZA3sJooHRfwihoxvXc3CHFfriLyBloAvMuCvFWsQQ3bLrjRkwV3Pc0SOY
         V7QQz7j7EvCvCYDxt4NpurgBRfw2jlB+CEGaHdYU5zm9oVSOMdc7/cUWc5YXNRTlrWzW
         ZYVl6PArAy3hn+hXTmHEKDMsiaL+oNBAT2WjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yNdnIuvlj7tnKOaaFXwPrb5iiqVU7ce1Jl6I80NDyRQ=;
        b=L3sjmBBcn6ChYBP1u3TxwdbA1eI/INzZ9L5YsBaKUqCYm8Co5I678ErnWFZOUPvrcT
         zYPxdyzWsoLgyGeY49fiNamokfoH5iKVpF2tAe3GDNkD8opTIABFxgVlnvgC+H32TisC
         mgKJcwLmWmXNpfeW1A8gCDUWvEZoAyOl3xi+MzBjEja+XRNx+M3BiipuNXMdf1gaKIiz
         oTUDOeLRhCs6Gff6rakts3xlenW5tIClPHPMDvUbFXgPPWsjznFlZaQI5v/pvF35xIPh
         o8G3D1Zb1tWiQGVPc6boIt0Lh+hCEbCUiwFyT2LXq5ij73GVQ2Bxjqw+mSXWIq5ZcN6h
         R0JQ==
X-Gm-Message-State: ANhLgQ2AbfYrQMkh3vYwmDcmGZtofQmDNIFa+f6QfZ1OiR9T8LjqggF9
        MpNlL2c3Lw/hY6tYAJ+0pr6FIA==
X-Google-Smtp-Source: ADFU+vuWdKBrJW/Zru5r1qyBhdE0QvIzHNu6VUzfPQFSNBwvooFE7S5navI1WkIDBx9HZ5vTOcNCPQ==
X-Received: by 2002:a5d:63c5:: with SMTP id c5mr9052816wrw.331.1585224309537;
        Thu, 26 Mar 2020 05:05:09 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id t2sm3108969wml.30.2020.03.26.05.05.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:05:08 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v3 net-next 4/5] bnxt_en: Read partno and serialno of the board from VPD
Date:   Thu, 26 Mar 2020 17:33:24 +0530
Message-Id: <1585224205-11966-1-git-send-email-vasundhara-v.volam@broadcom.com>
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

