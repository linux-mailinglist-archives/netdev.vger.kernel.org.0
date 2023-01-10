Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1918E664ED8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjAJWhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjAJWhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:37:52 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2345587D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673390271; x=1704926271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hzc2nLqmDRndtAh36EvmIqSpCxNCpTQFZLeMRPYTmrM=;
  b=V9YX92kC0mekz9dmmlvUlGSCBFEr6GLmmWMs+KXcsiI8DPS2VJZVqXUl
   me4kZF3bc3eAXKaAr7CiV4BYF5ZWjL/8a8LpVFGesuYe++QOUZvf3NuLL
   jy6uiCdVRDBDXsWz2k0nfnvcRlKeENghfQvwu3MY3vti410/yrWQCqiOj
   HC4k/Q0zcgS1xZxnYf6DA3D06vt5oc95kbeXM0YqPZPq8OIrOlHZDSWz5
   yPA5sBIyKVEvOPd27p544Tt32CtM9mZaROMHE08hbF3eaa98uyVIu/Jqo
   uUTZ7msK9N0sNWAV2eS98G89JKMUI96DMC5FJJkAhXg7Ka5/Xk/1v6DP7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="320962788"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320962788"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 14:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650512945"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650512945"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 14:37:50 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, stephend@silicom-usa.com,
        andrew@lunn.ch, f.fainelli@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/3] ixgbe: fix pci device refcount leak
Date:   Tue, 10 Jan 2023 14:38:23 -0800
Message-Id: <20230110223825.648544-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
References: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

As the comment of pci_get_domain_bus_and_slot() says, it
returns a PCI device with refcount incremented, when finish
using it, the caller must decrement the reference count by
calling pci_dev_put().

In ixgbe_get_first_secondary_devfn() and ixgbe_x550em_a_has_mii(),
pci_dev_put() is called to avoid leak.

Fixes: 8fa10ef01260 ("ixgbe: register a mdiobus")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 24aa97f993ca..123dca9ce468 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -855,9 +855,11 @@ static struct pci_dev *ixgbe_get_first_secondary_devfn(unsigned int devfn)
 	rp_pdev = pci_get_domain_bus_and_slot(0, 0, devfn);
 	if (rp_pdev && rp_pdev->subordinate) {
 		bus = rp_pdev->subordinate->number;
+		pci_dev_put(rp_pdev);
 		return pci_get_domain_bus_and_slot(0, bus, 0);
 	}
 
+	pci_dev_put(rp_pdev);
 	return NULL;
 }
 
@@ -874,6 +876,7 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct pci_dev *func0_pdev;
+	bool has_mii = false;
 
 	/* For the C3000 family of SoCs (x550em_a) the internal ixgbe devices
 	 * are always downstream of root ports @ 0000:00:16.0 & 0000:00:17.0
@@ -884,15 +887,16 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x16, 0));
 	if (func0_pdev) {
 		if (func0_pdev == pdev)
-			return true;
-		else
-			return false;
+			has_mii = true;
+		goto out;
 	}
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x17, 0));
 	if (func0_pdev == pdev)
-		return true;
+		has_mii = true;
 
-	return false;
+out:
+	pci_dev_put(func0_pdev);
+	return has_mii;
 }
 
 /**
-- 
2.38.1

