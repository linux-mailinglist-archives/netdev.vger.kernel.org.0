Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F33267B05
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgILOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgILOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:42:11 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51486C0617A1;
        Sat, 12 Sep 2020 07:41:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id u21so17272718eja.2;
        Sat, 12 Sep 2020 07:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NKS1auYv56m49WmI6rHkbjfbXUfFIyNjZnkjGaV5oqw=;
        b=Kl30H8L+oLIeyqmK497s5YTVn9St9+QQEumIgJ7xyijI0DgOC7pfjRs4ziLOQzACJB
         bzbqqR26bLmBGIwnqTXGa7v3kj7Va/EJxy+yRf4o8rrQ/WLILU3vymMOZnotNu1b05v5
         p1P4E64qVAwM8quexYW7VApW+atlL9MhNm9hWAh7xhrd+/oEgohqDfXBeBU07wozrfBP
         kyTyVJOAKZC3iYQe0bXfcJj1UVpYVYGv6zZotVc+P2irhnfJASrg0zxFpqVRgs37Wd2g
         9dVOrgzJfXk9yEQigeR2sJ08HePhjmp54I3RpELIQD+7k0B23m6pQ9KawsgWmylXRAip
         7XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NKS1auYv56m49WmI6rHkbjfbXUfFIyNjZnkjGaV5oqw=;
        b=FZ8Xo5+QqpInVYQGNaWNv2xFEHtsUXpnfmoDBPG1qra6me+9AwD0OsLwKqRkAb+cxj
         UvcQrGwh3llIK3WjO+zXjcOM5WSNw1lxzWIX9N8rAOrGantto6jFVua/V1RvC3EbsXoc
         XWGnvWxt7RURJIXJuQ5UmEPSM+fmczJIhV9YMYSkGedni3o4iP7fnI7vrwgUosl3VI4l
         cWSIp2Lo1mvL0auRpaGnywhqPqG/O+tnST4KgJTpoSamPESev4ivsGjrcbSh+aqb2eZ+
         cP8Tbioh/dCRoHiAv7+Oz5zLDcSn8zIWv3KPsNDlQaGdHil2ZvqaTD4EeZqHxzuV/MJz
         mK0Q==
X-Gm-Message-State: AOAM5331LUP0KQC7esuKRjMnOKxxqU0ryozGibLOx35b26OUbQ6pZp32
        1TIfPKClLqkLzIhFeu7mTUpd4A3X4eQ=
X-Google-Smtp-Source: ABdhPJyMJWorvAFL6IFMrn6jByr61Kfhym1m93kAqhcEAi3awAoqF48xeV4NUNq9mhzd+1D2NSR2ng==
X-Received: by 2002:a17:906:9712:: with SMTP id k18mr6199254ejx.76.1599921706330;
        Sat, 12 Sep 2020 07:41:46 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:45 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 14/14] habanalabs/gaudi: add NIC init/fini calls from common code
Date:   Sat, 12 Sep 2020 17:41:06 +0300
Message-Id: <20200912144106.11799-15-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Finally, enable the NIC engines. Initialize the NIC ports mask variable
with full mask so all ports will be initialized.

Call the NIC init/fini from the common code.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/device.c       | 18 +++++++++++++++
 drivers/misc/habanalabs/common/habanalabs.h   |  6 +++++
 .../misc/habanalabs/common/habanalabs_drv.c   |  1 +
 drivers/misc/habanalabs/common/pci.c          |  1 +
 drivers/misc/habanalabs/gaudi/gaudi.c         | 23 +++++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           | 12 ++++++++++
 6 files changed, 61 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 73d64f84aeba..dd815a545160 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1083,6 +1083,12 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 			goto out_err;
 		}
 
+		rc = hdev->asic_funcs->nic_init(hdev);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to init NIC driver\n");
+			goto out_err;
+		}
+
 		hl_set_max_power(hdev);
 	} else {
 		rc = hdev->asic_funcs->soft_reset_late_init(hdev);
@@ -1318,6 +1324,13 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 		goto out_disabled;
 	}
 
+	rc = hdev->asic_funcs->nic_init(hdev);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to init NIC driver\n");
+		rc = 0;
+		goto out_disabled;
+	}
+
 	/*
 	 * Expose devices and sysfs nodes to user.
 	 * From here there is no need to add char devices and create sysfs nodes
@@ -1469,6 +1482,11 @@ void hl_device_fini(struct hl_device *hdev)
 
 	hl_cb_pool_fini(hdev);
 
+	/* the NIC uses the kernel context for MMU mappings, therefore must be
+	 * cleaned before it
+	 */
+	hdev->asic_funcs->nic_fini(hdev);
+
 	/* Release kernel context */
 	if ((hdev->kernel_ctx) && (hl_ctx_put(hdev->kernel_ctx) != 1))
 		dev_err(hdev->dev, "kernel ctx is still alive\n");
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 65bc2527338b..d6130715a0ef 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -697,6 +697,10 @@ struct hl_info_mac_addr;
  *                    then the timeout is the default timeout for the specific
  *                    ASIC
  * @get_hw_state: retrieve the H/W state
+ * @nic_init: init the NIC H/W and I/F. This should be called in the final satge
+ *            of the init flow, as we must not have anything that might fail
+ *            during its initialization after the NIC init.
+ * @nic_fini: perform NIC cleanup.
  * @nic_control: Perform NIC related operations.
  * @nic_cq_mmap: map the NIC CQ buffer.
  * @pci_bars_map: Map PCI BARs.
@@ -803,6 +807,8 @@ struct hl_asic_funcs {
 	int (*send_cpu_message)(struct hl_device *hdev, u32 *msg,
 				u16 len, u32 timeout, long *result);
 	enum hl_device_hw_state (*get_hw_state)(struct hl_device *hdev);
+	int (*nic_init)(struct hl_device *hdev);
+	void (*nic_fini)(struct hl_device *hdev);
 	int (*nic_control)(struct hl_device *hdev, u32 op, void *input,
 				void *output);
 	int (*nic_cq_mmap)(struct hl_device *hdev, struct vm_area_struct *vma);
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index b7fbbe8f2577..e99e84b6a787 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -242,6 +242,7 @@ static void set_driver_behavior_per_device(struct hl_device *hdev)
 	hdev->bmc_enable = 1;
 	hdev->hard_reset_on_fw_events = 1;
 	hdev->card_type = cpucp_card_type_pci;
+	hdev->nic_ports_mask = 0x3FF;
 	hdev->nic_ports_ext_mask = 0x3FF;
 	hdev->nic_auto_neg_mask = 0x3FF;
 	hdev->nic_load_fw = 0;
diff --git a/drivers/misc/habanalabs/common/pci.c b/drivers/misc/habanalabs/common/pci.c
index 923b2606e29f..c376ab4695ab 100644
--- a/drivers/misc/habanalabs/common/pci.c
+++ b/drivers/misc/habanalabs/common/pci.c
@@ -230,6 +230,7 @@ int hl_pci_set_inbound_region(struct hl_device *hdev, u8 region,
 			lower_32_bits(pci_region->addr));
 	rc |= hl_pci_iatu_write(hdev, offset + 0x18,
 			upper_32_bits(pci_region->addr));
+	/* Set bar type as memory */
 	rc |= hl_pci_iatu_write(hdev, offset + 0x0, 0);
 
 	/* Enable + bar/address match + match enable + bar number */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 2af07eb4165c..836391ddb890 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -883,6 +883,27 @@ static void gaudi_late_fini(struct hl_device *hdev)
 	hdev->hl_chip_info->info = NULL;
 }
 
+static int gaudi_nic_init(struct hl_device *hdev)
+{
+	/*
+	 * In init flow we initialize the NIC ports from scratch. In hard reset
+	 * flow, we get here after the NIC ports were halted, hence we only
+	 * need to reopen them.
+	 */
+	if (atomic_read(&hdev->in_reset)) {
+		gaudi_nic_ports_reopen(hdev);
+		return 0;
+	}
+
+	return gaudi_nic_ports_init(hdev);
+}
+
+static void gaudi_nic_fini(struct hl_device *hdev)
+{
+	/* must be called after MSI was disabled */
+	gaudi_nic_ports_fini(hdev);
+}
+
 static void gaudi_nic_handle_rx(struct gaudi_nic_device *gaudi_nic)
 {
 	/* at this point, interrupts were disabled by the H/W */
@@ -7484,6 +7505,8 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.get_eeprom_data = gaudi_get_eeprom_data,
 	.send_cpu_message = gaudi_send_cpu_message,
 	.get_hw_state = gaudi_get_hw_state,
+	.nic_init = gaudi_nic_init,
+	.nic_fini = gaudi_nic_fini,
 	.nic_control = gaudi_nic_control,
 	.nic_cq_mmap = gaudi_nic_cq_mmap,
 	.pci_bars_map = gaudi_pci_bars_map,
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 9620654eefae..76f855fbc4d5 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5269,6 +5269,16 @@ static enum hl_device_hw_state goya_get_hw_state(struct hl_device *hdev)
 	return RREG32(mmHW_STATE);
 }
 
+static int goya_nic_init(struct hl_device *hdev)
+{
+	return 0;
+}
+
+static void goya_nic_fini(struct hl_device *hdev)
+{
+
+}
+
 static int goya_nic_control(struct hl_device *hdev, u32 op, void *input,
 			void *output)
 {
@@ -5409,6 +5419,8 @@ static const struct hl_asic_funcs goya_funcs = {
 	.get_eeprom_data = goya_get_eeprom_data,
 	.send_cpu_message = goya_send_cpu_message,
 	.get_hw_state = goya_get_hw_state,
+	.nic_init = goya_nic_init,
+	.nic_fini = goya_nic_fini,
 	.nic_control = goya_nic_control,
 	.nic_cq_mmap = goya_nic_mmap,
 	.pci_bars_map = goya_pci_bars_map,
-- 
2.17.1

