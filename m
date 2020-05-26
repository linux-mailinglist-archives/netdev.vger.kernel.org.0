Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1081E2778
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbgEZQrN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:47:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:35616 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728339AbgEZQrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:47:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-59-Bpkvz5_VMXyiz0GuLCWkfA-1; Tue, 26 May 2020 17:40:09 +0100
X-MC-Unique: Bpkvz5_VMXyiz0GuLCWkfA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 5/8] sctp: getsockopt, move usercopies into a
 wrapper.
Thread-Topic: [PATCH v3 net-next 5/8] sctp: getsockopt, move usercopies into a
 wrapper.
Thread-Index: AdYze1tPSfOsYTTCSOmZJ+tviax6LQ==
Date:   Tue, 26 May 2020 16:40:08 +0000
Message-ID: <ddf9369dafe34fcf8399f1aba44c4533@AcuMS.aculab.com>
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

Pull the user copies out of the getsockopt() sub-functions.
Diff minimised by using #define params (*params).
The #define are removed in the next patch.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 1103 +++++++++++++++--------------------------------------
 1 file changed, 308 insertions(+), 795 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ae916ad..c7cab60b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1359,11 +1359,11 @@ struct compat_sctp_getaddrs_old {
 };
 #endif
 
+#define param (*param)
 static int sctp_getsockopt_connectx3(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_getaddrs_old param,
+				     int *optlen)
 {
-	struct sctp_getaddrs_old param;
 	sctp_assoc_t assoc_id = 0;
 	struct sockaddr *addrs;
 	int err = 0;
@@ -1374,8 +1374,7 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 
 		if (len < sizeof(param32))
 			return -EINVAL;
-		if (copy_from_user(&param32, optval, sizeof(param32)))
-			return -EFAULT;
+		param32 = *(struct compat_sctp_getaddrs_old *)&param;
 
 		param.assoc_id = param32.assoc_id;
 		param.addr_num = param32.addr_num;
@@ -1385,8 +1384,6 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 	{
 		if (len < sizeof(param))
 			return -EINVAL;
-		if (copy_from_user(&param, optval, sizeof(param)))
-			return -EFAULT;
 	}
 
 	addrs = memdup_user(param.addrs, param.addr_num);
@@ -1397,14 +1394,13 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
 					 &assoc_id);
 	kfree(addrs);
 	if (err == 0 || err == -EINPROGRESS) {
-		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
-			return -EFAULT;
-		if (put_user(sizeof(assoc_id), optlen))
-			return -EFAULT;
+		*(sctp_assoc_t *)&param = assoc_id;
+		*optlen = sizeof(assoc_id);
 	}
 
 	return err;
 }
+#undef param
 
 /* API 3.1.4 close() - UDP Style Syntax
  * Applications use close() to perform graceful shutdown (as described in
@@ -5288,11 +5284,11 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
  * number of unacked data chunks, and number of data chunks pending
  * receipt.  This information is read-only.
  */
+#define status (*status)
 static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
-				       char __user *optval,
-				       int __user *optlen)
+				       struct sctp_status status,
+				       int *optlen)
 {
-	struct sctp_status status;
 	struct sctp_association *asoc = NULL;
 	struct sctp_transport *transport;
 	sctp_assoc_t associd;
@@ -5303,11 +5299,7 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 		goto out;
 	}
 
-	len = sizeof(status);
-	if (copy_from_user(&status, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(status);
 
 	associd = status.sstat_assoc_id;
 	asoc = sctp_id2assoc(sk, associd);
@@ -5342,23 +5334,14 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 	if (status.sstat_primary.spinfo_state == SCTP_UNKNOWN)
 		status.sstat_primary.spinfo_state = SCTP_ACTIVE;
 
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	pr_debug("%s: len:%d, state:%d, rwnd:%d, assoc_id:%d\n",
 		 __func__, len, status.sstat_state, status.sstat_rwnd,
 		 status.sstat_assoc_id);
 
-	if (copy_to_user(optval, &status, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 out:
 	return retval;
 }
+#undef status
 
 
 /* 7.2.2 Peer Address Information (SCTP_GET_PEER_ADDR_INFO)
@@ -5368,11 +5351,11 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
  * window, and retransmission timer values.  This information is
  * read-only.
  */
+#define pinfo (*pinfo)
 static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_paddrinfo pinfo,
+					  int *optlen)
 {
-	struct sctp_paddrinfo pinfo;
 	struct sctp_transport *transport;
 	int retval = 0;
 
@@ -5381,11 +5364,7 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 		goto out;
 	}
 
-	len = sizeof(pinfo);
-	if (copy_from_user(&pinfo, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(pinfo);
 
 	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
 					   pinfo.spinfo_assoc_id);
@@ -5410,19 +5389,10 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 	if (pinfo.spinfo_state == SCTP_UNKNOWN)
 		pinfo.spinfo_state = SCTP_ACTIVE;
 
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	if (copy_to_user(optval, &pinfo, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 out:
 	return retval;
 }
+#undef pinfo
 
 /* 7.1.12 Enable/Disable message fragmentation (SCTP_DISABLE_FRAGMENTS)
  *
@@ -5432,19 +5402,10 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
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
 
@@ -5453,27 +5414,21 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
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
 
@@ -5488,18 +5443,13 @@ static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
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
 
@@ -5555,9 +5505,10 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 EXPORT_SYMBOL(sctp_do_peeloff);
 
 static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *peeloff,
-					  struct file **newfile, unsigned flags)
+					  unsigned flags)
 {
 	struct socket *newsock;
+	struct file *newfile;
 	int retval;
 
 	retval = sctp_do_peeloff(sk, peeloff->associd, &newsock);
@@ -5571,11 +5522,10 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 		goto out;
 	}
 
-	*newfile = sock_alloc_file(newsock, 0, NULL);
-	if (IS_ERR(*newfile)) {
+	newfile = sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(newfile)) {
 		put_unused_fd(retval);
-		retval = PTR_ERR(*newfile);
-		*newfile = NULL;
+		retval = PTR_ERR(newfile);
 		return retval;
 	}
 
@@ -5585,77 +5535,42 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 	peeloff->sd = retval;
 
 	if (flags & SOCK_NONBLOCK)
-		(*newfile)->f_flags |= O_NONBLOCK;
+		newfile->f_flags |= O_NONBLOCK;
+
+	/* If the copy_to_user() fail (because the addresse are redonly)
+	 * and the application catches the SIGSEGV that -EFAULT
+	 * generates it does 'lose' the fd number.
+	 * But it can never tell whether the SIGSEGV happened on the
+	 * copy_from_user() or the copy_to_user().
+	 */
+	fd_install(retval, newfile);
+
 out:
 	return retval;
 }
 
-static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
+static int sctp_getsockopt_peeloff(struct sock *sk, int len,
+				   sctp_peeloff_arg_t *peeloff, int *optlen)
 {
-	sctp_peeloff_arg_t peeloff;
-	struct file *newfile = NULL;
-	int retval = 0;
-
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
+	return sctp_getsockopt_peeloff_common(sk, peeloff, 0);
 }
 
 static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
-					 char __user *optval, int __user *optlen)
+					 sctp_peeloff_flags_arg_t *peeloff,
+					 int *optlen)
 {
-	sctp_peeloff_flags_arg_t peeloff;
-	struct file *newfile = NULL;
-	int retval = 0;
-
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
+					      peeloff->flags);
 }
 
 /* 7.1.13 Peer Address Parameters (SCTP_PEER_ADDR_PARAMS)
@@ -5790,10 +5705,11 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
  *                     used for the DSCP.  This setting has precedence over any
  *                     IPv4- or IPv6- layer setting.
  */
+#define params (*params)
 static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
-					    char __user *optval, int __user *optlen)
+					    struct sctp_paddrparams params,
+					    int *optlen)
 {
-	struct sctp_paddrparams  params;
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
@@ -5807,8 +5723,7 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 	else
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+	*optlen = len;
 
 	/* If an address other than INADDR_ANY is specified, and
 	 * no transport is found, then the request is invalid.
@@ -5889,12 +5804,6 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
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
 
@@ -5934,29 +5843,25 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
  *    value to 1 will disable the delayed sack algorithm.
  */
 static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
-					    char __user *optval,
-					    int __user *optlen)
+				       struct sctp_sack_info params,
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
 
+	*optlen = len;
+
 	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
@@ -5987,12 +5892,6 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
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
 
@@ -6007,45 +5906,36 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
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
@@ -6055,18 +5945,14 @@ static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
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
@@ -6116,15 +6002,15 @@ static int sctp_copy_laddrs(struct sock *sk, __u16 port, void *to,
 }
 
 
+#define getaddrs (*getaddrs)
 static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
-				       char __user *optval, int __user *optlen)
+				       struct sctp_getaddrs getaddrs,
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
@@ -6137,9 +6023,6 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_getaddrs))
 		return -EINVAL;
 
-	if (copy_from_user(&getaddrs, optval, sizeof(struct sctp_getaddrs)))
-		return -EFAULT;
-
 	/*
 	 *  For UDP-style sockets, id specifies the association to query.
 	 *  If the id field is set to the value '0' then the locally bound
@@ -6155,13 +6038,9 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		bp = &asoc->base.bind_addr;
 	}
 
-	to = optval + offsetof(struct sctp_getaddrs, addrs);
+	addrs = &getaddrs.addrs;
 	space_left = len - offsetof(struct sctp_getaddrs, addrs);
 
-	addrs = kmalloc(space_left, GFP_USER | __GFP_NOWARN);
-	if (!addrs)
-		return -ENOMEM;
-
 	/* If the endpoint is bound to 0.0.0.0 or ::0, get the valid
 	 * addresses from the global local address list.
 	 */
@@ -6200,23 +6079,16 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
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
+	getaddrs.addr_num = cnt;
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
+#undef getaddrs
 
 /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
  *
@@ -6224,20 +6096,17 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
+#define prim (*prim)
 static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
-					char __user *optval, int __user *optlen)
+					struct sctp_prim prim, int *optlen)
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
 
 	asoc = sctp_id2assoc(sk, prim.ssp_assoc_id);
 	if (!asoc)
@@ -6252,13 +6121,9 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
 	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sp,
 			(union sctp_addr *)&prim.ssp_addr);
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &prim, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef prim
 
 /*
  * 7.1.11  Set Adaptation Layer Indicator (SCTP_ADAPTATION_LAYER)
@@ -6267,21 +6132,12 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
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
@@ -6305,21 +6161,18 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
  *
  *   For getsockopt, it get the default sctp_sndrcvinfo structure.
  */
+#define info (*info)
 static int sctp_getsockopt_default_send_param(struct sock *sk,
-					int len, char __user *optval,
-					int __user *optlen)
+					int len, struct sctp_sndrcvinfo info,
+					int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndrcvinfo info;
 
 	if (len < sizeof(info))
 		return -EINVAL;
 
-	len = sizeof(info);
-
-	if (copy_from_user(&info, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(info);
 
 	asoc = sctp_id2assoc(sk, info.sinfo_assoc_id);
 	if (!asoc && info.sinfo_assoc_id != SCTP_FUTURE_ASSOC &&
@@ -6340,11 +6193,6 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
 		info.sinfo_timetolive = sp->default_timetolive;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &info, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6352,20 +6200,16 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
  * (SCTP_DEFAULT_SNDINFO)
  */
 static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_sndinfo info,
+					   int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sndinfo info;
 
 	if (len < sizeof(info))
 		return -EINVAL;
 
-	len = sizeof(info);
-
-	if (copy_from_user(&info, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(info);
 
 	asoc = sctp_id2assoc(sk, info.snd_assoc_id);
 	if (!asoc && info.snd_assoc_id != SCTP_FUTURE_ASSOC &&
@@ -6384,13 +6228,9 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
 		info.snd_context = sp->default_context;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &info, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef info
 
 /*
  *
@@ -6403,19 +6243,10 @@ static int sctp_getsockopt_default_sndinfo(struct sock *sk, int len,
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
 
@@ -6432,18 +6263,14 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
-				char __user *optval,
-				int __user *optlen) {
-	struct sctp_rtoinfo params;
+				   struct sctp_rtoinfo params, int *optlen)
+{
 	struct sctp_association *asoc;
 
 	if (len < sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	len = sizeof(struct sctp_rtoinfo);
-
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_rtoinfo);
 
 	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
 
@@ -6465,12 +6292,6 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 		params.srto_min = sp->rtoinfo.srto_min;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6486,11 +6307,10 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
  *
  */
 static int sctp_getsockopt_associnfo(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assocparams params,
+				     int *optlen)
 {
 
-	struct sctp_assocparams params;
 	struct sctp_association *asoc;
 	struct list_head *pos;
 	int cnt = 0;
@@ -6498,10 +6318,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 	if (len < sizeof (struct sctp_assocparams))
 		return -EINVAL;
 
-	len = sizeof(struct sctp_assocparams);
-
-	if (copy_from_user(&params, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(struct sctp_assocparams);
 
 	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
 
@@ -6535,12 +6352,6 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 					sasoc_number_peer_destinations;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6555,20 +6366,12 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
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
@@ -6578,18 +6381,11 @@ static int sctp_getsockopt_mappedv4(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_context())
  */
 static int sctp_getsockopt_context(struct sock *sk, int len,
-				   char __user *optval, int __user *optlen)
+				   struct sctp_assoc_value params, int *optlen)
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
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -6599,11 +6395,6 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->default_rcv_context
 				  : sctp_sk(sk)->default_rcv_context;
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &params, len))
-		return -EFAULT;
-
 	return 0;
 }
 
@@ -6635,9 +6426,8 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
 static int sctp_getsockopt_maxseg(struct sock *sk, int len,
-				  char __user *optval, int __user *optlen)
+				  struct sctp_assoc_value params, int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (len == sizeof(int)) {
@@ -6649,11 +6439,11 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else
 		return -EINVAL;
 
+	*optlen = len;
+
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
@@ -6664,15 +6454,8 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 	else
 		params.assoc_value = sctp_sk(sk)->user_frag;
 
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
+		*(int *)&params = params.assoc_value;
 
 	return 0;
 }
@@ -6682,20 +6465,10 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
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
@@ -6705,21 +6478,10 @@ static int sctp_getsockopt_fragment_interleave(struct sock *sk, int len,
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
@@ -6729,10 +6491,9 @@ static int sctp_getsockopt_partial_delivery_point(struct sock *sk, int len,
  * (chapter and verse is quoted at sctp_setsockopt_maxburst())
  */
 static int sctp_getsockopt_maxburst(struct sock *sk, int len,
-				    char __user *optval,
-				    int __user *optlen)
+				    struct sctp_assoc_value params,
+				    int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (len == sizeof(int)) {
@@ -6744,10 +6505,9 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
-		if (copy_from_user(&params, optval, len))
-			return -EFAULT;
 	} else
 		return -EINVAL;
+	*optlen = len;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -6756,23 +6516,17 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 
 	params.assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
 
-	if (len == sizeof(int)) {
-		if (copy_to_user(optval, &params.assoc_value, len))
-			return -EFAULT;
-	} else {
-		if (copy_to_user(optval, &params, len))
-			return -EFAULT;
-	}
+	if (len == sizeof(int))
+		*(int *)&params = params.assoc_value;
 
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
@@ -6788,35 +6542,24 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_hmacalgo) + data_len)
 		return -EINVAL;
 
-	len = sizeof(struct sctp_hmacalgo) + data_len;
+	*optlen = sizeof(struct sctp_hmacalgo) + data_len;
 	num_idents = data_len / sizeof(u16);
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (put_user(num_idents, &p->shmac_num_idents))
-		return -EFAULT;
-	for (i = 0; i < num_idents; i++) {
-		__u16 hmacid = ntohs(hmacs->hmac_ids[i]);
+	p->shmac_num_idents = num_idents;
+	for (i = 0; i < num_idents; i++)
+		p->shmac_idents[i] = ntohs(hmacs->hmac_ids[i]);
 
-		if (copy_to_user(&p->shmac_idents[i], &hmacid, sizeof(__u16)))
-			return -EFAULT;
-	}
 	return 0;
 }
 
+#define val (*val)
 static int sctp_getsockopt_active_key(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+				    struct sctp_authkeyid val, int *optlen)
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
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
 	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
@@ -6832,32 +6575,21 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 		val.scact_keynumber = ep->active_key_id;
 	}
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-	if (copy_to_user(optval, &val, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef val
 
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
 
@@ -6870,40 +6602,30 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 
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
 
@@ -6923,14 +6645,10 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
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
@@ -6941,7 +6659,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
  * to a one-to-many style socket.  The option value is an uint32_t.
  */
 static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
-				    char __user *optval, int __user *optlen)
+					u32 *optval, int *optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
@@ -6950,19 +6668,13 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
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
@@ -6972,20 +6684,14 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
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
 
@@ -6997,11 +6703,10 @@ static int sctp_getsockopt_auto_asconf(struct sock *sk, int len,
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
@@ -7017,11 +6722,7 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num)
 		return -EINVAL;
 
-	len = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
-
-	ids = kmalloc(len, GFP_USER | __GFP_NOWARN);
-	if (unlikely(!ids))
-		return -ENOMEM;
+	*optlen = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
 
 	ids->gaids_number_of_ids = num;
 	num = 0;
@@ -7029,12 +6730,6 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 		ids->gaids_assoc_id[num++] = asoc->assoc_id;
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, ids, len)) {
-		kfree(ids);
-		return -EFAULT;
-	}
-
-	kfree(ids);
 	return 0;
 }
 
@@ -7045,11 +6740,11 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  * transports in an association.  See Section 6.1 of:
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
+#define val (*val)
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval, int len,
-					    int __user *optlen, bool v2)
+					    struct sctp_paddrthlds_v2 val,
+					    int len, int *optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int min;
@@ -7057,9 +6752,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	min = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
 	if (len < min)
 		return -EINVAL;
-	len = min;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
+	*optlen = min;
 
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
@@ -7092,11 +6785,9 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	}
 
 out:
-	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef val
 
 /*
  * SCTP_GET_ASSOC_STATS
@@ -7104,11 +6795,11 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
  * This option retrieves local per endpoint statistics. It is modeled
  * after OpenSolaris' implementation
  */
+#define sas (*sas)
 static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
-				       char __user *optval,
-				       int __user *optlen)
+				       struct sctp_assoc_stats sas,
+				       int *optlen)
 {
-	struct sctp_assoc_stats sas;
 	struct sctp_association *asoc = NULL;
 
 	/* User must provide at least the assoc id */
@@ -7116,10 +6807,7 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 		return -EINVAL;
 
 	/* Allow the struct to grow and fill in as much as possible */
-	len = min_t(size_t, len, sizeof(sas));
-
-	if (copy_from_user(&sas, optval, len))
-		return -EFAULT;
+	*optlen = min_t(size_t, len, sizeof(sas));
 
 	asoc = sctp_id2assoc(sk, sas.sas_assoc_id);
 	if (!asoc)
@@ -7145,124 +6833,76 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 	 * in such a case
 	 */
 	sas.sas_maxrto = asoc->stats.max_obs_rto;
-	memcpy(&sas.sas_obs_rto_ipaddr, &asoc->stats.obs_rto_ipaddr,
-		sizeof(struct sockaddr_storage));
+	sas.sas_obs_rto_ipaddr = asoc->stats.obs_rto_ipaddr;
 
 	/* Mark beginning of a new observation period */
 	asoc->stats.max_obs_rto = asoc->rto_min;
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
 	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
 
-	if (copy_to_user(optval, &sas, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef sas
 
-static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
-				       char __user *optval,
-				       int __user *optlen)
+static int sctp_getsockopt_recvrcvinfo(struct sock *sk, int len, int *optval,
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
+static int sctp_getsockopt_recvnxtinfo(struct sock *sk, int len, int *optval,
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
+					struct sctp_assoc_value params,
+					int *optlen)
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
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	params.assoc_value = asoc ? asoc->peer.prsctp_capable
 				  : sctp_sk(sk)->ep->prsctp_enable;
 
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
+	return 0;
 }
 
+#define info (*info)
 static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_default_prinfo info,
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
+	*optlen = sizeof(info);
 
 	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
 	if (!asoc && info.pr_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (asoc) {
@@ -7275,23 +6915,14 @@ static int sctp_getsockopt_default_prinfo(struct sock *sk, int len,
 		info.pr_value = sp->default_timetolive;
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
+#undef info
 
 static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_prstatus params,
+					  int *optlen)
 {
-	struct sctp_prstatus params;
 	struct sctp_association *asoc;
 	int policy;
 	int retval = -EINVAL;
@@ -7299,11 +6930,7 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 	if (len < sizeof(params))
 		goto out;
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(params);
 
 	policy = params.sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
@@ -7330,16 +6957,6 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
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
@@ -7347,23 +6964,18 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_prstatus params,
+					   int *optlen)
 {
 	struct sctp_stream_out_ext *streamoute;
 	struct sctp_association *asoc;
-	struct sctp_prstatus params;
 	int retval = -EINVAL;
 	int policy;
 
 	if (len < sizeof(params))
 		goto out;
 
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	*optlen = sizeof(params);
 
 	policy = params.sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
@@ -7399,11 +7011,6 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 			streamoute->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
-	if (put_user(len, optlen) || copy_to_user(optval, &params, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
 	retval = 0;
 
 out:
@@ -7411,21 +7018,13 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
-					      char __user *optval,
-					      int __user *optlen)
+					      struct sctp_assoc_value params,
+					      int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7437,12 +7036,6 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7450,21 +7043,13 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_assoc_value params,
+					   int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7476,12 +7061,6 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->strreset_enable
 				  : sctp_sk(sk)->ep->strreset_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7489,21 +7068,13 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_scheduler(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assoc_value params,
+				     int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7515,12 +7086,6 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 	params.assoc_value = asoc ? sctp_sched_get_sched(asoc)
 				  : sctp_sk(sk)->default_ss;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7528,21 +7093,13 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
-					   char __user *optval,
-					   int __user *optlen)
+					   struct sctp_stream_value params,
+					   int *optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc) {
@@ -7552,39 +7109,19 @@ static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 
 	retval = sctp_sched_get_value(asoc, params.stream_id,
 				      &params.stream_value);
-	if (retval)
-		goto out;
-
-	if (put_user(len, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	if (copy_to_user(optval, &params, len)) {
-		retval = -EFAULT;
-		goto out;
-	}
 
 out:
 	return retval;
 }
 
 static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
-						  char __user *optval,
-						  int __user *optlen)
+						  struct sctp_assoc_value params,
+						  int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7596,12 +7133,6 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->ep->intl_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7609,38 +7140,27 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
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
+#define param (*param)
+static int sctp_getsockopt_event(struct sock *sk, int len,
+				 struct sctp_event param,
+				 int *optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	__u16 subscribe;
 
 	if (len < sizeof(param))
 		return -EINVAL;
 
-	len = sizeof(param);
-	if (copy_from_user(&param, optval, len))
-		return -EFAULT;
+	*optlen = sizeof(param);
 
 	if (param.se_type < SCTP_SN_TYPE_BASE ||
 	    param.se_type > SCTP_SN_TYPE_MAX)
@@ -7654,31 +7174,18 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 	subscribe = asoc ? asoc->subscribe : sctp_sk(sk)->subscribe;
 	param.se_on = sctp_ulpevent_type_enabled(subscribe, param.se_type);
 
-	if (put_user(len, optlen))
-		return -EFAULT;
-
-	if (copy_to_user(optval, &param, len))
-		return -EFAULT;
-
 	return 0;
 }
+#undef param
 
 static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
-					    char __user *optval,
-					    int __user *optlen)
+					    struct sctp_assoc_value params,
+					    int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7690,12 +7197,6 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.asconf_capable
 				  : sctp_sk(sk)->ep->asconf_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7703,21 +7204,13 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
-					  char __user *optval,
-					  int __user *optlen)
+					  struct sctp_assoc_value params,
+					  int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7729,12 +7222,6 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.auth_capable
 				  : sctp_sk(sk)->ep->auth_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7742,21 +7229,13 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
-					 char __user *optval,
-					 int __user *optlen)
+					 struct sctp_assoc_value params,
+					 int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7768,12 +7247,6 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->peer.ecn_capable
 				  : sctp_sk(sk)->ep->ecn_enable;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
@@ -7781,21 +7254,13 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 }
 
 static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
-				     char __user *optval,
-				     int __user *optlen)
+				     struct sctp_assoc_value params,
+				     int *optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EFAULT;
 
-	if (len < sizeof(params)) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	len = sizeof(params);
-	if (copy_from_user(&params, optval, len))
-		goto out;
+	*optlen = sizeof(params);
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
@@ -7807,44 +7272,16 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 	params.assoc_value = asoc ? asoc->pf_expose
 				  : sctp_sk(sk)->pf_expose;
 
-	if (put_user(len, optlen))
-		goto out;
-
-	if (copy_to_user(optval, &params, len))
-		goto out;
-
 	retval = 0;
 
 out:
 	return retval;
 }
 
-static int sctp_getsockopt(struct sock *sk, int level, int optname,
-			   char __user *optval, int __user *optlen)
+static int kernel_sctp_getsockopt(struct sock *sk, int optname, int len,
+				  void *optval, int *optlen)
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
 
@@ -8048,6 +7485,82 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	return retval;
 }
 
+static int sctp_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *u_optval, int __user *u_optlen)
+{
+	u64 param_buf[8];
+	int retval = 0;
+	void *optval;
+	int buflen, len, optlen;
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
+	if (get_user(buflen, u_optlen))
+		return -EFAULT;
+
+	if (buflen < 0)
+		return -EINVAL;
+
+	/* Many options are RMW so we must read in the user buffer.
+	 * For safetly we need to initialise it to avoid leaking
+	 * kernel data - the copy does this as well.
+	 * To simplify the processing of simple options the buffer length
+	 * check is repeated after the request is actioned.
+	 */
+	if (buflen < sizeof (param_buf)) {
+		/* Zero first bytes to stop KASAN complaining. */
+		param_buf[0] = 0;
+		len = buflen;
+		if (copy_from_user(&param_buf, u_optval, len))
+			return -EFAULT;
+		optval = param_buf;
+	} else {
+		/* Sanity bound user buffer size */
+		len = min(buflen, 0x40000);
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
+		if (optlen != buflen && put_user(optlen, u_optlen))
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

