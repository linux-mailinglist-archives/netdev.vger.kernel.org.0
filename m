Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77953145C75
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgAVTap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:30:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVTao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:30:44 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BDF615A1495A;
        Wed, 22 Jan 2020 11:30:39 -0800 (PST)
Date:   Wed, 22 Jan 2020 20:30:37 +0100 (CET)
Message-Id: <20200122.203037.138201907865382075.davem@davemloft.net>
To:     jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net, sk_msg: Don't check if sock is locked when
 tearing down psock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121123147.706666-1-jakub@cloudflare.com>
References: <20200121123147.706666-1-jakub@cloudflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 11:30:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Tue, 21 Jan 2020 13:31:47 +0100

> As John Fastabend reports [0], psock state tear-down can happen on receive
> path *after* unlocking the socket, if the only other psock user, that is
> sockmap or sockhash, releases its psock reference before tcp_bpf_recvmsg
> does so:
> 
>  tcp_bpf_recvmsg()
>   psock = sk_psock_get(sk)                         <- refcnt 2
>   lock_sock(sk);
>   ...
>                                   sock_map_free()  <- refcnt 1
>   release_sock(sk)
>   sk_psock_put()                                   <- refcnt 0
> 
> Remove the lockdep check for socket lock in psock tear-down that got
> introduced in 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during
> tear down").
> 
> [0] https://lore.kernel.org/netdev/5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch/
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied, thank you.
