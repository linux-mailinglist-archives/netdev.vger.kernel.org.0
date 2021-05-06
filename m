Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D450375D15
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 00:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhEFWKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 18:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhEFWKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 18:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E9C610A1;
        Thu,  6 May 2021 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620338971;
        bh=TW8oGn+b0uCT4kIlyMebmO2UGUOVAt/zo2Ssl2vJCj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gxVi+MAyornGAdAvHjCa67UAsGaAfOon0d+vKgQqDCVM2z9AhsHWHSoeNDdSdL7HH
         +2Ov9hAW+Sr9wQ0irttRk/e2NcYv3yseXl5wnTuEV4rRw1INJV+KNtd+oNprGahP1v
         q2dqwBMGZbC62mA2BOZ2Y0qCrEHIakXHp9uGw+lPwtUfdIh/cSn5tFLbi0/PIWBZuC
         6mlMKtvidB4Hw5UQa6TBU9bZxA46OVT2JVysg039OVcKJliJ3kOlpmhvIZWvQXz0jp
         VNQqgNcB2dfggjM/6qFeWxXTYjoP9cQ6j/tg8UDcWqKdy3tuprqVsLwUwv6CWqDKjT
         ESylqGpwAjxdw==
Date:   Thu, 6 May 2021 15:09:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: GPF in net sybsystem
Message-ID: <20210506150930.3b677dcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210505200242.31d58452@gmail.com>
References: <20210505200242.31d58452@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 May 2021 20:02:42 +0300 Pavel Skripkin wrote:
> Hi, netdev developers!
> 
> I've spent some time debugging this bug
> https://syzkaller.appspot.com/bug?id=c670fb9da2ce08f7b5101baa9426083b39ee9f90
> and, I believe, I found the root case:
> 
> static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
> 		     bool kern)
> {
> ....
> 	for (;;) {
> 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> 		...
> 		if (!signal_pending(current)) {
> 			release_sock(sk);
> 			schedule();
> 			lock_sock(sk);
> 			continue;
> 		}
> 		...
> 	}
> ...
> }
> 
> When calling process will be scheduled, another proccess can release
> this socket and set sk->sk_wq to NULL. (In this case nr_release()
> will call sock_orphan(sk)). In this case GPF will happen in
> prepare_to_wait().

How does it get released midway through an accept call?
Is there a reference imbalance somewhere else in the code?

> I came up with this patch, but im not an expect in netdev sybsystem and
> im not sure about this one:
> 
> diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
> index 6d16e1ab1a8a..89ceddea48e8 100644
> --- a/net/netrom/af_netrom.c
> +++ b/net/netrom/af_netrom.c
> @@ -803,6 +803,10 @@ static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
>  			release_sock(sk);
>  			schedule();
>  			lock_sock(sk);
> +			if (sock_flag(sk, SOCK_DEAD)) {
> +				err = -ECONNABORTED;
> +				goto out_release;
> +			}
>  			continue;
>  		}
>  		err = -ERESTARTSYS;
> 
> I look forward to hearing your perspective on this :)
> 
> 
> BTW, I found similar code in:
> 
> 1) net/ax25/af_ax25.c
> 2) net/rose/af_rose.c
> 
> 
> I hope, this will help!
> 
> With regards,
> Pavel Skripkin

