Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C784552F9E9
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 10:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbiEUIDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiEUIDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 04:03:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CFDD54BD4
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 01:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653120184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R7QTuDiExCMdn+/GO0hMKidkjPgSNtRqwJ+PEjLIuRc=;
        b=Y3Occ9o9m2dfyxhr38BGrA+mp4fvdl2Jinb7ANu7PKPmH7qOmUjs/2OOTJf6Im8KSIoXk2
        e1qtuq7lS2/7d8j+hY/X6ZTK4zj1/5LSfKeKEBuJYcdlC8eQgeZGjX5ucdt8ccll74TDJR
        lT4VgGtp4dpO6DEYeJFvgvxx6NAFUNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-WJlU5EzgN96WceSwFgOXdQ-1; Sat, 21 May 2022 04:03:00 -0400
X-MC-Unique: WJlU5EzgN96WceSwFgOXdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4B758001EA;
        Sat, 21 May 2022 08:02:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F153C40E6A4E;
        Sat, 21 May 2022 08:02:58 +0000 (UTC)
Subject: [PATCH net 0/5] rxrpc: Miscellaneous fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org,
        Jeffrey Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 21 May 2022 09:02:58 +0100
Message-ID: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for AF_RXRPC:

 (1) Fix listen() allowing preallocation to overrun the prealloc buffer.

 (2) Prevent resending the request if we've seen the reply starting to
     arrive.

 (3) Fix accidental sharing of ACK state between transmission and
     reception.

 (4) Ignore ACKs in which ack.previousPacket regresses.  This indicates the
     highest DATA number so far seen, so should not be seen to go
     backwards.

 (5) Fix the determination of when to generate an IDLE-type ACK,
     simplifying it so that we generate one if we have more than two DATA
     packets that aren't hard-acked (consumed) or soft-acked (in the rx
     buffer, but could be discarded and re-requested).

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20220521

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

Tested-by: kafs-testing+fedora34_64checkkafs-build-495@auristor.com

Changes
=======
ver #2)
 - Rebased onto net/master
 - Dropped the IPv6 checksum patch as it's already upstream.

David

Link: https://lore.kernel.org/r/165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk/ # v1
---
David Howells (5):
      rxrpc: Fix listen() setting the bar too high for the prealloc rings
      rxrpc: Don't try to resend the request if we're receiving the reply
      rxrpc: Fix overlapping ACK accounting
      rxrpc: Don't let ack.previousPacket regress
      rxrpc: Fix decision on when to generate an IDLE ACK


 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/ar-internal.h      | 13 +++++++------
 net/rxrpc/call_event.c       |  3 ++-
 net/rxrpc/input.c            | 31 ++++++++++++++++++++-----------
 net/rxrpc/output.c           | 20 ++++++++++++--------
 net/rxrpc/recvmsg.c          |  8 +++-----
 net/rxrpc/sysctl.c           |  4 ++--
 7 files changed, 47 insertions(+), 34 deletions(-)


