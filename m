Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAF06CDC59
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjC2OWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjC2OUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD74B4C2D
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9xMfNdsrDCo/ep+SBwQk+++P3r8+NfDYHGjOqRd99M=;
        b=VZTDfih0xKpPSpaze8DW9Or8Vwt6+rEYFJd1h06L8xU7nrLDORCD7pZtOxYgF3ZsuMqrob
        UZrRfJ6T+6MaWAlkI8Lov2ZFQ2FA8h6Rqw/Di91D1+eOwHc2NceL9FVciY63SVdhp4KL2C
        R1YeFplyxtmMMN+/s6oU/4NWKhsfddc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-Ojh5V2k9OAOrBsNjIDnCsA-1; Wed, 29 Mar 2023 10:16:01 -0400
X-MC-Unique: Ojh5V2k9OAOrBsNjIDnCsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C34E299E77B;
        Wed, 29 Mar 2023 14:15:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615572166B33;
        Wed, 29 Mar 2023 14:15:56 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tom Herbert <tom@herbertland.com>,
        Tom Herbert <tom@quantonium.net>
Subject: [RFC PATCH v2 43/48] kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date:   Wed, 29 Mar 2023 15:13:49 +0100
Message-Id: <20230329141354.516864-44-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header, data
pages and trailer.

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
 net/kcm/kcmsock.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index cfe828bd7fc6..819259149952 100644
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
@@ -651,11 +655,12 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
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
+			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bvec.bv_len);
+			ret = sock_sendmsg(psock->sk->sk_socket, &msg);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
 					/* Save state to try again when there's

