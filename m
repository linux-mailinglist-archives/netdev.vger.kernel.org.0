Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F5644879
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbiLFP7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiLFP7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:59:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A3240AF
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7g0LnaCVVBFg5bjNm736bQE91ZcWL1iYF9XTOaq+3F8=;
        b=EYc1+AZDCTkyrdDhRytaWvGKHgnk7xvnL9pSaSucmGQH3gyW76zIRFqurMGnLgSOMb7oCk
        BSHBo6XSQEJeb5ocOyf9MIj7WabQG72KAhws7JTYL7mQZ7ff8v3uADr2P0mLHNK5MpZWjS
        5M91z6SK1yEQ8+zunOrP75w6TuUFT3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-M1Cqj47eO-S-9_xOtweZqQ-1; Tue, 06 Dec 2022 10:58:40 -0500
X-MC-Unique: M1Cqj47eO-S-9_xOtweZqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96EAA101A54E;
        Tue,  6 Dec 2022 15:58:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC96F1759E;
        Tue,  6 Dec 2022 15:58:38 +0000 (UTC)
Subject: [PATCH net-next 00/32] rxrpc: Increasing SACK size and moving away
 from softirq, part 4
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:58:36 +0000
Message-ID: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
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


Here's the fourth part of patches in the process of moving rxrpc from doing
a lot of its stuff in softirq context to doing it in an I/O thread in
process context and thereby making it easier to support a larger SACK
table.

The full description is in the description for the first part[1] which is
already in net-next.  The second and third parts have also been pulled[2].

The fourth part includes some more moving of stuff to the I/O thread:

 (1) Changing the state of a call.  This gets the last bits of changing
     call state out of sendmsg() and recvmsg() so that all call state
     transitions happen in the call event handler in the I/O thread.

 (2) Aborting of calls.  sendmsg() and recvmsg() are no longer allowed to
     shift a call's state and send an ABORT packet; rather they stash the
     details in the rxrpc_call struct and send an event and the state
     change and transmission happen in the I/O thread.

 (3) Connection of client calls.  The app thread allocates a call and then
     asks the I/O thread to connect it, waiting until the resources are
     attached to it.  Responsibility for setting up the crypto for the
     connection is then delegated to the app thread.

 (4) Disconnection of calls.  Calls are now disconnected by their event
     handers in the I/O thread when they reach the completed state.

 (5) Management of client connections.  The tree containing the client
     connection IDs is moved to the local endpoint and put under the
     management of the I/O thread.

 (6) Completion of service connection security.  When a RESPONSE packet has
     been successfully verified in the conn's service thread, the packet is
     marked specially and passed back to the I/O thread so that relevant
     calls can be woken up.

With the above, a call's lifetime is almost entirely managed by the I/O
thread and this allows a lot of locking to be removed as the singular I/O
thread itself provides the necessary exclusion:

 (6) Remove the call->state_lock and wrap the call state transition
     handling into helper functions to insert the appropriate barriers.
     The barriers allow the abort state to be read locklessly after the
     completion state is set.

 (7) Don't use call->tx_lock to access ->tx_buffer as that is only accessed
     inside the I/O thread.  sendmsg() loads onto ->tx_sendmsg and the I/O
     thread decants from that to the buffer.

 (8) Convert ->recvmsg_lock to a spinlock as it's only ever locked
     exclusively.

 (9) Make ->ackr_window and ->ackr_nr_unacked non-atomic as they're only
     used in the I/O thread.

(10) Remove local->defrag_sem as DATA packets are transmitted serially by
     the I/O thread.

Some other bits are done also:

(11) Fix a missing unlock in rxrpc_do_sendmsg().

(12) Fix propagation of the security settings on new calls.

(13) Simplify the SACK table maintenance and ACK generation.  Now that both
     parts are done in the same thread, there's no possibility of a race
     and no need to try and be cunning to avoid taking a BH spinlock whilst
     copying the SACK table (which in the future will be up to 2K) and no
     need to rotate the copy to fit the ACK packet table.

(14) Use SKB_CONSUMED when freeing received DATA packets (stop dropwatch
     complaining).

(15) Tidy up the abort generation, in particular to have one tracepoint and
     a big enum of trace reasons rather than copying in a string.  If the
     input functions want to return an abort, they just tag the received
     skbuff and return false; rxrpc_io_thread() will reject the packet on
     their behalf.

(16) Add a debugging option to allow a delay to be injected into packet
     reception to help investigate the behaviour over longer links than
     just a few cm.

Tested-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: kafs-testing+fedora36_64checkkafs-build-153@auristor.com
Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/r/166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk/ [2]

---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221206

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (32):
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      rxrpc: Fix security setting propagation
      rxrpc: Simplify rxrpc_implicit_end_call()
      rxrpc: Separate call retransmission from other conn events
      rxrpc: Convert call->recvmsg_lock to a spinlock
      rxrpc: Convert call->state_lock to a spinlock
      rxrpc: Only set/transmit aborts in the I/O thread
      rxrpc: Only disconnect calls in the I/O thread
      rxrpc: Allow a delay to be injected into packet reception
      rxrpc: Generate extra pings for RTT during heavy-receive call
      rxrpc: De-atomic call->ackr_window and call->ackr_nr_unacked
      rxrpc: Simplify ACK handling
      rxrpc: Don't lock call->tx_lock to access call->tx_buffer
      rxrpc: Remove local->defrag_sem
      rxrpc: Implement a mechanism to send an event notification to a connection
      rxrpc: Clean up connection abort
      rxrpc: Tidy up abort generation infrastructure
      rxrpc: Stash the network namespace pointer in rxrpc_local
      rxrpc: Make the set of connection IDs per local endpoint
      rxrpc: Offload the completion of service conn security to the I/O thread
      rxrpc: Set up a connection bundle from a call, not rxrpc_conn_parameters
      rxrpc: Split out the call state changing functions into their own file
      rxrpc: Wrap accesses to get call state to put the barrier in one place
      rxrpc: Move call state changes from sendmsg to I/O thread
      rxrpc: Move call state changes from recvmsg to I/O thread
      rxrpc: Remove call->state_lock
      rxrpc: Make the local endpoint hold a ref on a connected call
      rxrpc: Move the client conn cache management to the I/O thread
      rxrpc: Show consumed and freed packets as non-dropped in dropwatch
      rxrpc: Change rx_packet tracepoint to display securityIndex not type twice
      rxrpc: Move client call connection to the I/O thread
      rxrpc: Kill service bundle


 Documentation/networking/rxrpc.rst |   4 +-
 fs/afs/cmservice.c                 |   6 +-
 fs/afs/rxrpc.c                     |  24 +-
 include/net/af_rxrpc.h             |   3 +-
 include/trace/events/rxrpc.h       | 213 +++++++--
 net/rxrpc/Kconfig                  |   9 +
 net/rxrpc/Makefile                 |   1 +
 net/rxrpc/af_rxrpc.c               |  21 +-
 net/rxrpc/ar-internal.h            | 203 ++++++---
 net/rxrpc/call_accept.c            |  31 +-
 net/rxrpc/call_event.c             |  99 +++-
 net/rxrpc/call_object.c            | 121 +++--
 net/rxrpc/call_state.c             |  69 +++
 net/rxrpc/conn_client.c            | 701 ++++++++---------------------
 net/rxrpc/conn_event.c             | 381 ++++++----------
 net/rxrpc/conn_object.c            |  46 +-
 net/rxrpc/conn_service.c           |   8 -
 net/rxrpc/input.c                  | 233 +++++-----
 net/rxrpc/insecure.c               |  20 +-
 net/rxrpc/io_thread.c              | 249 ++++++----
 net/rxrpc/local_object.c           |  42 +-
 net/rxrpc/misc.c                   |   7 +
 net/rxrpc/net_ns.c                 |  17 -
 net/rxrpc/output.c                 | 129 ++++--
 net/rxrpc/peer_object.c            |  23 +-
 net/rxrpc/proc.c                   |  21 +-
 net/rxrpc/recvmsg.c                | 272 ++++-------
 net/rxrpc/rxkad.c                  | 356 ++++++---------
 net/rxrpc/rxperf.c                 |  17 +-
 net/rxrpc/security.c               |  54 +--
 net/rxrpc/sendmsg.c                | 196 ++++----
 net/rxrpc/skbuff.c                 |   4 +-
 net/rxrpc/sysctl.c                 |  17 +-
 net/rxrpc/txbuf.c                  |  12 +-
 34 files changed, 1755 insertions(+), 1854 deletions(-)
 create mode 100644 net/rxrpc/call_state.c


