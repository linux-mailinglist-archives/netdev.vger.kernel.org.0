Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861EC6A5D76
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjB1Qss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjB1Qsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:48:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FB083D5;
        Tue, 28 Feb 2023 08:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677602887; x=1709138887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=exlFMpVF5vBUX97QGUIEERFQuxyaIwqV/MHoSJIWeoc=;
  b=T1WQN/gxnPOdTnMSKrH/q7H+BzRou7/PrZxu1GjrjxVybTmvkaZRa1/E
   HqmvKSnwHJmcyYv4MrEcM6zeFh3cSLi7utH78mnaZ54BSA2yKRaKP9N85
   AWZ4TjK7D9HxKfrCdWWPrObwtm8X+XrMr0we4cx8W9Pt92hQ3uO38IiB3
   N5PBlNzU2fGaDBrPAc4pUx/RBS8YYeBwWF8cKyqiQkEH8B3QYOc/dZV0b
   c2sOVkJMiCrXmvG3rYe6JIwCZWgTurqCaOsMHndxjcNFYi3woOz8AadB4
   DK+ysnwq/UvMIxTUV2D9h6TUaGXB4hYUTvh4tIsOsmnDKRVF9jmWsIjRS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="317986834"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="317986834"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:48:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="624107467"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="624107467"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 28 Feb 2023 08:48:04 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id CC0F9369F0;
        Tue, 28 Feb 2023 16:48:02 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] iavf: fix inverted Rx hash condition leading to disabled hash
Date:   Tue, 28 Feb 2023 17:46:12 +0100
Message-Id: <20230228164613.1360409-2-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230228164613.1360409-1-aleksander.lobakin@intel.com>
References: <20230228164613.1360409-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Condition, which checks whether the netdev has hashing enabled is
inverted. Basically, the tagged commit effectively disabled passing flow
hash from descriptor to skb, unless user *disables* it via Ethtool.
Commit a876c3ba59a6 ("i40e/i40evf: properly report Rx packet hash")
fixed this problem, but only for i40e.
Invert the condition now in iavf and unblock passing hash to skbs again.

Fixes: 857942fd1aa1 ("i40e: Fix Rx hash reported to the stack by our driver")
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 18b6a702a1d6..e989feda133c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1096,7 +1096,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
-- 
2.39.2

