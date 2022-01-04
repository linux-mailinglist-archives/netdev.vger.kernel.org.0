Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CF74843DE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiADOyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:54:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:32944 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbiADOyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 09:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641308075; x=1672844075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3luvkNGyvd1+OW48scUQT4CKeF1YmcTsyDfG5YS/Ek0=;
  b=h0n4y8Bg51X3YYb0LYP13s1pNDnCJ5X1qj7qY/OgOpImuMH6QlSgLgrc
   KkVm6+GRtTxj1VZw84OJNWUvwcrnUlQJ+S3tbvnlxZwTLZ0Azf/vM/otm
   cqrRT+1lEkU561dk8ZM3H1yNxSPhxz/slZiG7BcfwmBhJp3KfPe4hQ8Vt
   3qFfYQyjgl2vcX8W7yUliuNq9CHr9ZKpO3XlhKXc/4Kzt5cNGaFPLx6EV
   zO8F7smISPCNYFAIV8WGHV6oUcya/fZ+Jp2REWtr2A7vbtXgavzJyRClH
   gt9KzSCGBVH4Ommp7IFyXZODexHzRkCr2TfMv4PbBOShvwchbsjH92P93
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="242031312"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="242031312"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 06:54:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="667761163"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2022 06:54:32 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        kai.heng.feng@canonical.com
Subject: [PATCH net-next] Revert "net: wwan: iosm: Keep device at D0 for s2idle case"
Date:   Tue,  4 Jan 2022 20:32:13 +0530
Message-Id: <20220104150213.1894-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on BIOS configuration IOSM driver exchanges
protocol required for putting device into D3L2 or D3L1.2.

ipc_pcie_suspend_s2idle() is implemented to put device to D3L1.2.

This patch forces PCI core know this device should stay at D0.
- pci_save_state()is expensive since it does a lot of slow PCI
config reads.

The reported issue is not observed on x86 platform. The supurios
wake on AMD platform needs to be futher debugged with orignal patch
submitter [1]. Also the impact of adding pci_save_state() needs to be
assessed by testing it on other platforms.

This reverts commit f4dd5174e273("net: wwan: iosm: Keep device
at D0 for s2idle case").

[1] https://lore.kernel.org/all/20211224081914.345292-2-kai.heng.feng@canonical.com/

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index af1d0e837fe9..d73894e2a84e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -340,9 +340,6 @@ static int __maybe_unused ipc_pcie_suspend_s2idle(struct iosm_pcie *ipc_pcie)
 
 	ipc_imem_pm_s2idle_sleep(ipc_pcie->imem, true);
 
-	/* Let PCI core know this device should stay at D0 */
-	pci_save_state(ipc_pcie->pci);
-
 	return 0;
 }
 
-- 
2.25.1

