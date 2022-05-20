Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABB552F0C6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351685AbiETQeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351707AbiETQeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F385B17EC35
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653064447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YugoE/XifAY9LywAxdwUauX52febWQalhatuAT7rC8=;
        b=HN8FP2SlEpxK8eBwkyZmXLVGNbmZwAuCdr7nTUqX6a/t0T4EewdKkEL88UZUkIYMOc3aIo
        cnm8DBXAF0TjulhfvTWcsmMXctEZIGEJc9YAqGAmX/6RRxVfDiLy5VgLr8jntl/+Imt1NX
        hu9O5cwqq/gfdQs9v+Q1p+nlZCv5WvU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-QB17ZsknMwW_Llzy2AIrcw-1; Fri, 20 May 2022 12:34:03 -0400
X-MC-Unique: QB17ZsknMwW_Llzy2AIrcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6275D1C04B58;
        Fri, 20 May 2022 16:34:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C742D2026D6A;
        Fri, 20 May 2022 16:34:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/6] rxrpc: Don't try to resend the request if we're
 receiving the reply
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:34:02 +0100
Message-ID: <165306444224.34086.1366952047332682873.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
References: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc has a timer to trigger resending of unacked data packets in a call.
This is not cancelled when a client call switches to the receive phase on
the basis that most calls don't last long enough for it to ever expire.
However, if it *does* expire after we've started to receive the reply, we
shouldn't then go into trying to retransmit or pinging the server to find
out if an ack got lost.

Fix this by skipping the resend code if we're into receiving the reply to a
client call.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/call_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 22e05de5d1ca..31761084a76f 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -406,7 +406,8 @@ void rxrpc_process_call(struct work_struct *work)
 		goto recheck_state;
 	}
 
-	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events)) {
+	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events) &&
+	    call->state != RXRPC_CALL_CLIENT_RECV_REPLY) {
 		rxrpc_resend(call, now);
 		goto recheck_state;
 	}


