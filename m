Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558B1DF2EB
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgEVXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:24:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731292AbgEVXX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590189805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yA8MG2xnNJx0Kt8hJUHty9G03UJJdwFcpyOZHcxGCS0=;
        b=cI7OiwFhLYhJyT5BRBi8RxgAqOe6cTG36IeRQhJAS8X2qFS3nZzeZhd3VrtKcfdT/eVos1
        FGPOHdFK8iX6wsx6XbfmaWj2uhn+RJV7V+gKBFmyednaKj3wp4r9lFSeeUgBqel2fvnbDf
        dnpnetDm91gJkh4n3XREJvR0CynBpMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-M4UY1Se6MOmGy9cPC_marg-1; Fri, 22 May 2020 19:23:24 -0400
X-MC-Unique: M4UY1Se6MOmGy9cPC_marg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0681D107ACCA;
        Fri, 22 May 2020 23:23:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3809160BE2;
        Fri, 22 May 2020 23:23:22 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Fix a warning and a leak
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 23 May 2020 00:23:21 +0100
Message-ID: <159018980141.996784.14747585629466633699.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a couple of fixes for AF_RXRPC:

 (1) Fix an uninitialised variable warning.

 (2) Fix a leak of the ticket on error in rxkad.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20200523

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

and follows on from rxrpc-fixes-20200521.

David
---
Qiushi Wu (1):
      A ticket was not released after a call of the function


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
 net/rxrpc/rxkad.c            |   3 +-
 net/rxrpc/sendmsg.c          |  26 ++----
 net/rxrpc/sysctl.c           |   9 --
 18 files changed, 336 insertions(+), 161 deletions(-)
 create mode 100644 net/rxrpc/rtt.c


