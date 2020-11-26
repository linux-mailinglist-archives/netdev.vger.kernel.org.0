Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C692C4E9C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbgKZGMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:12:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:43626 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387921AbgKZGMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 01:12:19 -0500
IronPort-SDR: Ks1mKO0VhREgf8yAqmlL7/Z8EjACAljTJW2YUKYhQthON+gJmdEwdVGuGVsW44XUJLsDkM7a0U
 kHg/WU+1JJMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="233847709"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="233847709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 22:12:18 -0800
IronPort-SDR: ImYxieLtpF/TurQlO1jIFlQ/Gze9/3iHTvEZARgz9QiuudhnIgjLzIB3+SuEyADUXmwISaeLtY
 fgboCF56/tDw==
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="313272699"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 22:12:15 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Kai-Heng Feng" <kai.heng.feng@canonical.com>
Cc:     linux-pm@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 2/2][v2] e1000e: Remove the runtime suspend restriction on CNP+
Date:   Thu, 26 Nov 2020 14:14:58 +0800
Message-Id: <8d92dd25b45f711708701e11d6cf4e4d41b2bddc.1606370334.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606370334.git.yu.c.chen@intel.com>
References: <cover.1606370334.git.yu.c.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although there is platform issue of runtime suspend support
on CNP, it would be more flexible to let the user decide whether
to disable runtime or not because:
1. This can be done in userspace via
   echo on > /sys/devices/pci0000\:00/0000\:00\:1f.d/power/control
2. More and more NICs would support runtime suspend, disabling the
   runtime suspend on them by default would impact the validation.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e32d443feb24..2850535db7a1 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7684,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NO_DIRECT_COMPLETE |
 				DPM_FLAG_SMART_SUSPEND | DPM_FLAG_MAY_SKIP_RESUME);
 
-	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
+	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
-- 
2.17.1

