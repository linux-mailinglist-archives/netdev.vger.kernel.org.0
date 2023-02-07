Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1A68D402
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjBGKYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjBGKYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:24:48 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F5D14E91;
        Tue,  7 Feb 2023 02:24:44 -0800 (PST)
X-QQ-mid: bizesmtp74t1675765469t046cmuq
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 07 Feb 2023 18:24:21 +0800 (CST)
X-QQ-SSF: 01400000000000N0O000000A0000000
X-QQ-FEAT: DEYZVVH8UvaUhz20yiyS4xvpoiESqoIfRbgYmzjo2Y9lp5bl4IkPZ6C+2Q58B
        /4iromrIq872i8Mh9oT1hXH78xj7f59LDrZpCosDQbVAv2ZJTs1rIr8zn9WyGs+09cB5hKC
        qyE0V6f1fZZohydD0gdR+K0s0i3nKCm3Y2afM0+V8SQY/+BqtZC+xWh2fsrBMKG30OIJyGh
        qyLUl/pKIPoC6XV99ILXhqnQTKFu+BGQdWOZnH1kTWlsme5jyl2l+fM4gDIGy64VXsgQJNt
        4mN2gdumtik6Dqd5k6oiR7nk+eZhTTs4D/uQQA4mTvnAnV9KS3c/eB/O47T396OJqRsurU2
        5ITEhF7RywlkQtmCSZlFW/82bKAQJh4BIIGFjdxNwigs1nP3x3OUQnNPJ+LZ6N9ByY/S9xF
        tzHEYWb1Szz/MJGuYy/InQ==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, helgaas@kernel.org,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Date:   Tue,  7 Feb 2023 18:24:19 +0800
Message-Id: <20230207102419.44326-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wangxun has verified there is no peer-to-peer between functions for the
below selection of SFxxx, RP1000 and RP2000 NICS.
They may be multi-function device, but the hardware does not advertise
ACS capability.

Add an ACS quirk for these devices so the functions can be in
independent IOMMU groups.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/pci/quirks.c    | 22 ++++++++++++++++++++++
 include/linux/pci_ids.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 285acc4aaccc..13290048beda 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4835,6 +4835,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
+ * devices, peer-to-peer transactions are not be used between the functions.
+ * So add an ACS quirk for below devices to isolate functions.
+ * SFxxx 1G NICs(em).
+ * RP1000/RP2000 10G NICs(sp).
+ */
+static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	switch (dev->device) {
+	case 0x0100 ... 0x010F:
+	case 0x1001:
+	case 0x2001:
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	}
+
+	return false;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -4980,6 +5000,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b362d90eb9b0..bc8f484cdcf3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3012,6 +3012,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
-- 
2.39.1

