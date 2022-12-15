Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C9164DE70
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiLOQUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiLOQUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:20:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9724A2F02E
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PeT2G/peKanAPSUrEqEYmZc7h4/xzdeLQWMNVJZY+ew=;
        b=IqQb/vUna2Y0eFdWymo3CAvtsc1gb6/IVp0wLEepQFQT+qRWEQxLYdTD4LqEUsZD/luI42
        abXbmRe+3wbWoxvf3O5IHvygX1AfmYocZv1t+gaujiNybLKYh1SOEeLrp1u9CQ7LMAUfIM
        2+PiWLwt1a1JMV2tVjWSbsNloyZnnvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-Ph_XzNJuMjO3L4o-24vpKg-1; Thu, 15 Dec 2022 11:19:46 -0500
X-MC-Unique: Ph_XzNJuMjO3L4o-24vpKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B764D100F909;
        Thu, 15 Dec 2022 16:19:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90C0151FF;
        Thu, 15 Dec 2022 16:19:41 +0000 (UTC)
Subject: [PATCH net 0/9] rxrpc: Fixes for I/O thread conversion/SACK table
 expansion
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <error27@gmail.com>, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:19:38 +0000
Message-ID: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for AF_RXRPC:

 (1) Fix missing unlock in rxrpc's sendmsg.

 (2) Fix (lack of) propagation of security settings to rxrpc_call.

 (3) Fix NULL ptr deref in rxrpc_unuse_local().

 (4) Fix problem with kthread_run() not invoking the I/O thread function if
     the kthread gets stopped first.  Possibly this should actually be
     fixed in the kthread code.

 (5) Fix locking problem as putting a peer (which may be done from RCU) may
     now invoke kthread_stop().

 (6) Fix switched parameters in a couple of trace calls.

 (7) Fix I/O thread's checking for kthread stop to make sure it completes
     all outstanding work before returning so that calls are cleaned up.

 (8) Fix an uninitialised var in the new rxperf test server.

 (9) Fix the return value of rxrpc_new_incoming_call() so that the checks
     on it work correctly.

The patches fix at least one syzbot bug[1] and probably some others that
don't have reproducers[2][3][4].  I think it also fixes another[5], but
that showed another failure during testing that was different to the
original.

There's also an outstanding bug in rxrpc_put_peer()[6] that is fixed by a
combination of several patches in my rxrpc-next branch, but I haven't
included that here.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20221215

and can also be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David

Link: https://syzkaller.appspot.com/bug?extid=3538a6a72efa8b059c38 [1]
Link: https://syzkaller.appspot.com/bug?extid=2a99eae8dc7c754bc16b [2]
Link: https://syzkaller.appspot.com/bug?extid=e1391a5bf3f779e31237 [3]
Link: https://syzkaller.appspot.com/bug?extid=2aea8e1c8e20cb27a01f [4]
Link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2 [5]
Link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd [6]

---
David Howells (9):
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      rxrpc: Fix security setting propagation
      rxrpc: Fix NULL deref in rxrpc_unuse_local()
      rxrpc: Fix I/O thread startup getting skipped
      rxrpc: Fix locking issues in rxrpc_put_peer_locked()
      rxrpc: Fix switched parameters in peer tracing
      rxrpc: Fix I/O thread stop
      rxrpc: rxperf: Fix uninitialised variable
      rxrpc: Fix the return value of rxrpc_new_incoming_call()


 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/ar-internal.h      |  8 ++++----
 net/rxrpc/call_accept.c      | 18 +++++++++---------
 net/rxrpc/call_object.c      |  1 +
 net/rxrpc/conn_client.c      |  2 --
 net/rxrpc/io_thread.c        | 10 +++++++---
 net/rxrpc/local_object.c     |  5 ++++-
 net/rxrpc/peer_event.c       | 10 +++++++---
 net/rxrpc/peer_object.c      | 23 ++---------------------
 net/rxrpc/rxperf.c           |  2 +-
 net/rxrpc/security.c         |  6 +++---
 net/rxrpc/sendmsg.c          |  2 +-
 12 files changed, 40 insertions(+), 49 deletions(-)


