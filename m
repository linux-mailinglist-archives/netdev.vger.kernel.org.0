Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5D621EF6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiKHWS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKHWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:18:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF9F60EB8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rTfsZi+KYTrZtx+N9I965ksNgbYriLjCYNEJ3KsNWRY=;
        b=a2nIqxH9rPykMj7z+MTF/Wn9Ld1V3VH2FAn7RdW/PSaNTLruW1cdTmsqd0bXtXaSZFnmbZ
        EfqXKpMm24omFQ62vvnCdjExa/953nrgw6encesZfplfovLtFZMmOsWNt5cfDaVA3doYRq
        vxpdLHTFwPodDIO+MPRfvw0+aQgRpr4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-_6T3RXPbN5y21WoioERu8w-1; Tue, 08 Nov 2022 17:17:52 -0500
X-MC-Unique: _6T3RXPbN5y21WoioERu8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 841EC380673F;
        Tue,  8 Nov 2022 22:17:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0ABA2028E90;
        Tue,  8 Nov 2022 22:17:51 +0000 (UTC)
Subject: [PATCH 00/26] rxrpc: Increasing SACK size and moving away from
 softirq, part 1
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:17:51 +0000
Message-ID: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


AF_RXRPC has some issues that need addressing:

 (1) The SACK table has a maximum capacity of 255, but for modern networks
     that isn't sufficient.  This is hard to increase in the upstream code
     because of the way the application thread is coupled to the softirq
     and retransmission side through a ring buffer.  Adjustments to the rx
     protocol allows a capacity of up to 8192, and having a ring
     sufficiently large to accommodate that would use an excessive amount
     of memory as this is per-call.

 (2) Processing ACKs in softirq mode causes the ACKs get conflated, with
     only the most recent being considered.  Whilst this has the upside
     that the retransmission algorithm only needs to deal with the most
     recent ACK, it causes DATA transmission for a call to be very bursty
     because DATA packets cannot be transmitted in softirq mode.  Rather
     transmission must be delegated to either the application thread or a
     workqueue, so there tend to be sudden bursts of traffic for any
     particular call due to scheduling delays.

 (3) All crypto in a single call is done in series; however, each DATA
     packet is individually encrypted so encryption and decryption of large
     calls could be parallelised if spare CPU resources are available.

This is the first of a number of sets of patches that try and address them.
The overall aims of these changes include:

 (1) To get rid of the TxRx ring and instead pass the packets round in
     queues (eg. sk_buff_head).  On the Tx side, each ACK packet comes with
     a SACK table that can be parsed as-is, so there's no particular need
     to maintain our own; we just have to refer to the ACK.

     On the Rx side, we do need to maintain a SACK table with one bit per
     entry - but only if packets go missing - and we don't want to have to
     perform a complex transformation to get the information into an ACK
     packet.

 (2) To try and move almost all processing of received packets out of the
     softirq handler and into a high-priority kernel I/O thread.  Only the
     transferral of packets would be left there.  I would still use the
     encap_rcv hook to receive packets as there's a noticeable performance
     drop from letting the UDP socket put the packets into its own queue
     and then getting them out of there.

 (3) To make the I/O thread also do all the transmission.  The app thread
     would be responsible for packaging the data into packets and then
     buffering them for the I/O thread to transmit.  This would make it
     easier for the app thread to run ahead of the I/O thread, and would
     mean the I/O thread is less likely to have to wait around for a new
     packet to come available for transmission.

 (4) To logically partition the socket/UAPI/KAPI side of things from the
     I/O side of things.  The local endpoint, connection, peer and call
     objects would belong to the I/O side.  The socket side would not then
     touch the private internals of calls and suchlike and would not change
     their states.  It would only look at the send queue, receive queue and
     a way to pass a message to cause an abort.

 (5) To remove as much locking, synchronisation, barriering and atomic ops
     as possible from the I/O side.  Exclusion would be achieved by
     limiting modification of state to the I/O thread only.  Locks would
     still need to be used in communication with the UDP socket and the
     AF_RXRPC socket API.

 (6) To provide crypto offload kernel threads that, when there's slack in
     the system, can see packets that need crypting and provide
     parallelisation in dealing with them.

 (7) To remove the use of system timers.  Since each timer would then send
     a poke to the I/O thread, which would then deal with it when it had
     the opportunity, there seems no point in using system timers if,
     instead, a list of timeouts can be sensibly consulted.  An I/O thread
     only then needs to schedule with a timeout when it is idle.

 (8) To use zero-copy sendmsg to send packets.  This would make use of the
     I/O thread being the sole transmitter on the socket to manage the
     dead-reckoning sequencing of the completion notifications.  There is a
     problem with zero-copy, though: the UDP socket doesn't handle running
     out of option memory very gracefully.

With regard to this first patchset, the changes made include:

 (1) Some fixes, including a fallback for proc_create_net_single_write(),
     setting ack.bufferSize to 0 in ACK packets and a fix for rxrpc
     congestion management, which shouldn't be saving the cwnd value
     between calls.

 (2) Improvements in rxrpc tracepoints, including splitting the timer
     tracepoint into a set-timer and a timer-expired trace.

 (3) Addition of a new proc file to display some stats.

 (4) Some code cleanups, including removing some unused bits and
     unnecessary header inclusions.

 (5) A change to the recently added UDP encap_err_rcv hook so that it has
     the same signature as {ip,ipv6}_icmp_error(), and then just have rxrpc
     point its UDP socket's hook directly at those.

 (6) Definition of a new struct, rxrpc_txbuf, that is used to hold
     transmissible packets of DATA and ACK type in a single 2KiB block
     rather than using an sk_buff.  This allows the buffer to be on a
     number of queues simultaneously more easily, and also guarantees that
     the entire block is in a single unit for zerocopy purposes and that
     the data payload is aligned for in-place crypto purposes.

 (7) ACK txbufs are allocated at proposal and queued for later transmission
     rather than being stored in a single place in the rxrpc_call struct,
     which means only a single ACK can be pending transmission at a time.
     The queue is then drained at various points.  This allows the ACK
     generation code to be simplified.

 (8) The Rx ring buffer is removed.  When a jumbo packet is received (which
     comprises a number of ordinary DATA packets glued together), it used
     to be pointed to by the ring multiple times, with an annotation in a
     side ring indicating which subpacket was in that slot - but this is no
     longer possible.  Instead, the packet is cloned once for each
     subpacket, barring the last, and the range of data is set in the skb
     private area.  This makes it easier for the subpackets in a jumbo
     packet to be decrypted in parallel.

 (9) The Tx ring buffer is removed.  The side annotation ring that held the
     SACK information is also removed.  Instead, in the event of packet
     loss, the SACK data attached an ACK packet is parsed.

(10) Allocate an skcipher request when needed in the rxkad security class
     rather than caching one in the rxrpc_call struct.  This deals with a
     race between externally-driven call disconnection getting rid of the
     skcipher request and sendmsg/recvmsg trying to use it because they
     haven't seen the completion yet.  This is also needed to support
     parallelisation as the skcipher request cannot be used by two or more
     threads simultaneously.

(11) Call udp_sendmsg() and udpv6_sendmsg() directly rather than going
     through kernel_sendmsg() so that we can provide our own iterator
     (zerocopy explicitly doesn't work with a KVEC iterator).  This also
     lets us avoid the overhead of the security hook.

---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221108

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (26):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Trace setting of the request-ack flag
      rxrpc: Split call timer-expiration from call timer-set tracepoint
      rxrpc: Track highest acked serial
      rxrpc: Add stats procfile and DATA packet stats
      rxrpc: Record statistics about ACK types
      rxrpc: Record stats for why the REQUEST-ACK flag is being set
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      net: Change the udp encap_err_rcv to allow use of {ip,ipv6}_icmp_error()
      rxrpc: Use the core ICMP/ICMP6 parsers
      rxrpc: Call udp_sendmsg() directly
      rxrpc: Remove unnecessary header inclusions
      rxrpc: Remove the flags from the rxrpc_skb tracepoint
      rxrpc: Remove call->tx_phase
      rxrpc: Define rxrpc_txbuf struct to carry data to be transmitted
      rxrpc: Allocate ACK records at proposal and queue for transmission
      rxrpc: Clean up ACK handling
      rxrpc: Split the rxrpc_recvmsg tracepoint
      rxrpc: Clone received jumbo subpackets and queue separately
      rxrpc: Get rid of the Rx ring
      rxrpc: Don't use a ring buffer for call Tx queue
      rxrpc: Remove call->lock
      rxrpc: Save last ACK's SACK table rather than marking txbufs
      rxrpc: Remove the rxtx ring
      rxrpc: Fix congestion management
      rxrpc: Allocate an skcipher each time needed rather than reusing


 include/linux/proc_fs.h      |   2 +
 include/linux/udp.h          |   3 +-
 include/net/udp_tunnel.h     |   4 +-
 include/trace/events/rxrpc.h | 361 ++++++++++++----
 net/core/skbuff.c            |   1 +
 net/ipv4/ip_sockglue.c       |   1 +
 net/ipv4/udp.c               |   3 +-
 net/ipv6/datagram.c          |   1 +
 net/ipv6/udp.c               |   4 +-
 net/rxrpc/Makefile           |   1 +
 net/rxrpc/af_rxrpc.c         |   5 +-
 net/rxrpc/ar-internal.h      | 224 ++++++----
 net/rxrpc/call_accept.c      |   8 +-
 net/rxrpc/call_event.c       | 427 +++++++++----------
 net/rxrpc/call_object.c      |  63 ++-
 net/rxrpc/conn_client.c      |   3 +-
 net/rxrpc/conn_object.c      |   4 +-
 net/rxrpc/input.c            | 770 +++++++++++++++++------------------
 net/rxrpc/insecure.c         |  16 +-
 net/rxrpc/local_object.c     |  20 +
 net/rxrpc/misc.c             |  23 +-
 net/rxrpc/net_ns.c           |   2 +
 net/rxrpc/output.c           | 390 ++++++++++--------
 net/rxrpc/peer_event.c       | 282 ++-----------
 net/rxrpc/peer_object.c      |   7 +-
 net/rxrpc/proc.c             | 110 ++++-
 net/rxrpc/protocol.h         |   9 +-
 net/rxrpc/recvmsg.c          | 268 ++++--------
 net/rxrpc/rxkad.c            | 245 ++++-------
 net/rxrpc/sendmsg.c          | 218 +++++-----
 net/rxrpc/skbuff.c           |  20 +-
 net/rxrpc/sysctl.c           |  11 +-
 net/rxrpc/txbuf.c            | 135 ++++++
 33 files changed, 1844 insertions(+), 1797 deletions(-)
 create mode 100644 net/rxrpc/txbuf.c


