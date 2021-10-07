Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F942578C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242640AbhJGQSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:18:53 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:54002
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242622AbhJGQSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:18:49 -0400
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 14C223FFDC;
        Thu,  7 Oct 2021 16:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633623414;
        bh=Pjg/6a07RHka1XO/WoTI/1mEFOZ/Ab+WfS6Fv7hCTRw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=G2JekpNLXdJwJNJSqQcNH7/WBuFozGNqAzNh31G2gcFzhpvfiwkN8mekyHfLKAHKT
         KbThh8hnlaHWL4LCe0RRkFgI797ddEyfKBiInyRfaM2pGEa7nVMgBZuVFMIS3d/Lww
         p6QQ9gcLLUE3If2j6DTxcwm9pJxB2shq5rFguOfmlxkUNMaOv7UpInRflgcRNGImvy
         F7mVLBipdkmL7k0zad9kSiiXjX7I9Q8HA2A2HNnbQSp2ZKmV4OFIX6eFeuRpDprchs
         xhdcpytxOLzD4fddrFjQFQtUTdM7+uRw/+bbaRu9mgKhIrByxPq3mOV6kt2rSrg9IM
         0NOkTYBjWTffQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v6 2/3] r8169: Enable chip-specific ASPM regardless of PCIe ASPM status
Date:   Fri,  8 Oct 2021 00:15:51 +0800
Message-Id: <20211007161552.272771-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211007161552.272771-1-kai.heng.feng@canonical.com>
References: <20211007161552.272771-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
chip-specific ASPM have to be enabled at the same time.

Since PCIe ASPM can be enabled or disabled vis sysfs and there's no
mechanism to notify driver about ASPM change, unconditionally enable
chip-specific ASPM to make ASPM really take into effect.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v6:
 - Unconditionally enable chip-specific ASPM.

v5:
 - New patch.

 drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0199914440abc..53936ebb3b3a6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -622,7 +622,6 @@ struct rtl8169_private {
 	} wk;
 
 	unsigned supports_gmii:1;
-	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -2664,8 +2663,13 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
-	/* Don't enable ASPM in the chip if OS can't control ASPM */
-	if (enable && tp->aspm_manageable) {
+	struct pci_dev *pdev = tp->pci_dev;
+
+	/* Skip if PCIe ASPM isn't possible */
+	if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
+		return;
+
+	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 	} else {
@@ -5272,8 +5276,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disable ASPM L1 as that cause random device stop working
 	 * problems as well as full system hangs for some PCIe devices users.
 	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.32.0

