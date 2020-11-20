Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3172BAFF3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgKTQS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:18:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729082AbgKTQSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605889101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbskkBS0w39EyEaWJEMsSJMWFGVaWwxQLH+uA8xDMj4=;
        b=dBBd9GWRE3+Dfr0PkPJSVFtudkIp+DUTJTAYDD0ShzvzUDsR5oS2u+u4K2ggtpZZ4V051u
        q+UXdJB5XRuaN2ibjU0LAw2V1RCBebIv2DQ9hPgfC3oLlk0ddFs03WcMsjSCPWluUV96nn
        9KiccGy+JSG1/ty1qSjYZ3Vi6S8dds8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-BumXM2vHM-GRVcxqclLgcw-1; Fri, 20 Nov 2020 11:18:18 -0500
X-MC-Unique: BumXM2vHM-GRVcxqclLgcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429C1801B19;
        Fri, 20 Nov 2020 16:18:16 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C890910016F7;
        Fri, 20 Nov 2020 16:18:12 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E16F83213845E;
        Fri, 20 Nov 2020 17:18:11 +0100 (CET)
Subject: [PATCH bpf-next V7 1/8] bpf: Remove MTU check in __bpf_skb_max_len
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Fri, 20 Nov 2020 17:18:11 +0100
Message-ID: <160588909185.2817268.7038636670740949181.stgit@firesoul>
In-Reply-To: <160588903254.2817268.4861837335793475314.stgit@firesoul>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
__bpf_skb_max_len() as the max-length. This function limit size against
the current net_device MTU (skb->dev->mtu).

When a BPF-prog grow the packet size, then it should not be limited to the
MTU. The MTU is a transmit limitation, and software receiving this packet
should be allowed to increase the size. Further more, current MTU check in
__bpf_skb_max_len uses the MTU from ingress/current net_device, which in
case of redirects uses the wrong net_device.

This patch keeps a sanity max limit of SKB_MAX_ALLOC (16KiB). The real limit
is elsewhere in the system. Jesper's testing[1] showed it was not possible
to exceed 8KiB when expanding the SKB size via BPF-helper. The limiting
factor is the define KMALLOC_MAX_CACHE_SIZE which is 8192 for
SLUB-allocator (CONFIG_SLUB) in-case PAGE_SIZE is 4096. This define is
in-effect due to this being called from softirq context see code
__gfp_pfmemalloc_flags() and __do_kmalloc_node(). Jakub's testing showed
that frames above 16KiB can cause NICs to reset (but not crash). Keep this
sanity limit at this level as memory layer can differ based on kernel
config.

[1] https://github.com/xdp-project/bpf-examples/tree/master/MTU-tests

V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..1ee97fdeea64 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3552,11 +3552,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 	return 0;
 }
 
-static u32 __bpf_skb_max_len(const struct sk_buff *skb)
-{
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
-}
+#define BPF_SKB_MAX_LEN SKB_MAX_ALLOC
 
 BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	   u32, mode, u64, flags)
@@ -3605,7 +3601,7 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 {
 	u32 len_cur, len_diff_abs = abs(len_diff);
 	u32 len_min = bpf_skb_net_base_len(skb);
-	u32 len_max = __bpf_skb_max_len(skb);
+	u32 len_max = BPF_SKB_MAX_LEN;
 	__be16 proto = skb->protocol;
 	bool shrink = len_diff < 0;
 	u32 off;
@@ -3688,7 +3684,7 @@ static int bpf_skb_trim_rcsum(struct sk_buff *skb, unsigned int new_len)
 static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
 					u64 flags)
 {
-	u32 max_len = __bpf_skb_max_len(skb);
+	u32 max_len = BPF_SKB_MAX_LEN;
 	u32 min_len = __bpf_skb_min_len(skb);
 	int ret;
 
@@ -3764,7 +3760,7 @@ static const struct bpf_func_proto sk_skb_change_tail_proto = {
 static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
 					u64 flags)
 {
-	u32 max_len = __bpf_skb_max_len(skb);
+	u32 max_len = BPF_SKB_MAX_LEN;
 	u32 new_len = skb->len + head_room;
 	int ret;
 


