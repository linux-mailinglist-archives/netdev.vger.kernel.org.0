Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CE2801BD
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbgJAO4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732299AbgJAO4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UhWKlTPk8iTygoL+cIpY5puUEyMwZ9rkuaRoxqem9NU=;
        b=T4eWf5LEhjW8woLwBk4rKLB2NPb5Ej5vku0PbbgWZzZBoXj2cpOHczZs9Ow7+BGsUc3zuV
        Yt+BpJZz/M+oPttmFcNZmfae8vXXlvhawDGYwRtFrDiVcwVtnyA5cTI5P0VweHWFdKNX1M
        U5+QQd4Zt8dWDORwS6XL13+vUQqkRoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-5VZJD73uPs2qmN9yMrG81w-1; Thu, 01 Oct 2020 10:56:46 -0400
X-MC-Unique: 5VZJD73uPs2qmN9yMrG81w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 707A7873115;
        Thu,  1 Oct 2020 14:56:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DA385C1CF;
        Thu,  1 Oct 2020 14:56:44 +0000 (UTC)
Subject: [PATCH net-next 00/23] rxrpc: Fixes and preparation for RxGK
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:56:43 +0100
Message-ID: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for problems encountered whilst writing the RxGK
security class (this will allow AF_RXRPC to use GSSAPI-negotiated tokens
and better crypto).  The RxGK security class is not included in this
patchset.

Firstly, there's a keyrings patch to provide the original key description,
as provided to add_key(), to the preparser so that it can interpret the
content on that basis.  Unfortunately, the rxrpc_s key type wasn't written
to interpret its payload as anything other than a string of bytes
comprising a key, but for RxGK, more information is required as multiple
Kerberos enctypes are supported.

Secondly, there's a bunch of rxrpc fixes:

 (1) Fix bundle refcounting for exclusive connections.

 (2) Fix the xdr encoding of the contents read from an rxrpc key.

 (3) Fix a BUG() for a unsupported encoding type.

 (4) Fix missing _bh lock annotations.

 (5) Fix the loss of deferred final ACKs on socket shutdown.

 (6) Fix acceptance handling for an incoming call where the incoming call
     is encrypted.

 (7) The server token keyring isn't network namespaced - it belongs to the
     server, so there's no need.

 (8) The default data packet size alignment should be 1, not 4.  It only
     needs to be something other than 1 if there are crypto requirements.

Thirdly, there are some preparatory changes:

 (1) Remove the rxk5 security class key support.  This class never went
     anywhere and is now defunct.  RxGK should be used instead.

 (2) Support multiple tokens in a single key, provided they're loaded in a
     single add_key() operation:

     - Make preparatory moves to allow the choice of class to be made
       higher up the stack.
     - Fix some bugs in the XDR parsing.
     - Display contained token types in /proc/keys

 (3) Split the server key (rxrpc_s-type) into its own file.  It has nothing
     in common with the session key (rxrpc-type).

 (4) Tidy up the connection security bits:

     - The prime_packet_security() op is redundant.

     - Don't retain the server key in the connection.  It's only used once
       in a service connection's life when the ticket gets decrypted.  Look
       it up on demand.

     - Hand server key parsing off to the security class.

     - Don't reserve the security header in the transmit data buffer, but
       rather just add to the offset.  RxGK has a more complicated
       structure than rxkad.

     - Organise the connection security into a union, thereby allowing
       other security classes to add bits in the same space.

     - Allow a security trailer to be reserved.  RxGK may put the checksum
       after the data.

     - Allow a security class to give more information on a server key in
       /proc/keys (such as the enctype).

     - Don't use pskb_pull() in rxkad, but rather just add to the offset
       when extracting data.

 (5) Don't leak key material from server session keys back to userspace.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-next-20201010

and can also be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (22):
      keys: Provide the original description to the key preparser
      rxrpc: Fix bundle counting for exclusive connections
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: Fix loss of final ack on shutdown
      rxrpc: Fix accept on a connection that need securing
      rxrpc: The server keyring isn't network-namespaced
      rxrpc: Change basic data packet size alignment to 1
      rxrpc: Remove the rxk5 security class as it's now defunct
      rxrpc: List the held token types in the key description in /proc/keys
      rxrpc: Allow for a security trailer in a packet
      rxrpc: Merge prime_packet_security into init_connection_security
      rxrpc: Support keys with multiple authentication tokens
      rxrpc: Don't retain the server key in the connection
      rxrpc: Split the server key type (rxrpc_s) into its own file
      rxrpc: Hand server key parsing off to the security class
      rxrpc: Don't reserve security header in Tx DATA skbuff
      rxrpc: Organise connection security to use a union
      rxrpc: Don't leak the service-side session key to userspace
      rxrpc: Allow security classes to give more info on server keys
      rxrpc: Make the parsing of xdr payloads more coherent
      rxrpc: rxkad: Don't use pskb_pull() to advance through the response packet

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding


 include/keys/rxrpc-type.h  |  56 +---
 include/uapi/linux/rxrpc.h |   2 +-
 net/rxrpc/Makefile         |   1 +
 net/rxrpc/ar-internal.h    |  65 ++--
 net/rxrpc/call_accept.c    | 277 +++-------------
 net/rxrpc/call_object.c    |   5 +-
 net/rxrpc/conn_client.c    |  14 +-
 net/rxrpc/conn_event.c     |  22 +-
 net/rxrpc/conn_object.c    |   3 +-
 net/rxrpc/conn_service.c   |   2 -
 net/rxrpc/insecure.c       |  15 +-
 net/rxrpc/key.c            | 642 +++----------------------------------
 net/rxrpc/recvmsg.c        |  36 +--
 net/rxrpc/rxkad.c          | 197 ++++++++----
 net/rxrpc/security.c       |  98 ++++--
 net/rxrpc/sendmsg.c        |  49 ++-
 net/rxrpc/server_key.c     | 143 +++++++++
 17 files changed, 513 insertions(+), 1114 deletions(-)
 create mode 100644 net/rxrpc/server_key.c


