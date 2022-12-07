Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0738F646085
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLGRo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLGRoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:44:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BC855CBE
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670434994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zDbg1E4iQ8iZrWi8icOJENxqpZHADn0utZrnGIpmHdg=;
        b=bWm4oeSUREJVrzgTvzH7bmlZCOYVWpZrc+vitz9GPNY0qpScHlvyOtlzR4Ls2pBVn+jsw9
        8r2c0onGj0mtvUIFl3+RIoFrS4EoG5WCORagIUsrgkbNeKBdG65Zac+3lVF2qaGC4EYBbX
        IwTmtTf7I9CCIXP5Ts3N9+Eo+mSmATw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-YuaXwoa-P9aTenAEJ_l2Iw-1; Wed, 07 Dec 2022 12:43:09 -0500
X-MC-Unique: YuaXwoa-P9aTenAEJ_l2Iw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A3A38582B9;
        Wed,  7 Dec 2022 17:43:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFD8940C6EC2;
        Wed,  7 Dec 2022 17:43:07 +0000 (UTC)
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
Content-ID: <1543007.1670434984.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 07 Dec 2022 17:43:04 +0000
Message-ID: <1543008.1670434984@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next=
.git master

diff --git a/kernel/kthread.c b/kernel/kthread.c
index f97fd01a2932..1335c89c6225 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -336,7 +336,6 @@ static int kthread(void *_create)
 	void *data =3D create->data;
 	struct completion *done;
 	struct kthread *self;
-	int ret;
 =

 	self =3D to_kthread(current);
 =

@@ -365,17 +364,20 @@ static int kthread(void *_create)
 	 * or the creator may spend more time in wait_task_inactive().
 	 */
 	preempt_disable();
+	if (test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
+		preempt_enable();
+		create->result =3D ERR_PTR(-EINTR);
+		complete(done);
+		do_exit(0);
+	}
 	complete(done);
 	schedule_preempt_disabled();
 	preempt_enable();
 =

-	ret =3D -EINTR;
-	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
-		cgroup_kthread_ready();
-		__kthread_parkme(self);
-		ret =3D threadfn(data);
-	}
-	kthread_exit(ret);
+	cgroup_kthread_ready();
+	__kthread_parkme(self);
+	/* Run the actual thread function. */
+	kthread_exit(threadfn(data));
 }
 =

 /* called from kernel_clone() to get node information for about to be cre=
ated task */
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 44222923c0d1..24ee585d9aaf 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -357,10 +357,11 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_loc=
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

