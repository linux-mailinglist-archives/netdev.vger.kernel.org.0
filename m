Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281B76C4D0
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 04:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbfGRCIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 22:08:17 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43906 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbfGRCIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 22:08:17 -0400
Received: by mail-ot1-f68.google.com with SMTP id j11so3051173otp.10
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 19:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fredlawl-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=2mNcSjYZTDX0o1c19DbRjvyTa/HNfq/i+DQ1fyLMpb8=;
        b=RdHlDRQe5S5oi+uNSNrU5wCY6AShBOUjqkKqq+XMXulSred1DqPs6bRNsISZgijTzc
         T4fmwGiw086AACYsEan0gyggOa7O8eK5wQO2I3ZuQWKBM6J/XtlfzdGsnsVk/6ag4rwU
         eHJVrjzSyYAx4GKZQWQuO6Y+/PW+SOkKR+qJ7pSfntCE/1x3P599Uz24gZclQbczvwcr
         JGVfYbbajXJZdLPcSn3sI+fi3Sy075xdBSQGeM1O4vCVMPUxpMmfboClKrVivUUYzO3C
         9EXyvBKWce+0nsjAnSfNGHez5tXJyX/bThpiPcj+6PsCYT4e5YFNgSqMOFjWv3ha28YL
         8Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2mNcSjYZTDX0o1c19DbRjvyTa/HNfq/i+DQ1fyLMpb8=;
        b=X7Zip0Mia1cm1AG6zxg0K3jm6Bprg+yYYWdR2eXoV27wArZbl3yFc7PiqknovHz712
         knvlfDlfIdlr+VlajXcuwceJRQE7x+Yq1wmJyqIi6miAOyV1xGuF52CqxpJ/pLsV2CTe
         fanzFBDL6tMzTOoYIOmSinpf6M7ULoJe0vFMYGN0sNVSiVgug+5+r9ORynbLQZvjELEY
         wA1OjCkX1RaA60TEI5q7QnPzxdI6Jvy3wpmEcrwq1e0T1MY7EQEoZyD6jm0FJjnGtqaj
         aJndU/T0Br2m6MUFVelFfcIFai5Pmc2ViZOjHEhmo257nqq8WTnMC5Ky5Zh1CWDkEbT8
         sq6Q==
X-Gm-Message-State: APjAAAV2ouvxcQrqSmHNY/Njs4Z+WE6ev05DUJDrQIpzbNxGWn1jiA6H
        Ioqrhjk6S27PcJPVuMNPmLM=
X-Google-Smtp-Source: APXvYqyUNDeuG65SzIx+VkEwU+3LdqvKyg46CnObeAwb+sKQYCAp4EPr/mSodztNtlWtg2BRyPqAPg==
X-Received: by 2002:a9d:6195:: with SMTP id g21mr34150314otk.103.1563415695901;
        Wed, 17 Jul 2019 19:08:15 -0700 (PDT)
Received: from linux.fredlawl.com ([2600:1700:18a0:11d0:18af:e893:6cb0:139a])
        by smtp.gmail.com with ESMTPSA id w3sm9563125otb.55.2019.07.17.19.08.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 19:08:15 -0700 (PDT)
From:   Frederick Lawler <fred@fredlawl.com>
To:     vishal@chelsio.com
Cc:     Frederick Lawler <fred@fredlawl.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: [PATCH] cxgb4: Prefer pcie_capability_read_word()
Date:   Wed, 17 Jul 2019 21:07:36 -0500
Message-Id: <20190718020745.8867-1-fred@fredlawl.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

Signed-off-by: Frederick Lawler <fred@fredlawl.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 6 ++----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 9 +++------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 715e4edcf4a2..98ff71434673 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5441,7 +5441,6 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 		char name[IFNAMSIZ];
 		u32 devcap2;
 		u16 flags;
-		int pos;
 
 		/* If we want to instantiate Virtual Functions, then our
 		 * parent bridge's PCI-E needs to support Alternative Routing
@@ -5449,9 +5448,8 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 		 * and above.
 		 */
 		pbridge = pdev->bus->self;
-		pos = pci_find_capability(pbridge, PCI_CAP_ID_EXP);
-		pci_read_config_word(pbridge, pos + PCI_EXP_FLAGS, &flags);
-		pci_read_config_dword(pbridge, pos + PCI_EXP_DEVCAP2, &devcap2);
+		pcie_capability_read_word(pbridge, PCI_EXP_FLAGS, &flags);
+		pcie_capability_read_dword(pbridge, PCI_EXP_DEVCAP2, &devcap2);
 
 		if ((flags & PCI_EXP_FLAGS_VERS) < 2 ||
 		    !(devcap2 & PCI_EXP_DEVCAP2_ARI)) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index f9b70be59792..346d7b59c50b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -7267,7 +7267,6 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
 	} else {
 		unsigned int pack_align;
 		unsigned int ingpad, ingpack;
-		unsigned int pcie_cap;
 
 		/* T5 introduced the separation of the Free List Padding and
 		 * Packing Boundaries.  Thus, we can select a smaller Padding
@@ -7292,8 +7291,7 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
 		 * multiple of the Maximum Payload Size.
 		 */
 		pack_align = fl_align;
-		pcie_cap = pci_find_capability(adap->pdev, PCI_CAP_ID_EXP);
-		if (pcie_cap) {
+		if (pci_is_pcie(adap->pdev)) {
 			unsigned int mps, mps_log;
 			u16 devctl;
 
@@ -7301,9 +7299,8 @@ int t4_fixup_host_params(struct adapter *adap, unsigned int page_size,
 			 * [bits 7:5] encodes sizes as powers of 2 starting at
 			 * 128 bytes.
 			 */
-			pci_read_config_word(adap->pdev,
-					     pcie_cap + PCI_EXP_DEVCTL,
-					     &devctl);
+			pcie_capability_read_word(adap->pdev, PCI_EXP_DEVCTL,
+						  &devctl);
 			mps_log = ((devctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5) + 7;
 			mps = 1 << mps_log;
 			if (mps > pack_align)
-- 
2.17.1

