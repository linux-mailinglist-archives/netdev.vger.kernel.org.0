Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFA135FA1
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgAIRrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:47:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:61385 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbgAIRrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:47:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 09:47:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="254669786"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2020 09:47:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/7] ixgbevf: Remove limit of 10 entries for unicast filter list
Date:   Thu,  9 Jan 2020 09:47:08 -0800
Message-Id: <20200109174713.2940499-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
References: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Currently, though the FDB entry is added to VF, it does not appear in
RAR filters. VF driver only allows to add 10 entries. Attempting to add
another causes an error. This patch removes limitation and allows use of
all free RAR entries for the FDB if needed.

Fixes: 46ec20ff7d ("ixgbevf: Add macvlan support in the set rx mode op")
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 076f2da36f27..64ec0e7c64b4 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2081,11 +2081,6 @@ static int ixgbevf_write_uc_addr_list(struct net_device *netdev)
 	struct ixgbe_hw *hw = &adapter->hw;
 	int count = 0;
 
-	if ((netdev_uc_count(netdev)) > 10) {
-		pr_err("Too many unicast filters - No Space\n");
-		return -ENOSPC;
-	}
-
 	if (!netdev_uc_empty(netdev)) {
 		struct netdev_hw_addr *ha;
 
-- 
2.24.1

