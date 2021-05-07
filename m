Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6B376192
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhEGIAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:00:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48312 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhEGIAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:00:31 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0DA646414B;
        Fri,  7 May 2021 09:58:46 +0200 (CEST)
Date:   Fri, 7 May 2021 09:59:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: avoid overflows in
 nft_hash_buckets()
Message-ID: <20210507075928.GA4320@salvia>
References: <20210506125323.3887186-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210506125323.3887186-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 05:53:23AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Number of buckets being stored in 32bit variables, we have to
> ensure that no overflows occur in nft_hash_buckets()
> 
> syzbot injected a size == 0x40000000 and reported:
> 
> UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
> shift exponent 64 is too large for 64-bit type 'long unsigned int'
> CPU: 1 PID: 29539 Comm: syz-executor.4 Not tainted 5.12.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
>  __roundup_pow_of_two include/linux/log2.h:57 [inline]
>  nft_hash_buckets net/netfilter/nft_set_hash.c:411 [inline]
>  nft_hash_estimate.cold+0x19/0x1e net/netfilter/nft_set_hash.c:652
>  nft_select_set_ops net/netfilter/nf_tables_api.c:3586 [inline]
>  nf_tables_newset+0xe62/0x3110 net/netfilter/nf_tables_api.c:4322
>  nfnetlink_rcv_batch+0xa09/0x24b0 net/netfilter/nfnetlink.c:488
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:612 [inline]
>  nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:630
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Applied, thanks.
