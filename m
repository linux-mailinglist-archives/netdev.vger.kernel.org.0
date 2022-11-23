Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225B363598F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiKWKU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbiKWKTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:19:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77CC122976
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669197987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0wVtadInLBEeuRePUmRUFVVWbjXsh42BBBQYRzoYLcw=;
        b=Z9Pt9JHtiqpuEV7QEVMaOjyCuwc8HIm80h0arZLmwQv0oBlbav5OMIFFW8PHmGlF0mLrWN
        HVCfrB6qb58U1wuTiSbxce0jszJuny4MSUr+qW2pm+0XGKMLSAm5IhJhahlKD8yVHiQ6UK
        M40LdG3ZcRHVFMz7oeEJXyJUoTs/Tus=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-lzdtT3VbMSybZVayiI-sIQ-1; Wed, 23 Nov 2022 05:06:24 -0500
X-MC-Unique: lzdtT3VbMSybZVayiI-sIQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDEC08027EC;
        Wed, 23 Nov 2022 10:06:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E477492B07;
        Wed, 23 Nov 2022 10:06:23 +0000 (UTC)
Subject: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving away
 from softirq, part 2
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:06:20 +0000
Message-ID: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
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


This is the second set of patches in the process of moving rxrpc from doing
a lot of its stuff in softirq context to doing it in an I/O thread in
process context and thereby making it easier to support a larger SACK table
(full description in part 1[1]).

[!] Note that these patches are based on a merge of a fix in net/master
    with net-next/master.  The fix makes a number of conflicting changes,
    so it's better if this set is built on top of it.

This set of patches includes some cleanups, adds some testing and overhauls
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

Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]

---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221121

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (13):
      rxrpc: Implement an in-kernel rxperf server for testing purposes
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


 include/net/af_rxrpc.h       |   2 +-
 include/trace/events/rxrpc.h | 385 +++++++++++++++-------
 net/rxrpc/Kconfig            |   7 +
 net/rxrpc/Makefile           |   3 +
 net/rxrpc/af_rxrpc.c         |  10 +-
 net/rxrpc/ar-internal.h      | 121 ++++---
 net/rxrpc/call_accept.c      |  39 +--
 net/rxrpc/call_event.c       |  18 +-
 net/rxrpc/call_object.c      | 120 +++----
 net/rxrpc/conn_client.c      | 112 ++++---
 net/rxrpc/conn_event.c       |  52 ++-
 net/rxrpc/conn_object.c      |  66 ++--
 net/rxrpc/conn_service.c     |  15 +-
 net/rxrpc/input.c            | 103 +++---
 net/rxrpc/key.c              |   2 +-
 net/rxrpc/local_event.c      |   7 +-
 net/rxrpc/local_object.c     |  85 +++--
 net/rxrpc/output.c           |  45 ++-
 net/rxrpc/peer_event.c       |  74 +----
 net/rxrpc/peer_object.c      |  44 ++-
 net/rxrpc/proc.c             |   6 +-
 net/rxrpc/recvmsg.c          |  32 +-
 net/rxrpc/rxkad.c            |  63 ++--
 net/rxrpc/rxperf.c           | 614 +++++++++++++++++++++++++++++++++++
 net/rxrpc/security.c         |   4 +-
 net/rxrpc/sendmsg.c          |   6 +-
 net/rxrpc/server_key.c       |  25 ++
 net/rxrpc/skbuff.c           |  36 +-
 28 files changed, 1403 insertions(+), 693 deletions(-)
 create mode 100644 net/rxrpc/rxperf.c


