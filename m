Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDFF318DDF
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhBKPMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:12:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230452AbhBKO5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613055325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rv0AX4El3L9BRXhQ67Zd1G732A2I2MFEub7SaOhadis=;
        b=EmnngopT61NrtlSAFONRiQ7bTFJrN+RfYxhNx97l/isjJhujs15eFu3Xsk4zX0UXKiNf6s
        qjnfOFx52FPOo1mHSDApolcay+rWP9P2TAGcJTNhLzeRBlws/s2zqPxF1mmZo9auM4JmZ5
        NoeIdLKdKqDOG3eJWO1hRt7q8wRB02Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-3XopvuBpM9GU7hxzP4vlvQ-1; Thu, 11 Feb 2021 09:55:21 -0500
X-MC-Unique: 3XopvuBpM9GU7hxzP4vlvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36AF66D4EE;
        Thu, 11 Feb 2021 14:55:17 +0000 (UTC)
Received: from ovpn-115-49.ams2.redhat.com (ovpn-115-49.ams2.redhat.com [10.36.115.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 609AD60C17;
        Thu, 11 Feb 2021 14:55:05 +0000 (UTC)
Message-ID: <e30145f4fccae3f3543da88cef40633db42b59d2.camel@redhat.com>
Subject: Re: [PATCH v4 net-next 09/11] skbuff: allow to optionally use NAPI
 cache from __alloc_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 11 Feb 2021 15:55:04 +0100
In-Reply-To: <20210211142811.1813-1-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
         <20210210162732.80467-10-alobakin@pm.me>
         <58147c2d36ea7b6e0284d400229cd79185c53463.camel@redhat.com>
         <20210211142811.1813-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-02-11 at 14:28 +0000, Alexander Lobakin wrote:
> From: Paolo Abeni <pabeni@redhat.com> on Thu, 11 Feb 2021 11:16:40 +0100 wrote:
> > What about changing __napi_alloc_skb() to always use
> > the __napi_build_skb(), for both kmalloc and page backed skbs? That is,
> > always doing the 'data' allocation in __napi_alloc_skb() - either via
> > page_frag or via kmalloc() - and than call __napi_build_skb().
> > 
> > I think that should avoid adding more checks in __alloc_skb() and
> > should probably reduce the number of conditional used
> > by __napi_alloc_skb().
> 
> I thought of this too. But this will introduce conditional branch
> to set or not skb->head_frag. So one branch less in __alloc_skb(),
> one branch more here, and we also lose the ability to __alloc_skb()
> with decached head.

Just to try to be clear, I mean something alike the following (not even
build tested). In the fast path it has less branches than the current
code - for both kmalloc and page_frag allocation.

---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030..a242fbe4730e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -506,23 +506,12 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 				 gfp_t gfp_mask)
 {
 	struct napi_alloc_cache *nc;
+	bool head_frag, pfmemalloc;
 	struct sk_buff *skb;
 	void *data;
 
 	len += NET_SKB_PAD + NET_IP_ALIGN;
 
-	/* If requested length is either too small or too big,
-	 * we use kmalloc() for skb->head allocation.
-	 */
-	if (len <= SKB_WITH_OVERHEAD(1024) ||
-	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
-	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
-		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
-		if (!skb)
-			goto skb_fail;
-		goto skb_success;
-	}
-
 	nc = this_cpu_ptr(&napi_alloc_cache);
 	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	len = SKB_DATA_ALIGN(len);
@@ -530,25 +519,34 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = page_frag_alloc(&nc->page, len, gfp_mask);
+	if (len <= SKB_WITH_OVERHEAD(1024) ||
+            len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
+            (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
+		data = kmalloc_reserve(len, gfp_mask, NUMA_NO_NODE, &pfmemalloc);
+		head_frag = 0;
+		len = 0;
+	} else {
+		data = page_frag_alloc(&nc->page, len, gfp_mask);
+		pfmemalloc = nc->page.pfmemalloc;
+		head_frag = 1;
+	}
 	if (unlikely(!data))
 		return NULL;
 
 	skb = __build_skb(data, len);
 	if (unlikely(!skb)) {
-		skb_free_frag(data);
+		if (head_frag)
+			skb_free_frag(data);
+		else
+			kfree(data);
 		return NULL;
 	}
 
-	if (nc->page.pfmemalloc)
-		skb->pfmemalloc = 1;
-	skb->head_frag = 1;
+	skb->pfmemalloc = pfmemalloc;
+	skb->head_frag = head_frag;
 
-skb_success:
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 	skb->dev = napi->dev;
-
-skb_fail:
 	return skb;
 }
 EXPORT_SYMBOL(__napi_alloc_skb);

