Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F140DE5B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhIPPqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:46:03 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33082
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239386AbhIPPqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 11:46:00 -0400
Received: from HP-EliteBook-840-G7.. (1-171-209-135.dynamic-ip.hinet.net [1.171.209.135])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F0A2E40185;
        Thu, 16 Sep 2021 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631807079;
        bh=4NmtIFJjyCaa4mu98UgP5WyoGLNbTsxso4yOr8yDXWg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=haOMAIryEZq7Tn/eE3jiYK3mEQdWfWtOcpmuXbgn4nzg+AZcrFT+rAQIPSamttues
         g3G6dj3nxCv7dy2rmNLthcYXg8+IOt8Jj3ZjesbHsa5Egc9XqOSfGMijAwubWydBD6
         6RQ2oMKDBl39j2F8DkAsG2XYSTq5C3YFTiGV/Nc0hnAzFPldqprXrJVhg6spLU8gtG
         va8s4zR4XPlg8Ih2Hg/MDA4HZwkyr60g/7tdObqGcnmVGNav6aBaaG/tzgNeG7lupj
         Rxj70EQ00tnTNROVJjPD49Q7sC9VOV6RWtH2FYE8VCWMe3updpu6lvkcd2l3jdujtF
         F9Gknmba1Ebjg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v5 2/3] r8169: Use PCIe ASPM status for NIC ASPM enablement
Date:   Thu, 16 Sep 2021 23:44:16 +0800
Message-Id: <20210916154417.664323-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916154417.664323-1-kai.heng.feng@canonical.com>
References: <20210916154417.664323-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because ASPM control may not be granted by BIOS while ASPM is enabled,
and ASPM can be enabled via sysfs, so use pcie_aspm_enabled() directly
to check current ASPM enable status.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v5:
 - New patch.

 drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0199914440abc..6f1a9bec40c05 100644
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
+	/* Don't enable ASPM in the chip if PCIe ASPM isn't enabled */
+	if (!pcie_aspm_enabled(pdev) && enable)
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

