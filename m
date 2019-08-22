Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0864699335
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388455AbfHVMWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfHVMWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:22:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64D89307D921;
        Thu, 22 Aug 2019 12:22:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F14B7E23;
        Thu, 22 Aug 2019 12:22:34 +0000 (UTC)
Subject: [PATCH net 0/9] rxrpc: Fix use of skb_cow_data()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 13:22:33 +0100
Message-ID: <156647655350.10908.12081183247715153431.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 22 Aug 2019 12:22:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here's a series of patches that fixes the use of skb_cow_data() in rxrpc.
The problem is that skb_cow_data() indirectly requires that the maximum
usage count on an sk_buff be 1, and it may generate an assertion failure in
pskb_expand_head() if not.

This can occur because rxrpc_input_data() may be still holding a ref when
it has just attached the sk_buff to the rx ring and given that attachment
its own ref.  If recvmsg happens fast enough, skb_cow_data() can see the
ref still held by the softirq handler.

Further, a packet may contain multiple subpackets, each of which gets its
own attachment to the ring and its own ref - also making skb_cow_data() go
bang.

Fix this by:

 (1) The DATA packet is currently parsed for subpackets twice by the input
     routines.  Parse it just once instead and make notes in the sk_buff
     private data.

 (2) Use the notes from (1) when attaching the packet to the ring multiple
     times.  Once the packet is attached to the ring, recvmsg can see it
     and cow it and start modifying it, so the softirq handler is not
     permitted to look inside it from that point.

 (3) Stick a second reference count in the skb private data, in struct
     rxrpc_skb_priv, to count the refs held by the ring on the packet.  All
     these refs together hold one single ref on the sk_buff main ref
     counter.

 (4) Pass the ref from the input code to the ring rather than getting an
     extra ref.  rxrpc_input_data() uses a ref on the second refcount to
     prevent the packet from evaporating under it.

 (5) rxkad currently calls skb_cow_data() once for each subpacket it needs
     to decrypt.  It should only be calling this once, however, so move
     that into recvmsg and only do it when we first see a new packet.

There's also a patch to improve the rxrpc_skb tracepoint to make sure that
Tx-derived buffers are identified separately from Rx-derived buffers in the
trace.


The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20190820

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (9):
      rxrpc: Pass the input handler's data skb reference to the Rx ring
      rxrpc: Improve jumbo packet counting
      rxrpc: Use info in skbuff instead of reparsing a jumbo packet
      rxrpc: Add a private skb flag to indicate transmission-phase skbs
      rxrpc: Abstract out rxtx ring cleanup
      rxrpc: Use the tx-phase skb flag to simplify tracing
      rxrpc: Add a shadow refcount in the skb private data
      rxrpc: Use shadow refcount for packets in the RxTx ring
      rxrpc: Only call skb_cow_data() once per packet


 include/trace/events/rxrpc.h |   62 +++++----
 net/rxrpc/ar-internal.h      |   18 ++-
 net/rxrpc/call_event.c       |    8 +
 net/rxrpc/call_object.c      |   33 ++---
 net/rxrpc/conn_event.c       |    6 -
 net/rxrpc/input.c            |  285 ++++++++++++++++++++++--------------------
 net/rxrpc/local_event.c      |    4 -
 net/rxrpc/output.c           |    6 -
 net/rxrpc/peer_event.c       |   10 +
 net/rxrpc/protocol.h         |    9 +
 net/rxrpc/recvmsg.c          |   58 +++++----
 net/rxrpc/rxkad.c            |   32 +----
 net/rxrpc/sendmsg.c          |   14 +-
 net/rxrpc/skbuff.c           |   72 +++++++++--
 14 files changed, 348 insertions(+), 269 deletions(-)

