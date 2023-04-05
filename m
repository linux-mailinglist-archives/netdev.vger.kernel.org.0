Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D367B6D845E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjDEQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjDEQ4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:56:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CE6EAF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OMwy0qt4L2slgfHXAMvoFhpKJLhShXlB6/4lgaiCeU4=;
        b=fsPcXU9nLDFTuwDCwSmk3GuOvKKwxW65+3X8nj3/Q7ptinpTttZ2puwlrCLtRBA0tYqvKl
        esBZYOx2u8+cn9b7bl672y8Pr+Sm4NC8khEwfknq+lI+wfbO7NrFmbR7TE8HTB28Gl7+88
        CVAJAtQ1e76S4/GjZzXQhxEernt839w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-4RoSPamyNOOyKJ-8OPZdCA-1; Wed, 05 Apr 2023 12:54:36 -0400
X-MC-Unique: 4RoSPamyNOOyKJ-8OPZdCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 044E23823A0B;
        Wed,  5 Apr 2023 16:54:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2DAE2166B26;
        Wed,  5 Apr 2023 16:54:31 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH net-next v4 17/20] ip, udp: Make sendmsg(MSG_SPLICE_PAGES) copy unspliceable data
Date:   Wed,  5 Apr 2023 17:53:36 +0100
Message-Id: <20230405165339.3468808-18-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
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

If sendmsg() with MSG_SPLICE_PAGES encounters a page that shouldn't be
spliced - a slab page, for instance, or one with a zero count - make
__ip_append_data() copy it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/ip_output.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 13d19867ffd3..e34c86b1b59a 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -967,13 +967,32 @@ static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
 	struct page *page = NULL, **pages = &page;
 	ssize_t copy = *pcopy;
 	size_t off;
+	bool put = false;
 	int err;
 
 	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
 	if (copy <= 0)
 		return copy ?: -EIO;
 
+	if (!sendpage_ok(page)) {
+		const void *p = kmap_local_page(page);
+		void *q;
+
+		q = page_frag_memdup(NULL, p + off, copy,
+				     sk->sk_allocation, ULONG_MAX);
+		kunmap_local(p);
+		if (!q) {
+			iov_iter_revert(&msg->msg_iter, copy);
+			return -ENOMEM;
+		}
+		page = virt_to_page(q);
+		off = offset_in_page(q);
+		put = true;
+	}
+
 	err = skb_append_pagefrags(skb, page, off, copy);
+	if (put)
+		put_page(page);
 	if (err < 0) {
 		iov_iter_revert(&msg->msg_iter, copy);
 		return err;

