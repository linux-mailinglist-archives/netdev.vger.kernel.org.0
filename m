Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C771DB7BC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgETPIm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 11:08:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48988 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgETPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:08:41 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-229-JG3YT1ZVOcG9utHhosJEdA-1; Wed, 20 May 2020 16:08:14 +0100
X-MC-Unique: JG3YT1ZVOcG9utHhosJEdA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 20 May 2020 16:08:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 20 May 2020 16:08:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Neil Horman <nhorman@tuxdriver.com>,
        'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] sctp: Pull the user copies out of the individual
 sockopt functions.
Thread-Topic: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Index: AdYut/UmmYS4izffR6iTi1nqaxYM2Q==
Date:   Wed, 20 May 2020 15:08:13 +0000
Message-ID: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
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

Since SCTP rather abuses getsockopt() to perform operations and uses
the user buffer to select the association to get values from
the sctp_getsockopt() has to do a Read-Modify-Write on the user buffer.

An on-stack buffer is used for short requests this allows the length
check for simple getsockopt requests to be done by the wrapper.

Signed-off-by: David Laight <david.laight@aculab.com>

--

While this patch might make it easier to export the functionality
to other kernel modules, it doesn't make that change.

Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
It is also the only getsockopt() that wants to return a buffer
and an error code. It is also definitely abusing getsockopt().

The SCTP_SOCKOPT_PEELOFF getsockopt() (another abuse) also wants to
return a positive value and a buffer (containing the same value) on
success.

Both these stop the sctp_getsockopt_xxx() functions returning
'error or length'.

There is also real fubar of SCTP_GET_LOCAL_ADDRS which has to
return the wrong length 'for historic compatibility'.
Although I'm not sure how portable that makes applications.

Reduces the code by about 800 lines and 8k bytes (x86-64).
Most of the changed lines are replacing x.y with x->y and
simplifying error paths.

Passes 'sparse' and at least some options work.

---
 net/sctp/socket.c | 2885 +++++++++++++++++++----------------------------------
 1 file changed, 1051 insertions(+), 1834 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..a115eb6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -965,10 +965,9 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  * Returns 0 if ok, <0 errno code on error.
  */
 static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
+				 struct sockaddr *kaddrs,
 				 int addrs_size, int op)
 {
-	struct sockaddr *kaddrs;
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
@@ -977,22 +976,16 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
+		 __func__, sk, kaddrs, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			return -EINVAL;
-		}
 
 		sa_addr = addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
@@ -1017,29 +1010,21 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 						 (struct sockaddr *)kaddrs,
 						 addrs_size);
 		if (err)
-			goto out;
+			return err;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
-		break;
+			return err;
+		return sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
 
 	case SCTP_BINDX_REM_ADDR:
 		err = sctp_bindx_rem(sk, kaddrs, addrcnt);
 		if (err)
-			goto out;
-		err = sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
-		break;
+			return err;
+		return sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
 
 	default:
-		err = -EINVAL;
-		break;
+		return -EINVAL;
 	}
-
-out:
-	kfree(kaddrs);
-
-	return err;
 }
 
 static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
@@ -1287,30 +1272,25 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
  * Returns >=0 if ok, <0 errno code on error.
  */
 static int __sctp_setsockopt_connectx(struct sock *sk,
-				      struct sockaddr __user *addrs,
+				      struct sockaddr *kaddrs,
 				      int addrs_size,
 				      sctp_assoc_t *assoc_id)
 {
-	struct sockaddr *kaddrs;
 	int err = 0, flags = 0;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
-		 __func__, sk, addrs, addrs_size);
+		 __func__, sk, kaddrs, addrs_size);
 
 	/* make sure the 1st addr's sa_family is accessible later */
 	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Allow security module to validate connectx addresses. */
 	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_CONNECTX,
 					 (struct sockaddr *)kaddrs,
 					  addrs_size);
 	if (err)
-		goto out_free;
+		return err;
 
 	/* in-kernel sockets don't generally have a file allocated to them
 	 * if all they do is call sock_create_kern().
@@ -1318,12 +1298,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	if (sk->sk_socket->file)
 		flags = sk->sk_socket->file->f_flags;
 
-	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
-
-out_free:
-	kfree(kaddrs);
-
-	return err;
+	return __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
 }
 
 /*
@@ -1331,7 +1306,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
  * to the option that doesn't provide association id.
  */
 static int sctp_setsockopt_connectx_old(struct sock *sk,
-					struct sockaddr __user *addrs,
+					struct sockaddr *addrs,
 					int addrs_size)
 {
 	return __sctp_setsockopt_connectx(sk, addrs, addrs_size, NULL);
@@ -1344,7 +1319,7 @@ static int sctp_setsockopt_connectx_old(struct sock *sk,
  * always positive.
  */
 static int sctp_setsockopt_connectx(struct sock *sk,
-				    struct sockaddr __user *addrs,
+				    struct sockaddr *addrs,
 				    int addrs_size)
 {
 	sctp_assoc_t assoc_id = 0;
@@ -1375,11 +1350,11 @@ struct compat_sctp_getaddrs_old {
 #endif
 
 static int sctp_getsockopt_connectx3(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_getaddrs_old *param,
+				     int *optlen)
 {
-	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
+	struct sockaddr *addrs;
 	int err = 0;
 
 #ifdef CONFIG_COMPAT
@@ -1388,29 +1363,28 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 
 		if (len < sizeof(param32))
 			return -EINVAL;
-		if (copy_from_user(&param32, optval, sizeof(param32)))
-			return -EFAULT;
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
-		if (copy_from_user(&param, optval, sizeof(param)))
-			return -EFAULT;
 	}
 
-	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
-					 param.addrs, param.addr_num,
+	addrs = memdup_user(param->addrs, param->addr_num);
+	if (IS_ERR(addrs))
+		return PTR_ERR(addrs);
+
+	err = __sctp_setsockopt_connectx(sk, addrs, param->addr_num,
 					 &assoc_id);
+	kfree(addrs);
 	if (err == 0 || err == -EINPROGRESS) {
-		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
-			return -EFAULT;
-		if (put_user(sizeof(assoc_id), optlen))
-			return -EFAULT;
+		*(sctp_assoc_t *)param = assoc_id;
+		*optlen = sizeof(assoc_id);
 	}
 
 	return err;
@@ -2188,27 +2162,20 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
  * instead a error will be indicated to the user.
  */
 static int sctp_setsockopt_disable_fragments(struct sock *sk,
-					     char __user *optval,
+					     int *optval,
 					     unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->disable_fragments = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->disable_fragments = (*optval == 0) ? 0 : 1;
 
 	return 0;
 }
 
-static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
 				  unsigned int optlen)
 {
-	struct sctp_event_subscribe subscribe;
-	__u8 *sn_type = (__u8 *)&subscribe;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int i;
@@ -2216,9 +2183,6 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
 
-	if (copy_from_user(&subscribe, optval, optlen))
-		return -EFAULT;
-
 	for (i = 0; i < optlen; i++)
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
@@ -2258,7 +2222,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, int *optval,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2269,8 +2233,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
+
+	sp->autoclose = *optval;
 
 	if (sp->autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
@@ -2606,48 +2570,42 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 }
 
 static int sctp_setsockopt_peer_addr_params(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrparams *params,
 					    unsigned int optlen)
 {
-	struct sctp_paddrparams  params;
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 	int error;
 	int hb_change, pmtud_change, sackdelay_change;
 
-	if (optlen == sizeof(params)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-	} else if (optlen == ALIGN(offsetof(struct sctp_paddrparams,
-					    spp_ipv6_flowlabel), 4)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
+	if (optlen != sizeof(*params)) {
+		if (optlen != ALIGN(offsetof(struct sctp_paddrparams,
+						    spp_ipv6_flowlabel), 4))
+			return -EINVAL;
+		if (params->spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
 			return -EINVAL;
-	} else {
-		return -EINVAL;
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
@@ -2656,19 +2614,19 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
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
 
@@ -2681,7 +2639,7 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	if (!trans && asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				transports) {
-			sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+			sctp_apply_peer_addr_params(params, trans, asoc, sp,
 						    hb_change, pmtud_change,
 						    sackdelay_change);
 		}
@@ -2774,17 +2732,14 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  */
 
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       char __user *optval, unsigned int optlen)
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sack_info params;
 
 	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
-		if (params.sack_delay == 0 && params.sack_freq == 0)
+		if (params->sack_delay == 0 && params->sack_freq == 0)
 			return 0;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -2792,59 +2747,56 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
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
@@ -2860,24 +2812,22 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
+				   unsigned int optlen)
 {
-	struct sctp_initmsg sinit;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen != sizeof(struct sctp_initmsg))
 		return -EINVAL;
-	if (copy_from_user(&sinit, optval, optlen))
-		return -EFAULT;
 
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
@@ -2897,57 +2847,54 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigne
  *   to this call if the caller is using the UDP model.
  */
 static int sctp_setsockopt_default_send_param(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_sndrcvinfo *info,
 					      unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
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
 
@@ -2958,54 +2905,51 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_setsockopt_default_sndinfo(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_sndinfo *info,
 					   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
-	if (optlen != sizeof(info))
+	if (optlen != sizeof(*info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
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
 
@@ -3018,10 +2962,9 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
 					unsigned int optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_transport *trans;
 	struct sctp_af *af;
 	int err;
@@ -3029,21 +2972,18 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
-		return -EFAULT;
-
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
 
@@ -3060,17 +3000,13 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
  * introduced, at the cost of more packets in the network.  Expects an
  *  integer boolean flag.
  */
-static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_nodelay(struct sock *sk, int *optval,
 				   unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->nodelay = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->nodelay = (*optval == 0) ? 0 : 1;
 	return 0;
 }
 
@@ -3086,9 +3022,10 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
  * be changed.
  *
  */
-static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_rtoinfo(struct sock *sk,
+				   struct sctp_rtoinfo *rtoinfo,
+				   unsigned int optlen)
 {
-	struct sctp_rtoinfo rtoinfo;
 	struct sctp_association *asoc;
 	unsigned long rto_min, rto_max;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3096,18 +3033,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	if (copy_from_user(&rtoinfo, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, rtoinfo->srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && rtoinfo->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	rto_max = rtoinfo.srto_max;
-	rto_min = rtoinfo.srto_min;
+	rto_max = rtoinfo->srto_max;
+	rto_min = rtoinfo->srto_min;
 
 	if (rto_max)
 		rto_max = asoc ? msecs_to_jiffies(rto_max) : rto_max;
@@ -3123,17 +3057,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 		return -EINVAL;
 
 	if (asoc) {
-		if (rtoinfo.srto_initial != 0)
+		if (rtoinfo->srto_initial != 0)
 			asoc->rto_initial =
-				msecs_to_jiffies(rtoinfo.srto_initial);
+				msecs_to_jiffies(rtoinfo->srto_initial);
 		asoc->rto_max = rto_max;
 		asoc->rto_min = rto_min;
 	} else {
 		/* If there is no association or the association-id = 0
 		 * set the values to the endpoint.
 		 */
-		if (rtoinfo.srto_initial != 0)
-			sp->rtoinfo.srto_initial = rtoinfo.srto_initial;
+		if (rtoinfo->srto_initial != 0)
+			sp->rtoinfo.srto_initial = rtoinfo->srto_initial;
 		sp->rtoinfo.srto_max = rto_max;
 		sp->rtoinfo.srto_min = rto_min;
 	}
@@ -3152,26 +3086,25 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
  * See [SCTP] for more information.
  *
  */
-static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_associnfo(struct sock *sk,
+				     struct sctp_assocparams *assocparams,
+				     unsigned int optlen)
 {
 
-	struct sctp_assocparams assocparams;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&assocparams, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, assocparams->sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && assocparams->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (assocparams.sasoc_asocmaxrxt != 0) {
+		if (assocparams->sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3188,24 +3121,24 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    assocparams.sasoc_asocmaxrxt > path_sum)
+			    assocparams->sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = assocparams.sasoc_asocmaxrxt;
+			asoc->max_retrans = assocparams->sasoc_asocmaxrxt;
 		}
 
-		if (assocparams.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(assocparams.sasoc_cookie_life);
+		if (assocparams->sasoc_cookie_life != 0)
+			asoc->cookie_life = ms_to_ktime(assocparams->sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (assocparams.sasoc_asocmaxrxt != 0)
+		if (assocparams->sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt =
-						assocparams.sasoc_asocmaxrxt;
-		if (assocparams.sasoc_cookie_life != 0)
+						assocparams->sasoc_asocmaxrxt;
+		if (assocparams->sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life =
-						assocparams.sasoc_cookie_life;
+						assocparams->sasoc_cookie_life;
 	}
 	return 0;
 }
@@ -3220,16 +3153,14 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
  * addresses and a user will receive both PF_INET6 and PF_INET type
  * addresses on the socket.
  */
-static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_mappedv4(struct sock *sk, int *optval,
+				    unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (val)
+	if (*optval)
 		sp->v4mapped = 1;
 	else
 		sp->v4mapped = 0;
@@ -3264,10 +3195,11 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
  *    changed (effecting future associations only).
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
-static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_maxseg(struct sock *sk,
+				  struct sctp_assoc_value *params,
+				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int val;
 
@@ -3277,19 +3209,16 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		val = params.assoc_value;
+		val = *(int *)params;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
+	} else if (optlen != sizeof(struct sctp_assoc_value)) {
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
 
@@ -3324,12 +3253,12 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
  *   locally bound addresses. The following structure is used to make a
  *   set primary request:
  */
-static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
+					     struct sctp_setpeerprim *prim,
 					     unsigned int optlen)
 {
 	struct sctp_sock	*sp;
 	struct sctp_association	*asoc = NULL;
-	struct sctp_setpeerprim	prim;
 	struct sctp_chunk	*chunk;
 	struct sctp_af		*af;
 	int 			err;
@@ -3342,10 +3271,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -3358,26 +3284,26 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
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
 
@@ -3388,17 +3314,14 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	return err;
 }
 
-static int sctp_setsockopt_adaptation_layer(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_adaptation_layer(struct sock *sk,
+					    struct sctp_setadaptation *adaptation,
 					    unsigned int optlen)
 {
-	struct sctp_setadaptation adaptation;
-
 	if (optlen != sizeof(struct sctp_setadaptation))
 		return -EINVAL;
-	if (copy_from_user(&adaptation, optval, optlen))
-		return -EFAULT;
 
-	sctp_sk(sk)->adaptation_ind = adaptation.ssb_adaptation_ind;
+	sctp_sk(sk)->adaptation_ind = adaptation->ssb_adaptation_ind;
 
 	return 0;
 }
@@ -3417,40 +3340,38 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk, char __user *optval
  * received messages from the peer and does not effect the value that is
  * saved with outbound messages.
  */
-static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_context(struct sock *sk,
+				   struct sctp_assoc_value *params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
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
@@ -3480,17 +3401,13 @@ static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
  * incorrectly.
  */
 static int sctp_setsockopt_fragment_interleave(struct sock *sk,
-					       char __user *optval,
+					       int *optval,
 					       unsigned int optlen)
 {
-	int val;
-
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->frag_interleave = !!val;
+	sctp_sk(sk)->frag_interleave = !!*optval;
 
 	if (!sctp_sk(sk)->frag_interleave)
 		sctp_sk(sk)->ep->intl_enable = 0;
@@ -3516,23 +3433,19 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
  * message.
  */
 static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
-						  char __user *optval,
+						  u32 *optval,
 						  unsigned int optlen)
 {
-	u32 val;
-
 	if (optlen != sizeof(u32))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
 	/* Note: We double the receive buffer from what the user sets
 	 * it to be, also initial rwnd is based on rcvbuf/2.
 	 */
-	if (val > (sk->sk_rcvbuf >> 1))
+	if (*optval > (sk->sk_rcvbuf >> 1))
 		return -EINVAL;
 
-	sctp_sk(sk)->pd_point = val;
+	sctp_sk(sk)->pd_point = *optval;
 
 	return 0; /* is this the right error code? */
 }
@@ -3549,11 +3462,10 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
  * future associations inheriting the socket value.
  */
 static int sctp_setsockopt_maxburst(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_assoc_value *params,
 				    unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen == sizeof(int)) {
@@ -3562,37 +3474,34 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params.assoc_value, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-	} else
+		params->assoc_value = *(int *)params;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
+	} else if (optlen != sizeof(struct sctp_assoc_value)) {
 		return -EINVAL;
+	}
 
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
@@ -3605,21 +3514,18 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
  * will only effect future associations on the socket.
  */
 static int sctp_setsockopt_auth_chunk(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authchunk *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authchunk val;
 
 	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authchunk))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	switch (val.sauth_chunk) {
+	switch (val->sauth_chunk) {
 	case SCTP_CID_INIT:
 	case SCTP_CID_INIT_ACK:
 	case SCTP_CID_SHUTDOWN_COMPLETE:
@@ -3628,7 +3534,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	}
 
 	/* add this chunk id to the endpoint */
-	return sctp_auth_ep_add_chunkid(ep, val.sauth_chunk);
+	return sctp_auth_ep_add_chunkid(ep, val->sauth_chunk);
 }
 
 /*
@@ -3638,13 +3544,11 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
  * endpoint requires the peer to use.
  */
 static int sctp_setsockopt_hmac_ident(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_hmacalgo *hmacs,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_hmacalgo *hmacs;
 	u32 idents;
-	int err;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -3654,21 +3558,13 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, sizeof(struct sctp_hmacalgo) +
 					     SCTP_AUTH_NUM_HMACS * sizeof(u16));
 
-	hmacs = memdup_user(optval, optlen);
-	if (IS_ERR(hmacs))
-		return PTR_ERR(hmacs);
-
 	idents = hmacs->shmac_num_idents;
 	if (idents == 0 || idents > SCTP_AUTH_NUM_HMACS ||
 	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-	err = sctp_auth_ep_set_hmacs(ep, hmacs);
-out:
-	kfree(hmacs);
-	return err;
+	return sctp_auth_ep_set_hmacs(ep, hmacs);
 }
 
 /*
@@ -3678,11 +3574,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
  * association shared key.
  */
 static int sctp_setsockopt_auth_key(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_authkey *authkey,
 				    unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authkey *authkey;
 	struct sctp_association *asoc;
 	int ret = -EINVAL;
 
@@ -3693,10 +3588,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3733,7 +3624,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
+	memset(authkey, 0, optlen);
 	return ret;
 }
 
@@ -3744,42 +3635,39 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
  * the association shared key.
  */
 static int sctp_setsockopt_active_key(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authkeyid *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
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
@@ -3795,42 +3683,39 @@ static int sctp_setsockopt_active_key(struct sock *sk,
  * This set option will delete a shared secret key from use.
  */
 static int sctp_setsockopt_del_key(struct sock *sk,
-				   char __user *optval,
+				   struct sctp_authkeyid *val,
 				   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
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
@@ -3845,42 +3730,40 @@ static int sctp_setsockopt_del_key(struct sock *sk,
  *
  * This set option will deactivate a shared secret key.
  */
-static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_deactivate_key(struct sock *sk,
+					  struct sctp_authkeyid *val,
 					  unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
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
@@ -3904,26 +3787,23 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
  * Note. In this implementation, socket operation overrides default parameter
  * being set by sysctl as well as FreeBSD implementation
  */
-static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
-					unsigned int optlen)
+static int sctp_setsockopt_auto_asconf(struct sock *sk, int *optval,
+				       unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (!sctp_is_ep_boundall(sk) && val)
+	if (!sctp_is_ep_boundall(sk) && *optval)
 		return -EINVAL;
-	if ((val && sp->do_auto_asconf) || (!val && !sp->do_auto_asconf))
+	if ((*optval && sp->do_auto_asconf) || (!*optval && !sp->do_auto_asconf))
 		return 0;
 
 	spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
-	if (val == 0 && sp->do_auto_asconf) {
+	if (*optval == 0 && sp->do_auto_asconf) {
 		list_del(&sp->auto_asconf_list);
 		sp->do_auto_asconf = 0;
-	} else if (val && !sp->do_auto_asconf) {
+	} else if (*optval && !sp->do_auto_asconf) {
 		list_add_tail(&sp->auto_asconf_list,
 		    &sock_net(sk)->sctp.auto_asconf_splist);
 		sp->do_auto_asconf = 1;
@@ -3940,10 +3820,9 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrthlds_v2 *val,
 					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int len;
@@ -3951,165 +3830,143 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
 	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
 
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
 
-static int sctp_setsockopt_recvrcvinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *optval,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvrcvinfo = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->recvrcvinfo = (*optval == 0) ? 0 : 1;
 
 	return 0;
 }
 
-static int sctp_setsockopt_recvnxtinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *optval,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvnxtinfo = (val == 0) ? 0 : 1;
+	sctp_sk(sk)->recvnxtinfo = (*optval == 0) ? 0 : 1;
 
 	return 0;
 }
 
 static int sctp_setsockopt_pr_supported(struct sock *sk,
-					char __user *optval,
+					struct sctp_assoc_value *params,
 					unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
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
-					  char __user *optval,
+					  struct sctp_default_prinfo *info,
 					  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(info))
-		goto out;
-
-	if (copy_from_user(&info, optval, sizeof(info))) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*info))
 		goto out;
-	}
 
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
 
@@ -4118,27 +3975,21 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 }
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_assoc_value *params,
 					      unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4147,60 +3998,52 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_assoc_value *params,
 					   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
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
 
 static int sctp_setsockopt_reset_streams(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_reset_streams *params,
 					 unsigned int optlen)
 {
-	struct sctp_reset_streams *params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen < sizeof(*params))
 		return -EINVAL;
@@ -4208,42 +4051,27 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, USHRT_MAX +
 					     sizeof(__u16) * sizeof(*params));
 
-	params = memdup_user(optval, optlen);
-	if (IS_ERR(params))
-		return PTR_ERR(params);
-
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->srs_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_streams(asoc, params);
+		return -EINVAL;
 
-out:
-	kfree(params);
-	return retval;
+	return sctp_send_reset_streams(asoc, params);
 }
 
-static int sctp_setsockopt_reset_assoc(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	sctp_assoc_t associd;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(associd))
-		goto out;
-
-	if (copy_from_user(&associd, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*associd))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, associd);
+	asoc = sctp_id2assoc(sk, *associd);
 	if (!asoc)
 		goto out;
 
@@ -4254,70 +4082,59 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk,
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       char __user *optval,
+				       struct sctp_add_streams *params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_add_streams params;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
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
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_value params;
 	int retval = 0;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		return -EINVAL;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
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
@@ -4328,38 +4145,31 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler_value(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_stream_value *params,
 					   unsigned int optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen < sizeof(*params))
 		goto out;
-	}
 
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
@@ -4369,25 +4179,18 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  char __user *optval,
+						  struct sctp_assoc_value *params,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen < sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
@@ -4396,7 +4199,7 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 		goto out;
 	}
 
-	sp->ep->intl_enable = !!params.assoc_value;
+	sp->ep->intl_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4404,11 +4207,9 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 	return retval;
 }
 
-static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_reuse_port(struct sock *sk, int *optval,
 				      unsigned int optlen)
 {
-	int val;
-
 	if (!sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
 
@@ -4418,10 +4219,7 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->reuse = !!val;
+	sctp_sk(sk)->reuse = !!*optval;
 
 	return 0;
 }
@@ -4447,45 +4245,40 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
 	return 0;
 }
 
-static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 				 unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	int retval = 0;
 
-	if (optlen < sizeof(param))
+	if (optlen < sizeof(*param))
 		return -EINVAL;
 
-	optlen = sizeof(param);
-	if (copy_from_user(&param, optval, optlen))
-		return -EFAULT;
-
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
@@ -4496,29 +4289,23 @@ static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 }
 
 static int sctp_setsockopt_asconf_supported(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_assoc_value *params,
 					    unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
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
@@ -4532,29 +4319,23 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_assoc_value *params,
 					  unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
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
@@ -4564,7 +4345,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 		}
 	}
 
-	ep->auth_enable = !!params.assoc_value;
+	ep->auth_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4572,27 +4353,21 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_assoc_value *params,
 					 unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
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
@@ -4600,104 +4375,61 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
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
 
-/* API 6.2 setsockopt(), getsockopt()
- *
- * Applications use setsockopt() and getsockopt() to set or retrieve
- * socket options.  Socket options are used to change the default
- * behavior of sockets calls.  They are described in Section 7.
- *
- * The syntax is:
- *
- *   ret = getsockopt(int sd, int level, int optname, void __user *optval,
- *                    int __user *optlen);
- *   ret = setsockopt(int sd, int level, int optname, const void __user *optval,
- *                    int optlen);
- *
- *   sd      - the socket descript.
- *   level   - set to IPPROTO_SCTP for all SCTP options.
- *   optname - the option name.
- *   optval  - the buffer to store the value of the option.
- *   optlen  - the size of the buffer.
- */
-static int sctp_setsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, unsigned int optlen)
+static int kernel_sctp_setsockopt(struct sock *sk, int optname, void *optval,
+			   int optlen)
 {
 	int retval = 0;
 
-	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
-
-	/* I can hardly begin to describe how wrong this is.  This is
-	 * so broken as to be worse than useless.  The API draft
-	 * REALLY is NOT helpful here...  I am not convinced that the
-	 * semantics of setsockopt() with a level OTHER THAN SOL_SCTP
-	 * are at all well-founded.
-	 */
-	if (level != SOL_SCTP) {
-		struct sctp_af *af = sctp_sk(sk)->pf->af;
-		retval = af->setsockopt(sk, level, optname, optval, optlen);
-		goto out_nounlock;
-	}
-
 	lock_sock(sk);
 
 	switch (optname) {
 	case SCTP_SOCKOPT_BINDX_ADD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_ADD_ADDR);
+		retval = sctp_setsockopt_bindx(sk, optval, optlen,
+					       SCTP_BINDX_ADD_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_BINDX_REM:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_REM_ADDR);
+		retval = sctp_setsockopt_bindx(sk, optval, optlen,
+					       SCTP_BINDX_REM_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX_OLD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_connectx_old(sk,
-					    (struct sockaddr __user *)optval,
-					    optlen);
+		retval = sctp_setsockopt_connectx_old(sk, optval, optlen);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_connectx(sk,
-					    (struct sockaddr __user *)optval,
-					    optlen);
+		retval = sctp_setsockopt_connectx(sk, optval, optlen);
 		break;
 
 	case SCTP_DISABLE_FRAGMENTS:
@@ -4857,7 +4589,64 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
 	release_sock(sk);
 
-out_nounlock:
+	return retval;
+}
+
+/* API 6.2 setsockopt(), getsockopt()
+ *
+ * Applications use setsockopt() and getsockopt() to set or retrieve
+ * socket options.  Socket options are used to change the default
+ * behavior of sockets calls.  They are described in Section 7.
+ *
+ * The syntax is:
+ *
+ *   ret = getsockopt(int sd, int level, int optname, void __user *optval,
+ *                    int __user *optlen);
+ *   ret = setsockopt(int sd, int level, int optname, const void __user *optval,
+ *                    int optlen);
+ *
+ *   sd      - the socket descript.
+ *   level   - set to IPPROTO_SCTP for all SCTP options.
+ *   optname - the option name.
+ *   optval  - the buffer to store the value of the option.
+ *   optlen  - the size of the buffer.
+ */
+static int sctp_setsockopt(struct sock *sk, int level, int optname,
+			   char __user *u_optval, unsigned int optlen)
+{
+	u64 param_buf[8];
+	int retval = 0;
+	void *optval;
+
+	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
+
+	/* I can hardly begin to describe how wrong this is.  This is
+	 * so broken as to be worse than useless.  The API draft
+	 * REALLY is NOT helpful here...  I am not convinced that the
+	 * semantics of setsockopt() with a level OTHER THAN SOL_SCTP
+	 * are at all well-founded.
+	 */
+	if (level != SOL_SCTP) {
+		struct sctp_af *af = sctp_sk(sk)->pf->af;
+		return af->setsockopt(sk, level, optname, u_optval, optlen);
+	}
+
+	if (optlen < sizeof (param_buf)) {
+		if (copy_from_user(&param_buf, u_optval, optlen))
+			return -EFAULT;
+		optval = param_buf;
+	} else {
+		if (optlen > USHRT_MAX)
+			optlen = USHRT_MAX;
+		optval = memdup_user(u_optval, optlen);
+		if (IS_ERR(optval))
+			return PTR_ERR(optval);
+	}
+
+	retval = kernel_sctp_setsockopt(sk, optname, optval, optlen);
+	if (optval != param_buf)
+		kfree(optval);
+
 	return retval;
 }
 
@@ -5475,75 +5264,56 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
  * receipt.  This information is read-only.
  */
 static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
-				       char __user *optval,
-				       int __user *optlen)
+				       struct sctp_status *status,
+				       int *optlen)
 {
-	struct sctp_status status;
 	struct sctp_association *asoc = NULL;
 	struct sctp_transport *transport;
 	sctp_assoc_t associd;
-	int retval = 0;
 
-	if (len < sizeof(status)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (len < sizeof(*status))
+		return -EINVAL;
 
-	len = sizeof(status);
-	if (copy_from_user(&status, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	len = sizeof(*status);
 
-	associd = status.sstat_assoc_id;
+	associd = status->sstat_assoc_id;
 	asoc = sctp_id2assoc(sk, associd);
-	if (!asoc) {
-		retval = -EINVAL;
-		goto out;
-	}
-
+	if (!asoc)
+		return -EINVAL;
+
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
-
-	if (status.sstat_primary.spinfo_state == SCTP_UNKNOWN)
-		status.sstat_primary.spinfo_state = SCTP_ACTIVE;
-
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+		(union sctp_addr *)&status->sstat_primary.spinfo_address);
+	status->sstat_primary.spinfo_state = transport->state;
+	status->sstat_primary.spinfo_cwnd = transport->cwnd;
+	status->sstat_primary.spinfo_srtt = transport->srtt;
+	status->sstat_primary.spinfo_rto = jiffies_to_msecs(transport->rto);
+	status->sstat_primary.spinfo_mtu = transport->pathmtu;
 
-	pr_debug("%s: len:%d, state:%d, rwnd:%d, assoc_id:%d\n",
-		 __func__, len, status.sstat_state, status.sstat_rwnd,
-		 status.sstat_assoc_id);
+	if (status->sstat_primary.spinfo_state == SCTP_UNKNOWN)
+		status->sstat_primary.spinfo_state = SCTP_ACTIVE;
 
-	if (copy_to_user(optval, &status, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = len;
 
-out:
-	return retval;
+	pr_debug("%s: len:%d, state:%d, rwnd:%d, assoc_id:%d\n",
+		 __func__, len, status->sstat_state, status->sstat_rwnd,
+		 status->sstat_assoc_id);
+
+	return 0;
 }
 
 
@@ -5555,59 +5325,37 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
  * read-only.
  */
 static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_paddrinfo *pinfo,
+					  int *optlen)
 {
-	struct sctp_paddrinfo pinfo;
 	struct sctp_transport *transport;
-	int retval = 0;
 
-	if (len < sizeof(pinfo)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (len < sizeof(*pinfo))
+		return -EINVAL;
 
-	len = sizeof(pinfo);
-	if (copy_from_user(&pinfo, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	len = sizeof(*pinfo);
 
-	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
-					   pinfo.spinfo_assoc_id);
-	if (!transport) {
-		retval = -EINVAL;
-		goto out;
-	}
+	transport = sctp_addr_id2transport(sk, &pinfo->spinfo_address,
+					   pinfo->spinfo_assoc_id);
+	if (!transport)
+		return -EINVAL;
 
 	if (transport->state == SCTP_PF &&
-	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
-		retval = -EACCES;
-		goto out;
-	}
-
-	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
-	pinfo.spinfo_state = transport->state;
-	pinfo.spinfo_cwnd = transport->cwnd;
-	pinfo.spinfo_srtt = transport->srtt;
-	pinfo.spinfo_rto = jiffies_to_msecs(transport->rto);
-	pinfo.spinfo_mtu = transport->pathmtu;
-
-	if (pinfo.spinfo_state == SCTP_UNKNOWN)
-		pinfo.spinfo_state = SCTP_ACTIVE;
+	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE)
+		return -EACCES;
 
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	pinfo->spinfo_assoc_id = sctp_assoc2id(transport->asoc);
+	pinfo->spinfo_state = transport->state;
+	pinfo->spinfo_cwnd = transport->cwnd;
+	pinfo->spinfo_srtt = transport->srtt;
+	pinfo->spinfo_rto = jiffies_to_msecs(transport->rto);
+	pinfo->spinfo_mtu = transport->pathmtu;
 
-	if (copy_to_user(optval, &pinfo, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (pinfo->spinfo_state == SCTP_UNKNOWN)
+		pinfo->spinfo_state = SCTP_ACTIVE;
 
-out:
-	return retval;
+	*optlen = len;
+	return 0;
 }
 
 /* 7.1.12 Enable/Disable message fragmentation (SCTP_DISABLE_FRAGMENTS)
@@ -5618,19 +5366,10 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
  * instead a error will be indicated to the user.
  */
 static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
-					char __user *optval, int __user *optlen)
+					int *optval, int *optlen)
 {
-	int val;
-
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
-	val = (sctp_sk(sk)->disable_fragments == 1);
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = (sctp_sk(sk)->disable_fragments == 1);
 	return 0;
 }
 
@@ -5639,27 +5378,21 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
  * This socket option is used to specify various notifications and
  * ancillary data the user wishes to receive.
  */
-static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
-				  int __user *optlen)
+static int sctp_getsockopt_events(struct sock *sk, int len, u8 *sn_type,
+				  int *optlen)
 {
-	struct sctp_event_subscribe subscribe;
-	__u8 *sn_type = (__u8 *)&subscribe;
 	int i;
 
 	if (len == 0)
 		return -EINVAL;
 	if (len > sizeof(struct sctp_event_subscribe))
 		len = sizeof(struct sctp_event_subscribe);
-	if (put_user(len, optlen))
-		return -EFAULT;
+	*optlen = len;
 
 	for (i = 0; i < len; i++)
 		sn_type[i] = sctp_ulpevent_type_enabled(sctp_sk(sk)->subscribe,
 							SCTP_SN_TYPE_BASE + i);
 
-	if (copy_to_user(optval, &subscribe, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -5674,18 +5407,13 @@ static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_autoclose(struct sock *sk, int len, int *optval, int *optlen)
 {
 	/* Applicable to UDP-style socket only */
 	if (sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
-	if (len < sizeof(int))
-		return -EINVAL;
-	len = sizeof(int);
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (put_user(sctp_sk(sk)->autoclose, (int __user *)optval))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = sctp_sk(sk)->autoclose;
 	return 0;
 }
 
@@ -5748,13 +5476,13 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 
 	retval = sctp_do_peeloff(sk, peeloff->associd, &newsock);
 	if (retval < 0)
-		goto out;
+		return retval;
 
 	/* Map the socket to an unused fd that can be returned to the user.  */
 	retval = get_unused_fd_flags(flags & SOCK_CLOEXEC);
 	if (retval < 0) {
 		sock_release(newsock);
-		goto out;
+		return retval;
 	}
 
 	*newfile = sock_alloc_file(newsock, 0, NULL);
@@ -5772,76 +5500,43 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 
 	if (flags & SOCK_NONBLOCK)
 		(*newfile)->f_flags |= O_NONBLOCK;
-out:
+
+	/* If the copy_to_user() fail (because the addresse are redonly)
+	 * and the application catches the SIGSEGV that -EFAULT
+	 * generates it does 'lose' the fd number.
+	 * But it can never tell whether the SIGSEGV happened on the
+	 * copy_from_user() or the copy_to_user().
+	 */
+	fd_install(retval, *newfile);
 	return retval;
 }
 
-static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_peeloff(struct sock *sk, int len,
+				   sctp_peeloff_arg_t *peeloff, int *optlen)
 {
-	sctp_peeloff_arg_t peeloff;
 	struct file *newfile = NULL;
-	int retval = 0;
 
 	if (len < sizeof(sctp_peeloff_arg_t))
 		return -EINVAL;
-	len = sizeof(sctp_peeloff_arg_t);
-	if (copy_from_user(&peeloff, optval, len))
-		return -EFAULT;
-
-	retval = sctp_getsockopt_peeloff_common(sk, &peeloff, &newfile, 0);
-	if (retval < 0)
-		goto out;
+	*optlen = sizeof(sctp_peeloff_arg_t);
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
-		fput(newfile);
-		put_unused_fd(retval);
-		return -EFAULT;
-	}
-
-	if (copy_to_user(optval, &peeloff, len)) {
-		fput(newfile);
-		put_unused_fd(retval);
-		return -EFAULT;
-	}
-	fd_install(retval, newfile);
-out:
-	return retval;
+	return sctp_getsockopt_peeloff_common(sk, peeloff, &newfile, 0);
 }
 
 static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
-					 char __user *optval, int __user *optlen)
+					 sctp_peeloff_flags_arg_t *peeloff,
+					 int *optlen)
 {
-	sctp_peeloff_flags_arg_t peeloff;
 	struct file *newfile = NULL;
-	int retval = 0;
 
 	if (len < sizeof(sctp_peeloff_flags_arg_t))
 		return -EINVAL;
-	len = sizeof(sctp_peeloff_flags_arg_t);
-	if (copy_from_user(&peeloff, optval, len))
-		return -EFAULT;
-
-	retval = sctp_getsockopt_peeloff_common(sk, &peeloff.p_arg,
-						&newfile, peeloff.flags);
-	if (retval < 0)
-		goto out;
+	*optlen = sizeof(sctp_peeloff_flags_arg_t);
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
-		fput(newfile);
-		put_unused_fd(retval);
-		return -EFAULT;
-	}
-
-	if (copy_to_user(optval, &peeloff, len)) {
-		fput(newfile);
-		put_unused_fd(retval);
-		return -EFAULT;
-	}
-	fd_install(retval, newfile);
-out:
-	return retval;
+	return sctp_getsockopt_peeloff_common(sk, &peeloff->p_arg,
+					      &newfile, peeloff->flags);
 }
 
 /* 7.1.13 Peer Address Parameters (SCTP_PEER_ADDR_PARAMS)
@@ -5977,15 +5672,15 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
  *                     IPv4- or IPv6- layer setting.
  */
 static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
-					    char __user *optval, int __user *optlen)
+					    struct sctp_paddrparams *params,
+					    int *optlen)
 {
-	struct sctp_paddrparams  params;
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
@@ -5993,15 +5688,14 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	else
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+	*optlen = len;
 
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
@@ -6012,8 +5706,8 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
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
@@ -6021,66 +5715,60 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 
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
 
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6120,26 +5808,20 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
  *    value to 1 will disable the delayed sack algorithm.
  */
 static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
-					    char __user *optval,
-					    int __user *optlen)
+				       struct sctp_sack_info *params,
+				       int *optlen)
 {
-	struct sctp_sack_info    params;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 
 	if (len >= sizeof(struct sctp_sack_info)) {
 		len = sizeof(struct sctp_sack_info);
-
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else if (len == sizeof(struct sctp_assoc_value)) {
 		pr_warn_ratelimited(DEPRECATED
 				    "%s (pid %d) "
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else
 		return -EINVAL;
 
@@ -6147,38 +5829,34 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->sack_assoc_id);
+	if (!asoc && params->sack_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
+	*optlen = len;
+
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
 
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6193,45 +5871,36 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_getsockopt_initmsg(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_initmsg(struct sock *sk, int len, struct sctp_initmsg *optval, int *optlen)
 {
-	if (len < sizeof(struct sctp_initmsg))
-		return -EINVAL;
-	len = sizeof(struct sctp_initmsg);
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &sctp_sk(sk)->initmsg, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_initmsg);
+	*optval = sctp_sk(sk)->initmsg;
 	return 0;
 }
 
 
 static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
-				      char __user *optval, int __user *optlen)
+				      struct sctp_getaddrs *getaddrs,
+				      int *optlen)
 {
 	struct sctp_association *asoc;
 	int cnt = 0;
-	struct sctp_getaddrs getaddrs;
 	struct sctp_transport *from;
-	void __user *to;
+	void *to;
 	union sctp_addr temp;
 	struct sctp_sock *sp = sctp_sk(sk);
 	int addrlen;
 	size_t space_left;
-	int bytes_copied;
 
 	if (len < sizeof(struct sctp_getaddrs))
 		return -EINVAL;
 
-	if (copy_from_user(&getaddrs, optval, sizeof(struct sctp_getaddrs)))
-		return -EFAULT;
-
 	/* For UDP-style sockets, id specifies the association to query.  */
-	asoc = sctp_id2assoc(sk, getaddrs.assoc_id);
+	asoc = sctp_id2assoc(sk, getaddrs->assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
-	to = optval + offsetof(struct sctp_getaddrs, addrs);
+	to = &getaddrs->addrs;
 	space_left = len - offsetof(struct sctp_getaddrs, addrs);
 
 	list_for_each_entry(from, &asoc->peer.transport_addr_list,
@@ -6241,18 +5910,14 @@ static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
 			      ->addr_to_user(sp, &temp);
 		if (space_left < addrlen)
 			return -ENOMEM;
-		if (copy_to_user(to, &temp, addrlen))
-			return -EFAULT;
+		memcpy(to, &temp, addrlen);
 		to += addrlen;
 		cnt++;
 		space_left -= addrlen;
 	}
 
-	if (put_user(cnt, &((struct sctp_getaddrs __user *)optval)->addr_num))
-		return -EFAULT;
-	bytes_copied = ((char __user *)to) - optval;
-	if (put_user(bytes_copied, optlen))
-		return -EFAULT;
+	getaddrs->addr_num = cnt;
+	*optlen = len - space_left;
 
 	return 0;
 }
@@ -6303,14 +5968,13 @@ static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
 
 
 static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
-				       char __user *optval, int __user *optlen)
+				       struct sctp_getaddrs *getaddrs,
+				       int *optlen)
 {
 	struct sctp_bind_addr *bp;
 	struct sctp_association *asoc;
 	int cnt = 0;
-	struct sctp_getaddrs getaddrs;
 	struct sctp_sockaddr_entry *addr;
-	void __user *to;
 	union sctp_addr temp;
 	struct sctp_sock *sp = sctp_sk(sk);
 	int addrlen;
@@ -6323,31 +5987,24 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_getaddrs))
 		return -EINVAL;
 
-	if (copy_from_user(&getaddrs, optval, sizeof(struct sctp_getaddrs)))
-		return -EFAULT;
-
 	/*
 	 *  For UDP-style sockets, id specifies the association to query.
 	 *  If the id field is set to the value '0' then the locally bound
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
 
-	to = optval + offsetof(struct sctp_getaddrs, addrs);
+	addrs = &getaddrs->addrs;
 	space_left = len - offsetof(struct sctp_getaddrs, addrs);
 
-	addrs = kmalloc(space_left, GFP_USER | __GFP_NOWARN);
-	if (!addrs)
-		return -ENOMEM;
-
 	/* If the endpoint is bound to 0.0.0.0 or ::0, get the valid
 	 * addresses from the global local address list.
 	 */
@@ -6386,21 +6043,13 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	}
 
 copy_getaddrs:
-	if (copy_to_user(to, addrs, bytes_copied)) {
-		err = -EFAULT;
-		goto out;
-	}
-	if (put_user(cnt, &((struct sctp_getaddrs __user *)optval)->addr_num)) {
-		err = -EFAULT;
-		goto out;
-	}
-	/* XXX: We should have accounted for sizeof(struct sctp_getaddrs) too,
-	 * but we can't change it anymore.
+	getaddrs->addr_num = cnt;
+	/* XXX: For compatibility with the original broken code
+	 * sizeof(struct sctp_getaddrs) has to be subracted off *optlen
+	 * after the buffer is copied but before the length is returned.
 	 */
-	if (put_user(bytes_copied, optlen))
-		err = -EFAULT;
+	*optlen = sizeof(struct sctp_getaddrs) + bytes_copied;
 out:
-	kfree(addrs);
 	return err;
 }
 
@@ -6411,37 +6060,28 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
  * association peer's addresses.
  */
 static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
-					char __user *optval, int __user *optlen)
+					struct sctp_prim *prim, int *optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_association *asoc;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (len < sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	len = sizeof(struct sctp_prim);
-
-	if (copy_from_user(&prim, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_prim);
 
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
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &prim, len))
-		return -EFAULT;
+			(union sctp_addr *)&prim->ssp_addr);
 
 	return 0;
 }
@@ -6453,21 +6093,12 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
  * Indication parameter for all future INIT and INIT-ACK exchanges.
  */
 static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  struct sctp_setadaptation *adaptation,
+				  int *optlen)
 {
-	struct sctp_setadaptation adaptation;
+	*optlen = sizeof(struct sctp_setadaptation);
 
-	if (len < sizeof(struct sctp_setadaptation))
-		return -EINVAL;
-
-	len = sizeof(struct sctp_setadaptation);
-
-	adaptation.ssb_adaptation_ind = sctp_sk(sk)->adaptation_ind;
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &adaptation, len))
-		return -EFAULT;
+	adaptation->ssb_adaptation_ind = sctp_sk(sk)->adaptation_ind;
 
 	return 0;
 }
@@ -6492,45 +6123,36 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
  *   For getsockopt, it get the default sctp_sndrcvinfo structure.
  */
 static int sctp_getsockopt_default_send_param(struct sock *sk,
-					int len, char __user *optval,
-					int __user *optlen)
+					int len, struct sctp_sndrcvinfo *info,
+					int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
-	if (len < sizeof(info))
+	if (len < sizeof(*info))
 		return -EINVAL;
 
-	len = sizeof(info);
-
-	if (copy_from_user(&info, optval, len))
-		return -EFAULT;
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
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &info, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6538,43 +6160,34 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_sndinfo *info,
+					   int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
-	if (len < sizeof(info))
+	if (len < sizeof(*info))
 		return -EINVAL;
 
-	len = sizeof(info);
-
-	if (copy_from_user(&info, optval, len))
-		return -EFAULT;
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
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &info, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6589,19 +6202,10 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
  */
 
 static int sctp_getsockopt_nodelay(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   int *optval, int *optlen)
 {
-	int val;
-
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
-	val = (sctp_sk(sk)->nodelay == 1);
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = (sctp_sk(sk)->nodelay == 1);
 	return 0;
 }
 
@@ -6618,45 +6222,35 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
-				char __user *optval,
-				int __user *optlen) {
-	struct sctp_rtoinfo rtoinfo;
+				   struct sctp_rtoinfo *rtoinfo, int *optlen)
+{
 	struct sctp_association *asoc;
 
 	if (len < sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	len = sizeof(struct sctp_rtoinfo);
-
-	if (copy_from_user(&rtoinfo, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_rtoinfo);
 
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, rtoinfo->srto_assoc_id);
 
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && rtoinfo->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values corresponding to the specific association. */
 	if (asoc) {
-		rtoinfo.srto_initial = jiffies_to_msecs(asoc->rto_initial);
-		rtoinfo.srto_max = jiffies_to_msecs(asoc->rto_max);
-		rtoinfo.srto_min = jiffies_to_msecs(asoc->rto_min);
+		rtoinfo->srto_initial = jiffies_to_msecs(asoc->rto_initial);
+		rtoinfo->srto_max = jiffies_to_msecs(asoc->rto_max);
+		rtoinfo->srto_min = jiffies_to_msecs(asoc->rto_min);
 	} else {
 		/* Values corresponding to the endpoint. */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		rtoinfo.srto_initial = sp->rtoinfo.srto_initial;
-		rtoinfo.srto_max = sp->rtoinfo.srto_max;
-		rtoinfo.srto_min = sp->rtoinfo.srto_min;
+		rtoinfo->srto_initial = sp->rtoinfo.srto_initial;
+		rtoinfo->srto_max = sp->rtoinfo.srto_max;
+		rtoinfo->srto_min = sp->rtoinfo.srto_min;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &rtoinfo, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6672,11 +6266,10 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_associnfo(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assocparams *assocparams,
+				     int *optlen)
 {
 
-	struct sctp_assocparams assocparams;
 	struct sctp_association *asoc;
 	struct list_head *pos;
 	int cnt = 0;
@@ -6684,49 +6277,40 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 	if (len < sizeof (struct sctp_assocparams))
 		return -EINVAL;
 
-	len = sizeof(struct sctp_assocparams);
-
-	if (copy_from_user(&assocparams, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_assocparams);
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, assocparams->sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && assocparams->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values correspoinding to the specific association */
 	if (asoc) {
-		assocparams.sasoc_asocmaxrxt = asoc->max_retrans;
-		assocparams.sasoc_peer_rwnd = asoc->peer.rwnd;
-		assocparams.sasoc_local_rwnd = asoc->a_rwnd;
-		assocparams.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
+		assocparams->sasoc_asocmaxrxt = asoc->max_retrans;
+		assocparams->sasoc_peer_rwnd = asoc->peer.rwnd;
+		assocparams->sasoc_local_rwnd = asoc->a_rwnd;
+		assocparams->sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
 
 		list_for_each(pos, &asoc->peer.transport_addr_list) {
 			cnt++;
 		}
 
-		assocparams.sasoc_number_peer_destinations = cnt;
+		assocparams->sasoc_number_peer_destinations = cnt;
 	} else {
 		/* Values corresponding to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		assocparams.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
-		assocparams.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
-		assocparams.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
-		assocparams.sasoc_cookie_life =
+		assocparams->sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
+		assocparams->sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
+		assocparams->sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
+		assocparams->sasoc_cookie_life =
 					sp->assocparams.sasoc_cookie_life;
-		assocparams.sasoc_number_peer_destinations =
+		assocparams->sasoc_number_peer_destinations =
 					sp->assocparams.
 					sasoc_number_peer_destinations;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &assocparams, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6741,20 +6325,12 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
  * addresses on the socket.
  */
 static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    int *optval, int *optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
-	val = sp->v4mapped;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = sp->v4mapped;
 
 	return 0;
 }
@@ -6764,31 +6340,19 @@ static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_context())
  */
 static int sctp_getsockopt_context(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   struct sctp_assoc_value *params, int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
-	if (len < sizeof(struct sctp_assoc_value))
-		return -EINVAL;
-
-	len = sizeof(struct sctp_assoc_value);
-
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_assoc_value);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	params.assoc_value = asoc ? asoc->default_rcv_context
-				  : sctp_sk(sk)->default_rcv_context;
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
+	params->assoc_value = asoc ? asoc->default_rcv_context
+				   : sctp_sk(sk)->default_rcv_context;
 
 	return 0;
 }
@@ -6821,9 +6385,8 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
 static int sctp_getsockopt_maxseg(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  struct sctp_assoc_value *params, int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (len == sizeof(int)) {
@@ -6832,33 +6395,26 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	*optlen = len;
+
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
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (len == sizeof(int)) {
-		if (copy_to_user(optval, &params.assoc_value, len))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(optval, &params, len))
-			return -EFAULT;
-	}
+	if (len == sizeof(int))
+		*(int *)params = params->assoc_value;
 
 	return 0;
 }
@@ -6868,20 +6424,10 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_fragment_interleave())
  */
 static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
-					       char __user *optval, int __user *optlen)
+					       int *optval, int *optlen)
 {
-	int val;
-
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
-
-	val = sctp_sk(sk)->frag_interleave;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = sctp_sk(sk)->frag_interleave;
 
 	return 0;
 }
@@ -6891,21 +6437,10 @@ static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_partial_delivery_point())
  */
 static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
-						  char __user *optval,
-						  int __user *optlen)
+						  u32 *optval, int *optlen)
 {
-	u32 val;
-
-	if (len < sizeof(u32))
-		return -EINVAL;
-
-	len = sizeof(u32);
-
-	val = sctp_sk(sk)->pd_point;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(u32);
+	*optval = sctp_sk(sk)->pd_point;
 
 	return 0;
 }
@@ -6915,10 +6450,9 @@ static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_maxburst())
  */
 static int sctp_getsockopt_maxburst(struct sock *sk, int len,
-				    char __user *optval,
-				    int __user *optlen)
+				    struct sctp_assoc_value *params,
+				    int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (len == sizeof(int)) {
@@ -6927,38 +6461,31 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 				    "Use of int in max_burst socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else
 		return -EINVAL;
+	*optlen = len;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	params.assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
+	params->assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
 
-	if (len == sizeof(int)) {
-		if (copy_to_user(optval, &params.assoc_value, len))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(optval, &params, len))
-			return -EFAULT;
-	}
+	if (len == sizeof(int))
+		*(int *)params = params->assoc_value;
 
 	return 0;
 
 }
 
 static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    struct sctp_hmacalgo *p, int *optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_hmacalgo  __user *p = (void __user *)optval;
 	struct sctp_hmac_algo_param *hmacs;
 	__u16 data_len = 0;
 	u32 num_idents;
@@ -6977,73 +6504,50 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 	len = sizeof(struct sctp_hmacalgo) + data_len;
 	num_idents = data_len / sizeof(u16);
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (put_user(num_idents, &p->shmac_num_idents))
-		return -EFAULT;
-	for (i = 0; i < num_idents; i++) {
-		__u16 hmacid = ntohs(hmacs->hmac_ids[i]);
+	*optlen = len;
+	p->shmac_num_idents = num_idents;
+	for (i = 0; i < num_idents; i++)
+		p->shmac_idents[i] = ntohs(hmacs->hmac_ids[i]);
 
-		if (copy_to_user(&p->shmac_idents[i], &hmacid, sizeof(__u16)))
-			return -EFAULT;
-	}
 	return 0;
 }
 
 static int sctp_getsockopt_active_key(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    struct sctp_authkeyid *val, int *optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
 
-	if (len < sizeof(struct sctp_authkeyid))
-		return -EINVAL;
-
-	len = sizeof(struct sctp_authkeyid);
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_authkeyid);
 
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
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
-
 	return 0;
 }
 
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    struct sctp_authchunks *p, int *optlen)
 {
-	struct sctp_authchunks __user *p = (void __user *)optval;
-	struct sctp_authchunks val;
 	struct sctp_association *asoc;
 	struct sctp_chunks_param *ch;
 	u32    num_chunks = 0;
-	char __user *to;
 
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(val)))
-		return -EFAULT;
-
-	to = p->gauth_chunks;
-	asoc = sctp_id2assoc(sk, val.gauth_assoc_id);
+	asoc = sctp_id2assoc(sk, p->gauth_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -7056,40 +6560,30 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 
 	/* See if the user provided enough room for all the data */
 	num_chunks = ntohs(ch->param_hdr.length) - sizeof(struct sctp_paramhdr);
-	if (len < num_chunks)
+	if (len < sizeof(struct sctp_authchunks) + num_chunks)
 		return -EINVAL;
 
-	if (copy_to_user(to, ch->chunks, num_chunks))
-		return -EFAULT;
+	memcpy(p->gauth_chunks, ch->chunks, num_chunks);
 num:
-	len = sizeof(struct sctp_authchunks) + num_chunks;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (put_user(num_chunks, &p->gauth_number_of_chunks))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_authchunks) + num_chunks;
+
+	p->gauth_number_of_chunks = num_chunks;
 	return 0;
 }
 
 static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    struct sctp_authchunks *p, int *optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authchunks __user *p = (void __user *)optval;
-	struct sctp_authchunks val;
 	struct sctp_association *asoc;
 	struct sctp_chunks_param *ch;
 	u32    num_chunks = 0;
-	char __user *to;
 
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(val)))
-		return -EFAULT;
-
-	to = p->gauth_chunks;
-	asoc = sctp_id2assoc(sk, val.gauth_assoc_id);
-	if (!asoc && val.gauth_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, p->gauth_assoc_id);
+	if (!asoc && p->gauth_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
@@ -7109,14 +6603,10 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_authchunks) + num_chunks)
 		return -EINVAL;
 
-	if (copy_to_user(to, ch->chunks, num_chunks))
-		return -EFAULT;
+	memcpy(p->gauth_chunks, ch->chunks, num_chunks);
 num:
-	len = sizeof(struct sctp_authchunks) + num_chunks;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (put_user(num_chunks, &p->gauth_number_of_chunks))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_authchunks) + num_chunks;
+	p->gauth_number_of_chunks = num_chunks;
 
 	return 0;
 }
@@ -7127,7 +6617,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
  * to a one-to-many style socket.  The option value is an uint32_t.
  */
 static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+					u32 *optval, int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -7136,19 +6626,13 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
 	if (sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
 
-	if (len < sizeof(u32))
-		return -EINVAL;
-
-	len = sizeof(u32);
+	*optlen = sizeof(u32);
 
 	list_for_each_entry(asoc, &(sp->ep->asocs), asocs) {
 		val++;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optval = val;
 
 	return 0;
 }
@@ -7158,20 +6642,14 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
  * See the corresponding setsockopt entry as description
  */
 static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				       int *optval, int *optlen)
 {
 	int val = 0;
 
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
+	*optlen = sizeof(int);
 	if (sctp_sk(sk)->do_auto_asconf && sctp_is_ep_boundall(sk))
 		val = 1;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optval = val;
 	return 0;
 }
 
@@ -7183,11 +6661,10 @@ static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
  * the SCTP associations handled by a one-to-many style socket.
  */
 static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				     struct sctp_assoc_ids *ids, int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_ids *ids;
 	u32 num = 0;
 
 	if (sctp_style(sk, TCP))
@@ -7205,22 +6682,14 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 
 	len = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
 
-	ids = kmalloc(len, GFP_USER | __GFP_NOWARN);
-	if (unlikely(!ids))
-		return -ENOMEM;
-
 	ids->gaids_number_of_ids = num;
 	num = 0;
 	list_for_each_entry(asoc, &(sp->ep->asocs), asocs) {
 		ids->gaids_assoc_id[num++] = asoc->assoc_id;
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, ids, len)) {
-		kfree(ids);
-		return -EFAULT;
-	}
+	*optlen = len;
 
-	kfree(ids);
 	return 0;
 }
 
@@ -7232,54 +6701,50 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval, int len,
-					    int __user *optlen, bool v2)
+					    struct sctp_paddrthlds_v2 *val,
+					    int len, int *optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int min;
 
-	min = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	min = v2 ? sizeof(*val) : sizeof(struct sctp_paddrthlds);
 	if (len < min)
 		return -EINVAL;
 	len = min;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
 
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
-	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = len;
 
 	return 0;
 }
@@ -7291,10 +6756,9 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
  * after OpenSolaris' implementation
  */
 static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
-				       char __user *optval,
-				       int __user *optlen)
+				       struct sctp_assoc_stats *sas,
+				       int *optlen)
 {
-	struct sctp_assoc_stats sas;
 	struct sctp_association *asoc = NULL;
 
 	/* User must provide at least the assoc id */
@@ -7302,230 +6766,151 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 		return -EINVAL;
 
 	/* Allow the struct to grow and fill in as much as possible */
-	len = min_t(size_t, len, sizeof(sas));
-
-	if (copy_from_user(&sas, optval, len))
-		return -EFAULT;
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
-	memcpy(&sas.sas_obs_rto_ipaddr, &asoc->stats.obs_rto_ipaddr,
-		sizeof(struct sockaddr_storage));
+	sas->sas_maxrto = asoc->stats.max_obs_rto;
+	sas->sas_obs_rto_ipaddr = asoc->stats.obs_rto_ipaddr;
 
 	/* Mark beginning of a new observation period */
 	asoc->stats.max_obs_rto = asoc->rto_min;
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
-
-	if (copy_to_user(optval, &sas, len))
-		return -EFAULT;
+	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas->sas_assoc_id);
 
 	return 0;
 }
 
-static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
-				       char __user *optval,
-				       int __user *optlen)
+static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len, int *optval,
+				       int *optlen)
 {
 	int val = 0;
 
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
+	*optlen = sizeof(int);
 	if (sctp_sk(sk)->recvrcvinfo)
 		val = 1;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optval = val;
 
 	return 0;
 }
 
-static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len,
-				       char __user *optval,
-				       int __user *optlen)
+static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len, int *optval,
+				       int *optlen)
 {
 	int val = 0;
 
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
+	*optlen = sizeof(int);
 	if (sctp_sk(sk)->recvnxtinfo)
 		val = 1;
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optval = val;
 
 	return 0;
 }
 
 static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
-					char __user *optval,
-					int __user *optlen)
+					struct sctp_assoc_value *params,
+					int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	params->assoc_value = asoc ? asoc->peer.prsctp_capable
+				   : sctp_sk(sk)->ep->prsctp_enable;
 
-	params.assoc_value = asoc ? asoc->peer.prsctp_capable
-				  : sctp_sk(sk)->ep->prsctp_enable;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
-	retval = 0;
-
-out:
-	return retval;
-}
+	return 0;
+}
 
 static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_default_prinfo *info,
+					  int *optlen)
 {
-	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
-	if (len < sizeof(info)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(info);
-	if (copy_from_user(&info, optval, len))
-		goto out;
+	*optlen = sizeof(*info);
 
-	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
-	if (!asoc && info.pr_assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
+	if (!asoc && info->pr_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
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
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &info, len))
-		goto out;
-
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_prstatus *params,
+					  int *optlen)
 {
-	struct sctp_prstatus params;
 	struct sctp_association *asoc;
 	int policy;
 	int retval = -EINVAL;
 
-	if (len < sizeof(params))
+	if (len < sizeof(*params))
 		goto out;
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
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
 
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	if (copy_to_user(optval, &params, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	retval = 0;
 
 out:
@@ -7533,504 +6918,261 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_prstatus *params,
+					   int *optlen)
 {
 	struct sctp_stream_out_ext *streamoute;
 	struct sctp_association *asoc;
-	struct sctp_prstatus params;
-	int retval = -EINVAL;
 	int policy;
 
-	if (len < sizeof(params))
-		goto out;
+	if (len < sizeof(*params))
+		return -EINVAL;
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	policy = params.sprstat_policy;
+	policy = params->sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
 	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
-		goto out;
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
-	if (!asoc || params.sprstat_sid >= asoc->stream.outcnt)
-		goto out;
+	asoc = sctp_id2assoc(sk, params->sprstat_assoc_id);
+	if (!asoc || params->sprstat_sid >= asoc->stream.outcnt)
+		return -EINVAL;
 
-	streamoute = SCTP_SO(&asoc->stream, params.sprstat_sid)->ext;
-	if (!streamoute) {
+	params->sprstat_abandoned_unsent = 0;
+	params->sprstat_abandoned_sent = 0;
+
+	streamoute = SCTP_SO(&asoc->stream, params->sprstat_sid)->ext;
+	if (!streamoute)
 		/* Not allocated yet, means all stats are 0 */
-		params.sprstat_abandoned_unsent = 0;
-		params.sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
-	}
+		return 0;
 
 	if (policy == SCTP_PR_SCTP_ALL) {
-		params.sprstat_abandoned_unsent = 0;
-		params.sprstat_abandoned_sent = 0;
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
 
-	if (put_user(len, optlen) || copy_to_user(optval, &params, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
-					      char __user *optval,
-					      int __user *optlen)
+					      struct sctp_assoc_value *params,
+					      int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	params.assoc_value = asoc ? asoc->peer.reconf_capable
-				  : sctp_sk(sk)->ep->reconf_enable;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->peer.reconf_capable
+				   : sctp_sk(sk)->ep->reconf_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_assoc_value *params,
+					   int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
 
-	params.assoc_value = asoc ? asoc->strreset_enable
-				  : sctp_sk(sk)->ep->strreset_enable;
+	*optlen = sizeof(*params);
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->strreset_enable
+				   : sctp_sk(sk)->ep->strreset_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_scheduler(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assoc_value *params,
+				     int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	params.assoc_value = asoc ? sctp_sched_get_sched(asoc)
-				  : sctp_sk(sk)->default_ss;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? sctp_sched_get_sched(asoc)
+				   : sctp_sk(sk)->default_ss;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_stream_value *params,
+					   int *optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	retval = sctp_sched_get_value(asoc, params.stream_id,
-				      &params.stream_value);
-	if (retval)
-		goto out;
 
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	if (copy_to_user(optval, &params, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc)
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_sched_get_value(asoc, params->stream_id,
+				      &params->stream_value);
 }
 
 static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
-						  char __user *optval,
-						  int __user *optlen)
+						  struct sctp_assoc_value *params,
+						  int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(*params);
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	params.assoc_value = asoc ? asoc->peer.intl_capable
-				  : sctp_sk(sk)->ep->intl_enable;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->peer.intl_capable
+				   : sctp_sk(sk)->ep->intl_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
-				      char __user *optval,
-				      int __user *optlen)
+				      int *optval,
+				      int *optlen)
 {
-	int val;
-
-	if (len < sizeof(int))
-		return -EINVAL;
-
-	len = sizeof(int);
-	val = sctp_sk(sk)->reuse;
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
+	*optlen = sizeof(int);
+	*optval = sctp_sk(sk)->reuse;
 
 	return 0;
 }
 
-static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
-				 int __user *optlen)
+static int sctp_getsockopt_event(struct sock *sk, int len,
+				 struct sctp_event *param,
+				 int *optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	__u16 subscribe;
 
-	if (len < sizeof(param))
+	if (len < sizeof(*param))
 		return -EINVAL;
 
-	len = sizeof(param);
-	if (copy_from_user(&param, optval, len))
-		return -EFAULT;
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
-
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &param, len))
-		return -EFAULT;
+	param->se_on = sctp_ulpevent_type_enabled(subscribe, param->se_type);
 
 	return 0;
 }
 
 static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
-					    char __user *optval,
-					    int __user *optlen)
+					    struct sctp_assoc_value *params,
+					    int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	params.assoc_value = asoc ? asoc->peer.asconf_capable
-				  : sctp_sk(sk)->ep->asconf_enable;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->peer.asconf_capable
+				   : sctp_sk(sk)->ep->asconf_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_assoc_value *params,
+					  int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	params.assoc_value = asoc ? asoc->peer.auth_capable
-				  : sctp_sk(sk)->ep->auth_enable;
 
-	if (put_user(len, optlen))
-		goto out;
+	*optlen = sizeof(*params);
 
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->peer.auth_capable
+				   : sctp_sk(sk)->ep->auth_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
-					 char __user *optval,
-					 int __user *optlen)
+					 struct sctp_assoc_value *params,
+					 int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	*optlen = sizeof(*params);
 
-	params.assoc_value = asoc ? asoc->peer.ecn_capable
-				  : sctp_sk(sk)->ep->ecn_enable;
-
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->peer.ecn_capable
+				   : sctp_sk(sk)->ep->ecn_enable;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assoc_value *params,
+				     int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
-
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
 
-	params.assoc_value = asoc ? asoc->pf_expose
-				  : sctp_sk(sk)->pf_expose;
+	*optlen = sizeof(*params);
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	retval = 0;
+	params->assoc_value = asoc ? asoc->pf_expose
+				   : sctp_sk(sk)->pf_expose;
 
-out:
-	return retval;
+	return 0;
 }
 
-static int sctp_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen)
+int kernel_sctp_getsockopt(struct sock *sk, int optname, int len, void *optval,
+			   int *optlen)
 {
-	int retval = 0;
-	int len;
-
-	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
-
-	/* I can hardly begin to describe how wrong this is.  This is
-	 * so broken as to be worse than useless.  The API draft
-	 * REALLY is NOT helpful here...  I am not convinced that the
-	 * semantics of getsockopt() with a level OTHER THAN SOL_SCTP
-	 * are at all well-founded.
-	 */
-	if (level != SOL_SCTP) {
-		struct sctp_af *af = sctp_sk(sk)->pf->af;
-
-		retval = af->getsockopt(sk, level, optname, optval, optlen);
-		return retval;
-	}
-
-	if (get_user(len, optlen))
-		return -EFAULT;
-
-	if (len < 0)
-		return -EINVAL;
+	int retval;
 
 	lock_sock(sk);
 
@@ -8234,6 +7376,81 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	return retval;
 }
 
+static int sctp_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *u_optval, int __user *u_optlen)
+{
+	u64 param_buf[8];
+	int retval = 0;
+	void *optval;
+	int len, optlen;
+
+	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
+
+	/* I can hardly begin to describe how wrong this is.  This is
+	 * so broken as to be worse than useless.  The API draft
+	 * REALLY is NOT helpful here...  I am not convinced that the
+	 * semantics of getsockopt() with a level OTHER THAN SOL_SCTP
+	 * are at all well-founded.
+	 */
+	if (level != SOL_SCTP) {
+		struct sctp_af *af = sctp_sk(sk)->pf->af;
+
+		retval = af->getsockopt(sk, level, optname, u_optval, u_optlen);
+		return retval;
+	}
+
+	if (get_user(len, u_optlen))
+		return -EFAULT;
+
+	if (len < 0)
+		return -EINVAL;
+
+	/* Many options are RMW so we must read in the user buffer.
+	 * For safetly we need to initialise it to avoid leaking
+	 * kernel data - the copy does this as well.
+	 * To simplify the processing of simple options the buffer length
+	 * check is repeated after the request is actioned.
+	 */
+	if (len < sizeof (param_buf)) {
+		/* Zero first bytes to stop KASAN complaining. */
+		param_buf[0] = 0;
+		if (copy_from_user(&param_buf, u_optval, len))
+			return -EFAULT;
+		optval = param_buf;
+	} else {
+		if (len > USHRT_MAX)
+			len = USHRT_MAX;
+		optval = memdup_user(u_optval, len);
+		if (IS_ERR(optval))
+			return PTR_ERR(optval);
+	}
+
+	optlen = 0;
+	retval = kernel_sctp_getsockopt(sk, optname, len, optval, &optlen);
+	if (optlen > len) {
+		BUG_ON(optlen > sizeof (param_buf));
+		if (retval >= 0)
+			retval = -EINVAL;
+	}
+
+	if (retval >= 0 || retval == -EINPROGRESS) {
+		if (optlen > 0 && copy_to_user(u_optval, optval, optlen))
+			retval = -EFAULT;
+
+		/* XXX SCTP_GET_LOCAL_ADDRS has to return the wrong length */
+		if (optname == SCTP_GET_LOCAL_ADDRS)
+			optlen -= sizeof(struct sctp_getaddrs);
+
+		if (optlen != len && put_user(optlen, u_optlen))
+			retval = -EFAULT;
+	}
+
+	if (optval != param_buf)
+		kfree(optval);
+		
+	return retval;
+}
+
 static int sctp_hash(struct sock *sk)
 {
 	/* STUB */
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

