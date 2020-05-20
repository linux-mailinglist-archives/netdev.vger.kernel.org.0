Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA11DC2C1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgETXVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:21:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728694AbgETXVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590016906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QCvvSQse9uoRSN4nhne9pBMylRnmmLbVVrXB6qYkxWg=;
        b=NQ7nnDche2OfvtrxXBkb5e7vSubn9iYsF2OJNBulWd+CE0HTGmGelBmjT29NEVCdK8sxf3
        Y0skSbNf4Uv5VzbCuUwsFfuqVB9Sw4BzYoOXdWOIOTNm1+aO1nC4+CKUrkmH+OUzEEPdK6
        eZI9u8FBrhQLcNU/FcmIctvYMUaOkAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-HWe3uLGmPfWPMmwsfaXDtA-1; Wed, 20 May 2020 19:21:44 -0400
X-MC-Unique: HWe3uLGmPfWPMmwsfaXDtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B18C4835B40;
        Wed, 20 May 2020 23:21:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E48C782A2C;
        Wed, 20 May 2020 23:21:42 +0000 (UTC)
Subject: [PATCH net 0/3] rxrpc: Fix retransmission timeout and ACK discard
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 00:21:42 +0100
Message-ID: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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


