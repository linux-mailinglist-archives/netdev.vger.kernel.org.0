Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7B73F12E5
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 07:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhHSFq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 01:46:56 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39428
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230274AbhHSFqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 01:46:49 -0400
Received: from localhost.localdomain (1-171-223-154.dynamic-ip.hinet.net [1.171.223.154])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id A35A4411C4;
        Thu, 19 Aug 2021 05:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629351972;
        bh=amXsjTc2Jlr4vNYCJIJwZjbkzL6BAOEgx/TBHMTR6cU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=mu+BQpZyR3+QvkVIR2cDQdg/SvVpzcb8qsEE9hzA7aTxTTsnfkzzm43OG91Ma+YL0
         +heO9NHlrNFASy3WSyc/lfSHiXFMxB2HjwwbDvCTfyGKSxTfd1WmX0ROFw7VFB1Tvn
         dXeopEWwfpzfqPEFHOlaOg8nJ1uZ7s8B86FDPUKtYNgwRqn/DvU5K465hsCDjuy0wM
         8OrEJN9L0L2CLiSzIl0WGMDo/X7gFb+g7PKm9Jepzw+y1JvErSCOhjaNIUP1MdumEQ
         9rkanQ0Km/a+Px0wSeEfviGC3HTCyBzSijegzyZtxT0g2YFmk48QlBJd9hLKZNzTdL
         0kfu76tamzPsw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH net-next v3 2/3] PCI/ASPM: Introduce a new helper to report ASPM support status
Date:   Thu, 19 Aug 2021 13:45:41 +0800
Message-Id: <20210819054542.608745-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819054542.608745-1-kai.heng.feng@canonical.com>
References: <20210819054542.608745-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper, pcie_aspm_supported(), to report ASPM support
status.

The user will be introduced by next patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v3:
 - This is a new patch

 drivers/pci/pcie/aspm.c | 11 +++++++++++
 include/linux/pci.h     |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 013a47f587cea..eeea6a04ab0cf 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1201,6 +1201,17 @@ bool pcie_aspm_enabled(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pcie_aspm_enabled);
 
+bool pcie_aspm_supported(struct pci_dev *pdev)
+{
+	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
+
+	if (!link)
+		return false;
+
+	return link->aspm_support;
+}
+EXPORT_SYMBOL_GPL(pcie_aspm_supported);
+
 static ssize_t aspm_attr_show_common(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf, u8 state)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 540b377ca8f61..b7b71982f2405 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1602,6 +1602,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 bool pcie_aspm_support_enabled(void);
 bool pcie_aspm_enabled(struct pci_dev *pdev);
+bool pcie_aspm_supported(struct pci_dev *pdev);
 #else
 static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
 { return 0; }
@@ -1610,6 +1611,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 static inline void pcie_no_aspm(void) { }
 static inline bool pcie_aspm_support_enabled(void) { return false; }
 static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
+static inline bool pcie_aspm_supported(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_PCIEAER
-- 
2.32.0

