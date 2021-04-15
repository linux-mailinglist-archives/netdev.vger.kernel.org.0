Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7322C35FEDE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhDOA3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: w5aRJKnGRwWRKW+FzjhrQnyCADfhPMv7vsOOUtvHXlgHVKmGhQyhZMBpXpWzesAaHT6OpdGYrM
 FtqoaUYIkHvQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262240"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262240"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: gGkl5TuNRI6/JybNqkOQcAiFkuIW/gxkw4mOCf+im/iRoHMoT80QMLb0Mn3SXy1jxY/aAl/qF2
 osVlqzSf083Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379522"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/15] ice: print name in /proc/iomem
Date:   Wed, 14 Apr 2021 17:30:07 -0700
Message-Id: <20210415003013.19717-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver previously printed it's PCI address in
the name field for the pci resource, which when displayed
via /proc/iomem, would print the same thing twice.

It's more useful for debugging to see the driver name, as
most other modules do.

Here's a diff of before and after this change:
     99100000-991fffff : 0000:3b:00.1
   9a000000-a04fffff : PCI Bus 0000:3b
     9a000000-9bffffff : 0000:3b:00.1
-      9a000000-9bffffff : 0000:3b:00.1
+      9a000000-9bffffff : ice
     9c000000-9dffffff : 0000:3b:00.0
-      9c000000-9dffffff : 0000:3b:00.0
+      9c000000-9dffffff : ice
     9e000000-9effffff : 0000:3b:00.1
     9f000000-9fffffff : 0000:3b:00.0
     a0000000-a000ffff : 0000:3b:00.1

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1e023d163447..02672be04f78 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4002,7 +4002,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (err)
 		return err;
 
-	err = pcim_iomap_regions(pdev, BIT(ICE_BAR0), pci_name(pdev));
+	err = pcim_iomap_regions(pdev, BIT(ICE_BAR0), dev_driver_string(dev));
 	if (err) {
 		dev_err(dev, "BAR0 I/O map error %d\n", err);
 		return err;
-- 
2.26.2

