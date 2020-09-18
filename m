Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959A3270858
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgIRVeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:34:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:65029 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgIRVeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 17:34:03 -0400
IronPort-SDR: 0ypBJKprQLiqtHDjtxe2V0VTVoHvCpoK9+YxSrNReZHZQ4sn8/w2M+Wo8EcYnPK/a6Api2VS3p
 uS+vpyzakiCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="178128523"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="178128523"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:14 -0700
IronPort-SDR: JO4uswODr1nyLXxyacwY5kFraBLyFzhzMPWWwDF4Cd8CKNoiWBrVTugiekyMz555Wr6WDFGSf7
 DbTdSJgfiJHw==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="508299887"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 14:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 2/4] ice: Fix call trace on suspend
Date:   Fri, 18 Sep 2020 14:27:01 -0700
Message-Id: <20200918212703.3398038-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
References: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
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

