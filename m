Return-Path: <netdev+bounces-5064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBF170F91C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25D2C1C20831
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539A218C3A;
	Wed, 24 May 2023 14:49:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4932B18AF6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:49:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE720135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684939779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBjfMnLRdPLaOtZKQ3MfDk6Q85OlEId07NY6t+N1kv8=;
	b=S0r2cn5x1v2It/GNfLIvFTvdCyhHf5AipvaptBxcRQi8Nzi8E2avyht+zDqN70DJV6hxuJ
	j20oQ3YEJR1p5hmGJ0L4M/Z8Q6rbZCq6/RZt9uC06jO27YsOKLEZW5o/KeZpabKk3sHdEY
	HWfLOnWwVkgm3u+u0pXWohBjiNEqF5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-WIiQwQthN-adX17FR81rFw-1; Wed, 24 May 2023 10:49:36 -0400
X-MC-Unique: WIiQwQthN-adX17FR81rFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2C9785A5B5;
	Wed, 24 May 2023 14:49:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2BDC407DEC6;
	Wed, 24 May 2023 14:49:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tom Herbert <tom@herbertland.com>,
	Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 3/4] kcm: Support MSG_SPLICE_PAGES
Date: Wed, 24 May 2023 15:49:22 +0100
Message-Id: <20230524144923.3623536-4-dhowells@redhat.com>
In-Reply-To: <20230524144923.3623536-1-dhowells@redhat.com>
References: <20230524144923.3623536-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make AF_KCM sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator if possible.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tom Herbert <tom@herbertland.com>
cc: Tom Herbert <tom@quantonium.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/kcm/kcmsock.c | 55 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index cfe828bd7fc6..411726d830c0 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -989,29 +989,50 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			merge = false;
 		}
 
-		copy = min_t(int, msg_data_left(msg),
-			     pfrag->size - pfrag->offset);
+		if (msg->msg_flags & MSG_SPLICE_PAGES) {
+			copy = msg_data_left(msg);
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_memory;
 
-		if (!sk_wmem_schedule(sk, copy))
-			goto wait_for_memory;
+			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
+						   sk->sk_allocation);
+			if (err < 0) {
+				if (err == -EMSGSIZE)
+					goto wait_for_memory;
+				goto out_error;
+			}
 
-		err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
-					       pfrag->page,
-					       pfrag->offset,
-					       copy);
-		if (err)
-			goto out_error;
+			skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
+			sk_wmem_queued_add(sk, copy);
+			sk_mem_charge(sk, copy);
 
-		/* Update the skb. */
-		if (merge) {
-			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+			if (head != skb)
+				head->truesize += copy;
 		} else {
-			skb_fill_page_desc(skb, i, pfrag->page,
-					   pfrag->offset, copy);
-			get_page(pfrag->page);
+			copy = min_t(int, msg_data_left(msg),
+				     pfrag->size - pfrag->offset);
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_memory;
+
+			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
+						       pfrag->page,
+						       pfrag->offset,
+						       copy);
+			if (err)
+				goto out_error;
+
+			/* Update the skb. */
+			if (merge) {
+				skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
+			} else {
+				skb_fill_page_desc(skb, i, pfrag->page,
+						   pfrag->offset, copy);
+				get_page(pfrag->page);
+			}
+
+			pfrag->offset += copy;
 		}
 
-		pfrag->offset += copy;
 		copied += copy;
 		if (head != skb) {
 			head->len += copy;


