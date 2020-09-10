Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2478B264978
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIJQOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA04C0617A0;
        Thu, 10 Sep 2020 09:12:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id u21so9551914eja.2;
        Thu, 10 Sep 2020 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PPUHmhNkM3clI/FRO8oFz2HVwSTGOnBMXUedMDl1l20=;
        b=d0dh+hUTpmyuI+yHzRxM4NeQjjik8gILIxcc74eoFlFzgxKG6hIxjkY+yys6NYr2JJ
         uccWHvTgJsCKiSmzhsQK6hWKpWbWfMT5cEEpbQy+RuG4Fmd5pH62lJIO2+RkNxPyJqLf
         n2egQxfLXPx6V0c+pX6Sor+AQrYRBq5Xcr+aQqfxWxeS0fPsPBURPCtD883p84SXlmYq
         63VHNp7bJZ1FIYvQ+k9aT1pGK5e01n/3pksTHTsimWuii6uRnEjfqxC+p+UWGrhCj8oL
         GslunbupA3n8qWI08Vix1gUdIeMsv0JqqJna8EeqIK+5FJ5k6skVwl/Gw/NltBB46I9T
         ssqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PPUHmhNkM3clI/FRO8oFz2HVwSTGOnBMXUedMDl1l20=;
        b=pKO+gizXhC3qfWWI0hckL8POEHN+1sjwyFwwpnYnBmC0vVRrrf3q/uuI+Bt2xk+NPw
         p0rND3pt8VVlN328YK6fDIHzkmpCR7yYR5KGzi4Yx0YbshzyQpWM4DtwHlBvOp4xpfxe
         yJHFUhGsBrXJDNA5DhlWnPSOdSDQWQSJqBbgnZUYOapzhF81i9zNg2VOW1z6yBZr7LvO
         Ms5w0MdEIV6UMcG6LD0Tf36KZI0Bke83lvXiNlVlte2D5LtOQ+OmCJQJjiPDyRFyg8MH
         pLDysDM2nmtVs26t7VzHPYWFL5717rjccRo5/L2D6xriOdxFqsUFyqKdo88yb1JmgVrU
         PwTA==
X-Gm-Message-State: AOAM533MhOox7eXCu/dYS4nCdkGrGaQxR0VCpFNSP+6R8/p7Z7AulaGl
        NwjY9Cmvyu5mQVjU83wDq0dBtHCzor0=
X-Google-Smtp-Source: ABdhPJzzxYcX+rjrX+Gpc322klSdJtPAJxDZ98qdNwB0NJ02js96AFcQVP7iKLBKipNZCTG+Zh9qWQ==
X-Received: by 2002:a17:906:3ad0:: with SMTP id z16mr10026141ejd.193.1599754322600;
        Thu, 10 Sep 2020 09:12:02 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:11:59 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 07/15] habanalabs/gaudi: allow user to get MAC addresses in INFO IOCTL
Date:   Thu, 10 Sep 2020 19:11:18 +0300
Message-Id: <20200910161126.30948-8-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

The user needs this information when working in a distributed environment
with master/slave configuration. All the slaves get their MAC addresses
from the driver and send them to the master.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/habanalabs.h   |  5 +++
 .../misc/habanalabs/common/habanalabs_ioctl.c | 31 +++++++++++++++++++
 drivers/misc/habanalabs/gaudi/gaudi.c         |  1 +
 drivers/misc/habanalabs/gaudi/gaudiP.h        |  2 ++
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 27 ++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |  9 ++++++
 include/uapi/misc/habanalabs.h                | 20 +++++++++++-
 7 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index f99db3483ba4..6bfef3da6e61 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -602,6 +602,8 @@ enum div_select_defs {
 	DIV_SEL_DIVIDED_PLL = 3,
 };
 
+struct hl_info_mac_addr;
+
 /**
  * struct hl_asic_funcs - ASIC specific functions that are can be called from
  *                        common code.
@@ -679,6 +681,7 @@ enum div_select_defs {
  * @get_hw_state: retrieve the H/W state
  * @pci_bars_map: Map PCI BARs.
  * @init_iatu: Initialize the iATU unit inside the PCI controller.
+ * @get_mac_addr: Get list of MAC addresses.
  * @rreg: Read a register. Needed for simulator support.
  * @wreg: Write a register. Needed for simulator support.
  * @halt_coresight: stop the ETF and ETR traces.
@@ -782,6 +785,8 @@ struct hl_asic_funcs {
 	enum hl_device_hw_state (*get_hw_state)(struct hl_device *hdev);
 	int (*pci_bars_map)(struct hl_device *hdev);
 	int (*init_iatu)(struct hl_device *hdev);
+	int (*get_mac_addr)(struct hl_device *hdev,
+				struct hl_info_mac_addr *mac_addr);
 	u32 (*rreg)(struct hl_device *hdev, u32 reg);
 	void (*wreg)(struct hl_device *hdev, u32 reg, u32 val);
 	void (*halt_coresight)(struct hl_device *hdev);
diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 07317ea49129..01425b821828 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -203,6 +203,33 @@ static int debug_coresight(struct hl_device *hdev, struct hl_debug_args *args)
 	return rc;
 }
 
+static int mac_addr_info(struct hl_device *hdev, struct hl_info_args *args)
+{
+	struct hl_info_mac_addr *mac_addr;
+	u32 max_size = args->return_size;
+	void __user *out = (void __user *) (uintptr_t) args->return_pointer;
+	int rc;
+
+	if (!max_size || !out)
+		return -EINVAL;
+
+	mac_addr = kzalloc(sizeof(struct hl_info_mac_addr), GFP_KERNEL);
+	if (!mac_addr)
+		return -ENOMEM;
+
+	rc = hdev->asic_funcs->get_mac_addr(hdev, mac_addr);
+	if (rc)
+		goto out;
+
+	rc = copy_to_user(out, mac_addr,
+		min((size_t) max_size, sizeof(struct hl_info_mac_addr))) ?
+								-EFAULT : 0;
+
+out:
+	kfree(mac_addr);
+	return rc;
+}
+
 static int device_utilization(struct hl_device *hdev, struct hl_info_args *args)
 {
 	struct hl_info_device_utilization device_util = {0};
@@ -423,6 +450,10 @@ static int _hl_info_ioctl(struct hl_fpriv *hpriv, void *data,
 		rc = hw_idle(hdev, args);
 		break;
 
+	case HL_INFO_MAC_ADDR:
+		rc = mac_addr_info(hdev, args);
+		break;
+
 	case HL_INFO_DEVICE_UTILIZATION:
 		rc = device_utilization(hdev, args);
 		break;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index d350519a9e31..8ce20e0f8c59 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7470,6 +7470,7 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.get_hw_state = gaudi_get_hw_state,
 	.pci_bars_map = gaudi_pci_bars_map,
 	.init_iatu = gaudi_init_iatu,
+	.get_mac_addr = gaudi_nic_get_mac_addr,
 	.rreg = hl_rreg,
 	.wreg = hl_wreg,
 	.halt_coresight = gaudi_halt_coresight,
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index bf3a215e0f8e..17560510a05f 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -566,6 +566,8 @@ void gaudi_nic_ports_fini(struct hl_device *hdev);
 int gaudi_nic_hard_reset_prepare(struct hl_device *hdev);
 void gaudi_nic_stop(struct hl_device *hdev);
 void gaudi_nic_ports_reopen(struct hl_device *hdev);
+int gaudi_nic_get_mac_addr(struct hl_device *hdev,
+				struct hl_info_mac_addr *mac_addr);
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx);
 irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg);
 irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg);
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index ff08cfc81e69..491f426ab0bb 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -2743,6 +2743,33 @@ void gaudi_nic_ports_reopen(struct hl_device *hdev)
 	gaudi->hw_cap_initialized |= HW_CAP_NIC_DRV;
 }
 
+int gaudi_nic_get_mac_addr(struct hl_device *hdev,
+				struct hl_info_mac_addr *mac_addr)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct net_device *ndev;
+	int i, number_of_ports;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV))
+		goto out;
+
+	number_of_ports = min_t(int, NIC_NUMBER_OF_PORTS,
+				HL_INFO_MAC_ADDR_MAX_NUM);
+
+	for (i = 0 ; i < number_of_ports ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		ndev = gaudi->nic_devices[i].ndev;
+		if (!ndev)
+			continue;
+
+		ether_addr_copy(mac_addr->array[i].addr, ndev->dev_addr);
+		mac_addr->mask[i / 64] |= BIT_ULL(i % 64);
+	}
+out:
+	return 0;
+}
 void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
 {
 }
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 8e15d9f85af8..e49ee24cde50 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5265,6 +5265,14 @@ static enum hl_device_hw_state goya_get_hw_state(struct hl_device *hdev)
 	return RREG32(mmHW_STATE);
 }
 
+static int goya_get_mac_addr(struct hl_device *hdev,
+			struct hl_info_mac_addr *mac_addr)
+{
+	dev_err_ratelimited(hdev->dev,
+				"No MAC addresses are assigned to Goya\n");
+	return -ENXIO;
+}
+
 static int goya_ctx_init(struct hl_ctx *ctx)
 {
 	return 0;
@@ -5384,6 +5392,7 @@ static const struct hl_asic_funcs goya_funcs = {
 	.get_hw_state = goya_get_hw_state,
 	.pci_bars_map = goya_pci_bars_map,
 	.init_iatu = goya_init_iatu,
+	.get_mac_addr = goya_get_mac_addr,
 	.rreg = hl_rreg,
 	.wreg = hl_wreg,
 	.halt_coresight = goya_halt_coresight,
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index e8a5b62b95dd..cd600a52f40a 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/if_ether.h>
 
 /*
  * Defines that are asic-specific but constitutes as ABI between kernel driver
@@ -248,6 +249,8 @@ enum hl_device_status {
  *                         internal engine.
  * HL_INFO_DEVICE_STATUS - Retrieve the device's status. This opcode doesn't
  *                         require an open context.
+ * HL_INFO_MAC_ADDR      - Retrieve the list of MAC addresses of the device's
+ *                         network ports, if the device has network ports.
  * HL_INFO_DEVICE_UTILIZATION  - Retrieve the total utilization of the device
  *                               over the last period specified by the user.
  *                               The period can be between 100ms to 1s, in
@@ -274,6 +277,7 @@ enum hl_device_status {
 #define HL_INFO_DRAM_USAGE		2
 #define HL_INFO_HW_IDLE			3
 #define HL_INFO_DEVICE_STATUS		4
+#define HL_INFO_MAC_ADDR		5
 #define HL_INFO_DEVICE_UTILIZATION	6
 #define HL_INFO_HW_EVENTS_AGGREGATE	7
 #define HL_INFO_CLK_RATE		8
@@ -285,9 +289,11 @@ enum hl_device_status {
 #define HL_INFO_SYNC_MANAGER		14
 #define HL_INFO_TOTAL_ENERGY		15
 
-#define HL_INFO_VERSION_MAX_LEN	128
+#define HL_INFO_VERSION_MAX_LEN		128
 #define HL_INFO_CARD_NAME_MAX_LEN	16
 
+#define HL_INFO_MAC_ADDR_MAX_NUM	128
+
 struct hl_info_hw_ip_info {
 	__u64 sram_base_address;
 	__u64 dram_base_address;
@@ -334,6 +340,18 @@ struct hl_info_device_status {
 	__u32 pad;
 };
 
+struct hl_mac_addr {
+	__u8 addr[ETH_ALEN];
+	__u8 pad[2];
+};
+
+struct hl_info_mac_addr {
+	/* MAC address at index N is of the corresponding PORT ID */
+	struct hl_mac_addr array[HL_INFO_MAC_ADDR_MAX_NUM];
+	/* Mask of valid entries at the MAC addresses array */
+	__u64 mask[2];
+};
+
 struct hl_info_device_utilization {
 	__u32 utilization;
 	__u32 pad;
-- 
2.17.1

