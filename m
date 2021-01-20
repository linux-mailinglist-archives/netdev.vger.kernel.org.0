Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F64C2FC656
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbhATBSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727153AbhATBS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C8A2222F;
        Wed, 20 Jan 2021 01:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105466;
        bh=VmiiaN59dtlkV7VII3Ql1mpneNdQ+iOs3bHxUtyHAwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sczpxoMfS/qKFWt+jj6uIYBhEPNQim4fkDqmANtBPpVJ+UZhG54ueNWuTWpplZ+WR
         IGaiYPhAr/2YFeVy+Uk4AxT4xb0zXUiWVgYXGir95iS9O4iSgwVoiRdOQFVBVPPmqK
         w6k4E6tcYHgqgNZiimfkclLzvSYNhQkxmv2YmTyHCysXg/VNwuziwNOkoC4Z9X6lzH
         /B0lBUWdRGSqJMVydAZrYayO17Nlu4BUBIugHWbH2rCRj/Gd1yjqHu61vL/Oz6RvZx
         BkVdjGJUw0pTduVjvB1Sj0DGnrvTIOnvpLh/v328lJQDsts5Xda59C9TEep1tBMzbO
         LTZRI+ccZLkQg==
Date:   Tue, 19 Jan 2021 17:17:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ricardo Dias <rdias@singlestore.com>
Subject: Re: [PATCH net] tcp: Fix potential use-after-free due to double
 kfree().
Message-ID: <20210119171745.6840e3a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118055920.82516-1-kuniyu@amazon.co.jp>
References: <20210118055920.82516-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 14:59:20 +0900 Kuniyuki Iwashima wrote:
> Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
> request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
> tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
> inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
> socket into ehash and sets NULL to ireq_opt. Otherwise,
> tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
> socket.
> 
> The commit 01770a1661657 ("tcp: fix race condition when creating child
> sockets from syncookies") added a new path, in which more than one cores
> create full sockets for the same SYN cookie. Currently, the core which
> loses the race frees the full socket without resetting inet_opt, resulting
> in that both sock_put() and reqsk_put() call kfree() for the same memory:
> 
>   sock_put
>     sk_free
>       __sk_free
>         sk_destruct
>           __sk_destruct
>             sk->sk_destruct/inet_sock_destruct
>               kfree(rcu_dereference_protected(inet->inet_opt, 1));
> 
>   reqsk_put
>     reqsk_free
>       __reqsk_free
>         req->rsk_ops->destructor/tcp_v4_reqsk_destructor
>           kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));
> 
> Calling kmalloc() between the double kfree() can lead to use-after-free, so
> this patch fixes it by setting NULL to inet_opt before sock_put().
> 
> As a side note, this kind of issue does not happen for IPv6. This is
> because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
> correspond to ireq_opt in IPv4.
> 
> Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
> CC: Ricardo Dias <rdias@singlestore.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>

Ricardo, Eric, any reason this was written this way?

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 58207c7769d0..87eb614dab27 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1595,6 +1595,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
>  		tcp_move_syn(newtp, req);
>  		ireq->ireq_opt = NULL;
>  	} else {
> +		newinet->inet_opt = NULL;
> +
>  		if (!req_unhash && found_dup_sk) {
>  			/* This code path should only be executed in the
>  			 * syncookie case only
> @@ -1602,8 +1604,6 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
>  			bh_unlock_sock(newsk);
>  			sock_put(newsk);
>  			newsk = NULL;
> -		} else {
> -			newinet->inet_opt = NULL;
>  		}
>  	}
>  	return newsk;

