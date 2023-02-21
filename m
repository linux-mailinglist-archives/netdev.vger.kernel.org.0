Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B95169D8A6
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjBUCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjBUCkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:40:19 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E1E2366F;
        Mon, 20 Feb 2023 18:40:06 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E0B313F158;
        Tue, 21 Feb 2023 02:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676947204;
        bh=pNqvuelCqk4rJCSN7tzVgxEDAb98YmVWBtwNCRfo4Z4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MwBE1XbJiP9QiFG4cII20s/diEPXbwaB7gsgsu+UAmZvNnvs91uPrPygCCwNxU0bL
         ZPix4E3Shilh7Har52hC6wziquvj2bgg7Gg31P5Vxi6O/XputkUIPujcnZZN+pUqGy
         4Pi+uNKUdRUf0ACaziyc4RcHBGtefCBh2ifWCFoSnbnVSys1UJUtVudQKYExPBi4nU
         N3PvQe93TZAVWjPfkJfygfad/vB4SoX0IWG/YWBF96pvfZHGkUMMXnUiMX1NVTRTfQ
         TP1VGq/1IzBYWQR7uQRbMwS42IyiEEBdFDDv/zK2s7J8V2TGfYQJjbV+NvgvTgAzHy
         a8Uk9iUKnVPBg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v8 RESEND 4/6] r8169: Consider chip-specific ASPM can be enabled on more cases
Date:   Tue, 21 Feb 2023 10:38:47 +0800
Message-Id: <20230221023849.1906728-5-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
chip-specific ASPM have to be enabled at the same time.

Before enabling ASPM at chip side, make sure the following conditions
are met:
1) Use pcie_aspm_support_enabled() to check if ASPM is disabled by
   kernel parameter.
2) Use pcie_aspm_capable() to see if the device is capable to perform
   PCIe ASPM.
3) Check the return value of pci_disable_link_state(). If it's -EPERM,
   it means BIOS doesn't grant ASPM control to OS, and device should use
   the ASPM setting as is

Consider ASPM is manageable when those conditions are met.

While at it, disable ASPM at chip-side for TX timeout reset, since
pci_disable_link_state() doesn't have any effect when OS isn't granted
with ASPM control.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v8:
 - Enable chip-side ASPM only when PCIe ASPM is already available.
 - Wording.

v7:
 - No change.

v6:
 - Unconditionally enable chip-specific ASPM.

v5:
 - New patch.

 drivers/net/ethernet/realtek/r8169_main.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1c949822661ae..e40498dd08d17 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2675,8 +2675,11 @@ static void rtl_disable_exit_l1(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
-	/* Don't enable ASPM in the chip if OS can't control ASPM */
-	if (enable && tp->aspm_manageable) {
+	/* Skip if PCIe ASPM isn't possible */
+	if (!tp->aspm_manageable)
+		return;
+
+	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 
@@ -4545,8 +4548,13 @@ static void rtl_task(struct work_struct *work)
 		/* ASPM compatibility issues are a typical reason for tx timeouts */
 		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
 							  PCIE_LINK_STATE_L0S);
+
+		/* OS may not be granted to control PCIe ASPM, prevent the driver from using it */
+		tp->aspm_manageable = 0;
+
 		if (!ret)
 			netdev_warn_once(tp->dev, "ASPM disabled on Tx timeout\n");
+
 		goto reset;
 	}
 
@@ -5227,13 +5235,19 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Chips from RTL8168h partially have issues with L1.1 and L1.2, but
 	 * seem to work fine with L1.
 	 */
-	if (rtl_aspm_is_safe(tp))
+	if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
+		rc = -EINVAL;
+	else if (rtl_aspm_is_safe(tp))
 		rc = 0;
 	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_1 | PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
+
+	/* -EPERM means BIOS doesn't grant OS ASPM control, ASPM should be use
+	 * as is. Honor it.
+	 */
+	tp->aspm_manageable = (rc == -EPERM) ? 1 : !rc;
 
 	tp->dash_type = rtl_check_dash(tp);
 
-- 
2.34.1

