Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9C264A933
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiLLVG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiLLVGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:06:21 -0500
Received: from forward102p.mail.yandex.net (forward102p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320BA124
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:06:18 -0800 (PST)
Received: from sas8-92ddc00f49ef.qloud-c.yandex.net (sas8-92ddc00f49ef.qloud-c.yandex.net [IPv6:2a02:6b8:c1b:2988:0:640:92dd:c00f])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 2EFAD393D06E;
        Tue, 13 Dec 2022 00:05:56 +0300 (MSK)
Received: by sas8-92ddc00f49ef.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id r5lUZXXYYSw1-kW4xCQSi;
        Tue, 13 Dec 2022 00:05:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1670879155;
        bh=kaCvmnXPvlCxSXT2m7nro3/2DqWZPYiNkWwoiOqbcVs=;
        h=To:Subject:From:Date:Message-ID;
        b=E6aYc+ig6UMVCNMvzF8w632Rt437oNxaxm72ANZYj/VWA/EVHYxVrNPVKUBtnffXg
         rlD51h1bvTqNoa7sGkthocPw6YSAZwKVCJ0Vv+ekfDd1K/ApFwve6ji2d1mhW64wwy
         +lEHfW1iYJaMmtN2jJwC6vqeekJK+s6bYTXh5rgg=
Authentication-Results: sas8-92ddc00f49ef.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <135fda25-22d5-837a-782b-ceee50e19844@ya.ru>
Date:   Tue, 13 Dec 2022 00:05:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH net v3] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuniyu@amazon.com, pabeni@redhat.com, netdev@vger.kernel.org,
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

Note, that we will return EPIPE here like this is normally done in sock_alloc_send_pskb().
Originally used ECONNREFUSED looks strange, since it's strange to return
a specific retval in dependence of race in kernel, when user can't affect on this.

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
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
v3: Return to v1 variant. It looks very bad to return special retval
    in case of race in kernel, when userspace can't control this.
    It looks bad to introduce corner case optimization, which normally
    occurs almost never.

 net/unix/af_unix.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b3545fc68097..6fd745cfc492 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1999,13 +1999,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			unix_state_lock(sk);
 
 		err = 0;
-		if (unix_peer(sk) == other) {
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			/* We are here only when racing with unix_release_sock()
+			 * is clearing @other. Never change state to TCP_CLOSE
+			 * unlike SOCK_DGRAM wants.
+			 */
+			unix_state_unlock(sk);
+			err = -EPIPE;
+		} else if (unix_peer(sk) == other) {
 			unix_peer(sk) = NULL;
 			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
 
+			sk->sk_state = TCP_CLOSE;
 			unix_state_unlock(sk);
 
-			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;


