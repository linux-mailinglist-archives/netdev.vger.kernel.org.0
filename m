Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C724300FA
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243844AbhJPH5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:57:18 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59624
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239780AbhJPH5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:57:16 -0400
Received: from HP-EliteBook-840-G7.. (36-229-230-94.dynamic-ip.hinet.net [36.229.230.94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8EAA941B97;
        Sat, 16 Oct 2021 07:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634370908;
        bh=ks4EMfJg/egcfAoIsAktLMa4qabsfSpvzb0PW64b30Q=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=m69cEWGg7bX6fjr5Eyse2DGGBU81swiTj/yccQ38+nTUIYLW0hu/6w7HV75R5VPlR
         aK6x+gxvys09xLE7DkbKJ+TMWS3yviyKI/3s2OLWj85UcfMMk1QSH/7NWAjnTDf5u/
         /FHaw2q8lbrn5ifySEHL0idIQFLZ1PVgEfk2aWP42UmrZMAxsn7FYb09Xr722vLPX+
         q7f3zQ8ckdDkMwZgZppOuZBo1mF2Kdehx79GV8gPXMJv1dTrDFge3QpKPvMhtD+mEw
         HHBGY99ufikTgbaUWTnQV5FczVhMejKuOrtg7qFlW+olzBM5qhOLsGQjnpQlMsZaG5
         ZyKpX4OGM2VOA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v7 2/4] r8169: Enable chip-specific ASPM regardless of PCIe ASPM status
Date:   Sat, 16 Oct 2021 15:54:40 +0800
Message-Id: <20211016075442.650311-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211016075442.650311-1-kai.heng.feng@canonical.com>
References: <20211016075442.650311-1-kai.heng.feng@canonical.com>
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
v7:
 - No change.

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

