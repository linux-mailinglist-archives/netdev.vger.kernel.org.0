Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FE670780
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfGVRih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:38:37 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45389 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfGVRih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 13:38:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so19487363plr.12;
        Mon, 22 Jul 2019 10:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ZCBmOi99k2ZZWdTHbe563u8MDgmILNNFAHSdOHqraKA=;
        b=EZv0jiT75SWcOIlFWVeHrvxDvOGyeAPxWkqXJ9w80VkYXe2rAzKaCDk2nm/fG9Uoac
         tx5ZcazfGGeRMFzL3Sx+ujASnMN2jgmiqWlpl2ZwLGHLBLLJi8yEY2tWoiZSSX+PZdE2
         wvsglSpBULjkoV/4X9QN+Yg+C3CLEw+9k1NhpZ8MYFPas+510btemIZmK4IBcZ9CeoDV
         n4GLMu//N9de9QXVl05Wm0uahd02yR6NIR38nSltjC0KGfHzguDl7WxYNzYfLpjezeha
         a005dlM43AP3EXB+Qtn6cNfT4VSREepVSLkTEMvXmaQxnbA75QytjJi+e51bvt8EdyvM
         jj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ZCBmOi99k2ZZWdTHbe563u8MDgmILNNFAHSdOHqraKA=;
        b=bv1Hem4OO1gi+vZGQDzWEtjKOLMG7yG3GjCNqVGXPvE7PjqpPaGbSg/yUEr6YxmjuU
         /tezwnxYWWjoeFXj2rzLaQ0DV7jMEhB+2A7WSwAseOLCmU5Pn27A9DeXKeNc85ZI25g9
         00wYHfkAWYFBX0Dgqm7RWGTE/XeIgT252VXgpI9T6e3qsPxj7vX6FM79bvV+vWItZZHG
         z9jbFHF6TlmWuT0qZKTDlLPYUkaXfu5Gpv6bHkisypdpsUUHfTl/Aqe0Cn84BbHeJkW3
         Fi1upaO7x/0ktAjE++a1XtTdCEhBjzQ/2NDpu6EGGzv1iOfAtA5AHYupaUv6MnXo63O+
         Dchw==
X-Gm-Message-State: APjAAAVIJSGA8augEUaOsLzLtWfPdEYaDLSw2CGYet8bNg9vpykmWYoo
        B5gVge4CTMXDytfBGNK8Ek6pP8N1
X-Google-Smtp-Source: APXvYqxMpQYryVzJM8Bt4VeQjn+YxvIkg73F8hK8VzGtcedp8dlkyVCUzbcIY7B7XPuMLeLB8KGYTQ==
X-Received: by 2002:a17:902:4623:: with SMTP id o32mr75171597pld.112.1563817115941;
        Mon, 22 Jul 2019 10:38:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a6sm35995145pjs.31.2019.07.22.10.38.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 10:38:35 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/4] sctp: factor out sctp_connect_new_asoc
Date:   Tue, 23 Jul 2019 01:37:59 +0800
Message-Id: <1b46966a4b2013dd3bb3c19b61b38e2d39d53118.1563817029.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
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
index 49837e9..420abdb 100644
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
@@ -1056,11 +1123,9 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
-	struct net *net = sock_net(sk);
 	int addrcnt, walk_size, err;
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
-	enum sctp_scope scope;
 	struct sctp_af *af;
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
@@ -1162,7 +1205,7 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			goto out_free;
 	}
 
-	err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
+	err = sctp_primitive_ASSOCIATE(sock_net(sk), asoc, NULL);
 	if (err < 0)
 		goto out_free;
 
@@ -1598,9 +1641,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				 struct sctp_transport **tp)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct net *net = sock_net(sk);
 	struct sctp_association *asoc;
-	enum sctp_scope scope;
 	struct cmsghdr *cmsg;
 	__be32 flowinfo = 0;
 	struct sctp_af *af;
@@ -1615,20 +1656,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
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
@@ -1644,45 +1671,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
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

