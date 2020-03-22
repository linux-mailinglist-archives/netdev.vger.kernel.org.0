Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96AA18E632
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCVDIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:08:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgCVDIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:08:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F7D415AC1020;
        Sat, 21 Mar 2020 20:08:40 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:08:39 -0700 (PDT)
Message-Id: <20200321.200839.737803094041368288.davem@davemloft.net>
To:     jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next 0/3] net/tls: Annotate lockless access to
 sk_prot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317170439.873532-1-jakub@cloudflare.com>
References: <20200317170439.873532-1-jakub@cloudflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:08:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Tue, 17 Mar 2020 18:04:36 +0100

> We have recently noticed that there is a case of lockless read/write to
> sk->sk_prot [0]. sockmap code on psock tear-down writes to sk->sk_prot,
> while holding sk_callback_lock. Concurrently, tcp can access it. Usually to
> read out the sk_prot pointer and invoke one of the ops,
> sk->sk_prot->handler().
> 
> The lockless write (lockless in regard to concurrent reads) happens on the
> following paths:
> 
> tcp_bpf_{recvmsg|sendmsg} / sock_map_unref
>   sk_psock_put
>     sk_psock_drop
>       sk_psock_restore_proto
>         WRITE_ONCE(sk->sk_prot, proto)
> 
> To prevent load/store tearing [1], and to make tooling aware of intentional
> shared access [2], we need to annotate sites that access sk_prot with
> READ_ONCE/WRITE_ONCE.
> 
> This series kicks off the effort to do it. Starting with net/tls.
> 
> [0] https://lore.kernel.org/bpf/a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com/
> [1] https://lwn.net/Articles/793253/
> [2] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

Series applied, thank you.
