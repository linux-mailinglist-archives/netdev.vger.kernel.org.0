Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC841E2744
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEZQka convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:40:30 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:24124 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728598AbgEZQk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:40:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-247-jYhcwi7yNDu5Ky8GI5JIFg-1; Tue, 26 May 2020 17:40:17 +0100
X-MC-Unique: jYhcwi7yNDu5Ky8GI5JIFg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:16 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 2/8] sctp: setsockopt, move usercopies into a
 wrapper.
Thread-Topic: [PATCH v3 net-next 2/8] sctp: setsockopt, move usercopies into a
 wrapper.
Thread-Index: AdYzewdqaLLDpKr8S+mr3xGmDCSQ3Q==
Date:   Tue, 26 May 2020 16:40:16 +0000
Message-ID: <a5e9759663364cbcb3bbbb0962e2b99f@AcuMS.aculab.com>
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

Pull the user copies out of the setsockopt() sub-functions.
Diff minimised by using #define params (*params).
The #define are removed in the next patch.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 535 +++++++++++++++++++-----------------------------------
 1 file changed, 187 insertions(+), 348 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c1c8215..639d7da 100644
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
@@ -977,20 +976,15 @@ static int sctp_setsockopt_bindx(struct sock *sk,
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
 		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
 			return -EINVAL;
 		}
 
@@ -1037,8 +1031,6 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	}
 
 out:
-	kfree(kaddrs);
-
 	return err;
 }
 
@@ -1287,24 +1279,19 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
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
@@ -1321,8 +1308,6 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
 
 out_free:
-	kfree(kaddrs);
-
 	return err;
 }
 
@@ -1331,7 +1316,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
  * to the option that doesn't provide association id.
  */
 static int sctp_setsockopt_connectx_old(struct sock *sk,
-					struct sockaddr __user *addrs,
+					struct sockaddr *addrs,
 					int addrs_size)
 {
 	return __sctp_setsockopt_connectx(sk, addrs, addrs_size, NULL);
@@ -1344,7 +1329,7 @@ static int sctp_setsockopt_connectx_old(struct sock *sk,
  * always positive.
  */
 static int sctp_setsockopt_connectx(struct sock *sk,
-				    struct sockaddr __user *addrs,
+				    struct sockaddr *addrs,
 				    int addrs_size)
 {
 	sctp_assoc_t assoc_id = 0;
@@ -1380,6 +1365,7 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 {
 	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
+	struct sockaddr *addrs;
 	int err = 0;
 
 #ifdef CONFIG_COMPAT
@@ -1403,9 +1389,13 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 			return -EFAULT;
 	}
 
-	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
-					 param.addrs, param.addr_num,
+	addrs = memdup_user(param.addrs, param.addr_num);
+	if (IS_ERR(addrs))
+		return PTR_ERR(addrs);
+
+	err = __sctp_setsockopt_connectx(sk, addrs, param.addr_num,
 					 &assoc_id);
+	kfree(addrs);
 	if (err == 0 || err == -EINPROGRESS) {
 		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
 			return -EFAULT;
@@ -2188,27 +2178,20 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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
@@ -2216,9 +2199,6 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
 
-	if (copy_from_user(&subscribe, optval, optlen))
-		return -EFAULT;
-
 	for (i = 0; i < optlen; i++)
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
@@ -2258,7 +2238,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, int *optval,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2269,8 +2249,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
+
+	sp->autoclose = *optval;
 
 	if (sp->autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
@@ -2605,28 +2585,23 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 	return 0;
 }
 
+#define params (*params)
 static int sctp_setsockopt_peer_addr_params(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrparams params,
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
+	if (optlen != sizeof(params)) {
+		if (optlen != ALIGN(offsetof(struct sctp_paddrparams,
+						    spp_ipv6_flowlabel), 4))
+			return -EINVAL;
 		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
 			return -EINVAL;
-	} else {
-		return -EINVAL;
 	}
 
 	/* Validate flags and value parameters. */
@@ -2689,6 +2664,7 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 
 	return 0;
 }
+#undef params
 
 static inline __u32 sctp_spp_sackdelay_enable(__u32 param_flags)
 {
@@ -2773,17 +2749,15 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  *    value to 1 will disable the delayed sack algorithm.
  */
 
+#define params (*params)
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       char __user *optval, unsigned int optlen)
+				       struct sctp_sack_info params,
+				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sack_info params;
 
 	if (optlen == sizeof(struct sctp_sack_info)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
 		if (params.sack_delay == 0 && params.sack_freq == 0)
 			return 0;
 	} else if (optlen == sizeof(struct sctp_assoc_value)) {
@@ -2792,9 +2766,6 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
 		if (params.sack_delay == 0)
 			params.sack_freq = 1;
 		else
@@ -2860,15 +2831,14 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigned int optlen)
+#define sinit (*sinit)
+static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg sinit,
+				   unsigned int optlen)
 {
-	struct sctp_initmsg sinit;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen != sizeof(struct sctp_initmsg))
 		return -EINVAL;
-	if (copy_from_user(&sinit, optval, optlen))
-		return -EFAULT;
 
 	if (sinit.sinit_num_ostreams)
 		sp->initmsg.sinit_num_ostreams = sinit.sinit_num_ostreams;
@@ -2881,6 +2851,7 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigne
 
 	return 0;
 }
+#undef sinit
 
 /*
  * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
@@ -2896,18 +2867,16 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigne
  *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
  *   to this call if the caller is using the UDP model.
  */
+#define info (*info)
 static int sctp_setsockopt_default_send_param(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_sndrcvinfo info,
 					      unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
 	if (optlen != sizeof(info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
 	if (info.sinfo_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
@@ -2958,17 +2927,14 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_setsockopt_default_sndinfo(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_sndinfo info,
 					   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
 	if (optlen != sizeof(info))
 		return -EINVAL;
-	if (copy_from_user(&info, optval, optlen))
-		return -EFAULT;
 	if (info.snd_flags &
 	    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 	      SCTP_ABORT | SCTP_EOF))
@@ -3018,10 +2984,10 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
+#define prim (*prim)
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim prim,
 					unsigned int optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_transport *trans;
 	struct sctp_af *af;
 	int err;
@@ -3029,9 +2995,6 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
-		return -EFAULT;
-
 	/* Allow security module to validate address but need address len. */
 	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
 	if (!af)
@@ -3051,6 +3014,7 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 
 	return 0;
 }
+#undef prim
 
 /*
  * 7.1.5 SCTP_NODELAY
@@ -3060,17 +3024,13 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
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
 
@@ -3086,9 +3046,10 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
  * be changed.
  *
  */
-static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_rtoinfo(struct sock *sk,
+				   struct sctp_rtoinfo params,
+				   unsigned int optlen)
 {
-	struct sctp_rtoinfo params;
 	struct sctp_association *asoc;
 	unsigned long rto_min, rto_max;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3096,9 +3057,6 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
 	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
 
 	/* Set the values to the specific association */
@@ -3152,16 +3110,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
  * See [SCTP] for more information.
  *
  */
-static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_associnfo(struct sock *sk,
+				     struct sctp_assocparams params,
+				     unsigned int optlen)
 {
 
-	struct sctp_assocparams params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
 
@@ -3220,16 +3177,14 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
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
@@ -3264,10 +3219,11 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
  *    changed (effecting future associations only).
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
-static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_maxseg(struct sock *sk,
+				  struct sctp_assoc_value params,
+				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int val;
 
@@ -3277,12 +3233,9 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
-			return -EFAULT;
+		val = *(int *)&params;
 		params.assoc_id = SCTP_FUTURE_ASSOC;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
+	} else if (optlen != sizeof(struct sctp_assoc_value)) {
 		val = params.assoc_value;
 	} else {
 		return -EINVAL;
@@ -3324,12 +3277,13 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
  *   locally bound addresses. The following structure is used to make a
  *   set primary request:
  */
-static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optval,
+#define prim (*prim)
+static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
+					     struct sctp_setpeerprim prim,
 					     unsigned int optlen)
 {
 	struct sctp_sock	*sp;
 	struct sctp_association	*asoc = NULL;
-	struct sctp_setpeerprim	prim;
 	struct sctp_chunk	*chunk;
 	struct sctp_af		*af;
 	int 			err;
@@ -3342,9 +3296,6 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, optlen))
-		return -EFAULT;
-
 	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
@@ -3387,18 +3338,16 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 
 	return err;
 }
+#undef prim
 
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
@@ -3417,17 +3366,15 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk, char __user *optval
  * received messages from the peer and does not effect the value that is
  * saved with outbound messages.
  */
-static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_context(struct sock *sk,
+				   struct sctp_assoc_value params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
@@ -3480,17 +3427,13 @@ static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
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
@@ -3516,23 +3459,19 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
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
@@ -3549,11 +3488,10 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
  * future associations inheriting the socket value.
  */
 static int sctp_setsockopt_maxburst(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_assoc_value params,
 				    unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen == sizeof(int)) {
@@ -3562,14 +3500,11 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params.assoc_value, optval, optlen))
-			return -EFAULT;
+		params.assoc_value = *(int *)&params;
 		params.assoc_id = SCTP_FUTURE_ASSOC;
-	} else if (optlen == sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-	} else
+	} else if (optlen != sizeof(struct sctp_assoc_value)) {
 		return -EINVAL;
+	}
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
@@ -3604,20 +3539,18 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
  * received only in an authenticated way.  Changes to the list of chunks
  * will only effect future associations on the socket.
  */
+#define val (*val)
 static int sctp_setsockopt_auth_chunk(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authchunk val,
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
 
 	switch (val.sauth_chunk) {
 	case SCTP_CID_INIT:
@@ -3638,11 +3571,10 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
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
 	int err;
 
@@ -3654,10 +3586,6 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, sizeof(struct sctp_hmacalgo) +
 					     SCTP_AUTH_NUM_HMACS * sizeof(u16));
 
-	hmacs = memdup_user(optval, optlen);
-	if (IS_ERR(hmacs))
-		return PTR_ERR(hmacs);
-
 	idents = hmacs->shmac_num_idents;
 	if (idents == 0 || idents > SCTP_AUTH_NUM_HMACS ||
 	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
@@ -3667,7 +3595,6 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 
 	err = sctp_auth_ep_set_hmacs(ep, hmacs);
 out:
-	kfree(hmacs);
 	return err;
 }
 
@@ -3678,11 +3605,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
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
 
@@ -3693,10 +3619,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3733,7 +3655,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
+	memzero_explicit(authkey, optlen);
 	return ret;
 }
 
@@ -3744,18 +3666,15 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
  * the association shared key.
  */
 static int sctp_setsockopt_active_key(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authkeyid val,
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
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
 	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
@@ -3795,18 +3714,15 @@ static int sctp_setsockopt_active_key(struct sock *sk,
  * This set option will delete a shared secret key from use.
  */
 static int sctp_setsockopt_del_key(struct sock *sk,
-				   char __user *optval,
+				   struct sctp_authkeyid val,
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
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
 	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
@@ -3845,18 +3761,16 @@ static int sctp_setsockopt_del_key(struct sock *sk,
  *
  * This set option will deactivate a shared secret key.
  */
-static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_deactivate_key(struct sock *sk,
+					  struct sctp_authkeyid val,
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
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
 	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
@@ -3889,6 +3803,7 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
 
 	return ret;
 }
+#undef val
 
 /*
  * 8.1.23 SCTP_AUTO_ASCONF
@@ -3904,16 +3819,14 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
  * Note. In this implementation, socket operation overrides default parameter
  * being set by sysctl as well as FreeBSD implementation
  */
-static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
-					unsigned int optlen)
+#define val (*optval)
+static int sctp_setsockopt_auto_asconf(struct sock *sk, int val,
+				       unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 	if (!sctp_is_ep_boundall(sk) && val)
 		return -EINVAL;
 	if ((val && sp->do_auto_asconf) || (!val && !sp->do_auto_asconf))
@@ -3931,6 +3844,7 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
 	spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	return 0;
 }
+#undef val
 
 /*
  * SCTP_PEER_ADDR_THLDS
@@ -3939,11 +3853,11 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
  * transports in an association.  See Section 6.1 of:
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
+#define val (*val)
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrthlds_v2 val,
 					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int len;
@@ -3951,8 +3865,6 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
 	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
 
 	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
 		return -EINVAL;
@@ -4004,52 +3916,39 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 
 	return 0;
 }
+#undef val
 
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
+					struct sctp_assoc_value params,
 					unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(params))
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4061,22 +3960,16 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_default_prinfo(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_default_prinfo info,
 					  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(info))
 		goto out;
 
-	if (copy_from_user(&info, optval, sizeof(info))) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	if (info.pr_policy & ~SCTP_PR_SCTP_MASK)
 		goto out;
 
@@ -4116,23 +4009,18 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 out:
 	return retval;
 }
+#undef info
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_assoc_value params,
 					      unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4147,22 +4035,16 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_assoc_value params,
 					   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	if (params.assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
 		goto out;
 
@@ -4194,11 +4076,11 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
 	return retval;
 }
 
+#undef params
 static int sctp_setsockopt_reset_streams(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_reset_streams *params,
 					 unsigned int optlen)
 {
-	struct sctp_reset_streams *params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
@@ -4208,10 +4090,6 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, USHRT_MAX +
 					     sizeof(__u16) * sizeof(*params));
 
-	params = memdup_user(optval, optlen);
-	if (IS_ERR(params))
-		return PTR_ERR(params);
-
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
 		goto out;
@@ -4223,26 +4101,21 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	retval = sctp_send_reset_streams(asoc, params);
 
 out:
-	kfree(params);
 	return retval;
 }
+#define params (*params)
 
-static int sctp_setsockopt_reset_assoc(struct sock *sk,
-				       char __user *optval,
+
+#define associd (*associd)
+static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	sctp_assoc_t associd;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(associd))
 		goto out;
 
-	if (copy_from_user(&associd, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, associd);
 	if (!asoc)
 		goto out;
@@ -4252,23 +4125,18 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk,
 out:
 	return retval;
 }
+#undef associd
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       char __user *optval,
+				       struct sctp_add_streams params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_add_streams params;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.sas_assoc_id);
 	if (!asoc)
 		goto out;
@@ -4280,21 +4148,16 @@ static int sctp_setsockopt_add_streams(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_value params;
 	int retval = 0;
 
 	if (optlen < sizeof(params))
 		return -EINVAL;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
 	if (params.assoc_value > SCTP_SS_MAX)
 		return -EINVAL;
 
@@ -4328,22 +4191,15 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler_value(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_stream_value params,
 					   unsigned int optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen < sizeof(params))
 		goto out;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_CURRENT_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4369,23 +4225,16 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  char __user *optval,
+						  struct sctp_assoc_value params,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen < sizeof(params))
 		goto out;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4404,11 +4253,9 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
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
 
@@ -4418,10 +4265,7 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->reuse = !!val;
+	sctp_sk(sk)->reuse = !!*optval;
 
 	return 0;
 }
@@ -4447,21 +4291,17 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
 	return 0;
 }
 
-static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
+#define param (*param)
+static int sctp_setsockopt_event(struct sock *sk, struct sctp_event param,
 				 unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	int retval = 0;
 
 	if (optlen < sizeof(param))
 		return -EINVAL;
 
-	optlen = sizeof(param);
-	if (copy_from_user(&param, optval, optlen))
-		return -EFAULT;
-
 	if (param.se_type < SCTP_SN_TYPE_BASE ||
 	    param.se_type > SCTP_SN_TYPE_MAX)
 		return -EINVAL;
@@ -4494,12 +4334,12 @@ static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 
 	return retval;
 }
+#undef param
 
 static int sctp_setsockopt_asconf_supported(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_assoc_value params,
 					    unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
@@ -4507,11 +4347,6 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4532,10 +4367,9 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_assoc_value params,
 					  unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
@@ -4543,11 +4377,6 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4572,21 +4401,15 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_assoc_value params,
 					 unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -4600,21 +4423,15 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value params,
 				     unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
 		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
 		goto out;
 
@@ -4632,72 +4449,36 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 out:
 	return retval;
 }
+#undef params
 
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
@@ -4857,7 +4638,65 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
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
+		/* Sanity bound the length */
+		if (optlen > 0x40000)
+			optlen = 0x40000;
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
 
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

