Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353F41DC72F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 08:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEUG4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 02:56:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26276 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726990AbgEUG4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 02:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590044210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NEPsuI322n1SfGdGZ1bt40k2iNByP761ppUmMqLTrT4=;
        b=R7/X4G5HPbTYF0t4n82ddLeeCn5TE5VhTYA8mBa5yVzmObHFH6Y0o6xPAbdvTtk6QVRrOT
        oGJwhnA9BXFTLOvKpPI0Xy7NzSwYRdqhhjWlfcp5rN6Z6MZRuWco72zg4r8GdvBOffziGi
        ZwP7uAKwN18b/6bFoetT0wD7Kv809ps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-bpOhwA4xPfyJjo_ViOMyPg-1; Thu, 21 May 2020 02:56:46 -0400
X-MC-Unique: bpOhwA4xPfyJjo_ViOMyPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 235A580183C;
        Thu, 21 May 2020 06:56:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54C4E5D9CA;
        Thu, 21 May 2020 06:56:44 +0000 (UTC)
Subject: [PATCH net 0/3] rxrpc: Fix retransmission timeout and ACK discard
 [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 07:56:43 +0100
Message-ID: <159004420353.66254.3034741691675793468.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a couple of fixes and an extra tracepoint for AF_RXRPC:

 (1) Calculate the RTO pretty much as TCP does, rather than making
     something up, including an initial 4s timeout (which causes return
     probes from the fileserver to fail if a packet goes missing), and add
     backoff.

 (2) Fix the discarding of out-of-order received ACKs.  We mustn't let the
     hard-ACK point regress, nor do we want to do unnecessary
     retransmission because the soft-ACK list regresses.  This is not
     trivial, however, due to some loose wording in various old protocol
     specs, the ACK field that should be used for this sometimes has the
     wrong information in it.

 (3) Add a tracepoint to log a discarded ACK.

[V2] Fixed a "Fixes" line in a commit message.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20200520

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (1):
      rxrpc: Fix ack discard


 fs/afs/fs_probe.c            |  18 ++--
 fs/afs/vl_probe.c            |  18 ++--
 include/net/af_rxrpc.h       |   2 +-
 include/trace/events/rxrpc.h |  52 +++++++++---
 net/rxrpc/Makefile           |   1 +
 net/rxrpc/ar-internal.h      |  25 ++++--
 net/rxrpc/call_accept.c      |   2 +-
 net/rxrpc/call_event.c       |  22 ++---
 net/rxrpc/input.c            |  44 ++++++++--
 net/rxrpc/misc.c             |   5 --
 net/rxrpc/output.c           |   9 +-
 net/rxrpc/peer_event.c       |  46 ----------
 net/rxrpc/peer_object.c      |  12 +--
 net/rxrpc/proc.c             |   8 +-
 net/rxrpc/rtt.c              | 195 +++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/sendmsg.c          |  26 ++----
 net/rxrpc/sysctl.c           |   9 --
 17 files changed, 335 insertions(+), 159 deletions(-)
 create mode 100644 net/rxrpc/rtt.c


