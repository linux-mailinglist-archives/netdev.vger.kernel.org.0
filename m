Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63CA654FFD
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiLWMCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLWMBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:01:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EBD4AF00
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WqoDmHwombh22HcqTLAH3v0XYTM++j8qClNa0n+ybPA=;
        b=IWGRW1Je8Ul0OnRKvXBgVzCRMiWinyB1AOyj2Mal1+oxy35SpKKBthYl/Z4aOaM3lRj67w
        nc3mpdpJjfhbDgXgVU/ihVDzQNRO8ApqgLUb6TP2Ugp5OwBJ5smSxfKb0B04Gqo6juAfGw
        aAb+VY2WgY5risTbC0F51sqPmEgn+yg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-W3a9M0w-OICzO0GntQQrLg-1; Fri, 23 Dec 2022 07:00:01 -0500
X-MC-Unique: W3a9M0w-OICzO0GntQQrLg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D58B1C25E80;
        Fri, 23 Dec 2022 12:00:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FA69492B00;
        Fri, 23 Dec 2022 12:00:00 +0000 (UTC)
Subject: [PATCH net 00/19] rxrpc: More fixes for I/O thread conversion/SACK
 table expansion
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 11:59:59 +0000
Message-ID: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are patches to fix a pair of bugs in rxrpc, one of them introduced in
the I/O thread conversion.

The first patch stands alone, fixing a couple of potential use-after-frees
due to a trace line referring to a call happening after the call has been
put in recvmsg.

The rest of the patches fix an oops[1] caused by a race between call
connection and call disconnection which results in something like:

	kernel BUG at net/rxrpc/peer_object.c:413!

when the syzbot test is run.  The problem is that the connection procedure
can get expanded by taking an interrupt, thereby adding the call to the
peer error distribution list *after* it has been disconnected (say be the
rxrpc socket shutting down).

The easiest solution is to look at the fourth set of I/O thread
conversion/SACK table expansion patches that didn't get applied[2] and take
from it those patches that move call connection and disconnection into the
I/O thread.  Moving these things into the I/O thread means that the
sequencing is managed by all being done in the same thread - and the race
can no longer happen.

This is preferable to introducing adding an extra lock as adding an extra
lock would make the I/O thread have to wait for the app thread in yet
another place.

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

Note that whilst this fixes the original syzbot bug, another bug may get
triggered if this one is fixed:

	INFO: rcu detected stall in corrupted
	rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5792 } 2657 jiffies s: 2825 root: 0x0/T
	rcu: blocking rcu_node structures (internal RCU debug):

It doesn't look this should be anything to do with rxrpc, though, as I've
cut the RCU usage to the minimum, there aren't any missing rcu_read_locks
or unlocks that I can see and the test doesn't use the rxrpc procfiles.  It
may be being caused by the tunnelling setup that the syzbot test does, but
there's not enough info to go on.  It also seems unlikely to be anything to
do with the afs driver as the test doesn't use that.


The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20221222

and can also be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David

Link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd [1]
Link: https://lore.kernel.org/r/167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk/ [2]

---
David Howells (19):
      rxrpc: Fix a couple of potential use-after-frees
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


 Documentation/networking/rxrpc.rst |   4 +-
 fs/afs/cmservice.c                 |   6 +-
 fs/afs/rxrpc.c                     |  24 +-
 include/net/af_rxrpc.h             |   3 +-
 include/trace/events/rxrpc.h       | 166 +++++--
 net/rxrpc/Makefile                 |   1 +
 net/rxrpc/af_rxrpc.c               |  19 +-
 net/rxrpc/ar-internal.h            | 194 +++++---
 net/rxrpc/call_accept.c            |  47 +-
 net/rxrpc/call_event.c             |  84 +++-
 net/rxrpc/call_object.c            | 115 +++--
 net/rxrpc/call_state.c             |  69 +++
 net/rxrpc/conn_client.c            | 708 ++++++++---------------------
 net/rxrpc/conn_event.c             | 381 ++++++----------
 net/rxrpc/conn_object.c            |  67 ++-
 net/rxrpc/conn_service.c           |   1 -
 net/rxrpc/input.c                  | 175 +++----
 net/rxrpc/insecure.c               |  20 +-
 net/rxrpc/io_thread.c              | 203 +++++----
 net/rxrpc/local_object.c           |  35 +-
 net/rxrpc/net_ns.c                 |  17 -
 net/rxrpc/output.c                 |  60 ++-
 net/rxrpc/peer_object.c            |  23 +-
 net/rxrpc/proc.c                   |  17 +-
 net/rxrpc/recvmsg.c                | 270 ++++-------
 net/rxrpc/rxkad.c                  | 356 ++++++---------
 net/rxrpc/rxperf.c                 |  17 +-
 net/rxrpc/security.c               |  48 +-
 net/rxrpc/sendmsg.c                | 194 ++++----
 29 files changed, 1571 insertions(+), 1753 deletions(-)
 create mode 100644 net/rxrpc/call_state.c


