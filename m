Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B93368ECD4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjBHK2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjBHK2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C3E46084
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675852077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0bdW2lu7gvPActE9FfmWhTe4s3T0qdSQp6cZIX9NGg=;
        b=FX+x9aCMe/gp1yflbKkwv/A85/gyyBkagEUg36GGBwmOlWEQE11N9g/rplWBo5lCjB5oLV
        tNDFpoP8IH3ptXyK69/8w48WVzU0IuvaEBQ/xrXswJdKudTLJnw6KMTU5auCDsupr+atES
        E2Ru8wH+dcJSOmqvp6FHnPpnuvW+W7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-gxQTpNX-MGWQGk9aSn4jHg-1; Wed, 08 Feb 2023 05:27:56 -0500
X-MC-Unique: gxQTpNX-MGWQGk9aSn4jHg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90659800B23;
        Wed,  8 Feb 2023 10:27:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 769EB492C3F;
        Wed,  8 Feb 2023 10:27:54 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] rxrpc: Use consume_skb() rather than kfree_skb_reason()
Date:   Wed,  8 Feb 2023 10:27:47 +0000
Message-Id: <20230208102750.18107-2-dhowells@redhat.com>
In-Reply-To: <20230208102750.18107-1-dhowells@redhat.com>
References: <20230208102750.18107-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use consume_skb() rather than kfree_skb_reason().

Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 944320e65ea8..3bcd6ee80396 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -63,7 +63,7 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 	if (skb) {
 		int n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
-		kfree_skb_reason(skb, SKB_CONSUMED);
+		consume_skb(skb);
 	}
 }
 
@@ -78,6 +78,6 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 		int n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, refcount_read(&skb->users), n,
 				rxrpc_skb_put_purge);
-		kfree_skb_reason(skb, SKB_CONSUMED);
+		consume_skb(skb);
 	}
 }

