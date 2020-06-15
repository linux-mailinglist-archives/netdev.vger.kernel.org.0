Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16A1FA17B
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgFOUaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFOUaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:30:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF18EC061A0E;
        Mon, 15 Jun 2020 13:30:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D07A120ED49A;
        Mon, 15 Jun 2020 13:30:17 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:30:17 -0700 (PDT)
Message-Id: <20200615.133017.143361546049495568.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        liuhangbin@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mld: fix memory leak in ipv6_mc_destroy_dev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611075750.18545-1-wanghai38@huawei.com>
References: <20200611075750.18545-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:30:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Thu, 11 Jun 2020 15:57:50 +0800

> Commit a84d01647989 ("mld: fix memory leak in mld_del_delrec()") fixed
> the memory leak of MLD, but missing the ipv6_mc_destroy_dev() path, in
> which mca_sources are leaked after ma_put().
> 
> Using ip6_mc_clear_src() to take care of the missing free.
> 
> BUG: memory leak
> unreferenced object 0xffff8881113d3180 (size 64):
>   comm "syz-executor071", pid 389, jiffies 4294887985 (age 17.943s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000002cbc483c>] kmalloc include/linux/slab.h:555 [inline]
>     [<000000002cbc483c>] kzalloc include/linux/slab.h:669 [inline]
>     [<000000002cbc483c>] ip6_mc_add1_src net/ipv6/mcast.c:2237 [inline]
>     [<000000002cbc483c>] ip6_mc_add_src+0x7f5/0xbb0 net/ipv6/mcast.c:2357
>     [<0000000058b8b1ff>] ip6_mc_source+0xe0c/0x1530 net/ipv6/mcast.c:449
>     [<000000000bfc4fb5>] do_ipv6_setsockopt.isra.12+0x1b2c/0x3b30 net/ipv6/ipv6_sockglue.c:754
>     [<00000000e4e7a722>] ipv6_setsockopt+0xda/0x150 net/ipv6/ipv6_sockglue.c:950
>     [<0000000029260d9a>] rawv6_setsockopt+0x45/0x100 net/ipv6/raw.c:1081
>     [<000000005c1b46f9>] __sys_setsockopt+0x131/0x210 net/socket.c:2132
>     [<000000008491f7db>] __do_sys_setsockopt net/socket.c:2148 [inline]
>     [<000000008491f7db>] __se_sys_setsockopt net/socket.c:2145 [inline]
>     [<000000008491f7db>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
>     [<00000000c7bc11c5>] do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295
>     [<000000005fb7a3f3>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied and queued up for -stable, thank you.
