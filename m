Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E756AF840
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCGWIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCGWIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:08:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F9692732
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678226916; x=1709762916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNMDUxVbUJrrqyM/4VAhn0Gtdno3yEClhpOlSUiV+M4=;
  b=PWNkudyPfUf1C3A6+sGh81KJ5nFn6Ldx4gw2dsHisn2uG2B4JVd3AuwE
   BFayxM8pugTbQbn+H2/VABa7Smwlhp1f2tFcvd5YQomtUekSg1735F6gJ
   e++ncJ50Pkmj4La4H8FWh6ZJhv1fuwR33CD9JXKCmJiInIOp47cQmSACl
   wb96e2anHjhSIH3EXcR6ATQua/KPx8FVYS+deKIM/lHq5Ernjh2kuPcnI
   claOaT0VLcu8K1UF0mL3nMZ9scF8eStU/yePPJYIND+ZGwql/WWDYc3zJ
   YTEKLBUWu1nrtuUx05TzhSfT9xgj2hTl7jJeAETKCeE7FGu3iSxAC7Q2q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316386720"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="316386720"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:08:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="654123242"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="654123242"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 14:08:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, anthony.l.nguyen@intel.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net 3/3] ethernet: ice: avoid gcc-9 integer overflow warning
Date:   Tue,  7 Mar 2023 14:07:14 -0800
Message-Id: <20230307220714.3997294-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
References: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With older compilers like gcc-9, the calculation of the vlan
priority field causes a false-positive warning from the byteswap:

In file included from drivers/net/ethernet/intel/ice/ice_tc_lib.c:4:
drivers/net/ethernet/intel/ice/ice_tc_lib.c: In function 'ice_parse_cls_flower':
include/uapi/linux/swab.h:15:15: error: integer overflow in expression '(int)(short unsigned int)((int)match.key-><U67c8>.<U6698>.vlan_priority << 13) & 57344 & 255' of type 'int' results in '0' [-Werror=overflow]
   15 |  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
      |   ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
include/uapi/linux/swab.h:106:2: note: in expansion of macro '___constant_swab16'
  106 |  ___constant_swab16(x) :   \
      |  ^~~~~~~~~~~~~~~~~~
include/uapi/linux/byteorder/little_endian.h:42:43: note: in expansion of macro '__swab16'
   42 | #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
      |                                           ^~~~~~~~
include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
   96 | #define cpu_to_be16 __cpu_to_be16
      |                     ^~~~~~~~~~~~~
drivers/net/ethernet/intel/ice/ice_tc_lib.c:1458:5: note: in expansion of macro 'cpu_to_be16'
 1458 |     cpu_to_be16((match.key->vlan_priority <<
      |     ^~~~~~~~~~~

After a change to be16_encode_bits(), the code becomes more
readable to both people and compilers, which avoids the warning.

Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 6b48cbc049c6..76f29a5bf8d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1455,8 +1455,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
 			headers->vlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 
 		if (match.mask->vlan_tpid)
@@ -1489,8 +1489,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_priority) {
 			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
 			headers->cvlan_hdr.vlan_prio =
-				cpu_to_be16((match.key->vlan_priority <<
-					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+				be16_encode_bits(match.key->vlan_priority,
+						 VLAN_PRIO_MASK);
 		}
 	}
 
-- 
2.38.1

