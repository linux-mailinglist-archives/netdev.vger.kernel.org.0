Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773CF6448A3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiLFQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiLFQCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49AD286ED
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kRLmKgK6yTanNGgmOMXwBGuf2jqDuVfaU4sS1IhfdM=;
        b=LtM+SBQtP8ECoeq4SAXKJRMSTAVeG+cUURv2WxuLeNoKx36hHZuAzcumbhST5+xKrQHtdX
        kbKGeNUIlX57wtyAlzrpI8oL+iccldmTO8Se0x2wVcDtDderXde49aaWLpHSGOMUhZh4ck
        WL5ZnUEih5K3wTkh6W1IZooqDjQAJXg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-d2V8GHtSNk248ZDT1MmmMA-1; Tue, 06 Dec 2022 11:01:04 -0500
X-MC-Unique: d2V8GHtSNk248ZDT1MmmMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D16341C008A6;
        Tue,  6 Dec 2022 16:01:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C60321759E;
        Tue,  6 Dec 2022 16:01:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/32] rxrpc: Tidy up abort generation infrastructure
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:01:00 +0000
Message-ID: <167034245999.1105287.14721103400935951983.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tidy up the abort generation infrastructure in the following ways:

 (1) Create an enum and string mapping table to list the reasons an abort
     might be generated in tracing.

 (2) Replace the 3-char string with the values from (1) in the places that
     use that to log the abort source.  This gets rid of a memcpy() in the
     tracepoint.

 (3) Subsume the rxrpc_rx_eproto tracepoint with the rxrpc_abort tracepoint
     and use values from (1) to indicate the trace reason.

 (4) Always make a call to an abort function at the point of the abort
     rather than stashing the values into variables and using goto to get
     to a place where it reported.  The C optimiser will collapse the calls
     together as appropriate.  The abort functions return a value that can
     be returned directly if appropriate.

Note that this extends into afs also at the points where that generates an
abort.  To aid with this, the afs sources need to #define
RXRPC_TRACE_ONLY_DEFINE_ENUMS before including the rxrpc tracing header
because they don't have access to the rxrpc internal structures that some of
the tracepoints make use of.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 fs/afs/cmservice.c           |    6 +
 fs/afs/rxrpc.c               |   23 ++-
 include/net/af_rxrpc.h       |    3 
 include/trace/events/rxrpc.h |  140 +++++++++++++++---
 net/rxrpc/ar-internal.h      |   39 +++--
 net/rxrpc/call_accept.c      |   27 ++--
 net/rxrpc/call_event.c       |   13 +-
 net/rxrpc/call_object.c      |    6 +
 net/rxrpc/conn_event.c       |   19 +-
 net/rxrpc/input.c            |   65 ++++-----
 net/rxrpc/insecure.c         |    6 +
 net/rxrpc/io_thread.c        |  165 ++++++++++------------
 net/rxrpc/recvmsg.c          |   20 ++-
 net/rxrpc/rxkad.c            |  321 +++++++++++++++++-------------------------
 net/rxrpc/rxperf.c           |   17 ++
 net/rxrpc/security.c         |   14 +-
 net/rxrpc/sendmsg.c          |   20 ++-
 17 files changed, 470 insertions(+), 434 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 0a090d614e76..6fcc09201697 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -13,6 +13,8 @@
 #include "internal.h"
 #include "afs_cm.h"
 #include "protocol_yfs.h"
+#define RXRPC_TRACE_ONLY_DEFINE_ENUMS
+#include <trace/events/rxrpc.h>
 
 static int afs_deliver_cb_init_call_back_state(struct afs_call *);
 static int afs_deliver_cb_init_call_back_state3(struct afs_call *);
@@ -191,7 +193,7 @@ static void afs_cm_destructor(struct afs_call *call)
  * Abort a service call from within an action function.
  */
 static void afs_abort_service_call(struct afs_call *call, u32 abort_code, int error,
-				   const char *why)
+				   enum rxrpc_abort_reason why)
 {
 	rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
 				abort_code, error, why);
@@ -469,7 +471,7 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 	if (memcmp(r, &call->net->uuid, sizeof(call->net->uuid)) == 0)
 		afs_send_empty_reply(call);
 	else
-		afs_abort_service_call(call, 1, 1, "K-1");
+		afs_abort_service_call(call, 1, 1, afs_abort_probeuuid_negative);
 
 	afs_put_call(call);
 	_leave("");
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index eccc3cd0cb70..cfff7f9ccc33 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -13,6 +13,8 @@
 #include "internal.h"
 #include "afs_cm.h"
 #include "protocol_yfs.h"
+#define RXRPC_TRACE_ONLY_DEFINE_ENUMS
+#include <trace/events/rxrpc.h>
 
 struct workqueue_struct *afs_async_calls;
 
@@ -397,7 +399,8 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 error_do_abort:
 	if (ret != -ECONNABORTED) {
 		rxrpc_kernel_abort_call(call->net->socket, rxcall,
-					RX_USER_ABORT, ret, "KSD");
+					RX_USER_ABORT, ret,
+					afs_abort_send_data_error);
 	} else {
 		len = 0;
 		iov_iter_kvec(&msg.msg_iter, READ, NULL, 0, 0);
@@ -527,7 +530,8 @@ static void afs_deliver_to_call(struct afs_call *call)
 		case -ENOTSUPP:
 			abort_code = RXGEN_OPCODE;
 			rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-						abort_code, ret, "KIV");
+						abort_code, ret,
+						afs_abort_op_not_supported);
 			goto local_abort;
 		case -EIO:
 			pr_err("kAFS: Call %u in bad state %u\n",
@@ -542,12 +546,14 @@ static void afs_deliver_to_call(struct afs_call *call)
 			if (state != AFS_CALL_CL_AWAIT_REPLY)
 				abort_code = RXGEN_SS_UNMARSHAL;
 			rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-						abort_code, ret, "KUM");
+						abort_code, ret,
+						afs_abort_unmarshal_error);
 			goto local_abort;
 		default:
 			abort_code = RX_CALL_DEAD;
 			rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-						abort_code, ret, "KER");
+						abort_code, ret,
+						afs_abort_general_error);
 			goto local_abort;
 		}
 	}
@@ -619,7 +625,8 @@ long afs_wait_for_call_to_complete(struct afs_call *call,
 			/* Kill off the call if it's still live. */
 			_debug("call interrupted");
 			if (rxrpc_kernel_abort_call(call->net->socket, call->rxcall,
-						    RX_USER_ABORT, -EINTR, "KWI"))
+						    RX_USER_ABORT, -EINTR,
+						    afs_abort_interrupted))
 				afs_set_call_complete(call, -EINTR, 0);
 		}
 	}
@@ -836,7 +843,8 @@ void afs_send_empty_reply(struct afs_call *call)
 	case -ENOMEM:
 		_debug("oom");
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
+					RXGEN_SS_MARSHAL, -ENOMEM,
+					afs_abort_oom);
 		fallthrough;
 	default:
 		_leave(" [error]");
@@ -878,7 +886,8 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 	if (n == -ENOMEM) {
 		_debug("oom");
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
+					RXGEN_SS_MARSHAL, -ENOMEM,
+					afs_abort_oom);
 	}
 	_leave(" [error]");
 }
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index d5a5ae926380..ba717eac0229 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -15,6 +15,7 @@ struct key;
 struct sock;
 struct socket;
 struct rxrpc_call;
+enum rxrpc_abort_reason;
 
 enum rxrpc_interruptibility {
 	RXRPC_INTERRUPTIBLE,	/* Call is interruptible */
@@ -55,7 +56,7 @@ int rxrpc_kernel_send_data(struct socket *, struct rxrpc_call *,
 int rxrpc_kernel_recv_data(struct socket *, struct rxrpc_call *,
 			   struct iov_iter *, size_t *, bool, u32 *, u16 *);
 bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
-			     u32, int, const char *);
+			     u32, int, enum rxrpc_abort_reason);
 void rxrpc_kernel_end_call(struct socket *, struct rxrpc_call *);
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d9c754f8ef2b..76d0bdc3e170 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -23,6 +23,104 @@
 	EM(rxrpc_sack_none,			"---")	\
 	E_(rxrpc_sack_oos,			"OOS")
 
+#define rxrpc_abort_reasons \
+	/* AFS errors */						\
+	EM(afs_abort_general_error,		"afs-error")		\
+	EM(afs_abort_interrupted,		"afs-intr")		\
+	EM(afs_abort_oom,			"afs-oom")		\
+	EM(afs_abort_op_not_supported,		"afs-op-notsupp")	\
+	EM(afs_abort_probeuuid_negative,	"afs-probeuuid-neg")	\
+	EM(afs_abort_send_data_error,		"afs-send-data")	\
+	EM(afs_abort_unmarshal_error,		"afs-unmarshal")	\
+	/* rxperf errors */						\
+	EM(rxperf_abort_general_error,		"rxperf-error")		\
+	EM(rxperf_abort_oom,			"rxperf-oom")		\
+	EM(rxperf_abort_op_not_supported,	"rxperf-op-notsupp")	\
+	EM(rxperf_abort_unmarshal_error,	"rxperf-unmarshal")	\
+	/* RxKAD security errors */					\
+	EM(rxkad_abort_1_short_check,		"rxkad1-short-check")	\
+	EM(rxkad_abort_1_short_data,		"rxkad1-short-data")	\
+	EM(rxkad_abort_1_short_encdata,		"rxkad1-short-encdata")	\
+	EM(rxkad_abort_1_short_header,		"rxkad1-short-hdr")	\
+	EM(rxkad_abort_2_short_check,		"rxkad2-short-check")	\
+	EM(rxkad_abort_2_short_data,		"rxkad2-short-data")	\
+	EM(rxkad_abort_2_short_header,		"rxkad2-short-hdr")	\
+	EM(rxkad_abort_2_short_len,		"rxkad2-short-len")	\
+	EM(rxkad_abort_bad_checksum,		"rxkad2-bad-cksum")	\
+	EM(rxkad_abort_chall_key_expired,	"rxkad-chall-key-exp")	\
+	EM(rxkad_abort_chall_level,		"rxkad-chall-level")	\
+	EM(rxkad_abort_chall_no_key,		"rxkad-chall-nokey")	\
+	EM(rxkad_abort_chall_short,		"rxkad-chall-short")	\
+	EM(rxkad_abort_chall_version,		"rxkad-chall-version")	\
+	EM(rxkad_abort_resp_bad_callid,		"rxkad-resp-bad-callid") \
+	EM(rxkad_abort_resp_bad_checksum,	"rxkad-resp-bad-cksum")	\
+	EM(rxkad_abort_resp_bad_param,		"rxkad-resp-bad-param")	\
+	EM(rxkad_abort_resp_call_ctr,		"rxkad-resp-call-ctr") \
+	EM(rxkad_abort_resp_call_state,		"rxkad-resp-call-state") \
+	EM(rxkad_abort_resp_key_expired,	"rxkad-resp-key-exp")	\
+	EM(rxkad_abort_resp_key_rejected,	"rxkad-resp-key-rej")	\
+	EM(rxkad_abort_resp_level,		"rxkad-resp-level")	\
+	EM(rxkad_abort_resp_nokey,		"rxkad-resp-nokey")	\
+	EM(rxkad_abort_resp_ooseq,		"rxkad-resp-ooseq")	\
+	EM(rxkad_abort_resp_short,		"rxkad-resp-short")	\
+	EM(rxkad_abort_resp_short_tkt,		"rxkad-resp-short-tkt")	\
+	EM(rxkad_abort_resp_tkt_aname,		"rxkad-resp-tk-aname")	\
+	EM(rxkad_abort_resp_tkt_expired,	"rxkad-resp-tk-exp")	\
+	EM(rxkad_abort_resp_tkt_future,		"rxkad-resp-tk-future")	\
+	EM(rxkad_abort_resp_tkt_inst,		"rxkad-resp-tk-inst")	\
+	EM(rxkad_abort_resp_tkt_len,		"rxkad-resp-tk-len")	\
+	EM(rxkad_abort_resp_tkt_realm,		"rxkad-resp-tk-realm")	\
+	EM(rxkad_abort_resp_tkt_short,		"rxkad-resp-tk-short")	\
+	EM(rxkad_abort_resp_tkt_sinst,		"rxkad-resp-tk-sinst")	\
+	EM(rxkad_abort_resp_tkt_sname,		"rxkad-resp-tk-sname")	\
+	EM(rxkad_abort_resp_unknown_tkt,	"rxkad-resp-unknown-tkt") \
+	EM(rxkad_abort_resp_version,		"rxkad-resp-version")	\
+	/* rxrpc errors */						\
+	EM(rxrpc_abort_call_improper_term,	"call-improper-term")	\
+	EM(rxrpc_abort_call_reset,		"call-reset")		\
+	EM(rxrpc_abort_call_sendmsg,		"call-sendmsg")		\
+	EM(rxrpc_abort_call_sock_release,	"call-sock-rel")	\
+	EM(rxrpc_abort_call_sock_release_tba,	"call-sock-rel-tba")	\
+	EM(rxrpc_abort_call_timeout,		"call-timeout")		\
+	EM(rxrpc_abort_no_service_key,		"no-serv-key")		\
+	EM(rxrpc_abort_nomem,			"nomem")		\
+	EM(rxrpc_abort_service_not_offered,	"serv-not-offered")	\
+	EM(rxrpc_abort_shut_down,		"shut-down")		\
+	EM(rxrpc_abort_unsupported_security,	"unsup-sec")		\
+	EM(rxrpc_badmsg_bad_abort,		"bad-abort")		\
+	EM(rxrpc_badmsg_bad_jumbo,		"bad-jumbo")		\
+	EM(rxrpc_badmsg_short_ack,		"short-ack")		\
+	EM(rxrpc_badmsg_short_ack_info,		"short-ack-info")	\
+	EM(rxrpc_badmsg_short_hdr,		"short-hdr")		\
+	EM(rxrpc_badmsg_unsupported_packet,	"unsup-pkt")		\
+	EM(rxrpc_badmsg_zero_call,		"zero-call")		\
+	EM(rxrpc_badmsg_zero_seq,		"zero-seq")		\
+	EM(rxrpc_badmsg_zero_service,		"zero-service")		\
+	EM(rxrpc_eproto_ackr_outside_window,	"ackr-out-win")		\
+	EM(rxrpc_eproto_ackr_sack_overflow,	"ackr-sack-over")	\
+	EM(rxrpc_eproto_ackr_short_sack,	"ackr-short-sack")	\
+	EM(rxrpc_eproto_ackr_zero,		"ackr-zero")		\
+	EM(rxrpc_eproto_bad_upgrade,		"bad-upgrade")		\
+	EM(rxrpc_eproto_data_after_last,	"data-after-last")	\
+	EM(rxrpc_eproto_different_last,		"diff-last")		\
+	EM(rxrpc_eproto_early_reply,		"early-reply")		\
+	EM(rxrpc_eproto_improper_term,		"improper-term")	\
+	EM(rxrpc_eproto_no_client_call,		"no-cl-call")		\
+	EM(rxrpc_eproto_no_client_conn,		"no-cl-conn")		\
+	EM(rxrpc_eproto_no_service_call,	"no-sv-call")		\
+	EM(rxrpc_eproto_reupgrade,		"re-upgrade")		\
+	EM(rxrpc_eproto_rxnull_challenge,	"rxnull-chall")		\
+	EM(rxrpc_eproto_rxnull_response,	"rxnull-resp")		\
+	EM(rxrpc_eproto_tx_rot_last,		"tx-rot-last")		\
+	EM(rxrpc_eproto_unexpected_ack,		"unex-ack")		\
+	EM(rxrpc_eproto_unexpected_ackall,	"unex-ackall")		\
+	EM(rxrpc_eproto_unexpected_implicit_end, "unex-impl-end")	\
+	EM(rxrpc_eproto_unexpected_reply,	"unex-reply")		\
+	EM(rxrpc_eproto_wrong_security,		"wrong-sec")		\
+	EM(rxrpc_recvmsg_excess_data,		"recvmsg-excess")	\
+	EM(rxrpc_recvmsg_short_data,		"recvmsg-short")	\
+	E_(rxrpc_sendmsg_late_send,		"sendmsg-late")
+
 #define rxrpc_call_poke_traces \
 	EM(rxrpc_call_poke_abort,		"Abort")	\
 	EM(rxrpc_call_poke_complete,		"Compl")	\
@@ -387,6 +485,7 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
+enum rxrpc_abort_reason		{ rxrpc_abort_reasons } __mode(byte);
 enum rxrpc_bundle_trace		{ rxrpc_bundle_traces } __mode(byte);
 enum rxrpc_call_poke_trace	{ rxrpc_call_poke_traces } __mode(byte);
 enum rxrpc_call_trace		{ rxrpc_call_traces } __mode(byte);
@@ -416,9 +515,13 @@ enum rxrpc_txqueue_trace	{ rxrpc_txqueue_traces } __mode(byte);
  */
 #undef EM
 #undef E_
+
+#ifndef RXRPC_TRACE_ONLY_DEFINE_ENUMS
+
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
+rxrpc_abort_reasons;
 rxrpc_bundle_traces;
 rxrpc_call_poke_traces;
 rxrpc_call_traces;
@@ -670,14 +773,14 @@ TRACE_EVENT(rxrpc_rx_done,
 	    );
 
 TRACE_EVENT(rxrpc_abort,
-	    TP_PROTO(unsigned int call_nr, const char *why, u32 cid, u32 call_id,
-		     rxrpc_seq_t seq, int abort_code, int error),
+	    TP_PROTO(unsigned int call_nr, enum rxrpc_abort_reason why,
+		     u32 cid, u32 call_id, rxrpc_seq_t seq, int abort_code, int error),
 
 	    TP_ARGS(call_nr, why, cid, call_id, seq, abort_code, error),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call_nr		)
-		    __array(char,			why, 4		)
+		    __field(enum rxrpc_abort_reason,	why		)
 		    __field(u32,			cid		)
 		    __field(u32,			call_id		)
 		    __field(rxrpc_seq_t,		seq		)
@@ -686,8 +789,8 @@ TRACE_EVENT(rxrpc_abort,
 			     ),
 
 	    TP_fast_assign(
-		    memcpy(__entry->why, why, 4);
 		    __entry->call_nr = call_nr;
+		    __entry->why = why;
 		    __entry->cid = cid;
 		    __entry->call_id = call_id;
 		    __entry->abort_code = abort_code;
@@ -698,7 +801,8 @@ TRACE_EVENT(rxrpc_abort,
 	    TP_printk("c=%08x %08x:%08x s=%u a=%d e=%d %s",
 		      __entry->call_nr,
 		      __entry->cid, __entry->call_id, __entry->seq,
-		      __entry->abort_code, __entry->error, __entry->why)
+		      __entry->abort_code, __entry->error,
+		      __print_symbolic(__entry->why, rxrpc_abort_reasons))
 	    );
 
 TRACE_EVENT(rxrpc_call_complete,
@@ -1536,30 +1640,6 @@ TRACE_EVENT(rxrpc_improper_term,
 		      __entry->abort_code)
 	    );
 
-TRACE_EVENT(rxrpc_rx_eproto,
-	    TP_PROTO(struct rxrpc_call *call, rxrpc_serial_t serial,
-		     const char *why),
-
-	    TP_ARGS(call, serial, why),
-
-	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(const char *,		why		)
-			     ),
-
-	    TP_fast_assign(
-		    __entry->call = call ? call->debug_id : 0;
-		    __entry->serial = serial;
-		    __entry->why = why;
-			   ),
-
-	    TP_printk("c=%08x EPROTO %08x %s",
-		      __entry->call,
-		      __entry->serial,
-		      __entry->why)
-	    );
-
 TRACE_EVENT(rxrpc_connect_call,
 	    TP_PROTO(struct rxrpc_call *call),
 
@@ -1884,6 +1964,8 @@ TRACE_EVENT(rxrpc_sack,
 
 #undef EM
 #undef E_
+
+#endif /* RXRPC_TRACE_ONLY_DEFINE_ENUMS */
 #endif /* _TRACE_RXRPC_H */
 
 /* This part must be outside protection */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ab031f899c2d..f2ab2d8044bd 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -627,9 +627,10 @@ struct rxrpc_call {
 	unsigned long		events;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
 	spinlock_t		state_lock;	/* lock for state transition */
-	const char		*send_abort_why; /* String indicating why the abort was sent */
+	unsigned int		send_abort_why; /* Why the abort [enum rxrpc_abort_reason] */
 	s32			send_abort;	/* Abort code to be sent */
 	short			send_abort_err;	/* Error to be associated with the abort */
+	rxrpc_seq_t		send_abort_seq;	/* DATA packet that incurred the abort (or 0) */
 	s32			abort_code;	/* Local/remote abort code */
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
@@ -842,7 +843,7 @@ void rxrpc_reduce_call_timer(struct rxrpc_call *call,
 			     unsigned long now,
 			     enum rxrpc_timer_trace why);
 
-void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb);
+bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb);
 
 /*
  * call_object.c
@@ -904,12 +905,13 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
 /*
  * conn_event.c
  */
+int rxrpc_abort_conn(struct rxrpc_connection *, struct sk_buff *, s32, int,
+		     enum rxrpc_abort_reason);
 void rxrpc_conn_retransmit_call(struct rxrpc_connection *, struct sk_buff *,
 				unsigned int);
-int rxrpc_abort_conn(struct rxrpc_connection *, struct sk_buff *, s32, int, const char *);
 void rxrpc_process_connection(struct work_struct *);
 void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
-int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
+bool rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
 void rxrpc_input_conn_event(struct rxrpc_connection *, struct sk_buff *);
 
 /*
@@ -974,12 +976,18 @@ void rxrpc_implicit_end_call(struct rxrpc_call *, struct sk_buff *);
  */
 int rxrpc_encap_rcv(struct sock *, struct sk_buff *);
 void rxrpc_error_report(struct sock *);
+bool rxrpc_direct_abort(struct sk_buff *, enum rxrpc_abort_reason, s32, int);
 int rxrpc_io_thread(void *data);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
 	wake_up_process(local->io_thread);
 }
 
+static inline bool rxrpc_protocol_error(struct sk_buff *skb, enum rxrpc_abort_reason why)
+{
+	return rxrpc_direct_abort(skb, why, RX_PROTOCOL_ERROR, -EPROTO);
+}
+
 /*
  * insecure.c
  */
@@ -1108,29 +1116,24 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion
 bool rxrpc_set_call_completion(struct rxrpc_call *, enum rxrpc_call_completion, u32, int);
 bool __rxrpc_call_completed(struct rxrpc_call *);
 bool rxrpc_call_completed(struct rxrpc_call *);
-bool __rxrpc_abort_call(const char *, struct rxrpc_call *, rxrpc_seq_t, u32, int);
-bool rxrpc_abort_call(const char *, struct rxrpc_call *, rxrpc_seq_t, u32, int);
+bool __rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
+bool rxrpc_abort_call(struct rxrpc_call *, rxrpc_seq_t, u32, int, enum rxrpc_abort_reason);
 int rxrpc_recvmsg(struct socket *, struct msghdr *, size_t, int);
 
 /*
  * Abort a call due to a protocol error.
  */
-static inline bool __rxrpc_abort_eproto(struct rxrpc_call *call,
-					struct sk_buff *skb,
-					const char *eproto_why,
-					const char *why,
-					u32 abort_code)
+static inline int rxrpc_abort_eproto(struct rxrpc_call *call,
+				     struct sk_buff *skb,
+				     s32 abort_code,
+				     enum rxrpc_abort_reason why)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
-	trace_rxrpc_rx_eproto(call, sp->hdr.serial, eproto_why);
-	return rxrpc_abort_call(why, call, sp->hdr.seq, abort_code, -EPROTO);
+	rxrpc_abort_call(call, sp->hdr.seq, abort_code, -EPROTO, why);
+	return -EPROTO;
 }
 
-#define rxrpc_abort_eproto(call, skb, eproto_why, abort_why, abort_code) \
-	__rxrpc_abort_eproto((call), (skb), tracepoint_string(eproto_why), \
-			     (abort_why), (abort_code))
-
 /*
  * rtt.c
  */
@@ -1162,7 +1165,7 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
 /*
  * sendmsg.c
  */
-bool rxrpc_propose_abort(struct rxrpc_call *, u32, int, const char *);
+bool rxrpc_propose_abort(struct rxrpc_call *, s32, int, enum rxrpc_abort_reason);
 int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
 
 /*
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index d1850863507f..5fa81bb4abfa 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -339,10 +339,9 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	_enter("");
 
-	/* Don't set up a call for anything other than the first DATA packet. */
-	if (sp->hdr.seq != 1 ||
-	    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
-		return true; /* Just discard */
+	/* Don't set up a call for anything other than a DATA packet. */
+	if (sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
+		return rxrpc_protocol_error(skb, rxrpc_eproto_no_service_call);
 
 	rcu_read_lock();
 
@@ -363,16 +362,14 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	if (!conn) {
 		sec = rxrpc_get_incoming_security(rx, skb);
 		if (!sec)
-			goto reject;
+			goto unsupported_security;
 	}
 
 	spin_lock(&rx->incoming_lock);
 	if (rx->sk.sk_state == RXRPC_SERVER_LISTEN_DISABLED ||
 	    rx->sk.sk_state == RXRPC_CLOSE) {
-		trace_rxrpc_abort(0, "CLS", sp->hdr.cid, sp->hdr.callNumber,
-				  sp->hdr.seq, RX_INVALID_OPERATION, ESHUTDOWN);
-		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-		skb->priority = RX_INVALID_OPERATION;
+		rxrpc_direct_abort(skb, rxrpc_abort_shut_down,
+				   RX_INVALID_OPERATION, -ESHUTDOWN);
 		goto no_call;
 	}
 
@@ -416,13 +413,15 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	return true;
 
 unsupported_service:
-	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_INVALID_OPERATION, EOPNOTSUPP);
-	skb->priority = RX_INVALID_OPERATION;
-	goto reject;
+	rcu_read_unlock();
+	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
+				  RX_INVALID_OPERATION, -EOPNOTSUPP);
+unsupported_security:
+	rcu_read_unlock();
+	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
+				  RX_INVALID_OPERATION, -EKEYREJECTED);
 no_call:
 	spin_unlock(&rx->incoming_lock);
-reject:
 	rcu_read_unlock();
 	_leave(" = f [%u]", skb->mark);
 	return false;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 60bec6feba4a..b41ffb0a69e9 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -331,7 +331,7 @@ static void rxrpc_send_initial_ping(struct rxrpc_call *call)
 /*
  * Handle retransmission and deferred ACK/abort generation.
  */
-void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
+bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	unsigned long now, next, t;
 	rxrpc_serial_t ackr_serial;
@@ -356,8 +356,8 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 
 	abort_code = smp_load_acquire(&call->send_abort);
 	if (abort_code)
-		rxrpc_abort_call(call->send_abort_why, call, 0, call->send_abort,
-				 call->send_abort_err);
+		rxrpc_abort_call(call, 0, call->send_abort, call->send_abort_err,
+				 call->send_abort_why);
 
 	if (skb && skb->mark == RXRPC_SKB_MARK_ERROR)
 		goto out;
@@ -442,9 +442,11 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		if (test_bit(RXRPC_CALL_RX_HEARD, &call->flags) &&
 		    (int)call->conn->hi_serial - (int)call->rx_serial > 0) {
 			trace_rxrpc_call_reset(call);
-			rxrpc_abort_call("EXP", call, 0, RX_CALL_DEAD, -ECONNRESET);
+			rxrpc_abort_call(call, 0, RX_CALL_DEAD, -ECONNRESET,
+					 rxrpc_abort_call_reset);
 		} else {
-			rxrpc_abort_call("EXP", call, 0, RX_CALL_TIMEOUT, -ETIME);
+			rxrpc_abort_call(call, 0, RX_CALL_TIMEOUT, -ETIME,
+					 rxrpc_abort_call_timeout);
 		}
 		goto out;
 	}
@@ -505,4 +507,5 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (call->acks_hard_ack != call->tx_bottom)
 		rxrpc_shrink_call_tx_buffer(call);
 	_leave("");
+	return true;
 }
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 924c8dc58ac9..cd491fd83c0d 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -578,7 +578,8 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 		call = list_entry(rx->to_be_accepted.next,
 				  struct rxrpc_call, accept_link);
 		list_del(&call->accept_link);
-		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET, "SKR");
+		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET,
+				    rxrpc_abort_call_sock_release_tba);
 		rxrpc_put_call(call, rxrpc_call_put_release_sock_tba);
 	}
 
@@ -586,7 +587,8 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 		call = list_entry(rx->sock_calls.next,
 				  struct rxrpc_call, sock_link);
 		rxrpc_get_call(call, rxrpc_call_get_release_sock);
-		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET, "SKT");
+		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET,
+				    rxrpc_abort_call_sock_release);
 		rxrpc_release_call(rx, call);
 		rxrpc_put_call(call, rxrpc_call_put_release_sock);
 	}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 93a892471999..21c826161741 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -47,7 +47,7 @@ static bool rxrpc_set_conn_aborted(struct rxrpc_connection *conn, struct sk_buff
  * Mark a socket buffer to indicate that the connection it's on should be aborted.
  */
 int rxrpc_abort_conn(struct rxrpc_connection *conn, struct sk_buff *skb,
-		     s32 abort_code, int err, const char *why)
+		     s32 abort_code, int err, enum rxrpc_abort_reason why)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
@@ -288,8 +288,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		return 0;
 
 	default:
-		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-				      tracepoint_string("bad_conn_pkt"));
+		WARN_ON_ONCE(1);
 		return -EPROTO;
 	}
 }
@@ -300,7 +299,8 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 static void rxrpc_secure_connection(struct rxrpc_connection *conn)
 {
 	if (conn->security->issue_challenge(conn) < 0)
-		rxrpc_abort_conn(conn, NULL, RX_CALL_DEAD, -ENOMEM, "OOM");
+		rxrpc_abort_conn(conn, NULL, RX_CALL_DEAD, -ENOMEM,
+				 rxrpc_abort_nomem);
 }
 
 /*
@@ -405,14 +405,14 @@ static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
 /*
  * Input a connection-level packet.
  */
-int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
+bool rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets for now. */
-		return 0;
+		return true;
 
 	case RXRPC_PACKET_TYPE_ABORT:
 		if (smp_load_acquire(&conn->state) == RXRPC_CONN_ABORTED)
@@ -429,12 +429,11 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 			return true;
 		}
 		rxrpc_post_packet_to_conn(conn, skb);
-		return 0;
+		return true;
 
 	default:
-		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-				      tracepoint_string("bad_conn_pkt"));
-		return -EPROTO;
+		WARN_ON_ONCE(1);
+		return true;
 	}
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 423b1839c06d..dce440600f1a 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -9,10 +9,10 @@
 
 #include "ar-internal.h"
 
-static void rxrpc_proto_abort(const char *why,
-			      struct rxrpc_call *call, rxrpc_seq_t seq)
+static void rxrpc_proto_abort(struct rxrpc_call *call, rxrpc_seq_t seq,
+			      enum rxrpc_abort_reason why)
 {
-	rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG);
+	rxrpc_abort_call(call, seq, RX_PROTOCOL_ERROR, -EBADMSG, why);
 }
 
 /*
@@ -249,8 +249,8 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
  * This occurs when we get an ACKALL packet, the first DATA packet of a reply,
  * or a final ACK packet.
  */
-static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
-			       const char *abort_why)
+static void rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
+			       enum rxrpc_abort_reason abort_why)
 {
 	unsigned int state;
 
@@ -283,13 +283,12 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 	else
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_end);
 	_leave(" = ok");
-	return true;
+	return;
 
 bad_state:
 	spin_unlock(&call->state_lock);
 	kdebug("end_tx %s", rxrpc_call_states[call->state]);
-	rxrpc_proto_abort(abort_why, call, call->tx_top);
-	return false;
+	rxrpc_proto_abort(call, call->tx_top, abort_why);
 }
 
 /*
@@ -311,11 +310,13 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 
 	if (!test_bit(RXRPC_CALL_TX_LAST, &call->flags)) {
 		if (!rxrpc_rotate_tx_window(call, top, &summary)) {
-			rxrpc_proto_abort("TXL", call, top);
+			rxrpc_proto_abort(call, top, rxrpc_eproto_early_reply);
 			return false;
 		}
 	}
-	return rxrpc_end_tx_phase(call, true, "ETD");
+
+	rxrpc_end_tx_phase(call, true, rxrpc_eproto_unexpected_reply);
+	return true;
 }
 
 static void rxrpc_input_update_ack_window(struct rxrpc_call *call,
@@ -366,17 +367,14 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 
 	if (last) {
 		if (test_and_set_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-		    seq + 1 != wtop) {
-			rxrpc_proto_abort("LSN", call, seq);
-			return;
-		}
+		    seq + 1 != wtop)
+			return rxrpc_proto_abort(call, seq, rxrpc_eproto_different_last);
 	} else {
 		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
 		    after_eq(seq, wtop)) {
 			pr_warn("Packet beyond last: c=%x q=%x window=%x-%x wlimit=%x\n",
 				call->debug_id, seq, window, wtop, wlimit);
-			rxrpc_proto_abort("LSA", call, seq);
-			return;
+			return rxrpc_proto_abort(call, seq, rxrpc_eproto_data_after_last);
 		}
 	}
 
@@ -583,7 +581,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		goto out_notify;
 
 	if (!rxrpc_input_split_jumbo(call, skb)) {
-		rxrpc_proto_abort("VLD", call, sp->hdr.seq);
+		rxrpc_proto_abort(call, sp->hdr.seq, rxrpc_badmsg_bad_jumbo);
 		goto out_notify;
 	}
 	skb = NULL;
@@ -764,7 +762,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	offset = sizeof(struct rxrpc_wire_header);
 	if (skb_copy_bits(skb, offset, &ack, sizeof(ack)) < 0)
-		return rxrpc_proto_abort("XAK", call, 0);
+		return rxrpc_proto_abort(call, 0, rxrpc_badmsg_short_ack);
 	offset += sizeof(ack);
 
 	ack_serial = sp->hdr.serial;
@@ -844,7 +842,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	ioffset = offset + nr_acks + 3;
 	if (skb->len >= ioffset + sizeof(info) &&
 	    skb_copy_bits(skb, ioffset, &info, sizeof(info)) < 0)
-		return rxrpc_proto_abort("XAI", call, 0);
+		return rxrpc_proto_abort(call, 0, rxrpc_badmsg_short_ack_info);
 
 	if (nr_acks > 0)
 		skb_condense(skb);
@@ -867,7 +865,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_input_ackinfo(call, skb, &info);
 
 	if (first_soft_ack == 0)
-		return rxrpc_proto_abort("AK0", call, 0);
+		return rxrpc_proto_abort(call, 0, rxrpc_eproto_ackr_zero);
 
 	/* Ignore ACKs unless we are or have just been transmitting. */
 	switch (READ_ONCE(call->state)) {
@@ -882,20 +880,20 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	if (before(hard_ack, call->acks_hard_ack) ||
 	    after(hard_ack, call->tx_top))
-		return rxrpc_proto_abort("AKW", call, 0);
+		return rxrpc_proto_abort(call, 0, rxrpc_eproto_ackr_outside_window);
 	if (nr_acks > call->tx_top - hard_ack)
-		return rxrpc_proto_abort("AKN", call, 0);
+		return rxrpc_proto_abort(call, 0, rxrpc_eproto_ackr_sack_overflow);
 
 	if (after(hard_ack, call->acks_hard_ack)) {
 		if (rxrpc_rotate_tx_window(call, hard_ack, &summary)) {
-			rxrpc_end_tx_phase(call, false, "ETA");
+			rxrpc_end_tx_phase(call, false, rxrpc_eproto_unexpected_ack);
 			return;
 		}
 	}
 
 	if (nr_acks > 0) {
 		if (offset > (int)skb->len - nr_acks)
-			return rxrpc_proto_abort("XSA", call, 0);
+			return rxrpc_proto_abort(call, 0, rxrpc_eproto_ackr_short_sack);
 		rxrpc_input_soft_acks(call, skb->data + offset, first_soft_ack,
 				      nr_acks, &summary);
 	}
@@ -917,7 +915,7 @@ static void rxrpc_input_ackall(struct rxrpc_call *call, struct sk_buff *skb)
 	struct rxrpc_ack_summary summary = { 0 };
 
 	if (rxrpc_rotate_tx_window(call, call->tx_top, &summary))
-		rxrpc_end_tx_phase(call, false, "ETL");
+		rxrpc_end_tx_phase(call, false, rxrpc_eproto_unexpected_ackall);
 }
 
 /*
@@ -962,27 +960,23 @@ void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
 
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_DATA:
-		rxrpc_input_data(call, skb);
-		break;
+		return rxrpc_input_data(call, skb);
 
 	case RXRPC_PACKET_TYPE_ACK:
-		rxrpc_input_ack(call, skb);
-		break;
+		return rxrpc_input_ack(call, skb);
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets from the server; the retry and
 		 * lifespan timers will take care of business.  BUSY packets
 		 * from the client don't make sense.
 		 */
-		break;
+		return;
 
 	case RXRPC_PACKET_TYPE_ABORT:
-		rxrpc_input_abort(call, skb);
-		break;
+		return rxrpc_input_abort(call, skb);
 
 	case RXRPC_PACKET_TYPE_ACKALL:
-		rxrpc_input_ackall(call, skb);
-		break;
+		return rxrpc_input_ackall(call, skb);
 
 	default:
 		break;
@@ -1004,7 +998,8 @@ void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 	case RXRPC_CALL_COMPLETE:
 		break;
 	default:
-		rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN);
+		rxrpc_abort_call(call, 0, RX_CALL_DEAD, -ESHUTDOWN,
+				 rxrpc_eproto_improper_term);
 		trace_rxrpc_improper_term(call);
 		break;
 	}
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index 29dcc7d3f51a..34353b6e584b 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -45,13 +45,15 @@ static void none_free_call_crypto(struct rxrpc_call *call)
 static int none_respond_to_challenge(struct rxrpc_connection *conn,
 				     struct sk_buff *skb)
 {
-	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO, "RXN");
+	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO,
+				rxrpc_eproto_rxnull_challenge);
 }
 
 static int none_verify_response(struct rxrpc_connection *conn,
 				struct sk_buff *skb)
 {
-	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO, "RXN");
+	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO,
+				rxrpc_eproto_rxnull_response);
 }
 
 static void none_clear(struct rxrpc_connection *conn)
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index be23b2dc930f..f709f6f109db 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -73,10 +73,32 @@ void rxrpc_error_report(struct sock *sk)
 	rcu_read_unlock();
 }
 
+/*
+ * Directly produce an abort from a packet.
+ */
+bool rxrpc_direct_abort(struct sk_buff *skb, enum rxrpc_abort_reason why,
+			s32 abort_code, int err)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+
+	trace_rxrpc_abort(0, why, sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  abort_code, err);
+	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+	skb->priority = abort_code;
+	return false;
+}
+
+static bool rxrpc_bad_message(struct sk_buff *skb, enum rxrpc_abort_reason why)
+{
+	return rxrpc_direct_abort(skb, why, RX_PROTOCOL_ERROR, -EBADMSG);
+}
+
+#define just_discard true
+
 /*
  * Process event packets targeted at a local endpoint.
  */
-static void rxrpc_input_version(struct rxrpc_local *local, struct sk_buff *skb)
+static bool rxrpc_input_version(struct rxrpc_local *local, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	char v;
@@ -88,22 +110,21 @@ static void rxrpc_input_version(struct rxrpc_local *local, struct sk_buff *skb)
 		if (v == 0)
 			rxrpc_send_version_request(local, &sp->hdr, skb);
 	}
+
+	return true;
 }
 
 /*
  * Extract the wire header from a packet and translate the byte order.
  */
-static noinline
-int rxrpc_extract_header(struct rxrpc_skb_priv *sp, struct sk_buff *skb)
+static bool rxrpc_extract_header(struct rxrpc_skb_priv *sp,
+				 struct sk_buff *skb)
 {
 	struct rxrpc_wire_header whdr;
 
 	/* dig out the RxRPC connection details */
-	if (skb_copy_bits(skb, 0, &whdr, sizeof(whdr)) < 0) {
-		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-				      tracepoint_string("bad_hdr"));
-		return -EBADMSG;
-	}
+	if (skb_copy_bits(skb, 0, &whdr, sizeof(whdr)) < 0)
+		return rxrpc_bad_message(skb, rxrpc_badmsg_short_hdr);
 
 	memset(sp, 0, sizeof(*sp));
 	sp->hdr.epoch		= ntohl(whdr.epoch);
@@ -117,7 +138,7 @@ int rxrpc_extract_header(struct rxrpc_skb_priv *sp, struct sk_buff *skb)
 	sp->hdr.securityIndex	= whdr.securityIndex;
 	sp->hdr._rsvd		= ntohs(whdr._rsvd);
 	sp->hdr.serviceId	= ntohs(whdr.serviceId);
-	return 0;
+	return true;
 }
 
 /*
@@ -137,28 +158,28 @@ static bool rxrpc_extract_abort(struct sk_buff *skb)
 /*
  * Process packets received on the local endpoint
  */
-static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
+static bool rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 {
 	struct rxrpc_connection *conn;
 	struct sockaddr_rxrpc peer_srx;
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_peer *peer = NULL;
 	struct sk_buff *skb = *_skb;
-	int ret = 0;
+	bool ret = false;
 
 	skb_pull(skb, sizeof(struct udphdr));
 
 	sp = rxrpc_skb(skb);
 
 	/* dig out the RxRPC connection details */
-	if (rxrpc_extract_header(sp, skb) < 0)
-		goto bad_message;
+	if (!rxrpc_extract_header(sp, skb))
+		return just_discard;
 
 	if (IS_ENABLED(CONFIG_AF_RXRPC_INJECT_LOSS)) {
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			trace_rxrpc_rx_lose(sp);
-			return 0;
+			return just_discard;
 		}
 	}
 
@@ -167,28 +188,28 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_VERSION:
 		if (rxrpc_to_client(sp))
-			return 0;
-		rxrpc_input_version(local, skb);
-		return 0;
+			return just_discard;
+		return rxrpc_input_version(local, skb);
 
 	case RXRPC_PACKET_TYPE_BUSY:
 		if (rxrpc_to_server(sp))
-			return 0;
+			return just_discard;
 		fallthrough;
 	case RXRPC_PACKET_TYPE_ACK:
 	case RXRPC_PACKET_TYPE_ACKALL:
 		if (sp->hdr.callNumber == 0)
-			goto bad_message;
+			return rxrpc_bad_message(skb, rxrpc_badmsg_zero_call);
 		break;
 	case RXRPC_PACKET_TYPE_ABORT:
 		if (!rxrpc_extract_abort(skb))
-			return 0; /* Just discard if malformed */
+			return just_discard; /* Just discard if malformed */
 		break;
 
 	case RXRPC_PACKET_TYPE_DATA:
-		if (sp->hdr.callNumber == 0 ||
-		    sp->hdr.seq == 0)
-			goto bad_message;
+		if (sp->hdr.callNumber == 0)
+			return rxrpc_bad_message(skb, rxrpc_badmsg_zero_call);
+		if (sp->hdr.seq == 0)
+			return rxrpc_bad_message(skb, rxrpc_badmsg_zero_seq);
 
 		/* Unshare the packet so that it can be modified for in-place
 		 * decryption.
@@ -198,7 +219,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 			if (!skb) {
 				rxrpc_eaten_skb(*_skb, rxrpc_skb_eaten_by_unshare_nomem);
 				*_skb = NULL;
-				return 0;
+				return just_discard;
 			}
 
 			if (skb != *_skb) {
@@ -212,28 +233,28 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
 		if (rxrpc_to_server(sp))
-			return 0;
+			return just_discard;
 		break;
 	case RXRPC_PACKET_TYPE_RESPONSE:
 		if (rxrpc_to_client(sp))
-			return 0;
+			return just_discard;
 		break;
 
 		/* Packet types 9-11 should just be ignored. */
 	case RXRPC_PACKET_TYPE_PARAMS:
 	case RXRPC_PACKET_TYPE_10:
 	case RXRPC_PACKET_TYPE_11:
-		return 0;
+		return just_discard;
 
 	default:
-		goto bad_message;
+		return rxrpc_bad_message(skb, rxrpc_badmsg_unsupported_packet);
 	}
 
 	if (sp->hdr.serviceId == 0)
-		goto bad_message;
+		return rxrpc_bad_message(skb, rxrpc_badmsg_zero_service);
 
 	if (WARN_ON_ONCE(rxrpc_extract_addr_from_skb(&peer_srx, skb) < 0))
-		return true; /* Unsupported address type - discard. */
+		return just_discard; /* Unsupported address type. */
 
 	if (peer_srx.transport.family != local->srx.transport.family &&
 	    (peer_srx.transport.family == AF_INET &&
@@ -241,7 +262,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		pr_warn_ratelimited("AF_RXRPC: Protocol mismatch %u not %u\n",
 				    peer_srx.transport.family,
 				    local->srx.transport.family);
-		return true; /* Wrong address type - discard. */
+		return just_discard; /* Wrong address type. */
 	}
 
 	if (rxrpc_to_client(sp)) {
@@ -249,12 +270,8 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		conn = rxrpc_find_client_connection_rcu(local, &peer_srx, skb);
 		conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
 		rcu_read_unlock();
-		if (!conn) {
-			trace_rxrpc_abort(0, "NCC", sp->hdr.cid,
-					  sp->hdr.callNumber, sp->hdr.seq,
-					  RXKADINCONSISTENCY, EBADMSG);
-			goto protocol_error;
-		}
+		if (!conn)
+			return rxrpc_protocol_error(skb, rxrpc_eproto_no_client_conn);
 
 		ret = rxrpc_input_packet_on_conn(conn, &peer_srx, skb);
 		rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
@@ -287,18 +304,6 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 
 	ret = rxrpc_new_incoming_call(local, peer, NULL, &peer_srx, skb);
 	rxrpc_put_peer(peer, rxrpc_peer_put_input);
-	if (ret < 0)
-		goto reject_packet;
-	return 0;
-
-bad_message:
-	trace_rxrpc_abort(0, "BAD", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_PROTOCOL_ERROR, EBADMSG);
-protocol_error:
-	skb->priority = RX_PROTOCOL_ERROR;
-	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-reject_packet:
-	rxrpc_reject_packet(local, skb);
 	return ret;
 }
 
@@ -313,21 +318,23 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 	struct rxrpc_channel *chan;
 	struct rxrpc_call *call = NULL;
 	unsigned int channel;
+	bool ret;
 
 	if (sp->hdr.securityIndex != conn->security_ix)
-		goto wrong_security;
+		return rxrpc_direct_abort(skb, rxrpc_eproto_wrong_security,
+					  RXKADINCONSISTENCY, -EBADMSG);
 
 	if (sp->hdr.serviceId != conn->service_id) {
 		int old_id;
 
 		if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
-			goto reupgrade;
+			return rxrpc_protocol_error(skb, rxrpc_eproto_reupgrade);
+
 		old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
 				 sp->hdr.serviceId);
-
 		if (old_id != conn->orig_service_id &&
 		    old_id != sp->hdr.serviceId)
-			goto reupgrade;
+			return rxrpc_protocol_error(skb, rxrpc_eproto_bad_upgrade);
 	}
 
 	if (after(sp->hdr.serial, conn->hi_serial))
@@ -343,19 +350,19 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 
 	/* Ignore really old calls */
 	if (sp->hdr.callNumber < chan->last_call)
-		return 0;
+		return just_discard;
 
 	if (sp->hdr.callNumber == chan->last_call) {
 		if (chan->call ||
 		    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
-			return 0;
+			return just_discard;
 
 		/* For the previous service call, if completed successfully, we
 		 * discard all further packets.
 		 */
 		if (rxrpc_conn_is_service(conn) &&
 		    chan->last_type == RXRPC_PACKET_TYPE_ACK)
-			return 0;
+			return just_discard;
 
 		/* But otherwise we need to retransmit the final packet from
 		 * data cached in the connection record.
@@ -366,7 +373,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 					    sp->hdr.serial,
 					    sp->hdr.flags);
 		rxrpc_conn_retransmit_call(conn, skb, channel);
-		return 0;
+		return just_discard;
 	}
 
 	rcu_read_lock();
@@ -375,10 +382,9 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 	rcu_read_unlock();
 
 	if (sp->hdr.callNumber > chan->call_id) {
-		if (rxrpc_to_client(sp)) {
-			rxrpc_put_call(call, rxrpc_call_put_input);
-			goto reject_packet;
-		}
+		if (rxrpc_to_client(sp))
+			return rxrpc_protocol_error(
+				skb, rxrpc_eproto_unexpected_implicit_end);
 
 		if (call) {
 			rxrpc_implicit_end_call(call, skb);
@@ -389,38 +395,14 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 
 	if (!call) {
 		if (rxrpc_to_client(sp))
-			goto bad_message;
-		if (rxrpc_new_incoming_call(conn->local, conn->peer, conn,
-					    peer_srx, skb))
-			return 0;
-		goto reject_packet;
+			return rxrpc_protocol_error(skb, rxrpc_eproto_no_client_call);
+		return rxrpc_new_incoming_call(conn->local, conn->peer, conn,
+					       peer_srx, skb);
 	}
 
-	rxrpc_input_call_event(call, skb);
+	ret = rxrpc_input_call_event(call, skb);
 	rxrpc_put_call(call, rxrpc_call_put_input);
-	return 0;
-
-wrong_security:
-	trace_rxrpc_abort(0, "SEC", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RXKADINCONSISTENCY, EBADMSG);
-	skb->priority = RXKADINCONSISTENCY;
-	goto post_abort;
-
-reupgrade:
-	trace_rxrpc_abort(0, "UPG", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_PROTOCOL_ERROR, EBADMSG);
-	goto protocol_error;
-
-bad_message:
-	trace_rxrpc_abort(0, "BAD", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_PROTOCOL_ERROR, EBADMSG);
-protocol_error:
-	skb->priority = RX_PROTOCOL_ERROR;
-post_abort:
-	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-reject_packet:
-	rxrpc_reject_packet(conn->local, skb);
-	return 0;
+	return ret;
 }
 
 /*
@@ -476,7 +458,8 @@ int rxrpc_io_thread(void *data)
 			switch (skb->mark) {
 			case RXRPC_SKB_MARK_PACKET:
 				skb->priority = 0;
-				rxrpc_input_packet(local, &skb);
+				if (!rxrpc_input_packet(local, &skb))
+					rxrpc_reject_packet(local, skb);
 				trace_rxrpc_rx_done(skb->mark, skb->priority);
 				rxrpc_free_skb(skb, rxrpc_skb_put_input);
 				break;
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 56a31aebea38..b7178f2150c0 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -118,8 +118,9 @@ bool rxrpc_call_completed(struct rxrpc_call *call)
 /*
  * Record that a call is locally aborted.
  */
-bool __rxrpc_abort_call(const char *why, struct rxrpc_call *call,
-			rxrpc_seq_t seq, u32 abort_code, int error)
+bool __rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
+			u32 abort_code, int error,
+			enum rxrpc_abort_reason why)
 {
 	trace_rxrpc_abort(call->debug_id, why, call->cid, call->call_id, seq,
 			  abort_code, error);
@@ -127,13 +128,14 @@ bool __rxrpc_abort_call(const char *why, struct rxrpc_call *call,
 					   abort_code, error);
 }
 
-bool rxrpc_abort_call(const char *why, struct rxrpc_call *call,
-		      rxrpc_seq_t seq, u32 abort_code, int error)
+bool rxrpc_abort_call(struct rxrpc_call *call, rxrpc_seq_t seq,
+		      u32 abort_code, int error,
+		      enum rxrpc_abort_reason why)
 {
 	bool ret;
 
 	spin_lock(&call->state_lock);
-	ret = __rxrpc_abort_call(why, call, seq, abort_code, error);
+	ret = __rxrpc_abort_call(call, seq, abort_code, error, why);
 	spin_unlock(&call->state_lock);
 	if (ret)
 		rxrpc_send_abort_packet(call);
@@ -641,11 +643,15 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 	return ret;
 
 short_data:
-	trace_rxrpc_rx_eproto(call, 0, tracepoint_string("short_data"));
+	trace_rxrpc_abort(call->debug_id, rxrpc_recvmsg_short_data,
+			  call->cid, call->call_id, call->rx_consumed,
+			  0, -EBADMSG);
 	ret = -EBADMSG;
 	goto out;
 excess_data:
-	trace_rxrpc_rx_eproto(call, 0, tracepoint_string("excess_data"));
+	trace_rxrpc_abort(call->debug_id, rxrpc_recvmsg_excess_data,
+			  call->cid, call->call_id, call->rx_consumed,
+			  0, -EMSGSIZE);
 	ret = -EMSGSIZE;
 	goto out;
 call_complete:
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 5d2fbc6ec3cf..3dea0dc319a2 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -411,18 +411,15 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
-	bool aborted;
 	u32 data_size, buf;
 	u16 check;
 	int ret;
 
 	_enter("");
 
-	if (sp->len < 8) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_hdr", "V1H",
-					     RXKADSEALEDINCON);
-		goto protocol_error;
-	}
+	if (sp->len < 8)
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_1_short_header);
 
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
@@ -442,11 +439,9 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	skcipher_request_zero(req);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_len", "XV1",
-					     RXKADDATALEN);
-		goto protocol_error;
-	}
+	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
+		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
+					  rxkad_abort_1_short_encdata);
 	sp->offset += sizeof(sechdr);
 	sp->len    -= sizeof(sechdr);
 
@@ -456,26 +451,16 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	check = buf >> 16;
 	check ^= seq ^ call->call_id;
 	check &= 0xffff;
-	if (check != 0) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_check", "V1C",
-					     RXKADSEALEDINCON);
-		goto protocol_error;
-	}
-
-	if (data_size > sp->len) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_datalen", "V1L",
-					     RXKADDATALEN);
-		goto protocol_error;
-	}
+	if (check != 0)
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_1_short_check);
+	if (data_size > sp->len)
+		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
+					  rxkad_abort_1_short_data);
 	sp->len = data_size;
 
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
-
-protocol_error:
-	if (aborted)
-		rxrpc_send_abort_packet(call);
-	return -EPROTO;
 }
 
 /*
@@ -490,18 +475,15 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
 	struct scatterlist _sg[4], *sg;
-	bool aborted;
 	u32 data_size, buf;
 	u16 check;
 	int nsg, ret;
 
 	_enter(",{%d}", sp->len);
 
-	if (sp->len < 8) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_hdr", "V2H",
-					     RXKADSEALEDINCON);
-		goto protocol_error;
-	}
+	if (sp->len < 8)
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_2_short_header);
 
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
@@ -513,7 +495,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	} else {
 		sg = kmalloc_array(nsg, sizeof(*sg), GFP_NOIO);
 		if (!sg)
-			goto nomem;
+			return -ENOMEM;
 	}
 
 	sg_init_table(sg, nsg);
@@ -537,11 +519,9 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 		kfree(sg);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_len", "XV2",
-					     RXKADDATALEN);
-		goto protocol_error;
-	}
+	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0)
+		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
+					  rxkad_abort_2_short_len);
 	sp->offset += sizeof(sechdr);
 	sp->len    -= sizeof(sechdr);
 
@@ -551,30 +531,17 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	check = buf >> 16;
 	check ^= seq ^ call->call_id;
 	check &= 0xffff;
-	if (check != 0) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_check", "V2C",
-					     RXKADSEALEDINCON);
-		goto protocol_error;
-	}
+	if (check != 0)
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_2_short_check);
 
-	if (data_size > sp->len) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_datalen", "V2L",
-					     RXKADDATALEN);
-		goto protocol_error;
-	}
+	if (data_size > sp->len)
+		return rxrpc_abort_eproto(call, skb, RXKADDATALEN,
+					  rxkad_abort_2_short_data);
 
 	sp->len = data_size;
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
-
-protocol_error:
-	if (aborted)
-		rxrpc_send_abort_packet(call);
-	return -EPROTO;
-
-nomem:
-	_leave(" = -ENOMEM");
-	return -ENOMEM;
 }
 
 /*
@@ -590,7 +557,6 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 		__be32 buf[2];
 	} crypto __aligned(8);
 	rxrpc_seq_t seq = sp->hdr.seq;
-	bool aborted;
 	int ret;
 	u16 cksum;
 	u32 x, y;
@@ -627,9 +593,9 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 		cksum = 1; /* zero checksums are not permitted */
 
 	if (cksum != sp->hdr.cksum) {
-		aborted = rxrpc_abort_eproto(call, skb, "rxkad_csum", "VCK",
-					     RXKADSEALEDINCON);
-		goto protocol_error;
+		ret = rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					 rxkad_abort_bad_checksum);
+		goto out;
 	}
 
 	switch (call->conn->security_level) {
@@ -647,13 +613,9 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 		break;
 	}
 
+out:
 	skcipher_request_free(req);
 	return ret;
-
-protocol_error:
-	if (aborted)
-		rxrpc_send_abort_packet(call);
-	return -EPROTO;
 }
 
 /*
@@ -827,27 +789,24 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	struct rxkad_challenge challenge;
 	struct rxkad_response *resp;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	const char *eproto;
-	u32 version, nonce, min_level, abort_code;
-	int ret;
+	u32 version, nonce, min_level;
+	int ret = -EPROTO;
 
 	_enter("{%d,%x}", conn->debug_id, key_serial(conn->key));
 
-	eproto = tracepoint_string("chall_no_key");
-	abort_code = RX_PROTOCOL_ERROR;
 	if (!conn->key)
-		goto protocol_error;
+		return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO,
+					rxkad_abort_chall_no_key);
 
-	abort_code = RXKADEXPIRED;
 	ret = key_validate(conn->key);
 	if (ret < 0)
-		goto other_error;
+		return rxrpc_abort_conn(conn, skb, RXKADEXPIRED, ret,
+					rxkad_abort_chall_key_expired);
 
-	eproto = tracepoint_string("chall_short");
-	abort_code = RXKADPACKETSHORT;
 	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
 			  &challenge, sizeof(challenge)) < 0)
-		goto protocol_error;
+		return rxrpc_abort_conn(conn, skb, RXKADPACKETSHORT, -EPROTO,
+					rxkad_abort_chall_short);
 
 	version = ntohl(challenge.version);
 	nonce = ntohl(challenge.nonce);
@@ -855,15 +814,13 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 
 	trace_rxrpc_rx_challenge(conn, sp->hdr.serial, version, nonce, min_level);
 
-	eproto = tracepoint_string("chall_ver");
-	abort_code = RXKADINCONSISTENCY;
 	if (version != RXKAD_VERSION)
-		goto protocol_error;
+		return rxrpc_abort_conn(conn, skb, RXKADINCONSISTENCY, -EPROTO,
+					rxkad_abort_chall_version);
 
-	abort_code = RXKADLEVELFAIL;
-	ret = -EACCES;
 	if (conn->security_level < min_level)
-		goto other_error;
+		return rxrpc_abort_conn(conn, skb, RXKADLEVELFAIL, -EACCES,
+					rxkad_abort_chall_level);
 
 	token = conn->key->payload.data[0];
 
@@ -892,13 +849,6 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 		ret = rxkad_send_response(conn, &sp->hdr, resp, token->kad);
 	kfree(resp);
 	return ret;
-
-protocol_error:
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
-	ret = -EPROTO;
-other_error:
-	rxrpc_abort_conn(conn, skb, abort_code, ret, "RXK");
-	return ret;
 }
 
 /*
@@ -912,16 +862,12 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 				time64_t *_expiry)
 {
 	struct skcipher_request *req;
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv, key;
 	struct scatterlist sg[1];
 	struct in_addr addr;
 	unsigned int life;
-	const char *eproto;
 	time64_t issue, now;
 	bool little_endian;
-	int ret;
-	u32 abort_code;
 	u8 *p, *q, *name, *end;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(server_key));
@@ -933,10 +879,9 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 
 	memcpy(&iv, &server_key->payload.data[2], sizeof(iv));
 
-	ret = -ENOMEM;
 	req = skcipher_request_alloc(server_key->payload.data[0], GFP_NOFS);
 	if (!req)
-		goto temporary_error;
+		return -ENOMEM;
 
 	sg_init_one(&sg[0], ticket, ticket_len);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
@@ -947,18 +892,21 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 	p = ticket;
 	end = p + ticket_len;
 
-#define Z(field)					\
-	({						\
-		u8 *__str = p;				\
-		eproto = tracepoint_string("rxkad_bad_"#field); \
-		q = memchr(p, 0, end - p);		\
-		if (!q || q - p > (field##_SZ))		\
-			goto bad_ticket;		\
-		for (; p < q; p++)			\
-			if (!isprint(*p))		\
-				goto bad_ticket;	\
-		p++;					\
-		__str;					\
+#define Z(field, fieldl)						\
+	({								\
+		u8 *__str = p;						\
+		q = memchr(p, 0, end - p);				\
+		if (!q || q - p > (field##_SZ))				\
+			return rxrpc_abort_conn(			\
+				conn, skb, RXKADBADTICKET, -EPROTO,	\
+				rxkad_abort_resp_tkt_##fieldl);		\
+		for (; p < q; p++)					\
+			if (!isprint(*p))				\
+				return rxrpc_abort_conn(		\
+					conn, skb, RXKADBADTICKET, -EPROTO, \
+					rxkad_abort_resp_tkt_##fieldl);	\
+		p++;							\
+		__str;							\
 	})
 
 	/* extract the ticket flags */
@@ -967,20 +915,20 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 	p++;
 
 	/* extract the authentication name */
-	name = Z(ANAME);
+	name = Z(ANAME, aname);
 	_debug("KIV ANAME: %s", name);
 
 	/* extract the principal's instance */
-	name = Z(INST);
+	name = Z(INST, inst);
 	_debug("KIV INST : %s", name);
 
 	/* extract the principal's authentication domain */
-	name = Z(REALM);
+	name = Z(REALM, realm);
 	_debug("KIV REALM: %s", name);
 
-	eproto = tracepoint_string("rxkad_bad_len");
 	if (end - p < 4 + 8 + 4 + 2)
-		goto bad_ticket;
+		return rxrpc_abort_conn(conn, skb, RXKADBADTICKET, -EPROTO,
+					rxkad_abort_resp_tkt_short);
 
 	/* get the IPv4 address of the entity that requested the ticket */
 	memcpy(&addr, p, sizeof(addr));
@@ -1012,37 +960,23 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 	_debug("KIV ISSUE: %llx [%llx]", issue, now);
 
 	/* check the ticket is in date */
-	if (issue > now) {
-		abort_code = RXKADNOAUTH;
-		ret = -EKEYREJECTED;
-		goto other_error;
-	}
-
-	if (issue < now - life) {
-		abort_code = RXKADEXPIRED;
-		ret = -EKEYEXPIRED;
-		goto other_error;
-	}
+	if (issue > now)
+		return rxrpc_abort_conn(conn, skb, RXKADNOAUTH, -EKEYREJECTED,
+					rxkad_abort_resp_tkt_future);
+	if (issue < now - life)
+		return rxrpc_abort_conn(conn, skb, RXKADEXPIRED, -EKEYEXPIRED,
+					rxkad_abort_resp_tkt_expired);
 
 	*_expiry = issue + life;
 
 	/* get the service name */
-	name = Z(SNAME);
+	name = Z(SNAME, sname);
 	_debug("KIV SNAME: %s", name);
 
 	/* get the service instance name */
-	name = Z(INST);
+	name = Z(INST, sinst);
 	_debug("KIV SINST: %s", name);
 	return 0;
-
-bad_ticket:
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
-	abort_code = RXKADBADTICKET;
-	ret = -EPROTO;
-other_error:
-	return rxrpc_abort_conn(conn, skb, abort_code, ret, "RXK");
-temporary_error:
-	return ret;
 }
 
 /*
@@ -1089,10 +1023,9 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt session_key;
 	struct key *server_key;
-	const char *eproto;
 	time64_t expiry;
 	void *ticket;
-	u32 abort_code, version, kvno, ticket_len, level;
+	u32 version, kvno, ticket_len, level;
 	__be32 csum;
 	int ret, i;
 
@@ -1100,19 +1033,18 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	server_key = rxrpc_look_up_server_security(conn, skb, 0, 0);
 	if (IS_ERR(server_key)) {
-		switch (PTR_ERR(server_key)) {
+		ret = PTR_ERR(server_key);
+		switch (ret) {
 		case -ENOKEY:
-			abort_code = RXKADUNKNOWNKEY;
-			break;
+			return rxrpc_abort_conn(conn, skb, RXKADUNKNOWNKEY, ret,
+						rxkad_abort_resp_nokey);
 		case -EKEYEXPIRED:
-			abort_code = RXKADEXPIRED;
-			break;
+			return rxrpc_abort_conn(conn, skb, RXKADEXPIRED, ret,
+						rxkad_abort_resp_key_expired);
 		default:
-			abort_code = RXKADNOAUTH;
-			break;
+			return rxrpc_abort_conn(conn, skb, RXKADNOAUTH, ret,
+						rxkad_abort_resp_key_rejected);
 		}
-		return rxrpc_abort_conn(conn, skb, abort_code,
-					PTR_ERR(server_key), "RXK");
 	}
 
 	ret = -ENOMEM;
@@ -1120,11 +1052,12 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	if (!response)
 		goto temporary_error;
 
-	eproto = tracepoint_string("rxkad_rsp_short");
-	abort_code = RXKADPACKETSHORT;
 	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
-			  response, sizeof(*response)) < 0)
+			  response, sizeof(*response)) < 0) {
+		rxrpc_abort_conn(conn, skb, RXKADPACKETSHORT, -EPROTO,
+				 rxkad_abort_resp_short);
 		goto protocol_error;
+	}
 
 	version = ntohl(response->version);
 	ticket_len = ntohl(response->ticket_len);
@@ -1132,20 +1065,23 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	trace_rxrpc_rx_response(conn, sp->hdr.serial, version, kvno, ticket_len);
 
-	eproto = tracepoint_string("rxkad_rsp_ver");
-	abort_code = RXKADINCONSISTENCY;
-	if (version != RXKAD_VERSION)
+	if (version != RXKAD_VERSION) {
+		rxrpc_abort_conn(conn, skb, RXKADINCONSISTENCY, -EPROTO,
+				 rxkad_abort_resp_version);
 		goto protocol_error;
+	}
 
-	eproto = tracepoint_string("rxkad_rsp_tktlen");
-	abort_code = RXKADTICKETLEN;
-	if (ticket_len < 4 || ticket_len > MAXKRB5TICKETLEN)
+	if (ticket_len < 4 || ticket_len > MAXKRB5TICKETLEN) {
+		rxrpc_abort_conn(conn, skb, RXKADTICKETLEN, -EPROTO,
+				 rxkad_abort_resp_tkt_len);
 		goto protocol_error;
+	}
 
-	eproto = tracepoint_string("rxkad_rsp_unkkey");
-	abort_code = RXKADUNKNOWNKEY;
-	if (kvno >= RXKAD_TKT_TYPE_KERBEROS_V5)
+	if (kvno >= RXKAD_TKT_TYPE_KERBEROS_V5) {
+		rxrpc_abort_conn(conn, skb, RXKADUNKNOWNKEY, -EPROTO,
+				 rxkad_abort_resp_unknown_tkt);
 		goto protocol_error;
+	}
 
 	/* extract the kerberos ticket and decrypt and decode it */
 	ret = -ENOMEM;
@@ -1153,12 +1089,12 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	if (!ticket)
 		goto temporary_error_free_resp;
 
-	eproto = tracepoint_string("rxkad_tkt_short");
-	abort_code = RXKADPACKETSHORT;
-	ret = skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
-			    ticket, ticket_len);
-	if (ret < 0)
-		goto temporary_error_free_ticket;
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
+			  ticket, ticket_len) < 0) {
+		rxrpc_abort_conn(conn, skb, RXKADPACKETSHORT, -EPROTO,
+				 rxkad_abort_resp_short_tkt);
+		goto protocol_error;
+	}
 
 	ret = rxkad_decrypt_ticket(conn, server_key, skb, ticket, ticket_len,
 				   &session_key, &expiry);
@@ -1169,56 +1105,66 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	 * response */
 	rxkad_decrypt_response(conn, response, &session_key);
 
-	eproto = tracepoint_string("rxkad_rsp_param");
-	abort_code = RXKADSEALEDINCON;
-	if (ntohl(response->encrypted.epoch) != conn->proto.epoch)
-		goto protocol_error_free;
-	if (ntohl(response->encrypted.cid) != conn->proto.cid)
-		goto protocol_error_free;
-	if (ntohl(response->encrypted.securityIndex) != conn->security_ix)
+	if (ntohl(response->encrypted.epoch) != conn->proto.epoch ||
+	    ntohl(response->encrypted.cid) != conn->proto.cid ||
+	    ntohl(response->encrypted.securityIndex) != conn->security_ix) {
+		rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
+				 rxkad_abort_resp_bad_param);
 		goto protocol_error_free;
+	}
+
 	csum = response->encrypted.checksum;
 	response->encrypted.checksum = 0;
 	rxkad_calc_response_checksum(response);
-	eproto = tracepoint_string("rxkad_rsp_csum");
-	if (response->encrypted.checksum != csum)
+	if (response->encrypted.checksum != csum) {
+		rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
+				 rxkad_abort_resp_bad_checksum);
 		goto protocol_error_free;
+	}
 
 	spin_lock(&conn->bundle->channel_lock);
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
 		struct rxrpc_call *call;
 		u32 call_id = ntohl(response->encrypted.call_id[i]);
 
-		eproto = tracepoint_string("rxkad_rsp_callid");
-		if (call_id > INT_MAX)
+		if (call_id > INT_MAX) {
+			rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
+					 rxkad_abort_resp_bad_callid);
 			goto protocol_error_unlock;
+		}
 
-		eproto = tracepoint_string("rxkad_rsp_callctr");
-		if (call_id < conn->channels[i].call_counter)
+		if (call_id < conn->channels[i].call_counter) {
+			rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
+					 rxkad_abort_resp_call_ctr);
 			goto protocol_error_unlock;
+		}
 
-		eproto = tracepoint_string("rxkad_rsp_callst");
 		if (call_id > conn->channels[i].call_counter) {
 			call = rcu_dereference_protected(
 				conn->channels[i].call,
 				lockdep_is_held(&conn->bundle->channel_lock));
-			if (call && call->state < RXRPC_CALL_COMPLETE)
+			if (call && call->state < RXRPC_CALL_COMPLETE) {
+				rxrpc_abort_conn(conn, skb, RXKADSEALEDINCON, -EPROTO,
+						 rxkad_abort_resp_call_state);
 				goto protocol_error_unlock;
+			}
 			conn->channels[i].call_counter = call_id;
 		}
 	}
 	spin_unlock(&conn->bundle->channel_lock);
 
-	eproto = tracepoint_string("rxkad_rsp_seq");
-	abort_code = RXKADOUTOFSEQUENCE;
-	if (ntohl(response->encrypted.inc_nonce) != conn->rxkad.nonce + 1)
+	if (ntohl(response->encrypted.inc_nonce) != conn->rxkad.nonce + 1) {
+		rxrpc_abort_conn(conn, skb, RXKADOUTOFSEQUENCE, -EPROTO,
+				 rxkad_abort_resp_ooseq);
 		goto protocol_error_free;
+	}
 
-	eproto = tracepoint_string("rxkad_rsp_level");
-	abort_code = RXKADLEVELFAIL;
 	level = ntohl(response->encrypted.level);
-	if (level > RXRPC_SECURITY_ENCRYPT)
+	if (level > RXRPC_SECURITY_ENCRYPT) {
+		rxrpc_abort_conn(conn, skb, RXKADLEVELFAIL, -EPROTO,
+				 rxkad_abort_resp_level);
 		goto protocol_error_free;
+	}
 	conn->security_level = level;
 
 	/* create a key to hold the security data and expiration time - after
@@ -1240,8 +1186,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 protocol_error:
 	kfree(response);
 	key_put(server_key);
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
-	return rxrpc_abort_conn(conn, skb, abort_code, -EPROTO, "RXK");
+	return -EPROTO;
 
 temporary_error_free_ticket:
 	kfree(ticket);
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 66f5eea291ff..7ddf96e54418 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -10,6 +10,8 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
+#define RXRPC_TRACE_ONLY_DEFINE_ENUMS
+#include <trace/events/rxrpc.h>
 
 MODULE_DESCRIPTION("rxperf test server (afs)");
 MODULE_AUTHOR("Red Hat, Inc.");
@@ -307,12 +309,14 @@ static void rxperf_deliver_to_call(struct work_struct *work)
 		case -EOPNOTSUPP:
 			abort_code = RXGEN_OPCODE;
 			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-						abort_code, ret, "GOP");
+						abort_code, ret,
+						rxperf_abort_op_not_supported);
 			goto call_complete;
 		case -ENOTSUPP:
 			abort_code = RX_USER_ABORT;
 			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-						abort_code, ret, "GUA");
+						abort_code, ret,
+						rxperf_abort_op_not_supported);
 			goto call_complete;
 		case -EIO:
 			pr_err("Call %u in bad state %u\n",
@@ -324,11 +328,13 @@ static void rxperf_deliver_to_call(struct work_struct *work)
 		case -ENOMEM:
 		case -EFAULT:
 			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-						RXGEN_SS_UNMARSHAL, ret, "GUM");
+						RXGEN_SS_UNMARSHAL, ret,
+						rxperf_abort_unmarshal_error);
 			goto call_complete;
 		default:
 			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-						RX_CALL_DEAD, ret, "GER");
+						RX_CALL_DEAD, ret,
+						rxperf_abort_general_error);
 			goto call_complete;
 		}
 	}
@@ -523,7 +529,8 @@ static int rxperf_process_call(struct rxperf_call *call)
 
 	if (n == -ENOMEM)
 		rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "GOM");
+					RXGEN_SS_MARSHAL, -ENOMEM,
+					rxperf_abort_oom);
 	return n;
 }
 
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index ab968f65a490..78af14694618 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -144,21 +144,15 @@ const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *rx,
 
 	sec = rxrpc_security_lookup(sp->hdr.securityIndex);
 	if (!sec) {
-		trace_rxrpc_abort(0, "SVS",
-				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-				  RX_INVALID_OPERATION, EKEYREJECTED);
-		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-		skb->priority = RX_INVALID_OPERATION;
+		rxrpc_direct_abort(skb, rxrpc_abort_unsupported_security,
+				   RX_INVALID_OPERATION, -EKEYREJECTED);
 		return NULL;
 	}
 
 	if (sp->hdr.securityIndex != RXRPC_SECURITY_NONE &&
 	    !rx->securities) {
-		trace_rxrpc_abort(0, "SVR",
-				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-				  RX_INVALID_OPERATION, EKEYREJECTED);
-		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-		skb->priority = sec->no_key_abort;
+		rxrpc_direct_abort(skb, rxrpc_abort_no_service_key,
+				   sec->no_key_abort, -EKEYREJECTED);
 		return NULL;
 	}
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index c8cb3b76633c..cb40ff74c202 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -20,14 +20,15 @@
 /*
  * Propose an abort to be made in the I/O thread.
  */
-bool rxrpc_propose_abort(struct rxrpc_call *call,
-			 u32 abort_code, int error, const char *why)
+bool rxrpc_propose_abort(struct rxrpc_call *call, s32 abort_code, int error,
+			 enum rxrpc_abort_reason why)
 {
-	_enter("{%d},%d,%d,%s", call->debug_id, abort_code, error, why);
+	_enter("{%d},%d,%d,%u", call->debug_id, abort_code, error, why);
 
 	if (!call->send_abort && call->state < RXRPC_CALL_COMPLETE) {
 		call->send_abort_why = why;
 		call->send_abort_err = error;
+		call->send_abort_seq = 0;
 		smp_store_release(&call->send_abort, abort_code);
 		rxrpc_poke_call(call, rxrpc_call_poke_abort);
 		return true;
@@ -679,7 +680,8 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		/* it's too late for this call */
 		ret = -ESHUTDOWN;
 	} else if (p.command == RXRPC_CMD_SEND_ABORT) {
-		rxrpc_propose_abort(call, p.abort_code, -ECONNABORTED, "CMD");
+		rxrpc_propose_abort(call, p.abort_code, -ECONNABORTED,
+				    rxrpc_abort_call_sendmsg);
 		ret = 0;
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
@@ -742,7 +744,9 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 		break;
 	default:
 		/* Request phase complete for this client call */
-		trace_rxrpc_rx_eproto(call, 0, tracepoint_string("late_send"));
+		trace_rxrpc_abort(call->debug_id, rxrpc_sendmsg_late_send,
+				  call->cid, call->call_id, call->rx_consumed,
+				  0, -EPROTO);
 		ret = -EPROTO;
 		break;
 	}
@@ -760,17 +764,17 @@ EXPORT_SYMBOL(rxrpc_kernel_send_data);
  * @call: The call to be aborted
  * @abort_code: The abort code to stick into the ABORT packet
  * @error: Local error value
- * @why: 3-char string indicating why.
+ * @why: Indication as to why.
  *
  * Allow a kernel service to abort a call, if it's still in an abortable state
  * and return true if the call was aborted, false if it was already complete.
  */
 bool rxrpc_kernel_abort_call(struct socket *sock, struct rxrpc_call *call,
-			     u32 abort_code, int error, const char *why)
+			     u32 abort_code, int error, enum rxrpc_abort_reason why)
 {
 	bool aborted;
 
-	_enter("{%d},%d,%d,%s", call->debug_id, abort_code, error, why);
+	_enter("{%d},%d,%d,%u", call->debug_id, abort_code, error, why);
 
 	mutex_lock(&call->user_mutex);
 	aborted = rxrpc_propose_abort(call, abort_code, error, why);


