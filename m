Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89635964FD
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiHPVwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiHPVwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:52:07 -0400
Received: from forward104j.mail.yandex.net (forward104j.mail.yandex.net [5.45.198.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5288E9AE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:51:58 -0700 (PDT)
Received: from sas2-ffeb92823cb1.qloud-c.yandex.net (sas2-ffeb92823cb1.qloud-c.yandex.net [IPv6:2a02:6b8:c08:6803:0:640:ffeb:9282])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 32BE02F98732;
        Wed, 17 Aug 2022 00:51:56 +0300 (MSK)
Received: by sas2-ffeb92823cb1.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TbPrd8KOKM-pshawkU4;
        Wed, 17 Aug 2022 00:51:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660686715;
        bh=/J5C9woEZLa6jrHE/LKFGPKwaK/dIC9IRwq0pORBYVg=;
        h=Date:Message-ID:Cc:To:Subject:From;
        b=ayRuyyata3zw4d/HFMgNpeIS93eD+pQQ9OQWQNP7m5kVnz+Ov51csBDMhrJKZdU+u
         UhH02WSZpUjVwT24fEX0lnkYct14bbsP//RbMhGuPK8OWnsauXj5YUbzgG/0Z4lEDG
         LXpjYJ9YVJ89t6CAiN0677AZv/cQuQRQ7iv68gJw=
Authentication-Results: sas2-ffeb92823cb1.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH] af_unix: Show number of inflight fds for sockets in
 TCP_LISTEN state too
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kirill Tkhai <tkhai@ya.ru>
Message-ID: <1cae5809-26b5-00e8-1554-38fae6d2f991@ya.ru>
Date:   Wed, 17 Aug 2022 00:51:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP_LISTEN sockets is a special case. They preserve skb with a newly
connected sock till accept() makes it fully functional socket.
Receive queue of such socket may grow after connected peer
send messages there. Since these messages may contain scm_fds,
we should expose correct fdinfo::scm_fds for listening socket too.

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
 net/unix/af_unix.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3c7e8049eba1..5c7756b57d2f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -785,15 +785,45 @@ static int unix_set_peek_off(struct sock *sk, int val)
 }
 
 #ifdef CONFIG_PROC_FS
+static int unix_count_nr_fds(struct sock *sk)
+{
+	struct sk_buff *skb;
+	struct unix_sock *u;
+	int nr_fds = 0;
+
+	spin_lock(&sk->sk_receive_queue.lock);
+	skb = skb_peek(&sk->sk_receive_queue);
+	while (skb) {
+		u = unix_sk(skb->sk);
+		nr_fds += atomic_read(&u->scm_stat.nr_fds);
+		skb = skb_peek_next(skb, &sk->sk_receive_queue);
+	}
+	spin_unlock(&sk->sk_receive_queue.lock);
+
+	return nr_fds;
+}
+
 static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct unix_sock *u;
+	int nr_fds;
 
 	if (sk) {
-		u = unix_sk(sock->sk);
-		seq_printf(m, "scm_fds: %u\n",
-			   atomic_read(&u->scm_stat.nr_fds));
+		u = unix_sk(sk);
+		if (sock->type == SOCK_DGRAM) {
+			nr_fds = atomic_read(&u->scm_stat.nr_fds);
+			goto out_print;
+		}
+
+		unix_state_lock(sk);
+		if (sk->sk_state != TCP_LISTEN)
+			nr_fds = atomic_read(&u->scm_stat.nr_fds);
+		else
+			nr_fds = unix_count_nr_fds(sk);
+		unix_state_unlock(sk);
+out_print:
+		seq_printf(m, "scm_fds: %u\n", nr_fds);
 	}
 }
 #else


