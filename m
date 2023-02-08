Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E325368ECD5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjBHK2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjBHK2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA4D46712
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675852077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4mFXTVT59y8d1k5sXKQsUBZQJKQt7FSG9opYwKhcnwY=;
        b=NTYyj2kJDGKEsaXOD096YUldG2A0DOaN7c0NAmGold/gV0XTua+VnS9ZN+ClgUL6V8a4tq
        ysEY1tcJD6Tt2AbOU1TJV3V2ioyzAON9FVRnbES8FKw7Ii1EvulqBHRsXLv8d/Ubo8KpMd
        2B3/dFRp2jAu2gX727exrKron0SzM4g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-qsTSqzUWMDWdFOOMGnr27w-1; Wed, 08 Feb 2023 05:27:54 -0500
X-MC-Unique: qsTSqzUWMDWdFOOMGnr27w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAC4A293248C;
        Wed,  8 Feb 2023 10:27:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3DA4140EBF4;
        Wed,  8 Feb 2023 10:27:52 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] rxrpc: Miscellaneous changes
Date:   Wed,  8 Feb 2023 10:27:46 +0000
Message-Id: <20230208102750.18107-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some miscellaneous changes for rxrpc:

 (1) Use consume_skb() rather than kfree_skb_reason().

 (2) Fix unnecessary waking when poking and already-poked call.

 (3) Add ack.rwind to the rxrpc_tx_ack tracepoint as this indicates how
     many incoming DATA packets we're telling the peer that we are
     currently willing to accept on this call.

 (4) Reduce duplicate ACK transmission.  We send ACKs to let the peer know
     that we're increasing the receive window (ack.rwind) as we consume
     packets locally.  Normal ACK transmission is triggered in three places
     and that leads to duplicates being sent.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20230208

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David

David Howells (4):
  rxrpc: Use consume_skb() rather than kfree_skb_reason()
  rxrpc: Fix overwaking on call poking
  rxrpc: Trace ack.rwind
  rxrpc: Reduce unnecessary ack transmission

 include/trace/events/rxrpc.h | 11 +++++++----
 net/rxrpc/call_object.c      |  6 ++++--
 net/rxrpc/conn_event.c       |  2 +-
 net/rxrpc/output.c           | 10 +++++++---
 net/rxrpc/recvmsg.c          |  2 +-
 net/rxrpc/skbuff.c           |  4 ++--
 6 files changed, 22 insertions(+), 13 deletions(-)

