Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA1132C9CB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbhCDBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:44723 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1450449AbhCDBHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:07:16 -0500
IronPort-SDR: RORb8fj7cSGaYTNl9FEw8fPi7k3jbgDgDxJcuhMyWrLcM23yY6o5ON3EZqyFMExBjAw8ZxERy6
 OydBru8CPKwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="183934478"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="183934478"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 17:05:38 -0800
IronPort-SDR: m19F1jb32BPsO2CoT7qvMLuy6UlrwuBQiseHlu7TsBYwfM5J+SW94MOu5jrF9XEIxQ3+aaHBbd
 ULuzqmVA4jSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="367809986"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2021 17:05:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Yongxin Liu <yongxin.liu@windriver.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/3] net: ethernet: ixgbe: don't propagate -ENODEV from ixgbe_mii_bus_init()
Date:   Wed,  3 Mar 2021 17:06:47 -0800
Message-Id: <20210304010649.1858916-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
References: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

It's a valid use-case for ixgbe_mii_bus_init() to return -ENODEV - we
still want to finalize the registration of the ixgbe device. Check the
error code and don't bail out if err == -ENODEV.

This fixes an issue on C3000 family of SoCs where four ixgbe devices
share a single MDIO bus and ixgbe_mii_bus_init() returns -ENODEV for
three of them but we still want to register them.

Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fae84202d870..aa3b0a7ab786 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11033,7 +11033,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			true);
 
 	err = ixgbe_mii_bus_init(hw);
-	if (err)
+	if (err && err != -ENODEV)
 		goto err_netdev;
 
 	return 0;
-- 
2.26.2

