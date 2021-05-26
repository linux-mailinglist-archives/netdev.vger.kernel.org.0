Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFCE391E05
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhEZRYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:18091 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234556AbhEZRYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:24:12 -0400
IronPort-SDR: Mlm/mRT2nnmbjdZUQ+AAEQVOFTy54+I8m212+rNW8Dwju+MMIt+Ai8ekfa2kwKroxACpQpTPnB
 bO/DNroZo1rg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415793"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415793"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: LKiVloiwxw/93pUAtbfyXNyrcLRYEZh1V304x8T/UzEXkX0zIQHljB8B6CfbKTP/NEekiy79Ad
 DC4hdc2ABc6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149232"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Shannon Nelson <snelson@pensando.io>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 11/11] ixgbe: reduce checker warnings
Date:   Wed, 26 May 2021 10:23:46 -0700
Message-Id: <20210526172346.3515587-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Fix the sparse warnings in the ixgbe crypto offload code. These
changes were made in the most conservative way (force cast)
in order to hopefully not break the code. I suspect that the
code might still be broken on big-endian architectures, but
no one is complaining, so I'm just leaving it functionally
the same.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Shannon Nelson <snelson@pensando.io>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail:
.../ixgbe/ixgbe_ipsec.c:514:56: warning: restricted __be32 degrades to integer
.../ixgbe/ixgbe_ipsec.c:521:48: warning: restricted __be32 degrades to integer
.../ixgbe/ixgbe_ipsec.c:536:59: warning: restricted __be32 degrades to integer
.../ixgbe/ixgbe_ipsec.c:546:59: warning: restricted __be32 degrades to integer
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 54d47265a7ac..e596e1a9fc75 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -511,14 +511,14 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 					continue;
 
 				reg = IXGBE_READ_REG(hw, MIPAF_ARR(3, i));
-				if (reg == xs->id.daddr.a4)
+				if (reg == (__force u32)xs->id.daddr.a4)
 					return 1;
 			}
 		}
 
 		if ((bmcipval & BMCIP_MASK) == BMCIP_V4) {
 			reg = IXGBE_READ_REG(hw, IXGBE_BMCIP(3));
-			if (reg == xs->id.daddr.a4)
+			if (reg == (__force u32)xs->id.daddr.a4)
 				return 1;
 		}
 
@@ -533,7 +533,7 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 
 			for (j = 0; j < 4; j++) {
 				reg = IXGBE_READ_REG(hw, MIPAF_ARR(i, j));
-				if (reg != xs->id.daddr.a6[j])
+				if (reg != (__force u32)xs->id.daddr.a6[j])
 					break;
 			}
 			if (j == 4)   /* did we match all 4 words? */
@@ -543,7 +543,7 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 		if ((bmcipval & BMCIP_MASK) == BMCIP_V6) {
 			for (j = 0; j < 4; j++) {
 				reg = IXGBE_READ_REG(hw, IXGBE_BMCIP(j));
-				if (reg != xs->id.daddr.a6[j])
+				if (reg != (__force u32)xs->id.daddr.a6[j])
 					break;
 			}
 			if (j == 4)   /* did we match all 4 words? */
-- 
2.26.2

