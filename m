Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82818155D1E
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBGRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:44:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgBGRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:44:37 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3578115B2628F;
        Fri,  7 Feb 2020 09:44:36 -0800 (PST)
Date:   Fri, 07 Feb 2020 18:44:31 +0100 (CET)
Message-Id: <20200207.184431.2155720023651613268.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, maximmi@mellanox.com
Subject: Re: [PATCH v2 net] ipv6/addrconf: fix potential NULL deref in
 inet6_set_link_af()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207151637.65999-1-edumazet@google.com>
References: <20200207151637.65999-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 09:44:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  7 Feb 2020 07:16:37 -0800

> __in6_dev_get(dev) called from inet6_set_link_af() can return NULL.
> 
> The needed check has been recently removed, let's add it back.
> 
> While do_setlink() does call validate_linkmsg() :
> ...
> err = validate_linkmsg(dev, tb); /* OK at this point */
> ...
> 
> It is possible that the following call happening before the
> ->set_link_af() removes IPv6 if MTU is less than 1280 :
> 
> if (tb[IFLA_MTU]) {
>     err = dev_set_mtu_ext(dev, nla_get_u32(tb[IFLA_MTU]), extack);
>     if (err < 0)
>           goto errout;
>     status |= DO_SETLINK_MODIFIED;
> }
> ...
> 
> if (tb[IFLA_AF_SPEC]) {
>    ...
>    err = af_ops->set_link_af(dev, af);
>       ->inet6_set_link_af() // CRASH because idev is NULL
 ...
> Fixes: 7dc2bccab0ee ("Validate required parameters in inet6_validate_link_af")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Bisected-and-reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied and queued up for -stable, thanks Eric.
