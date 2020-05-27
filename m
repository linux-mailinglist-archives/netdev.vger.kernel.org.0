Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA51E50F6
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgE0WKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE0WKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:10:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B66C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 15:10:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B61C128CE456;
        Wed, 27 May 2020 15:10:05 -0700 (PDT)
Date:   Wed, 27 May 2020 15:10:04 -0700 (PDT)
Message-Id: <20200527.151004.24719580946330092.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: declare lockless TX feature for slave
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527180805.1245991-1-olteanv@gmail.com>
References: <20200527180805.1245991-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 15:10:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 21:08:05 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Be there a platform with the following layout:
> 
>       Regular NIC
>        |
>        +----> DSA master for switch port
>                |
>                +----> DSA master for another switch port
> 
> After changing DSA back to static lockdep class keys in commit
> 1a33e10e4a95 ("net: partially revert dynamic lockdep key changes"), this
> kernel splat can be seen:
> 
> [   13.361198] ============================================
> [   13.366524] WARNING: possible recursive locking detected
> [   13.371851] 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988 Not tainted
> [   13.377874] --------------------------------------------
> [   13.383201] swapper/0/0 is trying to acquire lock:
> [   13.388004] ffff0000668ff298 (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at: __dev_queue_xmit+0x84c/0xbe0
> [   13.397879]
> [   13.397879] but task is already holding lock:
> [   13.403727] ffff0000661a1698 (&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at: __dev_queue_xmit+0x84c/0xbe0
 ...
> There appears to be no negative side-effect to declaring lockless TX for
> the DSA virtual interfaces, which means they handle their own locking.
> So that's what we do to make the splat go away.
> 
> Patch tested in a wide variety of cases: unicast, multicast, PTP, etc.
> 
> Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
> Suggested-by: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.
