Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D9447ED07
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 09:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351940AbhLXITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 03:19:38 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48404
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234111AbhLXITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 03:19:37 -0500
Received: from HP-EliteBook-840-G7.. (223-136-216-233.emome-ip.hinet.net [223.136.216.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 467AA3F13C;
        Fri, 24 Dec 2021 08:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640333970;
        bh=tENeFL8WIaSJFgGkKxOkudMuoVpt2IzxtUkKeonnshU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Ie9bN0vs+0tdUcGcmrHpsvYo30eEaNLYBLL8kXIa9Bdcu/47Tve2Pcma8uxC58VSV
         OpI50ftVQz8wZ5aY3ZvRZyzLK0/rjdU3qKwzbhbHu4WvL+NZx/R1fnhzThTI5Us/Qa
         96VR8fFI8Q8iLuz6OHz9qZ8zwX45hidIrL6FMoLMO87yBUnmF8U7BK/wJjDWYvfJrm
         9Cj/HTHNL34IWeCHWOB4tUHuQP4A9gJy6oSxhplfSlnJoV8LMZ1jYYnt7I2Bk6JHti
         iMTOS59VULu9CPtxUMdrrsS6EPiCW+P0dHp4EdJo8sFKwvG/heZtbNTD2sc4NWopwn
         am4pQLbnBjbEw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com
Cc:     linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: wwan: iosm: Let PCI core handle PCI power transition
Date:   Fri, 24 Dec 2021 16:19:13 +0800
Message-Id: <20211224081914.345292-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_pm_suspend_noirq() and pci_pm_resume_noirq() already handle power
transition for system-wide suspend and resume, so it's not necessary to
do it in the driver.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 49 ++-------------------------
 1 file changed, 2 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 2fe88b8be3481..d73894e2a84ed 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -363,67 +363,22 @@ static int __maybe_unused ipc_pcie_resume_s2idle(struct iosm_pcie *ipc_pcie)
 
 int __maybe_unused ipc_pcie_suspend(struct iosm_pcie *ipc_pcie)
 {
-	struct pci_dev *pdev;
-	int ret;
-
-	pdev = ipc_pcie->pci;
-
-	/* Execute D3 one time. */
-	if (pdev->current_state != PCI_D0) {
-		dev_dbg(ipc_pcie->dev, "done for PM=%d", pdev->current_state);
-		return 0;
-	}
-
 	/* The HAL shall ask the shared memory layer whether D3 is allowed. */
 	ipc_imem_pm_suspend(ipc_pcie->imem);
 
-	/* Save the PCI configuration space of a device before suspending. */
-	ret = pci_save_state(pdev);
-
-	if (ret) {
-		dev_err(ipc_pcie->dev, "pci_save_state error=%d", ret);
-		return ret;
-	}
-
-	/* Set the power state of a PCI device.
-	 * Transition a device to a new power state, using the device's PCI PM
-	 * registers.
-	 */
-	ret = pci_set_power_state(pdev, PCI_D3cold);
-
-	if (ret) {
-		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
-		return ret;
-	}
-
 	dev_dbg(ipc_pcie->dev, "SUSPEND done");
-	return ret;
+	return 0;
 }
 
 int __maybe_unused ipc_pcie_resume(struct iosm_pcie *ipc_pcie)
 {
-	int ret;
-
-	/* Set the power state of a PCI device.
-	 * Transition a device to a new power state, using the device's PCI PM
-	 * registers.
-	 */
-	ret = pci_set_power_state(ipc_pcie->pci, PCI_D0);
-
-	if (ret) {
-		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
-		return ret;
-	}
-
-	pci_restore_state(ipc_pcie->pci);
-
 	/* The HAL shall inform the shared memory layer that the device is
 	 * active.
 	 */
 	ipc_imem_pm_resume(ipc_pcie->imem);
 
 	dev_dbg(ipc_pcie->dev, "RESUME done");
-	return ret;
+	return 0;
 }
 
 static int __maybe_unused ipc_pcie_suspend_cb(struct device *dev)
-- 
2.33.1

