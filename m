Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602E8635A24
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbiKWKci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiKWKbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:31:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F15E50
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ziHJjbEHvKPBD/w57rLjBmunfh+NKoJJcYefTCmtlG8=;
        b=PtzI0D9zs9x6R/xbnGjteKg8coo1bUWGTBLB6t1MIhL0xyqaTm2pkyIySvlOrzZZpl9ivJ
        l1ooIyfdY23+KbP7NzKQ/pqQZvc0PI30aopsgMK65CbazCCbvIZKGPPQ/X9B4ygGPgWELx
        XMJsvwOdRU7V520S23WQPkYbXHy0d7E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-DG9H_KJUOhSF7E-5JZemVg-1; Wed, 23 Nov 2022 05:14:28 -0500
X-MC-Unique: DG9H_KJUOhSF7E-5JZemVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1A163C01D80;
        Wed, 23 Nov 2022 10:14:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EDA8C1908A;
        Wed, 23 Nov 2022 10:14:26 +0000 (UTC)
Subject: [PATCH net-next 00/17] rxrpc: Increasing SACK size and moving away
 from softirq, part 3
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:14:24 +0000
Message-ID: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is the third set of patches in the process of moving rxrpc from doing
a lot of its stuff in softirq context to doing it in an I/O thread in
process context and thereby making it easier to support a larger SACK table
(full description in part 1[1]).

[!] Note that these patches are based part 2[2], which is based on a merge
    of a fix in net/master with net-next/master.  The fix makes a number of
    conflicting changes, so it's better if this set is built on top of it.

This set of patches introduces the I/O thread and cuts various bits over to
running there:

 (1) Split input.c so that the call packet processing bits are separate
     from the received packet distribution bits.  Call packet processing
     will get bumped over to the call event handler.

 (2) Create a per-local endpoint I/O thread.  Barring some tiny bits that
     still get done in softirq context, all packet reception, processing
     and transmission is done in this thread.  That will allow a load of
     locking to be removed.

 (3) Perform packet processing and error processing from the I/O thread.

 (4) Provide a mechanism to process call event notifications in the I/O
     thread rather than queuing a work item for that call.

 (5) Move data and ACK transmission into the I/O thread.  ACKs can then be
     transmitted at the point they're generated rather than getting
     delegated from softirq context to some process context somewhere.

 (6) Move call and local processor event handling into the I/O thread.

 (7) Move cwnd degradation to after packets have been transmitted so that
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

Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/r/166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk [2]

---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221121-b

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (17):
      rxrpc: Split the receive code
      rxrpc: Create a per-local endpoint receive queue and I/O thread
      rxrpc: Move packet reception processing into I/O thread
      rxrpc: Move error processing into the local endpoint I/O thread
      rxrpc: Remove call->input_lock
      rxrpc: Don't use sk->sk_receive_queue.lock to guard socket state changes
      rxrpc: Don't take spinlocks in the RCU callback functions
      rxrpc: Remove the _bh annotation from all the spinlocks
      rxrpc: Implement a mechanism to send an event notification to a call
      rxrpc: Move DATA transmission into call processor work item
      rxrpc: Remove RCU from peer->error_targets list
      rxrpc: Make the I/O thread take over the call and local processor work
      rxrpc: Trace/count transmission underflows and cwnd resets
      rxrpc: Move the cwnd degradation after transmitting packets
      rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_local()
      rxrpc: Transmit ACKs at the point of generation
      rxrpc: Simplify skbuff accounting in receive path


 include/trace/events/rxrpc.h | 137 ++++++--
 net/rxrpc/Makefile           |   1 +
 net/rxrpc/af_rxrpc.c         |   8 +-
 net/rxrpc/ar-internal.h      |  84 ++---
 net/rxrpc/call_accept.c      |  55 +---
 net/rxrpc/call_event.c       | 255 ++++++++-------
 net/rxrpc/call_object.c      | 157 +++++----
 net/rxrpc/conn_client.c      |   8 +-
 net/rxrpc/conn_event.c       |  76 ++++-
 net/rxrpc/conn_object.c      |  24 +-
 net/rxrpc/conn_service.c     |  10 +-
 net/rxrpc/input.c            | 616 ++++++-----------------------------
 net/rxrpc/io_thread.c        | 423 ++++++++++++++++++++++++
 net/rxrpc/local_event.c      |  43 +--
 net/rxrpc/local_object.c     | 102 ++----
 net/rxrpc/output.c           | 190 +++++------
 net/rxrpc/peer_event.c       | 101 +++---
 net/rxrpc/peer_object.c      |   8 +-
 net/rxrpc/proc.c             |  31 +-
 net/rxrpc/recvmsg.c          |  48 ++-
 net/rxrpc/sendmsg.c          |  99 ++----
 net/rxrpc/txbuf.c            |   3 +-
 22 files changed, 1216 insertions(+), 1263 deletions(-)
 create mode 100644 net/rxrpc/io_thread.c


