Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AC31E273E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgEZQkN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:40:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:24386 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728570AbgEZQkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:40:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-ntnYF_z5Mfqt_Cr9XI6Gfw-1; Tue, 26 May 2020 17:40:04 +0100
X-MC-Unique: ntnYF_z5Mfqt_Cr9XI6Gfw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 7/8] sctp: setsockopt, remove 'goto out'
Thread-Topic: [PATCH v3 net-next 7/8] sctp: setsockopt, remove 'goto out'
Thread-Index: AdYze5BimASOWN87T2e//FZzUb/kwg==
Date:   Tue, 26 May 2020 16:40:03 +0000
Message-ID: <cd397d5671ee4c15acee4c5b008f85dd@AcuMS.aculab.com>
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

Replace most of the 'goto out' with 'return -Exxxxxx'.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 360 +++++++++++++++++-------------------------------------
 1 file changed, 110 insertions(+), 250 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1481372..6d35ea3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1297,7 +1297,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 					 (struct sockaddr *)kaddrs,
 					  addrs_size);
 	if (err)
-		goto out_free;
+		return err;
 
 	/* in-kernel sockets don't generally have a file allocated to them
 	 * if all they do is call sock_create_kern().
@@ -1305,10 +1305,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	if (sk->sk_socket->file)
 		flags = sk->sk_socket->file->f_flags;
 
-	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
-
-out_free:
-	return err;
+	return __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
 }
 
 /*
@@ -3559,7 +3556,6 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	u32 idents;
-	int err;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -3571,14 +3567,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 
 	idents = hmacs->shmac_num_idents;
 	if (idents == 0 || idents > SCTP_AUTH_NUM_HMACS ||
-	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
-		err = -EINVAL;
-		goto out;
-	}
+	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo)))
+		return -EINVAL;
 
-	err = sctp_auth_ep_set_hmacs(ep, hmacs);
-out:
-	return err;
+	return sctp_auth_ep_set_hmacs(ep, hmacs);
 }
 
 /*
@@ -3943,13 +3935,12 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*info))
-		goto out;
+		return -EINVAL;
 
 	if (info->pr_policy & ~SCTP_PR_SCTP_MASK)
-		goto out;
+		return -EINVAL;
 
 	if (info->pr_policy == SCTP_PR_SCTP_NONE)
 		info->pr_value = 0;
@@ -3957,14 +3948,12 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
 	if (!asoc && info->pr_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
-
-	retval = 0;
+		return -EINVAL;
 
 	if (asoc) {
 		SCTP_PR_SET_POLICY(asoc->default_flags, info->pr_policy);
 		asoc->default_timetolive = info->pr_value;
-		goto out;
+		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
@@ -3984,8 +3973,7 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 		}
 	}
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
@@ -3993,22 +3981,18 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 					      unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
 	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
@@ -4017,24 +4001,21 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	if (params->assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
-
-	retval = 0;
+		return -EINVAL;
 
 	if (asoc) {
 		asoc->strreset_enable = params->assoc_value;
-		goto out;
+		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
@@ -4049,8 +4030,7 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
 		list_for_each_entry(asoc, &ep->asocs, asocs)
 			asoc->strreset_enable = params->assoc_value;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_reset_streams(struct sock *sk,
@@ -4058,7 +4038,6 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 					 unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen < sizeof(*params))
 		return -EINVAL;
@@ -4068,35 +4047,28 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 
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
-	return retval;
+	return sctp_send_reset_streams(asoc, params);
 }
 
 static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*associd))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, (*associd));
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_assoc(asoc);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_reset_assoc(asoc);
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
@@ -4104,19 +4076,15 @@ static int sctp_setsockopt_add_streams(struct sock *sk,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->sas_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_add_streams(asoc, params);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_add_streams(asoc, params);
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
@@ -4167,21 +4135,19 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 					   unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
+	int retval;
 
 	if (optlen < sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_CURRENT_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
-	if (asoc) {
-		retval = sctp_sched_set_value(asoc, params->stream_id,
+	if (asoc)
+		return sctp_sched_set_value(asoc, params->stream_id,
 					      params->stream_value, GFP_KERNEL);
-		goto out;
-	}
 
 	retval = 0;
 
@@ -4192,7 +4158,6 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 			retval = ret;
 	}
 
-out:
 	return retval;
 }
 
@@ -4202,27 +4167,21 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen < sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
-	if (!sock_net(sk)->sctp.intl_enable || !sp->frag_interleave) {
-		retval = -EPERM;
-		goto out;
-	}
+	if (!sock_net(sk)->sctp.intl_enable || !sp->frag_interleave)
+		return -EPERM;
 
 	sp->ep->intl_enable = !!params->assoc_value;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_reuse_port(struct sock *sk, int *optval,
@@ -4312,15 +4271,14 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 {
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
 	ep = sctp_sk(sk)->ep;
 	ep->asconf_enable = !!params->assoc_value;
@@ -4330,10 +4288,7 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
 	}
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
@@ -4342,21 +4297,21 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 {
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
-	int retval = -EINVAL;
+	int retval;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
 	ep = sctp_sk(sk)->ep;
 	if (params->assoc_value) {
 		retval = sctp_auth_init(ep, GFP_KERNEL);
 		if (retval)
-			goto out;
+			return retval;
 		if (ep->asconf_enable) {
 			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
 			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
@@ -4364,10 +4319,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 	}
 
 	ep->auth_enable = !!params->assoc_value;
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
@@ -4375,21 +4327,17 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 					 unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
 	sctp_sk(sk)->ep->ecn_enable = !!params->assoc_value;
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
@@ -4397,27 +4345,24 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 				     unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	if (params->assoc_value > SCTP_PF_EXPOSE_MAX)
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
-		goto out;
+		return -EINVAL;
 
 	if (asoc)
 		asoc->pf_expose = params->assoc_value;
 	else
 		sctp_sk(sk)->pf_expose = params->assoc_value;
-	retval = 0;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int kernel_sctp_setsockopt(struct sock *sk, int optname, void *optval,
@@ -5289,21 +5234,16 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 	struct sctp_association *asoc = NULL;
 	struct sctp_transport *transport;
 	sctp_assoc_t associd;
-	int retval = 0;
 
-	if (len < sizeof(*status)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (len < sizeof(*status))
+		return -EINVAL;
 
 	*optlen = sizeof(*status);
 
 	associd = status->sstat_assoc_id;
 	asoc = sctp_id2assoc(sk, associd);
-	if (!asoc) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (!asoc)
+		return -EINVAL;
 
 	transport = asoc->peer.primary_path;
 
@@ -5335,8 +5275,7 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
 		 __func__, len, status->sstat_state, status->sstat_rwnd,
 		 status->sstat_assoc_id);
 
-out:
-	return retval;
+	return 0;
 }
 
 
@@ -5352,27 +5291,20 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 					  int *optlen)
 {
 	struct sctp_transport *transport;
-	int retval = 0;
 
-	if (len < sizeof(*pinfo)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (len < sizeof(*pinfo))
+		return -EINVAL;
 
 	*optlen = sizeof(*pinfo);
 
 	transport = sctp_addr_id2transport(sk, &pinfo->spinfo_address,
 					   pinfo->spinfo_assoc_id);
-	if (!transport) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (!transport)
+		return -EINVAL;
 
 	if (transport->state == SCTP_PF &&
-	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
-		retval = -EACCES;
-		goto out;
-	}
+	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE)
+		return -EACCES;
 
 	pinfo->spinfo_assoc_id = sctp_assoc2id(transport->asoc);
 	pinfo->spinfo_state = transport->state;
@@ -5384,8 +5316,7 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 	if (pinfo->spinfo_state == SCTP_UNKNOWN)
 		pinfo->spinfo_state = SCTP_ACTIVE;
 
-out:
-	return retval;
+	return 0;
 }
 
 /* 7.1.12 Enable/Disable message fragmentation (SCTP_DISABLE_FRAGMENTS)
@@ -5507,20 +5438,19 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 
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
 
 	newfile = sock_alloc_file(newsock, 0, NULL);
 	if (IS_ERR(newfile)) {
 		put_unused_fd(retval);
-		retval = PTR_ERR(newfile);
-		return retval;
+		return PTR_ERR(newfile);
 	}
 
 	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk, newsock->sk,
@@ -5539,7 +5469,6 @@ static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *p
 	 */
 	fd_install(retval, newfile);
 
-out:
 	return retval;
 }
 
@@ -6006,7 +5935,6 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	union sctp_addr temp;
 	struct sctp_sock *sp = sctp_sk(sk);
 	int addrlen;
-	int err = 0;
 	size_t space_left;
 	int bytes_copied = 0;
 	void *addrs;
@@ -6042,10 +5970,8 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		if (sctp_is_any(sk, &addr->a)) {
 			cnt = sctp_copy_laddrs(sk, bp->port, addrs,
 						space_left, &bytes_copied);
-			if (cnt < 0) {
-				err = cnt;
-				goto out;
-			}
+			if (cnt < 0)
+				return cnt;
 			goto copy_getaddrs;
 		}
 	}
@@ -6059,10 +5985,8 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		memcpy(&temp, &addr->a, sizeof(temp));
 		addrlen = sctp_get_pf_specific(sk->sk_family)
 			      ->addr_to_user(sp, &temp);
-		if (space_left < addrlen) {
-			err =  -ENOMEM; /*fixme: right error?*/
-			goto out;
-		}
+		if (space_left < addrlen)
+			return  -ENOMEM; /*fixme: right error?*/
 		memcpy(buf, &temp, addrlen);
 		buf += addrlen;
 		bytes_copied += addrlen;
@@ -6077,8 +6001,8 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	 * after the buffer is copied but before the length is returned.
 	 */
 	*optlen = sizeof(struct sctp_getaddrs) + bytes_copied;
-out:
-	return err;
+
+	return 0;
 }
 
 /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
@@ -6748,7 +6672,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val->spt_pathpfthld = trans->pf_retrans;
 		val->spt_pathcpthld = trans->ps_retrans;
 
-		goto out;
+		return 0;
 	}
 
 	asoc = sctp_id2assoc(sk, val->spt_assoc_id);
@@ -6768,7 +6692,6 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val->spt_pathcpthld = sp->ps_retrans;
 	}
 
-out:
 	return 0;
 }
 
@@ -6904,21 +6827,20 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 {
 	struct sctp_association *asoc;
 	int policy;
-	int retval = -EINVAL;
 
 	if (len < sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	*optlen = sizeof(*params);
 
 	policy = params->sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
 	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->sprstat_assoc_id);
 	if (!asoc)
-		goto out;
+		return -EINVAL;
 
 	if (policy == SCTP_PR_SCTP_ALL) {
 		params->sprstat_abandoned_unsent = 0;
@@ -6936,10 +6858,7 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 			asoc->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
@@ -6948,30 +6867,28 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 {
 	struct sctp_stream_out_ext *streamoute;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 	int policy;
 
 	if (len < sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	*optlen = sizeof(*params);
 
 	policy = params->sprstat_policy;
 	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
 	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->sprstat_assoc_id);
 	if (!asoc || params->sprstat_sid >= asoc->stream.outcnt)
-		goto out;
+		return -EINVAL;
 
 	streamoute = SCTP_SO(&asoc->stream, params->sprstat_sid)->ext;
 	if (!streamoute) {
 		/* Not allocated yet, means all stats are 0 */
 		params->sprstat_abandoned_unsent = 0;
 		params->sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
+		return 0;
 	}
 
 	if (policy == SCTP_PR_SCTP_ALL) {
@@ -6990,10 +6907,7 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 			streamoute->abandoned_sent[__SCTP_PR_INDEX(policy)];
 	}
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
@@ -7001,24 +6915,18 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 					      int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.reconf_capable
 				  : sctp_sk(sk)->ep->reconf_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
@@ -7026,24 +6934,18 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 					   int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->strreset_enable
 				  : sctp_sk(sk)->ep->strreset_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_scheduler(struct sock *sk, int len,
@@ -7051,24 +6953,18 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 				     int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? sctp_sched_get_sched(asoc)
 				  : sctp_sk(sk)->default_ss;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
@@ -7076,21 +6972,15 @@ static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 					   int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
-	if (!asoc) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (!asoc)
+		return -EINVAL;
 
-	retval = sctp_sched_get_value(asoc, params->stream_id,
+	return sctp_sched_get_value(asoc, params->stream_id,
 				      &params->stream_value);
-
-out:
-	return retval;
 }
 
 static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
@@ -7098,24 +6988,18 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 						  int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->ep->intl_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
@@ -7160,24 +7044,18 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 					    int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.asconf_capable
 				  : sctp_sk(sk)->ep->asconf_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
@@ -7185,24 +7063,18 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 					  int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.auth_capable
 				  : sctp_sk(sk)->ep->auth_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
@@ -7210,24 +7082,18 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 					 int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.ecn_capable
 				  : sctp_sk(sk)->ep->ecn_enable;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
@@ -7235,24 +7101,18 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 				     int *optlen)
 {
 	struct sctp_association *asoc;
-	int retval = -EFAULT;
 
 	*optlen = sizeof(*params);
 
 	asoc = sctp_id2assoc(sk, params->assoc_id);
 	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP)) {
-		retval = -EINVAL;
-		goto out;
-	}
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->pf_expose
 				  : sctp_sk(sk)->pf_expose;
 
-	retval = 0;
-
-out:
-	return retval;
+	return 0;
 }
 
 static int kernel_sctp_getsockopt(struct sock *sk, int optname, int len,
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

