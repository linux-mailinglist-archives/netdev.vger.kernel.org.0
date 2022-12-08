Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA632646E5B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHLVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLHLVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C56037E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670498418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdWrMzc4dK/3bKJEBuu39zZgc8/cJ70+F9DEjGv5gLw=;
        b=BgER44Xw43nx5Z0tQTRUpSGC039olaSd/FU4+NKg1XD8In4dscP4QfSJdg0WDCMEWy8zXs
        Qkfn0BA4NflZCvEVtWVDLpAoOAGdyLC0eYmPgI1JFneBVZmIGcKv5HS3HFrddLz4o/Tk25
        HeY84d+pRkDTLwDfcwF4GDugQqwLda8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-UkN5dHHxM4y44upYdoPi7A-1; Thu, 08 Dec 2022 06:20:12 -0500
X-MC-Unique: UkN5dHHxM4y44upYdoPi7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BDEF803533;
        Thu,  8 Dec 2022 11:20:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1619740C2065;
        Thu,  8 Dec 2022 11:20:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000229f1505ef2b6159@google.com>
References: <000000000000229f1505ef2b6159@google.com>
To:     syzbot <syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_lookup_local
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1728522.1670498408.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 08 Dec 2022 11:20:08 +0000
Message-ID: <1728523.1670498408@warthog.procyon.org.uk>
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

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next=
.git master

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e7dccab7b741..37f3aec784cc 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -287,6 +287,7 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
+	struct completion	io_thread_ready; /* Indication that the I/O thread sta=
rted */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoi=
nt */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index d83ae3193032..e460e4151c16 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -426,6 +426,8 @@ int rxrpc_io_thread(void *data)
 	struct rxrpc_call *call;
 	struct sk_buff *skb;
 =

+	complete(&local->io_thread_ready);
+
 	skb_queue_head_init(&rx_queue);
 =

 	set_user_nice(current, MIN_NICE);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 44222923c0d1..d8dfd5459f50 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -96,6 +96,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrp=
c_net *rxnet,
 		atomic_set(&local->active_users, 1);
 		local->rxnet =3D rxnet;
 		INIT_HLIST_NODE(&local->link);
+		init_completion(&local->io_thread_ready);
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->call_attend_q);
@@ -189,6 +190,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local=
, struct net *net)
 		goto error_sock;
 	}
 =

+	wait_for_completion(&local->io_thread_ready);
 	local->io_thread =3D io_thread;
 	_leave(" =3D 0");
 	return 0;
@@ -357,10 +359,11 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_loc=
al *local,
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace =
why)
 {
-	unsigned int debug_id =3D local->debug_id;
+	unsigned int debug_id;
 	int r, u;
 =

 	if (local) {
+		debug_id =3D local->debug_id;
 		r =3D refcount_read(&local->ref);
 		u =3D atomic_dec_return(&local->active_users);
 		trace_rxrpc_local(debug_id, why, r, u);

