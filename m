Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D07C188900
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgCQPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:19:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44713 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCQPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:19:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id y2so10712173wrn.11
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=807Ui94TU5u0AhxzhwnrSf/1vI/cWF4dKvvCGNgjD4c=;
        b=Zz1jwkeLetyGDCMiay8Zr1gPM9+Oxud92I0ptKiObdrQBTq2Wv4UmwCW9zdfxlnDkq
         YYdM1w6kRvzBpiI9l6bj291oT3JB4YjWiz57T/URCbNnBc/46adqH/v7p12z94VAfxdQ
         TBr5L0CSEZWsbHQ5bYoRnj1rFM9W6C5qgsYwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=807Ui94TU5u0AhxzhwnrSf/1vI/cWF4dKvvCGNgjD4c=;
        b=CnS1LBAFVlXDq2bVIZ6nw7gxOlAPqs9e+jUJSvWup2k/25oO9InDI/SA67mkGxdrq/
         +NDzYX5G2f9DXmsIX7hiSC2QMAQwuo5l1eP91LMo2bvbaqBEwDJ/V3uV73gifLnampuA
         ifTieCm5IZaGUul88vBMjkiW9iZnSV37qoYVcYC99SEZkvmVx+N/2yfRWC0jYg7MQOKX
         0bJHuVT9pPXlu9ThWuPKT+QeHmRlBWUg326kuOU/jZOSdr+ct6lvSbMMiObZgH5+kmiv
         s9zlSqefpvV/t13cvUxuLsGT4TgZhEGPSaC7Qi2qlKu0zAU7VYw7srPZpMg3UbJRgL/l
         +Dew==
X-Gm-Message-State: ANhLgQ0S8DtBtq+9VOp+EDaGvIShuqQoSmv43CaNzKmAiRTyl/lF6gAx
        ZLKpOUaD5f+qEwe2iKI45Kxcb/+e+gw=
X-Google-Smtp-Source: ADFU+vskFESljA0pMg1dI++LGac1STuwFCnuhn3wHGsRc9oibKd9ebtgDxuYiZZZQWQdEMF1ZrWt5Q==
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr6298103wrv.186.1584458361800;
        Tue, 17 Mar 2020 08:19:21 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z19sm4363534wma.41.2020.03.17.08.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:19:21 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 08/11] bnxt_en: Add partno and serialno to devlink info_get cb
Date:   Tue, 17 Mar 2020 20:47:23 +0530
Message-Id: <1584458246-29370-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add part number and serial number info from the vital product data
to info_get command via devlink tool.

Some of the broadcom devices support both PCI extended config space
for device serial number and VPD serial number. With this patch, both
the information will be displayed via info_get cb.

Update bnxt.rst documentation as well.

Example display:

$ devlink dev info pci/0000:3b:00.1
pci/0000:3b:00.1:
  driver bnxt_en
  serial_number B0-26-28-FF-FE-C8-85-20
  versions:
      fixed:
        board.id BCM957508-P2100G
        asic.id 1750
        asic.rev 1
        vpd.serialno P2100pm01920A0032CQ
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
 Documentation/networking/devlink/bnxt.rst         |  6 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index f850a18..17b6522 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -51,12 +51,18 @@ The ``bnxt_en`` driver reports the following versions
    * - Name
      - Type
      - Description
+   * - ``board.id``
+     - fixed
+     - Part number identifying the board design
    * - ``asic.id``
      - fixed
      - ASIC design identifier
    * - ``asic.rev``
      - fixed
      - ASIC design revision
+   * - ``vpd.serialno``
+     - fixed
+     - Serial number identifying the board
    * - ``drv.spec``
      - running
      - HWRM specification version supported by driver HWRM implementation
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 607e27a..6065602 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -439,6 +439,14 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
+	if (strlen(bp->board_partno)) {
+		rc = devlink_info_version_fixed_put(req,
+			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+			bp->board_partno);
+		if (rc)
+			return rc;
+	}
+
 	sprintf(buf, "%X", bp->chip_num);
 	rc = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
@@ -461,6 +469,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	if (strlen(bp->board_serialno)) {
+		rc = devlink_info_version_fixed_put(req, "vpd.serialno",
+						    bp->board_serialno);
+		if (rc)
+			return rc;
+	}
+
 	rc = devlink_info_version_running_put(req,
 		DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC, HWRM_VERSION_STR);
 	if (rc)
-- 
1.8.3.1

