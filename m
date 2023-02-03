Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCA689950
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBCNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjBCNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:00:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DB812F1F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 04:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675429172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Qipuo39+OWAJneX1qgUqK++usvUlifX33Yoot1ktmc=;
        b=Vst2FoGFYyDQhXy3achw8ECqn3YrblsL/yiRqzqHX7BzLA5Vnys6JOOx4GMwCQ3H+o3+KK
        kjnwh8LJQY06lnKJmv3CkKfuFgat/KBZBO4EXSO8E/0yAn26Pgl2LugynfFQ4zF+cxMHYW
        zPWNyFTolfYxW1MlgNXSRG+mOd0kbtA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-FFGRHu3UOtmJAsl_io_RUQ-1; Fri, 03 Feb 2023 07:59:31 -0500
X-MC-Unique: FFGRHu3UOtmJAsl_io_RUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD15338123BD;
        Fri,  3 Feb 2023 12:59:30 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C9EA2166B34;
        Fri,  3 Feb 2023 12:59:30 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6D48F300003DD;
        Fri,  3 Feb 2023 13:59:29 +0100 (CET)
Subject: [PATCH net-next V2] net: introduce skb_poison_list and use in
 kfree_skb_list
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Fri, 03 Feb 2023 13:59:29 +0100
Message-ID: <167542916933.1167230.1244118780145312645.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
kmem_cache_free_bulk"). For completeness mentioned bug have been fixed in
commit f72ff8b81ebc ("net: fix kfree_skb_list use of skb_mark_not_on_list").

In case of a bug like mentioned commit we would have seen OOPS with:
 general protection fault, probably for non-canonical address 0xdead000000000870
And content of one the registers e.g. R13: dead000000000800

In this case skb->len is at offset 112 bytes (0x70) why fault happens at
 0x800+0x70 = 0x870

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/poison.h |    3 +++
 include/linux/skbuff.h |    7 +++++++
 net/core/skbuff.c      |    4 +++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2d3249eb0e62..2823f90fdab4 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -81,6 +81,9 @@
 /********** net/core/page_pool.c **********/
 #define PP_SIGNATURE		(0x40 + POISON_POINTER_DELTA)
 
+/********** net/core/skbuff.c **********/
+#define SKB_LIST_POISON_NEXT	((void *)(0x800 + POISON_POINTER_DELTA))
+
 /********** kernel/bpf/ **********/
 #define BPF_PTR_POISON ((void *)(0xeB9FUL + POISON_POINTER_DELTA))
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5ba12185f43e..1fa95b916342 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1738,6 +1738,13 @@ static inline void skb_mark_not_on_list(struct sk_buff *skb)
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
index 44a19805c355..624e9e4ec116 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1000,8 +1000,10 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		if (__kfree_skb_reason(segs, reason))
+		if (__kfree_skb_reason(segs, reason)) {
+			skb_poison_list(segs);
 			kfree_skb_add_bulk(segs, &sa, reason);
+		}
 
 		segs = next;
 	}


