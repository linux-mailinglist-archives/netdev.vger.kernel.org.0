Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42B91E2740
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgEZQkU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:40:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23731 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729385AbgEZQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:40:20 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-223-YhNq18UFOQit-XCbZEa_0A-1; Tue, 26 May 2020 17:40:07 +0100
X-MC-Unique: YhNq18UFOQit-XCbZEa_0A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:06 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 6/8] sctp: getsockopt, expand some #defines
Thread-Topic: [PATCH v3 net-next 6/8] sctp: getsockopt, expand some #defines
Thread-Index: AdYze9zm9RD8CFChROKkYVuty/G8Zw==
Date:   Tue, 26 May 2020 16:40:06 +0000
Message-ID: <96a0cad80627498e865c4685c7647a83@AcuMS.aculab.com>
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
 net/sctp/socket.c | 627 ++++++++++++++++++++++++++----------------------------
 1 file changed, 302 insertions(+), 325 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7cab60b..1481372 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1359,9 +1359,8 @@ struct compat_sctp_getaddrs_old {
 };
 #endif
 
-#define param (*param)
 static int sctp_getsockopt_connectx3(struct sock *sk, int len,
-				     struct sctp_getaddrs_old param,
+				     struct sctp_getaddrs_old *param,
 				     int *optlen)
 {
 	sctp_assoc_t assoc_id = 0;
@@ -1374,33 +1373,32 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 
 		if (len < sizeof(param32))
 			return -EINVAL;
-		param32 = *(struct compat_sctp_getaddrs_old *)&param;
+		param32 = *(struct compat_sctp_getaddrs_old *)param;
 
-		param.assoc_id = param32.assoc_id;
-		param.addr_num = param32.addr_num;
-		param.addrs = compat_ptr(param32.addrs);
+		param->assoc_id = param32.assoc_id;
+		param->addr_num = param32.addr_num;
+		param->addrs = compat_ptr(param32.addrs);
 	} else
 #endif
 	{
-		if (len < sizeof(param))
+		if (len < sizeof(*param))
 			return -EINVAL;
 	}
 
-	addrs = memdup_user(param.addrs, param.addr_num);
+	addrs = memdup_user(param->addrs, param->addr_num);
 	if (IS_ERR(addrs))
 		return PTR_ERR(addrs);
 
-	err = __sctp_setsockopt_connectx(sk, addrs, param.addr_num,
+	err = __sctp_setsockopt_connectx(sk, addrs, param->addr_num,
 					 &assoc_id);
 	kfree(addrs);
 	if (err == 0 || err == -EINPROGRESS) {
-		*(sctp_assoc_t *)&param = assoc_id;
+		*(sctp_assoc_t *)param = assoc_id;
 		*optlen = sizeof(assoc_id);
 	}
 
 	return err;
 }
-#undef param
 
 /* API 3.1.4 close() - UDP Style Syntax
  * Applications use close() to perform graceful shutdown (as described in
@@ -5284,9 +5282,8 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
  * number of unacked data chunks, and number of data chunks pending
  * receipt.  This information is read-only.
  */
-#define status (*status)
 static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
-				       struct sctp_status status,
+				       struct sctp_status *status,
 				       int *optlen)
 {
 	struct sctp_association *asoc = NULL;
@@ -5294,14 +5291,14 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 	sctp_assoc_t associd;
 	int retval = 0;
 
-	if (len < sizeof(status)) {
+	if (len < sizeof(*status)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	*optlen = sizeof(status);
+	*optlen = sizeof(*status);
 
-	associd = status.sstat_assoc_id;
+	associd = status->sstat_assoc_id;
 	asoc = sctp_id2assoc(sk, associd);
 	if (!asoc) {
 		retval = -EINVAL;
@@ -5310,38 +5307,37 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 
 	transport = asoc->peer.primary_path;
 
-	status.sstat_assoc_id = sctp_assoc2id(asoc);
-	status.sstat_state = sctp_assoc_to_state(asoc);
-	status.sstat_rwnd =  asoc->peer.rwnd;
-	status.sstat_unackdata = asoc->unack_data;
-
-	status.sstat_penddata = sctp_tsnmap_pending(&asoc->peer.tsn_map);
-	status.sstat_instrms = asoc->stream.incnt;
-	status.sstat_outstrms = asoc->stream.outcnt;
-	status.sstat_fragmentation_point = asoc->frag_point;
-	status.sstat_primary.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
-	memcpy(&status.sstat_primary.spinfo_address, &transport->ipaddr,
+	status->sstat_assoc_id = sctp_assoc2id(asoc);
+	status->sstat_state = sctp_assoc_to_state(asoc);
+	status->sstat_rwnd =  asoc->peer.rwnd;
+	status->sstat_unackdata = asoc->unack_data;
+
+	status->sstat_penddata = sctp_tsnmap_pending(&asoc->peer.tsn_map);
+	status->sstat_instrms = asoc->stream.incnt;
+	status->sstat_outstrms = asoc->stream.outcnt;
+	status->sstat_fragmentation_point = asoc->frag_point;
+	status->sstat_primary.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
+	memcpy(&status->sstat_primary.spinfo_address, &transport->ipaddr,
 			transport->af_specific->sockaddr_len);
 	/* Map ipv4 address into v4-mapped-on-v6 address.  */
 	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sctp_sk(sk),
-		(union sctp_addr *)&status.sstat_primary.spinfo_address);
-	status.sstat_primary.spinfo_state = transport->state;
-	status.sstat_primary.spinfo_cwnd = transport->cwnd;
-	status.sstat_primary.spinfo_srtt = transport->srtt;
-	status.sstat_primary.spinfo_rto = jiffies_to_msecs(transport->rto);
-	status.sstat_primary.spinfo_mtu = transport->pathmtu;
+		(union sctp_addr *)&status->sstat_primary.spinfo_address);
+	status->sstat_primary.spinfo_state = transport->state;
+	status->sstat_primary.spinfo_cwnd = transport->cwnd;
+	status->sstat_primary.spinfo_srtt = transport->srtt;
+	status->sstat_primary.spinfo_rto = jiffies_to_msecs(transport->rto);
+	status->sstat_primary.spinfo_mtu = transport->pathmtu;
 
-	if (status.sstat_primary.spinfo_state == SCTP_UNKNOWN)
-		status.sstat_primary.spinfo_state = SCTP_ACTIVE;
+	if (status->sstat_primary.spinfo_state == SCTP_UNKNOWN)
+		status->sstat_primary.spinfo_state = SCTP_ACTIVE;
 
 	pr_debug("%s: len:%d, state:%d, rwnd:%d, assoc_id:%d\n",
-		 __func__, len, status.sstat_state, status.sstat_rwnd,
-		 status.sstat_assoc_id);
+		 __func__, len, status->sstat_state, status->sstat_rwnd,
+		 status->sstat_assoc_id);
 
 out:
 	return retval;
 }
-#undef status
 
 
 /* 7.2.2 Peer Address Information (SCTP_GET_PEER_ADDR_INFO)
@@ -5351,23 +5347,22 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
  * window, and retransmission timer values.  This information is
  * read-only.
  */
-#define pinfo (*pinfo)
 static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
-					  struct sctp_paddrinfo pinfo,
+					  struct sctp_paddrinfo *pinfo,
 					  int *optlen)
 {
 	struct sctp_transport *transport;
 	int retval = 0;
 
-	if (len < sizeof(pinfo)) {
+	if (len < sizeof(*pinfo)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	*optlen = sizeof(pinfo);
+	*optlen = sizeof(*pinfo);
 
-	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
-					   pinfo.spinfo_assoc_id);
+	transport = sctp_addr_id2transport(sk, &pinfo->spinfo_address,
+					   pinfo->spinfo_assoc_id);
 	if (!transport) {
 		retval = -EINVAL;
 		goto out;
@@ -5379,20 +5374,19 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 		goto out;
 	}
 
-	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
-	pinfo.spinfo_state = transport->state;
-	pinfo.spinfo_cwnd = transport->cwnd;
-	pinfo.spinfo_srtt = transport->srtt;
-	pinfo.spinfo_rto = jiffies_to_msecs(transport->rto);
-	pinfo.spinfo_mtu = transport->pathmtu;
+	pinfo->spinfo_assoc_id = sctp_assoc2id(transport->asoc);
+	pinfo->spinfo_state = transport->state;
+	pinfo->spinfo_cwnd = transport->cwnd;
+	pinfo->spinfo_srtt = transport->srtt;
+	pinfo->spinfo_rto = jiffies_to_msecs(transport->rto);
+	pinfo->spinfo_mtu = transport->pathmtu;
 
-	if (pinfo.spinfo_state == SCTP_UNKNOWN)
-		pinfo.spinfo_state = SCTP_ACTIVE;
+	if (pinfo->spinfo_state == SCTP_UNKNOWN)
+		pinfo->spinfo_state = SCTP_ACTIVE;
 
 out:
 	return retval;
 }
-#undef pinfo
 
 /* 7.1.12 Enable/Disable message fragmentation (SCTP_DISABLE_FRAGMENTS)
  *
@@ -5705,17 +5699,16 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
  *                     used for the DSCP.  This setting has precedence over any
  *                     IPv4- or IPv6- layer setting.
  */
-#define params (*params)
 static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
-					    struct sctp_paddrparams params,
+					    struct sctp_paddrparams *params,
 					    int *optlen)
 {
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 
-	if (len >= sizeof(params))
-		len = sizeof(params);
+	if (len >= sizeof(*params))
+		len = sizeof(*params);
 	else if (len >= ALIGN(offsetof(struct sctp_paddrparams,
 				       spp_ipv6_flowlabel), 4))
 		len = ALIGN(offsetof(struct sctp_paddrparams,
@@ -5728,9 +5721,9 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	/* If an address other than INADDR_ANY is specified, and
 	 * no transport is found, then the request is invalid.
 	 */
-	if (!sctp_is_any(sk, (union sctp_addr *)&params.spp_address)) {
-		trans = sctp_addr_id2transport(sk, &params.spp_address,
-					       params.spp_assoc_id);
+	if (!sctp_is_any(sk, (union sctp_addr *)&params->spp_address)) {
+		trans = sctp_addr_id2transport(sk, &params->spp_address,
+					       params->spp_assoc_id);
 		if (!trans) {
 			pr_debug("%s: failed no transport\n", __func__);
 			return -EINVAL;
@@ -5741,8 +5734,8 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->spp_assoc_id);
+	if (!asoc && params->spp_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		pr_debug("%s: failed no association\n", __func__);
 		return -EINVAL;
@@ -5750,57 +5743,57 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 
 	if (trans) {
 		/* Fetch transport values. */
-		params.spp_hbinterval = jiffies_to_msecs(trans->hbinterval);
-		params.spp_pathmtu    = trans->pathmtu;
-		params.spp_pathmaxrxt = trans->pathmaxrxt;
-		params.spp_sackdelay  = jiffies_to_msecs(trans->sackdelay);
+		params->spp_hbinterval = jiffies_to_msecs(trans->hbinterval);
+		params->spp_pathmtu    = trans->pathmtu;
+		params->spp_pathmaxrxt = trans->pathmaxrxt;
+		params->spp_sackdelay  = jiffies_to_msecs(trans->sackdelay);
 
 		/*draft-11 doesn't say what to return in spp_flags*/
-		params.spp_flags      = trans->param_flags;
+		params->spp_flags      = trans->param_flags;
 		if (trans->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
-			params.spp_ipv6_flowlabel = trans->flowlabel &
+			params->spp_ipv6_flowlabel = trans->flowlabel &
 						    SCTP_FLOWLABEL_VAL_MASK;
-			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+			params->spp_flags |= SPP_IPV6_FLOWLABEL;
 		}
 		if (trans->dscp & SCTP_DSCP_SET_MASK) {
-			params.spp_dscp	= trans->dscp & SCTP_DSCP_VAL_MASK;
-			params.spp_flags |= SPP_DSCP;
+			params->spp_dscp	= trans->dscp & SCTP_DSCP_VAL_MASK;
+			params->spp_flags |= SPP_DSCP;
 		}
 	} else if (asoc) {
 		/* Fetch association values. */
-		params.spp_hbinterval = jiffies_to_msecs(asoc->hbinterval);
-		params.spp_pathmtu    = asoc->pathmtu;
-		params.spp_pathmaxrxt = asoc->pathmaxrxt;
-		params.spp_sackdelay  = jiffies_to_msecs(asoc->sackdelay);
+		params->spp_hbinterval = jiffies_to_msecs(asoc->hbinterval);
+		params->spp_pathmtu    = asoc->pathmtu;
+		params->spp_pathmaxrxt = asoc->pathmaxrxt;
+		params->spp_sackdelay  = jiffies_to_msecs(asoc->sackdelay);
 
 		/*draft-11 doesn't say what to return in spp_flags*/
-		params.spp_flags      = asoc->param_flags;
+		params->spp_flags      = asoc->param_flags;
 		if (asoc->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
-			params.spp_ipv6_flowlabel = asoc->flowlabel &
+			params->spp_ipv6_flowlabel = asoc->flowlabel &
 						    SCTP_FLOWLABEL_VAL_MASK;
-			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+			params->spp_flags |= SPP_IPV6_FLOWLABEL;
 		}
 		if (asoc->dscp & SCTP_DSCP_SET_MASK) {
-			params.spp_dscp	= asoc->dscp & SCTP_DSCP_VAL_MASK;
-			params.spp_flags |= SPP_DSCP;
+			params->spp_dscp	= asoc->dscp & SCTP_DSCP_VAL_MASK;
+			params->spp_flags |= SPP_DSCP;
 		}
 	} else {
 		/* Fetch socket values. */
-		params.spp_hbinterval = sp->hbinterval;
-		params.spp_pathmtu    = sp->pathmtu;
-		params.spp_sackdelay  = sp->sackdelay;
-		params.spp_pathmaxrxt = sp->pathmaxrxt;
+		params->spp_hbinterval = sp->hbinterval;
+		params->spp_pathmtu    = sp->pathmtu;
+		params->spp_sackdelay  = sp->sackdelay;
+		params->spp_pathmaxrxt = sp->pathmaxrxt;
 
 		/*draft-11 doesn't say what to return in spp_flags*/
-		params.spp_flags      = sp->param_flags;
+		params->spp_flags      = sp->param_flags;
 		if (sp->flowlabel & SCTP_FLOWLABEL_SET_MASK) {
-			params.spp_ipv6_flowlabel = sp->flowlabel &
+			params->spp_ipv6_flowlabel = sp->flowlabel &
 						    SCTP_FLOWLABEL_VAL_MASK;
-			params.spp_flags |= SPP_IPV6_FLOWLABEL;
+			params->spp_flags |= SPP_IPV6_FLOWLABEL;
 		}
 		if (sp->dscp & SCTP_DSCP_SET_MASK) {
-			params.spp_dscp	= sp->dscp & SCTP_DSCP_VAL_MASK;
-			params.spp_flags |= SPP_DSCP;
+			params->spp_dscp	= sp->dscp & SCTP_DSCP_VAL_MASK;
+			params->spp_flags |= SPP_DSCP;
 		}
 	}
 
@@ -5843,7 +5836,7 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
  *    value to 1 will disable the delayed sack algorithm.
  */
 static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
-				       struct sctp_sack_info params,
+				       struct sctp_sack_info *params,
 				       int *optlen)
 {
 	struct sctp_association *asoc = NULL;
@@ -5866,29 +5859,29 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->sack_assoc_id);
+	if (!asoc && params->sack_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		/* Fetch association values. */
 		if (asoc->param_flags & SPP_SACKDELAY_ENABLE) {
-			params.sack_delay = jiffies_to_msecs(asoc->sackdelay);
-			params.sack_freq = asoc->sackfreq;
+			params->sack_delay = jiffies_to_msecs(asoc->sackdelay);
+			params->sack_freq = asoc->sackfreq;
 
 		} else {
-			params.sack_delay = 0;
-			params.sack_freq = 1;
+			params->sack_delay = 0;
+			params->sack_freq = 1;
 		}
 	} else {
 		/* Fetch socket values. */
 		if (sp->param_flags & SPP_SACKDELAY_ENABLE) {
-			params.sack_delay  = sp->sackdelay;
-			params.sack_freq = sp->sackfreq;
+			params->sack_delay  = sp->sackdelay;
+			params->sack_freq = sp->sackfreq;
 		} else {
-			params.sack_delay  = 0;
-			params.sack_freq = 1;
+			params->sack_delay  = 0;
+			params->sack_freq = 1;
 		}
 	}
 
@@ -6002,9 +5995,8 @@ static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
 }
 
 
-#define getaddrs (*getaddrs)
 static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
-				       struct sctp_getaddrs getaddrs,
+				       struct sctp_getaddrs *getaddrs,
 				       int *optlen)
 {
 	struct sctp_bind_addr *bp;
@@ -6029,16 +6021,16 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	 *  addresses are returned without regard to any particular
 	 *  association.
 	 */
-	if (0 == getaddrs.assoc_id) {
+	if (0 == getaddrs->assoc_id) {
 		bp = &sctp_sk(sk)->ep->base.bind_addr;
 	} else {
-		asoc = sctp_id2assoc(sk, getaddrs.assoc_id);
+		asoc = sctp_id2assoc(sk, getaddrs->assoc_id);
 		if (!asoc)
 			return -EINVAL;
 		bp = &asoc->base.bind_addr;
 	}
 
-	addrs = &getaddrs.addrs;
+	addrs = &getaddrs->addrs;
 	space_left = len - offsetof(struct sctp_getaddrs, addrs);
 
 	/* If the endpoint is bound to 0.0.0.0 or ::0, get the valid
@@ -6079,7 +6071,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	}
 
 copy_getaddrs:
-	getaddrs.addr_num = cnt;
+	getaddrs->addr_num = cnt;
 	/* XXX: For compatibility with the original broken code
 	 * sizeof(struct sctp_getaddrs) has to be subracted off *optlen
 	 * after the buffer is copied but before the length is returned.
@@ -6088,7 +6080,6 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 out:
 	return err;
 }
-#undef getaddrs
 
 /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
  *
@@ -6096,9 +6087,8 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-#define prim (*prim)
 static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
-					struct sctp_prim prim, int *optlen)
+					struct sctp_prim *prim, int *optlen)
 {
 	struct sctp_association *asoc;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -6108,22 +6098,21 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
 
 	*optlen = sizeof(struct sctp_prim);
 
-	asoc = sctp_id2assoc(sk, prim.ssp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->ssp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
 	if (!asoc->peer.primary_path)
 		return -ENOTCONN;
 
-	memcpy(&prim.ssp_addr, &asoc->peer.primary_path->ipaddr,
+	memcpy(&prim->ssp_addr, &asoc->peer.primary_path->ipaddr,
 		asoc->peer.primary_path->af_specific->sockaddr_len);
 
 	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sp,
-			(union sctp_addr *)&prim.ssp_addr);
+			(union sctp_addr *)&prim->ssp_addr);
 
 	return 0;
 }
-#undef prim
 
 /*
  * 7.1.11  Set Adaptation Layer Indicator (SCTP_ADAPTATION_LAYER)
@@ -6161,36 +6150,35 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
  *
  *   For getsockopt, it get the default sctp_sndrcvinfo structure.
  */
-#define info (*info)
 static int sctp_getsockopt_default_send_param(struct sock *sk,
-					int len, struct sctp_sndrcvinfo info,
+					int len, struct sctp_sndrcvinfo *info,
 					int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (len < sizeof(info))
+	if (len < sizeof(*info))
 		return -EINVAL;
 
-	*optlen = sizeof(info);
+	*optlen = sizeof(*info);
 
-	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
-	if (!asoc && info.sinfo_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->sinfo_assoc_id);
+	if (!asoc && info->sinfo_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		info.sinfo_stream = asoc->default_stream;
-		info.sinfo_flags = asoc->default_flags;
-		info.sinfo_ppid = asoc->default_ppid;
-		info.sinfo_context = asoc->default_context;
-		info.sinfo_timetolive = asoc->default_timetolive;
+		info->sinfo_stream = asoc->default_stream;
+		info->sinfo_flags = asoc->default_flags;
+		info->sinfo_ppid = asoc->default_ppid;
+		info->sinfo_context = asoc->default_context;
+		info->sinfo_timetolive = asoc->default_timetolive;
 	} else {
-		info.sinfo_stream = sp->default_stream;
-		info.sinfo_flags = sp->default_flags;
-		info.sinfo_ppid = sp->default_ppid;
-		info.sinfo_context = sp->default_context;
-		info.sinfo_timetolive = sp->default_timetolive;
+		info->sinfo_stream = sp->default_stream;
+		info->sinfo_flags = sp->default_flags;
+		info->sinfo_ppid = sp->default_ppid;
+		info->sinfo_context = sp->default_context;
+		info->sinfo_timetolive = sp->default_timetolive;
 	}
 
 	return 0;
@@ -6200,37 +6188,36 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
-					   struct sctp_sndinfo info,
+					   struct sctp_sndinfo *info,
 					   int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (len < sizeof(info))
+	if (len < sizeof(*info))
 		return -EINVAL;
 
-	*optlen = sizeof(info);
+	*optlen = sizeof(*info);
 
-	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
-	if (!asoc && info.snd_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->snd_assoc_id);
+	if (!asoc && info->snd_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		info.snd_sid = asoc->default_stream;
-		info.snd_flags = asoc->default_flags;
-		info.snd_ppid = asoc->default_ppid;
-		info.snd_context = asoc->default_context;
+		info->snd_sid = asoc->default_stream;
+		info->snd_flags = asoc->default_flags;
+		info->snd_ppid = asoc->default_ppid;
+		info->snd_context = asoc->default_context;
 	} else {
-		info.snd_sid = sp->default_stream;
-		info.snd_flags = sp->default_flags;
-		info.snd_ppid = sp->default_ppid;
-		info.snd_context = sp->default_context;
+		info->snd_sid = sp->default_stream;
+		info->snd_flags = sp->default_flags;
+		info->snd_ppid = sp->default_ppid;
+		info->snd_context = sp->default_context;
 	}
 
 	return 0;
 }
-#undef info
 
 /*
  *
@@ -6263,7 +6250,7 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
-				   struct sctp_rtoinfo params, int *optlen)
+				   struct sctp_rtoinfo *params, int *optlen)
 {
 	struct sctp_association *asoc;
 
@@ -6272,24 +6259,24 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 
 	*optlen = sizeof(struct sctp_rtoinfo);
 
-	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, params->srto_assoc_id);
 
-	if (!asoc && params.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values corresponding to the specific association. */
 	if (asoc) {
-		params.srto_initial = jiffies_to_msecs(asoc->rto_initial);
-		params.srto_max = jiffies_to_msecs(asoc->rto_max);
-		params.srto_min = jiffies_to_msecs(asoc->rto_min);
+		params->srto_initial = jiffies_to_msecs(asoc->rto_initial);
+		params->srto_max = jiffies_to_msecs(asoc->rto_max);
+		params->srto_min = jiffies_to_msecs(asoc->rto_min);
 	} else {
 		/* Values corresponding to the endpoint. */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		params.srto_initial = sp->rtoinfo.srto_initial;
-		params.srto_max = sp->rtoinfo.srto_max;
-		params.srto_min = sp->rtoinfo.srto_min;
+		params->srto_initial = sp->rtoinfo.srto_initial;
+		params->srto_max = sp->rtoinfo.srto_max;
+		params->srto_min = sp->rtoinfo.srto_min;
 	}
 
 	return 0;
@@ -6307,7 +6294,7 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_associnfo(struct sock *sk, int len,
-				     struct sctp_assocparams params,
+				     struct sctp_assocparams *params,
 				     int *optlen)
 {
 
@@ -6320,34 +6307,34 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 
 	*optlen = sizeof(struct sctp_assocparams);
 
-	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sasoc_assoc_id);
 
-	if (!asoc && params.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values correspoinding to the specific association */
 	if (asoc) {
-		params.sasoc_asocmaxrxt = asoc->max_retrans;
-		params.sasoc_peer_rwnd = asoc->peer.rwnd;
-		params.sasoc_local_rwnd = asoc->a_rwnd;
-		params.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
+		params->sasoc_asocmaxrxt = asoc->max_retrans;
+		params->sasoc_peer_rwnd = asoc->peer.rwnd;
+		params->sasoc_local_rwnd = asoc->a_rwnd;
+		params->sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
 
 		list_for_each(pos, &asoc->peer.transport_addr_list) {
 			cnt++;
 		}
 
-		params.sasoc_number_peer_destinations = cnt;
+		params->sasoc_number_peer_destinations = cnt;
 	} else {
 		/* Values corresponding to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		params.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
-		params.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
-		params.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
-		params.sasoc_cookie_life =
+		params->sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
+		params->sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
+		params->sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
+		params->sasoc_cookie_life =
 					sp->assocparams.sasoc_cookie_life;
-		params.sasoc_number_peer_destinations =
+		params->sasoc_number_peer_destinations =
 					sp->assocparams.
 					sasoc_number_peer_destinations;
 	}
@@ -6381,18 +6368,18 @@ static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_context())
  */
 static int sctp_getsockopt_context(struct sock *sk, int len,
-				   struct sctp_assoc_value params, int *optlen)
+				   struct sctp_assoc_value *params, int *optlen)
 {
 	struct sctp_association *asoc;
 
 	*optlen = sizeof(struct sctp_assoc_value);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	params.assoc_value = asoc ? asoc->default_rcv_context
+	params->assoc_value = asoc ? asoc->default_rcv_context
 				  : sctp_sk(sk)->default_rcv_context;
 
 	return 0;
@@ -6426,7 +6413,7 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
 static int sctp_getsockopt_maxseg(struct sock *sk, int len,
-				  struct sctp_assoc_value params, int *optlen)
+				  struct sctp_assoc_value *params, int *optlen)
 {
 	struct sctp_association *asoc;
 
@@ -6436,7 +6423,7 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
 	} else
@@ -6444,18 +6431,18 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 
 	*optlen = len;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		params.assoc_value = asoc->frag_point;
+		params->assoc_value = asoc->frag_point;
 	else
-		params.assoc_value = sctp_sk(sk)->user_frag;
+		params->assoc_value = sctp_sk(sk)->user_frag;
 
 	if (len == sizeof(int))
-		*(int *)&params = params.assoc_value;
+		*(int *)params = params->assoc_value;
 
 	return 0;
 }
@@ -6491,7 +6478,7 @@ static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_maxburst())
  */
 static int sctp_getsockopt_maxburst(struct sock *sk, int len,
-				    struct sctp_assoc_value params,
+				    struct sctp_assoc_value *params,
 				    int *optlen)
 {
 	struct sctp_association *asoc;
@@ -6502,22 +6489,22 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 				    "Use of int in max_burst socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
 	} else
 		return -EINVAL;
 	*optlen = len;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	params.assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
+	params->assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
 
 	if (len == sizeof(int))
-		*(int *)&params = params.assoc_value;
+		*(int *)params = params->assoc_value;
 
 	return 0;
 
@@ -6552,32 +6539,30 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 	return 0;
 }
 
-#define val (*val)
 static int sctp_getsockopt_active_key(struct sock *sk, int len,
-				    struct sctp_authkeyid val, int *optlen)
+				    struct sctp_authkeyid *val, int *optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
 
 	*optlen = sizeof(struct sctp_authkeyid);
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		if (!asoc->peer.auth_capable)
 			return -EACCES;
-		val.scact_keynumber = asoc->active_key_id;
+		val->scact_keynumber = asoc->active_key_id;
 	} else {
 		if (!ep->auth_enable)
 			return -EACCES;
-		val.scact_keynumber = ep->active_key_id;
+		val->scact_keynumber = ep->active_key_id;
 	}
 
 	return 0;
 }
-#undef val
 
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 				    struct sctp_authchunks *p, int *optlen)
@@ -6740,54 +6725,52 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  * transports in an association.  See Section 6.1 of:
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
-#define val (*val)
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
-					    struct sctp_paddrthlds_v2 val,
+					    struct sctp_paddrthlds_v2 *val,
 					    int len, int *optlen, bool v2)
 {
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int min;
 
-	min = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	min = v2 ? sizeof(*val) : sizeof(struct sctp_paddrthlds);
 	if (len < min)
 		return -EINVAL;
 	*optlen = min;
 
-	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		trans = sctp_addr_id2transport(sk, &val.spt_address,
-					       val.spt_assoc_id);
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val->spt_address)) {
+		trans = sctp_addr_id2transport(sk, &val->spt_address,
+					       val->spt_assoc_id);
 		if (!trans)
 			return -ENOENT;
 
-		val.spt_pathmaxrxt = trans->pathmaxrxt;
-		val.spt_pathpfthld = trans->pf_retrans;
-		val.spt_pathcpthld = trans->ps_retrans;
+		val->spt_pathmaxrxt = trans->pathmaxrxt;
+		val->spt_pathpfthld = trans->pf_retrans;
+		val->spt_pathcpthld = trans->ps_retrans;
 
 		goto out;
 	}
 
-	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->spt_assoc_id);
+	if (!asoc && val->spt_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		val.spt_pathpfthld = asoc->pf_retrans;
-		val.spt_pathmaxrxt = asoc->pathmaxrxt;
-		val.spt_pathcpthld = asoc->ps_retrans;
+		val->spt_pathpfthld = asoc->pf_retrans;
+		val->spt_pathmaxrxt = asoc->pathmaxrxt;
+		val->spt_pathcpthld = asoc->ps_retrans;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		val.spt_pathpfthld = sp->pf_retrans;
-		val.spt_pathmaxrxt = sp->pathmaxrxt;
-		val.spt_pathcpthld = sp->ps_retrans;
+		val->spt_pathpfthld = sp->pf_retrans;
+		val->spt_pathmaxrxt = sp->pathmaxrxt;
+		val->spt_pathcpthld = sp->ps_retrans;
 	}
 
 out:
 	return 0;
 }
-#undef val
 
 /*
  * SCTP_GET_ASSOC_STATS
@@ -6795,9 +6778,8 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
  * This option retrieves local per endpoint statistics. It is modeled
  * after OpenSolaris' implementation
  */
-#define sas (*sas)
 static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
-				       struct sctp_assoc_stats sas,
+				       struct sctp_assoc_stats *sas,
 				       int *optlen)
 {
 	struct sctp_association *asoc = NULL;
@@ -6807,42 +6789,41 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 		return -EINVAL;
 
 	/* Allow the struct to grow and fill in as much as possible */
-	*optlen = min_t(size_t, len, sizeof(sas));
+	*optlen = min_t(size_t, len, sizeof(*sas));
 
-	asoc = sctp_id2assoc(sk, sas.sas_assoc_id);
+	asoc = sctp_id2assoc(sk, sas->sas_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
-	sas.sas_rtxchunks = asoc->stats.rtxchunks;
-	sas.sas_gapcnt = asoc->stats.gapcnt;
-	sas.sas_outofseqtsns = asoc->stats.outofseqtsns;
-	sas.sas_osacks = asoc->stats.osacks;
-	sas.sas_isacks = asoc->stats.isacks;
-	sas.sas_octrlchunks = asoc->stats.octrlchunks;
-	sas.sas_ictrlchunks = asoc->stats.ictrlchunks;
-	sas.sas_oodchunks = asoc->stats.oodchunks;
-	sas.sas_iodchunks = asoc->stats.iodchunks;
-	sas.sas_ouodchunks = asoc->stats.ouodchunks;
-	sas.sas_iuodchunks = asoc->stats.iuodchunks;
-	sas.sas_idupchunks = asoc->stats.idupchunks;
-	sas.sas_opackets = asoc->stats.opackets;
-	sas.sas_ipackets = asoc->stats.ipackets;
+	sas->sas_rtxchunks = asoc->stats.rtxchunks;
+	sas->sas_gapcnt = asoc->stats.gapcnt;
+	sas->sas_outofseqtsns = asoc->stats.outofseqtsns;
+	sas->sas_osacks = asoc->stats.osacks;
+	sas->sas_isacks = asoc->stats.isacks;
+	sas->sas_octrlchunks = asoc->stats.octrlchunks;
+	sas->sas_ictrlchunks = asoc->stats.ictrlchunks;
+	sas->sas_oodchunks = asoc->stats.oodchunks;
+	sas->sas_iodchunks = asoc->stats.iodchunks;
+	sas->sas_ouodchunks = asoc->stats.ouodchunks;
+	sas->sas_iuodchunks = asoc->stats.iuodchunks;
+	sas->sas_idupchunks = asoc->stats.idupchunks;
+	sas->sas_opackets = asoc->stats.opackets;
+	sas->sas_ipackets = asoc->stats.ipackets;
 
 	/* New high max rto observed, will return 0 if not a single
 	 * RTO update took place. obs_rto_ipaddr will be bogus
 	 * in such a case
 	 */
-	sas.sas_maxrto = asoc->stats.max_obs_rto;
-	sas.sas_obs_rto_ipaddr = asoc->stats.obs_rto_ipaddr;
+	sas->sas_maxrto = asoc->stats.max_obs_rto;
+	sas->sas_obs_rto_ipaddr = asoc->stats.obs_rto_ipaddr;
 
 	/* Mark beginning of a new observation period */
 	asoc->stats.max_obs_rto = asoc->rto_min;
 
-	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
+	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas->sas_assoc_id);
 
 	return 0;
 }
-#undef sas
 
 static int sctp_getsockopt_recvrcvinfo(struct sock *sk, int len, int *optval,
 				       int *optlen)
@@ -6871,89 +6852,87 @@ static int sctp_getsockopt_recvnxtinfo(struct sock *sk, int len, int *optval,
 }
 
 static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
-					struct sctp_assoc_value params,
+					struct sctp_assoc_value *params,
 					int *optlen)
 {
 	struct sctp_association *asoc;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		return -EINVAL;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.prsctp_capable
+	params->assoc_value = asoc ? asoc->peer.prsctp_capable
 				  : sctp_sk(sk)->ep->prsctp_enable;
 
 	return 0;
 }
 
-#define info (*info)
 static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
-					  struct sctp_default_prinfo info,
+					  struct sctp_default_prinfo *info,
 					  int *optlen)
 {
 	struct sctp_association *asoc;
 
-	*optlen = sizeof(info);
+	*optlen = sizeof(*info);
 
-	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
-	if (!asoc && info.pr_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
+	if (!asoc && info->pr_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		return -EINVAL;
 	}
 
 	if (asoc) {
-		info.pr_policy = SCTP_PR_POLICY(asoc->default_flags);
-		info.pr_value = asoc->default_timetolive;
+		info->pr_policy = SCTP_PR_POLICY(asoc->default_flags);
+		info->pr_value = asoc->default_timetolive;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		info.pr_policy = SCTP_PR_POLICY(sp->default_flags);
-		info.pr_value = sp->default_timetolive;
+		info->pr_policy = SCTP_PR_POLICY(sp->default_flags);
+		info->pr_value = sp->default_timetolive;
 	}
 
 	return 0;
 }
-#undef info
 
 static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
-					  struct sctp_prstatus params,
+					  struct sctp_prstatus *params,
 					  int *optlen)
 {
 	struct sctp_association *asoc;
 	int policy;
 	int retval = -EINVAL;
 
-	if (len < sizeof(params))
+	if (len < sizeof(*params))
 		goto out;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	policy = params.sprstat_policy;
+	policy = params->sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
 	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sprstat_assoc_id);
 	if (!asoc)
 		goto out;
 
 	if (policy == SCTP_PR_SCTP_ALL) {
-		params.sprstat_abandoned_unsent = 0;
-		params.sprstat_abandoned_sent = 0;
+		params->sprstat_abandoned_unsent = 0;
+		params->sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {
-			params.sprstat_abandoned_unsent +=
+			params->sprstat_abandoned_unsent +=
 				asoc->abandoned_unsent[policy];
-			params.sprstat_abandoned_sent +=
+			params->sprstat_abandoned_sent +=
 				asoc->abandoned_sent[policy];
 		}
 	} else {
-		params.sprstat_abandoned_unsent =
+		params->sprstat_abandoned_unsent =
 			asoc->abandoned_unsent[__SCTP_PR_INDEX(policy)];
-		params.sprstat_abandoned_sent =
+		params->sprstat_abandoned_sent =
 			asoc->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
@@ -6964,7 +6943,7 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
-					   struct sctp_prstatus params,
+					   struct sctp_prstatus *params,
 					   int *optlen)
 {
 	struct sctp_stream_out_ext *streamoute;
@@ -6972,42 +6951,42 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 	int retval = -EINVAL;
 	int policy;
 
-	if (len < sizeof(params))
+	if (len < sizeof(*params))
 		goto out;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	policy = params.sprstat_policy;
+	policy = params->sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
 	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
-	if (!asoc || params.sprstat_sid >= asoc->stream.outcnt)
+	asoc = sctp_id2assoc(sk, params->sprstat_assoc_id);
+	if (!asoc || params->sprstat_sid >= asoc->stream.outcnt)
 		goto out;
 
-	streamoute = SCTP_SO(&asoc->stream, params.sprstat_sid)->ext;
+	streamoute = SCTP_SO(&asoc->stream, params->sprstat_sid)->ext;
 	if (!streamoute) {
 		/* Not allocated yet, means all stats are 0 */
-		params.sprstat_abandoned_unsent = 0;
-		params.sprstat_abandoned_sent = 0;
+		params->sprstat_abandoned_unsent = 0;
+		params->sprstat_abandoned_sent = 0;
 		retval = 0;
 		goto out;
 	}
 
 	if (policy == SCTP_PR_SCTP_ALL) {
-		params.sprstat_abandoned_unsent = 0;
-		params.sprstat_abandoned_sent = 0;
+		params->sprstat_abandoned_unsent = 0;
+		params->sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {
-			params.sprstat_abandoned_unsent +=
+			params->sprstat_abandoned_unsent +=
 				streamoute->abandoned_unsent[policy];
-			params.sprstat_abandoned_sent +=
+			params->sprstat_abandoned_sent +=
 				streamoute->abandoned_sent[policy];
 		}
 	} else {
-		params.sprstat_abandoned_unsent =
+		params->sprstat_abandoned_unsent =
 			streamoute->abandoned_unsent[__SCTP_PR_INDEX(policy)];
-		params.sprstat_abandoned_sent =
+		params->sprstat_abandoned_sent =
 			streamoute->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
@@ -7018,22 +6997,22 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
-					      struct sctp_assoc_value params,
+					      struct sctp_assoc_value *params,
 					      int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.reconf_capable
+	params->assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
 	retval = 0;
@@ -7043,22 +7022,22 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
-					   struct sctp_assoc_value params,
+					   struct sctp_assoc_value *params,
 					   int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->strreset_enable
+	params->assoc_value = asoc ? asoc->strreset_enable
 				  : sctp_sk(sk)->ep->strreset_enable;
 
 	retval = 0;
@@ -7068,22 +7047,22 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_scheduler(struct sock *sk, int len,
-				     struct sctp_assoc_value params,
+				     struct sctp_assoc_value *params,
 				     int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? sctp_sched_get_sched(asoc)
+	params->assoc_value = asoc ? sctp_sched_get_sched(asoc)
 				  : sctp_sk(sk)->default_ss;
 
 	retval = 0;
@@ -7093,44 +7072,44 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
-					   struct sctp_stream_value params,
+					   struct sctp_stream_value *params,
 					   int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
+	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	retval = sctp_sched_get_value(asoc, params.stream_id,
-				      &params.stream_value);
+	retval = sctp_sched_get_value(asoc, params->stream_id,
+				      &params->stream_value);
 
 out:
 	return retval;
 }
 
 static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
-						  struct sctp_assoc_value params,
+						  struct sctp_assoc_value *params,
 						  int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.intl_capable
+	params->assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->ep->intl_enable;
 
 	retval = 0;
@@ -7149,52 +7128,50 @@ static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
 	return 0;
 }
 
-#define param (*param)
 static int sctp_getsockopt_event(struct sock *sk, int len,
-				 struct sctp_event param,
+				 struct sctp_event *param,
 				 int *optlen)
 {
 	struct sctp_association *asoc;
 	__u16 subscribe;
 
-	if (len < sizeof(param))
+	if (len < sizeof(*param))
 		return -EINVAL;
 
-	*optlen = sizeof(param);
+	*optlen = sizeof(*param);
 
-	if (param.se_type < SCTP_SN_TYPE_BASE ||
-	    param.se_type > SCTP_SN_TYPE_MAX)
+	if (param->se_type < SCTP_SN_TYPE_BASE ||
+	    param->se_type > SCTP_SN_TYPE_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, param.se_assoc_id);
-	if (!asoc && param.se_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, param->se_assoc_id);
+	if (!asoc && param->se_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	subscribe = asoc ? asoc->subscribe : sctp_sk(sk)->subscribe;
-	param.se_on = sctp_ulpevent_type_enabled(subscribe, param.se_type);
+	param->se_on = sctp_ulpevent_type_enabled(subscribe, param->se_type);
 
 	return 0;
 }
-#undef param
 
 static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
-					    struct sctp_assoc_value params,
+					    struct sctp_assoc_value *params,
 					    int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.asconf_capable
+	params->assoc_value = asoc ? asoc->peer.asconf_capable
 				  : sctp_sk(sk)->ep->asconf_enable;
 
 	retval = 0;
@@ -7204,22 +7181,22 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
-					  struct sctp_assoc_value params,
+					  struct sctp_assoc_value *params,
 					  int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.auth_capable
+	params->assoc_value = asoc ? asoc->peer.auth_capable
 				  : sctp_sk(sk)->ep->auth_enable;
 
 	retval = 0;
@@ -7229,22 +7206,22 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
-					 struct sctp_assoc_value params,
+					 struct sctp_assoc_value *params,
 					 int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->peer.ecn_capable
+	params->assoc_value = asoc ? asoc->peer.ecn_capable
 				  : sctp_sk(sk)->ep->ecn_enable;
 
 	retval = 0;
@@ -7254,22 +7231,22 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
-				     struct sctp_assoc_value params,
+				     struct sctp_assoc_value *params,
 				     int *optlen)
 {
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	*optlen = sizeof(params);
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->pf_expose
+	params->assoc_value = asoc ? asoc->pf_expose
 				  : sctp_sk(sk)->pf_expose;
 
 	retval = 0;
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

