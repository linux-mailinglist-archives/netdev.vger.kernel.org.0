Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947AC669931
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbjAMNzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbjAMNzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:55:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AB8E0E7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673617923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3EhPScMtbCPKZm9xpfr/mN7lFimKgGY+JcDiiUhMV/o=;
        b=PbSHinqbQqE1d18X3X8wa4P8gu8Vh+mE0LnvKHhgzI6T0zcacxuWdKn5xJGa8OwfQadeQT
        w1jKa3C32Wl3eILwwZsYBp2potjUDW63Gc7P6Hw8Zdb+OjxU5FD1hgixtx/HR8zMuSP3KM
        ByOAW5jbPvu4z+jN4QrSeaHT+entkTU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-HOfz830lNkWV4tYGyj3jrw-1; Fri, 13 Jan 2023 08:52:01 -0500
X-MC-Unique: HOfz830lNkWV4tYGyj3jrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D751A29AA3BD;
        Fri, 13 Jan 2023 13:52:00 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FCA453A0;
        Fri, 13 Jan 2023 13:52:00 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 96E4930721A6C;
        Fri, 13 Jan 2023 14:51:59 +0100 (CET)
Subject: [PATCH net-next V2 1/2] net: fix call location in
 kfree_skb_list_reason
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Fri, 13 Jan 2023 14:51:59 +0100
Message-ID: <167361791956.531803.7967465402017572462.stgit@firesoul>
In-Reply-To: <167361788585.531803.686364041841425360.stgit@firesoul>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SKB drop reason uses __builtin_return_address(0) to give the call
"location" to trace_kfree_skb() tracepoint skb:kfree_skb.

To keep this stable for compilers kfree_skb_reason() is annotated with
__fix_address (noinline __noclone) as fixed in commit c205cc7534a9
("net: skb: prevent the split of kfree_skb_reason() by gcc").

The function kfree_skb_list_reason() invoke kfree_skb_reason(), which
cause the __builtin_return_address(0) "location" to report the
unexpected address of kfree_skb_list_reason.

Example output from 'perf script':
 kpktgend_0  1337 [000]    81.002597: skb:kfree_skb: skbaddr=0xffff888144824700 protocol=2048 location=kfree_skb_list_reason+0x1e reason: QDISC_DROP

Patch creates an __always_inline __kfree_skb_reason() helper call that
is called from both kfree_skb_list() and kfree_skb_list_reason().
Suggestions for solutions that shares code better are welcome.

As preparation for next patch move __kfree_skb() invocation out of
this helper function.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/skbuff.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4a0eb5593275..007a5fbe284b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -932,6 +932,21 @@ void __kfree_skb(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(__kfree_skb);
 
+static __always_inline
+bool __kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
+{
+	if (unlikely(!skb_unref(skb)))
+		return false;
+
+	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
+
+	if (reason == SKB_CONSUMED)
+		trace_consume_skb(skb);
+	else
+		trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	return true;
+}
+
 /**
  *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
@@ -944,26 +959,19 @@ EXPORT_SYMBOL(__kfree_skb);
 void __fix_address
 kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
-	if (unlikely(!skb_unref(skb)))
-		return;
-
-	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
-
-	if (reason == SKB_CONSUMED)
-		trace_consume_skb(skb);
-	else
-		trace_kfree_skb(skb, __builtin_return_address(0), reason);
-	__kfree_skb(skb);
+	if (__kfree_skb_reason(skb, reason))
+		__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
-void kfree_skb_list_reason(struct sk_buff *segs,
-			   enum skb_drop_reason reason)
+void __fix_address
+kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 {
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		kfree_skb_reason(segs, reason);
+		if (__kfree_skb_reason(segs, reason))
+			__kfree_skb(segs);
 		segs = next;
 	}
 }


