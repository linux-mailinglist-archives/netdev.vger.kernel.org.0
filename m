Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2118066AA7E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 10:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjANJfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 04:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjANJfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 04:35:09 -0500
Received: from forward108p.mail.yandex.net (forward108p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0745BAB
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 01:35:06 -0800 (PST)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward108p.mail.yandex.net (Yandex) with ESMTP id DC2E22678A9B;
        Sat, 14 Jan 2023 12:35:03 +0300 (MSK)
Received: from vla1-ef285479e348.qloud-c.yandex.net (vla1-ef285479e348.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:ef28:5479])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id D7D8913E80002;
        Sat, 14 Jan 2023 12:35:03 +0300 (MSK)
Received: by vla1-ef285479e348.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 2ZdFnkAZxuQ1-ttSOi8IV;
        Sat, 14 Jan 2023 12:35:03 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1673688903;
        bh=Chn5Q5jXt25bBtZRZc+O0C0bkApfPD5b20Bl23Sw+8c=;
        h=To:Subject:From:Date:Message-ID;
        b=SWhCuLCaJ7f+kNvuEvcWEiAYKAqj6dvHj6zOCqQQZTqWHI1pFcsx6nRIAm/eOdlRf
         hvJp3ExVXkHPkFdpwWbEN0HmHonQGtPk5ZHPFtaNoR7rAwESAxuE9gbXyyPsBjxUQJ
         1LgV3pJd35MYCC2Oao5laSyvFNbupYZvNz6BwxLk=
Authentication-Results: vla1-ef285479e348.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <c6c7084c-56c7-cd37-befe-df718e080597@ya.ru>
Date:   Sat, 14 Jan 2023 12:35:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH net-next v2] unix: Improve locking scheme in
 unix_show_fdinfo()
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        tkhai@ya.ru
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After switching to TCP_ESTABLISHED or TCP_LISTEN sk_state, alive SOCK_STREAM
and SOCK_SEQPACKET sockets can't change it anymore (since commit 3ff8bff704f4
"unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()").

Thus, we do not need to take lock here.

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
v2: Initialize "nr_fds = 0".

 net/unix/af_unix.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0c2293f1d3b..009616fa0256 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -807,23 +807,23 @@ static int unix_count_nr_fds(struct sock *sk)
 static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+	unsigned char s_state;
 	struct unix_sock *u;
-	int nr_fds;
+	int nr_fds = 0;
 
 	if (sk) {
+		s_state = READ_ONCE(sk->sk_state);
 		u = unix_sk(sk);
-		if (sock->type == SOCK_DGRAM) {
-			nr_fds = atomic_read(&u->scm_stat.nr_fds);
-			goto out_print;
-		}
 
-		unix_state_lock(sk);
-		if (sk->sk_state != TCP_LISTEN)
+		/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
+		 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
+		 * SOCK_DGRAM is ordinary. So, no lock is needed.
+		 */
+		if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
 			nr_fds = atomic_read(&u->scm_stat.nr_fds);
-		else
+		else if (s_state == TCP_LISTEN)
 			nr_fds = unix_count_nr_fds(sk);
-		unix_state_unlock(sk);
-out_print:
+
 		seq_printf(m, "scm_fds: %u\n", nr_fds);
 	}
 }


