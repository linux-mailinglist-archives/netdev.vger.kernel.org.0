Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9543DD24E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhHBIwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:52:31 -0400
Received: from relay.sw.ru ([185.231.240.75]:44328 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232877AbhHBIw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=tAY88asZF2lnIac1kxZ5VSRxDa9BzKen9bRoCOT7Gjs=; b=QtpX3bKexjzADh0gSoh
        ggPQpEZOSKAm9u0vanUNKrf8b+dbAAO8uQTvVixOcePwf8GB7EscY0zK+XZOrzDFq2zWLV8kBjUy9
        s4fmLv9mJT0ZEXctNY2VBxtefKO+0UhVWn96ius4WuzsvztSs8lDn30p1/r0ttM1RQ2Wmdb8xCQ=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mATgG-0060Mn-Bw; Mon, 02 Aug 2021 11:52:16 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v3 1/7] skbuff: introduce skb_expand_head()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
 <cover.1627891754.git.vvs@virtuozzo.com>
Message-ID: <44880c9b-3611-5d26-9bbc-50e1b2264f1f@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:52:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1627891754.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like skb_realloc_headroom(), new helper increases headroom of specified skb.
Unlike skb_realloc_headroom(), it does not allocate a new skb if possible;
copies skb->sk on new skb when as needed and frees original skb in case
of failures.

This helps to simplify ip[6]_finish_output2() and a few other similar cases.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2db9cd..ec8a783 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1179,6 +1179,7 @@ static inline struct sk_buff *__pskb_copy(struct sk_buff *skb, int headroom,
 int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail, gfp_t gfp_mask);
 struct sk_buff *skb_realloc_headroom(struct sk_buff *skb,
 				     unsigned int headroom);
+struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom);
 struct sk_buff *skb_copy_expand(const struct sk_buff *skb, int newheadroom,
 				int newtailroom, gfp_t priority);
 int __must_check skb_to_sgvec_nomark(struct sk_buff *skb, struct scatterlist *sg,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fc7942c..0c70b2b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1786,6 +1786,48 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 EXPORT_SYMBOL(skb_realloc_headroom);
 
 /**
+ *	skb_expand_head - reallocate header of &sk_buff
+ *	@skb: buffer to reallocate
+ *	@headroom: needed headroom
+ *
+ *	Unlike skb_realloc_headroom, this one does not allocate a new skb
+ *	if possible; copies skb->sk to new skb as needed
+ *	and frees original skb in case of failures.
+ *
+ *	It expect increased headroom and generates warning otherwise.
+ */
+
+struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
+{
+	int delta = headroom - skb_headroom(skb);
+
+	if (WARN_ONCE(delta <= 0,
+		      "%s is expecting an increase in the headroom", __func__))
+		return skb;
+
+	/* pskb_expand_head() might crash, if skb is shared */
+	if (skb_shared(skb)) {
+		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
+
+		if (likely(nskb)) {
+			if (skb->sk)
+				skb_set_owner_w(nskb, skb->sk);
+			consume_skb(skb);
+		} else {
+			kfree_skb(skb);
+		}
+		skb = nskb;
+	}
+	if (skb &&
+	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+		kfree_skb(skb);
+		skb = NULL;
+	}
+	return skb;
+}
+EXPORT_SYMBOL(skb_expand_head);
+
+/**
  *	skb_copy_expand	-	copy and expand sk_buff
  *	@skb: buffer to copy
  *	@newheadroom: new free bytes at head
-- 
1.8.3.1

