Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06284172B7F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgB0Wgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:45 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbgB0Wgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568417"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:43 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 3/5] scsi: qedf: use pci_get_dsn
Date:   Thu, 27 Feb 2020 14:36:33 -0800
Message-Id: <20200227223635.1021197-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200227223635.1021197-1-jacob.e.keller@intel.com>
References: <20200227223635.1021197-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded implementation for reading the PCIe DSN with
pci_get_dsn.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: QLogic-Storage-Upstream@cavium.com
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 604856e72cfb..6ef688ef465c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1578,7 +1578,7 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	struct fc_lport *lport = qedf->lport;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
 	u8 buf[8];
-	int i, pos;
+	int i, err;
 
 	/*
 	 * fdmi_enabled needs to be set for libfc to execute FDMI registration.
@@ -1591,20 +1591,16 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	 */
 
 	/* Get the PCI-e Device Serial Number Capability */
-	pos = pci_find_ext_capability(qedf->pdev, PCI_EXT_CAP_ID_DSN);
-	if (pos) {
-		pos += 4;
-		for (i = 0; i < 8; i++)
-			pci_read_config_byte(qedf->pdev, pos + i, &buf[i]);
-
+	err = pci_get_dsn(qedf->pdev, buf);
+	if (err)
+		snprintf(fc_host->serial_number,
+		    sizeof(fc_host->serial_number), "Unknown");
+	else
 		snprintf(fc_host->serial_number,
 		    sizeof(fc_host->serial_number),
 		    "%02X%02X%02X%02X%02X%02X%02X%02X",
 		    buf[7], buf[6], buf[5], buf[4],
 		    buf[3], buf[2], buf[1], buf[0]);
-	} else
-		snprintf(fc_host->serial_number,
-		    sizeof(fc_host->serial_number), "Unknown");
 
 	snprintf(fc_host->manufacturer,
 	    sizeof(fc_host->manufacturer), "%s", "Cavium Inc.");
-- 
2.25.0.368.g28a2d05eebfb

