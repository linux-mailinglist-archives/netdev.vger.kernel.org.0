Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169085FD918
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJMMSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJMMSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5299750065
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665663520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fkrJGvLv/zRxpOuQIQamH8XmYyze3emoi97+UvjPoh4=;
        b=UT5PrOAqx9vk4BhX+Ep2uihegSyHQMumxPJ8o4scPbz2QtFSoLPmD7f6Cf3hxDwCk47LS+
        U8F2gJ/guV6XV50JD8pLjzoVgk3KgfdhJaV2aNbuWXOGnp4GkOmyXiIQHmsrTsd8STflmA
        kud/dd930UrC8zs7xtq06uW133gWlWE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-484-0BQxJhd7Ohq_TGWPhAeW3g-1; Thu, 13 Oct 2022 08:18:39 -0400
X-MC-Unique: 0BQxJhd7Ohq_TGWPhAeW3g-1
Received: by mail-wr1-f69.google.com with SMTP id h17-20020adfaa91000000b0022e9f2245c8so476064wrc.19
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkrJGvLv/zRxpOuQIQamH8XmYyze3emoi97+UvjPoh4=;
        b=1rEqYI4DG0+B1fWWTQ4iNLaYF1Tqsc8TJxM+yMOkQ59iC1Qt3O3aIJ+pexs308MgII
         ffW87NYI0Wx3uyc6eQAY6OADNhPGT1hrWxenM9P7GZisBb760VleuT2el5kl7YSaDwSP
         4vWc4KxnvYUad4DhwMC8lSQsLaLd2DVEO0c77LhE/CQbD4FEhqRN6QjW8IhS1f38YOF6
         P7zYzbs62yidV9v0jFPh2c3IdhFJ1zz2rBSUCG452gb8NTaaZe9sQSbUlR+jIegY6xvw
         tFXTfhqy5y0+siBLJVEP2K76Jvu4Nu/WhipWdOPCOnjoiJsbDtX2QTkHWwDYPDBMEeUa
         UeXQ==
X-Gm-Message-State: ACrzQf2JmhwWzLJ+CD0E9WhNypeCKK1PZ7Ca209q5Sz7WpICYaq9jjM8
        ZKA/T4vpPlATeJNu8nPNpX34PCXcbBjVHUdaXRukjKm+n/LvqudBf8ZOyEJjBnWJPgDXvXNwIK8
        yniDOvecPFDSeIos8
X-Received: by 2002:a5d:6c62:0:b0:230:5aa7:6771 with SMTP id r2-20020a5d6c62000000b002305aa76771mr12896298wrz.158.1665663518060;
        Thu, 13 Oct 2022 05:18:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6yVX1OqJKHJSOzeCcGLgBgJ27RIgvJuSlrfma5WfGCZTbILZjo4IXllC8mm/0b40yq1UDZ6A==
X-Received: by 2002:a5d:6c62:0:b0:230:5aa7:6771 with SMTP id r2-20020a5d6c62000000b002305aa76771mr12896275wrz.158.1665663517813;
        Thu, 13 Oct 2022 05:18:37 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bh15-20020a05600c3d0f00b003b31c560a0csm4507586wmb.12.2022.10.13.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 05:18:37 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:18:34 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Trond Myklebust <trondmy@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2] sunrpc: Use GFP_NOFS to prevent use of
 current->task_frag.
Message-ID: <20221013121834.GA3353@localhost.localdomain>
References: <de6d99321d1dcaa2ad456b92b3680aa77c07a747.1665401788.git.gnault@redhat.com>
 <Y0QyYV1Wyo4vof70@infradead.org>
 <20221010165650.GA3456@ibm-p9z-18-fsp.mgmt.pnr.lab.eng.rdu2.redhat.com>
 <Y0UKq62ByUGNQpuY@infradead.org>
 <20221011150057.GB3606@localhost.localdomain>
 <a0bf0d49a7a69d20cfe007d66586a2649557a30b.camel@kernel.org>
 <20221011211433.GA13385@ibm-p9z-18-fsp.mgmt.pnr.lab.eng.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011211433.GA13385@ibm-p9z-18-fsp.mgmt.pnr.lab.eng.rdu2.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[Adding netdev and Eric, who commented on the original RFC.]

On Tue, Oct 11, 2022 at 11:14:36PM +0200, Guillaume Nault wrote:
> On Tue, Oct 11, 2022 at 11:57:53AM -0400, Trond Myklebust wrote:
> > On Tue, 2022-10-11 at 17:00 +0200, Guillaume Nault wrote:
> > > On Mon, Oct 10, 2022 at 11:18:19PM -0700, Christoph Hellwig wrote:
> > > > On Mon, Oct 10, 2022 at 06:56:50PM +0200, Guillaume Nault wrote:
> > > > > That's what my RFC patch did. It was rejected because reading
> > > > > current->flags may incur a cache miss thus slowing down TCP fast
> > > > > path.
> > > > > See the discussion in the Link tag:
> > > > > https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
> > > > 
> > > > As GFP_NOFS/NOIO are on their way out the networking people will
> > > > have to
> > > > do this anyway.
> > > 
> > > We can always think of a nicer solution in the future. But right now
> > > we
> > > have a real bug to fix.
> > > 
> > > Commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all
> > > rpciod/xprtiod jobs") introduces a bug that crashes the kernel. I
> > > can't
> > > see anything wrong with a partial revert.
> > > 
> > 
> > How about instead just adding a dedicated flag to the socket that
> > switches between the two page_frag modes?
> > 
> > That would remain future proofed, and it would give kernel users a
> > lever with which to do the right thing without unnecessarily
> > constraining the allocation modes.
> 
> The problem is to find a hole in struct sock, in a cacheline that
> wouldn't incur a cache miss.

Okay, so I have this patch that adds a flag in struct sock. The cache
line is shared with ->sk_shutdown and should be hot as ->sk_shutdown is
is tested just before the while() loop in tcp_sendmsg_locked().

Still, that looks like net-next material to me. Reverting sunrpc to use
GFP_NOFS looks better for an immediate bug fix.

------------ >8 ------------
net: Introduce sk_use_task_frag in struct sock.

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

Fixes: a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs")
Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/

diff --git a/include/net/sock.h b/include/net/sock.h
index 08038a385ef2..bd3eef3afb92 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -318,6 +318,9 @@ struct sk_filter;
   *	@sk_stamp: time stamp of last packet received
   *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
   *	@sk_tsflags: SO_TIMESTAMPING flags
+  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
+                           Sockets that can be used under memory reclaim should
+                           set this to false.
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
 
@@ -2554,14 +2558,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * socket operations and end up recursing into sk_page_frag()
  * while it's already in use: explicitly avoid task page_frag
  * usage if the caller is potentially doing any of them.
- * This assumes that page fault handlers use the GFP_NOFS flags.
+ * This assumes that page fault handlers use the GFP_NOFS flags or
+ * explicitely disable sk_use_task_frag.
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
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e976007f4fd0..d3170b753dfc 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1882,6 +1882,7 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_write_space = xs_udp_write_space;
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		xprt_clear_connected(xprt);
 
@@ -2083,6 +2084,7 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
+		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
 
@@ -2250,6 +2252,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		/* socket options */
 		sock_reset_flag(sk, SOCK_LINGER);

