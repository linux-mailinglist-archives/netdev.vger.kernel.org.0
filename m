Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4CB2F8AAC
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbhAPCJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbhAPCJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:09:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8926208A9;
        Sat, 16 Jan 2021 02:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762921;
        bh=ALswOCpvgo+akRSqafcaTMBLLSuFqHv6lDRV9pDMPhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZKFre56usaX3XjUKf5ELKEGvuswOdMw6DmodcntI0gaW2gfTqa+4vuU+y3heub1oW
         vIZd6sEBNInGx/cy3Cd7/1ZeI6h5SwMXhgIe3gftw3+BHmAi3lnHBRKJiTWOSbgawS
         LipVKIMEpStNJ4OpNNHraadTiWg3yxnIwca0fNIqs8tZwC86E90moywMGOityN9TYW
         b92HsUQJkU2qmYxYtoW85ptv+1G0g9X7JroBID5/onNa7T8geHrUGUtwFHsXgqq9ik
         IOSVO6gCGBmwQjoZ0Ma07zE5sIuyTM9x8O5/UY4gYW0OgfCdRxxxsNScKHheMePrPC
         Ik3K1mDig1uBw==
Date:   Fri, 15 Jan 2021 18:08:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net_sched: reject silly cell_log in
 qdisc_get_rtab()
Message-ID: <20210115180839.725064b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpVspkx5Sao8DxFiJFV0Y80J1RdTSevSbzQ9FuZ-xTVbbg@mail.gmail.com>
References: <20210114160637.1660597-1-eric.dumazet@gmail.com>
        <CAM_iQpVspkx5Sao8DxFiJFV0Y80J1RdTSevSbzQ9FuZ-xTVbbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 10:03:39 -0800 Cong Wang wrote:
> On Thu, Jan 14, 2021 at 8:06 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > iproute2 probably never goes beyond 8 for the cell exponent,
> > but stick to the max shift exponent for signed 32bit.
> >
> > UBSAN reported:
> > UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
> > shift exponent 130 is too large for 32-bit type 'int'
> > CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0x183/0x22e lib/dump_stack.c:120
> >  ubsan_epilogue lib/ubsan.c:148 [inline]
> >  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
> >  __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
> >  qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
> >  cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
> >  qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
> >  tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
> >  rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
> >  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
> >  netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
> >  netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg net/socket.c:672 [inline]
> >  ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
> >  ___sys_sendmsg net/socket.c:2399 [inline]
> >  __sys_sendmsg+0x319/0x400 net/socket.c:2432
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>  
> 
> Acked-by: Cong Wang <cong.wang@bytedance.com>

Applied, thanks!
