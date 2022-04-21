Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15D650A0AC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiDUNYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiDUNYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:24:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBDBC22;
        Thu, 21 Apr 2022 06:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650547308; x=1682083308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PQmqOn+KgAcS/RR9MQjoll3YVK5YnLxlMQMVZ6DK4x0=;
  b=iAIcDuC7Ass2zDSndDX/z3ln9PawCEyV7xijFjzujNtD7CdPTfCxaLzt
   Dc9u+MQq9tZTpZM0GcLBJkHg0fZUxlBX9PYAXhhQOh7CoGSC17zzKaUYO
   Y2uJZexl2xXYw19BKxWUN9GNUKncCfcBHZNldlDW3/T1tg0FVXg0yj/zt
   iR7cMV1Aq8pznck9aHa6h5o+ECr/sLsUQi9z6saBRDK1T44s2ZXKLd5t4
   5OckL5rwDol+RDT76dyHr9XsDWooDoNZG/ksE8JWWlmFaQ3q/iDlHTOnU
   2uh/p4PDOGbOZ6PrdBeQ0NQuGRjXjs9HjLMEvGPWcHmLrcBby3cMfS8gU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="251664913"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="251664913"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 06:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="593655735"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2022 06:21:45 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        sfr@canb.auug.org.au, andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        linux-next@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/2] ixgbe: xsk: get rid of redundant 'fallthrough'
Date:   Thu, 21 Apr 2022 15:21:25 +0200
Message-Id: <20220421132126.471515-2-maciej.fijalkowski@intel.com>
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

XDP_REDIRECT -> IXGBE_XDP_{REDIR,CONSUMED}
XDP_TX -> IXGBE_XDP_{TX,CONSUMED}
XDP_DROP -> IXGBE_XDP_CONSUMED
XDP_ABORTED -> IXGBE_XDP_CONSUMED
XDP_PASS -> IXGBE_XDP_PASS

Commit c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx
queue gets full") introduced new translation

XDP_REDIRECT -> IXGBE_XDP_EXIT

which is set when XSK RQ gets full and to indicate that driver should
stop further Rx processing. This happens for unsuccessful
xdp_do_redirect() so it is valuable to call trace_xdp_exception() for
this case. In order to avoid IXGBE_XDP_EXIT -> IXGBE_XDP_CONSUMED
overwrite, XDP_DROP case was moved above which in turn made the
'fallthrough' that is in XDP_ABORTED useless as it became the last label
in the switch statement.

Simply drop this leftover.

Fixes: c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 68532cffd453..1703c640a434 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -144,7 +144,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		result = IXGBE_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough; /* handle aborts by dropping packet */
 	}
 	return result;
 }
-- 
2.27.0

