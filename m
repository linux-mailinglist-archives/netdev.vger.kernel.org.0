Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E441C9FAC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHA3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgEHA3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:29:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56134C05BD43;
        Thu,  7 May 2020 17:29:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55F941193B1A6;
        Thu,  7 May 2020 17:29:03 -0700 (PDT)
Date:   Thu, 07 May 2020 17:28:33 -0700 (PDT)
Message-Id: <20200507.172833.1823250580053812142.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     kuba@kernel.org, willemb@google.com, martin.varghese@nokia.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: bareudp: avoid uninitialized variable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505172232.1034560-1-arnd@arndb.de>
References: <20200505172232.1034560-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:29:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  5 May 2020 19:22:14 +0200

> clang points out that building without IPv6 would lead to returning
> an uninitialized variable if a packet with family!=AF_INET is
> passed into bareudp_udp_encap_recv():
> 
> drivers/net/bareudp.c:139:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (family == AF_INET)
>             ^~~~~~~~~~~~~~~~~
> drivers/net/bareudp.c:146:15: note: uninitialized use occurs here
>         if (unlikely(err)) {
>                      ^~~
> include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
>  # define unlikely(x)    __builtin_expect(!!(x), 0)
>                                             ^
> drivers/net/bareudp.c:139:2: note: remove the 'if' if its condition is always true
>         if (family == AF_INET)
>         ^~~~~~~~~~~~~~~~~~~~~~
> 
> This cannot happen in practice, so change the condition in a way that
> gcc sees the IPv4 case as unconditionally true here.
> For consistency, change all the similar constructs in this file the
> same way, using "if(IS_ENABLED())" instead of #if IS_ENABLED()".
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
