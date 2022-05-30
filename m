Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB31E537EEA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiE3N5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiE3Nzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:55:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942018AE65;
        Mon, 30 May 2022 06:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 442F3B80D84;
        Mon, 30 May 2022 13:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A1C36AE5;
        Mon, 30 May 2022 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917890;
        bh=UEtTKC+segok9K/ynO7AyNzCmnn7J3j6y8rLTN8HqF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlKZPjC5qRIUGS4Wr7KvHt072wrncxU3wTp5sDRE2z1r28tN1hojyFIfMQ5WX5go8
         AniOyzxq7mPDATVFybhAScCGSuJ6Ut6KSat7Y7OTNRRdi6VsVYulRSiB5E43tvxVCP
         FoY0dOLbXsLiB8SPWlElEkV5vgzjBleSeu6bfPxv9fFv8uTco9effzLIkTkbsMnaxl
         6tjhCKh6+fQpSL2afuiRmgxO0SEGVxoSQ9OM9MIy2U6EDCgn82GYxGAzls8LRK2Pqs
         HZ53y0Cvlh2C3hfFRdHJ+AnWoHVUAcXyjp9lHMXUGaadhBr5XrQ2Wpjzl0rczAhoWg
         nk5LBW6MaD7Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 130/135] rxrpc, afs: Fix selection of abort codes
Date:   Mon, 30 May 2022 09:31:28 -0400
Message-Id: <20220530133133.1931716-130-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit de696c4784f0706884458893c5a6c39b3a3ff65c ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c          | 8 +++++---
 net/rxrpc/call_event.c  | 4 ++--
 net/rxrpc/conn_object.c | 2 +-
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
index b2159dbf5412..660cd9b1a465 100644
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
-- 
2.35.1

