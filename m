Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC179176A9B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCCCZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:54186 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgCCCZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605692"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:08 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 3/6] scsi: qedf: Use pci_get_dsn()
Date:   Mon,  2 Mar 2020 18:25:02 -0800
Message-Id: <20200303022506.1792776-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200303022506.1792776-1-jacob.e.keller@intel.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
 <20200303022506.1792776-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded implementation for reading the PCIe DSN with
pci_get_dsn().

The original code used a for-loop that looped over each of the 8 bytes
and copied them into a temporary buffer. pci_get_dsn() uses two calls to
pci_read_config_dword, and correctly bitwise ORs them into a u64. Thus,
we can simplify the snprintf significantly using %016llX on a u64 value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
The QLogic-Storage-Upstream@cavium.com appears to be a dud. I'm not sure who
maintains this driver, and thus am not sure who to add to the Cc.

 drivers/scsi/qedf/qedf_main.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 604856e72cfb..5b19f5175c5c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1577,8 +1577,7 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 {
 	struct fc_lport *lport = qedf->lport;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
-	u8 buf[8];
-	int i, pos;
+	u64 dsn;
 
 	/*
 	 * fdmi_enabled needs to be set for libfc to execute FDMI registration.
@@ -1591,18 +1590,11 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	 */
 
 	/* Get the PCI-e Device Serial Number Capability */
-	pos = pci_find_ext_capability(qedf->pdev, PCI_EXT_CAP_ID_DSN);
-	if (pos) {
-		pos += 4;
-		for (i = 0; i < 8; i++)
-			pci_read_config_byte(qedf->pdev, pos + i, &buf[i]);
-
+	dsn = pci_get_dsn(qedf->pdev);
+	if (dsn)
 		snprintf(fc_host->serial_number,
-		    sizeof(fc_host->serial_number),
-		    "%02X%02X%02X%02X%02X%02X%02X%02X",
-		    buf[7], buf[6], buf[5], buf[4],
-		    buf[3], buf[2], buf[1], buf[0]);
-	} else
+		    sizeof(fc_host->serial_number), "%016llX", dsn);
+	else
 		snprintf(fc_host->serial_number,
 		    sizeof(fc_host->serial_number), "Unknown");
 
-- 
2.25.0.368.g28a2d05eebfb

