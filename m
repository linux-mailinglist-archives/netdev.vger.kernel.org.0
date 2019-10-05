Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D36CC719
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfJEBJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:09:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:09:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37A2F14F35C4F;
        Fri,  4 Oct 2019 18:09:56 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:09:55 -0700 (PDT)
Message-Id: <20191004.180955.417634868451201113.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        rajendra.dendukuri@broadcom.com, eric.dumazet@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: Handle missing host route in
 __ipv6_ifa_notify
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004150309.4715-1-dsahern@kernel.org>
References: <20191004150309.4715-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:09:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri,  4 Oct 2019 08:03:09 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Rajendra reported a kernel panic when a link was taken down:
> 
>     [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>     [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
> 
>     <snip>
> 
>     [ 6870.570501] Call Trace:
>     [ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
>     [ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
>     [ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
>     [ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
>     [ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
>     [ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
>     [ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
>     [ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
>     [ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
>     [ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
>     [ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
>     [ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
>     [ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0
> 
> addrconf_dad_work is kicked to be scheduled when a device is brought
> up. There is a race between addrcond_dad_work getting scheduled and
> taking the rtnl lock and a process taking the link down (under rtnl).
> The latter removes the host route from the inet6_addr as part of
> addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
> to use the host route in __ipv6_ifa_notify. If the down event removes
> the host route due to the race to the rtnl, then the BUG listed above
> occurs.
> 
> Since the DAD sequence can not be aborted, add a check for the missing
> host route in __ipv6_ifa_notify. The only way this should happen is due
> to the previously mentioned race. The host route is created when the
> address is added to an interface; it is only removed on a down event
> where the address is kept. Add a warning if the host route is missing
> AND the device is up; this is a situation that should never happen.
> 
> Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
> Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.
