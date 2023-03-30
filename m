Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C516D0935
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjC3POZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjC3POY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:14:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56538D333
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680189078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NhGk7C4dqy0IhkWpLj7ZkWd43vsX2DX+V/BscIfaoMk=;
        b=QCsjK9rlP0BGo4spD9bb1ewil0IV3L6ICdvVSafECgt7/UWPVq6r//nf2vxdUdpC782bjX
        M5zTR7sbZzSgafAVWdrZREXpCuzDrwQJLGLTwsQ2eWV550viVCw99xMW4b0MpL5VJiwDTD
        1MsOco3e4BEA14FB4eTr6zbk2MMjAbM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-RyKUoDJ9OIyhstSXglnuWg-1; Thu, 30 Mar 2023 11:11:13 -0400
X-MC-Unique: RyKUoDJ9OIyhstSXglnuWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C4928028AD;
        Thu, 30 Mar 2023 15:11:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54828492C3E;
        Thu, 30 Mar 2023 15:11:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <64259aca22046_21883920890@willemb.c.googlers.com.notmuch>
References: <64259aca22046_21883920890@willemb.c.googlers.com.notmuch> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-17-dhowells@redhat.com>
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
Subject: Re: [RFC PATCH v2 16/48] ip, udp: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <854810.1680189069.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 16:11:09 +0100
Message-ID: <854811.1680189069@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> > +	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, xlength;
> =

> Does x here stand for anything?

Yeah... "bad naming".  How about if I call it initial_length?  I'm trying =
to
avoid allocating bufferage for the data.

> This does add a lot of code to two functions that are already
> unwieldy. It may be unavoidable, but it if can use helpers, that would
> be preferable.

Something like the attached?  (This is on top of patches 16-17, but I woul=
d
need to fold it in)

David
---
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index b38dbb2f9c3f..019ed9bb6745 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -956,6 +956,96 @@ csum_page(struct page *page, int offset, int copy)
 	return csum;
 }
 =

+/*
+ * Allocate a packet for MSG_SPLICE_PAGES.
+ */
+static int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
+			     unsigned int fragheaderlen, unsigned int maxfraglen,
+			     unsigned int hh_len)
+{
+	struct sk_buff *skb_prev =3D *pskb, *skb;
+	unsigned int fraggap =3D skb_prev->len - maxfraglen;
+	unsigned int alloclen =3D fragheaderlen + hh_len + fraggap + 15;
+
+	skb =3D sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
+	if (unlikely(!skb))
+		return -ENOBUFS;
+
+	/* Fill in the control structures */
+	skb->ip_summed =3D CHECKSUM_NONE;
+	skb->csum =3D 0;
+	skb_reserve(skb, hh_len);
+
+	/* Find where to start putting bytes. */
+	skb_put(skb, fragheaderlen + fraggap);
+	skb_reset_network_header(skb);
+	skb->transport_header =3D skb->network_header + fragheaderlen;
+	if (fraggap) {
+		skb->csum =3D skb_copy_and_csum_bits(skb_prev, maxfraglen,
+						   skb_transport_header(skb),
+						   fraggap);
+		skb_prev->csum =3D csum_sub(skb_prev->csum, skb->csum);
+		pskb_trim_unique(skb_prev, maxfraglen);
+	}
+
+	/* Put the packet on the pending queue. */
+	__skb_queue_tail(&sk->sk_write_queue, skb);
+	*pskb =3D skb;
+	return 0;
+}
+
+/*
+ * Add (or copy) data pages for MSG_SPLICE_PAGES.
+ */
+static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
+			     void *from, size_t *pcopy)
+{
+	struct msghdr *msg =3D from;
+	struct page *page =3D NULL, **pages =3D &page;
+	ssize_t copy =3D *pcopy;
+	size_t off;
+	bool put =3D false;
+	int err;
+
+	copy =3D iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off=
);
+	if (copy <=3D 0)
+		return copy ?: -EIO;
+
+	if (!sendpage_ok(page)) {
+		const void *p =3D kmap_local_page(page);
+		void *q;
+
+		q =3D page_frag_memdup(NULL, p + off, copy,
+				     sk->sk_allocation, ULONG_MAX);
+		kunmap_local(p);
+		if (!q)
+			return -ENOMEM;
+		page =3D virt_to_page(q);
+		off =3D offset_in_page(q);
+		put =3D true;
+	}
+
+	err =3D skb_append_pagefrags(skb, page, off, copy);
+	if (put)
+		put_page(page);
+	if (err < 0) {
+		iov_iter_revert(&msg->msg_iter, copy);
+		return err;
+	}
+
+	if (skb->ip_summed =3D=3D CHECKSUM_NONE) {
+		__wsum csum;
+
+		csum =3D csum_page(page, off, copy);
+		skb->csum =3D csum_block_add(skb->csum, csum, skb->len);
+	}
+
+	skb_len_add(skb, copy);
+	refcount_add(copy, &sk->sk_wmem_alloc);
+	*pcopy =3D copy;
+	return 0;
+}
+
 static int __ip_append_data(struct sock *sk,
 			    struct flowi4 *fl4,
 			    struct sk_buff_head *queue,
@@ -977,7 +1067,7 @@ static int __ip_append_data(struct sock *sk,
 	int err;
 	int offset =3D 0;
 	bool zc =3D false;
-	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, xlength;
+	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, initial_length;
 	int csummode =3D CHECKSUM_NONE;
 	struct rtable *rt =3D (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta =3D 0;
@@ -1017,7 +1107,7 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode =3D CHECKSUM_PARTIAL;
 =

-	xlength =3D length;
+	initial_length =3D length;
 	if ((flags & MSG_ZEROCOPY) && length) {
 		struct msghdr *msg =3D from;
 =

@@ -1053,7 +1143,7 @@ static int __ip_append_data(struct sock *sk,
 			return -EPERM;
 		if (!(rt->dst.dev->features & NETIF_F_SG))
 			return -EOPNOTSUPP;
-		xlength =3D transhdrlen; /* We need an empty buffer to attach stuff to =
*/
+		initial_length =3D transhdrlen; /* We need an empty buffer to attach st=
uff to */
 	}
 =

 	cork->length +=3D length;
@@ -1083,47 +1173,13 @@ static int __ip_append_data(struct sock *sk,
 			struct sk_buff *skb_prev;
 =

 			if (unlikely(flags & MSG_SPLICE_PAGES)) {
-				skb_prev =3D skb;
-				fraggap =3D skb_prev->len - maxfraglen;
-
-				alloclen =3D fragheaderlen + hh_len + fraggap + 15;
-				skb =3D sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
-				if (unlikely(!skb)) {
-					err =3D -ENOBUFS;
+				err =3D __ip_splice_alloc(sk, &skb, fragheaderlen,
+							maxfraglen, hh_len);
+				if (err < 0)
 					goto error;
-				}
-
-				/*
-				 *	Fill in the control structures
-				 */
-				skb->ip_summed =3D CHECKSUM_NONE;
-				skb->csum =3D 0;
-				skb_reserve(skb, hh_len);
-
-				/*
-				 *	Find where to start putting bytes.
-				 */
-				skb_put(skb, fragheaderlen + fraggap);
-				skb_reset_network_header(skb);
-				skb->transport_header =3D (skb->network_header +
-							 fragheaderlen);
-				if (fraggap) {
-					skb->csum =3D skb_copy_and_csum_bits(
-						skb_prev, maxfraglen,
-						skb_transport_header(skb),
-						fraggap);
-					skb_prev->csum =3D csum_sub(skb_prev->csum,
-								  skb->csum);
-					pskb_trim_unique(skb_prev, maxfraglen);
-				}
-
-				/*
-				 * Put the packet on the pending queue.
-				 */
-				__skb_queue_tail(&sk->sk_write_queue, skb);
 				continue;
 			}
-			xlength =3D length;
+			initial_length =3D length;
 =

 alloc_new_skb:
 			skb_prev =3D skb;
@@ -1136,7 +1192,7 @@ static int __ip_append_data(struct sock *sk,
 			 * If remaining data exceeds the mtu,
 			 * we know we need more fragment(s).
 			 */
-			datalen =3D xlength + fraggap;
+			datalen =3D initial_length + fraggap;
 			if (datalen > mtu - fragheaderlen)
 				datalen =3D maxfraglen - fragheaderlen;
 			fraglen =3D datalen + fragheaderlen;
@@ -1150,7 +1206,7 @@ static int __ip_append_data(struct sock *sk,
 			 * because we have no idea what fragment will be
 			 * the last.
 			 */
-			if (datalen =3D=3D xlength + fraggap)
+			if (datalen =3D=3D initial_length + fraggap)
 				alloc_extra +=3D rt->dst.trailer_len;
 =

 			if ((flags & MSG_MORE) &&
@@ -1258,48 +1314,9 @@ static int __ip_append_data(struct sock *sk,
 				goto error;
 			}
 		} else if (flags & MSG_SPLICE_PAGES) {
-			struct msghdr *msg =3D from;
-			struct page *page =3D NULL, **pages =3D &page;
-			size_t off;
-			bool put =3D false;
-
-			copy =3D iov_iter_extract_pages(&msg->msg_iter, &pages,
-						      copy, 1, 0, &off);
-			if (copy <=3D 0) {
-				err =3D copy ?: -EIO;
-				goto error;
-			}
-
-			if (!sendpage_ok(page)) {
-				const void *p =3D kmap_local_page(page);
-				void *q;
-
-				q =3D page_frag_memdup(NULL, p + off, copy,
-						     sk->sk_allocation, ULONG_MAX);
-				kunmap_local(p);
-				if (!q) {
-					err =3D copy ?: -ENOMEM;
-					goto error;
-				}
-				page =3D virt_to_page(q);
-				off =3D offset_in_page(q);
-				put =3D true;
-			}
-
-			err =3D skb_append_pagefrags(skb, page, off, copy);
-			if (put)
-				put_page(page);
+			err =3D __ip_splice_pages(sk, skb, from, &copy);
 			if (err < 0)
 				goto error;
-
-			if (skb->ip_summed =3D=3D CHECKSUM_NONE) {
-				__wsum csum;
-				csum =3D csum_page(page, off, copy);
-				skb->csum =3D csum_block_add(skb->csum, csum, skb->len);
-			}
-
-			skb_len_add(skb, copy);
-			refcount_add(copy, &sk->sk_wmem_alloc);
 		} else if (!zc) {
 			int i =3D skb_shinfo(skb)->nr_frags;
 =

