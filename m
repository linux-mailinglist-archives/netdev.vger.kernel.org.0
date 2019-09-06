Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8FABD36
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391430AbfIFQBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36775 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395023AbfIFQBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id p13so7710473wmh.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z2vLIzGVHMazqflfz6e3fyXoIG2fjgYyFM5yZYytFEA=;
        b=N/CuEJH+G1iqdbVKGfmzesHpcfNhyUckAxnNRbVppDhv5xX97FFZkDXJreOKHk6fsi
         EGZfFcZkMRfEc7uZhY1TbWfrRQnjrGaqm+aVtE1M+SjKYHWEQowpRYEY/OPmhRke9Rdn
         93FmWmV+MFPDTcDfLUGqv5yWPC6y0cdD6VV1YgHlG2y50mBgbm0de882Oe+9JMKsqzzx
         ZDBJ1jHqi6asR4UrFkWbv95zPijl9JY28i9W7wRoeE5nS1jJm/Rcq7I31bwcTZdJ8P+a
         stoAL2fnEU3vw9W/0BafjZXWuICqXpVOUamv5NoQuPyM/p5S6l5ayIHYkANGjwxfjnhf
         7I1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z2vLIzGVHMazqflfz6e3fyXoIG2fjgYyFM5yZYytFEA=;
        b=W1vbTl/hiBQcZII5zaPAUyD6GSR+0wq0a3TIQ8xSuTsXWXMRt054cK6Oj26iiTcGa9
         CPrbz6OEwV1NYvkh4gla1UI5hL0Io0yL1gXT/hLFMvp6g/E+Lq5jjHsbh6eSS/hujmfA
         PEpVRjPGcRz/czpHggxkRzy9cIfDBSVQWhgCB/hg372ehnnasHowmAybcL9OtilDX0iG
         cQJa9poyPXJyXvASbAxPt9pqBrF/I/Jw9KoEvXwt9IstISp12W2wY9S+U96Z1mcc0mK0
         yf87A9BI2YBtKhbMJkoB0fsF4Us5ybGyJZoLSwZEZA8UouC4lKbR0RiTojg4eMotZhPn
         35wg==
X-Gm-Message-State: APjAAAUZ4LbQEK0aIhALYrbEENX9yipn1TCMTWcLw5wdrI6L+W8fv9rv
        wQSjVHZok3rMnVp751gfTPL5PQ==
X-Google-Smtp-Source: APXvYqyvqySaiOpk2ioIey6NdpAD3e8YQ2jUJjwA5NBU0uEGWqeqdBMcXyJ7WWeOw1xUiAjv5YqlCA==
X-Received: by 2002:a1c:2bc1:: with SMTP id r184mr7676603wmr.40.1567785678141;
        Fri, 06 Sep 2019 09:01:18 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:17 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 06/11] nfp: honor FW reset and loading policies
Date:   Fri,  6 Sep 2019 18:00:56 +0200
Message-Id: <20190906160101.14866-7-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
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
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c      | 139 +++++++++++++++++----
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |   2 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  15 +++
 3 files changed, 131 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 81679647e842..0d8649024505 100644
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
@@ -441,44 +468,106 @@ nfp_net_fw_find(struct pci_dev *pdev, struct nfp_pf *pf)
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
@@ -704,7 +793,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 err_fw_unload:
 	kfree(pf->rtbl);
 	nfp_mip_close(pf->mip);
-	if (pf->fw_loaded)
+	if (pf->unload_fw_on_remove)
 		nfp_fw_unload(pf);
 	kfree(pf->eth_tbl);
 	kfree(pf->nspi);
@@ -744,7 +833,7 @@ static void __nfp_pci_shutdown(struct pci_dev *pdev, bool unload_fw)
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

