Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE346493E5
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiLKL3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLKL3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:29:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07375FB5
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670758083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNkQnABR8UWJa/HG+JmJRBaw4tE3KriUNOm9fQ11KHU=;
        b=X5ykV3Mn3VGIeofbIUicMdXk6CsFwIhGcZfw8gqZ89KBrCFXZ8NxAOGA6ZkoXj6q46/82Y
        aH8rRq6Qv1GR8dCnaqDlp/ppVNNxJHVrmtGglGxNUFgIuQFRaaHUhB3cjHgvzu/cJoPTIa
        ayi4numb8knbQsB/kHKF0MiAq6s2ufA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-aPkUDenFMkC-OzvOhHPz3A-1; Sun, 11 Dec 2022 06:27:59 -0500
X-MC-Unique: aPkUDenFMkC-OzvOhHPz3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9231D1C07548;
        Sun, 11 Dec 2022 11:27:58 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 260C940C2065;
        Sun, 11 Dec 2022 11:27:58 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 8E1B510C30F0; Sun, 11 Dec 2022 06:20:12 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net v3 1/3] net: Introduce sk_use_task_frag in struct sock.
Date:   Sun, 11 Dec 2022 06:20:03 -0500
Message-Id: <1a369325ac2d4a604a074428f58fa72a6065e197.1670756903.git.bcodding@redhat.com>
In-Reply-To: <20221209201127.65dc2cdb@kernel.org>
References: <20221209201127.65dc2cdb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

Sockets that can be used while recursing into memory reclaim, like
those used by network block devices and file systems, mustn't use
current->task_frag: if the current process is already using it, then
the inner memory reclaim call would corrupt the task_frag structure.

To avoid this, sk_page_frag() uses ->sk_allocation to detect sockets
that mustn't use current->task_frag, assuming that those used during
memory reclaim had their allocation constraints reflected in
->sk_allocation.

This unfortunately doesn't cover all cases: in an attempt to remove all
usage of GFP_NOFS and GFP_NOIO, sunrpc stopped setting these flags in
->sk_allocation, and used memalloc_nofs critical sections instead.
This breaks the sk_page_frag() heuristic since the allocation
constraints are now stored in current->flags, which sk_page_frag()
can't read without risking triggering a cache miss and slowing down
TCP's fast path.

This patch creates a new field in struct sock, named sk_use_task_frag,
which sockets with memory reclaim constraints can set to false if they
can't safely use current->task_frag. In such cases, sk_page_frag() now
always returns the socket's page_frag (->sk_frag). The first user is
sunrpc, which needs to avoid using current->task_frag but can keep
->sk_allocation set to GFP_KERNEL otherwise.

Eventually, it might be possible to simplify sk_page_frag() by only
testing ->sk_use_task_frag and avoid relying on the ->sk_allocation
heuristic entirely (assuming other sockets will set ->sk_use_task_frag
according to their constraints in the future).

The new ->sk_use_task_frag field is placed in a hole in struct sock and
belongs to a cache line shared with ->sk_shutdown. Therefore it should
be hot and shouldn't have negative performance impacts on TCP's fast
path (sk_shutdown is tested just before the while() loop in
tcp_sendmsg_locked()).

Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
---
 include/net/sock.h | 11 +++++++++--
 net/core/sock.c    |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..44380c6dc6c4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -318,6 +318,9 @@ struct sk_filter;
   *	@sk_stamp: time stamp of last packet received
   *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
   *	@sk_tsflags: SO_TIMESTAMPING flags
+  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
+  *			   Sockets that can be used under memory reclaim should
+  *			   set this to false.
   *	@sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
   *	              for timestamping
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
@@ -505,6 +508,7 @@ struct sock {
 #endif
 	u16			sk_tsflags;
 	u8			sk_shutdown;
+	bool			sk_use_task_frag;
 	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
 
@@ -2561,14 +2565,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * socket operations and end up recursing into sk_page_frag()
  * while it's already in use: explicitly avoid task page_frag
  * usage if the caller is potentially doing any of them.
- * This assumes that page fault handlers use the GFP_NOFS flags.
+ * This assumes that page fault handlers use the GFP_NOFS flags or
+ * explicitly disable sk_use_task_frag.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+	if (sk->sk_use_task_frag &&
+	    (sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC |
+				  __GFP_FS)) ==
 	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
 		return &current->task_frag;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c..cc113500d442 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3368,6 +3368,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
 	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
 	sk->sk_state		=	TCP_CLOSE;
+	sk->sk_use_task_frag	=	true;
 	sk_set_socket(sk, sock);
 
 	sock_set_flag(sk, SOCK_ZAPPED);
-- 
2.31.1

