Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C9D3F12E8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 07:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhHSFrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 01:47:00 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39452
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhHSFqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 01:46:54 -0400
Received: from localhost.localdomain (1-171-223-154.dynamic-ip.hinet.net [1.171.223.154])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C0EFC40C9D;
        Thu, 19 Aug 2021 05:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629351976;
        bh=6GWWIzDjc4L/ju2yv/2mn2NZsjtrX1blIUII0KdOUHk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=NtTBMkjwyfC9vlN74FGQtPNy6t9Y/dC4HSx2gRgzQfuZV6OnE85fLn5CiFeKmXb3Y
         RftilwgFybmWLvXBR/nZFEhl8f5EPEKOzrdkURBWDruOATKRctRvXrILDtD4JzggLE
         FfUwob32NFd+EuKv+pz7jtSrs685ijIoAS4pTeWR3rxk/BwhHvMHbdypzzbT1gVrBS
         3//E98xG0vdbxTRkLXIWnh8V7BfuzgruCNTOZ3BXiMmI6OsJNUuGjAXSQv0xDs2t0G
         /CCIi0Q/HbxuBwIlrbPwoEYl7XF9cQTbC4QbmBa0a81RwTPcsWmqvOvRrG2XA0LrQq
         tyO6M71igyfMQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v3 3/3] r8169: Enable ASPM for selected NICs
Date:   Thu, 19 Aug 2021 13:45:42 +0800
Message-Id: <20210819054542.608745-4-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819054542.608745-1-kai.heng.feng@canonical.com>
References: <20210819054542.608745-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The latest vendor driver enables ASPM for more recent r8168 NICs, so
disable ASPM on older chips and enable ASPM for the rest.

Rename aspm_manageable to pcie_aspm_manageable to indicate it's ASPM
from PCIe, and use rtl_aspm_supported for Realtek NIC's internal ASPM
function.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v3:
 - Use pcie_aspm_supported() to retrieve ASPM support status
 - Use whitelist for r8169 internal ASPM status

v2:
 - No change

 drivers/net/ethernet/realtek/r8169_main.c | 27 ++++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3359509c1c351..88e015d93e490 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -623,7 +623,8 @@ struct rtl8169_private {
 	} wk;
 
 	unsigned supports_gmii:1;
-	unsigned aspm_manageable:1;
+	unsigned pcie_aspm_manageable:1;
+	unsigned rtl_aspm_supported:1;
 	unsigned rtl_aspm_enabled:1;
 	struct delayed_work aspm_toggle;
 	atomic_t aspm_packet_count;
@@ -702,6 +703,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 	       tp->mac_version <= RTL_GIGA_MAC_VER_53;
 }
 
+static int rtl_supports_aspm(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_31:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_39:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_47:
+		return 0;
+	default:
+		return 1;
+	}
+}
+
 static bool rtl_supports_eee(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
@@ -2669,7 +2684,7 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
-	if (!tp->aspm_manageable && enable)
+	if (!(tp->pcie_aspm_manageable && tp->rtl_aspm_supported) && enable)
 		return;
 
 	tp->rtl_aspm_enabled = enable;
@@ -5319,12 +5334,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM completely as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
-					  PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
+	tp->pcie_aspm_manageable = pcie_aspm_supported(pdev);
+	tp->rtl_aspm_supported = rtl_supports_aspm(tp);
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.32.0

