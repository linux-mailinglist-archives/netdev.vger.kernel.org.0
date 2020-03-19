Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962DB18B2A5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCSLxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:53:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39647 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgCSLxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584618816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oXSDVbAEHWUnwLZgdo0+1RA3BdMgsrd4QkpoIWfyKRM=;
        b=WcsFdqNEPX6Mo6bmagS1XKRV2bDDEfaLDlzPMAiFybW9iMFmbsWnXy0dGIoH8PMdXaLxvc
        rIDZJAMRf1aY87v20X/1wWfM64l50Ch54EMzKCgIaKuQ5vHKDSwi1144stlPwMTc1MTsp0
        Awe6zO5/N0qNBbxwKL5S+ZjYKp/2ZPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-CnL5eWaPNJeevBlU9R1ydg-1; Thu, 19 Mar 2020 07:53:32 -0400
X-MC-Unique: CnL5eWaPNJeevBlU9R1ydg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45CD0800D5A;
        Thu, 19 Mar 2020 11:53:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8182994945;
        Thu, 19 Mar 2020 11:53:30 +0000 (UTC)
Subject: [PATCH net 0/6] rxrpc, afs: Interruptibility fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Mar 2020 11:53:29 +0000
Message-ID: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a number of fixes for AF_RXRPC and AFS that make AFS system calls
less interruptible and so less likely to leave the filesystem in an
uncertain state.  There's also a miscellaneous patch to make tracing
consistent.

 (1) Firstly, abstract out the Tx space calculation in sendmsg.  Much the
     same code is replicated in a number of places that subsequent patches
     are going to alter, including adding another copy.

 (2) Fix Tx interruptibility by allowing a kernel service, such as AFS, to
     request that a call be interruptible only when waiting for a call slot
     to become available (ie. the call has not taken place yet) or that a
     call be not interruptible at all (e.g. when we want to do writeback
     and don't want a signal interrupting a VM-induced writeback).

 (3) Increase the minimum delay on MSG_WAITALL for userspace sendmsg() when
     waiting for Tx buffer space as a 2*RTT delay is really small over 10G
     ethernet and a 1 jiffy timeout might be essentially 0 if at the end of
     the jiffy period.

 (4) Fix some tracing output in AFS to make it consistent with rxrpc.

 (5) Make sure aborted asynchronous AFS operations are tidied up properly
     so we don't end up with stuck rxrpc calls.

 (6) Make AFS client calls uninterruptible in the Rx phase.  If we don't
     wait for the reply to be fully gathered, we can't update the local VFS
     state and we end up in an indeterminate state with respect to the
     server.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20200319

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (6):
      rxrpc: Abstract out the calculation of whether there's Tx space
      rxrpc: Fix call interruptibility handling
      rxrpc: Fix sendmsg(MSG_WAITALL) handling
      afs: Fix some tracing details
      afs: Fix handling of an abort from a service handler
      afs: Fix client call Rx-phase signal handling


 fs/afs/cmservice.c         |   14 +++++++-
 fs/afs/internal.h          |   12 ++++++-
 fs/afs/rxrpc.c             |   74 ++++++-------------------------------------
 include/net/af_rxrpc.h     |   12 +++++--
 include/trace/events/afs.h |    2 +
 net/rxrpc/af_rxrpc.c       |   37 +++-------------------
 net/rxrpc/ar-internal.h    |    5 +--
 net/rxrpc/call_object.c    |    3 +-
 net/rxrpc/conn_client.c    |   13 ++++++--
 net/rxrpc/input.c          |    1 -
 net/rxrpc/sendmsg.c        |   75 +++++++++++++++++++++++++++++++++-----------
 11 files changed, 115 insertions(+), 133 deletions(-)


