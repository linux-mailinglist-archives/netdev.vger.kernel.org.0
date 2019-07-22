Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582F670782
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfGVRiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:38:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44576 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbfGVRip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 13:38:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so17998968pgl.11;
        Mon, 22 Jul 2019 10:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=gHKacYmBh1efx1Ep3kYrwF8pTxImCqUNM05PMFxVNQc=;
        b=Vrj5q50Ee2+3BHhrPYCNFPrho4DERHHuWuhx+gIUiPBd4gH+Q4XRWqCoA5o/jPdYDw
         Seo2gWQhNqIJxthSgUUtoDYLu7EKJAukbvsQ7XEv5cFWiU6jvbLGUW4fjbJ22r5rdAr3
         Uu+E8uavsVbsaOX2NdQ4nZRFugUVLRWRwoJ6CrZOYTzTy8SZbhEsxlpiI/OX0Ut2AhYw
         MytbdmtWako+lDqJ2g31EKtGzgtbJuR2YBcZIvgri0s+2kwFwBv57iCLfZPizMQYxtJi
         f7NwF1yPQqsVuyTJRwnANixaEgYFlVDZdWRAr6PfJeRwvkYgkV0cyNcxn4HG6V6hNObw
         /IIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=gHKacYmBh1efx1Ep3kYrwF8pTxImCqUNM05PMFxVNQc=;
        b=bIPOZpycLsNyMeP4omc1l0fsbSBqXQfVbZwiM1KxvDO6Eb/IFdpkhEdXVRfRW3bB/b
         cnFYZB/Dt+WJDnivWfFlYhtmEYV7DHbXmrJ6fGVE+X4g8moK91itT8yjOly6ZeKbFD9i
         TbrnNJFHmcPk+3Ha16G9e1rxV10Yc6tOiS2pYD08T4rDe5Flit8w2ODU1dJorJDtp+54
         q+vHwdYJPbXX1Yxf4kqWRx+7WCkoT40sIa781ElomTmbcY2v3N9oSFO+pWinmhkrOB9o
         dGhf0gpL3pR12lSnLX7YK5/xEeTEwKw4hRwgkKT1LyNk6AU8uBOmxqzBRuHl+MUwAU8T
         W3lw==
X-Gm-Message-State: APjAAAXM+7pgyZCOvvf6YlwyhTZGRK/85xYT7V3q2wYib2PUbgXKAQtR
        O4OkJJtUr4KP3zhSDz+e0slSIws8
X-Google-Smtp-Source: APXvYqxmZfrfcz9TYtwsPEQ5kRxBkKeOhn3Xr9ZhqOhPvmXJYGyUVJB1E/3Ig8WJmaaKbDi1q/+i0A==
X-Received: by 2002:a62:e515:: with SMTP id n21mr1388847pff.186.1563817124337;
        Mon, 22 Jul 2019 10:38:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g2sm66754870pfq.88.2019.07.22.10.38.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 10:38:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 4/4] sctp: factor out sctp_connect_add_peer
Date:   Tue, 23 Jul 2019 01:38:00 +0800
Message-Id: <4a8af7d5bcaf3c04a3553ae6491139b4f855be6d.1563817029.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1b46966a4b2013dd3bb3c19b61b38e2d39d53118.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
 <1b46966a4b2013dd3bb3c19b61b38e2d39d53118.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
References: <cover.1563817029.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this function factored out from sctp_sendmsg_new_asoc() and
__sctp_connect(), it adds a peer with the other addr into the
asoc after this asoc is created with the 1st addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 76 +++++++++++++++++++++++--------------------------------
 1 file changed, 31 insertions(+), 45 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 420abdb..6584c19 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1111,6 +1111,33 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 	return err;
 }
 
+static int sctp_connect_add_peer(struct sctp_association *asoc,
+				 union sctp_addr *daddr, int addr_len)
+{
+	struct sctp_endpoint *ep = asoc->ep;
+	struct sctp_association *old;
+	struct sctp_transport *t;
+	int err;
+
+	err = sctp_verify_addr(ep->base.sk, daddr, addr_len);
+	if (err)
+		return err;
+
+	old = sctp_endpoint_lookup_assoc(ep, daddr, &t);
+	if (old && old != asoc)
+		return old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
+							    : -EALREADY;
+
+	if (sctp_endpoint_is_peeled_off(ep, daddr))
+		return -EADDRNOTAVAIL;
+
+	t = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!t)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* __sctp_connect(struct sock* sk, struct sockaddr *kaddrs, int addrs_size)
  *
  * Common routine for handling connect() and sctp_connectx().
@@ -1119,10 +1146,10 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			  int addrs_size, int flags, sctp_assoc_t *assoc_id)
 {
-	struct sctp_association *old, *asoc;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
+	struct sctp_association *asoc;
 	int addrcnt, walk_size, err;
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
@@ -1168,29 +1195,10 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		if (asoc->peer.port != ntohs(daddr->v4.sin_port))
 			goto out_free;
 
-		err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
+		err = sctp_connect_add_peer(asoc, daddr, af->sockaddr_len);
 		if (err)
 			goto out_free;
 
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			err = old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
-								   : -EALREADY;
-			goto out_free;
-		}
-
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto out_free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
-			goto out_free;
-		}
-
 		addr_buf  += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
 		addrcnt++;
@@ -1684,8 +1692,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 
 	/* sendv addr list parse */
 	for_each_cmsghdr(cmsg, cmsgs->addrs_msg) {
-		struct sctp_transport *transport;
-		struct sctp_association *old;
 		union sctp_addr _daddr;
 		int dlen;
 
@@ -1719,30 +1725,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 			daddr->v6.sin6_port = htons(asoc->peer.port);
 			memcpy(&daddr->v6.sin6_addr, CMSG_DATA(cmsg), dlen);
 		}
-		err = sctp_verify_addr(sk, daddr, sizeof(*daddr));
-		if (err)
-			goto free;
-
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			if (old->state >= SCTP_STATE_ESTABLISHED)
-				err = -EISCONN;
-			else
-				err = -EALREADY;
-			goto free;
-		}
 
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
+		err = sctp_connect_add_peer(asoc, daddr, sizeof(*daddr));
+		if (err)
 			goto free;
-		}
 	}
 
 	return 0;
-- 
2.1.0

