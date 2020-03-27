Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE56419542C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgC0Jhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:37:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36400 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgC0Jhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:37:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so11583254wme.1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=9OxJuHZGLcKvh+cZOtc6EPpQlD2fx7MGNgsp1/kXk3s=;
        b=esvjbZ29fDG+uSVd7w+l9LPrAbhS3BFcYJI4lFzr9HtMlc+O2Y3BAL0UT1g6tphwne
         z2/1arZEb05HSidbavm5hU2PHQOU/EwMWK1V7sVGcgYqut7a7xBSBcI/2gVYsztzkAOE
         EVobIMWywBW3hq/9GcYGTBpId0UUX+J6+00Xk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9OxJuHZGLcKvh+cZOtc6EPpQlD2fx7MGNgsp1/kXk3s=;
        b=LR4DH8JIvm/dxD+ZyTsWXESxB6L4rfsLg2tGsZpdIhDwvZuIhdKA1g2OiR6JxcTi2F
         caWXnW7xGWWyhM3K1Nq4SBNWH8wPp04pQ/Z2ykMOZ+WGBbU5927Ge4CkdlP5mPkCi+M9
         JJ0TOUex9XS8f1WjLaE8VRcPDU4Z/eQlU7Sukc18sB/pFB0QLFb23IkP7u6O5elMWQjP
         gQ63NjwljPRF7XSz7SSQTi3kXAVwQik7edGjvhDBVWNm8nW/ghQ8VMAOGn6Cmsz/JAJ+
         T7GFKjc3VlHKK/dl7ygn7PlUk95f/Ho8Wp9J/MYIdktzL9jj7soWi82XIdqKcPeDJw8O
         TNVA==
X-Gm-Message-State: ANhLgQ2KdC0ZqGNHUdsVY95/91jOyDkrbyN3Bu+uKXdESPNjkpIMYe4R
        II1TKduxcNGtZC7x906o1gb+VA==
X-Google-Smtp-Source: ADFU+vtile/90lGGzhWtgTDAGTg6vqfGkeroytCqULXyT0M8SBb9RgaAilZNhWJRj7kfZ2rq17rqmw==
X-Received: by 2002:a1c:2842:: with SMTP id o63mr4437911wmo.73.1585301858736;
        Fri, 27 Mar 2020 02:37:38 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v7sm5385107wrs.96.2020.03.27.02.37.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:37:38 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 4/6] bnxt_en: Read partno and serialno of the board from VPD
Date:   Fri, 27 Mar 2020 15:05:49 +0530
Message-Id: <1585301751-26044-1-git-send-email-vasundhara-v.volam@broadcom.com>
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
index 3861dff..fead64f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11752,6 +11752,63 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
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
@@ -11809,6 +11866,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
+	bnxt_vpd_read_info(bp);
+
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
 		goto init_err_pci_clean;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a1e9d33..f2caa27 100644
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

