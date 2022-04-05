Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621CF4F44D0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385701AbiDEUFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457747AbiDEQjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:39:48 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA58CD763E;
        Tue,  5 Apr 2022 09:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649176669; x=1680712669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f/NnDNluwrPPVK9bocWIIxffrtTtf9T2hNVaplJZzMM=;
  b=ax8a1ymDMo31VgPiTOipaSzCJRu/RhD2r7APZ9ct9Q11olUra0PNrN8j
   iOVGqCgTHoJrnhN//6A68ylkX7GdOAT0CYzs0GCvqVIOcO4xe4auW7Pc6
   guwBIgmol8IfDFZPEzOcvkh2XSYhjiIkzO4jZqFEZvCROK41ckMml4BDj
   ILTf/IyXXb2j3e1uz/77m6wZhZOtRWvq5imNZCjNcIs5lBigBnmZ3RY6s
   Itn++EpMSsVrrAgnvfAJKOur9GImhWCGI6Ah8NFbJfsSP22J+CGC4mFYu
   Lt7WFeJzMT71y8QNj0+cxTOdVwmv778mEmSBkjEtfX7rDcTpRIoHT1xwP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="321492690"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321492690"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 09:37:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="722116675"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 Apr 2022 09:37:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Subject: [PATCH net 3/3] ice: clear cmd_type_offset_bsz for TX rings
Date:   Tue,  5 Apr 2022 09:38:03 -0700
Message-Id: <20220405163803.63815-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220405163803.63815-1-anthony.l.nguyen@intel.com>
References: <20220405163803.63815-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
Tested-by: Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d2039a9306b8..d768925785ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2562,7 +2562,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		spin_lock_init(&xdp_ring->tx_lock);
 		for (j = 0; j < xdp_ring->count; j++) {
 			tx_desc = ICE_TX_DESC(xdp_ring, j);
-			tx_desc->cmd_type_offset_bsz = cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE);
+			tx_desc->cmd_type_offset_bsz = 0;
 		}
 	}
 
-- 
2.31.1

