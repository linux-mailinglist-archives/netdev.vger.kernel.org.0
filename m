Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002052C9495
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389234AbgLABUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:20:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:22830 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbgLABUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:20:09 -0500
IronPort-SDR: GC6mnQRZdXI+SwddVEKYduUN/aFSyKe3GbfPi/J27nGV4pLsUP+Bf3KMvcDSmBJT34qC8SSWcE
 8t9PAtp8f++A==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="170177455"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="170177455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:19:28 -0800
IronPort-SDR: 0mj4k8xHOEc7kaYnDBIfwvuFreMJRA6EqTktv3jNhc8ZMeQ+ltM69Kba3vm4JjIj/2xahgAlIw
 XUKCNkJi/79Q==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="314771314"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:19:24 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Brandt, Todd E" <todd.e.brandt@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 2/2][v3] e1000e: Remove the runtime suspend restriction on CNP+
Date:   Tue,  1 Dec 2020 09:22:09 +0800
Message-Id: <aa62fe21ecafaff167f57e86192be70ee8914738.1606757180.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606757180.git.yu.c.chen@intel.com>
References: <cover.1606757180.git.yu.c.chen@intel.com>
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

Only disable runtime suspend on CNP in case of any user space regression.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index b210bba3f20a..d06435267dc8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7674,7 +7674,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
 
-	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
+	if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
 		pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
-- 
2.17.1

