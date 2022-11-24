Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B7D63769E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKXKie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKXKi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:38:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D1424BCA
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669286308; x=1700822308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sM1WwMySYS33bDfk5kqMC3RU4FwCGEpxpHzl9SJrF/s=;
  b=Ik2bV/4/qQe9203IJEnBwMpKFdZ5Kt3BEtniW51ebowe0H+KRJH7fpB5
   ynneKRL46SKifqkoGHabdtK8XaxHxY0KxyobBnSE/XlTuEBE3uwFNfDqP
   +lAOnZGSUGxoZRNepNqf9f+Ro0fYipDDGYvJLa43JsaJVLJOak6VaN1XB
   uQ1EC2V/Qolz2bm/Wt0q4EleHzkOTBIp57ErWTgR8KyO83DuGypbO9IHg
   U6mXpAS68pWAN0mIJDuT5IG9jBVxlMeurgX5fWPN7yuXNYZc1yZShVGcu
   9A1lgceFF/wFwFl+ZZCsN4sdaKrBfXJZCPPpg9ELe3uHXF5KA04yu7XSg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="316096262"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="316096262"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:38:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="971207532"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="971207532"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga005.fm.intel.com with ESMTP; 24 Nov 2022 02:38:24 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH v2 net 3/4] net: wwan: iosm: fix crash in peek throughput test
Date:   Thu, 24 Nov 2022 16:08:17 +0530
Message-Id: <20221124103817.1446013-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Peek throughput UL test is resulting in crash. If the UL
transfer block free list is exhaust, the peeked skb is freed.
In the next transfer freed skb is referred from UL list which
results in crash.

Don't free the skb if UL transfer blocks are unavailable. The
pending skb will be picked for transfer on UL transfer block
available.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
--
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index c16365123660..738420bd14af 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -1207,10 +1207,9 @@ static int mux_ul_dg_update_tbl_index(struct iosm_mux *ipc_mux,
 				 qlth_n_ql_size, ul_list);
 	ipc_mux_ul_adb_finish(ipc_mux);
 	if (ipc_mux_ul_adb_allocate(ipc_mux, adb, &ipc_mux->size_needed,
-				    IOSM_AGGR_MUX_SIG_ADBH)) {
-		dev_kfree_skb(src_skb);
+				    IOSM_AGGR_MUX_SIG_ADBH))
 		return -ENOMEM;
-	}
+
 	ipc_mux->size_needed = le32_to_cpu(adb->adbh->block_length);
 
 	ipc_mux->size_needed += offsetof(struct mux_adth, dg);
-- 
2.34.1

