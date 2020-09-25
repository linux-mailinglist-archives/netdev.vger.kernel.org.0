Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4D0279303
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgIYVJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:09:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:48591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgIYVJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 17:09:42 -0400
IronPort-SDR: QGEHk0k7ErMiLnJcxUehA5v8QwiqCdGmhvh0ukTietcrQskJGrvJTCKo0Jh3q/IQ+h8tc5yJA2
 q3T/OoNr9Wzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="161724525"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="161724525"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
IronPort-SDR: CgS76KcFf68aM2w6+Tjev/R6OQXSWaATqFwuNtF14FdfpbH4mQ+csSMZf74U0Wq1QVYlcelBIm
 gMciP99NPQ2A==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="291979270"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 14:09:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net v2 2/4] ice: Fix call trace on suspend
Date:   Fri, 25 Sep 2020 14:09:28 -0700
Message-Id: <20200925210930.4049734-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
References: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

It appears that the ice_suspend flow is missing a call to pci_save_state
and this is triggering the message "State of device not saved by
ice_suspend" and a call trace. Fix it.

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4634b48949bb..954f11f86f50 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4522,6 +4522,7 @@ static int __maybe_unused ice_suspend(struct device *dev)
 	}
 	ice_clear_interrupt_scheme(pf);
 
+	pci_save_state(pdev);
 	pci_wake_from_d3(pdev, pf->wol_ena);
 	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
-- 
2.26.2

