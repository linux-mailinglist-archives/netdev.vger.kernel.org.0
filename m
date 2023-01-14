Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C852266A772
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjANAVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjANAVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:21:05 -0500
Received: from forward107p.mail.yandex.net (forward107p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D232BF1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:20:57 -0800 (PST)
Received: from myt6-870ea81e6a0f.qloud-c.yandex.net (myt6-870ea81e6a0f.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2229:0:640:870e:a81e])
        by forward107p.mail.yandex.net (Yandex) with ESMTP id 1748455716BF;
        Sat, 14 Jan 2023 03:20:56 +0300 (MSK)
Received: by myt6-870ea81e6a0f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id sKUU747Z9iE1-EqOEHgRp;
        Sat, 14 Jan 2023 03:20:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1673655655;
        bh=eJEZoDVamdFHxb6hVYgVkfJR9oPb6t96viLjlkLHRnM=;
        h=To:Subject:From:Date:Message-ID;
        b=gpTRTNDgO6UfkZWV9SkPxOvg0rKSilLahqKa3aNN3t70h5CBngB0WuGJJhkN6qi+W
         d17bLctcYQb6KHMZVM/lfLuL9TPUpsyTy0ZLeQy5uMN/3bIWkIEMO/W847VUEFs+vC
         SDqQnTZHoe8b1+mIShV0Np/kQqaIYEZYtiN77Tao=
Authentication-Results: myt6-870ea81e6a0f.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <9d951e81-2051-5b67-a394-2cb819e5bf57@ya.ru>
Date:   Sat, 14 Jan 2023 03:20:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH net-next] unix: Improve locking scheme in unix_show_fdinfo()
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
 net/unix/af_unix.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0c2293f1d3b..f98d03fe3942 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -807,23 +807,23 @@ static int unix_count_nr_fds(struct sock *sk)
 static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+	unsigned char s_state;
 	struct unix_sock *u;
 	int nr_fds;
 
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


