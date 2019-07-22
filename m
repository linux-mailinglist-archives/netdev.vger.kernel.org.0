Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7257077E
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfGVRi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:38:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44558 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfGVRi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 13:38:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so17998565pgl.11;
        Mon, 22 Jul 2019 10:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=+edswenelaGCOs8AjQoyFIb+CwbScO8rVBTjJSobI64=;
        b=qV9XUiH/0wA6A0Z50+H2/tzZ4x5Gh68ZgnXrnMu+P+hiO1q37FVTxOTyxurTXYVpYI
         8vKrLWLAYFsiMuaAf1XEV4AZRhZw0kg7KqF4ydND/qODnGQUHdYOI2ORpalKyJzNsC7f
         wrlHicHusjeld6Z0FhRPY8Ul0mN1jd6AoKQy/1wZUoVMFi+jh5f9j3DozrDGa/5NWycu
         Q6PJ80jX//uD/fqlgBFq/3pqXSNGF7Jz9jTa6+d+seFP01QESueu3OTPCoeVQ5kCVsre
         gK4No+VYdzZduXRQGFXS2as41RBjvIR0BbripWnS6sRTySamp1W8Dtzy0foghNGkNHPU
         HmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=+edswenelaGCOs8AjQoyFIb+CwbScO8rVBTjJSobI64=;
        b=rj8yoy0sw+S2tr9nIDJNaKulyLOCCZPmtL5O9FdJVhRwWo3O8ZLPOpmtWpU6oVdLJ4
         +bjUBc5gOQa3PL2DvrwH2FcH/7HgTcsvrls07/3S4b3UnsreJpdFALCawkugZrGPGFnU
         0xXItr+hlJdS8yvFgojwnPNeyqPwrNZo2wX0zU64Z4YCthwbwiEY0o1GSiN5EQWcs29z
         h2Wuir9og3m1cqUceNx5bMWG+rzzauGdCultQE09VZXU6s5Z/aq1b/Wy/16DvduJgW/5
         Mtzf9tdwR+Ypo3gm2H/x5NwhXkc4kp5VTI5nq0k+9AYrh05Xcx7ojfZtzMHSqYE7Se1P
         qBcQ==
X-Gm-Message-State: APjAAAVrhN0DlcooBXys+i2VN3cJhM7uLu7lLfvK1rSvPL+ge0TXJ0Dc
        TCbRzJ7fpnBowwHwqNkz6e5QcfPa
X-Google-Smtp-Source: APXvYqwAyNRbQwcB2QC/boNCoMnZfkB5grAVSRg6mpoOrKu4tHFp8qHj15tkj+jtVjiIv6OS2BaWuQ==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr46456823pgh.325.1563817106425;
        Mon, 22 Jul 2019 10:38:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m20sm39298244pff.79.2019.07.22.10.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 10:38:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 2/4] sctp: clean up __sctp_connect
Date:   Tue, 23 Jul 2019 01:37:58 +0800
Message-Id: <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__sctp_connect is doing quit similar things as sctp_sendmsg_new_asoc.
To factor out common functions, this patch is to clean up their code
to make them look more similar:

  1. create the asoc and add a peer with the 1st addr.
  2. add peers with the other addrs into this asoc one by one.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 211 +++++++++++++++++++-----------------------------------
 1 file changed, 75 insertions(+), 136 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5f92e4a..49837e9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1049,154 +1049,108 @@ static int sctp_setsockopt_bindx(struct sock *sk,
  * Common routine for handling connect() and sctp_connectx().
  * Connect will come in with just a single address.
  */
-static int __sctp_connect(struct sock *sk,
-			  struct sockaddr *kaddrs,
-			  int addrs_size, int flags,
-			  sctp_assoc_t *assoc_id)
+static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
+			  int addrs_size, int flags, sctp_assoc_t *assoc_id)
 {
-	struct net *net = sock_net(sk);
-	struct sctp_sock *sp;
-	struct sctp_endpoint *ep;
-	struct sctp_association *asoc = NULL;
-	struct sctp_association *asoc2;
+	struct sctp_association *old, *asoc;
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
-	union sctp_addr to;
+	struct net *net = sock_net(sk);
+	int addrcnt, walk_size, err;
+	void *addr_buf = kaddrs;
+	union sctp_addr *daddr;
 	enum sctp_scope scope;
+	struct sctp_af *af;
 	long timeo;
-	int err = 0;
-	int addrcnt = 0;
-	int walk_size = 0;
-	union sctp_addr *sa_addr = NULL;
-	void *addr_buf;
-	unsigned short port;
 
-	sp = sctp_sk(sk);
-	ep = sp->ep;
-
-	/* connect() cannot be done on a socket that is already in ESTABLISHED
-	 * state - UDP-style peeled off socket or a TCP-style socket that
-	 * is already connected.
-	 * It cannot be done even on a TCP-style listening socket.
-	 */
 	if (sctp_sstate(sk, ESTABLISHED) || sctp_sstate(sk, CLOSING) ||
-	    (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))) {
-		err = -EISCONN;
-		goto out_free;
+	    (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING)))
+		return -EISCONN;
+
+	daddr = addr_buf;
+	af = sctp_get_af_specific(daddr->sa.sa_family);
+	if (!af || af->sockaddr_len > addrs_size)
+		return -EINVAL;
+
+	err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
+	if (err)
+		return err;
+
+	asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
+	if (asoc)
+		return asoc->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
+							     : -EALREADY;
+
+	if (sctp_endpoint_is_peeled_off(ep, daddr))
+		return -EADDRNOTAVAIL;
+
+	if (!ep->base.bind_addr.port) {
+		if (sctp_autobind(sk))
+			return -EAGAIN;
+	} else {
+		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
+		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+			return -EACCES;
 	}
 
-	/* Walk through the addrs buffer and count the number of addresses. */
-	addr_buf = kaddrs;
-	while (walk_size < addrs_size) {
-		struct sctp_af *af;
+	scope = sctp_scope(daddr);
+	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
+	if (!asoc)
+		return -ENOMEM;
 
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			err = -EINVAL;
-			goto out_free;
-		}
+	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
+	if (err < 0)
+		goto out_free;
 
-		sa_addr = addr_buf;
-		af = sctp_get_af_specific(sa_addr->sa.sa_family);
+	transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!transport) {
+		err = -ENOMEM;
+		goto out_free;
+	}
 
-		/* If the address family is not supported or if this address
-		 * causes the address buffer to overflow return EINVAL.
-		 */
-		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
-			err = -EINVAL;
+	addr_buf += af->sockaddr_len;
+	walk_size = af->sockaddr_len;
+	addrcnt = 1;
+	while (walk_size < addrs_size) {
+		err = -EINVAL;
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			goto out_free;
-		}
-
-		port = ntohs(sa_addr->v4.sin_port);
 
-		/* Save current address so we can work with it */
-		memcpy(&to, sa_addr, af->sockaddr_len);
+		daddr = addr_buf;
+		af = sctp_get_af_specific(daddr->sa.sa_family);
+		if (!af || af->sockaddr_len + walk_size > addrs_size)
+			goto out_free;
 
-		err = sctp_verify_addr(sk, &to, af->sockaddr_len);
-		if (err)
+		if (asoc->peer.port != ntohs(daddr->v4.sin_port))
 			goto out_free;
 
-		/* Make sure the destination port is correctly set
-		 * in all addresses.
-		 */
-		if (asoc && asoc->peer.port && asoc->peer.port != port) {
-			err = -EINVAL;
+		err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
+		if (err)
 			goto out_free;
-		}
 
-		/* Check if there already is a matching association on the
-		 * endpoint (other than the one created here).
-		 */
-		asoc2 = sctp_endpoint_lookup_assoc(ep, &to, &transport);
-		if (asoc2 && asoc2 != asoc) {
-			if (asoc2->state >= SCTP_STATE_ESTABLISHED)
-				err = -EISCONN;
-			else
-				err = -EALREADY;
+		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
+		if (old && old != asoc) {
+			err = old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
+								   : -EALREADY;
 			goto out_free;
 		}
 
-		/* If we could not find a matching association on the endpoint,
-		 * make sure that there is no peeled-off association matching
-		 * the peer address even on another socket.
-		 */
-		if (sctp_endpoint_is_peeled_off(ep, &to)) {
+		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
 			err = -EADDRNOTAVAIL;
 			goto out_free;
 		}
 
-		if (!asoc) {
-			/* If a bind() or sctp_bindx() is not called prior to
-			 * an sctp_connectx() call, the system picks an
-			 * ephemeral port and will choose an address set
-			 * equivalent to binding with a wildcard address.
-			 */
-			if (!ep->base.bind_addr.port) {
-				if (sctp_autobind(sk)) {
-					err = -EAGAIN;
-					goto out_free;
-				}
-			} else {
-				/*
-				 * If an unprivileged user inherits a 1-many
-				 * style socket with open associations on a
-				 * privileged port, it MAY be permitted to
-				 * accept new associations, but it SHOULD NOT
-				 * be permitted to open new associations.
-				 */
-				if (ep->base.bind_addr.port <
-				    inet_prot_sock(net) &&
-				    !ns_capable(net->user_ns,
-				    CAP_NET_BIND_SERVICE)) {
-					err = -EACCES;
-					goto out_free;
-				}
-			}
-
-			scope = sctp_scope(&to);
-			asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-			if (!asoc) {
-				err = -ENOMEM;
-				goto out_free;
-			}
-
-			err = sctp_assoc_set_bind_addr_from_ep(asoc, scope,
-							      GFP_KERNEL);
-			if (err < 0) {
-				goto out_free;
-			}
-
-		}
-
-		/* Prime the peer's transport structures.  */
-		transport = sctp_assoc_add_peer(asoc, &to, GFP_KERNEL,
+		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
 						SCTP_UNKNOWN);
 		if (!transport) {
 			err = -ENOMEM;
 			goto out_free;
 		}
 
-		addrcnt++;
-		addr_buf += af->sockaddr_len;
+		addr_buf  += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
+		addrcnt++;
 	}
 
 	/* In case the user of sctp_connectx() wants an association
@@ -1209,39 +1163,24 @@ static int __sctp_connect(struct sock *sk,
 	}
 
 	err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
-	if (err < 0) {
+	if (err < 0)
 		goto out_free;
-	}
 
 	/* Initialize sk's dport and daddr for getpeername() */
 	inet_sk(sk)->inet_dport = htons(asoc->peer.port);
-	sp->pf->to_sk_daddr(sa_addr, sk);
+	sp->pf->to_sk_daddr(daddr, sk);
 	sk->sk_err = 0;
 
-	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
-
 	if (assoc_id)
 		*assoc_id = asoc->assoc_id;
 
-	err = sctp_wait_for_connect(asoc, &timeo);
-	/* Note: the asoc may be freed after the return of
-	 * sctp_wait_for_connect.
-	 */
-
-	/* Don't free association on exit. */
-	asoc = NULL;
+	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
+	return sctp_wait_for_connect(asoc, &timeo);
 
 out_free:
 	pr_debug("%s: took out_free path with asoc:%p kaddrs:%p err:%d\n",
 		 __func__, asoc, kaddrs, err);
-
-	if (asoc) {
-		/* sctp_primitive_ASSOCIATE may have added this association
-		 * To the hash table, try to unhash it, just in case, its a noop
-		 * if it wasn't hashed so we're safe
-		 */
-		sctp_association_free(asoc);
-	}
+	sctp_association_free(asoc);
 	return err;
 }
 
-- 
2.1.0

