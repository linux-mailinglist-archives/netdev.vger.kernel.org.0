Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EDC28A7A2
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387943AbgJKNxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 09:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387885AbgJKNxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 09:53:02 -0400
Received: from kernel.org (unknown [87.71.73.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D931A20781;
        Sun, 11 Oct 2020 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602424381;
        bh=2Z3/Dy7FEwrXfEg2TjMmQHOqWceXblc0T+c5Wxpj1U8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UAw/nF8aokc1l4l36U/F7cHL2FRVa52GO2I1c+bjqrpYD6A4QERDCFghM+VOvbFg/
         2IfNrSJOcz5zaPQKqECb88Gc7lvuqurNhQGFphzM87mvTDm6p38Ze7ofZr56Gqv7II
         hpuOunWqeWcakghdfenflbfcBgmRzso0JM6XKOJA=
Date:   Sun, 11 Oct 2020 16:52:44 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        shakeelb@google.com, will@kernel.org, mhocko@suse.com, guro@fb.com,
        neilb@suse.de, samitolvanen@google.com,
        kirill.shutemov@linux.intel.com, feng.tang@intel.com,
        pabeni@redhat.com, willemb@google.com, rdunlap@infradead.org,
        fw@strlen.de, gustavoars@kernel.org, pablo@netfilter.org,
        decui@microsoft.com, jakub@cloudflare.com, peterz@infradead.org,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        tglx@linutronix.de, dave@stgolabs.net, walken@google.com,
        jannh@google.com, chenqiwu@xiaomi.com, christophe.leroy@c-s.fr,
        minchan@kernel.org, kafai@fb.com, ast@kernel.org,
        daniel@iogearbox.net, linmiaohe@huawei.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: proc: add Sock to /proc/meminfo
Message-ID: <20201011135244.GC4251@kernel.org>
References: <20201010103854.66746-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010103854.66746-1-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 06:38:54PM +0800, Muchun Song wrote:
> The amount of memory allocated to sockets buffer can become significant.
> However, we do not display the amount of memory consumed by sockets
> buffer. In this case, knowing where the memory is consumed by the kernel
> is very difficult. On our server with 500GB RAM, sometimes we can see
> 25GB disappear through /proc/meminfo. After our analysis, we found the
> following memory allocation path which consumes the memory with page_owner
> enabled.
 
I have a high lelel question.
There is accounting of the socket memory for memcg that gets called from
the networking layer. Did you check if the same call sites can be used
for the system-wide accounting as well?

>   849698 times:
>   Page allocated via order 3, mask 0x4052c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP)
>    __alloc_pages_nodemask+0x11d/0x290
>    skb_page_frag_refill+0x68/0xf0
>    sk_page_frag_refill+0x19/0x70
>    tcp_sendmsg_locked+0x2f4/0xd10
>    tcp_sendmsg+0x29/0xa0
>    sock_sendmsg+0x30/0x40
>    sock_write_iter+0x8f/0x100
>    __vfs_write+0x10b/0x190
>    vfs_write+0xb0/0x190
>    ksys_write+0x5a/0xd0
>    do_syscall_64+0x5d/0x110
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/base/node.c      |  2 ++
>  drivers/net/virtio_net.c |  3 +--

Is virtio-net the only dirver that requred an update?

>  fs/proc/meminfo.c        |  1 +
>  include/linux/mmzone.h   |  1 +
>  include/linux/skbuff.h   | 43 ++++++++++++++++++++++++++++++++++++++--
>  kernel/exit.c            |  3 +--
>  mm/page_alloc.c          |  7 +++++--
>  mm/vmstat.c              |  1 +
>  net/core/sock.c          |  8 ++++----
>  net/ipv4/tcp.c           |  3 +--
>  net/xfrm/xfrm_state.c    |  3 +--
>  11 files changed, 59 insertions(+), 16 deletions(-)
> 
