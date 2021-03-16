Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8326033CBCE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 04:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhCPDPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 23:15:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:18301 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhCPDPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 23:15:38 -0400
IronPort-SDR: ddrZ4eN9j5MjRPWWwD+wS7ZguDr0J1TMsoNInJgOLdnPv56ws3BAmkaHe9iUOA7ByG8Z2YYDjY
 g2FRvLG973qw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="274233662"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="274233662"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 20:15:38 -0700
IronPort-SDR: odwXcWe3K6SfeJFNLA+0B1rZhV1UYr6MAFwe7UokE21s81ACPgPcoLlX2W4/0eK34U/zC14/wP
 dIOpDyQD3maw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="601672906"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 15 Mar 2021 20:15:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chen Yu <yu.c.chen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        kai.heng.feng@canonical.com, rjw@rjwysocki.net,
        len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 2/2] e1000e: Remove the runtime suspend restriction on CNP+
Date:   Mon, 15 Mar 2021 20:16:59 -0700
Message-Id: <20210316031659.3695692-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
References: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

Although there is platform issue of runtime suspend support
on CNP, it would be more flexible to let the user decide whether
to disable runtime or not because:
1. This can be done in userspace via
   echo on > /sys/devices/pci0000\:00/0000\:00\:1f.d/power/control
2. More and more NICs would support runtime suspend, disabling the
   runtime suspend on them by default would impact the validation.

Only disable runtime suspend on CNP in case of any user space regression.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3eaae9a5a44e..480f6712a3b6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7635,7 +7635,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
 
-	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
+	if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
 		pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
-- 
2.26.2

