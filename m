Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3DB4F450A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiDET6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 15:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457748AbiDEQjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:39:49 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97459D76C0;
        Tue,  5 Apr 2022 09:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649176670; x=1680712670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1a6ZVwGCUfADZf6orM/CqhG/a4zc3vyK0G6QcP2tC1g=;
  b=jw7EDf+L+XqJwajMyR42JEIswrrDGZ4pSArz507OxRXOrrSAfyQLz9tF
   KnW8nIOCPI8bJk0boVtN7JSYJhRI2ZechXQ0sEQ4EfIE8c/4vYDUbT7x5
   lQPDHi3wngQM9kv33FFVkluHHG5wI2t7l6ek6gqzpdWyMf/iQF+BHeRsz
   Yy0epPF2rxib/LHmeuRC/lDg2XWUIONA2Oje9sgGCZ/+fknZaSS0E8mB+
   A4OxjW9hp4vtoEXxmZEDj+RX0aU0ZKFgpm6kz9/2yPvCYY6ZaxfaXqNZ5
   /E4eUf3JdaWzG1D4cK58bjDXK2L7iZnerz1SadrAmti14EpUXCIEnD9VM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="321492689"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321492689"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 09:37:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="722116672"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 Apr 2022 09:37:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Subject: [PATCH net 2/3] ice: xsk: fix VSI state check in ice_xsk_wakeup()
Date:   Tue,  5 Apr 2022 09:38:02 -0700
Message-Id: <20220405163803.63815-3-anthony.l.nguyen@intel.com>
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

ICE_DOWN is dedicated for pf->state. Check for ICE_VSI_DOWN being set on
vsi->state in ice_xsk_wakeup().

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Shwetha Nagaraju <shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 33b28a72ffcb..866ee4df9671 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -920,7 +920,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_tx_ring *ring;
 
-	if (test_bit(ICE_DOWN, vsi->state))
+	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi))
-- 
2.31.1

