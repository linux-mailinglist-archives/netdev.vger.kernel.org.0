Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF07CDEEB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfJGKPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfJGKPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:15:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B4874FCD6;
        Mon,  7 Oct 2019 10:15:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F15F1001956;
        Mon,  7 Oct 2019 10:15:36 +0000 (UTC)
Subject: [PATCH net 0/6] rxrpc: Syzbot-inspired fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 07 Oct 2019 11:15:35 +0100
Message-ID: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 07 Oct 2019 10:15:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here's a series of patches that fix a number of issues found by syzbot:

 (1) A reference leak on rxrpc_call structs in a sendmsg error path.

 (2) A tracepoint that looked in the rxrpc_peer record after putting it.

     Analogous with this, though not presently detected, the same bug is
     also fixed in relation to rxrpc_connection and rxrpc_call records.

 (3) Peer records don't pin local endpoint records, despite accessing them.

 (4) Access to connection crypto ops to clean up a call after the call's
     ref on that connection has been put.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20191007

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (6):
      rxrpc: Fix call ref leak
      rxrpc: Fix trace-after-put looking at the put peer record
      rxrpc: Fix trace-after-put looking at the put connection record
      rxrpc: Fix trace-after-put looking at the put call record
      rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
      rxrpc: Fix call crypto state cleanup


 include/trace/events/rxrpc.h |   18 +++++++++---------
 net/rxrpc/ar-internal.h      |    1 +
 net/rxrpc/call_accept.c      |    5 +++--
 net/rxrpc/call_object.c      |   34 ++++++++++++++++++++--------------
 net/rxrpc/conn_client.c      |    9 +++++++--
 net/rxrpc/conn_object.c      |   13 +++++++------
 net/rxrpc/conn_service.c     |    2 +-
 net/rxrpc/peer_object.c      |   16 ++++++++++------
 net/rxrpc/recvmsg.c          |    6 +++---
 net/rxrpc/sendmsg.c          |    3 ++-
 10 files changed, 63 insertions(+), 44 deletions(-)

