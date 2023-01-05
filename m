Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61B865F057
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbjAEPnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbjAEPnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:43:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A85C1F2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672933369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moLy3gk2AAvYoZFapcWuOq8ByoRH+wBG/nuahDdbM7I=;
        b=hnZAEMGYPwKuCwngGRyss1UxB514IQ2IVWhDF7mB5CE8UoLBks+hgGtbKLaG88qWjnnnNV
        Sct8H94usfxCFflsMS/DijyG2tokWLIaAeuceA3IRt21sgYbLqsoZWkbKpsRhwKjA9yvy7
        wCs1CTIttNNgBnvEV/1ItxC9hb0rbns=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-uRQdlEsMM6GC08v5fHSEDg-1; Thu, 05 Jan 2023 10:42:44 -0500
X-MC-Unique: uRQdlEsMM6GC08v5fHSEDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C69B01C087AC;
        Thu,  5 Jan 2023 15:42:43 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8A4140EBF6;
        Thu,  5 Jan 2023 15:42:43 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D06D730721A6C;
        Thu,  5 Jan 2023 16:42:42 +0100 (CET)
Subject: [PATCH net-next 1/2] net: fix call location in kfree_skb_list_reason
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Thu, 05 Jan 2023 16:42:42 +0100
Message-ID: <167293336279.249536.18331792118487373874.stgit@firesoul>
In-Reply-To: <167293333469.249536.14941306539034136264.stgit@firesoul>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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


