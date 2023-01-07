Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E74660D69
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjAGJxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjAGJxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846E17D1CF
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rIEC3SAlo0v2mH4ZztYrNVkXsYAur5kz6OPpXe2f6gE=;
        b=irdc1fLZh7rPFP3MmGJoo3GotPoVLQUqOD+uf+tFLE1bJIUz46pv87FC823bEX4hsVbREX
        PZqCiiTx3hN3YexSZ5G9DyCBFwIjGNvrlSoFPGyKu/n699oG4TBf/8yTG1podt25fzC9du
        WQdxxY3ovRSgIGK/GROvIxMN/tUHxis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-EGmrCz9ePSqRQSxoOsHzIg-1; Sat, 07 Jan 2023 04:52:53 -0500
X-MC-Unique: EGmrCz9ePSqRQSxoOsHzIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A9B0811E6E;
        Sat,  7 Jan 2023 09:52:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B1C01121314;
        Sat,  7 Jan 2023 09:52:52 +0000 (UTC)
Subject: [PATCH net 00/19] rxrpc: Fix race between call connection,
 data transmit and call disconnect
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:52:51 +0000
Message-ID: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
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


Here are patches to fix an oops[1] caused by a race between call
connection, initial packet transmission and call disconnection which
results in something like:

	kernel BUG at net/rxrpc/peer_object.c:413!

when the syzbot test is run.  The problem is that the connection procedure
is effectively split across two threads and can get expanded by taking an
interrupt, thereby adding the call to the peer error distribution list
*after* it has been disconnected (say by the rxrpc socket shutting down).

The easiest solution is to look at the fourth set of I/O thread
conversion/SACK table expansion patches that didn't get applied[2] and take
from it those patches that move call connection and disconnection into the
I/O thread.  Moving these things into the I/O thread means that the
sequencing is managed by all being done in the same thread - and the race
can no longer happen.

This is preferable to introducing an extra lock as adding an extra lock
would make the I/O thread have to wait for the app thread in yet another
place.

The changes can be considered as a number of logical parts:

 (1) Move all of the call state changes into the I/O thread.

 (2) Make client connection ID space per-local endpoint so that the I/O
     thread doesn't need locks to access it.

 (3) Move actual abort generation into the I/O thread and clean it up.  If
     sendmsg or recvmsg want to cause an abort, they have to delegate it.

 (4) Offload the setting up of the security context on a connection to the
     thread of one of the apps that's starting a call.  We don't want to be
     doing any sort of crypto in the I/O thread.

 (5) Connect calls (ie. assign them to channel slots on connections) in the
     I/O thread.  Calls are set up by sendmsg/kafs and passed to the I/O
     thread to connect.  Connections are allocated in the I/O thread after
     this.

 (6) Disconnect calls in the I/O thread.

I've also added a patch for an unrelated bug that cropped up during
testing, whereby a race can occur between an incoming call and socket
shutdown.


Note that whilst this fixes the original syzbot bug, another bug may get
triggered if this one is fixed:

	INFO: rcu detected stall in corrupted
	rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5792 } 2657 jiffies s: 2825 root: 0x0/T
	rcu: blocking rcu_node structures (internal RCU debug):

It doesn't look this should be anything to do with rxrpc, though, as I've
tested an additional patch[3] that removes practically all the RCU usage
from rxrpc and it still occurs.  It seems likely that it is being caused by
something in the tunnelling setup that the syzbot test does, but there's
not enough info to go on.  It also seems unlikely to be anything to do with
the afs driver as the test doesn't use that.


The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20230107

and can also be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David

Link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd [1]
Link: https://lore.kernel.org/r/167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk/ [2]
Link: https://lore.kernel.org/r/1278570.1673042093@warthog.procyon.org.uk/ [3]

---
David Howells (19):
      rxrpc: Stash the network namespace pointer in rxrpc_local
      rxrpc: Make the local endpoint hold a ref on a connected call
      rxrpc: Separate call retransmission from other conn events
      rxrpc: Only set/transmit aborts in the I/O thread
      rxrpc: Only disconnect calls in the I/O thread
      rxrpc: Implement a mechanism to send an event notification to a connection
      rxrpc: Clean up connection abort
      rxrpc: Tidy up abort generation infrastructure
      rxrpc: Make the set of connection IDs per local endpoint
      rxrpc: Offload the completion of service conn security to the I/O thread
      rxrpc: Set up a connection bundle from a call, not rxrpc_conn_parameters
      rxrpc: Split out the call state changing functions into their own file
      rxrpc: Wrap accesses to get call state to put the barrier in one place
      rxrpc: Move call state changes from sendmsg to I/O thread
      rxrpc: Move call state changes from recvmsg to I/O thread
      rxrpc: Remove call->state_lock
      rxrpc: Move the client conn cache management to the I/O thread
      rxrpc: Move client call connection to the I/O thread
      rxrpc: Fix incoming call setup race


 Documentation/networking/rxrpc.rst |   4 +-
 fs/afs/cmservice.c                 |   6 +-
 fs/afs/rxrpc.c                     |  24 +-
 include/net/af_rxrpc.h             |   3 +-
 include/trace/events/rxrpc.h       | 160 +++++--
 net/rxrpc/Makefile                 |   1 +
 net/rxrpc/af_rxrpc.c               |  27 +-
 net/rxrpc/ar-internal.h            | 212 ++++++---
 net/rxrpc/call_accept.c            |  57 ++-
 net/rxrpc/call_event.c             |  86 +++-
 net/rxrpc/call_object.c            | 116 +++--
 net/rxrpc/call_state.c             |  69 +++
 net/rxrpc/conn_client.c            | 709 ++++++++---------------------
 net/rxrpc/conn_event.c             | 382 ++++++----------
 net/rxrpc/conn_object.c            |  67 ++-
 net/rxrpc/conn_service.c           |   1 -
 net/rxrpc/input.c                  | 175 +++----
 net/rxrpc/insecure.c               |  20 +-
 net/rxrpc/io_thread.c              | 204 +++++----
 net/rxrpc/local_object.c           |  35 +-
 net/rxrpc/net_ns.c                 |  17 -
 net/rxrpc/output.c                 |  60 ++-
 net/rxrpc/peer_object.c            |  23 +-
 net/rxrpc/proc.c                   |  17 +-
 net/rxrpc/recvmsg.c                | 256 +++--------
 net/rxrpc/rxkad.c                  | 356 ++++++---------
 net/rxrpc/rxperf.c                 |  17 +-
 net/rxrpc/security.c               |  53 +--
 net/rxrpc/sendmsg.c                | 195 ++++----
 29 files changed, 1592 insertions(+), 1760 deletions(-)
 create mode 100644 net/rxrpc/call_state.c


