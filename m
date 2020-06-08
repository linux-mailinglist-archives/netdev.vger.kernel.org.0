Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D761F1F45
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFHSty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:49:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbgFHStx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591642192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l0ksCxzpwudUbpK7GfsKkgrf4ml8ic3g8I5MdiUao/c=;
        b=auCQhru8wpnyWfFJw3sdOYWlU9F6U5ba2LzDBJsM8TSxFG/lFoaAcELqkKiziNV8Bj2r94
        BSjEbG6JP7N19u2TqmnXrZpQNHgYu6pyeZAhJF+9XBq0Lvdpk069/qllMe9TsL1NUmweBo
        QC2pO363lXP4pjm3Nhd85cYWhF5hW3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-btfcDdT-NnykoFjMxWfLlw-1; Mon, 08 Jun 2020 14:49:50 -0400
X-MC-Unique: btfcDdT-NnykoFjMxWfLlw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 395CC835B42;
        Mon,  8 Jun 2020 18:49:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09B54648DB;
        Mon,  8 Jun 2020 18:49:47 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Fix hang due to missing notification
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Gerry Seidman <gerry@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 08 Jun 2020 19:49:47 +0100
Message-ID: <159164218727.2758133.1046957228494479308.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here's a fix for AF_RXRPC.  Occasionally calls hang because there are
circumstances in which rxrpc generate a notification when a call is
completed - primarily because initial packet transmission failed and the
call was killed off and an error returned.  But the AFS filesystem driver
doesn't check this under all circumstances, expecting failure to be
delivered by asynchronous notification.

There are two patches: the first moves the problematic bits out-of-line and
the second contains the fix.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20200605

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (1):
      rxrpc: Fix missing notification


 net/rxrpc/ar-internal.h | 119 ++++++++++--------------------------------------
 net/rxrpc/call_event.c  |   1 -
 net/rxrpc/conn_event.c  |   7 ++-
 net/rxrpc/input.c       |   7 +--
 net/rxrpc/peer_event.c  |   4 +-
 net/rxrpc/recvmsg.c     |  79 ++++++++++++++++++++++++++++++++
 net/rxrpc/sendmsg.c     |   4 +-
 7 files changed, 111 insertions(+), 110 deletions(-)


