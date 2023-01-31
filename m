Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4C683371
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjAaRNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaRNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC16C53B2E
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SPyDkzNg7Fk5+AnC1Y48zK4yNGiKKgn6ZNnFIe1+xxQ=;
        b=a+jL3fyIa5pZF6EVDVtFi6UKwtnom/D5zFlPoaDiL7NE8eo6w/NoPI7VwQ4ELxdOhYSNh0
        QrPEjxXtRpayRF4L+h8c5xKeBFz+L3yaM2wswxBigfvVFSgGlGYbVdJ1DKp5WxmqXM1ejG
        oxHbov/keHUetdQJQFyyPmCoA8CIYEY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-F0VE428gNFajppeeb4ManQ-1; Tue, 31 Jan 2023 12:12:41 -0500
X-MC-Unique: F0VE428gNFajppeeb4ManQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AFC9385F39B;
        Tue, 31 Jan 2023 17:12:31 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0B50C15BAD;
        Tue, 31 Jan 2023 17:12:29 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving away from softirq, part 5
Date:   Tue, 31 Jan 2023 17:12:14 +0000
Message-Id: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's the fifth part of patches in the process of moving rxrpc from doing
a lot of its stuff in softirq context to doing it in an I/O thread in
process context and thereby making it easier to support a larger SACK
table.

The full description is in the description for the first part[1] which is
now upstream.  The second and third parts are also upstream[2].  A subset
of the original fourth part[3] got applied as a fix for a race[4].

The fifth part includes some cleanups:

 (1) Miscellaneous trace header cleanups: fix a trace string, display the
     security index in rx_packet rather than displaying the type twice,
     remove some whitespace to make checkpatch happier and remove some
     excess tabulation.

 (2) Convert ->recvmsg_lock to a spinlock as it's only ever locked
     exclusively.

 (3) Make ->ackr_window and ->ackr_nr_unacked non-atomic as they're only
     used in the I/O thread.

 (4) Don't use call->tx_lock to access ->tx_buffer as that is only accessed
     inside the I/O thread.  sendmsg() loads onto ->tx_sendmsg and the I/O
     thread decants from that to the buffer.

 (5) Remove local->defrag_sem as DATA packets are transmitted serially by
     the I/O thread.

 (6) Remove the service connection bundle is it was only used for its
     channel_lock - which has now gone.

And some more significant changes:

 (7) Add a debugging option to allow a delay to be injected into packet
     reception to help investigate the behaviour over longer links than
     just a few cm.

 (8) Generate occasional PING ACKs to probe for RTT information during a
     receive heavy call.

 (9) Simplify the SACK table maintenance and ACK generation.  Now that both
     parts are done in the same thread, there's no possibility of a race
     and no need to try and be cunning to avoid taking a BH spinlock whilst
     copying the SACK table (which in the future will be up to 2K) and no
     need to rotate the copy to fit the ACK packet table.

(10) Use SKB_CONSUMED when freeing received DATA packets (stop dropwatch
     complaining).

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20230131

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David

Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/r/166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk/ [2]
Link: https://lore.kernel.org/r/167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk/ [3]
Link: https://lore.kernel.org/r/167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk/ [4]

David Howells (13):
  rxrpc: Fix trace string
  rxrpc: Remove whitespace before ')' in trace header
  rxrpc: Shrink the tabulation in the rxrpc trace header a bit
  rxrpc: Convert call->recvmsg_lock to a spinlock
  rxrpc: Allow a delay to be injected into packet reception
  rxrpc: Generate extra pings for RTT during heavy-receive call
  rxrpc: De-atomic call->ackr_window and call->ackr_nr_unacked
  rxrpc: Simplify ACK handling
  rxrpc: Don't lock call->tx_lock to access call->tx_buffer
  rxrpc: Remove local->defrag_sem
  rxrpc: Show consumed and freed packets as non-dropped in dropwatch
  rxrpc: Change rx_packet tracepoint to display securityIndex not type
    twice
  rxrpc: Kill service bundle

 include/trace/events/rxrpc.h | 480 +++++++++++++++++++----------------
 net/rxrpc/Kconfig            |   9 +
 net/rxrpc/af_rxrpc.c         |   2 +-
 net/rxrpc/ar-internal.h      |  15 +-
 net/rxrpc/call_accept.c      |   2 +-
 net/rxrpc/call_event.c       |  15 +-
 net/rxrpc/call_object.c      |   7 +-
 net/rxrpc/conn_service.c     |   7 -
 net/rxrpc/input.c            |  60 ++---
 net/rxrpc/io_thread.c        |  48 +++-
 net/rxrpc/local_object.c     |   7 +-
 net/rxrpc/misc.c             |   7 +
 net/rxrpc/output.c           |  69 ++---
 net/rxrpc/proc.c             |   4 +-
 net/rxrpc/recvmsg.c          |  18 +-
 net/rxrpc/skbuff.c           |   4 +-
 net/rxrpc/sysctl.c           |  17 +-
 net/rxrpc/txbuf.c            |  12 +-
 18 files changed, 438 insertions(+), 345 deletions(-)

