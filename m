Return-Path: <netdev+bounces-4245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304EC70BD3A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA5991C20A6C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE17D526;
	Mon, 22 May 2023 12:12:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C81D314
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:12:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FAB107
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684757538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Di14zlocOEDECmKOzgXOEyS4sjRLATonTy1WJdIXAUU=;
	b=cul1hH2ZjcACPvgRvbC7yUyba812B7cG0nlVmVZxlpIWux6lQdyw1drqQXvTRCrNx8qBKI
	VWtv1Q5ELX1Oo5k6013eHW/2PwmW9oIlK21QVZHjdHNgF6zRrQ39P7VPMsSaLcpch2xaPr
	0Vv+/6Q6EGDHvvameWjEzSZ/XJ5mUhU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-i0ekLMi1P3uITGz1Ox_XFQ-1; Mon, 22 May 2023 08:12:11 -0400
X-MC-Unique: i0ekLMi1P3uITGz1Ox_XFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2602780349B;
	Mon, 22 May 2023 12:12:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 856907B7C;
	Mon, 22 May 2023 12:12:07 +0000 (UTC)
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
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH net-next v10 11/16] ip, udp: Support MSG_SPLICE_PAGES
Date: Mon, 22 May 2023 13:11:20 +0100
Message-Id: <20230522121125.2595254-12-dhowells@redhat.com>
In-Reply-To: <20230522121125.2595254-1-dhowells@redhat.com>
References: <20230522121125.2595254-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---

Notes:
    ver #6)
     - Use common helper.

 net/ipv4/ip_output.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 52fc840898d8..c7db973b5d29 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1048,6 +1048,14 @@ static int __ip_append_data(struct sock *sk,
 				skb_zcopy_set(skb, uarg, &extra_uref);
 			}
 		}
+	} else if ((flags & MSG_SPLICE_PAGES) && length) {
+		if (inet->hdrincl)
+			return -EPERM;
+		if (rt->dst.dev->features & NETIF_F_SG)
+			/* We need an empty buffer to attach stuff to */
+			paged = true;
+		else
+			flags &= ~MSG_SPLICE_PAGES;
 	}
 
 	cork->length += length;
@@ -1207,6 +1215,15 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
+		} else if (flags & MSG_SPLICE_PAGES) {
+			struct msghdr *msg = from;
+
+			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
+						   sk->sk_allocation);
+			if (err < 0)
+				goto error;
+			copy = err;
+			wmem_alloc_delta += copy;
 		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 


