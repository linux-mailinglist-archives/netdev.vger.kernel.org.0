Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3E017542C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 07:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCBG5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 01:57:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43723 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgCBG5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 01:57:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id s1so5088522pfh.10;
        Sun, 01 Mar 2020 22:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yj6/i5PGnAg2vla96UjqFrCdBrIGa+0X2TdjaqrEe/Y=;
        b=b3YGAK+UaX8TgwholOzZWDvv6xiBB9MBD8W8HCqJKBDjtNZ4yAKmNsvufbvD0WfAUl
         Ojc82bK5Bjm+5D8Q8lMDrBd7BFFueGhCQrqvSR04Q0Jk0ZjypGlwv4hyNIZsUbAusv7v
         Ji1aB983yP1zxrJANQVBU22Diz46XD+Htr8bDCERtSNAcyA/5rBIk8epJk1/pE+HC1Tw
         Ql375z7BhpWDZ6TkeIeU2ZhSegkTExqWy4Q8GVH5fR3MTK7OhngJ7qmd5p1yJViVWmog
         KISGPrhBp7C1I3mN1BQpg1q7o/SsxhxVQXWqIhSJu+/AmCyjMuMZuBekoavBeNucB3gb
         bxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yj6/i5PGnAg2vla96UjqFrCdBrIGa+0X2TdjaqrEe/Y=;
        b=TqDTFU6880YieAQxJKwv6J37cSpiocwGea3Kf528L+75aaVRvPlFIb/jE6tzWfobj/
         GH7fj7jDfYkmRuvSJ4n/Vn63U47JZgD++WGxBQCvqF4WzJJfF4qWAMDP5M8EHdXqX56l
         GkfJWzp5S9fK/oPJYxz+12TK2z5g799oJTYaUxF1ktO5WOqeCYPcyyZerzNnhmTxrR6i
         Nm8J9QSzt0J9IYKY+I/isc/iuws9adVCMTmfqIu2nAmWI9qgWn8YODFkQtSypB/TjAFq
         1Q08x2lo257UGA8D6lzYUJPN16OS9MG2yNJHVl7v7C6BW2wjyTSY05Y9a0DBDR40B13K
         eo8Q==
X-Gm-Message-State: APjAAAW52LxyWrLLDIoBoKpbZkSkdYsZof09zxz689uAaBWaahZYkEgh
        ckvd4n6+El1Y2KbjYtBuqQE1dOs0
X-Google-Smtp-Source: APXvYqxSXnsiG4+LCZDRHNiley9tMRpBi+u+lobMGf/b4EqgU5kJ6fLJkASc97wabIcXeS/tmmtw5Q==
X-Received: by 2002:a63:3207:: with SMTP id y7mr18907478pgy.344.1583132243928;
        Sun, 01 Mar 2020 22:57:23 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o12sm7078715pfp.1.2020.03.01.22.57.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2020 22:57:23 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, jere.leppanen@nokia.com,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
Date:   Mon,  2 Mar 2020 14:57:15 +0800
Message-Id: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it says in rfc6458#section-9.2:

  The application uses the sctp_peeloff() call to branch off an
  association into a separate socket.  (Note that the semantics are
  somewhat changed from the traditional one-to-one style accept()
  call.)  Note also that the new socket is a one-to-one style socket.
  Thus, it will be confined to operations allowed for a one-to-one
  style socket.

Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
on which some operations are not allowed, like shutdown, as Jere
reported.

This patch is to change it to return a one-to-one type socket instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..2b55beb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -88,8 +88,7 @@ static int sctp_send_asconf(struct sctp_association *asoc,
 static int sctp_do_bind(struct sock *, union sctp_addr *, int);
 static int sctp_autobind(struct sock *sk);
 static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			     struct sctp_association *assoc,
-			     enum sctp_socket_type type);
+			     struct sctp_association *assoc);
 
 static unsigned long sctp_memory_pressure;
 static atomic_long_t sctp_memory_allocated;
@@ -4965,7 +4964,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
+	error = sctp_sock_migrate(sk, newsk, asoc);
 	if (error) {
 		sk_common_release(newsk);
 		newsk = NULL;
@@ -5711,7 +5710,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 		return -EINVAL;
 
 	/* Create a new socket.  */
-	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock);
+	err = sock_create(sk->sk_family, SOCK_STREAM, IPPROTO_SCTP, &sock);
 	if (err < 0)
 		return err;
 
@@ -5727,8 +5726,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	err = sctp_sock_migrate(sk, sock->sk, asoc,
-				SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
+	err = sctp_sock_migrate(sk, sock->sk, asoc);
 	if (err) {
 		sock_release(sock);
 		sock = NULL;
@@ -9453,8 +9451,7 @@ static inline void sctp_copy_descendant(struct sock *sk_to,
  * and its messages to the newsk.
  */
 static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			     struct sctp_association *assoc,
-			     enum sctp_socket_type type)
+			     struct sctp_association *assoc)
 {
 	struct sctp_sock *oldsp = sctp_sk(oldsk);
 	struct sctp_sock *newsp = sctp_sk(newsk);
@@ -9562,7 +9559,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * original UDP-style socket or created with the accept() call on a
 	 * TCP-style socket..
 	 */
-	newsp->type = type;
+	newsp->type = SCTP_SOCKET_TCP;
 
 	/* Mark the new socket "in-use" by the user so that any packets
 	 * that may arrive on the association after we've moved it are
-- 
2.1.0

