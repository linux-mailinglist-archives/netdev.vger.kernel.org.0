Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA0A6A6C06
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCAMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCAMAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:00:16 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751622F7B7;
        Wed,  1 Mar 2023 04:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677672015; x=1709208015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1BRx1cFZ8aFmlbAEYzeOUIKMH3jxuLSG/wPSL5VXqZs=;
  b=jY148CYHBNCTc1WqC0DJUZP6hAFXhy0qkZEmkl6y9TMWHnAOl3/9emNp
   hqc/ag8cDUyqYo2PxXD0e0tTNQMC7JwUZ63SsOQM0kMMMcwwbknio3N4N
   o2AcmgAkYXm8X+7qNNokNM4zTKS+Dz8Gu1XxdWXKu95e8qRy+h2mXasWG
   nyvPkBAyMK+c0Xp4B9xK4IEEVACFPT3PSWmL7aswS9Y9iY4uP9Mj5pmCr
   /PXamDYAS8kd4KAb9iXma1TFgw+FcIlz8akXWHBO4cUGLbE0Ws3520Yo6
   t+grr4WkJ0YbzknbpyGrkmP73G8zRMjlAdt34t3huZB4gZB/N3WWfggdd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="331870269"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="331870269"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 04:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="743405109"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="743405109"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga004.fm.intel.com with ESMTP; 01 Mar 2023 04:00:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 8240636A18;
        Wed,  1 Mar 2023 12:00:10 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND net v1 2/2] iavf: fix non-tunneled IPv6 UDP packet type and hashing
Date:   Wed,  1 Mar 2023 12:59:08 +0100
Message-Id: <20230301115908.47995-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301115908.47995-1-aleksander.lobakin@intel.com>
References: <20230301115908.47995-1-aleksander.lobakin@intel.com>
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
2.39.2

