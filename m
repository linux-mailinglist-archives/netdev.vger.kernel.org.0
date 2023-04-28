Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451226F1F53
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346578AbjD1U3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346559AbjD1U3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:29:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9963A88
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682713689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTrMz2PfIMAWZjqyClwi15SoJPR6XaGnAtPZVNp1hQw=;
        b=KPEQO1C4owOWNk37FOBvawjA02SBKom7WXuIwbhAs1MjuCfKOo1Fv81CR4sIjw7AJnm0xG
        SXvWKyAM0tK8ULesSNIctvC7mMI57XGgk7m7H6CXm62yZj17UeZKExmLSXT4A1NzPXOJ/n
        1Cn3qluqEhucPgrD6Wm/VA3Z4e5CAm4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-ghjhwPmqPYmD68ydMSPiVw-1; Fri, 28 Apr 2023 16:28:05 -0400
X-MC-Unique: ghjhwPmqPYmD68ydMSPiVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF31F3C025D3;
        Fri, 28 Apr 2023 20:28:04 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B559DC15BA0;
        Fri, 28 Apr 2023 20:28:03 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] rxrpc: Make it so that a waiting process can be aborted
Date:   Fri, 28 Apr 2023 21:27:55 +0100
Message-Id: <20230428202756.1186269-3-dhowells@redhat.com>
In-Reply-To: <20230428202756.1186269-1-dhowells@redhat.com>
References: <20230428202756.1186269-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sendmsg() creates an rxrpc call, it queues it to wait for a connection
and channel to be assigned and then waits before it can start shovelling
data as the encrypted DATA packet content includes a summary of the
connection parameters.

However, sendmsg() may get interrupted before a connection gets assigned
and further sendmsg() calls will fail with EBUSY until an assignment is
made.

Fix this so that the call can at least be aborted without failing on
EBUSY.  We have to be careful here as sendmsg() mustn't be allowed to start
the call timer if the call doesn't yet have a connection assigned as an
oops may follow shortly thereafter.

Fixes: 540b1c48c37a ("rxrpc: Fix deadlock between call creation and sendmsg/recvmsg")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 net/rxrpc/sendmsg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 7498a77b5d39..c1b074c17b33 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -656,10 +656,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			goto out_put_unlock;
 	} else {
 		switch (rxrpc_call_state(call)) {
-		case RXRPC_CALL_UNINITIALISED:
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
-		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
+			if (p.command == RXRPC_CMD_SEND_ABORT)
+				break;
+			fallthrough;
+		case RXRPC_CALL_UNINITIALISED:
+		case RXRPC_CALL_SERVER_PREALLOC:
 			rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 			ret = -EBUSY;
 			goto error_release_sock;

