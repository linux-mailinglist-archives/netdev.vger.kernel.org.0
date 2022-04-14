Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9550190B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbiDNQuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240787AbiDNQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:50:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C27CD651
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649953094; x=1681489094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WJm0+YPAo92RPCisEtm7nFxanJUucmXKve25Q/rSKPk=;
  b=V0B5DytEeUlqQiptVNTn0dM7PvmGIuu/l8RdnsdjPDjuYwKINizjblld
   0r5OYpN2HSbJghOk0zR8bnhq5Ek7YJDO/HU4iC6lqpvckHJqNPBetyTMp
   G+x88UDadxI9XU/0UCmG5zC5CnU4hPsg83FAegigia9Se6kdWUA6kcDk5
   oy8DsKodcz8vRsrzSFBAd2AlyO6ByvmwicByOc8zQY8ht/wcMAYdL5s53
   Ndqa1mRRnH/sLhcLGU+APVaWIn51o9z95EcjRNS4Vy7GtRsZSXM5tPilt
   7dWmsgGGPk0sZML1JfwG76RuwCiuUA0k5feTfP/d1Ygw+lGdFYdx/sV+O
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="242901616"
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="242901616"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 09:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="526970482"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2022 09:18:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Grzegorz Nitka <grzegorz.nitka@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/4] ice: allow creating VFs for !CONFIG_NET_SWITCHDEV
Date:   Thu, 14 Apr 2022 09:15:20 -0700
Message-Id: <20220414161522.2320694-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
References: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.31.1

