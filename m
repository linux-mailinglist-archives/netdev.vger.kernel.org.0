Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2642650A0AA
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiDUNYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbiDUNYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:24:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1285338BF;
        Thu, 21 Apr 2022 06:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650547310; x=1682083310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JUa5m/3AYneWyoIuicUzQgOmiMwiYyHAEiy56xSFTB8=;
  b=eYUiRkf5fjcORMCKhvBaKuFevbvu3xGuaaPKKGTqEL0uBslI+bfATDON
   wygAKtT4kL+k5CYlFGpUa68yEKkZWU/gmL3iIRYgYrXMf4zMO7QfqEsPI
   cAxTk0yTIRXf3XAatwYYNvB43110/eMoHtqrc36CYVTW+isGu4aZmnS0S
   +Wc6IfedIvS9/+klXC7HHJvamj9NE3P6V9wvJcTkyi3aJZoijHyT72+gN
   CzhZaPPCGN4mt8gVENUQaS+GMWeFGxclu/230TPqmv1gJnxhZ32hDcmvw
   TbUoB4zn1XnpF+/ssH4ApNGThEJOdpWUhOS1SXHtTs4jViSERE45bLRUT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="251664928"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="251664928"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 06:21:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="593655747"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2022 06:21:48 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        sfr@canb.auug.org.au, andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        linux-next@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/2] i40e: xsk: get rid of redundant 'fallthrough'
Date:   Thu, 21 Apr 2022 15:21:26 +0200
Message-Id: <20220421132126.471515-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
References: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel drivers translate actions returned from XDP programs to their own
return codes that have the following mapping:

XDP_REDIRECT -> I40E_XDP_{REDIR,CONSUMED}
XDP_TX -> I40E_XDP_{TX,CONSUMED}
XDP_DROP -> I40E_XDP_CONSUMED
XDP_ABORTED -> I40E_XDP_CONSUMED
XDP_PASS -> I40E_XDP_PASS

Commit b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx
queue gets full") introduced new translation

XDP_REDIRECT -> I40E_XDP_EXIT

which is set when XSK RQ gets full and to indicate that driver should
stop further Rx processing. This happens for unsuccessful
xdp_do_redirect() so it is valuable to call trace_xdp_exception() for
this case. In order to avoid I40E_XDP_EXIT -> IXGBE_XDP_CONSUMED
overwrite, XDP_DROP case was moved above which in turn made the
'fallthrough' that is in XDP_ABORTED useless as it became the last label
in the switch statement.

Simply drop this leftover.

Fixes: b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 050280fd10c1..af3e7e6afc85 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -189,7 +189,6 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		result = I40E_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough; /* handle aborts by dropping packet */
 	}
 	return result;
 }
-- 
2.27.0

