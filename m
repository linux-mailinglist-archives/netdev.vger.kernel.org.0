Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A71B6BD46D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjCPPzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCPPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:55:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF6B7D084
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678982099; x=1710518099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S+uEyo4xLLny139vZPGYymhU1OVI+zznyfDYuF8cMAw=;
  b=Z4kbmYkuayaVBwdw27Ov5nGOWVu9lEQZ6lPFtoj7eoWWUW+SzfzYMeCh
   0nTSKWF6NzuOGU1cA4IUSQhVjM4/rVafVzF8yPKC9O9ouaOTgXCWF3nvc
   9Ti9yOxYVwMIVtsL8CWyt6DZmaAI17PQgZ6hsF6VY5OZqXFTPdTy68kfE
   g9PFvKYeC9jymh/KlU61B/c5uE4B6J8cHjVZMTlepo6q7fQ7gCJDH7q+B
   4CiB7UmrfNQl22YS8bO6ofI9pVBl/GLDE9+XkPoel1PmjD5DuB8ckaUNC
   Em5CaIzazJqsmw+yHvpaZbUUXZRYb/nglcKbtB1ufSBLUE+nkxOzPRFtp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="340406442"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="340406442"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 08:54:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769010303"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="769010303"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2023 08:54:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        anthony.l.nguyen@intel.com, leonro@nvidia.com,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net v2 2/3] iavf: fix non-tunneled IPv6 UDP packet type and hashing
Date:   Thu, 16 Mar 2023 08:53:15 -0700
Message-Id: <20230316155316.1554931-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316155316.1554931-1-anthony.l.nguyen@intel.com>
References: <20230316155316.1554931-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>

Currently, IAVF's decode_rx_desc_ptype() correctly reports payload type
of L4 for IPv4 UDP packets and IPv{4,6} TCP, but only L3 for IPv6 UDP.
Originally, i40e, ice and iavf were affected.
Commit 73df8c9e3e3d ("i40e: Correct UDP packet header for non_tunnel-ipv6")
fixed that in i40e, then
commit 638a0c8c8861 ("ice: fix incorrect payload indicator on PTYPE")
fixed that for ice.
IPv6 UDP is L4 obviously. Fix it and make iavf report correct L4 hash
type for such packets, so that the stack won't calculate it on CPU when
needs it.

Fixes: 206812b5fccb ("i40e/i40evf: i40e implementation for skb_set_hash")
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 16c490965b61..dd11dbbd5551 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -661,7 +661,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[BIT(8)] = {
 	/* Non Tunneled IPv6 */
 	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	IAVF_PTT_UNUSED_ENTRY(91),
 	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-- 
2.38.1

