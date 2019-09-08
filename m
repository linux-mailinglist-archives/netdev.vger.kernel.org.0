Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4432AD14B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbfIHXzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38137 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbfIHXzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:55:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id b2so14136068qtq.5
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RZIDR3GQuJKZgF9/25aiSHfmiLcbtzo4S66qz4lxX18=;
        b=ZqMF6x+1Hb9gAYBhHcoWAlsUPZLbVJ/FiwoGx5wYPKanqCg3mATmgCB9FBoXwSbP3a
         Yut8DD4WuEq3utZ+vR5FEgiL0N7eDeyE2Gpl/wpp7ERjrVDBKPzdnhcWHER7igAvVtCh
         pPlXjd+7ZhWWaueAtsJQy5QSZgmJa46FH6cJr5+KfxRBBB4T/cMxMTrmxhfgXTIxxHa2
         Dv2BK92pN8EegmI7G8hcZURVuBCnrmijVpca5qE2dcZjtsD7Yh7RR8sK0LROlfZS94/i
         aiiJpuy4ksLAQQM7umydFSC7FJin3XThNrbKrc8cZRqRJKMwFr1uz3kcwVhK0BX26imE
         R9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RZIDR3GQuJKZgF9/25aiSHfmiLcbtzo4S66qz4lxX18=;
        b=mDto83pjFdcnYVYCsOHZ1nLakrsMKlMX/k9qUg5j/1RZWeDUT9qBRRcl0IcX27m36X
         xHCX5SRkxPxQ7pOtdEySH7QzTbMxWc47c4F65BmArBSGJqWxPA1gaBDREdIZDAq0BPFz
         UaVQVR6tGHuGIX6P2MC/PTnxcf6C4u7FzdQASQPYoWWNcrANsBlQmucdGRZ9mXsQJsqv
         89ede6bqFXEL92tgOt5hGbFTcYlQC3h03mReOJIhb7kp3qNUctYrQ97Xf36dwpAzOzrY
         RFLjw5eL1nAU7VSKitPITreSSC1AkhHkpl/dAyXXp+CoaKxVePRkIriqpL5weheio2fn
         p7cA==
X-Gm-Message-State: APjAAAWWVMuuhEnqMybtHNmAswa0IyTcEi8LQyacwKlqW0ggySYQsewA
        PVSKCVhD4wRB5i0SrS58IZh2pw==
X-Google-Smtp-Source: APXvYqzFHZXp8hc2+YXpr4ft97gaYswBF+SKbccLc2G8ICPmz5LfFzLqYJPId+ql1iq6idinEc/9bA==
X-Received: by 2002:ac8:748c:: with SMTP id v12mr20917049qtq.23.1567986900861;
        Sun, 08 Sep 2019 16:55:00 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:55:00 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 06/11] nfp: honor FW reset and loading policies
Date:   Mon,  9 Sep 2019 00:54:22 +0100
Message-Id: <20190908235427.9757-7-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

The firmware reset and loading policies can be controlled with the
combination of three hwinfo keys, 'abi_drv_reset', 'abi_drv_load_ifc'
and 'app_fw_from_flash'.

'app_fw_from_flash' defines which firmware should take precedence,
'Disk', 'Flash' or the 'Preferred' firmware. When 'Preferred'
is selected, the management firmware makes the decision on which
firmware will be loaded by comparing versions of the flash firmware
and the host supplied firmware.

'abi_drv_reset' defines when the driver should reset the firmware when
the driver is probed, either 'Disk' if firmware was found on disk,
'Always' reset or 'Never' reset. Note that the device is always reset
on driver unload if firmware was loaded when the driver was probed.

'abi_drv_load_ifc' defines a list of PF devices allowed to load FW on
the device.

Furthermore, we limit the cases to where the driver will unload firmware
again when the driver is removed to only when firmware was loaded by the
driver and only if this particular device was the only one that could
have loaded firmware. This is needed to avoid firmware being removed
while in use on multi-host platforms.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c      | 140 +++++++++++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |   2 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  15 +++
 3 files changed, 132 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 81679647e842..969850f8fe51 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -352,7 +352,7 @@ nfp_net_fw_request(struct pci_dev *pdev, struct nfp_pf *pf, const char *name)
 
 	err = request_firmware_direct(&fw, name, &pdev->dev);
 	nfp_info(pf->cpp, "  %s: %s\n",
-		 name, err ? "not found" : "found, loading...");
+		 name, err ? "not found" : "found");
 	if (err)
 		return NULL;
 
@@ -430,6 +430,33 @@ nfp_net_fw_find(struct pci_dev *pdev, struct nfp_pf *pf)
 	return nfp_net_fw_request(pdev, pf, fw_name);
 }
 
+static int
+nfp_get_fw_policy_value(struct pci_dev *pdev, struct nfp_nsp *nsp,
+			const char *key, const char *default_val, int max_val,
+			int *value)
+{
+	char hwinfo[64];
+	long hi_val;
+	int err;
+
+	snprintf(hwinfo, sizeof(hwinfo), key);
+	err = nfp_nsp_hwinfo_lookup_optional(nsp, hwinfo, sizeof(hwinfo),
+					     default_val);
+	if (err)
+		return err;
+
+	err = kstrtol(hwinfo, 0, &hi_val);
+	if (err || hi_val < 0 || hi_val > max_val) {
+		dev_warn(&pdev->dev,
+			 "Invalid value '%s' from '%s', ignoring\n",
+			 hwinfo, key);
+		err = kstrtol(default_val, 0, &hi_val);
+	}
+
+	*value = hi_val;
+	return err;
+}
+
 /**
  * nfp_net_fw_load() - Load the firmware image
  * @pdev:       PCI Device structure
@@ -441,44 +468,107 @@ nfp_net_fw_find(struct pci_dev *pdev, struct nfp_pf *pf)
 static int
 nfp_fw_load(struct pci_dev *pdev, struct nfp_pf *pf, struct nfp_nsp *nsp)
 {
-	const struct firmware *fw;
+	bool do_reset, fw_loaded = false;
+	const struct firmware *fw = NULL;
+	int err, reset, policy, ifcs = 0;
+	char *token, *ptr;
+	char hwinfo[64];
 	u16 interface;
-	int err;
+
+	snprintf(hwinfo, sizeof(hwinfo), "abi_drv_load_ifc");
+	err = nfp_nsp_hwinfo_lookup_optional(nsp, hwinfo, sizeof(hwinfo),
+					     NFP_NSP_DRV_LOAD_IFC_DEFAULT);
+	if (err)
+		return err;
 
 	interface = nfp_cpp_interface(pf->cpp);
-	if (NFP_CPP_INTERFACE_UNIT_of(interface) != 0) {
-		/* Only Unit 0 should reset or load firmware */
+	ptr = hwinfo;
+	while ((token = strsep(&ptr, ","))) {
+		unsigned long interface_hi;
+
+		err = kstrtoul(token, 0, &interface_hi);
+		if (err) {
+			dev_err(&pdev->dev,
+				"Failed to parse interface '%s': %d\n",
+				token, err);
+			return err;
+		}
+
+		ifcs++;
+		if (interface == interface_hi)
+			break;
+	}
+
+	if (!token) {
 		dev_info(&pdev->dev, "Firmware will be loaded by partner\n");
 		return 0;
 	}
 
+	err = nfp_get_fw_policy_value(pdev, nsp, "abi_drv_reset",
+				      NFP_NSP_DRV_RESET_DEFAULT,
+				      NFP_NSP_DRV_RESET_NEVER, &reset);
+	if (err)
+		return err;
+
+	err = nfp_get_fw_policy_value(pdev, nsp, "app_fw_from_flash",
+				      NFP_NSP_APP_FW_LOAD_DEFAULT,
+				      NFP_NSP_APP_FW_LOAD_PREF, &policy);
+	if (err)
+		return err;
+
 	fw = nfp_net_fw_find(pdev, pf);
-	if (!fw) {
-		if (nfp_nsp_has_stored_fw_load(nsp))
-			nfp_nsp_load_stored_fw(nsp);
-		return 0;
+	do_reset = reset == NFP_NSP_DRV_RESET_ALWAYS ||
+		   (fw && reset == NFP_NSP_DRV_RESET_DISK);
+
+	if (do_reset) {
+		dev_info(&pdev->dev, "Soft-resetting the NFP\n");
+		err = nfp_nsp_device_soft_reset(nsp);
+		if (err < 0) {
+			dev_err(&pdev->dev,
+				"Failed to soft reset the NFP: %d\n", err);
+			goto exit_release_fw;
+		}
 	}
 
-	dev_info(&pdev->dev, "Soft-reset, loading FW image\n");
-	err = nfp_nsp_device_soft_reset(nsp);
-	if (err < 0) {
-		dev_err(&pdev->dev, "Failed to soft reset the NFP: %d\n",
-			err);
-		goto exit_release_fw;
-	}
+	if (fw && policy != NFP_NSP_APP_FW_LOAD_FLASH) {
+		if (nfp_nsp_has_fw_loaded(nsp) && nfp_nsp_fw_loaded(nsp))
+			goto exit_release_fw;
 
-	err = nfp_nsp_load_fw(nsp, fw);
-	if (err < 0) {
-		dev_err(&pdev->dev, "FW loading failed: %d\n", err);
-		goto exit_release_fw;
+		err = nfp_nsp_load_fw(nsp, fw);
+		if (err < 0) {
+			dev_err(&pdev->dev, "FW loading failed: %d\n",
+				err);
+			goto exit_release_fw;
+		}
+		dev_info(&pdev->dev, "Finished loading FW image\n");
+		fw_loaded = true;
+	} else if (policy != NFP_NSP_APP_FW_LOAD_DISK &&
+		   nfp_nsp_has_stored_fw_load(nsp)) {
+
+		/* Don't propagate this error to stick with legacy driver
+		 * behavior, failure will be detected later during init.
+		 */
+		if (!nfp_nsp_load_stored_fw(nsp))
+			dev_info(&pdev->dev, "Finished loading stored FW image\n");
+
+		/* Don't flag the fw_loaded in this case since other devices
+		 * may reuse the firmware when configured this way
+		 */
+	} else {
+		dev_warn(&pdev->dev, "Didn't load firmware, please update flash or reconfigure card\n");
 	}
 
-	dev_info(&pdev->dev, "Finished loading FW image\n");
-
 exit_release_fw:
 	release_firmware(fw);
 
-	return err < 0 ? err : 1;
+	/* We don't want to unload firmware when other devices may still be
+	 * dependent on it, which could be the case if there are multiple
+	 * devices that could load firmware.
+	 */
+	if (fw_loaded && ifcs == 1)
+		pf->unload_fw_on_remove = true;
+
+	return err < 0 ? err : fw_loaded;
 }
 
 static void
@@ -704,7 +794,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 err_fw_unload:
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
-	if (pf->fw_loaded)
+	if (pf->unload_fw_on_remove)
 		nfp_fw_unload(pf);
 	kfree(pf->eth_tbl);
 	kfree(pf->nspi);
@@ -744,7 +834,7 @@ static void __nfp_pci_shutdown(struct pci_dev *pdev, bool unload_fw)
 	vfree(pf->dumpspec);
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
-	if (unload_fw && pf->fw_loaded)
+	if (unload_fw && pf->unload_fw_on_remove)
 		nfp_fw_unload(pf);
 
 	destroy_workqueue(pf->wq);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index b7211f200d22..bd6450b0f23f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -64,6 +64,7 @@ struct nfp_dumpspec {
  * @limit_vfs:		Number of VFs supported by firmware (~0 for PCI limit)
  * @num_vfs:		Number of SR-IOV VFs enabled
  * @fw_loaded:		Is the firmware loaded?
+ * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
  * @ctrl_vnic:		Pointer to the control vNIC if available
  * @mip:		MIP handle
  * @rtbl:		RTsym table
@@ -110,6 +111,7 @@ struct nfp_pf {
 	unsigned int num_vfs;
 
 	bool fw_loaded;
+	bool unload_fw_on_remove;
 
 	struct nfp_net *ctrl_vnic;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 055fda05880d..1531c1870020 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -102,6 +102,21 @@ enum nfp_eth_fec {
 #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
 #define NFP_FEC_DISABLED	BIT(NFP_FEC_DISABLED_BIT)
 
+/* Defines the valid values of the 'abi_drv_reset' hwinfo key */
+#define NFP_NSP_DRV_RESET_DISK			0
+#define NFP_NSP_DRV_RESET_ALWAYS		1
+#define NFP_NSP_DRV_RESET_NEVER			2
+#define NFP_NSP_DRV_RESET_DEFAULT		"0"
+
+/* Defines the valid values of the 'app_fw_from_flash' hwinfo key */
+#define NFP_NSP_APP_FW_LOAD_DISK		0
+#define NFP_NSP_APP_FW_LOAD_FLASH		1
+#define NFP_NSP_APP_FW_LOAD_PREF		2
+#define NFP_NSP_APP_FW_LOAD_DEFAULT		"2"
+
+/* Define the default value for the 'abi_drv_load_ifc' key */
+#define NFP_NSP_DRV_LOAD_IFC_DEFAULT		"0x10ff"
+
 /**
  * struct nfp_eth_table - ETH table information
  * @count:	number of table entries
-- 
2.11.0

