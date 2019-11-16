Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EEAFF266
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfKPPp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbfKPPpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:45:54 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7472082E;
        Sat, 16 Nov 2019 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919153;
        bh=iPFtIhlFnF1IDIP9CFvA7qpSv6U66EhbaLGNIWWMfT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoJRBeju/nJ44CVuVGiHxtCPks3AVzVdmfXm5WxK8X3RCjDf4I0fuOxepBY3omLbg
         zdl9YBBnRkMq3kVBBB/pAMovISTqSQ1aV8fuKC9+8A0dQeUTVKaLdRmvBpKS3eL47j
         2HKH5j8OpHxQ+opfjaZ4nn0A7uiBi86Gvi/v2URY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 167/237] fm10k: ensure completer aborts are marked as non-fatal after a resume
Date:   Sat, 16 Nov 2019 10:40:02 -0500
Message-Id: <20191116154113.7417-167-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit e330af788998b0de4da4f5bd7ddd087507999800 ]

VF drivers can trigger PCIe completer aborts any time they read a queue
that they don't own. Even in nominal circumstances, it is not possible
to prevent the VF driver from reading queues it doesn't own. VF drivers
may attempt to read queues it previously owned, but which it no longer
does due to a PF reset.

Normally these completer aborts aren't an issue. However, on some
platforms these trigger machine check errors. This is true even if we
lower their severity from fatal to non-fatal. Indeed, we already have
code for lowering the severity.

We could attempt to mask these errors conditionally around resets, which
is the most common time they would occur. However this would essentially
be a race between the PF and VF drivers, and we may still occasionally
see machine check exceptions on these strictly configured platforms.

Instead, mask the errors entirely any time we resume VFs. By doing so,
we prevent the completer aborts from being sent to the parent PCIe
device, and thus these strict platforms will not upgrade them into
machine check errors.

Additionally, we don't lose any information by masking these errors,
because we'll still report VFs which attempt to access queues via the
FUM_BAD_VF_QACCESS errors.

Without this change, on platforms where completer aborts cause machine
check exceptions, the VF reading queues it doesn't own could crash the
host system. Masking the completer abort prevents this, so we should
mask it for good, and not just around a PCIe reset. Otherwise malicious
or misconfigured VFs could cause the host system to crash.

Because we are masking the error entirely, there is little reason to
also keep setting the severity bit, so that code is also removed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c | 48 ++++++++++++--------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
index e707d717012fa..618032612f52d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
@@ -302,6 +302,28 @@ void fm10k_iov_suspend(struct pci_dev *pdev)
 	}
 }
 
+static void fm10k_mask_aer_comp_abort(struct pci_dev *pdev)
+{
+	u32 err_mask;
+	int pos;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return;
+
+	/* Mask the completion abort bit in the ERR_UNCOR_MASK register,
+	 * preventing the device from reporting these errors to the upstream
+	 * PCIe root device. This avoids bringing down platforms which upgrade
+	 * non-fatal completer aborts into machine check exceptions. Completer
+	 * aborts can occur whenever a VF reads a queue it doesn't own.
+	 */
+	pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_MASK, &err_mask);
+	err_mask |= PCI_ERR_UNC_COMP_ABORT;
+	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_MASK, err_mask);
+
+	mmiowb();
+}
+
 int fm10k_iov_resume(struct pci_dev *pdev)
 {
 	struct fm10k_intfc *interface = pci_get_drvdata(pdev);
@@ -317,6 +339,12 @@ int fm10k_iov_resume(struct pci_dev *pdev)
 	if (!iov_data)
 		return -ENOMEM;
 
+	/* Lower severity of completer abort error reporting as
+	 * the VFs can trigger this any time they read a queue
+	 * that they don't own.
+	 */
+	fm10k_mask_aer_comp_abort(pdev);
+
 	/* allocate hardware resources for the VFs */
 	hw->iov.ops.assign_resources(hw, num_vfs, num_vfs);
 
@@ -460,20 +488,6 @@ void fm10k_iov_disable(struct pci_dev *pdev)
 	fm10k_iov_free_data(pdev);
 }
 
-static void fm10k_disable_aer_comp_abort(struct pci_dev *pdev)
-{
-	u32 err_sev;
-	int pos;
-
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
-	if (!pos)
-		return;
-
-	pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, &err_sev);
-	err_sev &= ~PCI_ERR_UNC_COMP_ABORT;
-	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, err_sev);
-}
-
 int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	int current_vfs = pci_num_vf(pdev);
@@ -495,12 +509,6 @@ int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs)
 
 	/* allocate VFs if not already allocated */
 	if (num_vfs && num_vfs != current_vfs) {
-		/* Disable completer abort error reporting as
-		 * the VFs can trigger this any time they read a queue
-		 * that they don't own.
-		 */
-		fm10k_disable_aer_comp_abort(pdev);
-
 		err = pci_enable_sriov(pdev, num_vfs);
 		if (err) {
 			dev_err(&pdev->dev,
-- 
2.20.1

