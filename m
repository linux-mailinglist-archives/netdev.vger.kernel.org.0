Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF4F425788
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbhJGQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:18:45 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:53980
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242220AbhJGQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:18:44 -0400
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8FA413FFFE;
        Thu,  7 Oct 2021 16:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633623409;
        bh=RHp8KVkKNOR8LYF/gQFg3V0mAgOfypBH5g0DR7HH+h0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=TcQzHcQbDjPi74qA1efLVclz92coYEgU4vd3kTIPTvnyl2cFZYqgfG0PCQEmrUzYg
         1BVXTh1r/jvUTGHzpbqBgDb1gJPcLBn2P0LPMNe77xxZdUwSeG8HwZXX/qy8j+FKKt
         ALggkL0n0UmswTokdEwzJKiLRqqQobnZ/yfwGFnY4wm0ky2SVtAXEcujWN3xr5Ll/S
         aga6fUiSRTErrE+D47JCFAuVL0AVmJdDFOD2IucEHq0uxgNeyNyhGGv2tpcEsiZjzE
         Qq5chFuhLJegxdX5izZwV3R4+C+5kl8ffezFSXwFqWMgCz18dCJiZiXF8Sl8XOXCOV
         SO82KJbhWgItw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: [RFC] [PATCH net-next v5 1/3] PCI/ASPM: Introduce a new helper to report ASPM capability
Date:   Fri,  8 Oct 2021 00:15:50 +0800
Message-Id: <20211007161552.272771-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211007161552.272771-1-kai.heng.feng@canonical.com>
References: <20211007161552.272771-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.

The user will be introduced by next patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v6:
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

