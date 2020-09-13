Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59999268181
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgIMVjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMVjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:39:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5510AC06174A;
        Sun, 13 Sep 2020 14:39:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFEB41281E8CA;
        Sun, 13 Sep 2020 14:22:53 -0700 (PDT)
Date:   Sun, 13 Sep 2020 14:39:39 -0700 (PDT)
Message-Id: <20200913.143939.859765790019703223.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: fix uninit value error in __sys_sendmmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913110313.4239-1-anant.thazhemadam@gmail.com>
References: <20200913110313.4239-1-anant.thazhemadam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 13 Sep 2020 14:22:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Sun, 13 Sep 2020 16:33:13 +0530

> diff --git a/net/socket.c b/net/socket.c
> index 0c0144604f81..1e6f9b54982c 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2398,6 +2398,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>  	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
>  	ssize_t err;
>  
> +	memset(iov, 0, UIO_FASTIOV);
>  	msg_sys->msg_name = &address;

Did you even test this?

Seriously?

UIO_FASTIOV is the number of entries in 'iovstack', it's not the
size with would be "UIO_FASTIOV * sizeof (struct iovec)", or
even "sizeof(iovstack)"

So could you really explain to me how you tested this patch for
correctness, and for any functional or performance regressions
that may occur?

Because, once you correct that size argument to memset() we will now
have a huge memset() for _EVERY_ _SINGLE_ sendmsg() done by the
system.  And that will cause severe performance regressions for many
workloads involving networking.

This patch submission has been extremely careless on so many levels. I
sincerely wish you would take your time with these changes and not be
so lacking in the areas of testing and validation.

It is always a reg flag when a submitter doesn't even notice an
obvious compiler warning that reviewers like Greg and myself can see
even without trying to build your code changes.

