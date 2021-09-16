Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2940DE58
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbhIPPqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:46:02 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33056
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231702AbhIPPp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 11:45:56 -0400
Received: from HP-EliteBook-840-G7.. (1-171-209-135.dynamic-ip.hinet.net [1.171.209.135])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8B114412AC;
        Thu, 16 Sep 2021 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631807075;
        bh=R1Vt6j76+tfJTpRebzXGf6da6nGIfcE2GPxSs6Ets98=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hkrlLC+rxhYeV9HCe8JCTimSwtyAnFbiGg0902pEI4zoyzRT2SQLVzAAOLMS/wdcD
         z1YNVA8le1BaTBm0PCo1QQfAIwYhQeWuK+wg3J1mpbt/FXNvv3L0IbnMwT6+3swX02
         HPI2NSpEKPj38qf2IZXSwjGhRFqXTGk6Q9YgMMfcD7rhCEW7ofMqF0w9egPOlZtAiB
         erY96ycIpUGSoR8CLAqdoxJYSuHo0W+Bv67/dKTJ91ctMvKpmSXWs3QtL7QNUpbQPQ
         gyiDGz2yvhv6lVY67Y/Y08wVATz9YbPVr/x/eUWrUVu87fGjtSBH/GAyjEZvOPPh+0
         JqZw7efV/rcUw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [RFC] [PATCH net-next v5 1/3] PCI/ASPM: Introduce a new helper to report ASPM capability
Date:   Thu, 16 Sep 2021 23:44:15 +0800
Message-Id: <20210916154417.664323-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916154417.664323-1-kai.heng.feng@canonical.com>
References: <20210916154417.664323-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.

The user will be introduced by next patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v5:
 - No change.

v4:
 - Report aspm_capable instead.

v3:
 - This is a new patch

 drivers/pci/pcie/aspm.c | 11 +++++++++++
 include/linux/pci.h     |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 013a47f587cea..788e7496f33b1 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1201,6 +1201,17 @@ bool pcie_aspm_enabled(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pcie_aspm_enabled);
 
+bool pcie_aspm_capable(struct pci_dev *pdev)
+{
+	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
+
+	if (!link)
+		return false;
+
+	return link->aspm_capable;
+}
+EXPORT_SYMBOL_GPL(pcie_aspm_capable);
+
 static ssize_t aspm_attr_show_common(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf, u8 state)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 34d7d94ddf6dc..d77919d125af1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1631,6 +1631,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 bool pcie_aspm_support_enabled(void);
 bool pcie_aspm_enabled(struct pci_dev *pdev);
+bool pcie_aspm_capable(struct pci_dev *pdev);
 #else
 static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
 { return 0; }
@@ -1639,6 +1640,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 static inline void pcie_no_aspm(void) { }
 static inline bool pcie_aspm_support_enabled(void) { return false; }
 static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
+static inline bool pcie_aspm_capable(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_PCIEAER
-- 
2.32.0

