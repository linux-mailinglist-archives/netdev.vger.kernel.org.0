Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7852F105
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351842AbiETQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351865AbiETQqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77B3A3524F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653065204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DA7O6pbC6Izg24fMA0Z1M6bRg/AzBMzyB/mvXSj7xlU=;
        b=GaLiFfam84CYSQBFbQolr8FSJfdNpgEo/Rt5fOwF3oyR7yCUSVaNgr022xPBvRMqfMQQgq
        WuEmrX8OIatbD1teI2+3hOQZoMcKivYCJDSFvRiaGbx8uKdlEOM21XysrjdOfcsT54ZywY
        s7sHD2ClA30S5ojEvzBkUGqSGpzBQ+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-WxEePOZfMj2r7ktl59xwfA-1; Fri, 20 May 2022 12:46:35 -0400
X-MC-Unique: WxEePOZfMj2r7ktl59xwfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D698F38041D3;
        Fri, 20 May 2022 16:46:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C91D40CFD00;
        Fri, 20 May 2022 16:46:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 6/7] rxrpc, afs: Fix selection of abort codes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:46:33 +0100
Message-ID: <165306519350.34989.5122705705434053803.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
References: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX_USER_ABORT code should really only be used to indicate that the user
of the rxrpc service (ie. userspace) implicitly caused a call to be aborted
- for instance if the AF_RXRPC socket is closed whilst the call was in
progress.  (The user may also explicitly abort a call and specify the abort
code to use).

Change some of the points of generation to use other abort codes instead:

 (1) Abort the call with RXGEN_SS_UNMARSHAL or RXGEN_CC_UNMARSHAL if we see
     ENOMEM and EFAULT during received data delivery and abort with
     RX_CALL_DEAD in the default case.

 (2) Abort with RXGEN_SS_MARSHAL if we get ENOMEM whilst trying to send a
     reply.

 (3) Abort with RX_CALL_DEAD if we stop hearing from the peer if we had
     heard from the peer and abort with RX_CALL_TIMEOUT if we hadn't.

 (4) Abort with RX_CALL_DEAD if we try to disconnect a call that's not
     completed successfully or been aborted.

Reported-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 fs/afs/rxrpc.c          |    8 +++++---
 net/rxrpc/call_event.c  |    4 ++--
 net/rxrpc/conn_object.c |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 23a1a92d64bb..a5434f3e57c6 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -537,6 +537,8 @@ static void afs_deliver_to_call(struct afs_call *call)
 		case -ENODATA:
 		case -EBADMSG:
 		case -EMSGSIZE:
+		case -ENOMEM:
+		case -EFAULT:
 			abort_code = RXGEN_CC_UNMARSHAL;
 			if (state != AFS_CALL_CL_AWAIT_REPLY)
 				abort_code = RXGEN_SS_UNMARSHAL;
@@ -544,7 +546,7 @@ static void afs_deliver_to_call(struct afs_call *call)
 						abort_code, ret, "KUM");
 			goto local_abort;
 		default:
-			abort_code = RX_USER_ABORT;
+			abort_code = RX_CALL_DEAD;
 			rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
 						abort_code, ret, "KER");
 			goto local_abort;
@@ -836,7 +838,7 @@ void afs_send_empty_reply(struct afs_call *call)
 	case -ENOMEM:
 		_debug("oom");
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RX_USER_ABORT, -ENOMEM, "KOO");
+					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
 		fallthrough;
 	default:
 		_leave(" [error]");
@@ -878,7 +880,7 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	if (n == -ENOMEM) {
 		_debug("oom");
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RX_USER_ABORT, -ENOMEM, "KOO");
+					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
 	}
 	_leave(" [error]");
 }
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 22e05de5d1ca..e426f6831aab 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -377,9 +377,9 @@ void rxrpc_process_call(struct work_struct *work)
 		if (test_bit(RXRPC_CALL_RX_HEARD, &call->flags) &&
 		    (int)call->conn->hi_serial - (int)call->rx_serial > 0) {
 			trace_rxrpc_call_reset(call);
-			rxrpc_abort_call("EXP", call, 0, RX_USER_ABORT, -ECONNRESET);
+			rxrpc_abort_call("EXP", call, 0, RX_CALL_DEAD, -ECONNRESET);
 		} else {
-			rxrpc_abort_call("EXP", call, 0, RX_USER_ABORT, -ETIME);
+			rxrpc_abort_call("EXP", call, 0, RX_CALL_TIMEOUT, -ETIME);
 		}
 		set_bit(RXRPC_CALL_EV_ABORT, &call->events);
 		goto recheck_state;
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 03c7f2269151..22089e37e97f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -183,7 +183,7 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 			chan->last_type = RXRPC_PACKET_TYPE_ABORT;
 			break;
 		default:
-			chan->last_abort = RX_USER_ABORT;
+			chan->last_abort = RX_CALL_DEAD;
 			chan->last_type = RXRPC_PACKET_TYPE_ABORT;
 			break;
 		}


