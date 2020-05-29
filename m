Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063261E7118
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437987AbgE2AIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:2082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437941AbgE2AIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:34 -0400
IronPort-SDR: FHrteZqPczGE50mUwAcob6dGSKOj0TeaeaK+M4zvoGi8y7dPwSX1Ca++1YKUVcyKiB5we9qlfh
 nGHYRKuyBrBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:33 -0700
IronPort-SDR: iiw6tMRNpEWrb7wRBhymsgdpSyyr5G+v3b49xaSazSCxauzvVtY7xfiKXiqO/0cfzl4MUC71os
 sEHZuOA+7KIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651620"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: fix potential double free in probe unrolling
Date:   Thu, 28 May 2020 17:08:19 -0700
Message-Id: <20200529000831.2803870-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If ice_init_interrupt_scheme fails, ice_probe will jump to clearing up
the interrupts. This can lead to some static analysis tools such as the
compiler sanitizers complaining about double free problems.

Since ice_init_interrupt_scheme already unrolls internally on failure,
there is no need to call ice_clear_interrupt_scheme when it fails. Add
a new unroll label and use that instead.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6583acf32575..5cffaf360cb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3418,7 +3418,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (err) {
 		dev_err(dev, "ice_init_interrupt_scheme failed: %d\n", err);
 		err = -EIO;
-		goto err_init_interrupt_unroll;
+		goto err_init_vsi_unroll;
 	}
 
 	/* In case of MSIX we are going to setup the misc vector right here
@@ -3511,6 +3511,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_free_irq_msix_misc(pf);
 err_init_interrupt_unroll:
 	ice_clear_interrupt_scheme(pf);
+err_init_vsi_unroll:
 	devm_kfree(dev, pf->vsi);
 err_init_pf_unroll:
 	ice_deinit_pf(pf);
-- 
2.26.2

