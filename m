Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DED116687
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 06:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfLIFp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 00:45:28 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39818 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfLIFp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 00:45:28 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so6533294pga.6;
        Sun, 08 Dec 2019 21:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z4JoiD9YRn7b34NMH+Wmx9NG7ROX84Nd1FFhusolL00=;
        b=Bpr1oCmLvbWiW5Ke85QOoxJeGvj4dcgj+SWmBbd/tP2JENbx8eMS1rmKUNdMyJG5FZ
         drr9SJ04k/4tpMuccCkXtst/CGUOL5Psu5fZQp4SjHsI9U+NCafUJzvZD/uK1Mvl6yQa
         KwmTKDQFCUOB5Gy/9M4EDL7T15pyBXZcx4O/168Y0aj+1fhR0gGjFL3aOSoN56dfcFO8
         gHkMc2mfzDpZHPllY/GKpwD/BWj+UYjo7tqV5rYVN4uKC+RqALi26krQuw5Aui3dFsKE
         q6MNpNZVxDXT76heRmSlxuY+rfEOOE59ZF7ifUDwzcKhxcfU9+JmHexiyi1X8Ok+duOW
         f0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z4JoiD9YRn7b34NMH+Wmx9NG7ROX84Nd1FFhusolL00=;
        b=qFANHkJKkJ/LDh1PiXVAdV4s0S0On98+YlSrWK1gsOen4UkkuhdKlCLC8TG3Fa2AkY
         4pUyioogaMkGaCovH2iKGKhWq9GaCOD2jyDt7gVsRZ3tONbG/xxK/OVUD8qUYgchXUXF
         7FEi+zywA6SYVIGl5vF8tyEAOCjmwrHuaiTrWEM5a2nkxSNpoFcwsrR2B+tb4GaqUE32
         0MLxABLQDxpEvkjYUX9henb2NzzgqpF0K/Bmb4aH6gWRmS+H+oKN6d2nesBH5VhJZSYE
         wDNjB8F71RlCF6Uu23q9umXmi8C4QHFxYkV390+dTE9ga20YoL5r5eK9SOQpnQIkYUMd
         e3iA==
X-Gm-Message-State: APjAAAU+2qchcLTwoefrml/R48FJ9Vux0G8rhD3HinLAzrAu+F99GFYq
        VCjDwEnrhJdX/uW5ky59EVsG84n9
X-Google-Smtp-Source: APXvYqxnggFuW0bGS5WUK0K6l8zAfBb3JT7/wJFh5VM5I+KfI06PbwOU2OGSbqJ8yavPLdYgh9/PgA==
X-Received: by 2002:a63:1b47:: with SMTP id b7mr16676843pgm.446.1575870326414;
        Sun, 08 Dec 2019 21:45:26 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f24sm10748466pjp.12.2019.12.08.21.45.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Dec 2019 21:45:25 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net] sctp: get netns from asoc and ep base
Date:   Mon,  9 Dec 2019 13:45:18 +0800
Message-Id: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
in asoc and ep base since they're created, and it will never change.
It's a better way to get netns from asoc and ep base, comparing to
calling sock_net().

This patch is to replace them.

v1->v2:
  - no change.

Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/associola.c         | 10 +++++-----
 net/sctp/chunk.c             |  2 +-
 net/sctp/endpointola.c       |  6 +++---
 net/sctp/input.c             |  5 ++---
 net/sctp/output.c            |  2 +-
 net/sctp/outqueue.c          |  6 +++---
 net/sctp/sm_make_chunk.c     |  7 +++----
 net/sctp/sm_sideeffect.c     | 16 ++++++----------
 net/sctp/sm_statefuns.c      |  2 +-
 net/sctp/socket.c            | 12 +++++-------
 net/sctp/stream.c            |  3 +--
 net/sctp/stream_interleave.c | 23 ++++++++++-------------
 net/sctp/transport.c         |  2 +-
 net/sctp/ulpqueue.c          | 15 +++++++--------
 14 files changed, 49 insertions(+), 62 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index bbd5004..437079a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -584,7 +584,6 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 					   const gfp_t gfp,
 					   const int peer_state)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	struct sctp_transport *peer;
 	struct sctp_sock *sp;
 	unsigned short port;
@@ -614,7 +613,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 		return peer;
 	}
 
-	peer = sctp_transport_new(net, addr, gfp);
+	peer = sctp_transport_new(asoc->base.net, addr, gfp);
 	if (!peer)
 		return NULL;
 
@@ -974,7 +973,7 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 	struct sctp_association *asoc =
 		container_of(work, struct sctp_association,
 			     base.inqueue.immediate);
-	struct net *net = sock_net(asoc->base.sk);
+	struct net *net = asoc->base.net;
 	union sctp_subtype subtype;
 	struct sctp_endpoint *ep;
 	struct sctp_chunk *chunk;
@@ -1442,7 +1441,8 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
 /* Should we send a SACK to update our peer? */
 static inline bool sctp_peer_needs_update(struct sctp_association *asoc)
 {
-	struct net *net = sock_net(asoc->base.sk);
+	struct net *net = asoc->base.net;
+
 	switch (asoc->state) {
 	case SCTP_STATE_ESTABLISHED:
 	case SCTP_STATE_SHUTDOWN_PENDING:
@@ -1576,7 +1576,7 @@ int sctp_assoc_set_bind_addr_from_ep(struct sctp_association *asoc,
 	if (asoc->peer.ipv6_address)
 		flags |= SCTP_ADDR6_PEERSUPP;
 
-	return sctp_bind_addr_copy(sock_net(asoc->base.sk),
+	return sctp_bind_addr_copy(asoc->base.net,
 				   &asoc->base.bind_addr,
 				   &asoc->ep->base.bind_addr,
 				   scope, gfp, flags);
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index cc3ce5d..ab6a997 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -225,7 +225,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	if (msg_len >= first_len) {
 		msg->can_delay = 0;
 		if (msg_len > first_len)
-			SCTP_INC_STATS(sock_net(asoc->base.sk),
+			SCTP_INC_STATS(asoc->base.net,
 				       SCTP_MIB_FRAGUSRMSGS);
 	} else {
 		/* Which may be the only one... */
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 3ccab74..48c9c2c 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -244,7 +244,7 @@ struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *ep,
 	struct sctp_endpoint *retval = NULL;
 
 	if ((htons(ep->base.bind_addr.port) == laddr->v4.sin_port) &&
-	    net_eq(sock_net(ep->base.sk), net)) {
+	    net_eq(ep->base.net, net)) {
 		if (sctp_bind_addr_match(&ep->base.bind_addr, laddr,
 					 sctp_sk(ep->base.sk)))
 			retval = ep;
@@ -292,8 +292,8 @@ bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
 				 const union sctp_addr *paddr)
 {
 	struct sctp_sockaddr_entry *addr;
+	struct net *net = ep->base.net;
 	struct sctp_bind_addr *bp;
-	struct net *net = sock_net(ep->base.sk);
 
 	bp = &ep->base.bind_addr;
 	/* This function is called with the socket lock held,
@@ -384,7 +384,7 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 		if (asoc && sctp_chunk_is_data(chunk))
 			asoc->peer.last_data_from = chunk->transport;
 		else {
-			SCTP_INC_STATS(sock_net(ep->base.sk), SCTP_MIB_INCTRLCHUNKS);
+			SCTP_INC_STATS(ep->base.net, SCTP_MIB_INCTRLCHUNKS);
 			if (asoc)
 				asoc->stats.ictrlchunks++;
 		}
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 4d2bcfc..efaaefc 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -937,7 +937,7 @@ int sctp_hash_transport(struct sctp_transport *t)
 	if (t->asoc->temp)
 		return 0;
 
-	arg.net   = sock_net(t->asoc->base.sk);
+	arg.net   = t->asoc->base.net;
 	arg.paddr = &t->ipaddr;
 	arg.lport = htons(t->asoc->base.bind_addr.port);
 
@@ -1004,12 +1004,11 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
 				const struct sctp_endpoint *ep,
 				const union sctp_addr *paddr)
 {
-	struct net *net = sock_net(ep->base.sk);
 	struct rhlist_head *tmp, *list;
 	struct sctp_transport *t;
 	struct sctp_hash_cmp_arg arg = {
 		.paddr = paddr,
-		.net   = net,
+		.net   = ep->base.net,
 		.lport = htons(ep->base.bind_addr.port),
 	};
 
diff --git a/net/sctp/output.c b/net/sctp/output.c
index dbda7e7..1441eaf 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -282,7 +282,7 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
 					sctp_chunk_free(sack);
 					goto out;
 				}
-				SCTP_INC_STATS(sock_net(asoc->base.sk),
+				SCTP_INC_STATS(asoc->base.net,
 					       SCTP_MIB_OUTCTRLCHUNKS);
 				asoc->stats.octrlchunks++;
 				asoc->peer.sack_needed = 0;
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 0dab62b..a031d11 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -279,7 +279,7 @@ void sctp_outq_free(struct sctp_outq *q)
 /* Put a new chunk in an sctp_outq.  */
 void sctp_outq_tail(struct sctp_outq *q, struct sctp_chunk *chunk, gfp_t gfp)
 {
-	struct net *net = sock_net(q->asoc->base.sk);
+	struct net *net = q->asoc->base.net;
 
 	pr_debug("%s: outq:%p, chunk:%p[%s]\n", __func__, q, chunk,
 		 chunk && chunk->chunk_hdr ?
@@ -533,7 +533,7 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
 		     enum sctp_retransmit_reason reason)
 {
-	struct net *net = sock_net(q->asoc->base.sk);
+	struct net *net = q->asoc->base.net;
 
 	switch (reason) {
 	case SCTP_RTXR_T3_RTX:
@@ -1884,6 +1884,6 @@ void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 ctsn)
 
 	if (ftsn_chunk) {
 		list_add_tail(&ftsn_chunk->list, &q->control_chunk_list);
-		SCTP_INC_STATS(sock_net(asoc->base.sk), SCTP_MIB_OUTCTRLCHUNKS);
+		SCTP_INC_STATS(asoc->base.net, SCTP_MIB_OUTCTRLCHUNKS);
 	}
 }
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 48d6395..09050c1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2307,7 +2307,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		      const union sctp_addr *peer_addr,
 		      struct sctp_init_chunk *peer_init, gfp_t gfp)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	struct sctp_transport *transport;
 	struct list_head *pos, *temp;
 	union sctp_params param;
@@ -2363,8 +2362,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	 * also give us an option to silently ignore the packet, which
 	 * is what we'll do here.
 	 */
-	if (!net->sctp.addip_noauth &&
-	     (asoc->peer.asconf_capable && !asoc->peer.auth_capable)) {
+	if (!asoc->base.net->sctp.addip_noauth &&
+	    (asoc->peer.asconf_capable && !asoc->peer.auth_capable)) {
 		asoc->peer.addip_disabled_mask |= (SCTP_PARAM_ADD_IP |
 						  SCTP_PARAM_DEL_IP |
 						  SCTP_PARAM_SET_PRIMARY);
@@ -2491,9 +2490,9 @@ static int sctp_process_param(struct sctp_association *asoc,
 			      const union sctp_addr *peer_addr,
 			      gfp_t gfp)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	struct sctp_endpoint *ep = asoc->ep;
 	union sctp_addr_param *addr_param;
+	struct net *net = asoc->base.net;
 	struct sctp_transport *t;
 	enum sctp_scope scope;
 	union sctp_addr addr;
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index acd737d..ce82699 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -516,8 +516,6 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 					 struct sctp_transport *transport,
 					 int is_hb)
 {
-	struct net *net = sock_net(asoc->base.sk);
-
 	/* The check for association's overall error counter exceeding the
 	 * threshold is done in the state function.
 	 */
@@ -544,10 +542,10 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 	 * is SCTP_ACTIVE, then mark this transport as Partially Failed,
 	 * see SCTP Quick Failover Draft, section 5.1
 	 */
-	if (net->sctp.pf_enable &&
-	   (transport->state == SCTP_ACTIVE) &&
-	   (transport->error_count < transport->pathmaxrxt) &&
-	   (transport->error_count > transport->pf_retrans)) {
+	if (asoc->base.net->sctp.pf_enable &&
+	    transport->state == SCTP_ACTIVE &&
+	    transport->error_count < transport->pathmaxrxt &&
+	    transport->error_count > transport->pf_retrans) {
 
 		sctp_assoc_control_transport(asoc, transport,
 					     SCTP_TRANSPORT_PF,
@@ -798,10 +796,8 @@ static int sctp_cmd_process_sack(struct sctp_cmd_seq *cmds,
 	int err = 0;
 
 	if (sctp_outq_sack(&asoc->outqueue, chunk)) {
-		struct net *net = sock_net(asoc->base.sk);
-
 		/* There are no more TSNs awaiting SACK.  */
-		err = sctp_do_sm(net, SCTP_EVENT_T_OTHER,
+		err = sctp_do_sm(asoc->base.net, SCTP_EVENT_T_OTHER,
 				 SCTP_ST_OTHER(SCTP_EVENT_NO_PENDING_TSN),
 				 asoc->state, asoc->ep, asoc, NULL,
 				 GFP_ATOMIC);
@@ -834,7 +830,7 @@ static void sctp_cmd_assoc_update(struct sctp_cmd_seq *cmds,
 				  struct sctp_association *asoc,
 				  struct sctp_association *new)
 {
-	struct net *net = sock_net(asoc->base.sk);
+	struct net *net = asoc->base.net;
 	struct sctp_chunk *abort;
 
 	if (!sctp_assoc_update(asoc, new))
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4ab8208..42558fa 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1320,7 +1320,7 @@ static int sctp_sf_check_restart_addrs(const struct sctp_association *new_asoc,
 				       struct sctp_chunk *init,
 				       struct sctp_cmd_seq *commands)
 {
-	struct net *net = sock_net(new_asoc->base.sk);
+	struct net *net = new_asoc->base.net;
 	struct sctp_transport *new_addr;
 	int ret = 1;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0b48595..1b56fc4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -436,8 +436,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 static int sctp_send_asconf(struct sctp_association *asoc,
 			    struct sctp_chunk *chunk)
 {
-	struct net 	*net = sock_net(asoc->base.sk);
-	int		retval = 0;
+	int retval = 0;
 
 	/* If there is an outstanding ASCONF chunk, queue it for later
 	 * transmission.
@@ -449,7 +448,7 @@ static int sctp_send_asconf(struct sctp_association *asoc,
 
 	/* Hold the chunk until an ASCONF_ACK is received. */
 	sctp_chunk_hold(chunk);
-	retval = sctp_primitive_ASCONF(net, asoc, chunk);
+	retval = sctp_primitive_ASCONF(asoc->base.net, asoc, chunk);
 	if (retval)
 		sctp_chunk_free(chunk);
 	else
@@ -2428,9 +2427,8 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 	int error;
 
 	if (params->spp_flags & SPP_HB_DEMAND && trans) {
-		struct net *net = sock_net(trans->asoc->base.sk);
-
-		error = sctp_primitive_REQUESTHEARTBEAT(net, trans->asoc, trans);
+		error = sctp_primitive_REQUESTHEARTBEAT(trans->asoc->base.net,
+							trans->asoc, trans);
 		if (error)
 			return error;
 	}
@@ -5364,7 +5362,7 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
 		if (!sctp_transport_hold(t))
 			continue;
 
-		if (net_eq(sock_net(t->asoc->base.sk), net) &&
+		if (net_eq(t->asoc->base.net, net) &&
 		    t->asoc->peer.primary_path == t)
 			break;
 
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index e83cdaa..df60b5e 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -218,10 +218,9 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
 static int sctp_send_reconf(struct sctp_association *asoc,
 			    struct sctp_chunk *chunk)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	int retval = 0;
 
-	retval = sctp_primitive_RECONF(net, asoc, chunk);
+	retval = sctp_primitive_RECONF(asoc->base.net, asoc, chunk);
 	if (retval)
 		sctp_chunk_free(chunk);
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 40c40be..6b13f73 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -241,9 +241,8 @@ static struct sctp_ulpevent *sctp_intl_retrieve_partial(
 	if (!first_frag)
 		return NULL;
 
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
-					     &ulpq->reasm, first_frag,
-					     last_frag);
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
+					     first_frag, last_frag);
 	if (retval) {
 		sin->fsn = next_fsn;
 		if (is_last) {
@@ -326,7 +325,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled(
 
 	pd_point = sctp_sk(asoc->base.sk)->pd_point;
 	if (pd_point && pd_point <= pd_len) {
-		retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+		retval = sctp_make_reassembled_event(asoc->base.net,
 						     &ulpq->reasm,
 						     pd_first, pd_last);
 		if (retval) {
@@ -337,8 +336,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled(
 	goto out;
 
 found:
-	retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
-					     &ulpq->reasm,
+	retval = sctp_make_reassembled_event(asoc->base.net, &ulpq->reasm,
 					     first_frag, pos);
 	if (retval)
 		retval->msg_flags |= MSG_EOR;
@@ -630,7 +628,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_partial_uo(
 	if (!first_frag)
 		return NULL;
 
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
 					     &ulpq->reasm_uo, first_frag,
 					     last_frag);
 	if (retval) {
@@ -716,7 +714,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled_uo(
 
 	pd_point = sctp_sk(asoc->base.sk)->pd_point;
 	if (pd_point && pd_point <= pd_len) {
-		retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+		retval = sctp_make_reassembled_event(asoc->base.net,
 						     &ulpq->reasm_uo,
 						     pd_first, pd_last);
 		if (retval) {
@@ -727,8 +725,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_reassembled_uo(
 	goto out;
 
 found:
-	retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
-					     &ulpq->reasm_uo,
+	retval = sctp_make_reassembled_event(asoc->base.net, &ulpq->reasm_uo,
 					     first_frag, pos);
 	if (retval)
 		retval->msg_flags |= MSG_EOR;
@@ -814,7 +811,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_first_uo(struct sctp_ulpq *ulpq)
 		return NULL;
 
 out:
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
 					     &ulpq->reasm_uo, first_frag,
 					     last_frag);
 	if (retval) {
@@ -921,7 +918,7 @@ static struct sctp_ulpevent *sctp_intl_retrieve_first(struct sctp_ulpq *ulpq)
 		return NULL;
 
 out:
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
 					     &ulpq->reasm, first_frag,
 					     last_frag);
 	if (retval) {
@@ -1159,7 +1156,7 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 	if (ftsn_chunk) {
 		list_add_tail(&ftsn_chunk->list, &q->control_chunk_list);
-		SCTP_INC_STATS(sock_net(asoc->base.sk), SCTP_MIB_OUTCTRLCHUNKS);
+		SCTP_INC_STATS(asoc->base.net, SCTP_MIB_OUTCTRLCHUNKS);
 	}
 }
 
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 7235a60..f4de064 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -334,7 +334,7 @@ void sctp_transport_update_rto(struct sctp_transport *tp, __u32 rtt)
 		pr_debug("%s: rto_pending not set on transport %p!\n", __func__, tp);
 
 	if (tp->rttvar || tp->srtt) {
-		struct net *net = sock_net(tp->asoc->base.sk);
+		struct net *net = tp->asoc->base.net;
 		/* 6.3.1 C3) When a new RTT measurement R' is made, set
 		 * RTTVAR <- (1 - RTO.Beta) * RTTVAR + RTO.Beta * |SRTT - R'|
 		 * SRTT <- (1 - RTO.Alpha) * SRTT + RTO.Alpha * R'
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index b6536b7..1c6c640 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -486,10 +486,9 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
 		cevent = sctp_skb2event(pd_first);
 		pd_point = sctp_sk(asoc->base.sk)->pd_point;
 		if (pd_point && pd_point <= pd_len) {
-			retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+			retval = sctp_make_reassembled_event(asoc->base.net,
 							     &ulpq->reasm,
-							     pd_first,
-							     pd_last);
+							     pd_first, pd_last);
 			if (retval)
 				sctp_ulpq_set_pd(ulpq);
 		}
@@ -497,7 +496,7 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
 done:
 	return retval;
 found:
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net,
 					     &ulpq->reasm, first_frag, pos);
 	if (retval)
 		retval->msg_flags |= MSG_EOR;
@@ -563,8 +562,8 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_partial(struct sctp_ulpq *ulpq)
 	 * further.
 	 */
 done:
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
-					&ulpq->reasm, first_frag, last_frag);
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
+					     first_frag, last_frag);
 	if (retval && is_last)
 		retval->msg_flags |= MSG_EOR;
 
@@ -664,8 +663,8 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 	 * further.
 	 */
 done:
-	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
-					&ulpq->reasm, first_frag, last_frag);
+	retval = sctp_make_reassembled_event(ulpq->asoc->base.net, &ulpq->reasm,
+					     first_frag, last_frag);
 	return retval;
 }
 
-- 
2.1.0

