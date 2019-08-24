Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9BF9C111
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfHXXu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:50:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbfHXXu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:50:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C2A6152619C6;
        Sat, 24 Aug 2019 16:50:28 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:50:27 -0700 (PDT)
Message-Id: <20190824.165027.77644342474083753.davem@davemloft.net>
To:     john.fastabend@gmail.com
Cc:     sbrivio@redhat.com, dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [net PATCH] net: route dump netlink NLM_F_MULTI flag missing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156660549861.5753.7912871726096518275.stgit@john-XPS-13-9370>
References: <156660549861.5753.7912871726096518275.stgit@john-XPS-13-9370>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:50:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Fri, 23 Aug 2019 17:11:38 -0700

> An excerpt from netlink(7) man page,
> 
>   In multipart messages (multiple nlmsghdr headers with associated payload
>   in one byte stream) the first and all following headers have the
>   NLM_F_MULTI flag set, except for the last  header  which  has the type
>   NLMSG_DONE.
> 
> but, after (ee28906) there is a missing NLM_F_MULTI flag in the middle of a
> FIB dump. The result is user space applications following above man page
> excerpt may get confused and may stop parsing msg believing something went
> wrong.
> 
> In the golang netlink lib [0] the library logic stops parsing believing the
> message is not a multipart message. Found this running Cilium[1] against
> net-next while adding a feature to auto-detect routes. I noticed with
> multiple route tables we no longer could detect the default routes on net
> tree kernels because the library logic was not returning them.
> 
> Fix this by handling the fib_dump_info_fnhe() case the same way the
> fib_dump_info() handles it by passing the flags argument through the
> call chain and adding a flags argument to rt_fill_info().
> 
> Tested with Cilium stack and auto-detection of routes works again. Also
> annotated libs to dump netlink msgs and inspected NLM_F_MULTI and
> NLMSG_DONE flags look correct after this.
> 
> Note: In inet_rtm_getroute() pass rt_fill_info() '0' for flags the same
> as is done for fib_dump_info() so this looks correct to me.
> 
> [0] https://github.com/vishvananda/netlink/
> [1] https://github.com/cilium/
> 
> Fixes: ee28906fd7a14 ("ipv4: Dump route exceptions if requested")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks John.

