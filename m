Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33F557CF9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiFWN3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiFWN3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F05637A05
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0m9mnQtR9SeF7SZic2rLWnCR1ebdRS+O4syL37wmoVA=;
        b=aXuosXzdWsRTsD5/ahP58b8KqyaoSbo9HldSwt8G9rBcXgSsWzfjfIvRPZbCdEYwZLR8sW
        Emql0w0I9rmYvJXeIR5Vwilu3B+B+WVoyDyz9oN+MuGueoThQVG2Gm27WZIEgA8orAQc2P
        /JR6v545+O1rZLiWJnq339jHwztWbSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-tuuZDA7mPYmwAvy_xkdQhg-1; Thu, 23 Jun 2022 09:28:54 -0400
X-MC-Unique: tuuZDA7mPYmwAvy_xkdQhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97DBF81D9CA;
        Thu, 23 Jun 2022 13:28:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A316C492CA5;
        Thu, 23 Jun 2022 13:28:52 +0000 (UTC)
Subject: [RFC PATCH net 0/8] rxrpc: Multiqueue, sendfile,
 splice and call security
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:28:51 +0100
Message-ID: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some patches to provide support for multiqueuing, sendfile and
splice on AF_RXRPC sockets and to allow calls to have individual security
settings:

 (1) Multiqueue support is provided in the sense that a number of AF_RXRPC
     sockets can be bound together such that they share a UDP socket, all
     listen on the same set of services and share a queue of as-yet
     unaccepted calls.

     This is done by creating a socket and setting it up to listen:

	fd1 = socket(AF_RXRPC, SOCK_DGRAM, IPPROTO_IPV6);
	bind(fd1, &address);
	listen(fd1, depth);

     then creating one or more additional sockets and binding them onto the
     first:

	fd2 = socket(AF_RXRPC, SOCK_DGRAM, IPPROTO_IPV6);
	setsockopt(fd2, SOL_RXRPC, RXRPC_BIND_CHANNEL, &fd1, sizeof(fd1));

     The sockets are then indistinguishable interfaces onto the local
     endpoint.  Note that each has its own non-overlapping set of user call
     IDs (tags passed in sendmsg/recvmsg control messages to indicate which
     call is being referred to).  This allows each socket to be used in a
     separate process with unshared VMs (pointers to management structs can
     be used as user call IDs).

     User call IDs can then be charged separately on each socket, as
     before:

	msg.msg_control	= control;
	msg.msg_controllen = ctrllen;
	RXRPC_ADD_CALLID(control, ctrllen, user_id);
	RXRPC_ADD_CHARGE_ACCEPT(control, ctrllen);
	ret = sendmsg(service, &msg, 0);

     If there are any user call IDs available on a particular socket,
     recvmsg() on that socket will pop a waiting call off the shared accept
     queue, tag it with the first ID and add it to the back of that
     socket's recvmsg queue.  From that point, that call can only be
     interacted with through that socket.  The same goes for client calls -
     they're bound to the socket they're started on.

     This allows a server to set up a pool of individual processes, each
     with a "copy" of the socket, with the kernel routing incoming calls as
     the processes announce their availabilty by providing a user ID.

 (2) Provide sendfile() support by allowing a call to be nominated through
     a sockopt as the target.  The call must be bound to that socket.  This
     is done by something like:

	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_SEND,
		   &call_id, sizeof(call_id));
	sendfile(client, source, &pos, st.st_size);

     The target call is cleared when the call completion message is
     collected by recvmsg() or the sockopt is altered.  Setting 0 just
     clears it.  If no call is set, sendfile will fail.

 (3) Provide splice-read support by allowing a call to be nominated through
     a sockopt as the source.  The call must be bound to that socket.  This
     is done by something like:

	setsockopt(client, SOL_RXRPC, RXRPC_SELECT_CALL_FOR_RECV,
		   &call_id, sizeof(call_id));
	ret = splice(client, NULL, pipefd[1], NULL, count, 0);

     The source call is cleared when the call completion message is
     collected by recvmsg() or the sockopt is altered.  Setting 0 just
     clears it.  If no call is set, splice will fail.

 (4) Also limit recvmsg() by setting RXRPC_SELECT_CALL_FOR_RECV.  It will
     ignore other calls whilst it is effect.  The effect will be cancelled
     when the completion message is returned (MSG_EOR will be set).

 (5) Add two new control messages that can be passed to sendmsg() when
     initiating a client call to allow them to have authentication and
     crypto parameters individually set:

	RXRPC_SET_SECURITY_KEY
	RXRPC_SET_SECURITY_LEVEL

     The first allows a key to be specified to indicate the authentication
     and crypto; the second indicates the level of crypto required on the
     packet.

     Currently RXRPC_SET_SECURITY_KEY takes a key description, which it
     passes to request_key(), but possibly it should at least allow a key
     ID instead.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-multiqueue

David
---
David Howells (8):
      rxrpc: List open sockets in /proc/net/rxrpc/sockets
      rxrpc: Allow UDP socket sharing for AF_RXRPC service sockets
      rxrpc: Allow multiple AF_RXRPC sockets to be bound together to form queues
      rxrpc: Allow the call to interact with to be preselected
      rxrpc: Implement sendfile() support
      rxrpc: Use selected call in recvmsg()
      rxrpc: Implement splice-read for rxrpc calls
      rxrpc: Set call security params in sendmsg() cmsg


 fs/afs/internal.h            |   3 -
 fs/afs/main.c                |   1 -
 fs/afs/rxrpc.c               |  83 +++---
 include/net/af_rxrpc.h       |   9 +-
 include/trace/events/afs.h   |   4 +
 include/trace/events/rxrpc.h |   9 +-
 include/uapi/linux/rxrpc.h   |   5 +
 net/rxrpc/af_rxrpc.c         | 510 ++++++++++++++++++++++++++++++-----
 net/rxrpc/ar-internal.h      | 112 +++++---
 net/rxrpc/call_accept.c      | 439 +++++++++++++++++++-----------
 net/rxrpc/call_object.c      | 133 +++++----
 net/rxrpc/conn_service.c     |  17 +-
 net/rxrpc/input.c            |  25 +-
 net/rxrpc/key.c              |  30 ++-
 net/rxrpc/local_object.c     |  24 +-
 net/rxrpc/net_ns.c           |   5 +
 net/rxrpc/peer_object.c      |  17 +-
 net/rxrpc/proc.c             | 120 ++++++++-
 net/rxrpc/recvmsg.c          | 330 ++++++++++++++++++++---
 net/rxrpc/security.c         |  22 +-
 net/rxrpc/sendmsg.c          |  78 +++++-
 net/rxrpc/server_key.c       |  12 +-
 22 files changed, 1524 insertions(+), 464 deletions(-)


