Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53E128551
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLTXF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:05:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726389AbfLTXF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:05:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576883125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qL/Mm3oMnQqw/MILDz90PSbUAcYZcAXsXZfzb5qXcZE=;
        b=K7kTLLVmo+QRUXgSZmhS20tCe6D2RGzPTbqEmSdE/RXZgjI/MfhJwM9q59w3ScUs7nvGah
        GTPz6oECRA0lfVk/eqT+E1/79/+7vcQGTVI1JO25YlN1yBoUvMwbOPNOOqYJM2GuADHb0g
        jXp4K4gKQNsHjalUSXXyHHdRaEtdkS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-oFn70SybO2SwwV1GYYDK-Q-1; Fri, 20 Dec 2019 18:05:22 -0500
X-MC-Unique: oFn70SybO2SwwV1GYYDK-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FCFA107ACC4;
        Fri, 20 Dec 2019 23:05:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-52.rdu2.redhat.com [10.10.120.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 918A61001902;
        Fri, 20 Dec 2019 23:05:20 +0000 (UTC)
Subject: [PATCH net 0/3] rxrpc: Fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 Dec 2019 23:05:19 +0000
Message-ID: <157688311975.18694.10870615714269857980.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a couple of bugfixes plus a patch that makes one of the bugfixes
easier:

 (1) Move the ping and mutex unlock on a new call from rxrpc_input_packet()
     into rxrpc_new_incoming_call(), which it calls.  This means the
     lock-unlock section is entirely within the latter function.  This
     simplifies patch (2).

 (2) Don't take the call->user_mutex at all in the softirq path.  Mutexes
     aren't allowed to be taken or released there and a patch was merged
     that caused a warning to be emitted every time this happened.  Looking
     at the code again, it looks like that taking the mutex isn't actually
     necessary, as the value of call->state will block access to the call.

 (3) Fix the incoming call path to check incoming calls earlier to reject
     calls to RPC services for which we don't have a security key of the
     appropriate class.  This avoids an assertion failure if YFS tries
     making a secure call to the kafs cache manager RPC service.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20191220

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (3):
      rxrpc: Unlock new call in rxrpc_new_incoming_call() rather than the caller
      rxrpc: Don't take call->user_mutex in rxrpc_new_incoming_call()
      rxrpc: Fix missing security check on incoming calls


 net/rxrpc/ar-internal.h  |   10 +++++--
 net/rxrpc/call_accept.c  |   60 ++++++++++++++++++++++++---------------
 net/rxrpc/conn_event.c   |   16 +----------
 net/rxrpc/conn_service.c |    4 +++
 net/rxrpc/input.c        |   18 ------------
 net/rxrpc/rxkad.c        |    5 ++-
 net/rxrpc/security.c     |   70 ++++++++++++++++++++++------------------------
 7 files changed, 85 insertions(+), 98 deletions(-)

