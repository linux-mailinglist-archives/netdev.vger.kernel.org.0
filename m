Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9328A201
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgJJWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729470AbgJJSo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:44:27 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72855C05BD39;
        Sat, 10 Oct 2020 09:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=MW24HhFwFfGIeQJGLuezuzELB0g5N7HkPqr7uAX0N+s=; b=oScIWqUOiH3J9pqSo9SHSZaKgg
        G9dV+RYanl2AxUqG2llr4HvArk+ueT9cGvrgm3Qkh1pbG+IkGDLOZQCggUtAarBWTjiPYDDi3cCgr
        mPJs8/BlMEL1ucx0YiembjuXBi3e3ZHa4OKjNzTsc2k28FSD9USstIqnzNE+oE3FZbvKTMcAyAVN4
        bSTZwsZ1o1i8ct8E6eujqe2U0GVTJewEeNhJK3TZDoTObSFTsSah9TUMKEPXLWq2xOQ3eyWYkpXJq
        cFhjzoIoFWn+afqvTSG9cgPUg3q4nZ2r9FrZDQyE2T8sVEl/oUAqes3hG9Lb8NaqyG5zZ2ZX5KyJw
        YPQtQWCQ==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRHrD-00024R-2j; Sat, 10 Oct 2020 16:36:31 +0000
Subject: Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>, gregkh@linuxfoundation.org,
        rafael@kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        shakeelb@google.com, will@kernel.org, mhocko@suse.com, guro@fb.com,
        neilb@suse.de, rppt@kernel.org, samitolvanen@google.com,
        kirill.shutemov@linux.intel.com, feng.tang@intel.com,
        pabeni@redhat.com, willemb@google.com, fw@strlen.de,
        gustavoars@kernel.org, pablo@netfilter.org, decui@microsoft.com,
        jakub@cloudflare.com, peterz@infradead.org,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        tglx@linutronix.de, dave@stgolabs.net, walken@google.com,
        jannh@google.com, chenqiwu@xiaomi.com, christophe.leroy@c-s.fr,
        minchan@kernel.org, kafai@fb.com, ast@kernel.org,
        daniel@iogearbox.net, linmiaohe@huawei.com, keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201010103854.66746-1-songmuchun@bytedance.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f6dfa37f-5991-3e96-93b8-737f60128151@infradead.org>
Date:   Sat, 10 Oct 2020 09:36:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201010103854.66746-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/10/20 3:38 AM, Muchun Song wrote:
> The amount of memory allocated to sockets buffer can become significant.
> However, we do not display the amount of memory consumed by sockets
> buffer. In this case, knowing where the memory is consumed by the kernel
> is very difficult. On our server with 500GB RAM, sometimes we can see
> 25GB disappear through /proc/meminfo. After our analysis, we found the
> following memory allocation path which consumes the memory with page_owner
> enabled.
> 
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

Thanks for finding that.

Please update Documentation/filesystems/proc.rst "meminfo" section also.

-- 
~Randy

