Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A9D4300F8
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbhJPH5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:57:17 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59600
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243845AbhJPH5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:57:13 -0400
Received: from HP-EliteBook-840-G7.. (36-229-230-94.dynamic-ip.hinet.net [36.229.230.94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0019B40006;
        Sat, 16 Oct 2021 07:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634370904;
        bh=/P/llMH6UOsylnpGcNCdg/3aIo3qtJzP4OvFE14/jU0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nHBkHAX7YBPrflOhdLijiU2uu2zx5xxTN+a9s8vgi+Bc1YItAhNx+inGISeXVlb/t
         IKTt7zUDcBOwDS4NeMPFM86mWkOpQ0aLAdR0CG32ne3/evnatCZDxwBHIMRAuAi7vE
         eQlvfC9iwHq7AeRPO7ORe6M+Y+ZzFDtoWN9JycN9M9MEbdDP6CmmNT6un9TIoR0sWH
         eRUB4bgK+wYoX8QZJBTFeNYk3EfPcMPDU/g5Q54Btz8PAS24mAbKiZnxnYMHvYzdsm
         uPucHOEbIRNsYCRObJuTIkwdQ7LcOXC8MzdbmYB6ecQIBjsILDqhnqZteP8ZHdnLc6
         Ot7EJ9N/5VaNA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [RFC] [PATCH net-next v7 1/4] PCI/ASPM: Add pcie_aspm_capable()
Date:   Sat, 16 Oct 2021 15:54:39 +0800
Message-Id: <20211016075442.650311-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211016075442.650311-1-kai.heng.feng@canonical.com>
References: <20211016075442.650311-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.

The user will be introduced by next patch.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v7:
- Change subject.

v6:
 - No change.

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
index cd8aa6fce2041..a17baa39141f4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1639,6 +1639,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 bool pcie_aspm_support_enabled(void);
 bool pcie_aspm_enabled(struct pci_dev *pdev);
+bool pcie_aspm_capable(struct pci_dev *pdev);
 #else
 static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
 { return 0; }
@@ -1647,6 +1648,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 static inline void pcie_no_aspm(void) { }
 static inline bool pcie_aspm_support_enabled(void) { return false; }
 static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
+static inline bool pcie_aspm_capable(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_PCIEAER
-- 
2.32.0

