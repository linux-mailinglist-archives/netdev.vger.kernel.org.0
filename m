Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E23634303
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiKVRyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiKVRx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:53:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFB4BE84E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669139352; x=1700675352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JzOz5bVXkYUZE8ZlwVbwVP+eMXST791m6WnwLrIdrkQ=;
  b=k+lTliPu2hlT1+bWhkk2rJHmAJFesqqgkRqI/pkRE0hHPZvmfYk+FL+l
   CwJnnJkWfVPvjm6uKj/HQEyLjvOHB31V7sv57Mmfuyg4L1Q6C+P8SET4b
   hKjseXEXPksSMEGSTqFbaI+XMPxw55258TbYwjGt6dvZt2K8rprE0MEgK
   /qdfuuRjOs9gmRDt2pOcPl3Q9U7j7tzk2iv38LOT/jKlLABJUfsJ3mkik
   x6MEdW4EusLrNIMNbe1Tu280c1Nrb5y5p/BKrgFy6YsxE/NbEqtVtz1jI
   i0SeFxoiIpOFh9DGDZaC9Yu+pwJM9nJbnXnUL9IhFzdGzg2MO7hoHEMg9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="376018268"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="376018268"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 09:47:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="619301039"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="619301039"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2022 09:47:37 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        edumazet@google.com, pabeni@redhat.com
Subject: [PATCH net 3/4] net: wwan: iosm: fix crash in peek throughput test
Date:   Tue, 22 Nov 2022 23:17:34 +0530
Message-Id: <20221122174734.3496849-1-m.chetan.kumar@linux.intel.com>
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

