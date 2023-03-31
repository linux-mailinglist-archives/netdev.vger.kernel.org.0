Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A7C6D2547
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjCaQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjCaQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:18:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A03FD4FA2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V7IwXZpp4caT5icSmRzfTKcX2kIg430bJYtEqUuaqXc=;
        b=TGf1+sUTpzZ1q2YPwYW1QjbEoAU6RtF3MnAwdeFcWhNliuv8nBjwMVjnJenSRKqJpDxKfl
        9gyUPyq1KmCKvfScplb5l4pgUt/0gEAHEuXJ5axZVgHhClzomzK4kKplezQvl2Ed8vQYCp
        5d1fDhT87kGmopQ+ryHLE5nf3bfqHDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-KUirUmF0P5GTXUc33yxBYQ-1; Fri, 31 Mar 2023 12:11:41 -0400
X-MC-Unique: KUirUmF0P5GTXUc33yxBYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2135D10119EB;
        Fri, 31 Mar 2023 16:11:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 120582166B33;
        Fri, 31 Mar 2023 16:11:37 +0000 (UTC)
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
Subject: [PATCH v3 50/55] kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Date:   Fri, 31 Mar 2023 17:09:09 +0100
Message-Id: <20230331160914.1608208-51-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
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
index d77d28fbf389..9c9d379aafb1 100644
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

