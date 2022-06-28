Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04BE55EEA4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiF1Ty0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiF1Tu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0251C62;
        Tue, 28 Jun 2022 12:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445786; x=1687981786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zVh8rnbRSL6yxYm7j3MFZi5+oKCgLy0ivUDvveHIa48=;
  b=f2mOXHr1NtwdvSEGGpKwL2vuiVs+AXEzzrqeKg7DFtjzoX/KmuJfQVN4
   FH43XfU3W3w6vDFrGbRH60fhLuUN8KdQPHiawSINVur6itITi/O6ITM2T
   SZZKHXr4M/8HyugzqOOufwlvN0YmksqN/woK5BWxFB1fxNBFyztx0wSJr
   V8asIJ5DaP9qsczjI9/KvBO3ZtfNFBEzsVa9nEEPn8ItOLZgfGtGhmbfQ
   zJFOAQaV7IKrFEVnRusz9jpOIE0fy+Lxr1lAYulvE+u55z7eELFsfigbI
   W+9U9zw1Hsom7HVOyFkeWsLr5FplJnqOG+lFqsvn5gHtEE8/eEMNaUhwV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280595962"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280595962"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="732883439"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2022 12:49:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9Z022013;
        Tue, 28 Jun 2022 20:49:40 +0100
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
Subject: [PATCH RFC bpf-next 35/52] net, skbuff: introduce napi_skb_cache_get_bulk()
Date:   Tue, 28 Jun 2022 21:47:55 +0200
Message-Id: <20220628194812.1453059-36-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to get an array of skbs from the NAPI percpu cache.
It's supposed to be a drop-in replacement for
kmem_cache_alloc_bulk(skbuff_head_cache, GFP_ATOMIC) and
xdp_alloc_skb_bulk(GFP_ATOMIC). The difference (apart from the
requirement to call it only from the BH) is that it tries to use
as many NAPI cache entries for skbs as possible, and allocate new
ones only if and as less as needed.
It can save significant amounts of CPU cycles if there are GRO
cycles and/or Tx completion cycles (anything that descends to
napi_skb_cache_put()) happening on this CPU. If the function is
not able to provide the requested number of entries due to an
allocation error, it returns as much as it got.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0a95f753c1d9..0c1e5446653b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1240,6 +1240,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 void skb_attempt_defer_free(struct sk_buff *skb);
 
 struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
+size_t napi_skb_cache_get_bulk(void **skbs, size_t n);
 
 /**
  * alloc_skb - allocate a network buffer
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b23fc7f1157..9b075f52d1fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -190,6 +190,49 @@ static struct sk_buff *napi_skb_cache_get(void)
 	return skb;
 }
 
+/**
+ * napi_skb_cache_get_bulk - obtain a number of zeroed skb heads from the cache
+ * @skbs: a pointer to an at least @n-sized array to fill with skb pointers
+ * @n: the number of entries to provide
+ *
+ * Tries to obtain @n &sk_buff entries from the NAPI percpu cache and writes
+ * the pointers into the provided array @skbs. If there are less entries
+ * available, bulk-allocates the diff from the MM layer.
+ * The heads are being zeroed with either memset() or %__GFP_ZERO, so they are
+ * ready for {,__}build_skb_around() and don't have any data buffers attached.
+ * Must be called *only* from the BH context.
+ *
+ * Returns the number of successfully allocated skbs (@n if
+ * kmem_cache_alloc_bulk() didn't fail).
+ */
+size_t napi_skb_cache_get_bulk(void **skbs, size_t n)
+{
+	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+	size_t total = n;
+
+	if (nc->skb_count < n)
+		n -= kmem_cache_alloc_bulk(skbuff_head_cache,
+					   GFP_ATOMIC | __GFP_ZERO,
+					   n - nc->skb_count,
+					   skbs + nc->skb_count);
+	if (unlikely(nc->skb_count < n)) {
+		total -= n - nc->skb_count;
+		n = nc->skb_count;
+	}
+
+	for (size_t i = 0; i < n; i++) {
+		skbs[i] = nc->skb_cache[nc->skb_count - n + i];
+
+		kasan_unpoison_object_data(skbuff_head_cache, skbs[i]);
+		memset(skbs[i], 0, offsetof(struct sk_buff, tail));
+	}
+
+	nc->skb_count -= n;
+
+	return total;
+}
+EXPORT_SYMBOL_GPL(napi_skb_cache_get_bulk);
+
 /* Caller must provide SKB that is memset cleared */
 static void __build_skb_around(struct sk_buff *skb, void *data,
 			       unsigned int frag_size)
-- 
2.36.1

