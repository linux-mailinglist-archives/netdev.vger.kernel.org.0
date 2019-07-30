Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D427A8C3
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfG3MjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:39:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40463 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfG3MjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:39:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so30010067pgj.7;
        Tue, 30 Jul 2019 05:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=y3ahSmLu8mAN3iVMmyJ3jSihrIP4NJsd4xvE9cLjCj0=;
        b=trWRhsTwQjvrXLlp5feQly9BZPKndq2JEwMWA4YNxGumoHd9NtMRZOwDgoBHe50/oi
         IbUCZpYVqcZyYgHtmT27n979rwHyALbKELokFfpa2X0AZ2QssOIpl0CxgJ8j/jyTYV8x
         xJ/j8puXalSiQ1FRnpp+s43WTTTANAc3xga/wRKkCh40ut7f27x3xVMX4RmVaNMoYamU
         KzGpoOorJ7Cp+BeSkkBJVgrHczc6KkkXSsl+JfoRloSXgS8kQGfy/xNQy7qVkmhuewKd
         neQh7Ohp5fWonc/gOZUWPk5bkHIe2J4PJNVTgm/pJo8W20tshdSi4LlqtIrz7JzXQuyO
         z/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=y3ahSmLu8mAN3iVMmyJ3jSihrIP4NJsd4xvE9cLjCj0=;
        b=UOU63MgR/30HM9oTTBbkl0UQRRcR9Fcwnq4JMiTSmCfgYiAkH49yy6avf+7o5Nguhx
         NBu80EfU+DX6Da0spm+5FNczSMwRtv/6DTkYs5VBYFRdFA+QDej3NWcJBwlOadt/gxrl
         ZB+MvoRP81ad9cmNdqH+JjQ1UeKTNVSzoRqJ9jjQWP4617olLNDaQgHGxEzKIMABiFVl
         RKGyVaSEMJXx2YDr84KHzbQIOdOQXI3m1Q318dm1qyaMKDMa4mAhKVuR+OKsuODWsFnc
         AMwA3aHxkfajJZ8V9V7c++ODfRezx7e/SWH/UFDYobhyEbMZdk2xImlT7ww6UZTfrfN+
         nACQ==
X-Gm-Message-State: APjAAAWVsu94q08bENs9ilzOQiG898iYi658HvnvghKtd3C2oX2Mdtbc
        P4EwVgI8sllvx+6HZvKcPIvd//Hf
X-Google-Smtp-Source: APXvYqyzSvcGyfoRqQQVau7zNTMZCp6vLv+kKcG7WjFrk/ilBvxe1/eJoTMxEX0kp51l88AOhqZoZg==
X-Received: by 2002:aa7:8b11:: with SMTP id f17mr41751335pfd.19.1564490346538;
        Tue, 30 Jul 2019 05:39:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b190sm59246274pga.37.2019.07.30.05.39.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:39:05 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 4/5] sctp: factor out sctp_connect_new_asoc
Date:   Tue, 30 Jul 2019 20:38:22 +0800
Message-Id: <64a624d23fe947a7bd4fe1d66ddb8719e791c284.1564490276.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <9995f1c75cd5a555fc22ba2ab374890ad1cee470.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
 <2fe592e724eee4e9b00097485a5bccf317907874.1564490276.git.lucien.xin@gmail.com>
 <9995f1c75cd5a555fc22ba2ab374890ad1cee470.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this function factored out from sctp_sendmsg_new_asoc() and
__sctp_connect(), it creates the asoc and adds a peer with the
1st addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 160 ++++++++++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 84 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b9804e5..6f77853 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1044,6 +1044,73 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	return err;
 }
 
+static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
+				 const union sctp_addr *daddr,
+				 const struct sctp_initmsg *init,
+				 struct sctp_transport **tp)
+{
+	struct sctp_association *asoc;
+	struct sock *sk = ep->base.sk;
+	struct net *net = sock_net(sk);
+	enum sctp_scope scope;
+	int err;
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
+	}
+
+	scope = sctp_scope(daddr);
+	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
+	if (!asoc)
+		return -ENOMEM;
+
+	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
+	if (err < 0)
+		goto free;
+
+	*tp = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!*tp) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	if (!init)
+		return 0;
+
+	if (init->sinit_num_ostreams) {
+		__u16 outcnt = init->sinit_num_ostreams;
+
+		asoc->c.sinit_num_ostreams = outcnt;
+		/* outcnt has been changed, need to re-init stream */
+		err = sctp_stream_init(&asoc->stream, outcnt, 0, GFP_KERNEL);
+		if (err)
+			goto free;
+	}
+
+	if (init->sinit_max_instreams)
+		asoc->c.sinit_max_instreams = init->sinit_max_instreams;
+
+	if (init->sinit_max_attempts)
+		asoc->max_init_attempts = init->sinit_max_attempts;
+
+	if (init->sinit_max_init_timeo)
+		asoc->max_init_timeo =
+			msecs_to_jiffies(init->sinit_max_init_timeo);
+
+	return 0;
+free:
+	sctp_association_free(asoc);
+	return err;
+}
+
 /* __sctp_connect(struct sock* sk, struct sockaddr *kaddrs, int addrs_size)
  *
  * Common routine for handling connect() and sctp_connectx().
@@ -1056,10 +1123,8 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
-	struct net *net = sock_net(sk);
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
-	enum sctp_scope scope;
 	struct sctp_af *af;
 	int walk_size, err;
 	long timeo;
@@ -1082,32 +1147,10 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		return asoc->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
 							     : -EALREADY;
 
-	if (sctp_endpoint_is_peeled_off(ep, daddr))
-		return -EADDRNOTAVAIL;
-
-	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
-			return -EAGAIN;
-	} else {
-		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
-		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
-			return -EACCES;
-	}
-
-	scope = sctp_scope(daddr);
-	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-	if (!asoc)
-		return -ENOMEM;
-
-	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
-	if (err < 0)
-		goto out_free;
-
-	transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
-	if (!transport) {
-		err = -ENOMEM;
-		goto out_free;
-	}
+	err = sctp_connect_new_asoc(ep, daddr, NULL, &transport);
+	if (err)
+		return err;
+	asoc = transport->asoc;
 
 	addr_buf += af->sockaddr_len;
 	walk_size = af->sockaddr_len;
@@ -1160,7 +1203,7 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			goto out_free;
 	}
 
-	err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
+	err = sctp_primitive_ASSOCIATE(sock_net(sk), asoc, NULL);
 	if (err < 0)
 		goto out_free;
 
@@ -1597,9 +1640,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				 struct sctp_transport **tp)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct net *net = sock_net(sk);
 	struct sctp_association *asoc;
-	enum sctp_scope scope;
 	struct cmsghdr *cmsg;
 	__be32 flowinfo = 0;
 	struct sctp_af *af;
@@ -1614,20 +1655,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				    sctp_sstate(sk, CLOSING)))
 		return -EADDRNOTAVAIL;
 
-	if (sctp_endpoint_is_peeled_off(ep, daddr))
-		return -EADDRNOTAVAIL;
-
-	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
-			return -EAGAIN;
-	} else {
-		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
-		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
-			return -EACCES;
-	}
-
-	scope = sctp_scope(daddr);
-
 	/* Label connection socket for first association 1-to-many
 	 * style for client sequence socket()->sendmsg(). This
 	 * needs to be done before sctp_assoc_add_peer() as that will
@@ -1643,45 +1670,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	if (err < 0)
 		return err;
 
-	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-	if (!asoc)
-		return -ENOMEM;
-
-	if (sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL) < 0) {
-		err = -ENOMEM;
-		goto free;
-	}
-
-	if (cmsgs->init) {
-		struct sctp_initmsg *init = cmsgs->init;
-
-		if (init->sinit_num_ostreams) {
-			__u16 outcnt = init->sinit_num_ostreams;
-
-			asoc->c.sinit_num_ostreams = outcnt;
-			/* outcnt has been changed, need to re-init stream */
-			err = sctp_stream_init(&asoc->stream, outcnt, 0,
-					       GFP_KERNEL);
-			if (err)
-				goto free;
-		}
-
-		if (init->sinit_max_instreams)
-			asoc->c.sinit_max_instreams = init->sinit_max_instreams;
-
-		if (init->sinit_max_attempts)
-			asoc->max_init_attempts = init->sinit_max_attempts;
-
-		if (init->sinit_max_init_timeo)
-			asoc->max_init_timeo =
-				msecs_to_jiffies(init->sinit_max_init_timeo);
-	}
-
-	*tp = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
-	if (!*tp) {
-		err = -ENOMEM;
-		goto free;
-	}
+	err = sctp_connect_new_asoc(ep, daddr, cmsgs->init, tp);
+	if (err)
+		return err;
+	asoc = (*tp)->asoc;
 
 	if (!cmsgs->addrs_msg)
 		return 0;
-- 
2.1.0

