Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808666864B2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjBAKrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjBAKrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:47:40 -0500
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC0CE07F;
        Wed,  1 Feb 2023 02:47:34 -0800 (PST)
X-QQ-mid: bizesmtp84t1675248448tdzpzyjx
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 01 Feb 2023 18:47:19 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: mRz6/7wsmIiZXE+WMmlPlkdiRcFKIXrtEMNO+b2E8/DEinrgMTAMRDXoaYlIL
        hIsaS7I4soDqqXiHDFt7DOcOn+hxQL3oLTxDzo5uniC7x1YV0v7Dm+LTAIn7Lu+L/GPNCte
        sYNoLiTTdc4WjISzYoSB4Kg2PUqiJuBgMx3i0hFLufuZ6xWtiC6KXztQVYiHr5zuhQoXwYz
        UjpLuBprtIwRKSBQ4GsNloXUnMErX0eUuLp1NpqjC9/t/2VUFJsHt+LGiD83RhQPd78gZVW
        gRU/9TYzOwYnAS74Ou0Q3Nr00jsdEQK7viCwgcwla5tBMi1YnZgLuh+wbnnMEpmESd+53xn
        CMlieYRJIYK1TLTzd/Fxl/bR/L1QbcZK1rpObhAyGuC5jn1wlMmr+pLWlOGdN9nIy+137Sz
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Date:   Wed,  1 Feb 2023 18:47:03 +0800
Message-Id: <20230201104703.82511-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Wangxun 1G/10G NICs may be multi-function devices. They do
not advertise ACS capability.
Add an ACS quirk for these devices so the functions can be in
independent IOMMU groups.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/pci/quirks.c    | 20 ++++++++++++++++++++
 include/linux/pci_ids.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 285acc4aaccc..9daa4a07c67d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4835,6 +4835,24 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Wangxun 10G/1G nics have no ACS capability.
+ * But the implementation could block peer-to-peer transactions between them
+ * and provide ACS-like functionality.
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
@@ -4980,6 +4998,8 @@ static const struct pci_dev_acs_enabled {
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

