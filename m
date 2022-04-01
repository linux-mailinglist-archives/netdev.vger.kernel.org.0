Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06944EED84
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346003AbiDAM4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345997AbiDAM4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:56:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA56E6150
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 05:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648817700; x=1680353700;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NIxxOF4X+NBZXmFKmeG0AwAoyQKtEKclmBIOxgqHrFk=;
  b=jAv9qcAYBOWi/fBSAYvlFQU3OlKAQVgnSXFHz469to8c78JgpjDTTGIz
   36QeSHxxfAGdjCp4Gl18RlThH6qylCbYcBwf9cOCBS76CmEKbO4/qi6bS
   ub6oEPCuiA0sKYfTPQccevgel6ATaLF4o5m3h7IM5C3jdnAx/MEo23rtW
   sy0lraI+G0TAIYXxP2lpBiOCEcnuKH0baqs6ErO89i1NdEWsN457xHOn0
   eqO0AyMnzkwFpGU6UKPm8iKzX3SnJ5HUgTz8Erkd14xI2GHcCHBHHfQnJ
   jKYKSY/h+J+0cNmrn97SbpyQpj1IM/PbjctQ474LBaElaVvbpSmq7PEhg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="257710466"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="257710466"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 05:55:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="547791709"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 01 Apr 2022 05:54:57 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Grzegorz Nitka <grzegorz.nitka@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>
Subject: [PATCH intel-net] ice: allow creating VFs for !CONFIG_NET_SWITCHDEV
Date:   Fri,  1 Apr 2022 14:54:38 +0200
Message-Id: <20220401125438.292649-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently for !CONFIG_NET_SWITCHDEV kernel builds it is not possible to
create VFs properly as call to ice_eswitch_configure() returns
-EOPNOTSUPP for us. This is because CONFIG_ICE_SWITCHDEV depends on
CONFIG_NET_SWITCHDEV.

Change the ice_eswitch_configure() implementation for
!CONFIG_ICE_SWITCHDEV to return 0 instead -EOPNOTSUPP and let
ice_ena_vfs() finish its work properly.

CC: Grzegorz Nitka <grzegorz.nitka@intel.com>
Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
index bd58d9d2e565..6a413331572b 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -52,7 +52,7 @@ static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
 
 static inline int ice_eswitch_configure(struct ice_pf *pf)
 {
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 static inline int ice_eswitch_rebuild(struct ice_pf *pf)
-- 
2.27.0

