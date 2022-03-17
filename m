Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BCC4DCDB9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiCQSjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiCQSjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:39:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C80B114DDE;
        Thu, 17 Mar 2022 11:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647542263; x=1679078263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+aM5r8r1moVYf5XPT33TV5YGB8tm7BfoYyZ/LZfWi6A=;
  b=K3mA1IR+WkA9j+KieCSbx2AgK3o1EDSy0RXXo0vPtPYpaRujAlcG15cd
   fveqqVoXIRXi1YfH9qnAW2UQSPQ0HLPa+0yo2FpH+rBomutpea2fZzYpR
   6PEyFYp2cbAUNAXvpiupi3Ueml2bGoDSDDnBTOMGPtGlTozgPq1Lekm83
   2DOo2qEWby7dqEWxtsrNprQSp5elXt2GI9JzM99TGMwZrlAFhuus92Up8
   Rrna4Z7LcSAG5Xw3Ud0WXjp6Ca3YbOXXri3ubUa+S8EwOoZ3Zv2is5Ipa
   C0UwktBZdnupXQGZbbkwPeoI+Y4ePJuMOItzXMLMCKCippuwIgs/jc2iV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="244405597"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="244405597"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 11:37:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="558057204"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 17 Mar 2022 11:37:40 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 3/3] ice: clear cmd_type_offset_bsz for TX rings
Date:   Thu, 17 Mar 2022 19:36:29 +0100
Message-Id: <20220317183629.340350-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
References: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when XDP rings are created, each descriptor gets its DD bit
set, which turns out to be the wrong approach as it can lead to a
situation where more descriptors get cleaned than it was supposed to,
e.g. when AF_XDP busy poll is run with a large batch size. In this
situation, the driver would request for more buffers than it is able to
handle.

Fix this by not setting the DD bits in ice_xdp_alloc_setup_rings(). They
should be initialized to zero instead.

Fixes: 9610bd988df9 ("ice: optimize XDP_TX workloads")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c3c73a61bfd0..5332bb24001a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2533,7 +2533,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		spin_lock_init(&xdp_ring->tx_lock);
 		for (j = 0; j < xdp_ring->count; j++) {
 			tx_desc = ICE_TX_DESC(xdp_ring, j);
-			tx_desc->cmd_type_offset_bsz = cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE);
+			tx_desc->cmd_type_offset_bsz = 0;
 		}
 	}
 
-- 
2.27.0

