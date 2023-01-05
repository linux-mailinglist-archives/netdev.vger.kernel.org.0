Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500765F05B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbjAEPn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbjAEPnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:43:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E9F5BA16
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672933372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYp6AQPel8dtlNVg/rN48yiTwiS5hJbozzUEGncjBS0=;
        b=CZ+KHhNxCDXv6HcrflXN1gsSCiTemOHqX3VecnSaBZBXgExuelKqucoUT87jhvzpUImKBO
        nd7pVAha5marGpzvsSmlKRj7bXFMocEBKdar6nI0YFg+age9fCTbAJOoJ0JOaBpdTI3L+4
        yn/17+mdhm+Sr9rN9mM1nRxGQZCyQpQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-kqFMhWPSNO6aUPHkbxhLxA-1; Thu, 05 Jan 2023 10:42:49 -0500
X-MC-Unique: kqFMhWPSNO6aUPHkbxhLxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28BCA803DD5;
        Thu,  5 Jan 2023 15:42:49 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D861121314;
        Thu,  5 Jan 2023 15:42:48 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id DA7DF30721A6C;
        Thu,  5 Jan 2023 16:42:47 +0100 (CET)
Subject: [PATCH net-next 2/2] net: kfree_skb_list use kmem_cache_free_bulk
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Thu, 05 Jan 2023 16:42:47 +0100
Message-ID: <167293336786.249536.14237439594457105125.stgit@firesoul>
In-Reply-To: <167293333469.249536.14941306539034136264.stgit@firesoul>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 007a5fbe284b..e6fa667174d5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -964,16 +964,53 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
+#define KFREE_SKB_BULK_SIZE	16
+
+struct skb_free_array {
+	unsigned int skb_count;
+	void *skb_array[KFREE_SKB_BULK_SIZE];
+};
+
+static void kfree_skb_defer_local(struct sk_buff *skb,
+				  struct skb_free_array *sa,
+				  enum skb_drop_reason reason)
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
+	sa.skb_count = 0;
+
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
+		skb_mark_not_on_list(segs);
+
 		if (__kfree_skb_reason(segs, reason))
-			__kfree_skb(segs);
+			kfree_skb_defer_local(segs, &sa, reason);
+
 		segs = next;
 	}
+
+	if (sa.skb_count)
+		kmem_cache_free_bulk(skbuff_head_cache, sa.skb_count,
+				     sa.skb_array);
 }
 EXPORT_SYMBOL(kfree_skb_list_reason);
 


