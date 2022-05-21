Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0374452F9D3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354762AbiEUHqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354756AbiEUHpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C91E4939BD
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653119140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFGupm1C+ZWOkUQAo24Pibe+Ygnjs7S0HztvSqUR5qM=;
        b=Y9Py+Ts3VHvsceFLTavW9h+HKy16d1eTScZIhKzzDyIUMleOYjh85bK8cpiYfDX9ieTaU3
        NKrfwUmiUfDB8qC6W2Gt5+FzlCAN+osHnzIYURGOpezJVqeigVyATqfgjWp6MEM/Wzi+SY
        xAW3SK9jJ7WYCiO9/RTuolk6QgXQMiw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-cV1q0UUyP_iZcx66a_SiXw-1; Sat, 21 May 2022 03:45:37 -0400
X-MC-Unique: cV1q0UUyP_iZcx66a_SiXw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3D233C00089;
        Sat, 21 May 2022 07:45:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18D6A492C3B;
        Sat, 21 May 2022 07:45:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 4/7] rxrpc: Automatically generate trace tag enums
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 21 May 2022 08:45:35 +0100
Message-ID: <165311913543.245906.16036545813903070859.stgit@warthog.procyon.org.uk>
In-Reply-To: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
References: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Automatically generate trace tag enums from the symbol -> string mapping
tables rather than having the enums as well, thereby reducing duplicated
data.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |  261 +++++++-----------------------------------
 1 file changed, 42 insertions(+), 219 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index cdb28976641b..66915b872a44 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -13,215 +13,6 @@
 #include <linux/tracepoint.h>
 #include <linux/errqueue.h>
 
-/*
- * Define enums for tracing information.
- *
- * These should all be kept sorted, making it easier to match the string
- * mapping tables further on.
- */
-#ifndef __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY
-#define __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY
-
-enum rxrpc_skb_trace {
-	rxrpc_skb_cleaned,
-	rxrpc_skb_freed,
-	rxrpc_skb_got,
-	rxrpc_skb_lost,
-	rxrpc_skb_new,
-	rxrpc_skb_purged,
-	rxrpc_skb_received,
-	rxrpc_skb_rotated,
-	rxrpc_skb_seen,
-	rxrpc_skb_unshared,
-	rxrpc_skb_unshared_nomem,
-};
-
-enum rxrpc_local_trace {
-	rxrpc_local_got,
-	rxrpc_local_new,
-	rxrpc_local_processing,
-	rxrpc_local_put,
-	rxrpc_local_queued,
-};
-
-enum rxrpc_peer_trace {
-	rxrpc_peer_got,
-	rxrpc_peer_new,
-	rxrpc_peer_processing,
-	rxrpc_peer_put,
-};
-
-enum rxrpc_conn_trace {
-	rxrpc_conn_got,
-	rxrpc_conn_new_client,
-	rxrpc_conn_new_service,
-	rxrpc_conn_put_client,
-	rxrpc_conn_put_service,
-	rxrpc_conn_queued,
-	rxrpc_conn_reap_service,
-	rxrpc_conn_seen,
-};
-
-enum rxrpc_client_trace {
-	rxrpc_client_activate_chans,
-	rxrpc_client_alloc,
-	rxrpc_client_chan_activate,
-	rxrpc_client_chan_disconnect,
-	rxrpc_client_chan_pass,
-	rxrpc_client_chan_wait_failed,
-	rxrpc_client_cleanup,
-	rxrpc_client_discard,
-	rxrpc_client_duplicate,
-	rxrpc_client_exposed,
-	rxrpc_client_replace,
-	rxrpc_client_to_active,
-	rxrpc_client_to_idle,
-};
-
-enum rxrpc_call_trace {
-	rxrpc_call_connected,
-	rxrpc_call_error,
-	rxrpc_call_got,
-	rxrpc_call_got_kernel,
-	rxrpc_call_got_timer,
-	rxrpc_call_got_userid,
-	rxrpc_call_new_client,
-	rxrpc_call_new_service,
-	rxrpc_call_put,
-	rxrpc_call_put_kernel,
-	rxrpc_call_put_noqueue,
-	rxrpc_call_put_notimer,
-	rxrpc_call_put_timer,
-	rxrpc_call_put_userid,
-	rxrpc_call_queued,
-	rxrpc_call_queued_ref,
-	rxrpc_call_release,
-	rxrpc_call_seen,
-};
-
-enum rxrpc_transmit_trace {
-	rxrpc_transmit_await_reply,
-	rxrpc_transmit_end,
-	rxrpc_transmit_queue,
-	rxrpc_transmit_queue_last,
-	rxrpc_transmit_rotate,
-	rxrpc_transmit_rotate_last,
-	rxrpc_transmit_wait,
-};
-
-enum rxrpc_receive_trace {
-	rxrpc_receive_end,
-	rxrpc_receive_front,
-	rxrpc_receive_incoming,
-	rxrpc_receive_queue,
-	rxrpc_receive_queue_last,
-	rxrpc_receive_rotate,
-};
-
-enum rxrpc_recvmsg_trace {
-	rxrpc_recvmsg_cont,
-	rxrpc_recvmsg_data_return,
-	rxrpc_recvmsg_dequeue,
-	rxrpc_recvmsg_enter,
-	rxrpc_recvmsg_full,
-	rxrpc_recvmsg_hole,
-	rxrpc_recvmsg_next,
-	rxrpc_recvmsg_requeue,
-	rxrpc_recvmsg_return,
-	rxrpc_recvmsg_terminal,
-	rxrpc_recvmsg_to_be_accepted,
-	rxrpc_recvmsg_wait,
-};
-
-enum rxrpc_rtt_tx_trace {
-	rxrpc_rtt_tx_cancel,
-	rxrpc_rtt_tx_data,
-	rxrpc_rtt_tx_no_slot,
-	rxrpc_rtt_tx_ping,
-};
-
-enum rxrpc_rtt_rx_trace {
-	rxrpc_rtt_rx_cancel,
-	rxrpc_rtt_rx_lost,
-	rxrpc_rtt_rx_obsolete,
-	rxrpc_rtt_rx_ping_response,
-	rxrpc_rtt_rx_requested_ack,
-};
-
-enum rxrpc_timer_trace {
-	rxrpc_timer_begin,
-	rxrpc_timer_exp_ack,
-	rxrpc_timer_exp_hard,
-	rxrpc_timer_exp_idle,
-	rxrpc_timer_exp_keepalive,
-	rxrpc_timer_exp_lost_ack,
-	rxrpc_timer_exp_normal,
-	rxrpc_timer_exp_ping,
-	rxrpc_timer_exp_resend,
-	rxrpc_timer_expired,
-	rxrpc_timer_init_for_reply,
-	rxrpc_timer_init_for_send_reply,
-	rxrpc_timer_restart,
-	rxrpc_timer_set_for_ack,
-	rxrpc_timer_set_for_hard,
-	rxrpc_timer_set_for_idle,
-	rxrpc_timer_set_for_keepalive,
-	rxrpc_timer_set_for_lost_ack,
-	rxrpc_timer_set_for_normal,
-	rxrpc_timer_set_for_ping,
-	rxrpc_timer_set_for_resend,
-	rxrpc_timer_set_for_send,
-};
-
-enum rxrpc_propose_ack_trace {
-	rxrpc_propose_ack_client_tx_end,
-	rxrpc_propose_ack_input_data,
-	rxrpc_propose_ack_ping_for_check_life,
-	rxrpc_propose_ack_ping_for_keepalive,
-	rxrpc_propose_ack_ping_for_lost_ack,
-	rxrpc_propose_ack_ping_for_lost_reply,
-	rxrpc_propose_ack_ping_for_params,
-	rxrpc_propose_ack_processing_op,
-	rxrpc_propose_ack_respond_to_ack,
-	rxrpc_propose_ack_respond_to_ping,
-	rxrpc_propose_ack_retry_tx,
-	rxrpc_propose_ack_rotate_rx,
-	rxrpc_propose_ack_terminal_ack,
-};
-
-enum rxrpc_propose_ack_outcome {
-	rxrpc_propose_ack_subsume,
-	rxrpc_propose_ack_update,
-	rxrpc_propose_ack_use,
-};
-
-enum rxrpc_congest_change {
-	rxrpc_cong_begin_retransmission,
-	rxrpc_cong_cleared_nacks,
-	rxrpc_cong_new_low_nack,
-	rxrpc_cong_no_change,
-	rxrpc_cong_progress,
-	rxrpc_cong_retransmit_again,
-	rxrpc_cong_rtt_window_end,
-	rxrpc_cong_saw_nack,
-};
-
-enum rxrpc_tx_point {
-	rxrpc_tx_point_call_abort,
-	rxrpc_tx_point_call_ack,
-	rxrpc_tx_point_call_data_frag,
-	rxrpc_tx_point_call_data_nofrag,
-	rxrpc_tx_point_call_final_resend,
-	rxrpc_tx_point_conn_abort,
-	rxrpc_tx_point_rxkad_challenge,
-	rxrpc_tx_point_rxkad_response,
-	rxrpc_tx_point_reject,
-	rxrpc_tx_point_version_keepalive,
-	rxrpc_tx_point_version_reply,
-};
-
-#endif /* end __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY */
-
 /*
  * Declare tracing information enums and their string mappings for display.
  */
@@ -451,6 +242,36 @@ enum rxrpc_tx_point {
 	EM(rxrpc_tx_point_version_keepalive,	"VerKeepalive") \
 	E_(rxrpc_tx_point_version_reply,	"VerReply")
 
+/*
+ * Generate enums for tracing information.
+ */
+#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
+
+#undef EM
+#undef E_
+#define EM(a, b) a,
+#define E_(a, b) a
+
+enum rxrpc_call_trace		{ rxrpc_call_traces } __mode(byte);
+enum rxrpc_client_trace		{ rxrpc_client_traces } __mode(byte);
+enum rxrpc_congest_change	{ rxrpc_congest_changes } __mode(byte);
+enum rxrpc_conn_trace		{ rxrpc_conn_traces } __mode(byte);
+enum rxrpc_local_trace		{ rxrpc_local_traces } __mode(byte);
+enum rxrpc_peer_trace		{ rxrpc_peer_traces } __mode(byte);
+enum rxrpc_propose_ack_outcome	{ rxrpc_propose_ack_outcomes } __mode(byte);
+enum rxrpc_propose_ack_trace	{ rxrpc_propose_ack_traces } __mode(byte);
+enum rxrpc_receive_trace	{ rxrpc_receive_traces } __mode(byte);
+enum rxrpc_recvmsg_trace	{ rxrpc_recvmsg_traces } __mode(byte);
+enum rxrpc_rtt_rx_trace		{ rxrpc_rtt_rx_traces } __mode(byte);
+enum rxrpc_rtt_tx_trace		{ rxrpc_rtt_tx_traces } __mode(byte);
+enum rxrpc_skb_trace		{ rxrpc_skb_traces } __mode(byte);
+enum rxrpc_timer_trace		{ rxrpc_timer_traces } __mode(byte);
+enum rxrpc_transmit_trace	{ rxrpc_transmit_traces } __mode(byte);
+enum rxrpc_tx_point		{ rxrpc_tx_points } __mode(byte);
+
+#endif /* end __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY */
+
 /*
  * Export enum symbols via userspace.
  */
@@ -459,21 +280,21 @@ enum rxrpc_tx_point {
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
-rxrpc_skb_traces;
-rxrpc_local_traces;
-rxrpc_conn_traces;
-rxrpc_client_traces;
 rxrpc_call_traces;
-rxrpc_transmit_traces;
+rxrpc_client_traces;
+rxrpc_congest_changes;
+rxrpc_congest_modes;
+rxrpc_conn_traces;
+rxrpc_local_traces;
+rxrpc_propose_ack_outcomes;
+rxrpc_propose_ack_traces;
 rxrpc_receive_traces;
 rxrpc_recvmsg_traces;
-rxrpc_rtt_tx_traces;
 rxrpc_rtt_rx_traces;
+rxrpc_rtt_tx_traces;
+rxrpc_skb_traces;
 rxrpc_timer_traces;
-rxrpc_propose_ack_traces;
-rxrpc_propose_ack_outcomes;
-rxrpc_congest_modes;
-rxrpc_congest_changes;
+rxrpc_transmit_traces;
 rxrpc_tx_points;
 
 /*
@@ -1574,6 +1395,8 @@ TRACE_EVENT(rxrpc_rx_discard_ack,
 		      __entry->call_ackr_prev)
 	    );
 
+#undef EM
+#undef E_
 #endif /* _TRACE_RXRPC_H */
 
 /* This part must be outside protection */


