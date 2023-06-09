Return-Path: <netdev+bounces-9490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B846472963E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 168A81C210FB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BC914A99;
	Fri,  9 Jun 2023 10:03:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FED1642D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:03:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBF34237
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R74bPi2kwyePE/xmRN7KyjHRwIflZ6VoOr6lAl3jXjM=;
	b=fhtorRS2UnBGgWaU67YcN3Fq4QhH6cyNqYrxDo59fz51UNg06xiNVyG7ZUXoFnerZAj19R
	7ztCCuIHK0s4rRkH+K72Qr0D3UaglfgwdZi4dUtZdj/OrINru4IVURLqa8BMB2xEnkLVtB
	X8ozhmNqC5O94eVff+DIHc7IHyW6rQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-Y2G43H3wN2OR5zQ7GU9neg-1; Fri, 09 Jun 2023 06:02:42 -0400
X-MC-Unique: Y2G43H3wN2OR5zQ7GU9neg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6545785A5BA;
	Fri,  9 Jun 2023 10:02:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8EEBF492B0A;
	Fri,  9 Jun 2023 10:02:39 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tom Herbert <tom@herbertland.com>,
	Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 5/6] kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date: Fri,  9 Jun 2023 11:02:20 +0100
Message-ID: <20230609100221.2620633-6-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
References: <20230609100221.2620633-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When transmitting data, call down into the transport socket using sendmsg
with MSG_SPLICE_PAGES to indicate that content should be spliced rather
than using sendpage.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tom Herbert <tom@herbertland.com>
cc: Tom Herbert <tom@quantonium.net>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/kcm/kcmsock.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 7dee74430b59..3bcac1453f10 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -641,6 +641,10 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 
 		for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags;
 		     fragidx++) {
+			struct bio_vec bvec;
+			struct msghdr msg = {
+				.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
+			};
 			skb_frag_t *frag;
 
 			frag_offset = 0;
@@ -651,11 +655,13 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 				goto out;
 			}
 
-			ret = kernel_sendpage(psock->sk->sk_socket,
-					      skb_frag_page(frag),
-					      skb_frag_off(frag) + frag_offset,
-					      skb_frag_size(frag) - frag_offset,
-					      MSG_DONTWAIT);
+			bvec_set_page(&bvec,
+				      skb_frag_page(frag),
+				      skb_frag_size(frag) - frag_offset,
+				      skb_frag_off(frag) + frag_offset);
+			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1,
+				      bvec.bv_len);
+			ret = sock_sendmsg(psock->sk->sk_socket, &msg);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
 					/* Save state to try again when there's


