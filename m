Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F46AF83F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCGWIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCGWIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:08:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E40A92732
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678226914; x=1709762914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TcuU6R6yc6CwWSjd9f7ryAOPZjBjGpGMbwJK9R2SrBQ=;
  b=FhMoOP6gU6bPmsEYkK8jyOZMwIr8c4CkMDZi1gqfNNoN17JWl3Yf0unO
   xh5tyUj3vHrpDE77j9dzOknXrySVIHTuj8n8UfLSWUv8h4E563tLZgvIR
   C7khkHjxzqV7CNOdXv9l8288Q7cZoWIsDQIuGL6YjRJqo6gtFiUh0PxPu
   XtGUIpo/4aMWqnY3gY53d28FMzQNlMAgvZQU5ucQJ8oTVXKogCAuCxbBH
   eUH2arzURLjuJZkCybj9f9oh0NIPd7dLmqqNqDMmfMrvg5hLG+Xa7OTEh
   a4DKuOADzWQNvwk+AM98cu0ABxS+CZ4srJFrouQkLr1D0WpdshkDPo5k1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316386699"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="316386699"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:08:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="654123230"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="654123230"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 14:08:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, anthony.l.nguyen@intel.com,
        Karen Ostrowska <karen.ostrowska@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/3] ice: Fix DSCP PFC TLV creation
Date:   Tue,  7 Mar 2023 14:07:12 -0800
Message-Id: <20230307220714.3997294-2-anthony.l.nguyen@intel.com>
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

From: Dave Ertman <david.m.ertman@intel.com>

When creating the TLV to send to the FW for configuring DSCP mode PFC,the
PFCENABLE field was being masked with a 4 bit mask (0xF), but this is an 8
bit bitmask for enabled classes for PFC.  This means that traffic classes
4-7 could not be enabled for PFC.

Remove the mask completely, as it is not necessary, as we are assigning 8
bits to an 8 bit field.

Fixes: 2a87bd73e50d ("ice: Add DSCP support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index c557dfc50aad..396e555023aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1411,7 +1411,7 @@ ice_add_dscp_pfc_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
 	tlv->ouisubtype = htonl(ouisubtype);
 
 	buf[0] = dcbcfg->pfc.pfccap & 0xF;
-	buf[1] = dcbcfg->pfc.pfcena & 0xF;
+	buf[1] = dcbcfg->pfc.pfcena;
 }
 
 /**
-- 
2.38.1

