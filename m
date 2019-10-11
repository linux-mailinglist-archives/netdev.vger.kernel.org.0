Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3197DD37D0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfJKDSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:21 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51156 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:20 -0400
Received: by mail-pg1-f201.google.com with SMTP id r24so5910780pgj.17
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/WLAEAoew0rwtiW9YVzGDJiEv5y+PARjS+AEIyQmE6Y=;
        b=gwR14eDuqxt26TNndQtLRVTYAJObmuI4juoJ1IuNcySiI9n5qpNghJYXt8A9YHj8yY
         /Hv/h8s2362+BZsthwyqZCP9sUdgGkqCGVDPNGiPhipySGnGcYX0e0wQ9azt1H0sxLhF
         Ctv3QBR8n88pGcNubyBlsYZbNN75zBUgusdE7UX1eD/UXBn4yj26BPS66oR0IdzBRq6U
         TsKpEKILQwv3UPWRXCFZmtPey7+T7Sj+rlADWP2uENcSHT7fE3dMqGpegE1kZp3/1RMh
         8jaTOZ6LqZmv9x8884wHiG0cEwxmbObDDUcsCTTRsAlS/+GyKMSXQ2dIDDFjSztzpYfQ
         MTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/WLAEAoew0rwtiW9YVzGDJiEv5y+PARjS+AEIyQmE6Y=;
        b=Lz49ylYsS9EATD7P9IOVyucXaLNsK4kfcK/J4ivJzc3APe/5x+JGD1YZWERyzwwUgF
         UPtv4UFAYqnkRFAFZBOmVgGaYl9nqzGabfTP5qasgxx9iiY7UbEyUtC/ZI+zr+54B2Bn
         QIuvyvwUFqZRmWnulthaGVrcJ5nAe7UFTrFu9EEew/Oc3ZtJcYb9lB2YnqXCqjm7vtMQ
         p9HMvsk1r3IHfIZKI7xqDy2f05vZKQLVbZde1HtNYkXdlCZ7Wrb7fv2SLHgKqdV6bbAF
         yyKwdy375Bf5t8bEmdUxY/X0emhK4BPnRolgnnvbp8mjMh5PCoarsuyeIJWVeFkFTd5q
         Cbuw==
X-Gm-Message-State: APjAAAXmEugvUVfmhRo8wD6/j4ow9W14yHoE9tbletZ+Mh6ic7K/bs+L
        koyNeWXEsWtXtIFIXO1zfx4dagbGTLfuOw==
X-Google-Smtp-Source: APXvYqw0XQmKg3mpSzuqvQl9aYKVOEmZB5rsQpRnOBlNqSRKiF7c+dfj/Ru+W24R0KY+OjPXoLCQeHyRov5Zhw==
X-Received: by 2002:a65:628e:: with SMTP id f14mr14821692pgv.114.1570763899751;
 Thu, 10 Oct 2019 20:18:19 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:43 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-7-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 6/9] tcp: annotate tp->urg_seq lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There two places where we fetch tp->urg_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write side use corresponding WRITE_ONCE() to avoid
store-tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c       | 5 +++--
 net/ipv4/tcp_input.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 652568750cb17268509efc83bfa4bae0a23be83d..577a8c6eef9f520ba5d96485ab866af89aa0a046 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -546,7 +546,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    (state != TCP_SYN_RECV || rcu_access_pointer(tp->fastopen_rsk))) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 
-		if (tp->urg_seq == READ_ONCE(tp->copied_seq) &&
+		if (READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq) &&
 		    !sock_flag(sk, SOCK_URGINLINE) &&
 		    tp->urg_data)
 			target++;
@@ -607,7 +607,8 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCATMARK:
-		answ = tp->urg_data && tp->urg_seq == READ_ONCE(tp->copied_seq);
+		answ = tp->urg_data &&
+		       READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq);
 		break;
 	case SIOCOUTQ:
 		if (sk->sk_state == TCP_LISTEN)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a30aae3a6a182a3ba3d262171ebd9c1441cd5cd6..16342e043ab353bfe1b10d8099117395a396fbd4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5356,7 +5356,7 @@ static void tcp_check_urg(struct sock *sk, const struct tcphdr *th)
 	}
 
 	tp->urg_data = TCP_URG_NOTYET;
-	tp->urg_seq = ptr;
+	WRITE_ONCE(tp->urg_seq, ptr);
 
 	/* Disable header prediction. */
 	tp->pred_flags = 0;
-- 
2.23.0.700.g56cf767bdb-goog

