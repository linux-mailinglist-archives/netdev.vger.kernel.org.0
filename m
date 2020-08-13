Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD33243DF6
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMRGU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 13:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 13:06:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F633C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:06:19 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k6GgB-0003Vi-Mf; Thu, 13 Aug 2020 19:06:15 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1k6Gg8-00051Q-A7; Thu, 13 Aug 2020 19:06:12 +0200
Date:   Thu, 13 Aug 2020 19:06:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix kernel-infoleak in
 j1939_sk_sock2sockaddr_can()
Message-ID: <20200813170612.7weopvtaei4pezmx@pengutronix.de>
References: <20200813161834.4021638-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200813161834.4021638-1-edumazet@google.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:00:40 up 272 days,  8:19, 258 users,  load average: 0.12, 0.05,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Aug 13, 2020 at 09:18:34AM -0700, Eric Dumazet wrote:
> syzbot found that at least 2 bytes of kernel information
> were leaked during getsockname() on AF_CAN CAN_J1939 socket.
> 
> Since struct sockaddr_can has in fact two holes, simply
> clear the whole area before filling it with useful data.
> 
> BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
> CPU: 0 PID: 8466 Comm: syz-executor511 Not tainted 5.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x21c/0x280 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
>  kmsan_internal_check_memory+0x238/0x3d0 mm/kmsan/kmsan.c:423
>  kmsan_copy_to_user+0x81/0x90 mm/kmsan/kmsan_hooks.c:253
>  instrument_copy_to_user include/linux/instrumented.h:91 [inline]
>  _copy_to_user+0x18e/0x260 lib/usercopy.c:39
>  copy_to_user include/linux/uaccess.h:186 [inline]
>  move_addr_to_user+0x3de/0x670 net/socket.c:237
>  __sys_getsockname+0x407/0x5e0 net/socket.c:1909
>  __do_sys_getsockname net/socket.c:1920 [inline]
>  __se_sys_getsockname+0x91/0xb0 net/socket.c:1917
>  __x64_sys_getsockname+0x4a/0x70 net/socket.c:1917
>  do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440219
> Code: Bad RIP value.
> RSP: 002b:00007ffe5ee150c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000033
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440219
> RDX: 0000000020000240 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a20
> R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000
> 
> Local variable ----address@__sys_getsockname created at:
>  __sys_getsockname+0x91/0x5e0 net/socket.c:1894
>  __sys_getsockname+0x91/0x5e0 net/socket.c:1894
> 
> Bytes 2-3 of 24 are uninitialized
> Memory access of size 24 starts at ffff8880ba2c7de8
> Data copied to user address 0000000020000100
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Robin van der Gracht <robin@protonic.nl>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: linux-can@vger.kernel.org

Thank you for your patch!
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/socket.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 78ff9b3f1d40c732ba39b2402b5099ba84f8a4a5..3db0973e6d31ddf5267d8c56d3b8cedb800e78fd 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -553,6 +553,11 @@ static int j1939_sk_connect(struct socket *sock, struct sockaddr *uaddr,
>  static void j1939_sk_sock2sockaddr_can(struct sockaddr_can *addr,
>  				       const struct j1939_sock *jsk, int peer)
>  {
> +	/* There are two holes (2 bytes and 3 bytes) to clear to avoid
> +	 * leaking kernel information to user space.
> +	*/
> +	memset(addr, 0, J1939_MIN_NAMELEN);
> +
>  	addr->can_family = AF_CAN;
>  	addr->can_ifindex = jsk->ifindex;
>  	addr->can_addr.j1939.pgn = jsk->addr.pgn;
> -- 
> 2.28.0.220.ged08abb693-goog
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
