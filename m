Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9526D5482
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjDCWGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbjDCWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:06:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B404C38
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680559504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jnFtkoqMUBk9VK4xaDY9JMCyJUvcWn5aEBYFQqTdOKA=;
        b=SpDmDYPGjhKgouA/mZPv6zs+Bljf4MLjwIl3Y5vnHYNUiwgNruBWv9TeoJHi8c2gLpIG+S
        pv7uA6mRGmBuTyIzBIqmwlhjqaND7hLsgNhuAt0dZFcVW0IDsTx7zHrJy8jW23UDxoM7GQ
        AQUC/J+ZgNIp29uFs1wE6k8/qNQ9/pc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-H5UpbnI2P_GZNe0obnlrBw-1; Mon, 03 Apr 2023 18:05:00 -0400
X-MC-Unique: H5UpbnI2P_GZNe0obnlrBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 906571C051A7;
        Mon,  3 Apr 2023 22:04:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4329A1121314;
        Mon,  3 Apr 2023 22:04:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch>
References: <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch> <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch> <20230331160914.1608208-1-dhowells@redhat.com> <20230331160914.1608208-16-dhowells@redhat.com> <1818504.1680515446@warthog.procyon.org.uk>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2258797.1680559496.1@warthog.procyon.org.uk>
Date:   Mon, 03 Apr 2023 23:04:56 +0100
Message-ID: <2258798.1680559496@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> The code already has to avoid allocation in the MSG_ZEROCOPY case. I
> added alloc_len and paged_len for that purpose.
> 
> Only the transhdrlen will be copied with getfrag due to
> 
>     copy = datalen - transhdrlen - fraggap - pagedlen
> 
> On next iteration in the loop, when remaining data fits in the skb,
> there are three cases. The first is skipped due to !NETIF_F_SG. The
> other two are either copy to page frags or zerocopy page frags.
> 
> I think your code should be able to fit in. Maybe easier if it could
> reuse the existing alloc_new_skb code to copy the transport header, as
> MSG_ZEROCOPY does, rather than adding a new __ip_splice_alloc branch
> that short-circuits that. Then __ip_splice_pages also does not need
> code to copy the initial header. But this is trickier. It's fine to
> leave as is.
> 
> Since your code currently does call continue before executing the rest
> of that branch, no need to modify any code there? Notably replacing
> length with initial_length, which itself is initialized to length in
> all cases expect for MSG_SPLICE_PAGES.

Okay.  How about the attached?  This seems to work.  Just setting "paged" to
true seems to do the right thing in __ip_append_data() when allocating /
setting up the skbuff, and then __ip_splice_pages() is called to add the
pages.

David
---
commit 9ac72c83407c8aef4be0c84513ec27bac9cfbcaa
Author: David Howells <dhowells@redhat.com>
Date:   Thu Mar 9 14:27:29 2023 +0000

    ip, udp: Support MSG_SPLICE_PAGES
    
    Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
    spliced from the source iterator.
    
    This allows ->sendpage() to be replaced by something that can handle
    multiple multipage folios in a single transaction.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
    cc: "David S. Miller" <davem@davemloft.net>
    cc: Eric Dumazet <edumazet@google.com>
    cc: Jakub Kicinski <kuba@kernel.org>
    cc: Paolo Abeni <pabeni@redhat.com>
    cc: Jens Axboe <axboe@kernel.dk>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: netdev@vger.kernel.org

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6109a86a8a4b..fe2e48874191 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -956,6 +956,41 @@ csum_page(struct page *page, int offset, int copy)
 	return csum;
 }
 
+/*
+ * Add (or copy) data pages for MSG_SPLICE_PAGES.
+ */
+static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
+			     void *from, int *pcopy)
+{
+	struct msghdr *msg = from;
+	struct page *page = NULL, **pages = &page;
+	ssize_t copy = *pcopy;
+	size_t off;
+	int err;
+
+	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
+	if (copy <= 0)
+		return copy ?: -EIO;
+
+	err = skb_append_pagefrags(skb, page, off, copy);
+	if (err < 0) {
+		iov_iter_revert(&msg->msg_iter, copy);
+		return err;
+	}
+
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		__wsum csum;
+
+		csum = csum_page(page, off, copy);
+		skb->csum = csum_block_add(skb->csum, csum, skb->len);
+	}
+
+	skb_len_add(skb, copy);
+	refcount_add(copy, &sk->sk_wmem_alloc);
+	*pcopy = copy;
+	return 0;
+}
+
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
 			    struct sk_buff_head *queue,
@@ -1047,6 +1082,15 @@ static int __ip_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG) {
+			/* We need an empty buffer to attach stuff to */
+			paged = true;
+		} else {
+			flags &= ~MSG_SPLICE_PAGES;
+		}
 	}
 
 	cork->length += length;
@@ -1206,6 +1250,10 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			err = __ip_splice_pages(sk, skb, from, &copy);
+			if (err < 0)
+				goto error;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 

