Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5D11E2742
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgEZQk0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:40:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:58667 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388187AbgEZQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:40:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-127-S7539owyODaeACjEFTyM_g-1; Tue, 26 May 2020 17:40:15 +0100
X-MC-Unique: S7539owyODaeACjEFTyM_g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
Thread-Topic: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
Thread-Index: AdYze5zo5xQMv/KcR+CMEQN8gd6YZw==
Date:   Tue, 26 May 2020 16:40:14 +0000
Message-ID: <bab9a624ee2d4e05b1198c3f7344a200@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the #define foo (*foo) used to simplify the previous patch.
Doesn't change the generated code.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 687 ++++++++++++++++++++++++++----------------------------
 1 file changed, 331 insertions(+), 356 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 639d7da..b8068da 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2585,9 +2585,8 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 	return 0;
 }
 
-#define params (*params)
 static int sctp_setsockopt_peer_addr_params(struct sock *sk,
-					    struct sctp_paddrparams params,
+					    struct sctp_paddrparams *params,
 					    unsigned int optlen)
 {
 	struct sctp_transport   *trans = NULL;
@@ -2596,33 +2595,33 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	int error;
 	int hb_change, pmtud_change, sackdelay_change;
 
-	if (optlen != sizeof(params)) {
+	if (optlen != sizeof(*params)) {
 		if (optlen != ALIGN(offsetof(struct sctp_paddrparams,
 						    spp_ipv6_flowlabel), 4))
 			return -EINVAL;
-		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
+		if (params->spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
 			return -EINVAL;
 	}
 
 	/* Validate flags and value parameters. */
-	hb_change        = params.spp_flags & SPP_HB;
-	pmtud_change     = params.spp_flags & SPP_PMTUD;
-	sackdelay_change = params.spp_flags & SPP_SACKDELAY;
+	hb_change        = params->spp_flags & SPP_HB;
+	pmtud_change     = params->spp_flags & SPP_PMTUD;
+	sackdelay_change = params->spp_flags & SPP_SACKDELAY;
 
 	if (hb_change        == SPP_HB ||
 	    pmtud_change     == SPP_PMTUD ||
 	    sackdelay_change == SPP_SACKDELAY ||
-	    params.spp_sackdelay > 500 ||
-	    (params.spp_pathmtu &&
-	     params.spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
+	    params->spp_sackdelay > 500 ||
+	    (params->spp_pathmtu &&
+	     params->spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
 		return -EINVAL;
 
 	/* If an address other than INADDR_ANY is specified, and
 	 * no transport is found, then the request is invalid.
 	 */
-	if (!sctp_is_any(sk, (union sctp_addr *)&params.spp_address)) {
-		trans = sctp_addr_id2transport(sk, &params.spp_address,
-					       params.spp_assoc_id);
+	if (!sctp_is_any(sk, (union sctp_addr *)&params->spp_address)) {
+		trans = sctp_addr_id2transport(sk, &params->spp_address,
+					       params->spp_assoc_id);
 		if (!trans)
 			return -EINVAL;
 	}
@@ -2631,19 +2630,19 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->spp_assoc_id);
+	if (!asoc && params->spp_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Heartbeat demand can only be sent on a transport or
 	 * association, but not a socket.
 	 */
-	if (params.spp_flags & SPP_HB_DEMAND && !trans && !asoc)
+	if (params->spp_flags & SPP_HB_DEMAND && !trans && !asoc)
 		return -EINVAL;
 
 	/* Process parameters. */
-	error = sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+	error = sctp_apply_peer_addr_params(params, trans, asoc, sp,
 					    hb_change, pmtud_change,
 					    sackdelay_change);
 
@@ -2656,7 +2655,7 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	if (!trans && asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				transports) {
-			sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+			sctp_apply_peer_addr_params(params, trans, asoc, sp,
 						    hb_change, pmtud_change,
 						    sackdelay_change);
 		}
@@ -2664,7 +2663,6 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 
 	return 0;
 }
-#undef params
 
 static inline __u32 sctp_spp_sackdelay_enable(__u32 param_flags)
 {
@@ -2749,16 +2747,15 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  *    value to 1 will disable the delayed sack algorithm.
  */
 
-#define params (*params)
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       struct sctp_sack_info params,
+				       struct sctp_sack_info *params,
 				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
 	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (params.sack_delay == 0 && params.sack_freq == 0)
+		if (params->sack_delay == 0 && params->sack_freq == 0)
 			return 0;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -2766,56 +2763,56 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (params.sack_delay == 0)
-			params.sack_freq = 1;
+		if (params->sack_delay == 0)
+			params->sack_freq = 1;
 		else
-			params.sack_freq = 0;
+			params->sack_freq = 0;
 	} else
 		return -EINVAL;
 
 	/* Validate value parameter. */
-	if (params.sack_delay > 500)
+	if (params->sack_delay > 500)
 		return -EINVAL;
 
 	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->sack_assoc_id);
+	if (!asoc && params->sack_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		sctp_apply_asoc_delayed_ack(&params, asoc);
+		sctp_apply_asoc_delayed_ack(params, asoc);
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.sack_assoc_id = SCTP_FUTURE_ASSOC;
+		params->sack_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.sack_assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.sack_assoc_id == SCTP_ALL_ASSOC) {
-		if (params.sack_delay) {
-			sp->sackdelay = params.sack_delay;
+	if (params->sack_assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->sack_assoc_id == SCTP_ALL_ASSOC) {
+		if (params->sack_delay) {
+			sp->sackdelay = params->sack_delay;
 			sp->param_flags =
 				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
-		if (params.sack_freq == 1) {
+		if (params->sack_freq == 1) {
 			sp->param_flags =
 				sctp_spp_sackdelay_disable(sp->param_flags);
-		} else if (params.sack_freq > 1) {
-			sp->sackfreq = params.sack_freq;
+		} else if (params->sack_freq > 1) {
+			sp->sackfreq = params->sack_freq;
 			sp->param_flags =
 				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
 	}
 
-	if (params.sack_assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.sack_assoc_id == SCTP_ALL_ASSOC)
+	if (params->sack_assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->sack_assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			sctp_apply_asoc_delayed_ack(&params, asoc);
+			sctp_apply_asoc_delayed_ack(params, asoc);
 
 	return 0;
 }
@@ -2831,8 +2828,7 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-#define sinit (*sinit)
-static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg sinit,
+static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2840,18 +2836,17 @@ static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg sinit,
 	if (optlen != sizeof(struct sctp_initmsg))
 		return -EINVAL;
 
-	if (sinit.sinit_num_ostreams)
-		sp->initmsg.sinit_num_ostreams = sinit.sinit_num_ostreams;
-	if (sinit.sinit_max_instreams)
-		sp->initmsg.sinit_max_instreams = sinit.sinit_max_instreams;
-	if (sinit.sinit_max_attempts)
-		sp->initmsg.sinit_max_attempts = sinit.sinit_max_attempts;
-	if (sinit.sinit_max_init_timeo)
-		sp->initmsg.sinit_max_init_timeo = sinit.sinit_max_init_timeo;
+	if (sinit->sinit_num_ostreams)
+		sp->initmsg.sinit_num_ostreams = sinit->sinit_num_ostreams;
+	if (sinit->sinit_max_instreams)
+		sp->initmsg.sinit_max_instreams = sinit->sinit_max_instreams;
+	if (sinit->sinit_max_attempts)
+		sp->initmsg.sinit_max_attempts = sinit->sinit_max_attempts;
+	if (sinit->sinit_max_init_timeo)
+		sp->initmsg.sinit_max_init_timeo = sinit->sinit_max_init_timeo;
 
 	return 0;
 }
-#undef sinit
 
 /*
  * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
@@ -2867,56 +2862,55 @@ static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg sinit,
  *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
  *   to this call if the caller is using the UDP model.
  */
-#define info (*info)
 static int sctp_setsockopt_default_send_param(struct sock *sk,
-					      struct sctp_sndrcvinfo info,
+					      struct sctp_sndrcvinfo *info,
 					      unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		return -EINVAL;
-	if (info.sinfo_flags &
+	if (info->sinfo_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->sinfo_assoc_id);
+	if (!asoc && info->sinfo_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.sinfo_stream;
-		asoc->default_flags = info.sinfo_flags;
-		asoc->default_ppid = info.sinfo_ppid;
-		asoc->default_context = info.sinfo_context;
-		asoc->default_timetolive = info.sinfo_timetolive;
+		asoc->default_stream = info->sinfo_stream;
+		asoc->default_flags = info->sinfo_flags;
+		asoc->default_ppid = info->sinfo_ppid;
+		asoc->default_context = info->sinfo_context;
+		asoc->default_timetolive = info->sinfo_timetolive;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.sinfo_assoc_id = SCTP_FUTURE_ASSOC;
+		info->sinfo_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.sinfo_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.sinfo_assoc_id == SCTP_ALL_ASSOC) {
-		sp->default_stream = info.sinfo_stream;
-		sp->default_flags = info.sinfo_flags;
-		sp->default_ppid = info.sinfo_ppid;
-		sp->default_context = info.sinfo_context;
-		sp->default_timetolive = info.sinfo_timetolive;
+	if (info->sinfo_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->sinfo_assoc_id == SCTP_ALL_ASSOC) {
+		sp->default_stream = info->sinfo_stream;
+		sp->default_flags = info->sinfo_flags;
+		sp->default_ppid = info->sinfo_ppid;
+		sp->default_context = info->sinfo_context;
+		sp->default_timetolive = info->sinfo_timetolive;
 	}
 
-	if (info.sinfo_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.sinfo_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->sinfo_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->sinfo_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.sinfo_stream;
-			asoc->default_flags = info.sinfo_flags;
-			asoc->default_ppid = info.sinfo_ppid;
-			asoc->default_context = info.sinfo_context;
-			asoc->default_timetolive = info.sinfo_timetolive;
+			asoc->default_stream = info->sinfo_stream;
+			asoc->default_flags = info->sinfo_flags;
+			asoc->default_ppid = info->sinfo_ppid;
+			asoc->default_context = info->sinfo_context;
+			asoc->default_timetolive = info->sinfo_timetolive;
 		}
 	}
 
@@ -2927,51 +2921,51 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_setsockopt_default_sndinfo(struct sock *sk,
-					   struct sctp_sndinfo info,
+					   struct sctp_sndinfo *info,
 					   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		return -EINVAL;
-	if (info.snd_flags &
+	if (info->snd_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->snd_assoc_id);
+	if (!asoc && info->snd_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_stream = info.snd_sid;
-		asoc->default_flags = info.snd_flags;
-		asoc->default_ppid = info.snd_ppid;
-		asoc->default_context = info.snd_context;
+		asoc->default_stream = info->snd_sid;
+		asoc->default_flags = info->snd_flags;
+		asoc->default_ppid = info->snd_ppid;
+		asoc->default_context = info->snd_context;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.snd_assoc_id = SCTP_FUTURE_ASSOC;
+		info->snd_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.snd_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.snd_assoc_id == SCTP_ALL_ASSOC) {
-		sp->default_stream = info.snd_sid;
-		sp->default_flags = info.snd_flags;
-		sp->default_ppid = info.snd_ppid;
-		sp->default_context = info.snd_context;
+	if (info->snd_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->snd_assoc_id == SCTP_ALL_ASSOC) {
+		sp->default_stream = info->snd_sid;
+		sp->default_flags = info->snd_flags;
+		sp->default_ppid = info->snd_ppid;
+		sp->default_context = info->snd_context;
 	}
 
-	if (info.snd_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.snd_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->snd_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->snd_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			asoc->default_stream = info.snd_sid;
-			asoc->default_flags = info.snd_flags;
-			asoc->default_ppid = info.snd_ppid;
-			asoc->default_context = info.snd_context;
+			asoc->default_stream = info->snd_sid;
+			asoc->default_flags = info->snd_flags;
+			asoc->default_ppid = info->snd_ppid;
+			asoc->default_context = info->snd_context;
 		}
 	}
 
@@ -2984,8 +2978,7 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-#define prim (*prim)
-static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim prim,
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
 					unsigned int optlen)
 {
 	struct sctp_transport *trans;
@@ -2996,17 +2989,17 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim prim,
 		return -EINVAL;
 
 	/* Allow security module to validate address but need address len. */
-	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	af = sctp_get_af_specific(prim->ssp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
 	err = security_sctp_bind_connect(sk, SCTP_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.ssp_addr,
+					 (struct sockaddr *)&prim->ssp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
-	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
+	trans = sctp_addr_id2transport(sk, &prim->ssp_addr, prim->ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
 
@@ -3014,7 +3007,6 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim prim,
 
 	return 0;
 }
-#undef prim
 
 /*
  * 7.1.5 SCTP_NODELAY
@@ -3047,7 +3039,7 @@ static int sctp_setsockopt_nodelay(struct sock *sk, int *optval,
  *
  */
 static int sctp_setsockopt_rtoinfo(struct sock *sk,
-				   struct sctp_rtoinfo params,
+				   struct sctp_rtoinfo *params,
 				   unsigned int optlen)
 {
 	struct sctp_association *asoc;
@@ -3057,15 +3049,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, params->srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && params.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	rto_max = params.srto_max;
-	rto_min = params.srto_min;
+	rto_max = params->srto_max;
+	rto_min = params->srto_min;
 
 	if (rto_max)
 		rto_max = asoc ? msecs_to_jiffies(rto_max) : rto_max;
@@ -3081,17 +3073,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
 		return -EINVAL;
 
 	if (asoc) {
-		if (params.srto_initial != 0)
+		if (params->srto_initial != 0)
 			asoc->rto_initial =
-				msecs_to_jiffies(params.srto_initial);
+				msecs_to_jiffies(params->srto_initial);
 		asoc->rto_max = rto_max;
 		asoc->rto_min = rto_min;
 	} else {
 		/* If there is no association or the association-id = 0
 		 * set the values to the endpoint.
 		 */
-		if (params.srto_initial != 0)
-			sp->rtoinfo.srto_initial = params.srto_initial;
+		if (params->srto_initial != 0)
+			sp->rtoinfo.srto_initial = params->srto_initial;
 		sp->rtoinfo.srto_max = rto_max;
 		sp->rtoinfo.srto_min = rto_min;
 	}
@@ -3111,7 +3103,7 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
  *
  */
 static int sctp_setsockopt_associnfo(struct sock *sk,
-				     struct sctp_assocparams params,
+				     struct sctp_assocparams *params,
 				     unsigned int optlen)
 {
 
@@ -3120,15 +3112,15 @@ static int sctp_setsockopt_associnfo(struct sock *sk,
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sasoc_assoc_id);
 
-	if (!asoc && params.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (params.sasoc_asocmaxrxt != 0) {
+		if (params->sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3145,24 +3137,24 @@ static int sctp_setsockopt_associnfo(struct sock *sk,
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    params.sasoc_asocmaxrxt > path_sum)
+			    params->sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = params.sasoc_asocmaxrxt;
+			asoc->max_retrans = params->sasoc_asocmaxrxt;
 		}
 
-		if (params.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(params.sasoc_cookie_life);
+		if (params->sasoc_cookie_life != 0)
+			asoc->cookie_life = ms_to_ktime(params->sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (params.sasoc_asocmaxrxt != 0)
+		if (params->sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt =
-						params.sasoc_asocmaxrxt;
-		if (params.sasoc_cookie_life != 0)
+						params->sasoc_asocmaxrxt;
+		if (params->sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life =
-						params.sasoc_cookie_life;
+						params->sasoc_cookie_life;
 	}
 	return 0;
 }
@@ -3220,7 +3212,7 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, int *optval,
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
 static int sctp_setsockopt_maxseg(struct sock *sk,
-				  struct sctp_assoc_value params,
+				  struct sctp_assoc_value *params,
 				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3233,16 +3225,16 @@ static int sctp_setsockopt_maxseg(struct sock *sk,
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		val = *(int *)&params;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		val = *(int *)params;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (optlen != sizeof(struct sctp_assoc_value)) {
-		val = params.assoc_value;
+		val = params->assoc_value;
 	} else {
 		return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
@@ -3277,9 +3269,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk,
  *   locally bound addresses. The following structure is used to make a
  *   set primary request:
  */
-#define prim (*prim)
 static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
-					     struct sctp_setpeerprim prim,
+					     struct sctp_setpeerprim *prim,
 					     unsigned int optlen)
 {
 	struct sctp_sock	*sp;
@@ -3296,7 +3287,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -3309,26 +3300,26 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
 	if (!sctp_state(asoc, ESTABLISHED))
 		return -ENOTCONN;
 
-	af = sctp_get_af_specific(prim.sspp_addr.ss_family);
+	af = sctp_get_af_specific(prim->sspp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
-	if (!af->addr_valid((union sctp_addr *)&prim.sspp_addr, sp, NULL))
+	if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL))
 		return -EADDRNOTAVAIL;
 
-	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
+	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim->sspp_addr))
 		return -EADDRNOTAVAIL;
 
 	/* Allow security module to validate address. */
 	err = security_sctp_bind_connect(sk, SCTP_SET_PEER_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.sspp_addr,
+					 (struct sockaddr *)&prim->sspp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
 	/* Create an ASCONF chunk with SET_PRIMARY parameter	*/
 	chunk = sctp_make_asconf_set_prim(asoc,
-					  (union sctp_addr *)&prim.sspp_addr);
+					  (union sctp_addr *)&prim->sspp_addr);
 	if (!chunk)
 		return -ENOMEM;
 
@@ -3338,7 +3329,6 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
 
 	return err;
 }
-#undef prim
 
 static int sctp_setsockopt_adaptation_layer(struct sock *sk,
 					    struct sctp_setadaptation *adaptation,
@@ -3367,7 +3357,7 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk,
  * saved with outbound messages.
  */
 static int sctp_setsockopt_context(struct sock *sk,
-				   struct sctp_assoc_value params,
+				   struct sctp_assoc_value *params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3376,28 +3366,28 @@ static int sctp_setsockopt_context(struct sock *sk,
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_rcv_context = params.assoc_value;
+		asoc->default_rcv_context = params->assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_rcv_context = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_rcv_context = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->default_rcv_context = params.assoc_value;
+			asoc->default_rcv_context = params->assoc_value;
 
 	return 0;
 }
@@ -3488,7 +3478,7 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
  * future associations inheriting the socket value.
  */
 static int sctp_setsockopt_maxburst(struct sock *sk,
-				    struct sctp_assoc_value params,
+				    struct sctp_assoc_value *params,
 				    unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3500,34 +3490,34 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_value = *(int *)&params;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_value = *(int *)params;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (optlen != sizeof(struct sctp_assoc_value)) {
 		return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->max_burst = params.assoc_value;
+		asoc->max_burst = params->assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->max_burst = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->max_burst = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->max_burst = params.assoc_value;
+			asoc->max_burst = params->assoc_value;
 
 	return 0;
 }
@@ -3539,9 +3529,8 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
  * received only in an authenticated way.  Changes to the list of chunks
  * will only effect future associations on the socket.
  */
-#define val (*val)
 static int sctp_setsockopt_auth_chunk(struct sock *sk,
-				      struct sctp_authchunk val,
+				      struct sctp_authchunk *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
@@ -3552,7 +3541,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	if (optlen != sizeof(struct sctp_authchunk))
 		return -EINVAL;
 
-	switch (val.sauth_chunk) {
+	switch (val->sauth_chunk) {
 	case SCTP_CID_INIT:
 	case SCTP_CID_INIT_ACK:
 	case SCTP_CID_SHUTDOWN_COMPLETE:
@@ -3561,7 +3550,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	}
 
 	/* add this chunk id to the endpoint */
-	return sctp_auth_ep_add_chunkid(ep, val.sauth_chunk);
+	return sctp_auth_ep_add_chunkid(ep, val->sauth_chunk);
 }
 
 /*
@@ -3666,7 +3655,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
  * the association shared key.
  */
 static int sctp_setsockopt_active_key(struct sock *sk,
-				      struct sctp_authkeyid val,
+				      struct sctp_authkeyid *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
@@ -3676,29 +3665,29 @@ static int sctp_setsockopt_active_key(struct sock *sk,
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+		return sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_set_active_key(ep, asoc,
-							   val.scact_keynumber);
+							   val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -3714,7 +3703,7 @@ static int sctp_setsockopt_active_key(struct sock *sk,
  * This set option will delete a shared secret key from use.
  */
 static int sctp_setsockopt_del_key(struct sock *sk,
-				   struct sctp_authkeyid val,
+				   struct sctp_authkeyid *val,
 				   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
@@ -3724,29 +3713,29 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+		return sctp_auth_del_key_id(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_del_key_id(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_del_key_id(ep, asoc,
-						       val.scact_keynumber);
+						       val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -3762,7 +3751,7 @@ static int sctp_setsockopt_del_key(struct sock *sk,
  * This set option will deactivate a shared secret key.
  */
 static int sctp_setsockopt_deactivate_key(struct sock *sk,
-					  struct sctp_authkeyid val,
+					  struct sctp_authkeyid *val,
 					  unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
@@ -3772,29 +3761,29 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_deact_key_id(ep, asoc, val.scact_keynumber);
+		return sctp_auth_deact_key_id(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id == SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
-		ret = sctp_auth_deact_key_id(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id == SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
+		ret = sctp_auth_deact_key_id(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id == SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id == SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id == SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_deact_key_id(ep, asoc,
-							 val.scact_keynumber);
+							 val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -3803,7 +3792,6 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
 
 	return ret;
 }
-#undef val
 
 /*
  * 8.1.23 SCTP_AUTO_ASCONF
@@ -3819,24 +3807,23 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
  * Note. In this implementation, socket operation overrides default parameter
  * being set by sysctl as well as FreeBSD implementation
  */
-#define val (*optval)
-static int sctp_setsockopt_auto_asconf(struct sock *sk, int val,
+static int sctp_setsockopt_auto_asconf(struct sock *sk, int *optval,
 				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (!sctp_is_ep_boundall(sk) && val)
+	if (!sctp_is_ep_boundall(sk) && (*optval))
 		return -EINVAL;
-	if ((val && sp->do_auto_asconf) || (!val && !sp->do_auto_asconf))
+	if (((*optval) && sp->do_auto_asconf) || (!(*optval) && !sp->do_auto_asconf))
 		return 0;
 
 	spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
-	if (val == 0 && sp->do_auto_asconf) {
+	if ((*optval) == 0 && sp->do_auto_asconf) {
 		list_del(&sp->auto_asconf_list);
 		sp->do_auto_asconf = 0;
-	} else if (val && !sp->do_auto_asconf) {
+	} else if ((*optval) && !sp->do_auto_asconf) {
 		list_add_tail(&sp->auto_asconf_list,
 		    &sock_net(sk)->sctp.auto_asconf_splist);
 		sp->do_auto_asconf = 1;
@@ -3844,7 +3831,6 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, int val,
 	spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	return 0;
 }
-#undef val
 
 /*
  * SCTP_PEER_ADDR_THLDS
@@ -3853,70 +3839,68 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, int val,
  * transports in an association.  See Section 6.1 of:
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
-#define val (*val)
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
-					    struct sctp_paddrthlds_v2 val,
+					    struct sctp_paddrthlds_v2 *val,
 					    unsigned int optlen, bool v2)
 {
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int len;
 
-	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	len = v2 ? sizeof(*val) : sizeof(struct sctp_paddrthlds);
 	if (optlen < len)
 		return -EINVAL;
 
-	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
+	if (v2 && val->spt_pathpfthld > val->spt_pathcpthld)
 		return -EINVAL;
 
-	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		trans = sctp_addr_id2transport(sk, &val.spt_address,
-					       val.spt_assoc_id);
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val->spt_address)) {
+		trans = sctp_addr_id2transport(sk, &val->spt_address,
+					       val->spt_assoc_id);
 		if (!trans)
 			return -ENOENT;
 
-		if (val.spt_pathmaxrxt)
-			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			trans->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			trans->ps_retrans = val.spt_pathcpthld;
-		trans->pf_retrans = val.spt_pathpfthld;
+			trans->ps_retrans = val->spt_pathcpthld;
+		trans->pf_retrans = val->spt_pathpfthld;
 
 		return 0;
 	}
 
-	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->spt_assoc_id);
+	if (!asoc && val->spt_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				    transports) {
-			if (val.spt_pathmaxrxt)
-				trans->pathmaxrxt = val.spt_pathmaxrxt;
+			if (val->spt_pathmaxrxt)
+				trans->pathmaxrxt = val->spt_pathmaxrxt;
 			if (v2)
-				trans->ps_retrans = val.spt_pathcpthld;
-			trans->pf_retrans = val.spt_pathpfthld;
+				trans->ps_retrans = val->spt_pathcpthld;
+			trans->pf_retrans = val->spt_pathpfthld;
 		}
 
-		if (val.spt_pathmaxrxt)
-			asoc->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			asoc->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			asoc->ps_retrans = val.spt_pathcpthld;
-		asoc->pf_retrans = val.spt_pathpfthld;
+			asoc->ps_retrans = val->spt_pathcpthld;
+		asoc->pf_retrans = val->spt_pathpfthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (val.spt_pathmaxrxt)
-			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			sp->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			sp->ps_retrans = val.spt_pathcpthld;
-		sp->pf_retrans = val.spt_pathpfthld;
+			sp->ps_retrans = val->spt_pathcpthld;
+		sp->pf_retrans = val->spt_pathpfthld;
 	}
 
 	return 0;
 }
-#undef val
 
 static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *optval,
 				       unsigned int optlen)
@@ -3941,92 +3925,91 @@ static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *optval,
 }
 
 static int sctp_setsockopt_pr_supported(struct sock *sk,
-					struct sctp_assoc_value params,
+					struct sctp_assoc_value *params,
 					unsigned int optlen)
 {
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->prsctp_enable = !!params->assoc_value;
 
 	return 0;
 }
 
 static int sctp_setsockopt_default_prinfo(struct sock *sk,
-					  struct sctp_default_prinfo info,
+					  struct sctp_default_prinfo *info,
 					  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		goto out;
 
-	if (info.pr_policy & ~SCTP_PR_SCTP_MASK)
+	if (info->pr_policy & ~SCTP_PR_SCTP_MASK)
 		goto out;
 
-	if (info.pr_policy == SCTP_PR_SCTP_NONE)
-		info.pr_value = 0;
+	if (info->pr_policy == SCTP_PR_SCTP_NONE)
+		info->pr_value = 0;
 
-	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
-	if (!asoc && info.pr_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
+	if (!asoc && info->pr_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-		asoc->default_timetolive = info.pr_value;
+		SCTP_PR_SET_POLICY(asoc->default_flags, info->pr_policy);
+		asoc->default_timetolive = info->pr_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.pr_assoc_id = SCTP_FUTURE_ASSOC;
+		info->pr_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.pr_assoc_id == SCTP_FUTURE_ASSOC ||
-	    info.pr_assoc_id == SCTP_ALL_ASSOC) {
-		SCTP_PR_SET_POLICY(sp->default_flags, info.pr_policy);
-		sp->default_timetolive = info.pr_value;
+	if (info->pr_assoc_id == SCTP_FUTURE_ASSOC ||
+	    info->pr_assoc_id == SCTP_ALL_ASSOC) {
+		SCTP_PR_SET_POLICY(sp->default_flags, info->pr_policy);
+		sp->default_timetolive = info->pr_value;
 	}
 
-	if (info.pr_assoc_id == SCTP_CURRENT_ASSOC ||
-	    info.pr_assoc_id == SCTP_ALL_ASSOC) {
+	if (info->pr_assoc_id == SCTP_CURRENT_ASSOC ||
+	    info->pr_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-			asoc->default_timetolive = info.pr_value;
+			SCTP_PR_SET_POLICY(asoc->default_flags, info->pr_policy);
+			asoc->default_timetolive = info->pr_value;
 		}
 	}
 
 out:
 	return retval;
 }
-#undef info
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      struct sctp_assoc_value params,
+					      struct sctp_assoc_value *params,
 					      unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4035,48 +4018,47 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
-					   struct sctp_assoc_value params,
+					   struct sctp_assoc_value *params,
 					   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	if (params.assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
+	if (params->assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		asoc->strreset_enable = params.assoc_value;
+		asoc->strreset_enable = params->assoc_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		ep->strreset_enable = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		ep->strreset_enable = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &ep->asocs, asocs)
-			asoc->strreset_enable = params.assoc_value;
+			asoc->strreset_enable = params->assoc_value;
 
 out:
 	return retval;
 }
 
-#undef params
 static int sctp_setsockopt_reset_streams(struct sock *sk,
 					 struct sctp_reset_streams *params,
 					 unsigned int optlen)
@@ -4103,20 +4085,17 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 out:
 	return retval;
 }
-#define params (*params)
 
-
-#define associd (*associd)
-static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t associd,
+static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(associd))
+	if (optlen != sizeof(*associd))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, associd);
+	asoc = sctp_id2assoc(sk, (*associd));
 	if (!asoc)
 		goto out;
 
@@ -4125,62 +4104,61 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t associd,
 out:
 	return retval;
 }
-#undef associd
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       struct sctp_add_streams params,
+				       struct sctp_add_streams *params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.sas_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sas_assoc_id);
 	if (!asoc)
 		goto out;
 
-	retval = sctp_send_add_streams(asoc, &params);
+	retval = sctp_send_add_streams(asoc, params);
 
 out:
 	return retval;
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
-				     struct sctp_assoc_value params,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int retval = 0;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		return -EINVAL;
 
-	if (params.assoc_value > SCTP_SS_MAX)
+	if (params->assoc_value > SCTP_SS_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_sched_set_sched(asoc, params.assoc_value);
+		return sctp_sched_set_sched(asoc, params->assoc_value);
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id == SCTP_FUTURE_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC)
-		sp->default_ss = params.assoc_value;
+	if (params->assoc_id == SCTP_FUTURE_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC)
+		sp->default_ss = params->assoc_value;
 
-	if (params.assoc_id == SCTP_CURRENT_ASSOC ||
-	    params.assoc_id == SCTP_ALL_ASSOC) {
+	if (params->assoc_id == SCTP_CURRENT_ASSOC ||
+	    params->assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
 			int ret = sctp_sched_set_sched(asoc,
-						       params.assoc_value);
+						       params->assoc_value);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4191,31 +4169,31 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler_value(struct sock *sk,
-					   struct sctp_stream_value params,
+					   struct sctp_stream_value *params,
 					   unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_CURRENT_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_CURRENT_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc) {
-		retval = sctp_sched_set_value(asoc, params.stream_id,
-					      params.stream_value, GFP_KERNEL);
+		retval = sctp_sched_set_value(asoc, params->stream_id,
+					      params->stream_value, GFP_KERNEL);
 		goto out;
 	}
 
 	retval = 0;
 
 	list_for_each_entry(asoc, &sctp_sk(sk)->ep->asocs, asocs) {
-		int ret = sctp_sched_set_value(asoc, params.stream_id,
-					       params.stream_value, GFP_KERNEL);
+		int ret = sctp_sched_set_value(asoc, params->stream_id,
+					       params->stream_value, GFP_KERNEL);
 		if (ret && !retval) /* try to return the 1st error. */
 			retval = ret;
 	}
@@ -4225,18 +4203,18 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  struct sctp_assoc_value params,
+						  struct sctp_assoc_value *params,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
@@ -4245,7 +4223,7 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 		goto out;
 	}
 
-	sp->ep->intl_enable = !!params.assoc_value;
+	sp->ep->intl_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4291,41 +4269,40 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
 	return 0;
 }
 
-#define param (*param)
-static int sctp_setsockopt_event(struct sock *sk, struct sctp_event param,
+static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 				 unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int retval = 0;
 
-	if (optlen < sizeof(param))
+	if (optlen < sizeof(*param))
 		return -EINVAL;
 
-	if (param.se_type < SCTP_SN_TYPE_BASE ||
-	    param.se_type > SCTP_SN_TYPE_MAX)
+	if (param->se_type < SCTP_SN_TYPE_BASE ||
+	    param->se_type > SCTP_SN_TYPE_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, param.se_assoc_id);
-	if (!asoc && param.se_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, param->se_assoc_id);
+	if (!asoc && param->se_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_assoc_ulpevent_type_set(&param, asoc);
+		return sctp_assoc_ulpevent_type_set(param, asoc);
 
 	if (sctp_style(sk, TCP))
-		param.se_assoc_id = SCTP_FUTURE_ASSOC;
+		param->se_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (param.se_assoc_id == SCTP_FUTURE_ASSOC ||
-	    param.se_assoc_id == SCTP_ALL_ASSOC)
+	if (param->se_assoc_id == SCTP_FUTURE_ASSOC ||
+	    param->se_assoc_id == SCTP_ALL_ASSOC)
 		sctp_ulpevent_type_set(&sp->subscribe,
-				       param.se_type, param.se_on);
+				       param->se_type, param->se_on);
 
-	if (param.se_assoc_id == SCTP_CURRENT_ASSOC ||
-	    param.se_assoc_id == SCTP_ALL_ASSOC) {
+	if (param->se_assoc_id == SCTP_CURRENT_ASSOC ||
+	    param->se_assoc_id == SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			int ret = sctp_assoc_ulpevent_type_set(&param, asoc);
+			int ret = sctp_assoc_ulpevent_type_set(param, asoc);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4334,26 +4311,25 @@ static int sctp_setsockopt_event(struct sock *sk, struct sctp_event param,
 
 	return retval;
 }
-#undef param
 
 static int sctp_setsockopt_asconf_supported(struct sock *sk,
-					    struct sctp_assoc_value params,
+					    struct sctp_assoc_value *params,
 					    unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	ep->asconf_enable = !!params.assoc_value;
+	ep->asconf_enable = !!params->assoc_value;
 
 	if (ep->asconf_enable && ep->auth_enable) {
 		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
@@ -4367,23 +4343,23 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  struct sctp_assoc_value params,
+					  struct sctp_assoc_value *params,
 					  unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	if (params.assoc_value) {
+	if (params->assoc_value) {
 		retval = sctp_auth_init(ep, GFP_KERNEL);
 		if (retval)
 			goto out;
@@ -4393,7 +4369,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 		}
 	}
 
-	ep->auth_enable = !!params.assoc_value;
+	ep->auth_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4401,21 +4377,21 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
-					 struct sctp_assoc_value params,
+					 struct sctp_assoc_value *params,
 					 unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->ecn_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->ecn_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4423,33 +4399,32 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     struct sctp_assoc_value params,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+	if (params->assoc_value > SCTP_PF_EXPOSE_MAX)
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc)
-		asoc->pf_expose = params.assoc_value;
+		asoc->pf_expose = params->assoc_value;
 	else
-		sctp_sk(sk)->pf_expose = params.assoc_value;
+		sctp_sk(sk)->pf_expose = params->assoc_value;
 	retval = 0;
 
 out:
 	return retval;
 }
-#undef params
 
 static int kernel_sctp_setsockopt(struct sock *sk, int optname, void *optval,
 			   int optlen)
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

