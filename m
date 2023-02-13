Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EF9693D6B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 05:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBME1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 23:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBME1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 23:27:12 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6F33E398;
        Sun, 12 Feb 2023 20:27:09 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 31D4R361006971;
        Mon, 13 Feb 2023 05:27:03 +0100
Date:   Mon, 13 Feb 2023 05:27:03 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Winter <winter@winter.cafe>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE
 from bind
Message-ID: <Y+m8F7Q95al39ctV@1wt.eu>
References: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[CCed netdev]

On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> Hi all,
> 
> I'm facing the same issue as
> https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> on 5.15.93.
> 
> However, I cannot seem to find the identified problematic commit in the 5.15
> branch, so I'm unsure if this is a different issue or not.
> 
> There's a few ways to reproduce this issue, but the one I've been using is
> running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> 271 and 277.

From the linked patch:

  https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/

I can see that:

  We assume the correct errno is -EADDRINUSE when sk->sk_prot->get_port()
  fails, so some ->get_port() functions return just 1 on failure and the
  callers return -EADDRINUSE instead.

  However, mptcp_get_port() can return -EINVAL.  Let's not ignore the error.

  Note the only exception is inet_autobind(), all of whose callers return
  -EAGAIN instead.

But the patch doesn't do what is documented, it preserves all return
values and will happily return 1 if ->get_port() returns 1:

> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -522,9 +522,9 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  	/* Make sure we are allowed to bind here. */
>  	if (snum || !(inet->bind_address_no_port ||
>  		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
> -		if (sk->sk_prot->get_port(sk, snum)) {
> +		err = sk->sk_prot->get_port(sk, snum);
> +		if (err) {
>  			inet->inet_saddr = inet->inet_rcv_saddr = 0;
> -			err = -EADDRINUSE;
>  			goto out_release_sock;
>  		}
>  		if (!(flags & BIND_FROM_BPF)) {
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index eb31c7158b39..971969cc7e17 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1041,7 +1041,7 @@ int inet_csk_listen_start(struct sock *sk)
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct inet_sock *inet = inet_sk(sk);
> -	int err = -EADDRINUSE;
> +	int err;
>  
>  	reqsk_queue_alloc(&icsk->icsk_accept_queue);
>  
> @@ -1057,7 +1057,8 @@ int inet_csk_listen_start(struct sock *sk)
>  	 * after validation is complete.
>  	 */
>  	inet_sk_state_store(sk, TCP_LISTEN);
> -	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
> +	err = sk->sk_prot->get_port(sk, inet->inet_num);
> +	if (!err) {
>  		inet->inet_sport = htons(inet->inet_num);

IMHO in the "if (err)" block in all these places what is missing
is:

    if (err > 0)
        err = -EADDRINUSE;

so that all non-negative errors are properly mapped to -EADDRINUSE,
like in the appended patch (if someone wants to give it a try, I've
not even build-tested it). Note that I don't like it much and do not
like the original patch either, I think a revert and a cleaner fix
could be better :-/

Willy
--

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index cf11f10927e1..ce9960d9448d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -526,6 +526,9 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		err = sk->sk_prot->get_port(sk, snum);
 		if (err) {
 			inet->inet_saddr = inet->inet_rcv_saddr = 0;
+			/* some ->get_port() return 1 on failure */
+			if (err > 0)
+				err = -EADDRINUSE;
 			goto out_release_sock;
 		}
 		if (!(flags & BIND_FROM_BPF)) {
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f2c43f67187d..7585c440fb8c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1241,6 +1241,9 @@ int inet_csk_listen_start(struct sock *sk)
 		if (likely(!err))
 			return 0;
 	}
+	/* some ->get_port() return 1 on failure */
+	if (err > 0)
+		err = -EADDRINUSE;
 
 	inet_sk_set_state(sk, TCP_CLOSE);
 	return err;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 847934763868..941c8ee4a144 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -415,6 +415,9 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		if (err) {
 			sk->sk_ipv6only = saved_ipv6only;
 			inet_reset_saddr(sk);
+			/* some ->get_port() return 1 on failure */
+			if (err > 0)
+				err = -EADDRINUSE;
 			goto out;
 		}
 		if (!(flags & BIND_FROM_BPF)) {
