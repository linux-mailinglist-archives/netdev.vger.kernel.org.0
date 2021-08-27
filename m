Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711333F9D65
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbhH0RQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:16:03 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56004
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234095AbhH0RQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:16:02 -0400
Received: from HP-EliteBook-840-G7.. (36-229-239-33.dynamic-ip.hinet.net [36.229.239.33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A58FF411F9;
        Fri, 27 Aug 2021 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630084512;
        bh=Jddpgu6AOn0FGNPn3h009huWCn2/GtfWfpw5SyAfrVw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MT3ccwLy4wM72NbqxWZsv4zfQr7olU2b5Aw2TN6b/0eTad+seNQH7zpZlL9RNsW9R
         y+KRAHM3o6LDsshXYXqccRcbbxGXee+cHRndxMwp9IHzjLk/GX/S7Au2f+jCrf/mCL
         /dHloQRID+f2vIQfMf2sa2Z1wiyCYGIjpgcHuBIzjmfSLbRm+HAuNcUPJ7TvTjJg+j
         AA25mYzHBIXFx+b+brKa2LzuTp78awJEAf0DIMojFVfhmNjJ86f9Sl2fCy0CAVjbKP
         V/87lnU3JDkhQJB6+oCH3JUo3UGvmcDDOgyG944p0U48R3XdUwbKWl+S0hpgDaxBPN
         lwnzhnxrvJwMw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [RFC] [PATCH net-next v4 1/2] PCI/ASPM: Introduce a new helper to report ASPM capability
Date:   Sat, 28 Aug 2021 01:14:51 +0800
Message-Id: <20210827171452.217123-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210827171452.217123-1-kai.heng.feng@canonical.com>
References: <20210827171452.217123-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.

The user will be introduced by next patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
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
index 947430637cac3..6b20775eff03c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1602,6 +1602,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 bool pcie_aspm_support_enabled(void);
 bool pcie_aspm_enabled(struct pci_dev *pdev);
+bool pcie_aspm_capable(struct pci_dev *pdev);
 #else
 static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
 { return 0; }
@@ -1610,6 +1611,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 static inline void pcie_no_aspm(void) { }
 static inline bool pcie_aspm_support_enabled(void) { return false; }
 static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
+static inline bool pcie_aspm_capable(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_PCIEAER
-- 
2.32.0

