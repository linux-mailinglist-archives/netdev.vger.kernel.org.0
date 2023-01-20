Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9941F6753C8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjATLtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjATLsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:48:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89F2BCE1B
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674215207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/QFp3bmbYaYKk0E1nw7rLzrqQfs4EA+a58KvmrEwURo=;
        b=Jd76svPsdi/tGd1xt6hWZDH8yI7yzSLBZO+ElK54AEweWkzdKGzmIeyERycGD3sFEj2QDs
        TsUtgkXIbP5Y0NqwbUKIA8BeILev9sD6QjerQNuFUI0eQgHm2dMEXoZ1e4l8Wpo/ycUQFP
        ihgVI4bFFA4wG3sbuP2Bema8rpw2NnQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-eLk-0T6iNDiWrZ702ifmjA-1; Fri, 20 Jan 2023 06:46:41 -0500
X-MC-Unique: eLk-0T6iNDiWrZ702ifmjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A4383806070;
        Fri, 20 Jan 2023 11:46:41 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3597C40C2064;
        Fri, 20 Jan 2023 11:46:41 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id ECBE0300003EC;
        Fri, 20 Jan 2023 12:46:39 +0100 (CET)
Subject: [PATCH net-next RFC] net: introduce skb_poison_list and use in
 kfree_skb_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Fri, 20 Jan 2023 12:46:39 +0100
Message-ID: <167421519986.1321434.5887198904455029318.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First user of skb_poison_list is in kfree_skb_list_reason, to catch bugs
earlier like introduced in commit eedade12f4cb ("net: kfree_skb_list use
kmem_cache_free_bulk").

In case of a bug like mentioned commit we would have seen OOPS with:
 general protection fault, probably for non-canonical address 0xdead0000000000b1
And content of one the registers e.g. R13: dead000000000041

In this case skb->len is at offset 112 bytes (0x70) why fault happens at
 0x41+0x70 = 0xB1

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/poison.h |    3 +++
 include/linux/skbuff.h |    7 +++++++
 net/core/skbuff.c      |    4 +++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2d3249eb0e62..f44da61bb88f 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -81,6 +81,9 @@
 /********** net/core/page_pool.c **********/
 #define PP_SIGNATURE		(0x40 + POISON_POINTER_DELTA)
 
+/********** net/core/skbuff.c **********/
+#define SKB_LIST_POISON_NEXT	((void *)(0x41 + POISON_POINTER_DELTA))
+
 /********** kernel/bpf/ **********/
 #define BPF_PTR_POISON ((void *)(0xeB9FUL + POISON_POINTER_DELTA))
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..3b411a40a149 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1743,6 +1743,13 @@ static inline void skb_mark_not_on_list(struct sk_buff *skb)
 	skb->next = NULL;
 }
 
+static inline void skb_poison_list(struct sk_buff *skb)
+{
+#ifdef CONFIG_DEBUG_NET
+	skb->next = SKB_LIST_POISON_NEXT;
+#endif
+}
+
 /* Iterate through singly-linked GSO fragments of an skb. */
 #define skb_list_walk_safe(first, skb, next_skb)                               \
 	for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 180df58e85c7..02a1761ed0f9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -999,8 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		if (__kfree_skb_reason(segs, reason))
+		if (__kfree_skb_reason(segs, reason)) {
+			skb_poison_list(segs);
 			kfree_skb_add_bulk(segs, &sa, reason);
+		}
 
 		segs = next;
 	}


