Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A761082F5
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKXKri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:47:38 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:42336 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKXKri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 05:47:38 -0500
Received: by mail-pj1-f66.google.com with SMTP id y21so5135440pjn.9
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 02:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q3BQ66sbK5Gpfnrdg3eGDKlvFsiR1x021f4knTjkTjQ=;
        b=cDsveOPEvv+q+ii3OMnZiVNGEDOwTXjwHiSYZqUEq/VBI/9cuB9LiL3R8ajNpzq/TF
         t+U/0/NXQRZubHMIkIZqPLQHotntERLI5JLbrIfZoHn7IR074eVYVCK2zcBrszDjnPCE
         pIDkvdqSAJExAPgD0fA4t8oriHTeZCucQgokCDxaTq9laO8xADlA85yr9Xa1g3PZbOkW
         sE2sn2GMou0T3LLCYo7SOq8R1CAyVmYtH7ljIizxW2Su09RLAEXkEYIwWKXvRWfAOVIq
         jYO5swfqTTKDR1TvVm3wImglxgBEvb2m0iix6acfuXEhuMWNLKOuTHAqGmtp73crYmiI
         v1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q3BQ66sbK5Gpfnrdg3eGDKlvFsiR1x021f4knTjkTjQ=;
        b=EhM72txPt4jtxYgKpBTsrGLjqpIEd6AEIOUO35yZPpzd7M61doFvIptx4SQtXP6LSS
         yailvCCcQfhRK9s3vARyNgyrREgUwE4CEKToSQYnwmN7VToD4P9Mb4fBGeTWj3Nuw6le
         tE6pOkILjJkwJOp/EZBNv6fkiJoGne1XUSyhb7SoeZT3Ah+b4Mi9lqVg7/WWguTn5ToJ
         7Xl3syLTZ5ltgcc0VrovwmtIK9nZc4Wt64gY6ODj3MnoLtpMls+Lm9totCSfgPNz1Xe7
         NifqRIQ1ojDn4AKOvNvM6Md1xtlqpG7Myaptvo/iVi/PWB11fO0GO5jkDgmtFQ9NizRc
         z6iw==
X-Gm-Message-State: APjAAAU/ZNFvPxHXM8vaMeVV2iluXsy6Cd2EnahRkE+P0ZkUWVzmnRxr
        A+N0MBvDi/4M2V2QKKDm1uWqwhTO
X-Google-Smtp-Source: APXvYqyqmeZcFw4rFRkCfU81RzSau1AG9h9vn8CSvw7gt19e0C9dd4WmYwIG4RhR9xeZDH05uYoxRg==
X-Received: by 2002:a17:90a:650c:: with SMTP id i12mr32335948pjj.28.1574592457453;
        Sun, 24 Nov 2019 02:47:37 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id i13sm4188537pfo.39.2019.11.24.02.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 02:47:36 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net-sctp: replace some sock_net(sk) with just 'net'
Date:   Sun, 24 Nov 2019 02:47:27 -0800
Message-Id: <20191124104727.8273-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

It already existed in part of the function, but move it
to a higher level and use it consistently throughout.

Safe since sk is never written to.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/sctp/socket.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 83e4ca1fabda..f57a83d54583 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8264,6 +8264,7 @@ static struct sctp_bind_bucket *sctp_bucket_create(
 
 static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 {
+	struct net *net = sock_net(sk);
 	struct sctp_sock *sp = sctp_sk(sk);
 	bool reuse = (sk->sk_reuse || sp->reuse);
 	struct sctp_bind_hashbucket *head; /* hash list */
@@ -8282,7 +8283,6 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		/* Search for an available port. */
 		int low, high, remaining, index;
 		unsigned int rover;
-		struct net *net = sock_net(sk);
 
 		inet_get_local_port_range(net, &low, &high);
 		remaining = (high - low) + 1;
@@ -8294,12 +8294,12 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 				rover = low;
 			if (inet_is_local_reserved_port(net, rover))
 				continue;
-			index = sctp_phashfn(sock_net(sk), rover);
+			index = sctp_phashfn(net, rover);
 			head = &sctp_port_hashtable[index];
 			spin_lock(&head->lock);
 			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port == rover) &&
-				    net_eq(sock_net(sk), pp->net))
+				    net_eq(net, pp->net))
 					goto next;
 			break;
 		next:
@@ -8323,10 +8323,10 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * to the port number (snum) - we detect that with the
 		 * port iterator, pp being NULL.
 		 */
-		head = &sctp_port_hashtable[sctp_phashfn(sock_net(sk), snum)];
+		head = &sctp_port_hashtable[sctp_phashfn(net, snum)];
 		spin_lock(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
-			if ((pp->port == snum) && net_eq(pp->net, sock_net(sk)))
+			if ((pp->port == snum) && net_eq(pp->net, net))
 				goto pp_found;
 		}
 	}
@@ -8382,7 +8382,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 pp_not_found:
 	/* If there was a hash table miss, create a new port.  */
 	ret = 1;
-	if (!pp && !(pp = sctp_bucket_create(head, sock_net(sk), snum)))
+	if (!pp && !(pp = sctp_bucket_create(head, net, snum)))
 		goto fail_unlock;
 
 	/* In either case (hit or miss), make sure fastreuse is 1 only
-- 
2.24.0.432.g9d3f5f5b63-goog

