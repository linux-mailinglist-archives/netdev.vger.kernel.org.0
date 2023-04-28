Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9186F1F54
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346616AbjD1U3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346628AbjD1U3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ED030E8
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682713686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Uy6dRgRnvqm17ecZ+ZFNSRr8vcB2QgAYx8cCPhO/llU=;
        b=KiWb2R0JzukjvOqDfwW3aoIkGH+lkovjKIGaP7WrvFJQAuX7btqfB17AQjbqemeMyTNV0W
        0IZgqubBO8CzZClJetR7WD7DCaExbgDCeFt4ju4+BPzwrY3ih5iA1DLh5z7c5uxXN9QxZB
        Zh9Qn6rsGsJg1miTOqPEa4wJqEb1Ipo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-Z8iOFh6iOEyyoDIYLjlA-w-1; Fri, 28 Apr 2023 16:28:02 -0400
X-MC-Unique: Z8iOFh6iOEyyoDIYLjlA-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F8D9185A79C;
        Fri, 28 Apr 2023 20:28:01 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A9142027043;
        Fri, 28 Apr 2023 20:28:00 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] rxrpc: Timeout handling fixes
Date:   Fri, 28 Apr 2023 21:27:53 +0100
Message-Id: <20230428202756.1186269-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are three patches to fix timeouts handling in AF_RXRPC:

 (1) The hard call timeout should be interpreted in seconds, not
     milliseconds.

 (2) Allow a waiting call to be aborted (thereby cancelling the call) in
     the case a signal interrupts sendmsg() and leaves it hanging until it
     is granted a channel on a connection.

 (3) Kernel-generated calls get the timer started on them even if they're
     still waiting to be attached to a connection.  If the timer expires
     before the wait is complete and a conn is attached, an oops will
     occur.

David

---
The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David Howells (3):
  rxrpc: Fix hard call timeout units
  rxrpc: Make it so that a waiting process can be aborted
  rxrpc: Fix timeout of a call that hasn't yet been granted a channel

 fs/afs/afs.h            |  4 ++--
 fs/afs/internal.h       |  2 +-
 fs/afs/rxrpc.c          |  8 +++-----
 include/net/af_rxrpc.h  | 21 +++++++++++----------
 net/rxrpc/af_rxrpc.c    |  3 +++
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/call_object.c |  9 ++++++++-
 net/rxrpc/sendmsg.c     | 10 +++++++---
 8 files changed, 36 insertions(+), 22 deletions(-)

