Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2AA79F1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfIDEf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfIDEfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804402"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: add needed PFR during driver unload
Date:   Tue,  3 Sep 2019 21:35:02 -0700
Message-Id: <20190904043512.28066-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

According to the specification, a PF Reset must be done as part of the
driver unload flow.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b62c01ca9c28..8217b81eb9d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2638,6 +2638,11 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
 	ice_clear_interrupt_scheme(pf);
+	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
+	 * do it via ice_schedule_reset() since there is no need to rebuild
+	 * and the service task is already stopped.
+	 */
+	ice_reset(&pf->hw, ICE_RESET_PFR);
 	pci_disable_pcie_error_reporting(pdev);
 }
 
-- 
2.21.0

