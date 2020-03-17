Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2261888DE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgCQPQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51062 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgCQPQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id z13so5827090wml.0
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/UP1Q7AjVrjFNMY2X1B0rOG3eU+MSiW7QqWDfuAwuAQ=;
        b=F4LRYWS9YcHF2EIr8yIfGMu2yk7JWBVM4xHiQtgwVri+7/zFUvZOB7+ofzVAV7TpMY
         wBOpRcWtqE3nBvwtRYGvopHH62efrA597KXCzswGgu317cz9BXbHHl8MVWJfoMtw9YDI
         VHS1CbOfte7AYlZLVfwyWIBsC9oJ1SsGFBDG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/UP1Q7AjVrjFNMY2X1B0rOG3eU+MSiW7QqWDfuAwuAQ=;
        b=EjqfgI4R1zI1ClPVe2YxCQ+XuwBnkDm9C1BkgLIjCU0Wwl8mopk3ODaC/LO8nXvoRd
         QTIaQwk3TI2tLbz8pjyhdoCqFLPu37kSLohOEWV3GKL8tY3F3ylRsMobQFv4JlvqSkpk
         Iq6hUqO6VK4+5azXHknVjJNzWgUtOGC3rn5pWmU3ZjKFtVbZTa0Smibjaaeb6utwz1Uu
         jweBLNU65kXM02/DBMuYsokcFTo4EsW/fhD/wnbUhQpiHERIC4SNPpzDuz000h4jZfsl
         B1HzDd79HqUAYbfRCIYl3DL3ZJWYARv5RLBQvDe/lyJOG4OeGvzuFVB+SK1e01EbpP4H
         WBxA==
X-Gm-Message-State: ANhLgQ14fiKaT5xiH+bvjyjEfV3G4UtD1exxZqFzQwFJDOTAKm0mxeX3
        MUh7uKpmKc5RJl0AFJdUczxoDw==
X-Google-Smtp-Source: ADFU+vuY6NNKJNUbb7wskp7oxB/aeWGPf2r5M5FzGd5VaIVFE3Z4L1dL8EAslLzUZviseZ/UMLR+VQ==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr5895936wmf.160.1584458216209;
        Tue, 17 Mar 2020 08:16:56 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:55 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 05/11] bnxt_en: Add hw addr and multihost base hw addr to devlink info_get cb.
Date:   Tue, 17 Mar 2020 20:44:42 +0530
Message-Id: <1584458082-29207-6-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most of the scenarios, device serial number is not supported. So
MAC address is used for proper asset tracking by cloud customers. In
case of multihost NICs, base MAC address is unique for entire NIC and
this can be used for asset tracking. Add the multihost base MAC address
and interface MAC address information to info_get command.

Also update bnxt.rst documentation file.

Example display:

$ devlink dev info pci/0000:3b:00.1
pci/0000:3b:00.1:
  driver bnxt_en
  serial_number B0-26-28-FF-FE-C8-85-20
  versions:
      fixed:
        asic.id 1750
        asic.rev 1
      running:
        drv.spec 1.10.1.12
        hw.addr b0:26:28:c8:85:21
        hw.mh_base_addr b0:26:28:c8:85:20
        fw 216.0.286.0
        fw.psid 0.0.6
        fw.app 216.0.251.0

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         |  7 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 40 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  2 ++
 3 files changed, 49 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 2709161..f850a18 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -60,6 +60,13 @@ The ``bnxt_en`` driver reports the following versions
    * - ``drv.spec``
      - running
      - HWRM specification version supported by driver HWRM implementation
+   * - ``hw.addr``
+     - stored, running
+     - Hardware address of the interface
+   * - ``hw.mh_base_addr``
+     - stored, running
+     - Base hardware address of the multihost NIC. Displayed only on multihost
+       system
    * - ``fw.psid``
      - stored, running
      - Firmware parameter set version of the board
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index f08db49..607e27a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -396,6 +396,32 @@ static int bnxt_get_nvm_cfg_ver(struct bnxt *bp,
 	return rc;
 }
 
+static int bnxt_get_mh_base_addr(struct bnxt *bp, u8 *base_addr)
+{
+	dma_addr_t data_dma_addr;
+	__le32 *data;
+	int rc;
+
+	data = dma_alloc_coherent(&bp->pdev->dev, 2 * sizeof(*data),
+				  &data_dma_addr, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	rc = bnxt_hwrm_nvm_get_var(bp, data_dma_addr, NVM_OFF_MAC_ADDR,
+				   BNXT_NVM_MAC_ADDR_BITS);
+	if (!rc) {
+		u32 mac_hi = le32_to_cpu(data[0]);
+		u32 mac_lo = le32_to_cpu(data[1]);
+
+		sprintf(base_addr, "%02x:%02x:%02x:%02x:%02x:%02x",
+			(u8)(mac_hi >> 8), (u8)(mac_hi), (u8)(mac_lo >> 24),
+			(u8)(mac_lo >> 16), (u8)(mac_lo >> 8), (u8)(mac_lo));
+	}
+	dma_free_coherent(&bp->pdev->dev, 2 * sizeof(*data), data,
+			  data_dma_addr);
+	return rc;
+}
+
 static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
@@ -405,6 +431,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	char mgmt_ver[FW_VER_STR_LEN];
 	char roce_ver[FW_VER_STR_LEN];
 	char fw_ver[FW_VER_STR_LEN];
+	u8 mh_base_addr[ETH_ALEN];
 	char buf[32];
 	int rc;
 
@@ -439,6 +466,19 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	sprintf(buf, "%pM", bp->dev->dev_addr);
+	rc = devlink_info_version_running_put(req,
+				DEVLINK_INFO_VERSION_GENERIC_HW_ADDR, buf);
+	if (rc)
+		return rc;
+
+	if (BNXT_MH(bp) && !bnxt_get_mh_base_addr(bp, &mh_base_addr[0])) {
+		rc = devlink_info_version_running_put(req, "hw.mh_base_addr",
+						      mh_base_addr);
+		if (rc)
+			return rc;
+	}
+
 	if (strlen(ver_resp->active_pkg_name)) {
 		rc =
 		    devlink_info_version_running_put(req,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 95f893f..e720b1d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -33,6 +33,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 	}
 }
 
+#define NVM_OFF_MAC_ADDR		1
 #define NVM_OFF_MSIX_VEC_PER_PF_MAX	108
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
@@ -40,6 +41,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_ENABLE_SRIOV		401
 #define NVM_OFF_NVM_CFG_VER		602
 
+#define BNXT_NVM_MAC_ADDR_BITS		64
 #define BNXT_NVM_CFG_VER_BITS		24
 #define BNXT_NVM_CFG_VER_BYTES		4
 
-- 
1.8.3.1

