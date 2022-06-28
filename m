Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D015B55EE85
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiF1Tyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA8930C;
        Tue, 28 Jun 2022 12:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445778; x=1687981778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PAudLE7AakzDffKtv0p+t6VMKmoJsLKi2pIu7DFNm7Y=;
  b=GPhNQCE+mdaEOanby3XEt8DJnaHZmMPIJ/6/2WXZYGEv6ES000F86NF5
   NVdGnW+lz0YAuVLrAAT3JtjV4N3CAmIZXZNtfkF9EaVWU+3ehPpK+ra+p
   2z/dCLDrDdbXgGfTqIE+qT2XgvQuJCtoWbnLjGx380qWKX9ffR7wJ8pDL
   Jn+mlJSZIOR5p5z0yph+ALUb4g2uuNbnn9hXhcn8XSVyC/GTjFYJffbIb
   30Tg8QAtNeRQroLVnOEAvNdekf427Mkn7cuwhyNQ+qXi5nkmPi4SQBAKk
   BeeGhVuDvuojzxLWEuw2bEQQuG0Wk9Zm9Wd1woJ1AUc1Tz0rpXX6zjgOA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568212"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568212"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="590426362"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2022 12:49:33 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9S022013;
        Tue, 28 Jun 2022 20:49:31 +0100
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
Subject: [PATCH RFC bpf-next 28/52] net, xdp: prefetch data a bit when building an skb from an &xdp_frame
Date:   Tue, 28 Jun 2022 21:47:48 +0200
Message-Id: <20220628194812.1453059-29-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Different cpumap tests showed that a couple of little careful
prefetches helps the performance. The only thing is to not go crazy:
only one cacheline to the right from the frame start and one to the
left -- if there is a metadata in front.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 net/bpf/core.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/bpf/core.c b/net/bpf/core.c
index a8685bcc6e00..775f9648e8cf 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -620,10 +620,26 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					   struct net_device *dev)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u32 dist, metasize = xdpf->metasize;
 	unsigned int headroom, frame_size;
+	void *data = xdpf->data;
 	void *hard_start;
 	u8 nr_frags;
 
+	/* Bring the headers to the current CPU, as well as the
+	 * metadata if present. This helps eth_type_trans() and
+	 * xdp_populate_skb_meta_generic().
+	 * The idea here is to prefetch no more than 2 cachelines:
+	 * one to the left from the data start and one to the right.
+	 */
+#define to_cl(ptr) PTR_ALIGN_DOWN(ptr, L1_CACHE_BYTES)
+	dist = min_t(typeof(dist), metasize, L1_CACHE_BYTES);
+	if (dist && to_cl(data - dist) != to_cl(data))
+		prefetch(data - dist);
+#undef to_cl
+
+	prefetch(data);
+
 	/* xdp frags frame */
 	if (unlikely(xdp_frame_has_frags(xdpf)))
 		nr_frags = sinfo->nr_frags;
@@ -636,15 +652,15 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	 */
 	frame_size = xdpf->frame_sz;
 
-	hard_start = xdpf->data - headroom;
+	hard_start = data - headroom;
 	skb = build_skb_around(skb, hard_start, frame_size);
 	if (unlikely(!skb))
 		return NULL;
 
 	skb_reserve(skb, headroom);
 	__skb_put(skb, xdpf->len);
-	if (xdpf->metasize)
-		skb_metadata_set(skb, xdpf->metasize);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
 
 	if (unlikely(xdp_frame_has_frags(xdpf)))
 		xdp_update_skb_shared_info(skb, nr_frags,
-- 
2.36.1

