Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885EA55EE97
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiF1Tyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbiF1Tu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C27101D5;
        Tue, 28 Jun 2022 12:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445788; x=1687981788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f++W//QJlwHfgm1DNYa0qsrg7yVxZsil1tIeQfMWplE=;
  b=AfngGRlqtLpC26acAHuYJlvLDUCzpYtJFlIVJ3OpNBzqU1GAhGZOWofQ
   xKodbPyGv1lHZzKBTylTQaRxe3jZzTCVU7TrwFu7fIOfXmqBVp5xNAGiG
   2B3mwNg+VMPj5dmEyro/+9Do9pu9fKSQtn2r/Tfv3S7tSPGt5OY7I+FwN
   eFK+xR81T1/fU28tRQx/CLEb8Ubdf4vmF7kWCDdBkdLCua7oriLGRp1si
   RFuuNH9dGcXL3gxC1/GHJS60PcN5SR7XsmujSnmMKlUqOFV//HEpZjDLM
   8ot3BKOZTTf0pZ4aKWldmljbiJURTeeyCHNRHZSH81NC4VaxGhgz9sfza
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="264874207"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="264874207"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="565181352"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2022 12:49:43 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9a022013;
        Tue, 28 Jun 2022 20:49:41 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 36/52] bpf, cpumap: switch to napi_skb_cache_get_bulk()
Date:   Tue, 28 Jun 2022 21:47:56 +0200
Message-Id: <20220628194812.1453059-37-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that cpumap uses GRO, which drops unused skb heads to the NAPI
cache, use napi_skb_cache_get_bulk() to try to reuse cached entries
and lower the MM layer pressure.
In the situation when all 8 skbs from one cpumap batch goes into one
GRO skb (so the rest 7 go into the cache), there will now be only 1
skb to allocate per cycle instead of 8. If there is some other work
happening in between the cycles, even all 8 might be getting
decached each cycle.
This makes the BH-off period per each batch slightly longer --
previously, skb allocation was happening in the process context.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 kernel/bpf/cpumap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 145f49de0931..1bb3ae570e6c 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -365,7 +365,6 @@ static int cpu_map_kthread_run(void *data)
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
 		unsigned int kmem_alloc_drops = 0, sched = 0;
-		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
 		int i, n, m, nframes, xdp_n;
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
@@ -416,8 +415,10 @@ static int cpu_map_kthread_run(void *data)
 
 		/* Support running another XDP prog on this CPU */
 		nframes = cpu_map_bpf_prog_run(rcpu, frames, xdp_n, &stats, &list);
+		local_bh_disable();
+
 		if (nframes) {
-			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
+			m = napi_skb_cache_get_bulk(skbs, nframes);
 			if (unlikely(m == 0)) {
 				for (i = 0; i < nframes; i++)
 					skbs[i] = NULL; /* effect: xdp_return_frame */
@@ -425,7 +426,6 @@ static int cpu_map_kthread_run(void *data)
 			}
 		}
 
-		local_bh_disable();
 		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
-- 
2.36.1

