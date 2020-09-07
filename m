Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6955F25F20B
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 05:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIGD2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 23:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgIGD2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 23:28:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C277F20738;
        Mon,  7 Sep 2020 03:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599449295;
        bh=MJu1y3OACOeIPE9VdiWlkHp4eAPivsdT7Py/C2nKtrA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ojEAKudYS/g/HDtDWn/WzO24x+Fhic8otPh5lyVVgFFj/0YMH9MMNSGapbzfzvkRM
         xm8FxIR+uZKgff1unr017mWBk4wgu8979Pkz4H1cnQqREBm2c8DajWpOWOFdJgSi+C
         4mWnUM3yC0v0Yk6r9DtZAOBDOU9fBehIgOe7Gy5M=
Date:   Sun, 6 Sep 2020 20:28:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ying Xue <ying.xue@windriver.com>,
        Parthasarathy Bhuvaragan <parthasarathy.bhuvaragan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: fix shutdown() of connection oriented socket
Message-ID: <20200906202813.759b1a09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905061447.3463-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20200905061447.3463-1-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 15:14:47 +0900 Tetsuo Handa wrote:
> I confirmed that the problem fixed by commit 2a63866c8b51a3f7 ("tipc: fix
> shutdown() of connectionless socket") also applies to stream socket.
> 
> ----------
> #include <sys/socket.h>
> #include <unistd.h>
> #include <sys/wait.h>
> 
> int main(int argc, char *argv[])
> {
>         int fds[2] = { -1, -1 };
>         socketpair(PF_TIPC, SOCK_STREAM /* or SOCK_DGRAM */, 0, fds);
>         if (fork() == 0)
>                 _exit(read(fds[0], NULL, 1));
>         shutdown(fds[0], SHUT_RDWR); /* This must make read() return. */
>         wait(NULL); /* To be woken up by _exit(). */
>         return 0;
> }
> ----------
> 
> Since shutdown(SHUT_RDWR) should affect all processes sharing that socket,
> unconditionally setting sk->sk_shutdown to SHUTDOWN_MASK will be the right
> behavior.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Jon, this looks correct to me but it may change the behavior for
applications (at least poll events).

Please review.

> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index ebd280e767bd..11b27ddc75ba 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -2771,10 +2771,7 @@ static int tipc_shutdown(struct socket *sock, int how)
>  
>  	trace_tipc_sk_shutdown(sk, NULL, TIPC_DUMP_ALL, " ");
>  	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
> -	if (tipc_sk_type_connectionless(sk))
> -		sk->sk_shutdown = SHUTDOWN_MASK;
> -	else
> -		sk->sk_shutdown = SEND_SHUTDOWN;
> +	sk->sk_shutdown = SHUTDOWN_MASK;
>  
>  	if (sk->sk_state == TIPC_DISCONNECTING) {
>  		/* Discard any unreceived messages */

