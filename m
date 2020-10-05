Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C05283C41
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgJEQSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgJEQSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/YC9NAs5VgH1MipX2+476O9V7RcdOHJuBy83f1Doo/8=;
        b=A4mvi2VhdbrbSuoyuMllILFJ6+L3UXBUT+dVPQT28WoNFiyVif8ZJpU6potYyskZ/Voj8j
        MO2huaz2oQxC1aF8YXOwSVqO64rLuOi1m464tSxFLB/Lmdnzxiu1faV50XWWn2K8ZoRhgf
        5nwx4Wv0zWsAhVwhVt4xp5SEvYgW8zY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-NGsTwhBHOOmyWu4T17yihw-1; Mon, 05 Oct 2020 12:18:47 -0400
X-MC-Unique: NGsTwhBHOOmyWu4T17yihw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 570A810BBEC7;
        Mon,  5 Oct 2020 16:18:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42AB710001B3;
        Mon,  5 Oct 2020 16:18:44 +0000 (UTC)
Subject: [PATCH net 0/6] rxrpc: Miscellaneous fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 17:18:44 +0100
Message-ID: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some miscellaneous rxrpc fixes:

 (1) Fix the xdr encoding of the contents read from an rxrpc key.

 (2) Fix a BUG() for a unsupported encoding type.

 (3) Fix missing _bh lock annotations.

 (4) Fix acceptance handling for an incoming call where the incoming call
     is encrypted.

 (5) The server token keyring isn't network namespaced - it belongs to the
     server, so there's no need.  Namespacing it means that request_key()
     fails to find it.

 (6) Fix a leak of the server keyring.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20201005.txt

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (5):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: Fix accept on a connection that need securing
      rxrpc: The server keyring isn't network-namespaced
      rxrpc: Fix server keyring leak

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding


 include/uapi/linux/rxrpc.h |   2 +-
 net/rxrpc/ar-internal.h    |   7 +-
 net/rxrpc/call_accept.c    | 263 ++++++-------------------------------
 net/rxrpc/call_object.c    |   5 +-
 net/rxrpc/conn_event.c     |   8 +-
 net/rxrpc/key.c            |   8 +-
 net/rxrpc/recvmsg.c        |  36 +----
 net/rxrpc/sendmsg.c        |  15 +--
 8 files changed, 56 insertions(+), 288 deletions(-)


