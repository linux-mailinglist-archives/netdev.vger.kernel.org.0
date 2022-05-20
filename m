Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F412C52F0C0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351678AbiETQdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351685AbiETQdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 564E61796FA
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653064427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VF6ktk7dGOZrKXjAVeRJJ2W4CUc9s4i/ZO9KLyZ4mDY=;
        b=GeV8J/U+6wAukYvadlXOPYM3LH7ayDgKcYrZS1u4Law3uvwOvnV8L9KaBkVhc5XmomL1F2
        4YZ9BxaLn9V+cWBeiMC/lkyoeU47XusD/LXDQVV+1fYKJPRLFp3dPFYUJmmTuQKWCvPuQz
        XHzmfhMDZvt0LoNgRu+G6wrj5yljQv0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-b5RPEo5fMzGqvw03SLOR3A-1; Fri, 20 May 2022 12:33:44 -0400
X-MC-Unique: b5RPEo5fMzGqvw03SLOR3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96B71101AA44;
        Fri, 20 May 2022 16:33:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AAC9492CA2;
        Fri, 20 May 2022 16:33:41 +0000 (UTC)
Subject: [PATCH net 0/6] rxrpc: Leak fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jeffrey Altman <jaltman@auristor.com>,
        linux-afs@lists.infradead.org,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xin Long <lucien.xin@gmail.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:33:41 +0100
Message-ID: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for AF_RXRPC:

 (1) Reenable IPv6 checksums on the UDP transport socket after the
     conversion to the UDP tunnel API disabled it.

 (2) Fix listen() allowing preallocation to overrun the prealloc buffer.

 (3) Prevent resending the request if we've seen the reply starting to
     arrive.

 (4) Fix accidental sharing of ACK state between transmission and
     reception.

 (5) Ignore ACKs in which ack.previousPacket regresses.  This indicates the
     highest DATA number so far seen, so should not be seen to go
     backwards.

 (6) Fix the determination of when to generate an IDLE-type ACK,
     simplifying it so that we generate one if we have more than two DATA
     packets that aren't hard-acked (consumed) or soft-acked (in the rx
     buffer, but could be discarded and re-requested).

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20220520

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

Tested-by: kafs-testing+fedora34_64checkkafs-build-495@auristor.com

David
---
David Howells (6):
      rxrpc: Enable IPv6 checksums on transport socket
      rxrpc: Fix listen() setting the bar too high for the prealloc rings
      rxrpc: Don't try to resend the request if we're receiving the reply
      rxrpc: Fix overlapping ACK accounting
      rxrpc: Don't let ack.previousPacket regress
      rxrpc: Fix decision on when to generate an IDLE ACK


 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/ar-internal.h      | 13 +++++++------
 net/rxrpc/call_event.c       |  3 ++-
 net/rxrpc/input.c            | 31 ++++++++++++++++++++-----------
 net/rxrpc/local_object.c     |  3 +++
 net/rxrpc/output.c           | 20 ++++++++++++--------
 net/rxrpc/recvmsg.c          |  8 +++-----
 net/rxrpc/sysctl.c           |  4 ++--
 8 files changed, 50 insertions(+), 34 deletions(-)


