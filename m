Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C077B639885
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 23:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiKZW4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 17:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKZW4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 17:56:40 -0500
X-Greylist: delayed 396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Nov 2022 14:56:38 PST
Received: from forward104p.mail.yandex.net (forward104p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA414033
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 14:56:38 -0800 (PST)
Received: from iva5-b9ce8295c822.qloud-c.yandex.net (iva5-b9ce8295c822.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:7f93:0:640:b9ce:8295])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 375C23C20831;
        Sun, 27 Nov 2022 01:46:53 +0300 (MSK)
Received: by iva5-b9ce8295c822.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id pkW0OkDWK0U1-bU9nzoua;
        Sun, 27 Nov 2022 01:46:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1669502812;
        bh=eM76YzEkfoRT0q6b9CXiPUE8flKFDQbicKlrH3vrTyQ=;
        h=To:Subject:From:Date:Message-ID;
        b=qIy1SeHq7HJqpYb+7p9ItT0QQBEh3D7q39giWgMh7gJD1NzPPXF+av876m6IMllIU
         SNZQgsLFyJBHkzh8I3jn9//OyC5UmrpVtxphaXoJhKNJMUeOFSjcKcOeSS5A0meYlH
         QwqAQhokctlCWCieBTgqNmOy/s++EsNbByLpqapI=
Authentication-Results: iva5-b9ce8295c822.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
Date:   Sun, 27 Nov 2022 01:46:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tkhai@ya.ru,
        Kuniyuki Iwashima <kuniyu@amazon.com>
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

There is a race resulting in alive SOCK_SEQPACKET socket
may change its state from TCP_ESTABLISHED to TCP_CLOSE:

unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
  sock_orphan(peer)
    sock_set_flag(peer, SOCK_DEAD)
                                           sock_alloc_send_pskb()
                                             if !(sk->sk_shutdown & SEND_SHUTDOWN)
                                               OK
                                           if sock_flag(peer, SOCK_DEAD)
                                             sk->sk_state = TCP_CLOSE
  sk->sk_shutdown = SHUTDOWN_MASK


After that socket sk remains almost normal: it is able to connect, listen, accept
and recvmsg, while it can't sendmsg.

Since this is the only possibility for alive SOCK_SEQPACKET to change
the state in such way, we should better fix this strange and potentially
danger corner case.

Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
to fix race with unix_dgram_connect():

unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
                                       unix_peer(sk) = NULL
                                       unix_state_unlock(sk)
  unix_state_double_lock(sk, other)
  sk->sk_state  = TCP_ESTABLISHED
  unix_peer(sk) = other
  unix_state_double_unlock(sk, other)
                                       sk->sk_state  = TCP_CLOSED

This patch fixes both of these races.

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
v2: Disconnect from peer right there.

 net/unix/af_unix.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b3545fc68097..be40023a61fb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2001,11 +2001,14 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		err = 0;
 		if (unix_peer(sk) == other) {
 			unix_peer(sk) = NULL;
-			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
+
+			if (sk->sk_type == SOCK_DGRAM) {
+				unix_dgram_peer_wake_disconnect_wakeup(sk, other);
+				sk->sk_state = TCP_CLOSE;
+			}
 
 			unix_state_unlock(sk);
 
-			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;


