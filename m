Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3304566992F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbjAMNzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241553AbjAMNzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377B2DF5D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673617928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0XileK0BdObn4mSHgihspHyNqZhpMQEFASomg0cqBM=;
        b=NVrv9Apc9ZCXhtMYTh0ZLmMV3Qjf3nVMD1XAz613LV/53SaBXSbhDL70967e+RFrSb0A+J
        zgpmD9wOxKAEcJ2rwEIAz6KgAIuRSV88QtvHSG3k7vgGcU7uRqzGVFH6RGGlgUu4hPYgJ0
        TYdX9V5l9gG58J5IBjLEhGZcoddqCe8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-hHMX5lpwNseDkeUXKvb2sg-1; Fri, 13 Jan 2023 08:52:06 -0500
X-MC-Unique: hHMX5lpwNseDkeUXKvb2sg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE3091C08997;
        Fri, 13 Jan 2023 13:52:05 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9964D492B01;
        Fri, 13 Jan 2023 13:52:05 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A0D4C30721A6C;
        Fri, 13 Jan 2023 14:52:04 +0100 (CET)
Subject: [PATCH net-next V2 2/2] net: kfree_skb_list use kmem_cache_free_bulk
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Fri, 13 Jan 2023 14:52:04 +0100
Message-ID: <167361792462.531803.224198635706602340.stgit@firesoul>
In-Reply-To: <167361788585.531803.686364041841425360.stgit@firesoul>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kfree_skb_list function walks SKB (via skb->next) and frees them
individually to the SLUB/SLAB allocator (kmem_cache). It is more
efficient to bulk free them via the kmem_cache_free_bulk API.

This patches create a stack local array with SKBs to bulk free while
walking the list. Bulk array size is limited to 16 SKBs to trade off
stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
for SLUB the optimal bulk free case is 32 objects belonging to same
slab, but runtime this isn't likely to occur.

The expected gain from using kmem_cache bulk alloc and free API
have been assessed via a microbencmark kernel module[1].

The module 'slab_bulk_test01' results at bulk 16 element:
 kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
 kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)

More detailed description of benchmarks avail in [2].

[1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
[2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org

V2: rename function to kfree_skb_add_bulk.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 007a5fbe284b..79c9e795a964 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -964,16 +964,54 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
+#define KFREE_SKB_BULK_SIZE	16
+
+struct skb_free_array {
+	unsigned int skb_count;
+	void *skb_array[KFREE_SKB_BULK_SIZE];
+};
+
+static void kfree_skb_add_bulk(struct sk_buff *skb,
+			       struct skb_free_array *sa,
+			       enum skb_drop_reason reason)
+{
+	/* if SKB is a clone, don't handle this case */
+	if (unlikely(skb->fclone != SKB_FCLONE_UNAVAILABLE)) {
+		__kfree_skb(skb);
+		return;
+	}
+
+	skb_release_all(skb, reason);
+	sa->skb_array[sa->skb_count++] = skb;
+
+	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
+		kmem_cache_free_bulk(skbuff_head_cache, KFREE_SKB_BULK_SIZE,
+				     sa->skb_array);
+		sa->skb_count = 0;
+	}
+}
+
 void __fix_address
 kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 {
+	struct skb_free_array sa;
+
+	sa.skb_count = 0;
+
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
+		skb_mark_not_on_list(segs);
+
 		if (__kfree_skb_reason(segs, reason))
-			__kfree_skb(segs);
+			kfree_skb_add_bulk(segs, &sa, reason);
+
 		segs = next;
 	}
+
+	if (sa.skb_count)
+		kmem_cache_free_bulk(skbuff_head_cache, sa.skb_count,
+				     sa.skb_array);
 }
 EXPORT_SYMBOL(kfree_skb_list_reason);
 


