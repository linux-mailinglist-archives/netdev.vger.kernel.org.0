Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBBD1C9FAE
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEHAaG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 May 2020 20:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgEHAaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:30:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586ABC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:30:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9EC61193B1AA;
        Thu,  7 May 2020 17:30:05 -0700 (PDT)
Date:   Thu, 07 May 2020 17:30:04 -0700 (PDT)
Message-Id: <20200507.173004.1881498730999455740.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, lucien.xin@gmail.com,
        hannes@stressinduktion.org
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in
 __ip6_rt_update_pmtu"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505185723.191944-1-zenczykowski@gmail.com>
References: <20200505185723.191944-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:30:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue,  5 May 2020 11:57:23 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> This reverts commit 19bda36c4299ce3d7e5bce10bebe01764a655a6d:
> 
> | ipv6: add mtu lock check in __ip6_rt_update_pmtu
> |
> | Prior to this patch, ipv6 didn't do mtu lock check in ip6_update_pmtu.
> | It leaded to that mtu lock doesn't really work when receiving the pkt
> | of ICMPV6_PKT_TOOBIG.
> |
> | This patch is to add mtu lock check in __ip6_rt_update_pmtu just as ipv4
> | did in __ip_rt_update_pmtu.
> 
> The above reasoning is incorrect.  IPv6 *requires* icmp based pmtu to work.
> There's already a comment to this effect elsewhere in the kernel:
> 
>   $ git grep -p -B1 -A3 'RTAX_MTU lock'
>   net/ipv6/route.c=4813=
> 
>   static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
>   ...
>     /* In IPv6 pmtu discovery is not optional,
>        so that RTAX_MTU lock cannot disable it.
>        We still use this lock to block changes
>        caused by addrconf/ndisc.
>     */
> 
> This reverts to the pre-4.9 behaviour.
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>
> Fixes: 19bda36c4299 ("ipv6: add mtu lock check in __ip6_rt_update_pmtu")

I've thought about this some more and decided to apply this and
queue it up for -stable, thank you.
