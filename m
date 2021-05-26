Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C666391E06
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhEZRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:18168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhEZRYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:24:13 -0400
IronPort-SDR: xHsJWVXUqR8jOn3dwyVfwsuXZ+Lic25p4sWfg5jmcwey1RQuSbX55csWv9Ro4e67kfjjbYp2K3
 rzS535X0vFXA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415794"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415794"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: daWFghVrzDkBXmuneg6PjejjgHJB9siWn3HhNXJ0nt2y1bPSvQMVanY3XoACUviPayltHxwmhj
 XoSmvlDG3vnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149227"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 10/11] ixgbe: use checker safe conversions
Date:   Wed, 26 May 2021 10:23:45 -0700
Message-Id: <20210526172346.3515587-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The ixgbe hardware needs some very specific programming for
certain registers, which led to some misguided usage of ntohs
instead of using be16_to_cpu(), as well as a home grown swap
followed by an ntohs. Sparse didn't like this at all, and this
fixes the C=2 build, with code that uses native kernel interface.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Details:
.../ixgbe/ixgbe_82599.c:1660:20: warning: cast to restricted __be16
.../ixgbe/ixgbe_82599.c:1660:20: warning: cast to restricted __be16
.../ixgbe/ixgbe_82599.c:1660:20: warning: cast to restricted __be16
.../ixgbe/ixgbe_82599.c:1660:20: warning: cast to restricted __be16
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index e324e42fab2d..58ea959a4482 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -1514,8 +1514,7 @@ static u32 ixgbe_get_fdirtcpm_82599(union ixgbe_atr_input *input_mask)
 #define IXGBE_WRITE_REG_BE32(a, reg, value) \
 	IXGBE_WRITE_REG((a), (reg), IXGBE_STORE_AS_BE32(ntohl(value)))
 
-#define IXGBE_STORE_AS_BE16(_value) \
-	ntohs(((u16)(_value) >> 8) | ((u16)(_value) << 8))
+#define IXGBE_STORE_AS_BE16(_value) __swab16(ntohs((_value)))
 
 s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 				    union ixgbe_atr_input *input_mask)
@@ -1651,13 +1650,13 @@ s32 ixgbe_fdir_write_perfect_filter_82599(struct ixgbe_hw *hw,
 	IXGBE_WRITE_REG_BE32(hw, IXGBE_FDIRIPDA, input->formatted.dst_ip[0]);
 
 	/* record source and destination port (little-endian)*/
-	fdirport = ntohs(input->formatted.dst_port);
+	fdirport = be16_to_cpu(input->formatted.dst_port);
 	fdirport <<= IXGBE_FDIRPORT_DESTINATION_SHIFT;
-	fdirport |= ntohs(input->formatted.src_port);
+	fdirport |= be16_to_cpu(input->formatted.src_port);
 	IXGBE_WRITE_REG(hw, IXGBE_FDIRPORT, fdirport);
 
 	/* record vlan (little-endian) and flex_bytes(big-endian) */
-	fdirvlan = IXGBE_STORE_AS_BE16((__force u16)input->formatted.flex_bytes);
+	fdirvlan = IXGBE_STORE_AS_BE16(input->formatted.flex_bytes);
 	fdirvlan <<= IXGBE_FDIRVLAN_FLEX_SHIFT;
 	fdirvlan |= ntohs(input->formatted.vlan_id);
 	IXGBE_WRITE_REG(hw, IXGBE_FDIRVLAN, fdirvlan);
-- 
2.26.2

