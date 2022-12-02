Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2963FCA4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiLBAQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiLBAQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:16:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5946BCEF9D
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b9dh/kGDK2kRt5aTeyXrFqljd9Z/LSvIuqJ6g5olIic=;
        b=f7y6GZoyI0dRqFouuAdz7AnPI8V+4+Q7G4qUREBgmvawK2V7oTF7/SSMyyiR6RWS3Qp1c+
        d1oq+swz6yK5VEgVetU6aQjF747F+A6t+xyoD4KkcOaeoKz5N5xXsnCF+pGAx801g4qXxp
        2FGOqXstI+L6A3bKVAOjHizpPF7qQUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-aBsoxdDLM6eEva5Mv7OwKQ-1; Thu, 01 Dec 2022 19:15:08 -0500
X-MC-Unique: aBsoxdDLM6eEva5Mv7OwKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928D4800B23;
        Fri,  2 Dec 2022 00:15:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92876111E3F8;
        Fri,  2 Dec 2022 00:15:06 +0000 (UTC)
Subject: [PATCH net-next 00/36] rxrpc: Increasing SACK size and moving away
 from softirq, parts 2 & 3
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Jakub Kicinski <kuba@kernel.org>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:15:03 +0000
Message-ID: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are the second and third parts of patches in the process of moving
rxrpc from doing a lot of its stuff in softirq context to doing it in an
I/O thread in process context and thereby making it easier to support a
larger SACK table.

The full description is in the description for the first part[1] which is
already in net-next.

The second part includes some cleanups, adds some testing and overhauls
some tracing:

 (1) Remove declaration of rxrpc_kernel_call_is_complete() as the
     definition is no longer present.

 (2) Remove the knet() and kproto() macros in favour of using tracepoints.

 (3) Remove handling of duplicate packets from recvmsg.  The input side
     isn't now going to insert overlapping/duplicate packets into the
     recvmsg queue.

 (4) Don't use the rxrpc_conn_parameters struct in the rxrpc_connection or
     rxrpc_bundle structs - rather put the members in directly.

 (5) Extract the abort code from a received abort packet right up front
     rather than doing it in multiple places later.

 (6) Use enums and symbol lists rather than __builtin_return_address() to
     indicate where a tracepoint was triggered for local, peer, conn, call
     and skbuff tracing.

 (7) Add a refcount tracepoint for the rxrpc_bundle struct.

 (8) Implement an in-kernel server for the AFS rxperf testing program to
     talk to (enabled by a Kconfig option).

This is tagged as rxrpc-next-20221201-a.

The third part introduces the I/O thread and switches various bits over to
running there:

 (1) Fix call timers and call and connection workqueues to not hold refs on
     the rxrpc_call and rxrpc_connection structs to thereby avoid messy
     cleanup when the last ref is put in softirq mode.

 (2) Split input.c so that the call packet processing bits are separate
     from the received packet distribution bits.  Call packet processing
     gets bumped over to the call event handler.

 (3) Create a per-local endpoint I/O thread.  Barring some tiny bits that
     still get done in softirq context, all packet reception, processing
     and transmission is done in this thread.  That will allow a load of
     locking to be removed.

 (4) Perform packet processing and error processing from the I/O thread.

 (5) Provide a mechanism to process call event notifications in the I/O
     thread rather than queuing a work item for that call.

 (6) Move data and ACK transmission into the I/O thread.  ACKs can then be
     transmitted at the point they're generated rather than getting
     delegated from softirq context to some process context somewhere.

 (7) Move call and local processor event handling into the I/O thread.

 (8) Move cwnd degradation to after packets have been transmitted so that
     they don't shorten the window too quickly.

A bunch of simplifications can then be done:

 (1) The input_lock is no longer necessary as exclusion is achieved by
     running the code in the I/O thread only.

 (2) Don't need to use sk->sk_receive_queue.lock to guard socket state
     changes as the socket mutex should suffice.

 (3) Don't take spinlocks in RCU callback functions as they get run in
     softirq context and thus need _bh annotations.

 (4) RCU is then no longer needed for the peer's error_targets list.

 (5) Simplify the skbuff handling in the receive path by dropping the ref
     in the basic I/O thread loop and getting an extra ref as and when we
     need to queue the packet for recvmsg or another context.

 (6) Get the peer address earlier in the input process and pass it to the
     users so that we only do it once.

This is tagged as rxrpc-next-20221201-b.

Changes:
========
ver #2)
 - Added a patch to change four assertions into warnings in rxrpc_read()
   and fixed a checker warning from a __user annotation that should have
   been removed..
 - Change a min() to min_t() in rxperf as PAGE_SIZE doesn't seem to match
   type size_t on i386.
 - Three error handling issues in rxrpc_new_incoming_call():
   - If not DATA or not seq #1, should drop the packet, not abort.
   - Fix a goto that went to the wrong place, dropping a non-held lock.
   - Fix an rcu_read_lock that should've been an unlock.

Tested-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: kafs-testing+fedora36_64checkkafs-build-144@auristor.com
Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/r/166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk/ # v1
---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221201-b

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (36):
      rxrpc: Fix checker warning
      rxrpc: Implement an in-kernel rxperf server for testing purposes
      rxrpc: Fix call leak
      rxrpc: Remove decl for rxrpc_kernel_call_is_complete()
      rxrpc: Remove handling of duplicate packets in recvmsg_queue
      rxrpc: Remove the [k_]proto() debugging macros
      rxrpc: Remove the [_k]net() debugging macros
      rxrpc: Drop rxrpc_conn_parameters from rxrpc_connection and rxrpc_bundle
      rxrpc: Extract the code from a received ABORT packet much earlier
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_local tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_peer tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_conn tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_call tracing
      rxrpc: Trace rxrpc_bundle refcount
      rxrpc: trace: Don't use __builtin_return_address for sk_buff tracing
      rxrpc: Don't hold a ref for call timer or workqueue
      rxrpc: Don't hold a ref for connection workqueue
      rxrpc: Split the receive code
      rxrpc: Create a per-local endpoint receive queue and I/O thread
      rxrpc: Move packet reception processing into I/O thread
      rxrpc: Move error processing into the local endpoint I/O thread
      rxrpc: Remove call->input_lock
      rxrpc: Don't use sk->sk_receive_queue.lock to guard socket state changes
      rxrpc: Implement a mechanism to send an event notification to a call
      rxrpc: Copy client call parameters into rxrpc_call earlier
      rxrpc: Move DATA transmission into call processor work item
      rxrpc: Remove RCU from peer->error_targets list
      rxrpc: Simplify skbuff accounting in receive path
      rxrpc: Reduce the use of RCU in packet input
      rxrpc: Extract the peer address from an incoming packet earlier
      rxrpc: Make the I/O thread take over the call and local processor work
      rxrpc: Remove the _bh annotation from all the spinlocks
      rxrpc: Trace/count transmission underflows and cwnd resets
      rxrpc: Move the cwnd degradation after transmitting packets
      rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_local()
      rxrpc: Transmit ACKs at the point of generation


 include/net/af_rxrpc.h       |   2 +-
 include/trace/events/rxrpc.h | 486 +++++++++++++++++++-------
 net/rxrpc/Kconfig            |   7 +
 net/rxrpc/Makefile           |   4 +
 net/rxrpc/af_rxrpc.c         |  18 +-
 net/rxrpc/ar-internal.h      | 211 +++++------
 net/rxrpc/call_accept.c      | 191 +++++-----
 net/rxrpc/call_event.c       | 260 ++++++++------
 net/rxrpc/call_object.c      | 318 ++++++++---------
 net/rxrpc/conn_client.c      | 143 ++++----
 net/rxrpc/conn_event.c       | 128 ++++---
 net/rxrpc/conn_object.c      | 309 ++++++++---------
 net/rxrpc/conn_service.c     |  29 +-
 net/rxrpc/input.c            | 653 +++++------------------------------
 net/rxrpc/io_thread.c        | 496 ++++++++++++++++++++++++++
 net/rxrpc/key.c              |  16 +-
 net/rxrpc/local_event.c      |  46 +--
 net/rxrpc/local_object.c     | 167 +++------
 net/rxrpc/net_ns.c           |   2 +-
 net/rxrpc/output.c           | 227 ++++++------
 net/rxrpc/peer_event.c       | 167 +++------
 net/rxrpc/peer_object.c      |  52 ++-
 net/rxrpc/proc.c             |  67 ++--
 net/rxrpc/recvmsg.c          |  88 ++---
 net/rxrpc/rxkad.c            |  63 ++--
 net/rxrpc/rxperf.c           | 619 +++++++++++++++++++++++++++++++++
 net/rxrpc/security.c         |  34 +-
 net/rxrpc/sendmsg.c          | 105 ++----
 net/rxrpc/server_key.c       |  25 ++
 net/rxrpc/skbuff.c           |  36 +-
 net/rxrpc/txbuf.c            |  15 +-
 31 files changed, 2882 insertions(+), 2102 deletions(-)
 create mode 100644 net/rxrpc/io_thread.c
 create mode 100644 net/rxrpc/rxperf.c


