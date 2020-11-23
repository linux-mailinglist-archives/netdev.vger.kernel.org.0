Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5D12C1603
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbgKWUKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:10:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731873AbgKWUKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:10:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hcuDNvyq84AB97TqWEefdqqDKsupl/7+ST0mbyjcurA=;
        b=cwetzx6Tk77hcmumub+oZ5c6outfIlxrAEQt8Ayky3QiM5zmKtoqCofU2vKSp5Md6pDwxO
        OrpGBdD8L2HeYKhFEtzUBWjwkM0A+4v9o14J9D0H7kBt+97hM5D+axuOCEuipJRJA1PaRl
        3SvZnfGilGoP6tjfNYfYO4ybXH0UHyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-a9xFkh4uPvKDrXOGeoz3eg-1; Mon, 23 Nov 2020 15:10:06 -0500
X-MC-Unique: a9xFkh4uPvKDrXOGeoz3eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9EEE18C89CD;
        Mon, 23 Nov 2020 20:10:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBB1F100164C;
        Mon, 23 Nov 2020 20:10:04 +0000 (UTC)
Subject: [PATCH net 00/17] rxrpc: Prelude to gssapi support
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:10:04 +0000
Message-ID: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Here are some patches that do some reorganisation of the security class
handling in rxrpc to allow implementation of the RxGK security class that
will allow AF_RXRPC to use GSSAPI-negotiated tokens and better crypto.  The
RxGK security class is not included in this patchset.

It does the following things:

 (1) Add a keyrings patch to provide the original key description, as
     provided to add_key(), to the payload preparser so that it can
     interpret the content on that basis.  Unfortunately, the rxrpc_s key
     type wasn't written to interpret its payload as anything other than a
     string of bytes comprising a key, but for RxGK, more information is
     required as multiple Kerberos enctypes are supported.

 (2) Remove the rxk5 security class key parsing.  The rxk5 class never got
     rolled out in OpenAFS and got replaced with rxgk.

 (3) Support the creation of rxrpc keys with multiple tokens of different
     types.  If some types are not supported, the ENOPKG error is
     suppressed if at least one other token's type is supported.

 (4) Punt the handling of server keys (rxrpc_s type) to the appropriate
     security class.

 (5) Organise the security bits in the rxrpc_connection struct into a
     union to make it easier to override for other classes.

 (6) Move some bits from core code into rxkad that won't be appropriate to
     rxgk.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-next-20201123

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (17):
      keys: Provide the original description to the key preparser
      rxrpc: Remove the rxk5 security class as it's now defunct
      rxrpc: List the held token types in the key description in /proc/keys
      rxrpc: Support keys with multiple authentication tokens
      rxrpc: Don't retain the server key in the connection
      rxrpc: Split the server key type (rxrpc_s) into its own file
      rxrpc: Hand server key parsing off to the security class
      rxrpc: Don't leak the service-side session key to userspace
      rxrpc: Allow security classes to give more info on server keys
      rxrpc: Make the parsing of xdr payloads more coherent
      rxrpc: Ignore unknown tokens in key payload unless no known tokens
      rxrpc: Fix example key name in a comment
      rxrpc: Merge prime_packet_security into init_connection_security
      rxrpc: Don't reserve security header in Tx DATA skbuff
      rxrpc: Organise connection security to use a union
      rxrpc: rxkad: Don't use pskb_pull() to advance through the response packet
      rxrpc: Ask the security class how much space to allow in a packet


 include/keys/rxrpc-type.h |  56 +---
 net/rxrpc/Makefile        |   1 +
 net/rxrpc/ar-internal.h   |  63 ++--
 net/rxrpc/call_accept.c   |  14 +-
 net/rxrpc/conn_client.c   |   6 -
 net/rxrpc/conn_event.c    |   8 +-
 net/rxrpc/conn_object.c   |   2 -
 net/rxrpc/conn_service.c  |   2 -
 net/rxrpc/insecure.c      |  19 +-
 net/rxrpc/key.c           | 658 ++++----------------------------------
 net/rxrpc/rxkad.c         | 256 ++++++++++-----
 net/rxrpc/security.c      |  98 ++++--
 net/rxrpc/sendmsg.c       |  45 +--
 net/rxrpc/server_key.c    | 143 +++++++++
 14 files changed, 519 insertions(+), 852 deletions(-)
 create mode 100644 net/rxrpc/server_key.c


